---@class CDebug
---@field getfuncchain fun(level: integer): string[]?
---@field getfunclevel fun(fn: function): integer?
---@field getfuncinfo fun(fn: function): {name: string, source: string, line: integer}?
---@field checktype fun(param: any, type_name: string|string[], fn: function, arg_no: integer?): boolean?, string?
local CDebug do
  local debug = debug
  local get_info = debug.getinfo
  local require = require
  local array = require 'shared.array'

  ---@param level integer
  ---@return string[]?
  local function get_fn_chain(level)
    local chain = array{}
    local info = get_info(level + 1, 'n')
    while info do
      chain:push(info.name)
      level = level + 1
      info = get_info(level + 1, 'n')
    end
    return chain
  end

  ---@param fn function
  ---@return integer?
  local function get_fn_level(fn)
    local level = 1
    local info = get_info(level, 'f')
    while info do
      if info.func == fn then
        return level
      end
      level = level + 1
      info = get_info(level, 'f')
    end
  end

  ---@param fn function
  ---@return {name: string, source: string, line: integer}?
  local function get_fn_info(fn)
    local level = get_fn_level(fn)
    if level then
      local info = get_info(level + 1, 'nS')
      return info and {
        name = info.name or 'unknown',
        source = info.short_src,
        line = get_info(level + 2, 'l')?.currentline
      }
    end
  end

  ---@param param any
  ---@param type_name string|string[]
  ---@param fn function
  ---@param arg_no integer?
  ---@return boolean?, string?
  local function check_type(param, type_name, fn, arg_no)
    local param_type = type(param)
    type_name = type(type_name) == 'table' and array(type_name) or array{type_name}
    local equals = array(type_name):contains(nil, param_type)
    if not equals and fn then
      arg_no = arg_no or 1
      local info = get_fn_info(fn)
      if not info then error('bad argument #3 to \'checktype\' (invalid function)', 0) end
      error(info.source..':'..info.line..': bad argument #'..arg_no..' to \''..info.name..'\' ('..array(type_name):concat(', ')..' expected, got '..param_type..')', 0)
    end
    return equals, param_type
  end

  return {
    getfuncchain = get_fn_chain,
    getfunclevel = get_fn_level,
    getfuncinfo = get_fn_info,
    checktype = check_type
  }
end