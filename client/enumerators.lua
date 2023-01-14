--------------------------------- Entity Enumerators --------------------------------- [Credits goes to: IllidanS4 | https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2]

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

local function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

local function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

exports('EnumerateObjects', function() return EnumerateObjects() end) 
exports('EnumeratePeds', function() return EnumeratePeds() end)
exports('EnumerateVehicles', function() return EnumerateVehicles() end)
exports('EnumeratePickups', function() return EnumeratePickups() end)
--[[
    Example Usage:
    for ped in EnumeratePeds() do
        -- Do something with the ped
    end
]]

--------------------------------- Enumerator Utility Functions ---------------------------------

---@param entityType string | Type of entity to search for (object, ped, vehicle, pickup)
---@param model string or hash | Model to search for
local function ReturnEntitiesWithModel(entityType, model)
    if type(model) == 'string' then
        model = joaat(model)
    end

    local entities = {}
    if entityType == 'object' then
        for obj in EnumerateObjects() do
            if GetEntityModel(obj) == model then
                entities[#entities + 1] = obj
            end
        end
    elseif entityType == 'ped' then
        for ped in EnumeratePeds() do
            if GetEntityModel(ped) == model then
                entities[#entities + 1] = ped
            end
        end
    elseif entityType == 'vehicle' then
        for veh in EnumerateVehicles() do
            if GetEntityModel(veh) == model then
                entities[#entities + 1] = veh
            end
        end
    elseif entityType == 'pickup' then
        for pickup in EnumeratePickups() do
            if GetPickupHash(pickup) == model then
                entities[#entities + 1] = pickup
            end
        end
    end
    return entities
end

exports('ReturnEntitiesWithModel', function(entityType, model) return ReturnEntitiesWithModel(entityType, model) end)
--[[
    Example Usage:
    local Vehicles = ReturnEntitiesWithModel('vehicle', 'sentinel2')
    for _, veh in pairs(Vehicles) do
        -- Do something with the veh
    end
]]

---@param entityType string | Type of entity to search for (object, ped, vehicle, pickup)
---@param zone vector3 | Zone to search for entities in
local function ReturnEntitiesInZone(entityType, zone)
    if type(zone) == 'vector3' then
        SetFocusPosAndVel(zone)
        zone = GetNameOfZone(zone)
    else
        print('^3DUF^7: ^1Invalid Zone Argument^7')
        return {}
    end

    local entities = {}
    if entityType == 'object' then
        for obj in EnumerateObjects() do
            if IsEntityInZone(obj, zone) then
                entities[#entities + 1] = obj
            end
        end
    elseif entityType == 'ped' then
        for ped in EnumeratePeds() do
            if IsEntityInZone(ped, zone) then
                entities[#entities + 1] = ped
            end
        end
    elseif entityType == 'vehicle' then
        for veh in EnumerateVehicles() do
            if IsEntityInZone(veh, zone) then
                entities[#entities + 1] = veh
            end
        end
    elseif entityType == 'pickup' then
        for pickup in EnumeratePickups() do
            if IsEntityInZone(pickup, zone) then
                entities[#entities + 1] = pickup
            end
        end
    end
    ClearFocus()
    return entities
end

exports('ReturnEntitiesInZone', function(entityType, zone) return ReturnEntitiesInZone(entityType, zone) end)
--[[
    Example usage:
    local Peds = exports['duf']:ReturnEntitiesInZone('AIRP', 'ped')
    for ped in Peds do 
        -- Do something with ped
    end
]]

---@param entityType string | Type of entity to search for (object, ped, vehicle, pickup)
---@param coords vector3 | Coordinates to search for entities around
---@param model string or hash | Model to search for
---@param excludePlayer boolean | Exclude player from search
local function GetClosest(entityType, coords, model)
    if model and type(model) == 'string' then
        model = joaat(model)
    end
    local entities = {}
    if entityType == 'object' then
        for obj in EnumerateObjects() do
            if model then
                if GetEntityModel(obj) == model then
                    entities[#entities + 1] = obj
                end
            else
                entities[#entities + 1] = obj
            end
        end
    elseif entityType == 'ped' then
        for ped in EnumeratePeds() do
            if ped ~= PlayerPedId() then
                if model then
                    if GetEntityModel(ped) == model then
                        entities[#entities + 1] = ped
                    end
                else
                    entities[#entities + 1] = ped
                end
            end
        end
    elseif entityType == 'vehicle' then
        for veh in EnumerateVehicles() do
            if model then
                if GetEntityModel(veh) == model then
                    entities[#entities + 1] = veh
                end
            else
                entities[#entities + 1] = veh
            end
        end
    elseif entityType == 'pickup' then
        for pickup in EnumeratePickups() do
            if model then
                if GetPickupHash(pickup) == model then
                    entities[#entities + 1] = pickup
                end
            else
                entities[#entities + 1] = pickup
            end
        end
    end

    local closestEntity = nil
    local closestDistance = nil
    for _, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))
        if closestDistance == nil or closestDistance > distance then
            closestEntity = entity
            closestDistance = distance
        end
    end
    return closestEntity, closestDistance
end

exports('GetClosest', function(entityType, coords, model) return GetClosest(entityType, coords, model) end)
--[[ 
    Example usage:
    local ped, dist = exports['duf']:GetClosest('ped', GetEntityCoords(PlayerPedId()))
    -- Do something with ped
]]