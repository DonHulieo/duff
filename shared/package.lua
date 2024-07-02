---@class module<T>: {[string]: function}
---@class CPackage
---@field private curr_pkg string
---@field path './?.lua;./?/init.lua;./?/shared/import.lua;'
---@field preload {[string]: fun(env: table?): module|function} -- Returns the module if it was found and loaded.
---@field loaded {[string]: {env: table, contents: (fun(): module|function), exported: module|function}} -- Returns the module if it was found and loaded.
---@field loaders (fun(mod_name: string, env: table?): module|function|false, string)[] -- Returns the module if it was found and loaded, and the name of the module.
---@field searchpath fun(mod_name: string, pattern: string?): string|false, string? -- Returns the path to the module, and an error message if the module was not found. <br> This function is based on the Lua [`package.searchpath`](https://github.com/lua/lua/blob/c1dc08e8e8e22af9902a6341b4a9a9a7811954cc/loadlib.c#L474), [Lua Modules Loader](http://lua-users.org/wiki/LuaModulesLoader) by @lua-users & ox_lib's [`package.searchpath`](https://github.com/overextended/ox_lib/blob/cdf840fc68ace1f4befc78555a7f4f59d2c4d020/imports/require/shared.lua#L50).
---@field require fun(mod_name: string): module|function|table -- Returns the module if it was found and could be loaded. <br> `mod_name` needs to be a dot seperated path from resource to module. <br> Credits to [Lua Modules Loader](http://lua-users.org/wiki/LuaModulesLoader) by @lua-users & ox_lib's [`require`](https://github.com/overextended/ox_lib/blob/cdf840fc68ace1f4befc78555a7f4f59d2c4d020/imports/require/shared.lua#L149).
---@field import fun(sym: string, methods: string[]?): module|function|table? -- Imports a lua file's methods into the global environment. <br> `sym` has to be a dot-separated path to the module. <br> For example, `duff.import`.
---@field as fun(name: string) -- Changes the imported module's name to the provided name.
do
  local curr_res = GetCurrentResourceName()
  local get_res_state = GetResourceState
  local debug_mode = duff?._DEBUG or GetResourceMetadata('duff', 'debug_mode', 0) == 'true'
  local _require = require
  ---@type {[string]: {env: table, contents: (fun(): module|function), exported: module|function}}
  local packages = {}
  local path = './?.lua;./?/init.lua;./?/shared/import.lua'
  local preload = {}
  local loaded = setmetatable({}, {__index = packages})
  local curr_pkg = ''

  local function does_res_exist(res_name)
    local state = get_res_state(res_name)
    return state == 'started' or state == 'starting'
  end

  ---@param fn function
  ---@param env table
  ---@return function
  local function setfenv(fn, env)
    local i = 1
    local name = debug.getupvalue(fn, i)
    while name do
      if name == '_ENV' then debug.upvaluejoin(fn, i, (function() return env end), 1) break end
      i += 1
      name = debug.getupvalue(fn, i)
    end
    return fn
  end

  ---@param mod_name string The name of the module to search for. <br> This has to be a dot-separated path to the module. <br> For example, `duff.import`.
  ---@param pattern string? A pattern to search for the module. <br> This has to be a string with a semicolon-separated list of paths. <br> For example, `./?.lua;./?/init.lua`.
  ---@return string mod_path, string? errmsg The path to the module, and an error message if the module was not found.
  local function search_path(mod_name, pattern) -- Based on the Lua [`package.searchpath`](https://github.com/lua/lua/blob/c1dc08e8e8e22af9902a6341b4a9a9a7811954cc/loadlib.c#L474) function, [Lua Modules Loader](http://lua-users.org/wiki/LuaModulesLoader) by @lua-users & ox_lib's [`package.searchpath`](https://github.com/overextended/ox_lib/blob/cdf840fc68ace1f4befc78555a7f4f59d2c4d020/imports/require/shared.lua#L50) function.
    if type(mod_name) ~= 'string' then error('bad argument #1 to \'search_path\' (string expected, got '..type(mod_name)..')', 2) end
    local mod_path = mod_name:gsub('%.', '/')
    local resource, dir, contents = mod_name:match('^%@?(%w+%_?%-?%w+)'), '', ''
    local errmsg = nil
    pattern = pattern or path
    if not does_res_exist(resource) then resource = curr_res; mod_path = curr_res..'/'..mod_path end
    for subpath in pattern:gmatch('[^;]+') do
      local file = subpath:gsub('%?', mod_path)
      dir = file:match('^./%@?%w+%_?%-?%w+(.*)')
      mod_name = resource..dir:gsub('%/', '.'):gsub('.lua', '') --[[@as string]]
      if preload[mod_name] then return mod_name end
      contents = LoadResourceFile(resource, dir)
      if contents then
        local module_fn, err = load(contents, '@@'..resource..'/'..dir, 't', _ENV)
        if module_fn then
          preload[mod_name] = function(env)
            packages[mod_name] = packages[mod_name] or {}
            packages[mod_name].env = env or _ENV
            packages[mod_name].contents = env and setfenv(module_fn, env) or module_fn
            if debug_mode then print('^3[duff]^7 - ^2loaded module^7 ^5\''..mod_name..'\'^7') end
            return packages[mod_name].contents()
          end
          break
        end
        errmsg = (errmsg or '')..(err and '\n\t'..err or '')
      end
    end
    return preload[mod_name] and mod_name or false, errmsg
  end

  ---@type (fun(mod_name: string, env: table?): module|function|false, string)[]
  local loaders = {
    ---@param mod_name string
    ---@return module|function|table|false result, string errmsg
    function(mod_name)
      local success, contents = pcall(_require, mod_name)
      if success then return contents, mod_name end
      return false, contents
    end,
    ---@param mod_name string
    ---@param env table?
    ---@return module|function|table|false result, string errmsg
    function(mod_name, env)
      local package = packages[mod_name]
      if preload[mod_name] and env and env ~= package?.env then return preload[mod_name](env), mod_name end
      return false, 'module \''..mod_name..'\' not found'
    end,
    ---@param mod_name string
    ---@param env table?
    ---@return module|function|table|false result, string errmsg
    function(mod_name, env)
      local mod_path, err = search_path(mod_name)
      if mod_path and not err then
        local package = packages[mod_path]
        if package and (not env or package.env == env) then return package.exported, mod_path end
        return preload[mod_path] and preload[mod_path](env), mod_path
      end
      return false, 'module \''..mod_name..'\' not found'..(err and '\n\t'..err or '')
    end
  }

  ---@param mod_name string The name of the module to load. <br> This has to be a dot-separated path to the module. <br> For example, `duff.import`.
  ---@param env table? The environment to load the module into.
  ---@return module|function|table|false result, string errmsg
  local function load_module(mod_name, env)
    local errmsg = ''
    for i = 1, #loaders do
      local result, err = loaders[i](mod_name, env)
      if result ~= false then
        curr_pkg = err
        packages[curr_pkg].exported = result or result == nil
        return packages[curr_pkg].exported, curr_pkg
      end
      errmsg = errmsg..'\n\t'..err
    end
    return false, errmsg
  end

  ---@param mod_name string The name of the module to require. <br> This has to be a dot-separated path to the module. <br> For example, `duff.import`.
  ---@return module|function|table module Returns `module` if the file is a module or function.
  local function require(mod_name) -- Returns the module if it was found and could be loaded. <br> `mod_name` needs to be a dot seperated path from resource to module. <br> Credits to [Lua Modules Loader](http://lua-users.org/wiki/LuaModulesLoader) by @lua-users & ox_lib's [`require`](https://github.com/overextended/ox_lib/blob/cdf840fc68ace1f4befc78555a7f4f59d2c4d020/imports/require/shared.lua#L149).
    if type(mod_name) ~= 'string' then error('bad argument #1 to \'require\' (string expected, got '..type(mod_name)..')', 2) end
    local errmsg = 'bad argument #1 to \'require\' (module \''..mod_name..'\' not found)'
    if packages[mod_name] then return packages[mod_name].exported end
    local result, err = load_module(mod_name)
    if result then return result end
    error(errmsg..'\n\t'..err, 2)
  end

  ---@param mod_name string  The name of the module to import. <br> This has to be a dot-separated path to the module. <br> For example, `duff.import`.
  ---@param methods string[]? A list of methods to import to the global environment.
  ---@return module|function|table? module Returns `module` if the file is a module or function.
  local function import(mod_name, methods) -- Imports a lua file's methods into the global environment.
    if type(mod_name) ~= 'string' then error('bad argument #1 to \'import\' (string expected, got '..type(mod_name)..')', 2) end
    local module = packages[mod_name]?.exported
    if not module then
      local result, err = load_module(mod_name)
      if result then module = result else error('bad argument #1 to \'import\' (module \''..mod_name..'\' not found)\n\t'..err, 2) end
    end
    if module then
      local mod_type = type(module)
      if not methods or mod_type == 'function' then
        packages[curr_pkg].exported = module
        _G[curr_pkg] = module
      elseif mod_type == 'table' then
        local exports = {}
        for i = 1, #methods do
          local name = methods[i]
          local method = module[name]
          if not method then warn('method \''..name..'\' not found in module \''..curr_pkg..'\'') end
          exports[name] = method
          _G[name] = method
        end
        packages[curr_pkg].exported = exports
      end
      return packages[curr_pkg].exported
    end
  end

  ---@param name string The name to assign the module to.
  local function as(name) -- Changes the imported module's name to the provided name.
    if not curr_pkg or curr_pkg == '' then error('no package loaded', 2) end
    local module = packages[curr_pkg].exported
    if not module then error('package \''..curr_pkg..'\' doesn\'t return a module', 2) end
    local mod_type = type(module)
    if mod_type == 'function' then
      _G[name] = module
    elseif mod_type == 'table' then
      _G[name] = {}
      for k, v in pairs(module) do
        _G[name][k] = v
        _G[k] = nil
      end
    end
  end

  return {path = path, preload = preload, loaded = loaded, loaders = loaders, searchpath = search_path, require = require, import = import, as = as}
end