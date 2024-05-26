---@class array
---@field private __actions table
---@field __type string
---@field new fun(self: any[]?): array Creates a new array.
---@field insert fun(self: array, index: integer, value: any): array Inserts an element at the specified index.
---@field remove fun(self: array, index: integer): any? Removes and returns the element at the specified index.
---@field sort fun(self: array, fn: function): array Sorts the elements of the array.
---@field concat fun(self: array, sep: string): string Concatenates all elements of the array with an optional separator.
---@field isarray fun(tbl: any[]): boolean? Checks if a table is an array.
---@field push fun(self: array, arg: any?, ...: any?): array Adds one or more elements to the end of the array.
---@field pusharray fun(self: array, tbl: any[]): array Adds all elements from a table to the end of the array.
---@field peek fun(self: array, index: integer?): any Returns the element at the specified index without removing it.
---@field peekarray fun(self: array, index: integer?): array Returns a new array containing the elements from the specified index to the end of the array.
---@field pop fun(self: array, index: integer?): any?, array? Removes and returns the element at the specified index.
---@field poparray fun(self: array, index: integer?): array Removes and returns a new array containing the elements from the specified index to the end of the array.
---@field contains fun(self: array, key: integer?, value: any?): boolean? Checks if the array contains a specific element or key or key-value pair.
---@field find fun(self: array, fn: function): integer? Searches for the first element that satisfies a given condition and returns its index.
---@field copy fun(self: array): array Creates a shallow copy of the array.
---@field foldleft fun(self: array, fn: function, arg: any?): array Applies a function to each element from left to right, accumulating a result.
---@field foldright fun(self: array, fn: function, arg: any?): array Applies a function to each element from right to left, accumulating a result.
---@field setenum fun(self: array?): enum: array Creates a read-only array that can be used for enumeration.
---@field map fun(self: array, fn: function, inPlace: boolean?): array Applies a function to each element and returns a new array with the results.
---@field filter fun(self: array, fn: function, inPlace: boolean?): array Returns a new array containing only the elements that satisfy a given condition.
---@field foreach fun(self: array, fn: function) Executes a function for each element across the array.
---@field reverse fun(self: array, length: integer?): array Reverses the order of elements.
local array do
  local table = table
  array = {__actions = {__index = array}, __type = 'array'}
  array.insert = table.insert
  array.remove = table.remove
  array.sort = table.sort
  array.concat = table.concat
  local min = math.min
  ---@module 'duff.shared.debug'
  local debug = require 'duff.shared.debug'
  local check_type = debug.checktype

  ---@param tbl table
  ---@param fn function
  ---@param arg_no integer?
  ---@return boolean?, string?
  local function is_table(tbl, fn, arg_no)
    return check_type(tbl, 'table', fn, arg_no)
  end

  ---@param self any[]?
  ---@return array
  local function new(self)
    self = self or {}
    if not is_table(self, new, 1) then return self end
    for k, v in pairs(array) do self[k] = v end
    setmetatable(self, {__index = array.__actions, __type = 'array'})
    return self
  end

  ---@param tbl any[]|array
  ---@return boolean?
  local function is_array(tbl)
    if not is_table(tbl, is_array, 1) then return end
    return tbl.__type == 'array'
  end

  ---@param self array
  ---@param arg any?
  ---@param ... any?
  ---@return array
  local function push(self, arg, ...)
    if not arg then return self end
    self[#self + 1] = arg
    if select('#', ...) > 0 then
      local args = {...}
      for i = 1, #args do self[#self + 1] = args[i] end
    end
    return self
  end

  ---@param self array
  ---@param tbl any[]
  ---@return array
  local function push_array(self, tbl)
    for i = 1, #tbl do self[#self + 1] = tbl[i] end
    return self
  end

  ---@param self array
  ---@param index integer?
  ---@return any
  local function peek(self, index)
    index = index or 1
    local len = #self
    if index <= 0 or index > len then return end
    local function do_peek(n, offset)
      if n <= 0 or offset >= len then return end
      return self[len - offset], do_peek(n - 1, offset + 1)
    end
    return do_peek(index, 0)
  end

  ---@param self array
  ---@param index integer?
  ---@return any[]
  local function peek_array(self, index)
    index = index or 1
    local res = new{}
    local len = #self
    for i = 1, min(index, len) do res[i] = self[len - i + 1] end
    return res
  end

  ---@param self array
  ---@param index integer?
  ---@return any?, array?
  local function pop(self, index)
    index = index or 1
    if index <= 0 or index > #self then return end
    local value = self[index]
    value = array.remove(self, index)
    return value and value, value and pop(self, index - 1)
  end

  ---@param self array
  ---@param index integer?
  ---@return array
  local function pop_array(self, index)
    index = index or 1
    local res = new{}
    for i = 1, min(index, #self) do res[i] = array.remove(self, i) end
    return res
  end

  ---@param self array
  ---@param key integer?
  ---@param value any?
  ---@return boolean?
  local function contains(self, key, value)
    if not key and not value then return end
    if not key and value then
      for i = 1, #self do
        if self[i] == value then return true end
      end
      return false
    end
    return key and (not value and self[key] or self[key] == value)
  end

  ---@param self array
  ---@param fn function
  ---@return integer?
  local function find(self, fn)
    for i = 1, #self do
      if fn(self[i], i) then return i end
    end
  end

  ---@param self array
  ---@return array
  local function copy(self)
    local res = new{}
    for i = 1, #self do res[i] = self[i] end
    return res
  end

  ---@param self array
  ---@param fn function
  ---@param arg any?
  ---@return array
  local function fold_left(self, fn, arg)
    local res = self[1]
    res = arg and fn(res, arg) or res
    for i = 2, #self do res = fn(res, self[i]) end
    return res
  end

  ---@param self array
  ---@param fn function
  ---@param arg any?
  ---@return array
  local function fold_right(self, fn, arg)
    local res = self[#self]
    res = arg and fn(res, arg) or res
    for i = #self - 1, 1, -1 do res = fn(res, self[i]) end
    return res
  end

  ---@param self array?
  ---@return array enum
  local function enum(self)
    local res = self or {}
    setmetatable(res, {__newindex = function() error('attempt to modify a read-only table') end})
    return res
  end

  ---@param self array
  ---@param fn function
  ---@param inPlace boolean?
  ---@return array
  local function map(self, fn, inPlace)
    local res = inPlace and self or new{}
    for i = 1, #self do res[i] = fn(self[i]) end
    return res
  end

  ---@param self array
  ---@param fn fun(val: any, i: integer): boolean
  ---@param inPlace boolean?
  ---@return array
  local function filter(self, fn, inPlace)
    if inPlace then
      local i = 1
      while i <= #self do
        if not fn(self[i], i) then array.remove(self, i) else i += 1 end
      end
      return self
    end
    local res = new{}
    for i = 1, #self do
      local val = self[i]
      if fn(val, i) then res[#res + 1] = val end
    end
    return res
  end

  ---@param self array
  ---@param fn function
  local function for_each(self, fn)
    for i = 1, #self do fn(self[i], i) end
  end

  ---@param self array
  ---@param length integer?
  ---@return array
  local function reverse(self, length)
    if length and length <= 1 or #self <= 1 then return self end
    local i, j = 1, length and length or #self
    while i < j do
      self[i], self[j] = self[j], self[i]
      i += 1
      j -= 1
    end
    return self
  end

  array.new = new
  array.isarray = is_array
  array.push = push
  array.pusharray = push_array
  array.peek = peek
  array.peekarray = peek_array
  array.pop = pop
  array.poparray = pop_array
  array.contains = contains
  array.find = find
  array.copy = copy
  array.foldleft = fold_left
  array.foldright = fold_right
  array.setenum = enum
  array.map = map
  array.filter = filter
  array.foreach = for_each
  array.reverse = reverse

  return setmetatable(array, {__index = array.__actions})
end