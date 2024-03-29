---@class CScope
---@field Scopes {[string]: {[string]: boolean}, Synced: {[string]: {[string]: boolean}}}?
---@field GetPlayerScope fun(source: number|integer): {[string]: boolean}?
---@field TriggerScopeEvent fun(event: string, owner: number|integer, ...: any): {[string]: boolean}?
---@field CreateSyncedScopeEvent fun(event: string, owner: number|integer, time: integer?, ...: any)
---@field RemoveSyncedScopeEvent fun(event: string)
local CScope do
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
  ---@return table? Scope
  local function getPlayerScope(source) -- Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
    local bool = check_type(source, 'string', getPlayerScope, 1)
    if bool then return end
    local src = not bool and tostring(source) or source
    return Scopes[src]
  end

  ---@param data table
  local function onPlayerEnteredScope(data)
    local player, owner = data['player'], data['for']
    Scopes[player] = Scopes[player] or {}
    Scopes[owner][player] = true
  end

  ---@param data table
  local function onPlayerLeftScope(data)
    local playerLeaving, player = data['player'], data['for']
    if not Scopes[player] then return end
    Scopes[player][playerLeaving] = nil
  end

  local function onPlayerDropped()
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
  local function triggerScopeEvent(event, owner, ...) -- Credits go to: [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
    local targets = getPlayerScope(owner)
    client_event(event, owner, ...)
    if not targets then return end
    for target, _ in pairs(targets) do client_event(event, target, ...) end
    return targets
  end

  ---@param event string
  ---@param owner number|integer
  ---@param time integer?
  ---@param ... any
  local function createSyncedScopeEvent(event, owner, time, ...)
    local targets = triggerScopeEvent(event, owner, ...)
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
  local function removeSyncedScopeEvent(event)
    Scopes.Synced[event] = nil
  end

  -------------------------------- INTERNAL HANDLERS --------------------------------
  AddEventHandler('onResourceStop', clearScopes)
  AddEventHandler('playerEnteredScope', onPlayerEnteredScope)
  AddEventHandler('playerLeftScope', onPlayerLeftScope)
  AddEventHandler('playerDropped', onPlayerDropped)
  -----------------------------------------------------------------------------------
  return {
    Scopes = Scopes,
    GetPlayerScope = getPlayerScope,
    TriggerScopeEvent = triggerScopeEvent,
    CreateSyncedScopeEvent = createSyncedScopeEvent,
    RemoveSyncedScopeEvent = removeSyncedScopeEvent
  }
end