local _ = require
local type, error = type, error
local load_resource_file = LoadResourceFile
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
  return pcall(load, load_resource_file(res, file..'.lua'))
end

---@param resource string
local function init_paths(resource)
  local filLim = ensure_files(resource, GetNumResourceMetadata) - 1
  for i = 0, filLim do
    local file = ensure_files(resource, GetResourceMetadata, i) --[[@as string]]
    local name = file:match('^(.-)%.lua$') or file:match('^(.-)%*%*$')
    if name then
      local path = name:gsub('%.', '/')
      name = resource..':'..name
      package.path[name] = {resource, path}
      local loaded, func = safe_load(resource, path)
      if loaded then package.preload[name] = func end
    end
  end
end

local function find_paths()
  local resLim = GetNumResources() - 1
  for i = 0, resLim do
    local res = GetResourceByFindIndex(i)
    init_paths(res)
  end
end

find_paths() -- Find As Many Paths As Possible On Startup

---@param resource string
---@param file string
---@return function|table|boolean path
local function test_path(resource, file)
  local loaded, func = safe_load(resource, file)
  return loaded and func or false
end

---@param name string
---@return string?, function|table?
local function find_path(name)
  local parts = {}
  for part in name:gmatch('[^.]+') do parts[#parts + 1] = part end
  local resource_state = GetResourceState
  local resource, file = parts[1], ''
  local is_resource = resource_state(resource) ~= 'missing' and resource_state(resource) ~= 'unknown'
  local func
  if is_resource then
    file = table.concat(parts, '/', 2, #parts)
    func = test_path(resource, file)
  else
    local sources = {GetInvokingResource(), GetCurrentResourceName()} -- This checks for the module (if named w/o resource name ie. shared.bridge) inside the invoking resource and the current resource respectively.
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

---@param name string @The name of the module to require. This can be a path, or a module name. If a path is provided, it must be relative to the resource root.
---@return {[string]: any} module
function require(name)
  local param_type = type(name)
  if param_type ~= 'string' then error('bad argument #1 to \'require\' (string expected, got ' ..param_type.. ')', 1) end
  local path = find_path(name)
  if not path then error('bad argument #1 to \'require\' (invalid path)', 1) end
  if package.loaded[name] then return package.loaded[name] end
  if not package.preload[path] then error('bad argument #1 to \'require\' (no file found)', 1) end
  local loaded, module = pcall(package.preload[path])
  if not loaded then error('bad argument #1 to \'require\' (error loading file) \n' ..module, 1)
  elseif not module then module = package.preload[path] end
  for k, v in pairs(module) do
    if type(v) == 'function' then
      module[k] = function(...)
        local success, result, any = pcall(v, ...)
        if success then
          return result, any and table.unpack(any)
        else
          error(result, 0)
        end
      end
    end
  end
  package.loaded[name] = module
  return package.loaded[name]
end

exports('require', require)

local function deinit_package(resource)
  for name, path in pairs(package.path) do
    if path[1] == resource then
      package.path[name] = nil
      package.preload[name] = nil
      package.loaded[name] = nil
    end
  end
end

AddEventHandler('onResourceStart', init_paths)
AddEventHandler('onResourceStop', deinit_package)
