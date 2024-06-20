---@type fun(fn: function, ...: any) Calls and returns the result of a function asynchronously.
do
  local promise, table, Citizen = promise, table, Citizen
  local wait = Wait
  local new_promise = promise.new
  local create_thread = CreateThread
  local unpack = table.unpack
  local await = Citizen.Await

  ---@async
  ---@param fn function The function to call asynchronously.
  ---@param ... any The arguments to pass to the function.
  ---@return ...? The return values of the function.
  return function(fn, ...)
    if not fn or type(fn) ~= 'function' then error('bad argument #1 to \'%s\' (function expected, got ' .. type(fn) .. ')', 0) end
    wait(0) -- Yield to ensure the promise is created in a new thread.
    local args = {...}
    local p = new_promise()
    create_thread(function()
      p:resolve(fn(unpack(args)))
    end)
    return await(p)
  end
end