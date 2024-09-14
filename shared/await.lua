---@type fun(fn: function, ...: any) Calls and awaits a the return of a function.
do
  local Citizen, promise, table = Citizen, promise, table
  local type, error = type, error
  local wait, await, new_thread = Citizen.Wait, Citizen.Await, Citizen.CreateThread
  local new_promise = promise.new
  ---@diagnostic disable-next-line: deprecated
  local unpack = table.unpack or unpack

  ---@param fn any The value to check if it is a function.
  ---@return boolean is_func the value is a function or not.
  local function is_fun(fn)
    local fn_type = type(fn)
    return fn_type == 'function' or fn_type == 'table' and (getmetatable(fn) and getmetatable(fn).__call or rawget(fn, '__cfx_functionReference'))
  end

  ---@async
  ---@param fn function The function to await.
  ---@param ... any The arguments to pass to the function.
  ---@return ...? The return values of the function.
  return function(fn, ...)
    if not fn or not is_fun(fn) then error('bad argument #1 to \'async\' (function expected, got ' .. type(fn) .. ')', 2) end
    wait(0) -- Yield to ensure the promise is created in a new thread.
    local args = {...}
    local p = new_promise()
    new_thread(function()
      p:resolve(fn(unpack(args)))
    end)
    return await(p)
  end
end