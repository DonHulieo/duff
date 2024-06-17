---@type fun(fns: {[string]: function}, lim: integer) Benchmarks a `function` for `lim` iterations. <br> Prints the average time taken compared to other `functions`. <br> Based on this [benchmarking snippet](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua) by @thelindat.
local bm do
  local is_server = IsDuplicityVersion() == 1
  local time = is_server and os.nanotime or GetFrameTime()

  ---@param fn function The function to benchmark.
  ---@param lim integer The number of iterations.
  ---@return number avg_time The average time taken per iteration.
  local function bench(fn, lim)
    local start = time()
    for _ = 1, lim do fn() end
    return (time() - start) / (is_server and lim or 1)
  end

  ---@param fns {[string]: function} A table of functions to benchmark.
  ---@param lim integer The number of iterations.
  function bm(fns, lim)
    print('Average time (ms) for '..lim..' iterations:')
    local results = {}
    for k, v in pairs(fns) do results[#results + 1] = {k, bench(v, lim)} end
    table.sort(results, function(a, b) return a[2] < b[2] end)
    for i = 1, #results do
      local result = results[i]
      print(('#%d - %.4f\t(%s)'):format(i, result[2] / 1e6, result[1]))
    end
  end

  return bm
end