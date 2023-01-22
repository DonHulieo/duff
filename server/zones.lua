--------------------------------- Zone Utility Functions --------------------------------- [Credits goes to: DurtyFree | https://github.com/DurtyFree/gta-v-data-dumps/blob/master/zones.json]

--------------------------------- GetZoneFromIndex ---------------------------------
-- This is useful as most function on the client side require the zone index instead of the name, or give you the index instead of the name
---@param index number | The index of the zone
---@return string | The name of the zone
local function GetZoneFromIndex(index)
    for i, zone in pairs(Zones.Data) do
        if zone.Index == index then
            return zone.Name
        end
    end
end

exports('Sv_GetZoneFromIndex', function(index) return GetZoneFromIndex(index) end)

--------------------------------- GetZoneAtCoords ---------------------------------

---@param coords 'vector3' | The coordinates to get the zone of
---@param returnIndex boolean | If true, will return the index of the zone instead of the name
---@return string or number | The name of the zone or the index of the zone
local function GetZoneAtCoords(coords, returnIndex)
    if type(coords) == 'table' then
        coords = exports['duf']:ConvertToVec3(coords)
    elseif type(coords) ~= 'vector3' then
        return
    end
    for i, zone in pairs(Zones.Data) do
        local zonePoints = {}
        for _, bounds in pairs(zone.Bounds) do 
            for index, bound in pairs(bounds) do
                zonePoints[#zonePoints + 1] = {x = bound.X, y = bound.Y, z = bound.Z}
            end
        end
        if exports['duf']:IsPointInPolygon(coords, zonePoints) then
            if returnIndex then
                return i
            else
                return zone.Name
            end
        end
    end
end

exports('Sv_GetZoneAtCoords', function(coords) return GetZoneAtCoords(coords) end)

--------------------------------- GetEntityZone ---------------------------------

---@param entity number | Entity to get the zone of
---@param returnIndex boolean | If true, will return the index of the zone instead of the name
---@return string or number
local function GetEntityZone(entity, returnIndex)
    local coords = GetEntityCoords(entity)
    return GetZoneAtCoords(coords, returnIndex)
end

exports('Sv_GetEntityZone', function(entity) return GetEntityZone(entity) end)

--------------------------------- IsEntityInZone ---------------------------------

---@param entity number | Entity to check if the zone of 
---@param zone string or number | The zone to check if the entity is in
---@return boolean
local function IsEntityInZone(entity, zone)
    if type(zone) == 'number' then
        zone = GetZoneFromIndex(zone)
    elseif type(zone) ~= 'string' then
        return
    end
    local zoneIndex = GetZoneAtCoords(GetEntityCoords(entity), true)
    if zoneIndex then
        return Zones.Data[zoneIndex].Name == zone
    end
    return false
end

exports('Sv_IsEntityInZone', function(entity, zone) return IsEntityInZone(entity, zone) end)

--------------------------------- Get Closest Zone ---------------------------------

---@param coords 'vector3' | The coordinates to get the closest zone of
---@param returnIndex boolean | If true, will return the index of the zone instead of the name
---@param excludeZone string or number | The zone to exclude from the search
---@return string or number, number | The name of the zone or the index of the zone and the distance to the zone
local function GetClosestZone(coords, returnIndex, excludeZone)
    if type(coords) == 'table' then
        coords = exports['duf']:ConvertToVec3(coords)
    elseif type(coords) ~= 'vector3' then
        return
    end
    local closestZone, closestZoneDistance
    for i, zone in pairs(Zones.Data) do
        if excludeZone then
            if type(excludeZone) == 'number' then
                excludeZone = GetZoneFromIndex(excludeZone)
            elseif type(excludeZone) ~= 'string' then
                return
            end
            if zone.Name == excludeZone then
                goto continue
            end
        end
        local zonePoints = {}
        for _, bounds in pairs(zone.Bounds) do 
            for index, bound in pairs(bounds) do
                zonePoints[#zonePoints + 1] = {x = bound.X, y = bound.Y, z = bound.Z}
            end
        end
        local distance = exports['duf']:GetDistBetweenPoints(coords, zonePoints[1])
        if not closestZoneDistance or distance < closestZoneDistance then
            closestZoneDistance = distance
            if returnIndex then
                closestZone = i
            else
                closestZone = zone.Name
            end
        end
        ::continue::
    end
    return closestZone, closestZoneDistance
end

exports('Sv_GetClosestZone', function(coords, returnIndex, excludeZone) return GetClosestZone(coords, returnIndex, excludeZone) end)

--------------------------------- Zone Threads ---------------------------------
local function isVehicleBlacklisted(vehicle)
    local blacklistedVehicleTypes = {'boat', 'heli', 'plane', 'submarine'}
    for i = 1, #blacklistedVehicleTypes do
        if GetVehicleType(vehicle) == blacklistedVehicleTypes[i] then
            return true
        end
    end
    return false
end

CreateThread(function()
    local sleep = 1000
    while true do
        Wait(sleep)
        for _, ID in pairs(GetPlayers()) do
            Wait(0)
            sleep = 5000 
            while true do
                Wait(sleep)
                local player = GetPlayerFromIndex(ID)
                local ped = GetPlayerPed(ID)
                local coords = GetEntityCoords(ped)
                local vehicle = GetVehiclePedIsIn(ped, false)
                local zone = GetEntityZone(ped)
                if not zone then zone = 'None' end
                if vehicle ~= 0 then
                    if not isVehicleBlacklisted(vehicle) then
                        print(GetVehicleType(vehicle))
                        if string.upper(zone) ~= 'OCEANA' then
                            if zone ~= Zones.Players[ID] then
                                local event = 'duf:Cl_PlayerEntered' .. zone
                                Zones.Players[ID] = zone
                                TriggerClientEvent(event, ID, zone)
                                TriggerClientEvent('duf:Cl_SyncPlayerZones', -1, Zones.Players)
                                print(event ..' Player ' .. ID .. ' changed zone to ' .. zone)
                            else
                                local closest, distance = GetClosestZone(coords, false, zone)
                                if distance < 100 then
                                    sleep = 1000
                                else
                                    sleep = 5000
                                end
                            end
                        else
                            sleep = 5000
                        end
                    else
                        if zone ~= Zones.Players[ID] then
                            local event = 'duf:Cl_PlayerEntered' .. zone
                            Zones.Players[ID] = zone
                            TriggerClientEvent(event, ID, zone)
                            TriggerClientEvent('duf:Cl_SyncPlayerZones', -1, Zones.Players)
                            print(event ..' Player ' .. ID .. ' changed zone to ' .. zone)
                        else
                            local closest, distance = GetClosestZone(coords, false, zone)
                            if distance < 100 then
                                sleep = 1000
                            else
                                sleep = 5000
                            end
                        end
                    end
                end
            end
        end
    end
end)