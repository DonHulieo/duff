local await = Citizen.Await
local type = type
local error = error
local wait = Wait
local create_thread = CreateThread

---@param param any
---@param type_name string
---@return boolean, string
function CheckType(param, type_name)
  local param_type = type(param)
  return param_type == type_name, param_type
end

local check_type = CheckType

---@async
---@param fn function
---@param ... any
---@return boolean?
function AsyncCall(fn, ...)
  local bool, param_type = check_type(fn, 'function')
  if not bool then error('bad argument #1 to \'AsyncCall\' (function expected, got ' ..param_type.. ')') end
  wait(0) -- Yield to ensure the promise is created in a new thread
  local args = {...}
  local p = promise.new()
  create_thread(function()
    p:resolve(fn(table.unpack(args)))
  end)
  return await(p)
end

local _ = require
local Modules = {}
local load_resource_file = LoadResourceFile
---@param path string the path to the file to load ie. 'duf.shared.require'
---@return {[string]: function}? @returns the loaded module
function require(path)
  local bool, param_type = check_type(path, 'string')
  if not bool then error('bad argument #1 to \'require\' (string expected, got ' ..param_type.. ')') end
  if Modules[path] then print('Module already loaded: ' .. path) return Modules[path] end
  local resource, file = path:match('^(.-)%.(.*)$')
  if not resource then error('bad argument #1 to \'require\' (invalid path)') end
	local content = load_resource_file(resource, file:gsub('%.', '/')..'.lua')
	if not content then error('Failed to load module: ' .. path) end
	local func, err = load(content)
	if not func then error(err) end
  local ret = func()
  Modules[path] = ret
  return ret
end

exports('require', require)
-- exports('ImportObject', function()
--   return require 'duf.shared.import'
-- end)

---@param resource string
local function clearModules(resource)
  if resource ~= GetCurrentResourceName() then return end
  Modules = {}
end

AddEventHandler('onResourceStop', clearModules)