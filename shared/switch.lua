do
  local type, error = type, error

  ---@param t {[any]: (fun(...): any), default: (fun(...): any)}
  ---@param v any
  ---@param ... any
  ---@return fun(...): any
  return function(t, v, ...)
    local f = t[v] or t.default
    if type(f) ~= 'function' then error('bad argument #1 to \'switch\' (case \''..tostring(v)..'\' not valid)', 2) end
    return f(...)
  end
end