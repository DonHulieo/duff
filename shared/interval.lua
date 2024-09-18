---@class CInterval
---@field create fun(callback: (fun(...: any): callback_data: any?), time: integer?, limit: integer?): interval: interval, idx: integer
---@field start fun(interval_id: integer, update: (fun(callback_data: any?): any?)?, ...: any): interval: interval?
---@field pause fun(interval_id: integer, pause: boolean?): state: boolean
---@field stop fun(interval_id: integer): interval: interval?
---@field resume fun(interval_id: integer, update: (fun(callback_data: any?): any?)?, ...: any): interval: interval?
---@field update fun(interval_id: integer, callback: (fun(...: any): callback_data: any?), update: (fun(callback_data: any?): any)?, time: integer?, limit: integer?): interval: interval, idx: integer
---@field destroy fun(interval: interval|integer)
do
  local RES_NAME <const> = GetCurrentResourceName()
  local is_server = IsDuplicityVersion() == 1
  local game_timer = not is_server and GetNetworkTimeAccurate or os.time
  local Intervals = {}

  ---@class interval
  ---@field idx integer
  ---@field callback fun(...: any): callback_data: any?
  ---@field time integer
  ---@field limit integer
  ---@field paused boolean
  ---@field stopped boolean
  ---@field update (fun(callback_data: any?): any?)?
  ---@field thread function?
  ---@field RESOURCE string
  ---@field INVOKING string?
  ---@field data any?

  -------------------------------- FUNCTIONS --------------------------------

  ---@param start integer Network time if called from client, os time if called from server.
  ---@param limit integer Time limit in milliseconds.
  ---@return boolean state Time is greater than or equal to the limit.
  local function timer(start, limit)
    return game_timer() - start >= limit
  end

  ---@param callback fun(...: any): callback_data: any?
  ---@param time integer?
  ---@param limit integer?
  ---@return interval interval, integer idx
  local function create_interval(callback, time, limit)
    local idx = #Intervals + 1
    local interval = {
      idx = idx,
      callback = callback,
      time = time or 1000,
      limit = limit or -1,
      paused = false,
      stopped = false,
      RESOURCE = RES_NAME,
      INVOKING = GetInvokingResource()
    }
    Intervals[idx] = interval
    return interval, idx
  end

  ---@param interval_id integer
  ---@param update (fun(callback_data: any?): any)?
  ---@param ... any
  ---@return interval?
  local function start_thread(interval_id, update, ...)
    local interval = Intervals[interval_id] --[[@as interval]]
    if not interval then error('bad argument #1 to \'start\' (interval not found)', 2) end
    local stop = interval.stopped
    if stop or interval.thread then return end
    local args = {...}
    interval.thread = function()
      local limit = interval.limit
      local callback = interval.callback
      local time = interval.time
      local start = game_timer()
      local data = nil
      update = update or interval.update
      while not stop do
        Wait(time)
        if interval.paused then goto continue end
        if not callback or interval.stopped or limit and limit ~= -1 and timer(start, limit) then return end
        data = callback(table.unpack(args))
        if update then update(data) end
        interval.data = data
        ::continue::
      end
      interval.update = update
      interval.thread = nil
    end
    if not is_server then Wait(0) end
    CreateThread(interval.thread)
    return interval
  end

  ---@param interval_id integer
  ---@param pause boolean?
  ---@return boolean state
  local function pause_thread(interval_id, pause)
    local interval = Intervals[interval_id] --[[@as interval]]
    if not interval then error('bad argument #1 to \'pause\' (interval not found)', 2) end
    interval.paused = pause or not interval.paused
    return interval.paused
  end

  ---@param interval_id integer
  ---@return interval?
  local function stop_thread(interval_id)
    local interval = Intervals[interval_id] --[[@as interval]]
    if not interval then error('bad argument #1 to \'stop\' (interval not found)', 2) end
    interval.stopped = true
    return interval
  end

  ---@param interval_id integer
  ---@param update (fun(callback_data: any?): any)?
  ---@param ... any
  ---@return interval?
  local function resume_thread(interval_id, update, ...)
    local interval = Intervals[interval_id] --[[@as interval]]
    if not interval then error('bad argument #1 to \'resume\' (interval not found)', 2) end
    interval.stopped = false
    return start_thread(interval_id, update, ...)
  end

  ---@param interval_id integer
  ---@param callback fun(...: any): callback_data: any?
  ---@param update (fun(callback_data: any?): any)?
  ---@param time integer?
  ---@param limit integer?
  ---@return interval interval, integer idx
  local function update_thread(interval_id, callback, update, time, limit)
    local interval = Intervals[interval_id] --[[@as interval]]
    if not interval then error('bad argument #1 to \'update\' (interval not found)', 2) end
    stop_thread(interval_id)
    interval.callback = callback
    interval.time = time or interval.time
    interval.limit = limit or interval.limit
    interval.paused = false
    interval.stopped = false
    start_thread(interval_id, update)
    return interval, interval_id
  end

  ---@param interval interval|integer
  local function destroy_thread(interval)
    local idx = type(interval) == 'table' and interval.idx or Intervals[interval] and interval --[[@as integer]]
    if not idx then error('bad argument #1 to \'destroy\' (interval not found)', 2) end
    stop_thread(idx)
    Intervals[idx] = nil
  end

  ---@param resource string
  local function clear_res_threads(resource)
    if resource == RES_NAME then
      for _, interval in ipairs(Intervals) do
        if interval.RESOURCE == resource then destroy_thread(interval) end
      end
    elseif resource == 'duff' then
      for _, interval in ipairs(Intervals) do
        destroy_thread(interval)
      end
    else
      for _, interval in ipairs(Intervals) do
        if interval.INVOKING == resource then destroy_thread(interval) end
      end
    end
  end

  -------------------------------- HANDLERS --------------------------------

  AddEventHandler('onResourceStop', clear_res_threads)

  return {
    create = create_interval,
    start = start_thread,
    pause = pause_thread,
    stop = stop_thread,
    resume = resume_thread,
    update = update_thread,
    destroy = destroy_thread
  }
end