local _debug = debug
---@class debug
---@field getfuncchain fun(level: integer): string[]? Retrieves the function call chain at the specified level.
---@field getfunclevel fun(fn: function): integer? Retrieves the level of the specified function in the call stack.
---@field getfuncinfo fun(fn: function): {name: string, source: string, line: integer}? Retrieves information about the specified function.
---@field checktype fun(param: any, type_name: string|string[], fn: function, arg_no: integer?): boolean?, string? Checks if the parameter matches the expected type(s).
local debug do
  local get_info = _debug.getinfo
  local type = type

  ---@param level integer  The level in the call stack.
  ---@return string[]?  fn_chain The function call chain as a string array.
  local function get_fn_chain(level)
    local chain = {}
    local info = get_info(level + 1, 'n')
    while info do
      chain[#chain + 1] = info.name
      level = level + 1
      info = get_info(level + 1, 'n')
    end
    return chain
  end

  ---@param fn function  The function to find the level for.
  ---@return integer?  level The level of the function in the call stack, or nil if not found.
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

  ---@param fn function The Lua function to retrieve information for.
  ---@return {name: string, source: string, line: integer}? info A table containing the name, source, and line number of the function, or nil if the information could not be retrieved.
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

  ---@param param any The parameter to check the type of.
  ---@param type_name string|string[] The expected type(s) of the parameter.
  ---@param fn function The function where the parameter is being checked.
  ---@param arg_no integer|string|nil The argument number or name being checked.
  ---@return boolean? type_valid, string param_type Returns true if the parameter type matches the expected type, or false if it does not. Also returns the actual type of the parameter.
  local function check_type(param, type_name, fn, arg_no)
    local param_type = type(param)
    type_name = type(type_name) == 'table' and type_name or {type_name} --[=[@cast type_name string[] ]=]
    local equals do
      for i = 1, #type_name do
        if param_type == type_name[i] then
          equals = true
          break
        end
      end
    end
    if not equals and fn then
      local arg_no_type = type(arg_no)
      arg_no = (arg_no_type == 'number' or arg_no_type == 'nil') and '#'..arg_no and (arg_no or 1)..'' or arg_no
      local info = get_fn_info(fn)
      if not info then error('bad argument #3 to \'checktype\' (invalid function)', 0) end
      error(info.source..':'..info.line..': bad argument '..arg_no..' to \''..info.name..'\' ('..table.concat(type_name, ', ')..' expected, got '..param_type..')', 0)
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