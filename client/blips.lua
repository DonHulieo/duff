---@class CBlips
---@field GetAll fun(): integer[]
---@field GetOnScreen fun(): integer[]
---@field ByCoords fun(coords: vector3|vector3[], radius: number?): integer[]
---@field BySprite fun(sprite: integer): integer[]
---@field ByType fun(id_type: integer): integer[]
---@field GetInfo fun(blip: integer): table
---@field Remove fun(blips: integer|integer[])
local CBlips do
  local require = require
  ---@module 'duf.shared.array'
  local array = require 'shared.array'
  local check_type = require('shared.debug').checktype
  local does_blip_exist = DoesBlipExist
  local get_closest = require('shared.vector').GetClosest

  ---@return CArray blips An array of all currently active blip handles
  local function get_all_blips() -- Credits go to: [negbook](https://github.com/negbook/nbk_blips)
    local blips = array.new{}
    for i = 0, 883 do -- 884 is the max number of default blips b3095, if you have custom blips you need to increase this number
      local blip = GetFirstBlipInfoId(i)
      local exists = does_blip_exist(blip)
      while exists do
        blips:push(blip)
        blip = GetNextBlipInfoId(i)
        exists = does_blip_exist(blip)
        if not exists then break end
      end
    end
    return blips
  end

  ---@return CArray blips An array of all currently active blip handles that are on the minimap
  local function onScreenBlips()
    return get_all_blips():filter(IsBlipOnMinimap, true)
  end

  ---@param coords vector3|vector3[]
  ---@param radius number?
  ---@return CArray? blips An array of all currently active blip handles that are within the specified coordinates
  local function blipsByCoords(coords, radius)
    local bool, param_type = check_type(coords, {'vector3', 'table'}, blipsByCoords, 1)
    if not bool then return end
    radius = radius or 1.0
    return get_all_blips():filter(function(blip)
      local blip_coords = GetBlipCoords(blip)
      if param_type == 'vector3' then
        return #(coords - blip_coords) <= radius
      else
        local _, dist = get_closest(blip_coords, coords)
        return dist <= radius
      end
    end, true)
  end

  ---@param sprite integer
  ---@return CArray? blips An array of all currently active blip handles that have the specified sprite
  local function blipsBySprite(sprite)
    if check_type(sprite, 'number', blipsBySprite, 1) then return end
    return get_all_blips():filter(function(blip) return GetBlipSprite(blip) == sprite end, true)
  end

  ---@enum (key) id_types
  local id_types = array.new{true, true, true, true, true, true, true}:setenum()
  ---@param id_type integer {1, 2, 3, 4, 5, 6, 7}
  ---@return CArray? blips An array of all currently active blip handles that have the specified type
  local function blipsByType(id_type)
    if not check_type(id_type, 'number', blipsByType, 1) or not id_types[id_type] then return end
    return get_all_blips():filter(function(blip) return GetBlipInfoIdType(blip) == id_type end, true)
  end

  ---@param blip integer
  ---@return table? blip_info
  local function getBlipInfo(blip)
    if not check_type(blip, 'number', getBlipInfo, 1) or not does_blip_exist(blip) then return end
    return {
      alpha = GetBlipAlpha(blip),
      coords = GetBlipCoords(blip),
      colour = GetBlipColour(blip),
      display = GetBlipInfoIdDisplay(blip),
      fade = N_0x2c173ae2bdb9385e(blip),
      hud_colour = GetBlipHudColour(blip),
      type = GetBlipInfoIdType(blip),
      rotation = GetBlipRotation(blip),
      is_shortrange = IsBlipShortRange(blip),
    }
  end

  ---@param blips integer|integer[]
  local function removeBlips(blips)
    local bool, param_type = check_type(blips, {'table', 'number'}, removeBlips, 1)
    if not bool then return end
    blips = param_type == 'table' and array.new(blips--[[@as integer[]?]]) or array.new{blips}
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
    blips:foreach(function(blip)
      if does_blip_exist(blip) then RemoveBlip(blip) end
    end)
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(false)
  end

  return {GetAll = get_all_blips, GetOnScreen = onScreenBlips, ByCoords = blipsByCoords, BySprite = blipsBySprite, ByType = blipsByType, GetInfo = getBlipInfo, Remove = removeBlips}
end