local get_res_meta = GetResourceMetadata
local get_invoking_res = GetInvokingResource
local is_server = IsDuplicityVersion() == 1

-- msgpack.setoption('with_hole', true) -- If a func has nil return values, this allows any leading nils to be preserved in the return values.

-- ---@param success boolean
-- ---@param ... any
-- ---@return ...
-- local function helper(success, ...)
--   if not success then error(..., 0) end
--   return ...
-- end

-- ---@param file string The name of the file that the function is in.
-- ---@param name string The name of the function.
-- ---@param fn function The function to protect.
-- ---@return function protected_fn The protected function.
-- local function protect(file, name, fn) -- Wraps a function with error handling and stack trace printing. <br> [Lua: How to call error without stack trace](https://stackoverflow.com/questions/20547499/lua-how-to-call-error-without-stack-trace?rq=3) <br> [FinalizedExceptions](http://lua-users.org/wiki/FinalizedExceptions) <br> [Lua: How to get true stack trace of an error in pcall](https://stackoverflow.com/questions/45788739/get-true-stack-trace-of-an-error-in-lua-pcall)
--   return function(...)
--     return helper(xpcall(fn, function(err)
--       err = '@'..file..'.lua:'..debug.getinfo(fn, 'S').linedefined..': '..string.format(err, name)
--       local trace = debug.traceback(nil, 3):sub(17):gsub('\t', '')
--       local index = trace:find('%[C%]: in function')
--       return index and err..trace:sub(1, index - 4) or trace or err
--     end, ...))
--   end
-- end

-- -- ---@param file string
-- -- ---@param name string
-- -- ---@param fn function
-- -- ---@return function
-- -- local function protect(file, name, fn) -- testing coroutine protection, and error handling | https://stackoverflow.com/questions/45788739/get-true-stack-trace-of-an-error-in-lua-pcall
-- --   local co = coroutine.create(fn)
-- --   return function(...)
-- --     if coroutine.status(co) == 'dead' then co = coroutine.create(fn) end
-- --     local results = {coroutine.resume(co, ...)}
-- --     local success, err = results[1], results[2]
-- --     if not success then print('^1SCRIPT ERROR: ' ..debug.traceback(co, ' @'..file..'.lua:'..debug.getinfo(fn, 'S').linedefined..': '..string.format(err, name), 1)..'^7') end
-- --     return select(2, unpack(results))
-- --   end
-- -- end

-- ---@param module {[string]: any}
-- ---@return {[string]: any} module
-- local function protect_module(file, module)
--   for k, v in pairs(module) do
--     if type(v) == 'function' then
--       module[k] = protect(file, k, v)
--     elseif type(v) == 'table' then
--       module[k] = protect_module(file, v)
--     end
--   end
--   return module
-- end

-- ---@param name string @The name of the module to require. This can be a path, or a module name. If a path is provided, it must be relative to the resource root.
-- ---@return {[string]: any}|function module
-- function require(name)
--   local param_type = type(name)
--   if param_type ~= 'string' then error('bad argument #1 to \'require\' (string expected, got '..param_type..')', 2) end
--   local path, parts = find_path(name)
--   if not path or not parts then error('bad argument #1 to \'require\' (invalid path)', 2) end
--   if package.loaded[path] then return package.loaded[path] end
--   if not package.preload[path] then error('bad argument #1 to \'require\' (no file found)', 2) end
--   local loaded, module = pcall(package.preload[path])
--   if not loaded then error('bad argument #1 to \'require\' (error loading file) \n'..module, 2) end
--   module = package.preload[path]()
--   local mod_type = type(module)
--   if mod_type ~= 'table' and mod_type ~= 'function' then error('bad argument #1 to \'require\' (table or function expected, got '..mod_type..')', 2) end
--   package.loaded[name] = mod_type == 'table' and protect_module(path, module) or protect(path, parts[2], module)
--   return package.loaded[name]
-- end

---@param resource string?
---@param version string?
---@param git string?
---@param repo string?
---@return promise? version_check @A promise that resolves with the resource and version if an update is available, or rejects with an error message.
local function check_resource_version(resource, version, git, repo)
  if not is_server then return end
  resource = resource or get_invoking_res()
  version = version or get_res_meta(resource, 'version', 0)
  local version_check = promise.new()
  if not version then version_check:reject(('^1Unable to determine current resource version for `%s` ^0'):format(resource)) return version_check end
  version = version:match('%d+%.%d+%.%d+')
  PerformHttpRequest(('https://api.github.com/repos/%s/%s/releases/latest'):format(git, repo or resource), function(status, response)
    local reject = ('^1Unable to check for updates for `%s` ^0'):format(resource)
    if status ~= 200 then version_check:reject(reject) return end
    response = json.decode(response)
    if response.prerelease then version_check:reject(reject) return end
    local latest = response.tag_name:match('%d+%.%d+%.%d+')
    if not latest then version_check:reject(reject) return
    elseif latest == version then version_check:reject(('^2`%s` is running latest version.^0'):format(resource)) return end
    local cv, lv = version:gsub('%D', ''), latest:gsub('%D', '')
    if cv < lv then version_check:resolve({resource = resource, version = version}) end
  end, 'GET')
  return version_check
end

---@param resource string
local function init_duff(resource)
  if resource ~= 'duff' then return end
  if not is_server then return end
  SetTimeout(2000, function()
    local version = get_res_meta('duff', 'version', 0)
    check_resource_version('duff', version, 'donhulieo'):next(function(data)
      print(('^3[duff]^7 - ^1An update is available for `%s` (current version: %s)\r\n^3[duff]^7 - ^5Please download the latest version from the github release page.^7'):format(data.resource, data.version))
    end, function(err)
      print('^3[duff]^7 - '..(err or '^1Unable to Check for Updates.^7'))
    end)
  end)
end

AddEventHandler('onResourceStart', init_duff)

if is_server then exports('checkversion', check_resource_version); SetConvarReplicated('locale', GetConvar('locale', 'en')) end