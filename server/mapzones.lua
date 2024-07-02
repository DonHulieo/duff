---@class CMapZones
---@field contains fun(check: vector3|{x: number, y: number, z: number}|number[]): boolean, integer Returns whether `check` is within a zone and the index of the zone. <br> `check` can be vector3, a table with `x`, `y`, `z`, and `w` keys or an array with the same values.
---@field getzone fun(index: integer): {Name: string, DisplayName: string, Bounds: {Minimum: {X: number, Y: number, Z: number}, Maximum: {X: number, Y: number, Z: number}}}? Returns the zone data at `index`. <br> `index` is the index of the zone.
---@field getzonename fun(coords: vector3|{x: number, y: number, z: number}|number[]): string Returns the name of the zone. <br> `check` can be vector3, a table with `x`, `y`, `z`, and `w` keys or an array with the same values.
---@field getzoneindex fun(coords: vector3|{x: number, y: number, z: number}|number[]): integer Returns the index of the zone. <br> `check` can be vector3, a table with `x`, `y`, `z`, and `w` keys or an array with the same values.
---@field getzonefromname fun(name: string): integer Returns the index of the zone. <br> `name` is the name of the zone.
---@field addzoneevent fun(event: string, zone_id: integer|vector3|{x: number, y: number, z: number}|number[]|string, onEnter: fun(player: string, coords: vector3)?, onExit: fun(player: string, coords: vector3, disconnected: boolean?)?, time: integer?, player: string?) Adds an event to a zone. <br> `zone_id` can be vector3, a table with `x`, `y`, `z`, and `w` keys, an array with the same values, the name or the index of the zone. <br> `onEnter` is the function to call when a player enters the zone. <br> `onExit` is the function to call when a player exits the zone. <br> `time` is the time to wait between checks in milliseconds. <br> `player` is the player to add the event for.
---@field removezoneevent fun(event: string) Removes the event from the zone. <br> `event` is the name of the event.
do
  local load, load_resource_file = load, LoadResourceFile
  local vector = duff?.vector or load(load_resource_file('duff', 'shared/vector.lua'), '@duff/shared/vector.lua', 't', _ENV)()
  local to_vec, is_vec = vector.tovec, vector.isvec
  local ZONES = json.decode(load_resource_file('duff', 'data/zones.json'))
  local current_resource = GetCurrentResourceName()
  local Listeners, Players = {}, GetPlayers()

  ---@param resource string
  local function deinit_zones(resource)
    if resource ~= current_resource then return end
    table.wipe(Players)
    Listeners = nil
  end

  ---@param string any The string to check.
  ---@return string string The string if it is a string, otherwise the string representation of the value.
  local function ensure_string(string)
    return type(string) ~= 'string' and tostring(string) or string
  end

  ---@param index integer The index of the zone.
  ---@param coords vector3|{x: number, y: number, z: number}|number[] The coordinates to check.
  ---@return boolean in_bounds Returns whether `coords` is within the bounds of the zone.
  local function check_bounds(index, coords) -- Internal function to check if the coordinates are within the bounds of the zone.
    local bounds = ZONES[index].Bounds
    local x, y, z = coords.x, coords.y, coords.z
    for i = 1, #bounds do
      local min, max = bounds[i].Minimum, bounds[i].Maximum
      local xMin, yMin, zMin, xMax, yMax, zMax = min.X, min.Y, min.Z, max.X, max.Y, max.Z
      if x >= xMin and x <= xMax and y >= yMin and y <= yMax and z >= zMin and z <= zMax then return true end
    end
    return false
  end

  ---@param coords vector3|{x: number, y: number, z: number}|number[]  The value to check. <br> Can be vector3, a table with `x`, `y`, `z`, and `w` keys or an array with the same values.
  ---@return boolean contains, integer index Returns whether `check` is within a zone and the index of the zone.
  local function contains(coords)
    local param_type = type(coords)
    coords = param_type ~= 'vector3' and to_vec(coords) or coords --[[@as vector3]]
    if not coords or not is_vec(coords) then error('bad argument #1 to \'contains\' (vector3 or table expected, got '..param_type..')', 2) end
    local does_contain, index = false, 0
    for i = 1, #ZONES do
      if check_bounds(i, coords) then does_contain, index = true, i break end
    end
    return does_contain, index
  end

  ---@param index integer The index of the zone.
  ---@return {Name: string, DisplayName: string, Bounds: {Minimum: {X: number, Y: number, Z: number}, Maximum: {X: number, Y: number, Z: number}}}? zone Returns the zone data.
  local function get_zone(index)
    if type(index) ~= 'number' then error('bad argument #1 to \'getzone\' (number expected, got '..type(index)..')', 2) end
    return ZONES[index]
  end

  ---@param coords vector3|{x: number, y: number, z: number}|number[] The value to check. <br> Can be vector3, a table with `x`, `y`, `z`, and `w` keys or an array with the same values.
  ---@return string name Returns the name of the zone.
  local function get_name_of_zone(coords)
    if not coords or not is_vec(coords) then error('bad argument #1 to \'getzonename\' (vector3 or table expected, got '..type(coords)..')', 2) end
    local bool, index = contains(coords)
    return bool and ZONES[index].Name:upper() or 'UNKNOWN'
  end

  ---@param coords vector3|{x: number, y: number, z: number}|number[] The value to check. <br> Can be vector3, a table with `x`, `y`, `z`, and `w` keys or an array with the same values.
  ---@return integer index Returns the index of the zone.
  local function get_index_of_zone(coords)
    if not coords or not is_vec(coords) then error('bad argument #1 to \'getzoneindex\' (vector3 or table expected, got '..type(coords)..')', 2) end
    local bool, index = contains(coords)
    return bool and index or 0
  end

  ---@param name string The name of the zone.
  ---@return integer index Returns the index of the zone.
  local function get_index_from_name(name)
    if type(name) ~= 'string' then error('bad argument #1 to \'getzonefromname\' (string expected, got '..type(name)..')', 2) end
    local index = 0
    name = name:upper()
    for i = 1, #ZONES do
      local ZONE = ZONES[i]
      if ZONE.Name:upper() == name or ZONE.DisplayName:upper() == name then index = i break end
    end
    return index
  end

  local function on_joined()
    local src = ensure_string(source)
    if not src then return end
    Players[#Players + 1] = src
  end

  local function on_dropped()
    local src = ensure_string(source)
    if not src then return end
    for i = 1, #Players do
      if Players[i] == src then table.remove(Players, i) break end
    end
    for _, listener in pairs(Listeners) do
      if listener.players[src] then listener.players[src] = nil end
    end
  end

  ---@param event string The name of the event.
  ---@param zone_id integer|vector3|{x: number, y: number, z: number}|number[]|string The zone to add the event to. <br> Can be vector3, a table with `x`, `y`, `z`, and `w` keys, an array with the same values, the name or the index of the zone.
  ---@param onEnter fun(player: string, coords: vector3)? The function to call when a player enters the zone.
  ---@param onExit fun(player: string, coords: vector3, disconnected: boolean?)? The function to call when a player exits the zone.
  ---@param time integer? The time to wait between checks in milliseconds.
  ---@param player string? The player to add the event for.
  local function add_zone_event(event, zone_id, onEnter, onExit, time, player)
    if not event or type(event) ~= 'string' then error('bad argument #1 to \'addzoneevent\' (string expected, got '..type(event)..')', 2) end
    local zone_id_type = type(zone_id)
    if not zone_id or not (is_vec(zone_id --[[@as table|number[]|vector3]]) or zone_id_type == 'string') then error('bad argument #2 to \'addzoneevent\' (vector3 or string expected, got '..zone_id_type..')', 2) end
    local index = zone_id_type == 'number' and zone_id or zone_id_type ~= 'string' and get_index_of_zone(zone_id --[[@as number[]|vector3|{x: number, y: number, z: number}]]) or get_index_from_name(zone_id --[[@as string]])
    if index == 0 or not ZONES[index] then error('bad argument #2 to \'addzoneevent\' (zone not found)', 2) end
    if Listeners[event] then error('bad argument #1 to \'addzoneevent\' (event \''..event..'\' already exists)', 2) end
    Listeners[event] = {players = {}}
    local sleep = time or 500
    CreateThread(function()
      while Listeners[event] do
        Wait(2500)
        for i = 1, #Players do
          local player_src = Players[i]
          if (not player or player_src == player) and Listeners[event].players[player_src] == nil then
            CreateThread(function()
              Listeners[event].players[player_src] = true
              repeat Wait(1000) until not DoesPlayerExist(player_src) or GetPlayerPed(player_src) ~= 0
              if DoesPlayerExist(player_src) then
                local ped = GetPlayerPed(player_src)
                local coords = GetEntityCoords(ped)
                local entered = false
                while DoesEntityExist(ped) do
                  if check_bounds(index, coords) then
                    if not entered then
                      entered = true
                      Listeners[event].players[player_src] = true
                      if onEnter then onEnter(player_src, coords) end
                    end
                  elseif entered then
                    entered = false
                    Listeners[event].players[player_src] = false
                    if onExit then onExit(player_src, coords) end
                  end
                  Wait(sleep)
                  coords = GetEntityCoords(ped)
                end
                if entered and onExit then onExit(player_src, coords, true) end
              end
              Listeners[event].players[player_src] = nil
            end)
          end
        end
        Players = Players
      end
    end)
  end

  ---@param event string The name of the event.
  local function remove_zone_event(event)
    if not event or type(event) ~= 'string' then error('bad argument #1 to \'removezoneevent\' (string expected, got '..type(event)..')', 2) end
    if Listeners[event] then Listeners[event] = nil end
  end

  -------------------------------- INTERNAL HANDLERS --------------------------------
  AddEventHandler('onResourceStop', deinit_zones)
  AddEventHandler('playerJoining', on_joined)
  AddEventHandler('playerDropped', on_dropped)
  -----------------------------------------------------------------------------------
  return {
    contains = contains,
    getzone = get_zone,
    getzonename = get_name_of_zone,
    getzoneindex = get_index_of_zone,
    getzonefromname = get_index_from_name,
    addzoneevent = add_zone_event,
    removezoneevent = remove_zone_event
  }
end