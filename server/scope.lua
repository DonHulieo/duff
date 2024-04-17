---@class scope
---@field Scopes {[string]: {[string]: boolean}, Synced: {[string]: {[string]: boolean}}}?
---@field getplayerscope fun(source: number|integer): {[string]: boolean}?
---@field triggerscopeevent fun(event: string, owner: number|integer, ...: any): {[string]: boolean}?
---@field createsyncedscopeevent fun(event: string, owner: number|integer, time: integer?, ...: any)
---@field removesyncedscopeevent fun(event: string)
local scope do
  local check_type = require('shared.debug').checktype
  local tostring, table = tostring, table
  local client_event, create_thread, wait = TriggerClientEvent, CreateThread, Wait
  local Scopes = {}

  local function clearScopes(resource)
    local bool = check_type(resource, 'string', clearScopes, 1)
    if bool and resource ~= 'duf' then return end
    Scopes = {}
  end

  ---@param source number|integer
  ---@return {[string]: boolean}? Scope
  local function get_player_scope(source) -- Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
    local bool = check_type(source, 'string', get_player_scope, 1)
    if bool then return end
    local src = not bool and tostring(source) or source
    return Scopes[src]
  end

  ---@param data table
  local function on_entered_scope(data)
    local player, owner = data['player'], data['for']
    Scopes[player] = Scopes[player] or {}
    Scopes[owner][player] = true
  end

  ---@param data table
  local function on_exited_scope(data)
    local playerLeaving, player = data['player'], data['for']
    if not Scopes[player] then return end
    Scopes[player][playerLeaving] = nil
  end

  local function on_dropped()
    local src = source
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
  ---@param ... any
  local function create_synced_scope_event(event, owner, time, ...)
    local targets = trigger_scope_event(event, owner, ...)
    Scopes.Synced = Scopes.Synced or {}
    Scopes.Synced[event] = targets
    local args = {...}
    time = time or 1000
    create_thread(function()
      while Scopes.Synced[event] do
        wait(time)
        if not Scopes.Synced[event] then break end
        targets = Scopes[owner]
        if targets then
          for target, _ in pairs(targets) do
            if not Scopes.Synced[event][target] then client_event(event, target, table.unpack(args)) end
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
  AddEventHandler('onResourceStop', clearScopes)
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