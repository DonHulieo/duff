---@class CPools
---@field GetPeds fun(ped_type: integer?): integer[]
---@field GetVehicles fun(vehicle_type: integer?): integer[]
---@field GetObjects fun(): integer[]
---@field GetPickups fun(hash: string|number?): integer[]
---@field GetClosestPed fun(coords: vector3|number?, ped_type: integer?): integer?, number?
---@field GetClosestVehicle fun(coords: vector3|number?, vehicle_type: integer?): integer?, number?
---@field GetClosestObject fun(coords: vector3|number?): integer?, number?
---@field GetClosestPickup fun(coords: vector3|number?, hash: string|number?): integer?, number?
local CPools do
  local require = require
  local array = require 'duf.shared.array'
  local get_pool = GetGamePool
  local type = type
  local get_coords = GetEntityCoords
  local get_closest = require('duf.shared.vector').GetClosest

  ---@param ped_type integer?
  ---@return integer[]
  local function getPeds(ped_type)
    return array(get_pool('CPed')):filter(function(ped) return not ped_type or GetPedType(ped) == ped_type end, array.IN_PLACE)
  end

  ---@param vehicle_type integer?
  ---@return integer[]
  local function getVehicles(vehicle_type)
    return array(get_pool('CVehicle')):filter(function(vehicle) return not vehicle_type or GetVehicleClass(vehicle) == vehicle_type end, array.IN_PLACE)
  end

  ---@return integer[]
  local function getObjects()
    return array(get_pool('CObject'))
  end

  ---@param hash string|number?
  ---@return integer[]
  local function getPickups(hash)
    hash = type(hash) == 'string' and joaat(hash) or hash
    return array(get_pool('CPickup')):filter(function(pickup) return not hash or GetPickupHash(pickup) == hash end, array.IN_PLACE)
  end

  ---@param coords vector3|number?
  ---@return vector3
  local function ensure_coords(coords)
    local param_type = type(coords)
    return param_type == 'vector3' and coords or param_type == 'number' and coords % 1 == 0 and get_coords(coords) or get_coords(PlayerPedId())
  end

  ---@param coords vector3|number?
  ---@param ped_type integer?
  ---@return integer? ped, number? distance
  local function getClosestPed(coords, ped_type)
    return get_closest(ensure_coords(coords), getPeds(ped_type)) --[[@as integer|number]]
  end

  ---@param coords vector3|number?
  ---@param vehicle_type integer?
  ---@return integer? vehicle, number? distance
  local function getClosestVehicle(coords, vehicle_type)
    return get_closest(ensure_coords(coords), getVehicles(vehicle_type)) --[[@as integer|number]]
  end

  ---@param coords vector3|number?
  ---@return integer? object, number? distance
  local function getClosestObject(coords)
    return get_closest(ensure_coords(coords), getObjects()) --[[@as integer|number]]
  end

  ---@param coords vector3|number?
  ---@param hash string|number?
  ---@return integer? pickup, number? distance
  local function getClosestPickup(coords, hash)
    return get_closest(ensure_coords(coords), getPickups(hash)) --[[@as integer|number]]
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