--------------------------------- Zone Utility Functions --------------------------------- [Credits goes to: DurtyFree | https://github.com/DurtyFree/gta-v-data-dumps/blob/master/zones.json]

local function SortTable(t, center)
    local sorted = {}
    local function GetAngle(p)
        local angle = math.atan2(p.y - center.y, p.x - center.x)
        if angle < 0 then
            angle = angle + math.pi * 2
        end
        return angle
    end
    for i = 1, #t do
        local inserted = false
        for j = 1, #sorted do
            if GetAngle(t[i]) < GetAngle(sorted[j]) then
                table.insert(sorted, j, t[i])
                inserted = true
                break
            end
        end
        if not inserted then
            sorted[#sorted + 1] = t[i]
        end
    end
    return sorted
end

--------------------------------- GetZoneFromIndex ---------------------------------
-- This is useful as most function on the client side require the zone index instead of the name, or give you the index instead of the name
---@param index number | The index of the zone
---@return string | The name of the zone
local function GetZoneFromIndex(index)
    for i, zone in pairs(Zones.Data) do
        if i == index then
            return zone.Name
        end
    end
end

exports('Sv_GetZoneFromIndex', function(index) return GetZoneFromIndex(index) end)

--------------------------------- GetIndexFromZone ---------------------------------

---@param zone string | The name of the zone
---@return number | The index of the zone
local function GetIndexFromZone(zone)
    for index, z in pairs(Zones.Data) do
        if z.Name == zone then
            return index
        end
    end
end

exports('Sv_GetIndexFromZone', function(zone) return GetIndexFromZone(zone) end)

--------------------------------- GetZoneAtCoords ---------------------------------

---@param coords 'vector3' | The coordinates to get the zone of
---@param returnIndex boolean | If true, will return the index of the zone instead of the name
---@param excludeZone string or number | The zone to exclude from the check
---@return string or number | The name of the zone or the index of the zone
local function GetZoneAtCoords(coords, returnIndex, excludeZone)
    if type(coords) == 'table' then 
        coords = exports['duf']:ConvertToVec3(coords)
    elseif type(coords) ~= 'vector3' then 
        return 
    end
    if excludeZone then
        if type(excludeZone) == 'number' then
            excludeZone = GetZoneFromIndex(excludeZone)
        elseif type(excludeZone) ~= 'string' then
            return
        end
    end
    for i, zone in pairs(Zones.Data) do
        local zonePoints = {}
        for _, bounds in pairs(zone.Bounds) do 
            for index, bound in pairs(bounds) do
                zonePoints[#zonePoints + 1] = vector3(bound.X, bound.Y, bound.Z)
            end
        end
        --[[local center = {x = 0, y = 0}
        for _, point in pairs(zonePoints) do
            center.x = center.x + point.x
            center.y = center.y + point.y
        end
        center.x = center.x / #zonePoints
        center.y = center.y / #zonePoints
        local orderedPoints = {}
        orderedPoints = exports['duf']:SortTable(zonePoints, function(a, b)
            local angleA = math.atan2(a.y - center.y, a.x - center.x)
            local angleB = math.atan2(b.y - center.y, b.x - center.x)
            if angleA < 0 then
                angleA = angleA + math.pi * 2
            end
            if angleB < 0 then
                angleB = angleB + math.pi * 2
            end
            return angleA < angleB
        end)]]
        if exports['duf']:IsPointInPoly(coords, zonePoints) then
            if excludeZone and zone.Name == excludeZone then
                return
            end
            if returnIndex then
                return zone.Index
            else
                return zone.Name
            end
        end
    end
end

exports('Sv_GetZoneAtCoords', function(coords, returnIndex, excludeZone) return GetZoneAtCoords(coords, returnIndex, excludeZone) end)

--------------------------------- GetEntityZone ---------------------------------

---@param entity number | Entity to get the zone of
---@param returnIndex boolean | If true, will return the index of the zone instead of the name
---@param excludeZone string or number | The zone to exclude from the check
---@return string or number
local function GetEntityZone(entity, returnIndex, excludeZone)
    local coords = GetEntityCoords(entity)
    return GetZoneAtCoords(coords, returnIndex, excludeZone)
end

exports('Sv_GetEntityZone', function(entity, returnIndex, excludeZone) return GetEntityZone(entity, returnIndex, excludeZone) end)

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
        local distance = 0
        for _, bounds in pairs(zone.Bounds) do 
            for index, bound in pairs(bounds) do
                distance = exports['duf']:GetDistBetweenPoints(coords, vector3(bound.X, bound.Y, bound.Z))
                if not closestZoneDistance or distance < closestZoneDistance then
                    closestZoneDistance = distance
                    if returnIndex then
                        closestZone = i
                    else
                        closestZone = zone.Name
                    end
                end
            end
        end
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

--------------------------------- Does Zone Include ---------------------------------

---@param zone string or number | The zone to check if it includes another zone
---@return boolean, string | If the zone includes another zone, return true and the name of the zone it includes
local function DoesZoneInclude(zone)
    if type(zone) == 'number' then
        zone = GetZoneFromIndex(zone)
    elseif type(zone) ~= 'string' then
        return
    end
    local bounds = Zones.Data[GetIndexFromZone(zone)].Bounds
    for _, bound in pairs(bounds) do
        for k, v in pairs(bound) do
            local zoneName = GetZoneAtCoords(vector3(v.X, v.Y, v.Z))
            if not zoneName then return false end
            if string.upper(zoneName) ~= string.upper(zone) then
                return true, zoneName
            end
        end
    end
    return false
end

exports('Sv_DoesZoneInclude', function(zone) return DoesZoneInclude(zone) end)

--------------------------------- Handlers ---------------------------------

RegisterNetEvent('duf:server:UpdateZones')
AddEventHandler('duf:server:UpdateZones', function(zones)
    Zones.PolyZones = zones
end)
