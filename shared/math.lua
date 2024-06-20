local _math = math
---@class math: mathlib
---@field between fun(val: number, min: number, max: number): boolean Returns `true` if `val` is between `min` and `max`, `false` otherwise.
---@field clamp fun(val: number, min: number, max: number): number `val` clamped between `min` and `max`.
---@field gcd fun(num: integer, den: integer): integer Greatest Common Divisor of `num` and `den`.
---@field ishalf fun(val: number): boolean Returns true if `val` is a half number. <br> e.g. `1.5`, `-1.5`
---@field isint fun(val: number): boolean Returns true if `val` is an integer.
---@field sign fun(val: number): integer Returns `1` if `val` is positive, `-1` if `val` is negative.
---@field round fun(val: number, increment: integer?): integer `val` rounded to the nearest integer. <br> `increment` if provided, rounds to the nearest multiple of `increment`.
---@field seedrng fun(): integer Seeds the random number generator with a unique seed based on the current time.
---@field random fun(m: integer , n: integer?): integer `m` minimum or maximum (from 1). <br> `n` maximum if m and n are provided. <br> Returns a random number between `m` and `n`.
---@field timer fun(time: integer, limit: integer): boolean Checks if `time` has exceeded `limit` in milliseconds.
---@field tofloat fun(num: integer, den: integer): number `num` is the numerator. <br> `den` is the denominator. <br> Returns the rational number as a float.
---@field toint fun(val: number): integer Converts a float to integer following the round half away from zero rule. <br> e.g. `1.5 -> 2`, `-1.5 -> -2` <br> [Rounding Half Toward Zero](https://en.wikipedia.org/wiki/Rounding#Rounding_half_toward_zero)
---@field toratio fun(float: number, precision: number?): integer, integer `float` is the float to convert. <br> `precision` is the maximum error allowed in the conversion. <br> Returns the float as a rational number.
local math do
  local require = require
  local type, error = type, error
  local math_floor, math_abs = _math.floor, _math.abs
  local random_seed, math_random = _math.randomseed, _math.random
  local huge = _math.huge
  local tonumber, tostring = tonumber, tostring
  local is_server = IsDuplicityVersion() == 1
  local posix_time = is_server and os.time or GetCloudTimeAsInt
  local game_timer = GetGameTimer

  ---@param val number The value to check.
  ---@param min number The minimum value.
  ---@param max number The maximum value.
  ---@return boolean is_between `true` if `val` is between `min` and `max`, `false` otherwise.
  local function between(val, min, max)
    if not val or type(val) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(val)..')', 0) end
    if not min or type(min) ~= 'number' then error('bad argument #2 to \'%s\' (number expected, got '..type(min)..')', 0) end
    if not max or type(max) ~= 'number' then error('bad argument #3 to \'%s\' (number expected, got '..type(max)..')', 0) end
    return val >= min and val <= max
  end

  ---@param val number The value to clamp.
  ---@param min number The minimum value.
  ---@param max number The maximum value.
  ---@return number clamped `val` clamped between `min` and `max`.
  local function clamp(val, min, max)
    if not val or type(val) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(val)..')', 0) end
    if not min or type(min) ~= 'number' then error('bad argument #2 to \'%s\' (number expected, got '..type(min)..')', 0) end
    if not max or type(max) ~= 'number' then error('bad argument #3 to \'%s\' (number expected, got '..type(max)..')', 0) end
    return val < min and min or val > max and max or val
  end

  ---@param val integer|number The value to check.
  ---@return boolean is_integer `true` if `val` is an integer.
  local function is_integer(val)
    if not val or type(val) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(val)..')', 0) end
    return val % 1 == 0
  end

  ---@param num integer The numerator.
  ---@param den integer The denominator.
  ---@return integer gcd The Greatest Common Divisor of `num` and `den`.
  local function g_c_d(num, den)
    if not num or not is_integer(num) then error('bad argument #1 to \'%s\' (integer expected, got '..type(num)..')', 0) end
    if not den or not is_integer(den) then error('bad argument #2 to \'%s\' (integer expected, got '..type(den)..')', 0) end
    while den ~= 0 do
      num, den = den, num % den
    end
    return num
  end

  ---@param val number The value to check.
  ---@return boolean is_half `true` if `val` is a half number. <br> e.g. `1.5`, `-1.5`.
  local function is_half(val)
    if not val or type(val) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(val)..')', 0) end
    return val % 1 == .5
  end

  ---@param val number The value to check.
  ---@return integer sign `1` if `val` is positive, `-1` if `val` is negative.
  local function sign(val)
    if not val or type(val) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(val)..')', 0) end
    return val > 0 and 1 or -1
  end

  ---@param val number The value to convert.
  ---@return integer int The converted value.
  local function to_int(val) -- Converts a `float` to `integer` following the round half away from zero rule. <br> eg. `1.5 -> 2`, `-1.5 -> -2` <br> [Rounding Half Toward Zero](https://en.wikipedia.org/wiki/Rounding#Rounding_half_toward_zero)
    if not val or type(val) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(val)..')', 0) end
    local half, pos = val % 1 >= .5, sign(val) == 1
    return half and (pos and math_floor(val+.5) or math_floor(val-.5)) or math_floor(val)
  end

  ---@param val number The value to round.
  ---@param increment number? The increment to round to.
  ---@return number|integer rounded `val` rounded to the nearest number. <br> `increment` if provided, rounds to the nearest multiple of `increment`.
  local function round(val, increment)
    if not val or type(val) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(val)..')', 0) end
    if increment and (type(increment) ~= 'number' or increment < 1) then error('bad argument #2 to \'%s\' (number greater than 0 expected, got '..type(increment)..')', 0) end
    if increment then return round(val / increment) * increment end
    return to_int(val)
  end

  ---@return integer? seed The seed used to seed the random number generator.
  local function seed_rng()
    local seed = tonumber(tostring(posix_time()):reverse():sub(1, 6))
    random_seed(seed)
    return seed
  end

  ---@param m integer Minimum or Maximum (from 1).
  ---@param n integer? Maximum if m and n are provided.
  ---@return integer number A random number between `m` and `n`.
  local function random(m, n)
    if not m or not is_integer(m) then error('bad argument #1 to \'%s\' (integer expected, got '..type(m)..')', 0) end
    if n and not is_integer(n) then error('bad argument #2 to \'%s\' (integer expected, got '..type(n)..')', 0) end
    m, n = not n and 1 or m, not n and m or n
    return math_floor(math_random() * (n - m + 1) + m)
  end

  ---@param time integer The time to check.
  ---@param limit integer The limit to check against.
  ---@return boolean has_exceeded `true` if `time` has exceeded `limit` in milliseconds.
  local function timer(time, limit)
    if not time or not is_integer(time) then error('bad argument #1 to \'timer\' (integer expected, got '..type(time)..')', 0) end
    if not limit or not is_integer(limit) then error('bad argument #2 to \'timer\' (integer expected, got '..type(limit)..')', 0) end
    local current = game_timer()
    return current - time > limit
  end

  ---@param num integer The numerator.
  ---@param den integer? The denominator.
  ---@return number float The `num` or `num/den` as a float.
  local function to_float(num, den) -- Converts an integer to float if `den` is not provided. <br> Converts a rational number to a float if `den` is provided.
    if not num or not is_integer(num) then error('bad argument #1 to \'tofloat\' (integer expected, got '..type(num)..')', 0) end
    if den and not is_integer(den) then error('bad argument #2 to \'%s\' (integer expected, got '..type(den)..')', 0) end
    return not den and num + 0.0 or num / den
  end

  ---@param float number The float to convert.
  ---@param precision number? The maximum error allowed in the conversion.
  ---@return integer num, integer den The float as a rational number.
  local function to_rational(float, precision)
    if not float or type(float) ~= 'number' then error('bad argument #1 to \'%s\' (number expected, got '..type(float)..')', 0) end
    if precision and (type(precision) ~= 'number' or precision < 1e-10) then error('bad argument #2 to \'%s\' (number greater than 1e-10 expected, got '..type(precision)..')', 0) end
    local is_neg = sign(float) == -1
    float = is_neg and -float or float
    precision =  precision or 1e-10
    local h1, h2, k1, k2 = 1, 0, 0, 1
    local x = float
    local y = x
    repeat
      local a = math_floor(x)
      h1, h2 = a * h1 + h2, h1
      k1, k2 = a * k1 + k2, k1
      x = 1 / (x - a)
      if x == huge then break end
      y = h1 / k1
    until math_abs(float - y) < float * precision
    local divisor = g_c_d(h1, k1)
    local num = math_floor(h1 / divisor)
    return is_neg and -num or num, math_floor(k1 / divisor)
  end

  math = {
    between = between,
    clamp = clamp,
    gcd = g_c_d,
    ishalf = is_half,
    isint = is_integer,
    sign = sign,
    round = round,
    seedrng = seed_rng,
    random = random,
    timer = timer,
    tofloat = to_float,
    toint = to_int,
    toratio = to_rational
  }
  for k, v in pairs(_math) do math[not math[k] and k or '_'..k] = v end
  return math
end