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