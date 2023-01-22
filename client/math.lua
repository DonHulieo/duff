--------------------------------- Line of Sight Utility Functions ---------------------------------

---@param source Entity
---@param flags number |  IntersectWorld = 1, IntersectVehicles = 2, IntersectPedsSimpleCollision = 4, IntersectPeds = 8, IntersectObjects = 16, IntersectWater = 32, IntersectFoliage = 256, IntersectEverything = 4294967295
---@param maxDistance number | Max distance to check for entities
---@return table | Entities found in line of sight
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
---@return boolean, vector3 | Hit, Coords
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
    local hit, coords = exports['duf']:IsEntityInLOS(PlayerPedId(), ped, 8)
    if hit then
        print('hit', coords)
    end
]]

--------------------------------- GetEntityVectors --------------------------------- [Credits go to: VenomXNL | https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980]

---@param entity Entity
---@return 'vector3' | upVector 
local function GetEntityUpVector(entity)
	local forwardVector, rightVector, upVector, posVector = GetEntityMatrix(entity)
	return upVector
end

---@param entity Entity
---@return 'vector3' | rightVector
local function GetEntityRightVector(entity)
	local forwardVector, rightVector, upVector, posVector = GetEntityMatrix(entity)
	return rightVector
end

exports('Cl_GetEntityUpVector', function(entity) return GetEntityUpVector(entity) end)
exports('Cl_GetEntityRightVector', function(entity) return GetEntityRightVector(entity) end)

--------------------------------- Calculate Incline ---------------------------------

---@param entity number | Entity Handle 
---@param ms number | Milliseconds to calculate incline over
---@return number | Incline in degrees
local function CalculateIncline(entity, ms)
    local entity = entity or PlayerPedId()
    local ms = ms or 1000
    local startCoords = GetEntityCoords(entity)
    Wait(ms)
    local endCoords = GetEntityCoords(entity)
    local dist = GetDistVec3(startCoords, endCoords)
    local incline = math.deg(math.atan2(dist, ms))
    return incline
end

exports('CalculateIncline', function(entity, ms) return CalculateIncline(entity, ms) end)

--------------------------------- Calculate Fuel Consumption ---------------------------------

---@param vehicle Entity
---@param speed number | Speed in MPH
---@param incline number | Incline in degrees
---@return number | Fuel consumption in L/100km
local function CalculateFuelConsumption(vehicle, speed, incline)
    local vehicle = vehicle or GetVehiclePedIsIn(PlayerPedId(), false)  
    local speed = speed or GetEntitySpeed(vehicle) * 2.236936
    local incline = incline or CalculateIncline(vehicle, 1000)
    local fuelConsumption = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume') * GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume') * (speed / 100) * (incline / 100)
    return fuelConsumption
end

exports('CalculateFuelConsumption', function(vehicle, speed, incline) return CalculateFuelConsumption(vehicle, speed, incline) end)
