---@class CPools
---@field GetPeds fun(ped_type: integer?): integer[]
---@field GetVehicles fun(vehicle_type: integer?): integer[]
---@field GetObjects fun(): integer[]
---@field GetPickups fun(hash: string|number?): integer[]
---@field GetClosestPed fun(coords: vector3|number?, ped_type: integer?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, integer[]?
---@field GetClosestVehicle fun(coords: vector3|number?, vehicle_type: integer?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, integer[]?
---@field GetClosestObject fun(coords: vector3|number?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, integer[]?
---@field GetClosestPickup fun(coords: vector3|number?, hash: string|number?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, integer[]?
local CPools do
  local require = require
  ---@module 'duf.shared.array'
  local array = require 'duf.shared.array'
  local type = type
  local get_pool, does_entity_exist, get_coords = GetGamePool, DoesEntityExist, GetEntityCoords
  local get_closest = require('duf.shared.vector').GetClosest

  ---@param ped_type integer?
  ---@return integer[]
  local function getPeds(ped_type)
    return array(get_pool('CPed')):filter(function(ped) return not ped_type or GetPedType(ped) == ped_type end, true)
  end

  ---@param vehicle_type integer?
  ---@return integer[]
  local function getVehicles(vehicle_type)
    return array(get_pool('CVehicle')):filter(function(vehicle) return not vehicle_type or GetVehicleClass(vehicle) == vehicle_type end, true)
  end

  ---@return integer[]
  local function getObjects()
    return array(get_pool('CObject'))
  end

  ---@param hash string|number?
  ---@return integer[]
  local function getPickups(hash)
    hash = type(hash) == 'string' and joaat(hash) or hash
    return array(get_pool('CPickup')):filter(function(pickup) return not hash or GetPickupHash(pickup) == hash end, true)
  end

  ---@param coords vector3|number?
  ---@return vector3
  local function ensure_coords(coords)
    local param_type = type(coords)
    return param_type == 'vector3' and coords or param_type == 'number' and does_entity_exist(coords) and get_coords(coords) or get_coords(PlayerPedId())
  end

  ---@param coords vector3|number?
  ---@param ped_type integer?
  ---@param radius number?
  ---@param excluding integer[]?
  ---@return integer? ped, number? dist, integer[]? peds
  local function getClosestPed(coords, ped_type, radius, excluding)
    local ped, dist, peds = get_closest(ensure_coords(coords), getPeds(ped_type), radius, excluding) --[[@cast ped -vector3]]--[=[@cast peds -vector3[]]=]
    return ped, dist, peds
  end

  ---@param coords vector3|number?
  ---@param vehicle_type integer?
  ---@param radius number?
  ---@param excluding integer[]?
  ---@return integer? veh, number? dist, integer[]? vehs
  local function getClosestVehicle(coords, vehicle_type, radius, excluding)
    local veh, dist, vehs = get_closest(ensure_coords(coords), getVehicles(vehicle_type), radius, excluding) --[[@cast veh -vector3]]--[=[@cast vehs -vector3[]]=]
    return veh, dist, vehs
  end

  ---@param coords vector3|number?
  ---@param radius number?
  ---@param excluding integer[]?
  ---@return integer? obj, number? dist, integer[]? objs
  local function getClosestObject(coords, radius, excluding)
    local obj, dist, objs = get_closest(ensure_coords(coords), getObjects(), radius, excluding) --[[@cast obj -vector3]]--[=[@cast objs -vector3[]]=]
    return obj, dist, objs
  end

  ---@param coords vector3|number?
  ---@param hash string|number?
  ---@param radius number?
  ---@param excluding string[]|number[]?
  ---@return integer? pickup, number? dist, integer[]? pickups
  local function getClosestPickup(coords, hash, radius, excluding)
    local pickup, dist, pickups = get_closest(ensure_coords(coords), getPickups(hash), radius, excluding) --[[@cast pickup -vector3]]--[=[@cast pickups -vector3[]]=]
    return pickup, dist, pickups
  end

  return {
    GetPeds = getPeds,
    GetVehicles = getVehicles,
    GetObjects = getObjects,
    GetPickups = getPickups,
    GetClosestPed = getClosestPed,
    GetClosestVehicle = getClosestVehicle,
    GetClosestObject = getClosestObject,
    GetClosestPickup = getClosestPickup
  }
end