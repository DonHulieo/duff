---@type fun(fns: {[string]: function}, lim: integer) Benchmarks a `function` for `lim` iterations. <br> Prints the average time taken compared to other `functions`. <br> Based on this [benchmarking snippet](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua) by @thelindat.
do
  local is_server = IsDuplicityVersion() == 1
  local time = is_server and os.nanotime or GetBenchmarkTime

  ---@param fn function The function to benchmark.
  ---@param lim integer The number of iterations.
  ---@return number avg_time The average time taken per iteration.
  local function bench_fn(fn, lim)
    if not fn or not pcall(fn) then error('bad argument #1 to \'%s\' (table values must be functions)', 0) end
    local start = 0
    if not is_server then Wait(0)
    else start = time() end
    for _ = 1, lim do fn() end
    return not is_server and time() or (time() - start) / lim
  end

  ---@param fns {[string]: function} A table of functions to benchmark.
  ---@param lim integer The number of iterations.
  return function(fns, lim) -- Credits go to: [@thelindat](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua)
    if not fns or type(fns) ~= 'table' then error('bad argument #1 to \'%s\' (table expected, got '..type(fns)..')', 0) end
    if not lim or lim < 0 then error('bad argument #2 to \'%s\' (positive integer expected, got '..type(lim)..')', 0) end
    print('Average time (ms) for '..lim..' iterations:')
    local results = {}
    for k, v in pairs(fns) do results[#results + 1] = {k, bench_fn(v, lim)} end
    table.sort(results, function(a, b) return a[2] < b[2] end)
    for i = 1, #results do
      local result = results[i]
      print(('#%d - %.4f\t(%s)'):format(i, is_server and result[2] / 1e6 or result[2], result[1]))
    end
  end
end