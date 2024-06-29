---@class CScopes
---@field Scopes {[string]: {[string]: boolean}, Synced: {[string]: {[string]: boolean}}}?
---@field getplayerscope fun(player: number|integer): {[string]: boolean} Returns the scope of `player` or the source player if `player` is not provided. <br> The scope is a table containing the players that are in the same scope as the owner. <br> Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21).
---@field triggerscopeevent fun(event: string, owner: number|integer, ...: any): {[string]: boolean}? Triggers the `event` for the owner and all the players in the same scope as the owner. <br> The `...` arguments are the arguments that will be passed to the event. <br> Returns the players that the event was triggered for. <br> Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21).
---@field createsyncedscopeevent fun(event: string, owner: number|integer, time: integer?, duration: integer?, ...: any) Creates a synced scope event that triggers the `event` for the owner and all the players in the same scope as the owner. <br> The event will be triggered every `time` milliseconds and will last for `duration` milliseconds. <br> The `...` arguments are the arguments that will be passed to the event. <br> The event will be removed after `duration` milliseconds if `duration` is provided.
---@field removesyncedscopeevent fun(event: string) Removes the synced scope event with the name `event`.
do
  local load, load_resource_file = load, LoadResourceFile
  local math = duff?.math or load(load_resource_file('duff', 'shared/math.lua'), '@duff/shared/math.lua', 'bt', _ENV)()
  local Citizen, table = Citizen, table
  local timer = math.timer
  local new_thread, wait = Citizen.CreateThread, Citizen.Wait
  ---@diagnostic disable-next-line: deprecated
  local unpack = table.unpack or unpack
  local type, error = type, error
  local tostring = tostring
  local client_event = TriggerLatentClientEvent
  local game_timer = GetGameTimer
  local current_resource = GetCurrentResourceName()
  local Scopes = {}

  ---@param resource string
  local function deinit_scopes(resource)
    if resource ~= current_resource then return end
    Scopes = {}
  end

  ---@param string any The string to check.
  ---@return string string The string if it is a string, otherwise the string representation of the value.
  local function ensure_string(string)
    return type(string) ~= 'string' and tostring(string) or string
  end

  ---@param player number|integer? The player to get the scope for. If not provided, the source player will be used.
  ---@return {[string]: boolean} Scope Returns the scope of `player` or the source player if `player` is not provided.
  local function get_player_scope(player) -- Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
    local src = ensure_string(player or source)
    if not src or type(src) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(src)..')', 0) end
    Scopes[src] = Scopes[src] or {}
    return Scopes[src]
  end

  ---@param data {for: string, player: string} The data containing the player and the owner.
  local function on_entered_scope(data)
    local player, owner = data['player'], data['for']
    Scopes[owner] = Scopes[owner] or {}
    Scopes[owner][player] = true
  end

  ---@param data {for: string, player: string} The data containing the player and the owner.
  local function on_exited_scope(data)
    local player, owner = data['player'], data['for']
    if not Scopes[owner] then return end
    Scopes[owner][player] = nil
  end

  local function on_joined()
    local src = ensure_string(source)
    if not src then return end
    Scopes[src] = {}
  end

  local function on_dropped()
    local src = ensure_string(source)
    if not src then return end
    Scopes[src] = nil
    for _, tbl in pairs(Scopes) do
      if tbl[src] then tbl[src] = nil end
    end
  end

  ---@param event string The event to trigger.
  ---@param owner number|integer The owner of the event.
  ---@param ... any The arguments to pass to the event.
  ---@return {[string]: boolean}? targets Returns the players that the event was triggered for.
  local function trigger_scope_event(event, owner, ...) -- Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
    local targets = get_player_scope(owner)
    client_event(event, owner, 50000, ...)
    if not targets then return end
    for target, _ in pairs(targets) do client_event(event, target, 50000, ...) end
    return targets
  end

  ---@param event string The event to create.
  ---@param owner number|integer The owner of the event.
  ---@param time integer? The time in milliseconds between each event.
  ---@param duration integer? The duration in milliseconds of the event.
  ---@param ... any The arguments to pass to the event.
  local function create_synced_scope_event(event, owner, time, duration, ...)
    if not get_player_scope(owner) then return end
    local targets = trigger_scope_event(event, owner, ...)
    Scopes.Synced = Scopes.Synced or {}
    Scopes.Synced[event] = targets
    local args = {...}
    local event_start = game_timer()
    time = time or 1000
    new_thread(function()
      while Scopes.Synced[event] do
        wait(time)
        if duration and timer(event_start, duration) then Scopes.Synced[event] = nil end
        if not Scopes.Synced[event] then break end
        targets = Scopes[owner]
        if targets then
          for target, _ in pairs(targets) do
            if not Scopes.Synced[event][target] then client_event(event, target, 50000, unpack(args)) end
          end
          Scopes.Synced[event] = targets
        end
      end
    end)
  end

  ---@param event string The event to remove.
  local function remove_synced_scope_event(event)
    Scopes.Synced[event] = nil
  end

  -------------------------------- INTERNAL HANDLERS --------------------------------
  AddEventHandler('onResourceStop', deinit_scopes)
  AddEventHandler('playerEnteredScope', on_entered_scope)
  AddEventHandler('playerLeftScope', on_exited_scope)
  AddEventHandler('playerJoining', on_joined)
  AddEventHandler('playerDropped', on_dropped)
  -----------------------------------------------------------------------------------
  return {
    Scopes = Scopes,
    getplayerscope = get_player_scope,
    triggerscopeevent = trigger_scope_event,
    createsyncedscopeevent = create_synced_scope_event,
    removesyncedscopeevent = remove_synced_scope_event
  }
end