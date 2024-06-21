---@class CArray
---@field insert fun(list: any[], index: integer, value: any) Inserts `value` into `list` at `index`. <br> This is lua's `table.insert` imported; [documentation](https://www.lua.org/manual/5.4/manual.html#pdf-table.insert).
---@field remove fun(list: any[], index: integer): any? Returns and removes the element at `index` from `list`. <br> This is lua's `table.remove` imported; [documentation](https://www.lua.org/manual/5.4/manual.html#pdf-table.remove).
---@field sort fun(list: any[], fn: fun(a: any, b: any): boolean): any[] Sorts the elements of `list` in place. <br> This is lua's `table.sort` imported; [documentation](https://www.lua.org/manual/5.4/manual.html#pdf-table.sort).
---@field concat fun(list: any[], sep: string): string Concatenates the elements of `list` with `sep` as the separator. <br> This is lua's `table.concat` imported; [documentation](https://www.lua.org/manual/5.4/manual.html#pdf-table.concat).
---@field isarray fun(list: any[]): boolean? Returns `true` if `list` is an array, `false` otherwise.
---@field push fun(list: any[], arg: any?, ...: any?): any[] Pushes one or more values to the end of `list`.
---@field pusharray fun(list: any[], tbl: any[]): any[] Pushes the elements of an array to the end of `list`.
---@field peek fun(list: any[], index: integer?): any Returns the element at `index` without removing it from `list`.
---@field peekarray fun(list: any[], index: integer?): any[] Returns an array of elements from the end of `list` up to `index`.
---@field pop fun(list: any[], index: integer?): any?, any[] Returns and removes the element at `index` from `list`.
---@field poparray fun(list: any[], index: integer?): any[] Returns and removes an array of elements from the end of `list` up to `index`.
---@field contains fun(list: any[], key: integer?, value: any?): boolean Returns `true` if `list` contains `key`, `value` or `key & value`, `false` otherwise.
---@field find fun(list: any[], fn: fun(val: any, i: integer): boolean): integer? Returns the index of the first element that satisfies `fn`.
---@field copy fun(list: any[]): any[] Returns a shallow copy of `list`.
---@field foldleft fun(list: any[], fn: function, arg: any?): any[] Reduces `list` to a single value by applying `fn` from left to right.
---@field foldright fun(list: any[], fn: function, arg: any?): any[] Reduces `list` to a single value by applying `fn` from right to left.
---@field setenum fun(list: any[]?): enum: any[] Returns `list` as a read-only array.
---@field map fun(list: any[], fn: function, in_place: boolean?): any[] Returns a new array with the results of applying `fn` to each element.
---@field filter fun(list: any[], fn: function, in_place: boolean?): any[] Returns a new array with the elements that satisfy `fn`.
---@field foreach fun(list: any[], fn: function, reverse: boolean?) Iterates over `list` and calls `fn` for each element.
---@field reverse fun(list: any[], length: integer?): any[] Reverses the elements of `list` in place.
do
  local table = table
  local table_insert, table_remove, table_sort, table_concat, table_type, next = table.insert, table.remove, table.sort, table.concat, table.type, next
  local type, error = type, error
  local math_min = math.min
  local require = require

  ---@param tbl any[]|table The table to check.
  ---@return boolean? is_array Whether the table is an array.
  local function is_array(tbl)
    return table_type(tbl) == 'array' or type(tbl) == 'table' and not next(tbl)
  end

  ---@param list any[] The array to push to.
  ---@param arg any? The value to push.
  ---@param ... any? Additional values to push.
  ---@return any[] list The array with the values pushed.
  local function push(list, arg, ...)
    if not is_array(list) then error('bad argument #1 to \'%s\' (array or empty table expected, got '..table_type(list)..' table)', 0) end
    if not arg then return list end
    list[#list + 1] = arg
    if select('#', ...) > 0 then
      local args = {...}
      for i = 1, #args do list[#list + 1] = args[i] end
    end
    return list
  end

  ---@param list any[] The array to push to.
  ---@param tbl any[] The array to push.
  ---@return any[] list The array with the values pushed.
  local function push_array(list, tbl)
    if not is_array(list) then error('bad argument #1 to \'%s\' (array or empty table expected, got '..table_type(list)..' table)', 0) end
    if not is_array(tbl) or not tbl[1] then error('bad argument #2 to \'%s\' (filled array expected, got '..table_type(tbl)..' table)', 0) end
    for i = 1, #tbl do list[#list + 1] = tbl[i] end
    return list
  end

  ---@param list any[] The array to peek from.
  ---@param index integer? The index to peek at.
  ---@return any value The value at the specified index.
  local function peek(list, index)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    index = index or 1
    local len = #list
    if index <= 0 or index > #list then error('bad argument #2 to \'%s\' (index out of range)', 0) end
    local function do_peek(n, offset)
      if n <= 0 or offset >= len then return end
      return list[len - offset], do_peek(n - 1, offset + 1)
    end
    return do_peek(index, 0)
  end

  ---@param list any[] The array to peek from.
  ---@param index integer? The index to peek at.
  ---@return any[] values The values at the specified index.
  local function peek_array(list, index)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    index = index or 1
    if index <= 0 or index > #list then error('bad argument #2 to \'%s\' (index out of range)', 0) end
    local len, res = #list, {}
    for i = 1, math_min(index, len) do res[i] = list[len - i + 1] end
    return res
  end

  ---@param list any[] The array to pop from.
  ---@param index integer? The index to pop.
  ---@return any value, any[] list The value at the specified index and the array with the value removed.
  local function pop(list, index)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    index = index or 1
    if index <= 0 or index > #list then error('bad argument #2 to \'%s\' (index out of range)', 0) end
    local value = list[index]
    value = table_remove(list, index)
    return value and value, value and pop(list, index - 1)
  end

  ---@param list any[] The array to pop from.
  ---@param index integer? The index to pop.
  ---@return any[] values The values at the specified index.
  local function pop_array(list, index)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    index = index or 1
    if index <= 0 or index > #list then error('bad argument #2 to \'%s\' (index out of range)', 0) end
    local res = {}
    for i = 1, math_min(index, #list) do res[i] = table_remove(list, i) end
    return res
  end

  ---@param list any[] The array to search.
  ---@param key integer? The key to check.
  ---@param value any? The value to check.
  ---@return boolean contains Whether the array contains the key or value.
  local function contains(list, key, value)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if not key and not value then error('bad argument #2 to \'%s\' (key or value expected, got nil)', 0) end
    if not key and value then
      for i = 1, #list do
        if list[i] == value then return true end
      end
      return false
    end
    return key and (not value and list[key] or list[key] == value)
  end

  ---@param list any[] The array to copy.
  ---@return any[] copy_list The copied array.
  local function copy(list)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    local res = {}
    for i = 1, #list do res[i] = list[i] end
    return res
  end

  ---@param list any[] The array to search.
  ---@param fn fun(val: any, i: integer): boolean The function to search with.
  ---@return integer? index The index of the first element that satisfies the condition.
  local function find(list, fn)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if not fn then error('bad argument #2 to \'%s\' (function expected, got '..type(fn)..')', 0) end
    for i = 1, #list do
      if fn(list[i], i) then return i end
    end
  end

  ---@param list any[] The array to fold.
  ---@param fn fun(acc: any, val: any): any The function to fold with.
  ---@param arg any? The initial value.
  ---@return any res The reduced list.
  local function fold_left(list, fn, arg)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if not fn then error('bad argument #2 to \'%s\' (function expected, got '..type(fn)..')', 0) end
    local res = list[1]
    res = arg and fn(res, arg) or res
    for i = 2, #list do res = fn(res, list[i]) end
    return res
  end

  ---@param list any[] The array to fold.
  ---@param fn fun(acc: any, val: any): any The function to fold with.
  ---@param arg any? The initial value.
  ---@return any res The reduced list.
  local function fold_right(list, fn, arg)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if not fn then error('bad argument #2 to \'%s\' (function expected, got '..type(fn)..')', 0) end
    local res = list[#list]
    res = arg and fn(res, arg) or res
    for i = #list - 1, 1, -1 do res = fn(res, list[i]) end
    return res
  end

  ---@param list any[]? The array to enumerate.
  ---@return any[] enum The read-only array.
  local function enum(list)
    local res = list or {}
    setmetatable(res, {__newindex = function() error('attempt to modify a read-only table') end})
    return res
  end

  ---@param list any[] The array to map.
  ---@param fn fun(val: any): any The function to map with.
  ---@param in_place boolean? Whether to map in place.
  ---@return any[] res The mapped array.
  local function map(list, fn, in_place)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if not fn then error('bad argument #2 to \'%s\' (function expected, got '..type(fn)..')', 0) end
    local res = in_place and list or {}
    for i = 1, #list do res[i] = fn(list[i]) end
    return res
  end

  ---@param list any[] The array to filter.
  ---@param fn fun(val: any, i: integer): boolean The function to filter with.
  ---@param in_place boolean? Whether to filter in place.
  ---@return any[] res The filtered array.
  local function filter(list, fn, in_place)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if not fn then error('bad argument #2 to \'%s\' (function expected, got '..type(fn)..')', 0) end
    if in_place then
      local i = 1
      while i <= #list do
        if not fn(list[i], i) then table_remove(list, i) else i += 1 end
      end
      return list
    end
    local res = {}
    for i = 1, #list do
      local val = list[i]
      if fn(val, i) then res[#res + 1] = val end
    end
    return res
  end

  ---@param list any[] The array to iterate over.
  ---@param fn fun(val: any, i: integer) The function to call for each element.
  ---@param reverse boolean? Whether to iterate in reverse.
  local function for_each(list, fn, reverse)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if not fn then error('bad argument #2 to \'%s\' (function expected, got '..type(fn)..')', 0) end
    local i, j, n = 1, #list, 1
    if reverse then i, j, n = j, 1, -1 end
    for k = i, j, n do fn(list[k], k) end
  end

  ---@param list any[] The array to reverse.
  ---@param length integer? The length to reverse.
  ---@return any[] list The reversed array.
  local function reverse(list, length)
    if not is_array(list) or not list[1] then error('bad argument #1 to \'%s\' (filled array expected, got '..table_type(list)..' table)', 0) end
    if length and length <= 1 or #list <= 1 then return list end
    local i, j = 1, length and length or #list
    while i < j do
      list[i], list[j] = list[j], list[i]
      i += 1; j -= 1
    end
    return list
  end

  return {
    insert = table_insert,
    remove = table_remove,
    sort = table_sort,
    concat = table_concat,
    isarray = is_array,
    push = push,
    pusharray = push_array,
    peek = peek,
    peekarray = peek_array,
    pop = pop,
    poparray = pop_array,
    contains = contains,
    find = find,
    copy = copy,
    foldleft = fold_left,
    foldright = fold_right,
    setenum = enum,
    map = map,
    filter = filter,
    foreach = for_each,
    reverse = reverse
  }
end