---@class CPackage
---@field private path './?.lua;./?/init.lua;./?/shared/import.lua;./?/shared.lua;./?/server.lua;./?/client.lua'
---@field private preload {[string]: function}
---@field private loaded {env: table}
---@field private packages {[string]: {env: table, contents: function|{[string]: function}, exported: function|{[string]: function}}}
---@field private curr_pkg string
---@field private searchers (fun(mod_name: string, env: table?): function|{[string]: function}|false, string)[] -- Returns the module if it was found and loaded, and the name of the module.
---@field searchpath fun(mod_name: string, pattern: string?): string, string? -- Returns the path to the module, and an error message if the module was not found. <br> This function is based on the Lua [`package.searchpath`](https://github.com/lua/lua/blob/c1dc08e8e8e22af9902a6341b4a9a9a7811954cc/loadlib.c#L474), [Lua Modules Loader](http://lua-users.org/wiki/LuaModulesLoader) by @lua-users & ox_lib's [`package.searchpath`](https://github.com/overextended/ox_lib/blob/cdf840fc68ace1f4befc78555a7f4f59d2c4d020/imports/require/shared.lua#L50).
---@field require fun(mod_name: string): function|{[string]: function} -- Returns the module if it was found and loaded. <br> `mod_name` has to be a dot-separated path to the module. <br> For example, `duff.import`.
---@field import fun(sym: string, methods: string[]?): function|{[string]: function}? -- Imports a lua file's methods into the global environment. <br> If the file is a module, it returns the module and imports `methods` (if provided) or the module into the global environment.
---@field as fun(name: string) -- Changes the imported module's name to the provided name.
do
  local curr_res = GetCurrentResourceName()
  local debug_mode = duff?._DEBUG or GetResourceMetadata('duff', 'debug_mode', 0) == 'true'
  local _require = require
  ---@type {[string]: {env: table, contents: function|{[string]: function}, exported: function|{[string]: function}}}
  local packages = {}
  local curr_pkg = ''

  local package = {
    path = './?.lua;./?/init.lua;./?/shared/import.lua;./?/shared.lua;./?/server.lua;./?/client.lua',
    preload = {},
    loaded = {env = setmetatable({}, {__index = packages})}
  }

  ---@param mod_name string The name of the module to search for. <br> This has to be a dot-separated path to the module. <br> For example, `duff.import`.
  ---@param pattern string? A pattern to search for the module. <br> This has to be a string with a semicolon-separated list of paths. <br> For example, `./?.lua;./?/init.lua`.
  ---@return string mod_path, string? errmsg The path to the module, and an error message if the module was not found.
  local function search_path(mod_name, pattern) -- Based on the Lua [`package.searchpath`](https://github.com/lua/lua/blob/c1dc08e8e8e22af9902a6341b4a9a9a7811954cc/loadlib.c#L474) function, [Lua Modules Loader](http://lua-users.org/wiki/LuaModulesLoader) by @lua-users & ox_lib's [`package.searchpath`](https://github.com/overextended/ox_lib/blob/cdf840fc68ace1f4befc78555a7f4f59d2c4d020/imports/require/shared.lua#L50) function.
    if type(mod_name) ~= 'string' then error('bad argument #1 to \'search_path\' (string expected, got '..type(mod_name)..')', 2) end
    local mod_path = mod_name:gsub('%.', '/')
    local resource, path, contents = '', '', ''
    local errmsg = nil
    pattern = pattern or package.path
    for subpath in pattern:gmatch('[^;]+') do
      local file = subpath:gsub('%?', mod_path)
      resource, path = file:match('^./%@?(%w+%_?%w+)'), file:match('^./%@?%w+%_?%w+(.*)')
      contents = LoadResourceFile(resource, path)
      if contents then
        local module, err = load(contents, '@@'..resource..'/'..path, 'bt', _ENV)
        if module then
          mod_path = resource..path:gsub('%/', '.'):gsub('.lua', '')
          package.preload[mod_path] = function(env)
            packages[mod_path] = packages[mod_path] or {}
            packages[mod_path].env = setmetatable({}, {__index = env or _ENV})
            packages[mod_path].contents = module
            if debug_mode then print('^3[duff]^7 - ^2loaded module^7 ^5\''..mod_path..'\'^7') end
            return packages[mod_path].contents()
          end
          break
        end
        errmsg = (errmsg or '')..(err and '\n\t'..err or '')
      end
    end
    return package.preload[mod_path] and mod_path or false, errmsg
  end

  local searchers = {
    ---@param mod_name string
    ---@return function|{[string]: function}|false result, string errmsg
    function(mod_name)
      local success, contents = pcall(_require, mod_name)
      if success then return contents, mod_name end
      return false, contents
    end,
    ---@param mod_name string
    ---@param env table
    ---@return function|{[string]: function}|false result, string errmsg
    function(mod_name, env)
      if package.preload[mod_name] then return package.preload[mod_name](env), mod_name end
      return false, 'module \''..mod_name..'\' not found'
    end,
    ---@param mod_name string
    ---@param env table
    ---@return function|{[string]: function}|false result, string errmsg
    function(mod_name, env)
      local mod_path, err = search_path(mod_name)
      if mod_path and not err then return package.preload[mod_path] and package.preload[mod_path](env), mod_path end
      return false, 'module \''..mod_name..'\' not found'..(err and '\n\t'..err or '')
    end
  }

  ---@param mod_name string The name of the module to require. <br> This has to be a dot-separated path to the module. <br> For example, `duff.import`.
  ---@return function|{[string]: function}? module Returns the module if it was found and loaded.
  local function require(mod_name)
    if type(mod_name) ~= 'string' then error('bad argument #1 to \'require\' (string expected, got '..type(mod_name)..')', 2) end
    local errmsg = 'bad argument #1 to \'require\' (module \''..mod_name..'\' not found)'
    local module = packages[mod_name]?.exported
    if module ~= nil then return module end
    for i = 1, #searchers do
      local result, err = searchers[i](mod_name)
      if result then
        curr_pkg = err
        packages[curr_pkg].exported = result
        return packages[curr_pkg].exported
      elseif err then
        errmsg = errmsg..'\n\t'..err
      end
    end
    error(errmsg, 2)
  end

  ---@param mod_name string  The name of the module to import. <br> This has to be a dot-separated path to the module. <br> For example, `duff.import`.
  ---@param methods string[]? A list of methods to import from the module.
  local function import(mod_name, methods) -- Imports a lua file's methods into the global environment. <br> If the file is a module, it returns the module and imports `methods` (if provided) or the module into the global environment.
    if type(mod_name) ~= 'string' then error('bad argument #1 to \'import\' (string expected, got '..type(mod_name)..')', 2) end
    local module, errmsg = nil, nil
    for i = 2, #searchers do
      ---@diagnostic disable-next-line: redundant-parameter
      module, errmsg = searchers[i](mod_name, _G)
      if module ~= false then mod_name = errmsg; errmsg = nil break end
    end
    if module == false then error('bad argument #1 to \'import\' (module \''..mod_name..'\' not found)\n\t'..errmsg, 2) end
    curr_pkg = mod_name
    if module then
      local mod_type = type(module)
      if not methods or mod_type == 'function' then
        packages[mod_name].exported = module
      elseif mod_type == 'table' then
        local exports = {}
        for i = 1, #methods do
          for k, v in pairs(module) do
            if k == methods[i] then
              exports[k] = v
            end
          end
        end
        packages[mod_name].exported = exports
        for k, v in pairs(exports) do _G[k] = v end
      end
      return packages[mod_name]?.exported
    end
  end

  ---@param name string The name to assign the module to.
  local function as(name) -- Changes the imported module's name to the provided name.
    if not curr_pkg then error('no package loaded', 2) end
    local module = packages[curr_pkg].exported
    if not module then error('module \''..curr_pkg..'\' not loaded', 2) end
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

  return {searchpath = search_path, require = require, import = import, as = as}
end