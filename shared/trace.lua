
---@type fun(trace_type: string, ...: any) Prints a trace message to the console. <br> The trace message is prefixed with a color-coded type. <br> Based on [lume's trace function](https://github.com/rxi/lume/blob/master/README.md#lumetrace).
local trace do
  local get_info = debug.getinfo
  local require = require
  local round = require('duff.shared.math').round

  ---@enum (key) trace_types
  local trace_types = {['error'] = '^1SCRIPT ERROR:', ['warn'] = '^3SCRIPT WARNING:', ['info'] = '^5SCRIPT INFO:', ['debug'] = '^7SCRIPT DEBUG:'}
  ---@param trace_type 'error'|'warn'|'info'|'debug' The type of trace message. <br> This determines the color and prefix of the message. <br> `error` is red, `warn` is yellow, `info` is light blue, and `debug` is white.
  ---@param ... any The arguments to print.
  function trace(trace_type, ...) -- Print a trace message to the console, prefixed with a color-coded type. <br> Based on [lume's trace function](https://github.com/rxi/lume/blob/master/README.md#lumetrace).
    local info = get_info(2, 'Sl')
    if info.short_src == '[C]' then info = get_info(4, 'Sl') end
    local args = {...}
    local msg = trace_types[trace_type]..' '..info.short_src..':'.. info.currentline..':'
    for i = 1, #args do
      local x = args[i]
      if type(x) == 'number' then x = string.format('%g', round(x, .01)) end
      msg = msg..' '..tostring(x)
    end
    print(msg..'^7')
  end

  return trace
end