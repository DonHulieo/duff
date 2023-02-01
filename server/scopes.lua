local scopes = {}

---@param intSource number | Player Server ID
---@return table | Table of players in scope
local function GetPlayerScope(intSource)
    return scopes[tostring(intSource)]
end

exports('GetPlayerScope', function(intSource) return GetPlayerScope(intSource) end)

---@param eventName string | Event name to trigger
---@param scopeOwner number | Player Server ID
---@vararg any | Arguments to pass to event
local function TriggerScopeEvent(eventName, scopeOwner, ...)
    local targets = scopes[tostring(scopeOwner)]
    if targets then
        for target, _ in pairs(targets) do
            TriggerClientEvent(eventName, target, ...)
        end
    end
    TriggerClientEvent(eventName, scopeOwner, ...)
end

RegisterNetEvent('TriggerScopeEvent', function(eventName, scopeOwner, ...)
    TriggerScopeEvent(eventName, scopeOwner, ...)
end)

-------------------------------- HANDLERS --------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    scopes = {}
end)

AddEventHandler('playerEnteredScope', function(data)
    local playerEntering, player = data['player'], data['for']

    if not scopes[player] then
        scopes[player] = {}
    end

    scopes[player][playerEntering] = true
end)

AddEventHandler('playerLeftScope', function(data)
    local playerLeaving, player = data['player'], data['for']

    if not scopes[player] then return end
    scopes[player][playerLeaving] = nil
end)

AddEventHandler('playerDropped', function()
    local intSource = source
        
    if not intSource then return end

    scopes[intSource] = nil

    for owner, tbl in pairs(scopes) do
        if tbl[intSource] then
            tbl[intSource] = nil
        end
    end
end)