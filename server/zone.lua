---@class zone
---@field contains fun(check: vector3|{x: number, y: number, z: number}|string): boolean?, integer?
---@field getzone fun(index: integer): table?
---@field getzonename fun(check: vector3|{x: number, y: number, z: number}|string): string?
---@field getzoneindex fun(check: vector3|{x: number, y: number, z: number}|string): integer?
---@field addzoneevent fun(event: string, zone_id: vector3|{x: number, y: number, z: number}|string, onEnter: fun(player: string, coords: vector3), onExit: fun(player: string, coords: vector3, disconnected: boolean?), time: integer?, player: string?)
---@field removezoneevent fun(event: string)
local zone do
  local ZONES = json.decode(LoadResourceFile('duf', 'data/zones.json'))
  local check_type = require('duff.shared.debug').checktype
  local convert_to_vec = require('duff.shared.vector').tabletovector
  local Listeners = {}

  ---@param index integer
  ---@param coords vector3|{x: number, y: number, z: number}
  ---@return boolean
  local function check_bounds(index, coords)
    local bounds = ZONES[index].Bounds
    local x, y, z = coords.x, coords.y, coords.z
    for i = 1, #bounds do
      local min, max = bounds[i].Minimum, bounds[i].Maximum
      local xMin, yMin, zMin, xMax, yMax, zMax = min.X, min.Y, min.Z, max.X, max.Y, max.Z
      if x >= xMin and x <= xMax and y >= yMin and y <= yMax and z >= zMin and z <= zMax then return true end
    end
    return false
  end

  ---@param check vector3|{x: number, y: number, z: number}|string
  ---@return boolean?, integer?
  local function contains(check)
    local bool, param_type = check_type(check, {'vector3', 'table', 'string'}, contains, 1)
    if not bool then return end
    check = param_type == 'table' and convert_to_vec(check--[[@as table]]) or param_type == 'string' and check--[[@as string]]:upper() or check
    if not check then return end
    local isVec = type(check) == 'vector3'
    local x, y, z = isVec and check.x, isVec and check.y, isVec and check.z
    for i = 1, #ZONES do
      local zone_data = ZONES[i]
      if x and y and z and param_type ~= 'string' then
        if check_bounds(i, check--[[@as table|vector3]]) then return true, i end
      elseif param_type == 'string' then
        if zone_data.Name:upper() == check or zone_data.DisplayName:upper() == check then return true, i end
      end
    end
    return false
  end

  ---@param index integer
  ---@return table?
  local function get_zone(index)
    return ZONES[index]
  end

  ---@param coords vector3|{x: number, y: number, z: number}|string
  ---@return string? name
  local function get_name_of_zone(coords)
    if not check_type(coords, {'vector3', 'table'}, get_name_of_zone, 1) then return end
    local bool, index = contains(coords)
    return bool and ZONES[index].Name:upper() or nil
  end

  ---@param coords vector3|{x: number, y: number, z: number}|string
  ---@return integer? index
  local function get_index_of_zone(coords)
    if not check_type(coords, {'vector3', 'table'}, get_index_of_zone, 1) then return end
    local bool, index = contains(coords)
    return bool and index or nil
  end

  ---@param event string
  ---@param zone_id vector3|{x: number, y: number, z: number}|string
  ---@param onEnter fun(player: string, coords: vector3)
  ---@param onExit fun(player: string, coords: vector3, disconnected: boolean?)
  ---@param time integer?
  ---@param player string?
  local function add_zone_event(event, zone_id, onEnter, onExit, time, player)
    if not check_type(event, 'string', add_zone_event, 1) then return end
    if not check_type(zone, 'string', add_zone_event, 2) then return end
    if not check_type(onEnter, 'function', add_zone_event, 3) then return end
    if not check_type(onExit, 'function', add_zone_event, 4) then return end
    if time and not check_type(time, 'integer', add_zone_event, 5) then return end
    if player and not check_type(player, 'string', add_zone_event, 6) then return end
    local index = get_index_of_zone(zone_id)
    if not index or Listeners[event] then return end
    Listeners[event] = {players = {}}
    local Players = GetPlayers()
    local sleep = time or 500
    CreateThread(function()
      while Listeners[event] do
        Wait(sleep)
        for _, player_src in pairs(Players) do
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
                      onEnter(player_src, coords)
                    end
                  elseif entered then
                    entered = false
                    Listeners[event].players[player_src] = false
                    onExit(player_src, coords)
                  end
                  Wait(sleep)
                  coords = GetEntityCoords(ped)
                end
                if entered then onExit(player_src, coords, true) end
              end
              Listeners[event].players[player_src] = nil
            end)
          end
        end
        Players = GetPlayers()
      end
    end)
  end

  ---@param event string
  local function remove_zone_event(event)
    if not check_type(event, 'string', remove_zone_event, 1) then return end
    if Listeners[event] then Listeners[event] = nil end
  end

  return {
    contains = contains,
    getzone = get_zone,
    getzonename = get_name_of_zone,
    getzoneindex = get_index_of_zone,
    addzoneevent = add_zone_event,
    removezoneevent = remove_zone_event
  }
end