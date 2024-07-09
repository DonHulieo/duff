---@class CBin
---@field private comparator fun(a: number, b: number): integer integer The default comparison function used by `search` and `insert`. <br> It returns `1` if `a < b`, `-1` if `a > b`, and `0` if `a == b`.
---@field private push fun(t: any[], k: integer, v: any) Inserts a value into an array at a specific index. <br> The value at the index and all subsequent values are shifted to the right.
---@field private pop fun(t: any[], i: integer): any Removes a value from an array at a specific index. <br> All subsequent values are shifted to the left.
---@field private __index table<string, fun(t: any[], v: any, cmp?: fun(a: any, b: any): integer): integer|fun(t: any[], v: any): integer|fun(t: any[], cmp?: fun(a: any, b: any): integer): any[]|fun(t: any[]): any[]> The metatable index for the `CBin` class.
---@field cmp fun(a: any, b: any): integer The comparison function used by `insert` and `search`. <br> If not provided, `comparator` is used, with signature `fun(a: any, b: any): a < b and 1 or a > b and -1 or 0`.
---@field search fun(t: any[], v: any): integer Searches for a value in a sorted array and returns the index where it was found. <br> If it was not found, it returns the index where it should be inserted.
---@field insert fun(t: any[], v: any): integer Inserts a value into a sorted array and returns the index where it was inserted.
---@field remove fun(t: any[], v: any): any Removes a value from a sorted array and returns it. <br> If the value was not found, it returns `false`.
---@field sort fun(t: any[], cmp?: fun(a: any, b: any): integer): any[] Sorts an array in place and returns it.
---@field new fun(cmp?: fun(a: any, b: any): integer): CBin Creates a new `CBin` instance with a custom comparison function.
do
  local table = table
  local t_sort = table.sort
  local type, error = type, error
  local setmeta = setmetatable

  ---@param a number The first value to compare.
  ---@param b number The second value to compare.
  ---@return integer c The comparison result.
  local function comparator(a, b)
    if type(a) ~= 'number' then error('bad argument #1 to \'cmp\' (number expected, got '..type(a)..')', 2) end
    if type(b) ~= 'number' then error('bad argument #2 to \'cmp\' (number expected, got '..type(b)..')', 2) end
    return a < b and 1 or a > b and -1 or 0
  end

  ---@param t CBin|any[] The array to search.
  ---@param v any The value to search for.
  ---@return integer i The index where the value was found or should be inserted.
  local function search(t, v)
    if type(t) ~= 'table' or next(t) and not t?[1] and not t.cmp then error('bad argument #1 to \'insert\' (array expected, got '..type(t)..')', 2) end
    if v == nil then error('bad argument #2 to \'search\' (value expected, got nil)', 2) end
    local l, r, m, c = 1, #t, 0, 0
    if r == 0 then return 1 end
    local cmp = t.cmp or comparator
    while l <= r do
      m = l + ((r - l) >> 1)
      c = cmp(v, t[m])
      if c > 0 then
        r = m - 1
      elseif c < 0 then
        l = m + 1
      else
        return m
      end
    end
    return l
  end

  ---@param t any[] The array to insert into.
  ---@param k integer The index to insert at.
  ---@param v any The value to insert.
  ---@return any[] t The array with the value inserted.
  local function push(t, k, v)
    local n = #t + 1
    for i = n, k + 1, -1 do t[i] = t[i - 1] end
    t[k] = v
    return t
  end

  ---@param t CBin|any[] The array to insert into. <br> The array must be sorted.
  ---@param v any The value to insert.
  ---@return integer i The index where the value was inserted.
  local function insert(t, v)
    if type(t) ~= 'table' or next(t) and not t?[1] and not t.cmp then error('bad argument #1 to \'insert\' (array expected, got '..type(t)..')', 2) end
    if v == nil then error('bad argument #2 to \'insert\' (value expected, got nil)', 2) end
    if #t == 0 then push(t, 1, v) return 1 end
    local i = search(t, v)
    push(t, i, v)
    return i
  end

  ---@param t any[] The array to remove from.
  ---@param i integer The index to remove.
  ---@return any v The value that was removed.
  local function pop(t, i)
    local v = t[i]
    for j = i, #t - 1 do t[j] = t[j + 1] end
    t[#t] = nil
    return v
  end

  ---@param t CBin|any[] The array to remove from.
  ---@param v number The value to remove.
  ---@return number|false v The value that was removed or `false` if it was not found.
  local function remove(t, v)
    if type(t) ~= 'table' or next(t) and not t?[1] and not t.cmp then error('bad argument #1 to \'remove\' (array expected, got '..type(t)..')', 2) end
    if v == nil then error('bad argument #2 to \'remove\' (value expected, got nil)', 2) end
    if #t == 0 then return false end
    local i = search(t, v)
    return t[i] == v and pop(t, i)
  end

  ---@param t CBin|any[] The array to sort.
  ---@return any[] t The sorted array.
  local function sort(t)
    if type(t) ~= 'table' or next(t) and not t?[1] and not t.cmp then error('bad argument #1 to \'sort\' (array expected, got '..type(t)..')', 2) end
    local cmp = t.cmp or comparator
    t_sort(t, function(a, b) return cmp(a, b) > 0 end)
    return t
  end

  local _mt = {
    __index = {
      default_cmp = comparator,
      search = search,
      insert = insert,
      remove = remove,
      sort = sort
    }
  }

  ---@param cmp (fun(a: any, b: any): integer)? The comparison function. <br> If not provided, `comparator` is used, with signature `fun(a: any, b: any): a < b and 1 or a > b and -1 or 0`.
  ---@return CBin bin The `CBin` class. <br> The class has the following methods: <br> `search`, `insert`, `remove`, `sort`.
  local function new(cmp)
    if cmp and type(cmp) ~= 'function' then error('bad argument #1 to \'new\' (function expected, got '..type(cmp)..')', 2) end
    local o = {}
    o.cmp = cmp or comparator
    return setmeta(o, _mt)
  end

  return {search = search, insert = insert, remove = remove, sort = sort, new = new}
end