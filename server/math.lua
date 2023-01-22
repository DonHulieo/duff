--------------------------------- GetOffsetFromEntityInWorldCoords --------------------------------- [Credits goes to: draobrehtom | https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297]

---@param element number | Entity to get the matrix from
---@return table
local function getEntityMatrix(element)
    local rot = GetEntityRotation(element) -- ZXY
    local rx, ry, rz = rot.x, rot.y, rot.z
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local matrix = {}
    matrix[1] = {}
    matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
    matrix[1][3] = -math.cos(rx)*math.sin(ry)
    matrix[1][4] = 1
    
    matrix[2] = {}
    matrix[2][1] = -math.cos(rx)*math.sin(rz)
    matrix[2][2] = math.cos(rz)*math.cos(rx)
    matrix[2][3] = math.sin(rx)
    matrix[2][4] = 1
	
    matrix[3] = {}
    matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
    matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
    matrix[3][3] = math.cos(rx)*math.cos(ry)
    matrix[3][4] = 1
	
    matrix[4] = {}
    local pos = GetEntityCoords(element)
    matrix[4][1], matrix[4][2], matrix[4][3] = pos.x, pos.y, pos.z - 1.0
    matrix[4][4] = 1
	
    return matrix
end

---@param entity number | Entity to get the offset from
---@param offX number | X offset
---@param offY number | Y offset
---@param offZ number | Z offset
---@return 'vector3'
local function GetOffsetFromEntityInWorldCoords(entity, offX, offY, offZ)
    local m = getEntityMatrix(entity)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return vector3(x, y, z)
end

exports('Sv_GetOffsetFromEntityInWorldCoords', function(entity, offX, offY, offZ) return GetOffsetFromEntityInWorldCoords(entity, offX, offY, offZ) end)

--------------------------------- GetEntityVectors --------------------------------- [Credits goes to: VenomXNL | https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980]

---@param entity number | Entity to get the forward vector from
---@return 'vector3'
local function GetEntityForwardVector(entity)
    local matrix = getEntityMatrix(entity)
    return vector3(matrix[1][2], matrix[2][2], matrix[3][2])
end

---@param entity number | Entity to get the up vector from
---@return 'vector3'
local function GetEntityUpVector(entity)
    local matrix = getEntityMatrix(entity)
    return vector3(matrix[1][3], matrix[2][3], matrix[3][3])
end

---@param entity number | Entity to get the right vector from
---@return 'vector3'
local function GetEntityRightVector(entity)
    local matrix = getEntityMatrix(entity)
    return vector3(matrix[1][1], matrix[2][1], matrix[3][1])
end

exports('Sv_GetEntityForwardVector', function(entity) return GetEntityForwardVector(entity) end)
exports('Sv_GetEntityUpVector', function(entity) return GetEntityUpVector(entity) end)
exports('Sv_GetEntityRightVector', function(entity) return GetEntityRightVector(entity) end)

--------------------------------- GetEntityMatrix ---------------------------------

---@param entity number | Entity to get the matrix from
---@return 'vector3', 'vector3', 'vector3', 'vector3'
exports('GetEntityMatrix', function(entity) 
    local matrix = getEntityMatrix(entity)
    local forwardVector, upVector, rightVector, position = vector3(matrix[1][2], matrix[2][2], matrix[3][2]), vector3(matrix[1][3], matrix[2][3], matrix[3][3]), vector3(matrix[1][1], matrix[2][1], matrix[3][1]), vector3(matrix[4][1], matrix[4][2], matrix[4][3])
    return forwardVector, upVector, rightVector, position
end)

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


