---@type fun(unit: time_units, dec_places: integer?, iterations: integer?, fn: function, ...: any) Benchmarks a function for a given number of iterations, finding the average execution time and printing the results.
do
  local is_server = IsDuplicityVersion() == 1
  local type, error = type, error
  local os, string = os, string
  local time = is_server and os.clock or GetNetworkTimeAccurate
  local format = string.format
  local print = print
  local getmeta, get = getmetatable, rawget

  ---@param fn function The value to check if it is a function.
  ---@return boolean is_func the value is a function or not.
  local function is_fun(fn)
    local fn_type = type(fn)
    return fn_type == 'function' or fn_type == 'table' and (getmeta(fn) and getmeta(fn).__call or get(fn, '__cfx_functionReference'))
  end

  ---@enum (key) time_units
  local time_units = {['S'] = 1, ['ms'] = 1e3, ['us'] = 1e6, ['ns'] = 1e9}

  if not is_server then
    time_units['S'] = 10
    time_units['ms'] = 1
    time_units['us'] = 1e3
    time_units['ns'] = 1e6
  end

  ---@param unit time_units The unit of time to display the results in.
  ---@param dec_places integer? The number of decimal places to display the results to. <br> If `dec_places` is not provided, it defaults to `2`.
  ---@param iterations integer? The number of iterations to run the benchmark for. <br> If `iterations` is not provided, it defaults to `1000`.
  ---@param fn function The function to benchmark.
  ---@param ... any The arguments to pass to the function.
  return function(unit, dec_places, iterations, fn, ...)
    if type(unit) ~= 'string' or not time_units[unit] then error('bad argument #2 to \'bench\' (string expected, got '..type(unit)..')', 2) end
    if not is_fun(fn) then error('bad argument #1 to \'bench\' (function expected, got '..type(fn)..')', 2) end
    dec_places, iterations = dec_places or 2, iterations or 1e6
    local elapsed, multi = 0, time_units[unit]
    for _ = 1, iterations do
      local start = time()
      fn(...)
      elapsed += (time() - start)
    end
    print(format('Benchmark results:\n\t- %d function calls\n\t- %.'..dec_places..'f %s elapsed\n\t- %.'..dec_places..'f %s avg execution time.', iterations, elapsed * multi, unit, (elapsed / iterations) * multi, unit))
  end
end