---@class CPools
---@field getpeds fun(ped_type: integer?): integer[] Returns an array of all peds. <br> In the client env, `ped_type` is used to filter the peds by their type. <br> `ped_type` can be found [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C).
---@field getvehicles fun(vehicle_type: integer|string?): integer[] Returns an array of all vehicles. <br> In the client env, `vehicle_type` is used to filter the vehicles by their class. <br> `vehicle_type` can be found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62). <br> In the server env, `vehicle_type` is used to filter the vehicles by their type. <br> `vehicle_type` can be found [here](https://docs.fivem.net/natives/?_0xA273060E).
---@field getobjects fun(): integer[] Returns an array of all objects.
---@field getpickups fun(hash: string|number?): integer[] Returns an array of all pickups. <br> `hash` is used to filter the pickups by their hash. <br> `hash` can be a string or a number. <br> **Note:** This is a client-only function.
---@field getclosestped fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, ped_type: integer?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest ped to `check`. <br> `check` can be an entity, vector or a table. <br> `ped_type` will filter for only peds of that type. <br> `radius` is the maximum distance within. <br> `excluding` is the ped or array of peds to exclude from the search.
---@field getclosestvehicle fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, vehicle_type: integer?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest vehicle to `check`. <br> `check` can be an entity, vector or a table. <br> `vehicle_type` will filter for only vehicles of that type. <br> `radius` is the maximum distance within. <br> `excluding` is the vehicle or array of vehicles to exclude from the search.
---@field getclosestobject fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest object to `check`. <br> `check` can be an entity, vector or a table. <br> `radius` is the maximum distance within. <br> `excluding` is the object or array of objects to exclude from the search.
---@field getclosestpickup fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, hash: string|number?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest pickup to `check`. <br> `check` can be an entity, vector or a table. <br> `hash` will filter for only pickups with that hash. <br> `radius` is the maximum distance within. <br> `excluding` is the pickup or array of pickups to exclude from the search. <br> **Note:** This is a client-only function.
do
  local require = require
  local filter = require('duff.shared.array').filter
  local type = type
  local get_pool, get_coords = GetGamePool, GetEntityCoords
  local is_server = IsDuplicityVersion() == 1
  local all_peds, all_vehs, all_objs = is_server and GetAllPeds or nil, is_server and GetAllVehicles or nil, is_server and GetAllObjects or nil
  ---@module 'duff.shared.vector'
  local vector = require('duff.shared.vector')
  local to_vec, get_closest = vector.tovec, vector.getclosest

  ---@param ped_type integer? The type of the ped to filter by. <br> `ped_type` can be found [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C). <br> **Note:** This is a client-only argument.
  ---@return integer[] peds An array of all peds, filtered by `ped_type` if provided.
  local function get_peds(ped_type)
    if is_server and not all_peds then error('error calling \'%s\' (native at index _0xB8584FEF not found)', 0) end ---@cast all_peds -?
    return is_server and all_peds() or filter(get_pool('CPed'),
      function(ped)
        return not ped_type or GetPedType(ped) == ped_type
      end,
    true)
  end

  ---@param vehicle_type integer|string? The class or type the vehicle to filter by. <br> `vehicle_type` is defined by class in the client env and by type in the server env. <br> Vehicles Class can be found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62). <br> Vehicles Type can be found [here](https://docs.fivem.net/natives/?_0xA273060E).
  ---@return integer[] vehicles An array of all vehicles, filtered by `vehicle_type` if provided.
  local function get_vehicles(vehicle_type)
    if is_server and not all_vehs then error('error calling \'%s\' (native at index _0x332169F5 not found)', 0) end ---@cast all_vehs -?
    return filter(is_server and all_vehs() --[[@as integer[]=]] or get_pool('CVehicle'),
      function(vehicle)
        return not vehicle_type or is_server and GetVehicleType(vehicle) == vehicle_type or GetVehicleClass(vehicle) == vehicle_type
      end,
    true)
  end

  ---@return integer[] objects An array of all objects.
  local function get_objects()
    if is_server and not all_objs then error('error calling \'%s\' (native at index _0x6886C3FE not found)', 0) end ---@cast all_objs -?
    return is_server and all_objs() or get_pool('CObject')
  end

  ---@param hash string|number? The hash of the pickup to filter by. <br> `hash` can be a string or a number.
  ---@return integer[] pickups An array of all pickups, filtered by `hash` if provided.
  local function get_pickups(hash) -- **Note**: This is a client-only function.
    if is_server then error('called a client only function \'%s\'', 0) end
    hash = type(hash) == 'string' and joaat(hash) or hash
    return filter(get_pool('CPickup'), function(pickup) return not hash or GetPickupHash(pickup) == hash end, true)
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used (client only).
  ---@param ped_type integer? The type of the ped to filter by. <br> `ped_type` can be found [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C). <br> **Note:** This is a client-only argument.
  ---@param radius number? The maximum distance to search within.
  ---@param excluding integer|integer[]? The ped or array of peds to exclude from the search.
  ---@return integer? ped, number? dist, integer[]? peds The closest ped to `check`, the distance to the closest ped and an array of all peds within `radius`.
  local function get_closest_ped(check, ped_type, radius, excluding)
    check = check and to_vec(check) or not is_server and get_coords(PlayerPedId()) --[[@as vector3]]
    if not check then error('bad argument #1 to \'%s\' (entity, vector or table expected, got '..type(check)..')', 0) end
    local ped, dist, peds = get_closest(check, get_peds(ped_type), radius, excluding)
    return ped --[[@as integer]], dist, peds
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used (client only). 
  ---@param vehicle_type integer? The class or type the vehicle to filter by. <br> `vehicle_type` is defined by class in the client env and by type in the server env. <br> Vehicles Class can be found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62). <br> Vehicles Type can be found [here](https://docs.fivem.net/natives/?_0xA273060E).
  ---@param radius number? The maximum distance to search within.
  ---@param excluding integer|integer[]?
  ---@return integer? veh, number? dist, integer[]? vehs
  local function get_closest_vehicle(check, vehicle_type, radius, excluding)
    check = check and to_vec(check) or not is_server and get_coords(PlayerPedId()) --[[@as vector3]]
    if not check then error('bad argument #1 to \'%s\' (entity, vector or table expected, got '..type(check)..')', 0) end
    local veh, dist, vehs = get_closest(check, get_vehicles(vehicle_type), radius, excluding)
    return veh --[[@as integer]], dist, vehs
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used (client only).
  ---@param radius number? The maximum distance to search within.
  ---@param excluding integer|integer[]? The object or array of objects to exclude from the search.
  ---@return integer? obj, number? dist, integer[]? objs
  local function get_closest_object(check, radius, excluding)
    check = check and to_vec(check) or not is_server and get_coords(PlayerPedId()) --[[@as vector3]]
    if not check then error('bad argument #1 to \'%s\' (entity, vector or table expected, got '..type(check)..')', 0) end
    local obj, dist, objs = get_closest(check, get_objects(), radius, excluding)
    return obj --[[@as integer]], dist, objs
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used.
  ---@param hash string|number? The hash of the pickup to filter by. <br> `hash` can be a string or a number.
  ---@param radius number? The maximum distance to search within.
  ---@param excluding string|number|(string|number)[]? The pickup or array of pickups to exclude from the search.
  ---@return integer? pickup, number? dist, integer[]? pickups The closest pickup to `check`, the distance to the closest pickup and an array of all pickups within `radius`.
  local function get_closest_pickup(check, hash, radius, excluding) -- **Note**: This is a client-only function.
    if is_server then error('called a client only function \'%s\'', 0) end
    check = check and to_vec(check) or get_coords(PlayerPedId()) --[[@as vector3]]
    hash = type(hash) == 'string' and joaat(hash) or hash
    local pickup, dist, pickups = get_closest(check, get_pickups(hash), radius, excluding)
    return pickup --[[@as integer]], dist, pickups
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