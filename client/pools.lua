---@class pools
---@field getpeds fun(ped_type: integer?): array
---@field getvehicles fun(vehicle_type: integer?): array
---@field getobjects fun(): array
---@field getpickups fun(hash: string|number?): array
---@field getclosestped fun(coords: vector3|integer?, ped_type: integer?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, array?
---@field getclosestvehicle fun(coords: vector3|integer?, vehicle_type: integer?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, array?
---@field getclosestobject fun(coords: vector3|integer?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, array?
---@field getclosestpickup fun(coords: vector3|integer?, hash: string|number?, radius: number?, excluding: integer[]|string[]|number[]): integer?, number?, array?
local pools do
  local require = require
  ---@module 'duff.shared.array'
  local array = require 'duff.shared.array'
  local type = type
  local get_pool, does_entity_exist, get_coords = GetGamePool, DoesEntityExist, GetEntityCoords
  local get_closest = require('duff.shared.vector').getclosest

  ---@param ped_type integer?
  ---@return array
  local function get_peds(ped_type)
    return array.new(get_pool('CPed')):filter(function(ped) return not ped_type or GetPedType(ped) == ped_type end, true)
  end

  ---@param vehicle_type integer?
  ---@return array
  local function get_vehicles(vehicle_type)
    return array.new(get_pool('CVehicle')):filter(function(vehicle) return not vehicle_type or GetVehicleClass(vehicle) == vehicle_type end, true)
  end

  ---@return array
  local function get_objects()
    return array.new(get_pool('CObject'))
  end

  ---@param hash string|number?
  ---@return array
  local function get_pickups(hash)
    hash = type(hash) == 'string' and joaat(hash) or hash
    return array.new(get_pool('CPickup')):filter(function(pickup) return not hash or GetPickupHash(pickup) == hash end, true)
  end

  ---@param coords vector3|number?
  ---@return vector3
  local function ensure_coords(coords)
    local param_type = type(coords)
    return param_type == 'vector3' and coords or param_type == 'number' and does_entity_exist(coords) and get_coords(coords) or get_coords(PlayerPedId())
  end

  ---@param coords vector3|integer?
  ---@param ped_type integer?
  ---@param radius number?
  ---@param excluding integer[]?
  ---@return integer? ped, number? dist, array? peds
  local function get_closest_ped(coords, ped_type, radius, excluding)
    local ped, dist, peds = get_closest(ensure_coords(coords), get_peds(ped_type), radius, excluding) --[[@cast ped -vector3]]--[=[@cast peds -vector3[]]=]
    return ped, dist, peds
  end

  ---@param coords vector3|number?
  ---@param vehicle_type integer?
  ---@param radius number?
  ---@param excluding integer[]?
  ---@return integer? veh, number? dist, array? vehs
  local function get_closest_vehicle(coords, vehicle_type, radius, excluding)
    local veh, dist, vehs = get_closest(ensure_coords(coords), get_vehicles(vehicle_type), radius, excluding) --[[@cast veh -vector3]]--[=[@cast vehs -vector3[]]=]
    return veh, dist, vehs
  end

  ---@param coords vector3|number?
  ---@param radius number?
  ---@param excluding integer[]?
  ---@return integer? obj, number? dist, array? objs
  local function get_closest_object(coords, radius, excluding)
    local obj, dist, objs = get_closest(ensure_coords(coords), get_objects(), radius, excluding) --[[@cast obj -vector3]]--[=[@cast objs -vector3[]]=]
    return obj, dist, objs
  end

  ---@param coords vector3|number?
  ---@param hash string|number?
  ---@param radius number?
  ---@param excluding string[]|number[]?
  ---@return integer? pickup, number? dist, array? pickups
  local function get_closest_pickup(coords, hash, radius, excluding)
    local pickup, dist, pickups = get_closest(ensure_coords(coords), get_pickups(hash), radius, excluding) --[[@cast pickup -vector3]]--[=[@cast pickups -vector3[]]=]
    return pickup, dist, pickups
  end

  return {
    getpeds = get_peds,
    getvehicles = get_vehicles,
    getobjects = get_objects,
    getpickups = get_pickups,
    getclosestped = get_closest_ped,
    getclosestvehicle = get_closest_vehicle,
    getclosestobject = get_closest_object,
    getclosestpickup = get_closest_pickup
  }
end