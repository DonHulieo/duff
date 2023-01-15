--------------------------------- Line of Sight Utility Functions ---------------------------------

---@param source Entity
---@param flags number |  IntersectWorld = 1, IntersectVehicles = 2, IntersectPedsSimpleCollision = 4, IntersectPeds = 8, IntersectObjects = 16, IntersectWater = 32, IntersectFoliage = 256, IntersectEverything = 4294967295
---@param maxDistance number | Max distance to check for entities
local function FindEntitiesInLOS(source, flags, maxDistance)
    local start = GetEntityCoords(source)
    local finish = GetOffsetFromEntityInWorldCoords(source, 0.0, maxDistance, 0.0)
    local rayHandle = StartShapeTestLosProbe(start, finish, -1, source, flags)
    local status, hit, coords, normal, entity = GetShapeTestResult(rayHandle)
    local entities = {}
    if hit then
        local distance = #(start - coords)
        if distance <= maxDistance then
            entities[#entities + 1] = entity
        end
    end
    return entities
end

---@param source entity
---@param target entity
---@param flags number |  IntersectWorld = 1, IntersectVehicles = 2, IntersectPedsSimpleCollision = 4, IntersectPeds = 8, IntersectObjects = 16, IntersectWater = 32, IntersectFoliage = 256, IntersectEverything = 4294967295
local function IsEntityInLOS(source, target, flags) 
    local start = GetEntityCoords(source)
    local finish = GetEntityCoords(target)
    local rayHandle = StartShapeTestLosProbe(start, finish, -1, source, flags)
    local status, hit, coords, normal, entity = GetShapeTestResult(rayHandle)
    return hit, coords
end

exports('FindEntitiesInLOS', function(source, flags, maxDistance) return FindEntitiesInLOS(source, flags, maxDistance) end)
exports('IsEntityInLOS', function(source, target, flags) return IsEntityInLOS(source, target, flags) end)
--[[
    Example usage:
    local entities = FindEntitiesInLOS(PlayerPedId(), 4294967295, 100.0)
    for k, v in pairs(entities) do
        print(k, v)
    end
    ------------------------------------------------------------------
    Example usage:
    local ped = exports['duf']:GetClosest('ped', GetEntityCoords(PlayerPedId()))
    local hit, coords = IsEntityInLOS(PlayerPedId(), ped, 4294967295)
    if hit then
        print('hit', coords)
    end
]]

--------------------------------- GetEntityVectors --------------------------------- [Credits go to: VenomXNL | https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980]

---@param entity Entity
local function GetEntityUpVector(entity)
	local forwardVector, rightVector, upVector, posVector = GetEntityMatrix(entity)
	return upVector
end

---@param entity Entity
local function GetEntityRightVector(entity)
	local forwardVector, rightVector, upVector, posVector = GetEntityMatrix(entity)
	return rightVector
end

exports('Cl_GetEntityUpVector', function(entity) return GetEntityUpVector(entity) end)
exports('Cl_GetEntityRightVector', function(entity) return GetEntityRightVector(entity) end)