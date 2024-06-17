local _math = math
---@class math: mathlib
---@field between fun(val: number, min: number, max: number): boolean? returns `true` if `val` is between `min` and `max`, `false` otherwise.
---@field clamp fun(val: number, min: number, max: number): number `val` clamped between `min` and `max`.
---@field gcd fun(num: integer, den: integer): integer Greatest Common Divisor of `num` and `den`.
---@field ishalf fun(val: number): boolean returns true if `val` is a half number. <br> e.g. `1.5`, `-1.5`
---@field isint fun(val: number): boolean returns true if `val` is an integer.
---@field ispos fun(val: number): boolean returns true if `val` is positive.
---@field round fun(val: number, increment: integer?): integer `val` rounded to the nearest integer. <br> `increment` if provided, rounds to the nearest multiple of `increment`.
---@field seedrng fun(): integer? Seeds the random number generator with a unique seed based on the current time.
---@field random fun(m: integer , n: integer?): integer? `m` Minimum or Maximum (from 1). <br> `n` Maximum if m and n are provided. <br> returns a random number between `m` and `n`.
---@field timer fun(time: integer, limit: integer): boolean Checks if `time` has exceeded `limit` in milliseconds.
---@field tofloat fun(num: integer, den: integer): number `num` is the numerator. <br> `den` is the denominator. <br> returns the rational number as a float.
---@field toint fun(val: number): integer Converts a float to integer following the round half away from zero rule. <br> e.g. `1.5 -> 2`, `-1.5 -> -2` <br> [Rounding Half Toward Zero](https://en.wikipedia.org/wiki/Rounding#Rounding_half_toward_zero)
---@field toratio fun(float: number, precision: number?): integer, integer `float` is the float to convert. <br> `precision` is the maximum error allowed in the conversion. <br> returns the float as a rational number.
local math do
  local require = require
  local check_type = require('duff.shared.debug').checktype
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
  ---@return boolean? is_between `true` if `val` is between `min` and `max`, `false` otherwise.
  local function between(val, min, max)
    if not check_type(val, 'number', between, 1) or not check_type(min, 'number', between, 2) or not check_type(max, 'number', between, 3) then return end
    return val >= min and val <= max
  end

  ---@param val number The value to clamp.
  ---@param min number The minimum value.
  ---@param max number The maximum value.
  ---@return number? clamped `val` clamped between `min` and `max`.
  local function clamp(val, min, max)
    if not check_type(val, 'number', clamp, 1) or not check_type(min, 'number', clamp, 2) or not check_type(max, 'number', clamp, 3) then return end
    return val < min and min or val > max and max or val
  end

  ---@param num integer The numerator.
  ---@param den integer The denominator.
  ---@return integer gcd The Greatest Common Divisor of `num` and `den`.
  local function g_c_d(num, den)
    while den ~= 0 do
      num, den = den, num % den
    end
    return num
  end

  ---@param val number The value to check.
  ---@return boolean is_half `true` if `val` is a half number. <br> e.g. `1.5`, `-1.5`.
  local function is_half(val)
    return val % 1 == .5
  end

  ---@param val integer|number The value to check.
  ---@return boolean is_integer `true` if `val` is an integer.
  local function is_integer(val)
    return val % 1 == 0
  end

  ---@param val number The value to check.
  ---@return boolean is_positive `true` if `val` is positive.
  local function is_positive(val)
    return val > 0
  end

  ---@param val number The value to convert.
  ---@return integer int The converted value.
  local function to_int(val) -- Converts a `float` to `integer` following the round half away from zero rule. <br> eg. `1.5 -> 2`, `-1.5 -> -2` <br> [Rounding Half Toward Zero](https://en.wikipedia.org/wiki/Rounding#Rounding_half_toward_zero)
    local half, pos = val % 1 >= .5, is_positive(val)
    return half and (pos and math_floor(val+.5) or math_floor(val-.5)) or math_floor(val)
  end

  ---@param val number The value to round.
  ---@param increment integer? The increment to round to.
  ---@return number|integer? rounded `val` rounded to the nearest integer. <br> `increment` if provided, rounds to the nearest multiple of `increment`.
  local function round(val, increment)
    if not check_type(val, 'number', round, 1) or increment and not check_type(increment, 'number', round, 2) then return end
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
  ---@return integer? number A random number between `m` and `n`.
  local function random(m, n)
    if not check_type(m, 'number', random, 1) then return end
    m, n = not n and 1 or m, not n and m or n
    return math_floor(math_random() * (n - m + 1) + m)
  end

  ---@param time integer The time to check.
  ---@param limit integer The limit to check against.
  ---@return boolean? has_exceeded `true` if `time` has exceeded `limit` in milliseconds.
  local function timer(time, limit)
    if not check_type(time, 'number', timer, 1) or not check_type(limit, 'number', timer, 2) then return end
    local current = game_timer()
    return current - time > limit
  end

  ---@param num integer The numerator.
  ---@param den integer? The denominator.
  ---@return number float the `num` or `num/den` as a float.
  local function to_float(num, den) -- Converts an integer to float if `den` is not provided. <br> Converts a rational number to a float if `den` is provided.
    return not den and num + 0.0 or num / den
  end

  ---@param float number The float to convert.
  ---@param precision number? The maximum error allowed in the conversion.
  ---@return integer num, integer den The float as a rational number.
  local function to_rational(float, precision)
    local is_neg = not is_positive(float)
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

  math = {}
  math.between = between
  math.clamp = clamp
  math.gcd = g_c_d
  math.ishalf = is_half
  math.isint = is_integer
  math.ispos = is_positive
  math.round = round
  math.seedrng = seed_rng
  math.random = random
  math.timer = timer
  math.tofloat = to_float
  math.toint = to_int
  math.toratio = to_rational
  for k, v in pairs(_math) do math[k] = not math[k] and v or math[k] end

  return math
end