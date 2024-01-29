local _ = require
local Modules = {}
local type, error = type, error
local load_resource_file = LoadResourceFile
---@param path string the path to the file to load ie. 'duf.shared.require'
---@return {[string]: function}? @returns the loaded module
function require(path)
  local param_type = type(path)
  if param_type ~= 'string' then error('bad argument #1 to \'require\' (string expected, got ' ..param_type.. ')', 2) end
  if Modules[path] then print('Module already loaded: ' .. path) return Modules[path] end
  local resource, file = path:match('^(.-)%.(.*)$')
  if not resource then error('bad argument #1 to \'require\' (invalid path)', 2) end
	local content = load_resource_file(resource, file:gsub('%.', '/')..'.lua')
	if not content then error('Failed to load module: ' .. path, 2) end
	local func, err = load(content)
	if not func then error(err, 2) end
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

---@module 'duf.shared.array'
local array = require 'duf.shared.array'

---@param param any
---@param type_name string|string[]
---@param fn_name string
---@param arg_no integer?
---@param level integer?
---@return boolean?, string?
function CheckType(param, type_name, fn_name, arg_no, level)
  local param_type = type(param)
  local equals = array(type_name):contains(nil, param_type)
  if not equals and fn_name then
    arg_no, level = arg_no or 1, level or 2
    error('bad argument #' ..arg_no.. ' to \'' ..fn_name.. '\' (' ..array(type_name):concat().. ' expected, got ' ..param_type.. ')', level)
  end
  return equals, param_type
end

local check_type = CheckType
local promise, table = promise, table
local await, wait, create_thread = Citizen.Await, Wait, CreateThread

---@async
---@param fn function
---@param ... any
---@return boolean?
function AsyncCall(fn, ...)
  if not check_type(fn, 'function', 'AsyncCall', 1, 2) then return end
  wait(0) -- Yield to ensure the promise is created in a new thread
  local args = {...}
  local p = promise.new()
  create_thread(function()
    p:resolve(fn(table.unpack(args)))
  end)
  return await(p)
end