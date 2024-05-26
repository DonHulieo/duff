---@class scope
---@field Scopes {[string]: {[string]: boolean}, Synced: {[string]: {[string]: boolean}}}?
---@field getplayerscope fun(source: number|integer): {[string]: boolean}?
---@field triggerscopeevent fun(event: string, owner: number|integer, ...: any): {[string]: boolean}?
---@field createsyncedscopeevent fun(event: string, owner: number|integer, time: integer?, ...: any)
---@field removesyncedscopeevent fun(event: string)
local scope do
  local check_type = require('duff.shared.debug').checktype
  ---@diagnostic disable-next-line: deprecated
  local tostring, unpack = tostring, unpack or table.unpack
  local timer = require('duff.shared.math').timer
  local client_event, create_thread, wait = TriggerClientEvent, CreateThread, Wait
  local game_timer = GetGameTimer
  local current_resource = GetCurrentResourceName()
  local Scopes = {}

  local function clear_scopes(resource)
    local bool = check_type(resource, 'string', clear_scopes, 1)
    if not bool or resource ~= current_resource then return end
    Scopes = {}
  end

  ---@param string any
  ---@return string
  local function ensure_string(string)
    return type(string) ~= 'string' and tostring(string) or string
  end

  ---@param player number|integer
  ---@return {[string]: boolean}? Scope
  local function get_player_scope(player) -- Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
    local src = ensure_string(player or source)
    if not check_type(src, 'string', get_player_scope, 1) then return end
    Scopes[src] = Scopes[src] or {}
    return Scopes[src]
  end

  ---@param data {for: string, player: string}
  local function on_entered_scope(data)
    local player, owner = data['player'], data['for']
    Scopes[owner] = Scopes[owner] or {}
    Scopes[owner][player] = true
  end

  ---@param data {for: string, player: string}
  local function on_exited_scope(data)
    local player, owner = data['player'], data['for']
    if not Scopes[owner] then return end
    Scopes[owner][player] = nil
  end

  local function on_dropped()
    local src = ensure_string(source)
    if not src then return end
    Scopes[src] = nil
    for _, tbl in pairs(Scopes) do
      if tbl[src] then tbl[src] = nil end
    end
  end

  ---@param event string
  ---@param owner number|integer
  ---@param ... any
  ---@return {[string]: boolean}? targets
  local function trigger_scope_event(event, owner, ...) -- Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
    local targets = get_player_scope(owner)
    client_event(event, owner, ...)
    if not targets then return end
    for target, _ in pairs(targets) do client_event(event, target, ...) end
    return targets
  end

  ---@param event string
  ---@param owner number|integer
  ---@param time integer?
  ---@param duration integer?
  ---@param ... any
  local function create_synced_scope_event(event, owner, time, duration, ...)
    if not get_player_scope(owner) then return end
    local targets = trigger_scope_event(event, owner, ...)
    Scopes.Synced = Scopes.Synced or {}
    Scopes.Synced[event] = targets
    local args = {...}
    local event_start = game_timer()
    time = time or 1000
    create_thread(function()
      while Scopes.Synced[event] do
        wait(time)
        if duration and timer(event_start, duration) then Scopes.Synced[event] = nil end
        if not Scopes.Synced[event] then break end
        targets = Scopes[owner]
        if targets then
          for target, _ in pairs(targets) do
            if not Scopes.Synced[event][target] then client_event(event, target, unpack(args)) end
          end
          Scopes.Synced[event] = targets
        end
      end
    end)
  end

  ---@param event string
  local function remove_synced_scope_event(event)
    Scopes.Synced[event] = nil
  end

  -------------------------------- INTERNAL HANDLERS --------------------------------
  AddEventHandler('onResourceStop', clear_scopes)
  AddEventHandler('playerEnteredScope', on_entered_scope)
  AddEventHandler('playerLeftScope', on_exited_scope)
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