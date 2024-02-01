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
---@return boolean, function?
local function safe_load(res, file)
  return pcall(load, load_resource_file(res, file..'.lua'))
end

---@param resource string
local function init_paths(resource)
  local filLim = ensure_files(resource, GetNumResourceMetadata) - 1
  for j = 0, filLim do
    local file = ensure_files(resource, GetResourceMetadata, j) --[[@as string]]
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

---@enum contexts
local contexts = {'shared', 'server', 'client'}
---@param name string
---@return string[]? path
local function find_path(name)
  local parts = {}
  local path = {}
  for part in name:gmatch('[^.]+') do
    parts[#parts + 1] = part
  end
  for i = 1, #parts do
    local part = parts[i]:gsub('%.', '/')
    local found = package.path[part]
    if found then return found end
    for _, val in pairs(package.path) do
      local res, file = val[1], val[2]
      if file:match('%'..part..'$') then
        local new_path = file
        local loaded, func = safe_load(res, new_path)
        if loaded then
          path = {res, new_path, func}
          break
        end
      elseif file:match('%*%*') and file:match('%*$') then
        for j = 1, #contexts do
          local new_path = file:gsub('%*%*', contexts[j]):gsub('%*$', part)
          local loaded, func = safe_load(res, new_path)
          if loaded then
            path = {res, new_path, func}
            break
          end
        end
      elseif file:match('%*%*') then
        local new_path = file:gsub('%*%*', part)
        local loaded, func = safe_load(res, new_path)
        if loaded then
          path = {res, new_path, func}
          break
        end
      elseif file:match('%*$') then
        local new_path = file:gsub('%*$', part)
        local loaded, func = safe_load(res, new_path)
        if loaded then
          path = {res, new_path, func}
          break
        end
      end
    end
  end
  if #path > 0 then
    name = path[1]..':'..path[2]
    package.path[name] = {path[1], path[2]}
    package.preload[name] = path[3]
    return package.path[name]
  end
end

---@param name string @The name of the module to require. This can be a path, or a module name. If a path is provided, it must be relative to the resource root.
---@return {[string]: any} module
function require(name)
  local param_type = type(name)
  if param_type ~= 'string' then error('bad argument #1 to \'require\' (string expected, got ' ..param_type.. ')', 2) end
  local path = find_path(name)
  if not path then error('bad argument #1 to \'require\' (invalid path)', 2) end
  name = path[1]..':'..path[2]
  if not package.preload[name] then error('bad argument #1 to \'require\' (no file found)', 2) end
  local loaded, module = pcall(package.preload[name])
  if not loaded then error('bad argument #1 to \'require\' (error loading file)', 2) end
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

---@module 'duf.shared.array'
local array = require 'shared.array'

---@param param any
---@param type_name string|string[]
---@param fn_name string
---@param arg_no integer?
---@param level integer?
---@return boolean?, string?
function CheckType(param, type_name, fn_name, arg_no, level)
  local param_type = type(param)
  local equals = type(type_name) == 'table' and array(type_name):contains(nil, param_type) or param_type == type_name
  if not equals and fn_name then
    arg_no, level = arg_no or 1, level or 2
    error('bad argument #' ..arg_no.. ' to \'' ..fn_name.. '\' (' ..array(type_name):concat(', ').. ' expected, got ' ..param_type.. ')', level)
  end
  return equals, param_type
end
