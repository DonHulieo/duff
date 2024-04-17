---@class CMZone (To Not Clash w/ ox_lib's CZone)
---@field Contains fun(check: vector3|{x: number, y: number, z: number}|string): boolean?, integer?
---@field GetZone fun(index: integer): table?
---@field GetNameOfZone fun(coords: vector3|{x: number, y: number, z: number}): string?
---@field GetZoneAtCoords fun(coords: vector3|{x: number, y: number, z: number}): integer?
---@field GetZoneFromNameId fun(name: string): integer?
---@field AddZoneEvent fun(event: string, zone: string, onEnter: fun(player: string, coords: vector3), onExit: fun(player: string, coords: vector3, disconnected: boolean?), time: integer?, player: string?)
---@field RemoveZoneEvent fun(event: string)
local CMZone do
  local ZONES = json.decode(LoadResourceFile('duf', 'data/zones.json'))
  local check_type = require('shared.debug').checktype
  local convert_to_vec = require('shared.vector').tabletovector
  local Listeners = {}

  ---@param index integer
  ---@param coords vector3|{x: number, y: number, z: number}
  ---@return boolean
  local function check_bounds(index, coords)
    local bounds = ZONES[index].Bounds
    local x, y, z in coords
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
      local zone = ZONES[i]
      if x and y and z and param_type ~= 'string' then
        if check_bounds(i, check--[[@as table|vector3]]) then return true, i end
      elseif param_type == 'string' then
        if zone.Name:upper() == check or zone.DisplayName:upper() == check then return true, i end
      end
    end
    return false
  end

  ---@param index integer
  ---@return table?
  local function getZone(index)
    return ZONES[index]
  end

  ---@param coords vector3|{x: number, y: number, z: number}
  ---@return string? name
  local function getNameOfZone(coords)
    if not check_type(coords, {'vector3', 'table'}, getNameOfZone, 1) then return end
    local bool, index = contains(coords)
    return bool and ZONES[index].Name:upper() or nil
  end

  ---@param coords vector3|{x: number, y: number, z: number}
  ---@return integer? index
  local function getIndexOfZone(coords)
    if not check_type(coords, {'vector3', 'table'}, getIndexOfZone, 1) then return end
    local bool, index = contains(coords)
    return bool and index or nil
  end

  ---@param name string
  ---@return integer? index
  local function getZoneFromNameId(name)
    if not check_type(name, 'string', getZoneFromNameId, 1) then return end
    local bool, index = contains(name)
    return bool and index or nil
  end

  ---@param event string
  ---@param zone string
  ---@param onEnter fun(player: string, coords: vector3)
  ---@param onExit fun(player: string, coords: vector3, disconnected: boolean?)
  ---@param time integer?
  ---@param player string?
  local function addZoneEvent(event, zone, onEnter, onExit, time, player)
    if not check_type(event, 'string', addZoneEvent, 1) then return end
    if not check_type(zone, 'string', addZoneEvent, 2) then return end
    if not check_type(onEnter, 'function', addZoneEvent, 3) then return end
    if not check_type(onExit, 'function', addZoneEvent, 4) then return end
    if time and not check_type(time, 'integer', addZoneEvent, 5) then return end
    if player and not check_type(player, 'string', addZoneEvent, 6) then return end
    local index = getZoneFromNameId(zone)
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
                Listeners[event].players[player_src] = nil
                if entered then onExit(player_src, coords, true) end
              end
            end)
          end
        end
      end
    end)
  end

  ---@param event string
  local function removeZoneEvent(event)
    if not check_type(event, 'string', removeZoneEvent, 1) then return end
    if Listeners[event] then Listeners[event] = nil end
  end

  return {
    Contains = contains,
    GetZone = getZone,
    GetNameOfZone = getNameOfZone,
    GetZoneAtCoords = getIndexOfZone,
    GetZoneFromNameId = getZoneFromNameId,
    AddZoneEvent = addZoneEvent,
    RemoveZoneEvent = removeZoneEvent
  }
end