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
    local startZ = GetEntityCoords(entity).z
    Wait(ms)
    local endZ = GetEntityCoords(entity).z
    local dist = endZ - startZ
    local incline = math.deg(math.atan2(dist, ms / 1000))
    return incline
end

exports('CalculateIncline', function(entity, ms) return CalculateIncline(entity, ms) end)

--------------------------------- Calculate Fuel Consumption ---------------------------------

---@param vehicle number | Vehicle Handle
---@param speed number | Speed in m/s
---@return number | Fuel consumption in L/100km
local function CalculateFuelConsumption(vehicle, speed)
    local vehicle = vehicle or GetVehiclePedIsIn(PlayerPedId(), false)  
    local speed = speed or GetEntitySpeed(vehicle)
    local tankVolume = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume')
    local mass = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fMass')
    local dragCo = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDragCoeff')
    local windSpeed = GetWindSpeed()
    local incline = CalculateIncline(vehicle, 100)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))
    local vehicleCSA = (maxDim.y - minDim.y) * (maxDim.z - minDim.z) -- in m^2
    local dragForce = 0.5 * dragCo * vehicleCSA * 1.202 * ((speed - windSpeed)^2) -- in N
    local gradForce = mass * 9.81 * (math.sin(math.rad(incline)) + 1 * math.cos(math.rad(incline))) -- in N
    local rollFrCo = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fRollCentreHeightFront') 
    local rollRrCo = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fRollCentreHeightRear')
    local rollCo = (rollFrCo + rollRrCo) / 2
    local rollForce = rollCo * mass * 9.81 -- in N
    local efficiency = 0.87
    if GetVehicleCurrentGear(vehicle) < (GetVehicleHighGear(vehicle) / 2) then efficiency = 0.85
    elseif GetVehicleCurrentGear(vehicle) == GetVehicleHighGear(vehicle) then efficiency = 0.9 end
    if dragForce < 0 then dragForce = 0 end 
    if gradForce < 0 then gradForce = 0 end
    if rollForce < 0 then rollForce = 0 end
    local power = (dragForce + gradForce + rollForce) * speed / efficiency -- in W
    local BSFC = 1 - ((0.5 * 1.202 * dragCo * vehicleCSA * speed ^ 3) / power) -- in kg/kWh
    local fuelConsumption = (power * BSFC) / (3600 * 4184) * 100 / tankVolume -- in L/100km
    if fuelConsumption ~= fuelConsumption or fuelConsumption < 0 then fuelConsumption = exports['duf']:RoundNumber(GetVehicleCurrentRpm(vehicle), 2) end
    -- print('Speed: ' .. speed * 3.6 .. '\nMass: ' .. mass .. ' kg\nDrag Co: ' .. dragCo .. '\nWind Speed: ' .. windSpeed .. ' m/s\nIncline: ' .. incline .. ' deg\nVehicle CSA: ' .. vehicleCSA .. ' m^2\nDrag Force: ' .. dragForce .. ' N\nGrad Force: ' .. gradForce .. ' N\nRoll Force: ' .. rollForce .. ' N\nEfficiency: ' .. efficiency .. '\nPower: ' .. power .. ' W\nBSFC : ' .. BSFC .. '\nFuel Consumption: ' .. fuelConsumption .. ' L/100km')
    return fuelConsumption
end

exports('CalculateFuelConsumption', function(vehicle, speed, incline) return CalculateFuelConsumption(vehicle, speed, incline) end)

--[[
CreateThread(function()
    while true do
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= 0 then
            local fuelConsumption = CalculateFuelConsumption(vehicle)
            print('Fuel Consumption: ' .. fuelConsumption .. ' L/100km')
        end
        Wait(1000)
    end
end)
]]--