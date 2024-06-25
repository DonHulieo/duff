local _ = require
local load_resource_file = LoadResourceFile
local get_num_res_meta, get_res_meta, get_num_of_res = GetNumResourceMetadata, GetResourceMetadata, GetNumResources
local get_res_by_find_index, get_res_state, get_invoking_res, get_current_res = GetResourceByFindIndex, GetResourceState, GetInvokingResource, GetCurrentResourceName
---@diagnostic disable-next-line: deprecated
local pcall, load, table, select, unpack = pcall, load, table, select, unpack or table.unpack
local type, error = type, error
local is_server = IsDuplicityVersion() == 1
package = {loaded = {}, path = {}, preload = {}}

---@enum file_ids
local file_ids = {'file', 'files'}
---@param resource string
---@param fn function
---@param ... any
---@return integer|string?
local function ensure_files(resource, fn, ...)
  for i = 1, #file_ids do
    local file_id = file_ids[i]
    local success = fn(resource, file_id, ...)
    if success then return success end
  end
end

---@param res string
---@param file string
---@return boolean, function|table?
local function safe_load(res, file)
  return pcall(load, load_resource_file(res, file..'.lua'), '@'..res..':'..file..'.lua', 't', _ENV)
end

---@param resource string
local function init_paths(resource)
  local filLim = ensure_files(resource, get_num_res_meta) - 1
  for i = 0, filLim do
    local file = ensure_files(resource, get_res_meta, i) --[[@as string]]
    local name = file:match('^(.-)%.lua$') or file:match('^(.-)%*%*$')
    if name then
      local path = name:gsub('%.', '/')
      local loaded, func = safe_load(resource, path)
      if not loaded then return end
      name = resource..':'..name
      package.path[name] = {resource, path}
      package.preload[name] = func
    end
  end
end

---@param resource string
---@return boolean
local function does_res_exist(resource)
  return get_res_state(resource) ~= 'missing' and get_res_state(resource) ~= 'unknown'
end

local function find_paths()
  local resLim = get_num_of_res() - 1
  for i = 0, resLim do
    local res = get_res_by_find_index(i)
    if res and does_res_exist(res) then init_paths(res) end
  end
end

---@param resource string
---@param file string
---@return function|table|boolean path
local function test_path(resource, file)
  if not resource or not file then return false end
  local loaded, func = safe_load(resource, file)
  return loaded and func or false
end

---@param name string
---@return string?, table?
local function find_path(name)
  local parts = {}
  for part in name:gmatch('[^.]+') do parts[#parts + 1] = part end
  local resource, file = parts[1], ''
  local is_resource = does_res_exist(resource)
  local func
  if is_resource then
    file = table.concat(parts, '/', 2, #parts)
    func = test_path(resource, file)
  else
    local sources = {get_invoking_res(), get_current_res()} -- This checks for the module (if named w/o resource name ie. shared.bridge) inside the invoking resource and the current resource respectively.
    file = table.concat(parts, '/')
    for i = 1, #sources do
      local source = sources[i]
      func = test_path(source, file)
      if func then resource = source break end
    end
    for _, val in pairs(package.path) do
      local found_res = val[1]
      func = test_path(found_res, file)
      if func then resource = found_res break end
    end
  end
  if func then
    name = resource..':'..file
    package.path[name] = {resource, file}
    package.preload[name] = func
    return name, package.path[name]
  end
end

msgpack.setoption('with_hole', true) -- If a func has nil return values, this allows any leading nils to be preserved in the return values.

---@param success boolean
---@param ... any
---@return ...
local function helper(success, ...)
  if not success then error(..., 0) end
  return ...
end

---@param file string The name of the file that the function is in.
---@param name string The name of the function.
---@param fn function The function to protect.
---@return function protected_fn The protected function.
local function protect(file, name, fn) -- Wraps a function with error handling and stack trace printing. <br> [Lua: How to call error without stack trace](https://stackoverflow.com/questions/20547499/lua-how-to-call-error-without-stack-trace?rq=3) <br> [FinalizedExceptions](http://lua-users.org/wiki/FinalizedExceptions) <br> [Lua: How to get true stack trace of an error in pcall](https://stackoverflow.com/questions/45788739/get-true-stack-trace-of-an-error-in-lua-pcall)
  return function(...)
    return helper(xpcall(fn, function(err)
      err = '@'..file..'.lua:'..debug.getinfo(fn, 'S').linedefined..': '..string.format(err, name)
      local trace = debug.traceback(nil, 3):sub(17):gsub('\t', '')
      local index = trace:find('%[C%]: in function')
      return index and err..trace:sub(1, index - 4) or trace or err
    end, ...))
  end
end

-- ---@param file string
-- ---@param name string
-- ---@param fn function
-- ---@return function
-- local function protect(file, name, fn) -- testing coroutine protection, and error handling | https://stackoverflow.com/questions/45788739/get-true-stack-trace-of-an-error-in-lua-pcall
--   local co = coroutine.create(fn)
--   return function(...)
--     if coroutine.status(co) == 'dead' then co = coroutine.create(fn) end
--     local results = {coroutine.resume(co, ...)}
--     local success, err = results[1], results[2]
--     if not success then print('^1SCRIPT ERROR: ' ..debug.traceback(co, ' @'..file..'.lua:'..debug.getinfo(fn, 'S').linedefined..': '..string.format(err, name), 1)..'^7') end
--     return select(2, unpack(results))
--   end
-- end

---@param module {[string]: any}
---@return {[string]: any} module
local function protect_module(file, module)
  for k, v in pairs(module) do
    if type(v) == 'function' then
      module[k] = protect(file, k, v)
    elseif type(v) == 'table' then
      module[k] = protect_module(file, v)
    end
  end
  return module
end

---@param name string @The name of the module to require. This can be a path, or a module name. If a path is provided, it must be relative to the resource root.
---@return {[string]: any}|function module
function require(name)
  local param_type = type(name)
  if param_type ~= 'string' then error('bad argument #1 to \'require\' (string expected, got '..param_type..')', 2) end
  local path, parts = find_path(name)
  if not path or not parts then error('bad argument #1 to \'require\' (invalid path)', 2) end
  if package.loaded[path] then return package.loaded[path] end
  if not package.preload[path] then error('bad argument #1 to \'require\' (no file found)', 2) end
  local loaded, module = pcall(package.preload[path])
  if not loaded then error('bad argument #1 to \'require\' (error loading file) \n'..module, 2) end
  module = package.preload[path]()
  local mod_type = type(module)
  if mod_type ~= 'table' and mod_type ~= 'function' then error('bad argument #1 to \'require\' (table or function expected, got '..mod_type..')', 2) end
  package.loaded[name] = mod_type == 'table' and protect_module(path, module) or protect(path, parts[2], module)
  return package.loaded[name]
end

exports('require', require)

---@param resource string
local function deinit_package(resource)
  if not resource then return end
  if resource == 'duff' then package.loaded = {} package.preload = {} package.path = {} return end
  for name, path in pairs(package.path) do
    if path[1] == resource then
      package.loaded[name] = nil
      package.preload[name] = nil
      package.path[name] = nil
      Wait(0)
    end
  end
end

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
  find_paths()
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

AddEventHandler('onResourceStarting', init_paths)
AddEventHandler('onClientResourceStart', init_paths)
AddEventHandler('onResourceStart', init_duff)
AddEventHandler('onResourceStop', deinit_package)
AddEventHandler('onClientResourceStop', deinit_package)

if is_server then exports('checkversion', check_resource_version); SetConvarReplicated('locale', GetConvar('locale', 'en')) end