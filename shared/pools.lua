---@class CPools
---@field getpeds fun(ped_type: integer|(fun(ped: integer, index: integer): boolean)?): integer[] Returns an array of all peds, filtered by `ped_type` if provided. <br> `ped_type` can be a function or a ped type (client only). <br> If `ped_type` is a function, it will be used to filter the peds. <br> If `ped_type` is a number, it will filter the peds by their type. <br> `ped_type` can be found [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C).
---@field getvehicles fun(vehicle_type: integer|string|(fun(vehicle: integer, index: integer): boolean)?): integer[] Returns an array of all vehicles, filtered by `vehicle_type` if provided. <br> `vehicle_type` can be a function, a vehicle type (client only) or vehicle class (server only). <br> If `vehicle_type` is a function, it will be used to filter the vehicles. <br> If `vehicle_type` is a number, it will filter the vehicles by their class. <br> Vehicle classes can be found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62). <br> If `vehicle_type` is a string, it will filter the vehicles by their type. <br> Vehicle types can be found [here](https://docs.fivem.net/natives/?_0xA273060E).
---@field getobjects fun(filter: (fun(object: integer, index: integer): boolean)?): integer[] Returns an array of all objects, filtered by `filter` if provided. <br> `filter` is a function used to filter the objects. <br> If not provided, all objects will be returned.
---@field getpickups fun(hash: string|number|(fun(pickup: integer, index: integer): boolean)?): integer[] Returns an array of all pickups, filtered by `hash` if provided. <br> `hash` can be a function, a string or a number. <br> If `hash` is a function, it will be used to filter the pickups. <br> If `hash` is a string or number, it will filter the pickups by their hash. <br> **Note:** This is a client-only function.
---@field getclosestped fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, ped_type: integer|(fun(ped: integer, index: integer): boolean)?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest ped to `check`. <br> `check` can be an entity, vector or a table. <br> `ped_type` can be a function or a number (client only). <br> If `ped_type` is a function, it will be used to filter the peds. <br> If `ped_type` is a number, it will filter the peds by their type, see [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C). <br> `radius` is the maximum distance within. <br> `excluding` is the ped or array of peds to exclude from the search.
---@field getclosestvehicle fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, vehicle_type: integer|string|(fun(vehicle: integer, index: integer): boolean)?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest vehicle to `check`. <br> `check` can be an entity, vector or a table. <br> `vehicle_type` can be a function, a number (client only) or a string (server only). <br> If `vehicle_type` is a function, it will be used to filter the vehicles. <br> If `vehicle_type` is a number, it will filter the vehicles by their class, see [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62). <br> If `vehicle_type` is a string, it will filter the vehicles by their type, see [here](https://docs.fivem.net/natives/?_0xA273060E). <br> `radius` is the maximum distance within. <br> `excluding` is the vehicle or array of vehicles to exclude from the search.
---@field getclosestobject fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, filter: (fun(object: integer, index: integer): boolean)?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest object to `check`. <br> `check` can be an entity, vector or a table. <br> `filter` is a function used to filter the objects. <br> `radius` is the maximum distance within. <br> `excluding` is the object or array of objects to exclude from the search.
---@field getclosestpickup fun(check: integer|vector|{x: number, y: number, z: number}|number[]?, hash: string|number|(fun(pickup: integer, index: integer): boolean)?, radius: number?, excluding: integer|integer[]): integer?, number?, integer[]? Finds the closest pickup to `check`. <br> `check` can be an entity, vector or a table. <br> `hash` can be a function, a string or a number. <br> If `hash` is a function, it will be used to filter the pickups. <br> If `hash` is a string or number, it will filter the pickups by their hash. <br> **Note:** This is a client-only function.
do
  local load, load_resource_file = load, LoadResourceFile
  local require = duff?.package.require or load(load_resource_file('duff', 'shared/package.lua'), '@duff/shared/package.lua', 't', _ENV)().require
  local array, vector = duff?.array or require 'duff.shared.array', duff?.vector or require 'duff.shared.vector'
  local filter = array.filter
  local to_vec, get_closest = vector.tovec, vector.getclosest
  local type = type
  local get_pool, get_coords = GetGamePool, GetEntityCoords
  local is_server = IsDuplicityVersion() == 1
  local all_peds, all_vehs, all_objs = is_server and GetAllPeds or nil, is_server and GetAllVehicles or nil, is_server and GetAllObjects or nil

  ---@param fn any The value to check if it is a function.
  ---@return boolean is_func the value is a function or not.
  local function is_fun(fn)
    local fn_type = type(fn)
    return fn_type == 'function' or fn_type == 'table' and (getmetatable(fn) and getmetatable(fn).__call or rawget(fn, '__cfx_functionReference'))
  end

  ---@param ped_type integer|(fun(ped: integer, index: integer): boolean)? Can be a filter function or a ped type (client only). <br> If `ped_type` is a function with the signature `(ped: integer, index: integer): boolean`, it will be used to filter the peds. <br> If `ped_type` is a number, it will filter the peds by their type. <br> `ped_type` can be found [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C).
  ---@return integer[] peds An array of all peds, filtered by `ped_type` if provided.
  local function get_peds(ped_type)
    local is_func = is_fun(ped_type)
    if is_server then
      if not all_peds then error('error calling \'getpeds\' (native at index _0xB8584FEF not found)', 2) end ---@cast all_peds -?
      if ped_type and not is_func then --[[@cast ped_type -function]] error('bad argument #1 to \'getpeds\' (expected nil or function, got '..type(ped_type)..')', 2) end
    end
    local def_filter = not is_func --[[@cast ped_type +integer|-function]] and function(ped, index) return not ped_type or GetPedType(ped) == ped_type end or ped_type  --[[@as fun(ped: integer, index: integer): boolean]]
    local peds = is_server --[[@cast all_peds -?]] and all_peds() --[[@as integer[]=]] or get_pool('CPed') --[[@as integer[]=]]
    if not peds or not next(peds) then warn('error calling \'getpeds\' (no peds found)') end
    return filter(peds, def_filter, true)
  end

  ---@param vehicle_type integer|string|(fun(vehicle: integer, index: integer): boolean)? Can be a filter function, a vehicle type (client only) or vehicle class (server only). <br> If `vehicle_type` is a function with the signature `(vehicle: integer, index: integer): boolean`, it will be used to filter the vehicles. <br> If `vehicle_type` is a number, it will filter the vehicles by their class. <br> Vehicle classes can be found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62). <br> If `vehicle_type` is a string, it will filter the vehicles by their type. <br> Vehicle types can be found [here](https://docs.fivem.net/natives/?_0xA273060E).
  ---@return integer[] vehicles An array of all vehicles, filtered by `vehicle_type` if provided.
  local function get_vehicles(vehicle_type)
    local param_type = type(vehicle_type)
    local is_func = is_fun(vehicle_type)
    local def_filter ---@type fun(vehicle: integer, index: integer): boolean
    if is_server then
      if not all_vehs then error('error calling \'getvehicles\' (native at index _0x332169F5 not found)', 2) end ---@cast all_vehs -?
      if GetNumPlayerIndices() == 0 then return {} end
      if vehicle_type and not is_func and param_type ~= 'string' then --[[@cast vehicle_type -function]] error('bad argument #1 to \'getvehicles\' (expected nil, string or function, got '..type(vehicle_type)..')', 2) end
      def_filter = not is_func --[[@cast vehicle_type +integer|-function]] and function(vehicle, index) return not vehicle_type or GetVehicleType(vehicle) == vehicle_type end or vehicle_type --[[@as fun(vehicle: integer, index: integer): boolean]]
    else
      if vehicle_type and not is_func and param_type ~= 'number' then --[[@cast vehicle_type -function]] error('bad argument #1 to \'getvehicles\' (expected nil, number or function, got '..type(vehicle_type)..')', 2) end
      def_filter = not is_func --[[@cast vehicle_type +integer|-function]] and function(vehicle, index) return not vehicle_type or GetVehicleClass(vehicle) == vehicle_type end or vehicle_type --[[@as fun(vehicle: integer, index: integer): boolean]]
    end
    local vehicles = is_server --[[@cast all_vehs -?]] and all_vehs() --[[@as integer[]=]] or get_pool('CVehicle') --[[@as integer[]=]]
    if not vehicles or not next(vehicles) then warn('error calling \'getvehicles\' (no vehicles found)') end
    return filter(vehicles, def_filter, true)
  end

  ---@param filter_fn (fun(object: integer, index: integer): boolean)? The function to filter the objects. <br> If not provided, all objects will be returned.
  ---@return integer[] objects An array of all objects, filtered by `filter_fn` if provided.
  local function get_objects(filter_fn)
    if is_server and not all_objs then error('error calling \'getobjects\' (native at index _0x6886C3FE not found)', 2) end ---@cast all_objs -?
    if filter_fn and not is_fun(filter_fn) then error('bad argument #1 to \'getobjects\' (expected nil or function, got '..type(filter_fn)..')', 2) end
    local objs = is_server --[[@cast all_objs -?]] and all_objs() --[[@as integer[]=]] or get_pool('CObject') --[[@as integer[]=]]
    if not objs or not next(objs) then warn('error calling \'getobjects\' (no objects found)') end
    return filter(objs, filter_fn, true)
  end

  ---@param hash (fun(pickup: integer, index: integer): boolean)|string|number|? The function to filter the pickups, the hash of the pickup to filter by or `nil`. <br> If `hash` is a function with the signature `(pickup: integer, index: integer): boolean`, it will be used to filter the pickups. <br> If `hash` is a string or number, it will filter the pickups by their hash. <br> If `hash` is `nil`, all pickups will be returned.
  ---@return integer[] pickups An array of all pickups, filtered by `hash` if provided.
  local function get_pickups(hash) -- **Note**: This is a client-only function.
    if is_server then error('called a client only function \'%s\'', 0) end
    local param_type = type(hash)
    local is_str = param_type == 'string'
    local is_num = param_type == 'number'
    local is_func = is_fun(hash)
    if hash and not is_str and not is_num and not is_func then error('bad argument #1 to \'getpickups\' (expected nil, string, number or function, got '..param_type..')', 2) end
    local hash_key = param_type == 'string' and joaat(hash) or param_type == 'number' and hash or nil
    local def_filter = not is_func and function(pickup, index) return not hash_key or GetPickupHash(pickup) == hash_key end or hash --[[@as fun(pickup: integer, index: integer): boolean]]
    return filter(get_pool('CPickup'), def_filter, true)
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used (client only).
  ---@param ped_type integer|(fun(ped: integer, index: integer): boolean)? The function to filter the peds, the type of ped to filter (client only). <br> If `ped_type` is a function with the signature `(ped: integer, index: integer): boolean`, it will be used to filter the peds. <br> If `ped_type` is a number, it will filter the peds by their type. <br> If `ped_type` is `nil`, all peds will be searched.
  ---@param radius number? The maximum distance to search within.
  ---@param excluding integer|integer[]? The ped or array of peds to exclude from the search.
  ---@return integer? ped, number? dist, integer[]? peds The closest ped to `check`, the distance to the closest ped and an array of all peds within `radius`.
  local function get_closest_ped(check, ped_type, radius, excluding)
    check = check and to_vec(check) or not is_server and get_coords(PlayerPedId()) --[[@as vector3]]
    if not check then error('bad argument #1 to \'getclosestped\' (entity, vector or table expected, got '..type(check)..')', 2) end
    local ped, dist, peds = get_closest(check, get_peds(ped_type --[[@as any]]), radius, excluding)
    return ped --[[@as integer]], dist, peds
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used (client only). 
  ---@param vehicle_type integer|string|(fun(vehicle: integer, index: integer): boolean)? The function to filter the vehicles, the type of vehicle to filter (client only) or the class of vehicle to filter (server only). <br> If `vehicle_type` is a function with the signature `(vehicle: integer, index: integer): boolean`, it will be used to filter the vehicles. <br> If `vehicle_type` is a number, it will filter the vehicles by their class. <br> If `vehicle_type` is a string, it will filter the vehicles by their type. <br> If `vehicle_type` is `nil`, all vehicles will be searched.
  ---@param radius number? The maximum distance to search within.
  ---@param excluding integer|integer[]?
  ---@return integer? veh, number? dist, integer[]? vehs
  local function get_closest_vehicle(check, vehicle_type, radius, excluding)
    check = check and to_vec(check) or not is_server and get_coords(PlayerPedId()) --[[@as vector3]]
    if not check then error('bad argument #1 to \'getclosestvehicle\' (entity, vector or table expected, got '..type(check)..')', 2) end
    local veh, dist, vehs = get_closest(check, get_vehicles(vehicle_type --[[@as any]]), radius, excluding)
    return veh --[[@as integer]], dist, vehs
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used (client only).
  ---@param filter_fn (fun(object: integer, index: integer): boolean)? The function to filter the objects. <br> If not provided, all objects will be searched.
  ---@param radius number? The maximum distance to search within.
  ---@param excluding integer|integer[]? The object or array of objects to exclude from the search.
  ---@return integer? obj, number? dist, integer[]? objs
  local function get_closest_object(check, filter_fn, radius, excluding)
    check = check and to_vec(check) or not is_server and get_coords(PlayerPedId()) --[[@as vector3]]
    if not check then error('bad argument #1 to \'getclosestobject\' (entity, vector or table expected, got '..type(check)..')', 2) end
    local obj, dist, objs = get_closest(check, get_objects(filter_fn), radius, excluding)
    return obj --[[@as integer]], dist, objs
  end

  ---@param check integer|vector|{x: number, y: number, z: number}|number[]? The entity, vector or table to check the distance from. <br> If not provided, the player's coords will be used.
  ---@param hash string|number|(fun(pickup: integer, index: integer): boolean)? The function to filter the pickups, the hash of the pickup to filter by or `nil`. <br> If `hash` is a function with the signature `(pickup: integer, index: integer): boolean`, it will be used to filter the pickups. <br> If `hash` is a string or number, it will filter the pickups by their hash. <br> If `hash` is `nil`, all pickups will be searched.
  ---@param radius number? The maximum distance to search within.
  ---@param excluding string|number|(string|number)[]? The pickup or array of pickups to exclude from the search.
  ---@return integer? pickup, number? dist, integer[]? pickups The closest pickup to `check`, the distance to the closest pickup and an array of all pickups within `radius`.
  local function get_closest_pickup(check, hash, radius, excluding) -- **Note**: This is a client-only function.
    if is_server then error('called a client only function \'getclosestpickup\'', 2) end
    check = check and to_vec(check) or get_coords(PlayerPedId()) --[[@as vector3]]
    local pickup, dist, pickups = get_closest(check, get_pickups(hash --[[@as any]]), radius, excluding)
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