---@class CMath
---@field clamp fun(val: number, min: number, max: number): number
---@field round fun(val: number, increment: integer?): integer
---@field seedrng fun(): integer?
---@field random fun(m: integer, n: integer?): integer?
---@field timer fun(time: integer, limit: integer): boolean
local CMath do
  local math = math
  local math_floor = math.floor
  local random_seed, math_random = math.randomseed, math.random
  local tonumber, tostring = tonumber, tostring
  local is_server = IsDuplicityVersion() == 1
  local posix_time = is_server and os.time or GetCloudTimeAsInt
  local game_timer = GetGameTimer

  ---@param val number
  ---@param min number
  ---@param max number
  ---@return number
  local function clamp(val, min, max)
    return val < min and min or val > max and max or val
  end

  ---@param val number
  ---@param increment integer?
  ---@return integer
  local function round(val, increment)
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
    if not m then return end
    m, n = not n and 1 or m, not n and m or n
    return math_floor(math_random() * (n - m + 1) + m)
  end

  ---@param time integer
  ---@param limit integer
  ---@return boolean
  local function timer(time, limit)
    local current = game_timer()
    return current - time > limit
  end

  return {clamp = clamp, round = round, seedrng = seed_rng, random = random, timer = timer}
end