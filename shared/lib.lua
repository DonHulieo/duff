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
---@return {[1]: string, [2]: string, [3]: function}|boolean path
local function test_path(resource, file)
  local loaded, func = safe_load(resource, file)
  return loaded and {resource, file, func}
end

---@enum contexts
local contexts = {'shared', 'server', 'client'}
---@param name string
---@return string[]? path
local function find_path(name)
  local parts = {}
  ---@type {[1]: string, [2]: string, [3]: function}|false
  local path = {}
  for part in name:gmatch('[^.]+') do parts[#parts + 1] = part end
  local parts_len = #parts
  local resource = parts_len >= 3 and parts[1]
  local folder = parts_len >= 3 and table.concat(parts, '/', 2, parts_len - 1) or parts[1]
  local file = parts[parts_len]
  local found = parts_len >= 3 and package.path[resource..':'..folder..'/'..file]
  if found then return found end
  for _, val in pairs(package.path) do
    local found_res, found_path = val[1], val[2]
    if resource and found_res ~= resource then goto continue end
    if found_path:match('%'..folder..'/'..file..'$') then
      local new_path = found_path
      path = test_path(found_res, new_path)
      if path then break end
    elseif found_path:match('%*%*') and found_path:match('%*$') then
      if folder then
        local new_path = found_path:gsub('%*%*', folder):gsub('%*$', file)
        path = test_path(found_res, new_path)
      else
        for i = 1, #contexts do
          local new_path = found_path:gsub('%*%*', contexts[i]):gsub('%*$', file)
          path = test_path(found_res, new_path)
        end
      end
      if path then break end
    elseif found_path:match('%*%*') then
      local new_path = found_path:gsub('%*%*', folder):gsub('%*$', file)
      path = test_path(found_res, new_path)
      if path then break end
    elseif found_path:match('%*$') then
      local new_path = found_path:gsub('%*$', file)
      path = test_path(found_res, new_path)
    end
    ::continue::
  end
  if type(path) == 'table' and #path > 0 then
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
  for k, v in pairs(module) do
    if type(v) == 'function' then
      module[k] = function(...)
        local success, result = pcall(v, ...)
        if success then
          return result
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
