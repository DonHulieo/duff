local _math = math
---@class math
---@field between fun(val: number, min: number, max: number): boolean?
---@field clamp fun(val: number, min: number, max: number): number
---@field round fun(val: number, increment: integer?): integer
---@field seedrng fun(): integer?
---@field random fun(m: integer, n: integer?): integer?
---@field timer fun(time: integer, limit: integer): boolean
local math do
  local require = require
  local check_type = require('shared.debug').checktype
  local math_floor = _math.floor
  local random_seed, math_random = _math.randomseed, _math.random
  local tonumber, tostring = tonumber, tostring
  local is_server = IsDuplicityVersion() == 1
  local posix_time = is_server and os.time or GetCloudTimeAsInt
  local game_timer = GetGameTimer

  ---@param val number
  ---@param min number
  ---@param max number
  ---@return boolean?
  local function between(val, min, max)
    if not check_type(val, 'number', between, 1) or not check_type(min, 'number', between, 2) or not check_type(max, 'number', between, 3) then return end
    return val >= min and val <= max
  end

  ---@param val number
  ---@param min number
  ---@param max number
  ---@return number?
  local function clamp(val, min, max)
    if not check_type(val, 'number', clamp, 1) or not check_type(min, 'number', clamp, 2) or not check_type(max, 'number', clamp, 3) then return end
    return val < min and min or val > max and max or val
  end

  ---@param val number
  ---@param increment integer?
  ---@return integer?
  local function round(val, increment)
    if not check_type(val, 'number', round, 1) or increment and not check_type(increment, 'number', round, 2) then return end
    if increment then return round(val / increment) * increment end
    return val >= 0 and math_floor(val + .5) or math_floor(val - .5)
  end

  ---@return integer? seed
  local function seed_rng()
    local seed = tonumber(tostring(posix_time()):reverse():sub(1, 6))
    random_seed(seed)
    return seed
  end

  ---@param m integer Minimum or Maximum (from 1)
  ---@param n integer? Maximum if m and n are provided
  ---@return integer?
  local function random(m, n)
    if not check_type(m, 'number', random, 1) then return end
    m, n = not n and 1 or m, not n and m or n
    return math_floor(math_random() * (n - m + 1) + m)
  end

  ---@param time integer
  ---@param limit integer
  ---@return boolean?
  local function timer(time, limit)
    if not check_type(time, 'number', timer, 1) or not check_type(limit, 'number', timer, 2) then return end
    local current = game_timer()
    return current - time > limit
  end

  return {
    abs = _math.abs,
    acos = _math.acos,
    asin = _math.asin,
    atan = _math.atan,
    ceil = _math.ceil,
    cos = _math.cos,
    deg = _math.deg,
    exp = _math.exp,
    floor = _math.floor,
    fmod = _math.fmod,
    huge = _math.huge,
    log = _math.log,
    max = _math.max,
    min = _math.min,
    modf = _math.modf,
    pi = _math.pi,
    rad = _math.rad,
    sin = _math.sin,
    sqrt = _math.sqrt,
    tan = _math.tan,
    _random = math_random,
    randomseed = random_seed,
    between = between,
    clamp = clamp,
    round = round,
    seedrng = seed_rng,
    random = random,
    timer = timer
  }
end