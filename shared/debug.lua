---@class CDebug
---@field getfuncchain fun(level: integer): string[]?
---@field getfunclevel fun(fn: function): integer?
---@field getfuncinfo fun(fn: function): {name: string, source: string, line: integer}?
---@field checktype fun(param: any, type_name: string|string[], fn: function, arg_no: integer?): boolean?, string?
local CDebug do
  local debug = debug
  local get_info = debug.getinfo
  local type = type

  ---@param level integer
  ---@return string[]?
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
  ---@param arg_no integer|string?
  ---@return boolean?, string?
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