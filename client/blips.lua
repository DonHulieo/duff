---@class CBlips
---@field GetAll fun(): integer[]
---@field GetOnScreen fun(): integer[]
---@field ByCoords fun(coords: vector3|vector3[], radius: number?): integer[]
---@field BySprite fun(sprite: integer): integer[]
---@field ByType fun(id_type: integer): integer[]
---@field Remove fun(blips: integer|integer[])
local CBlips do
  local does_blip_exist = DoesBlipExist
  local require = require
  local array = require 'duf.shared.array'
  local check_type = CheckType
  local error = error
  local get_closest = require('duf.shared.vector').GetClosest

  ---@return CArray blips An array of all currently active blip handles | Credits go to: negbook, https://github.com/negbook/nbk_blips
  local function get_all_blips()
    local blips = array{}
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
    return get_all_blips():filter(IsBlipOnMinimap, array.IN_PLACE)
  end

  ---@param coords vector3|vector3[]
  ---@param radius number?
  ---@return CArray blips An array of all currently active blip handles that are within the specified coordinates
  local function blipsByCoords(coords, radius)
    local bool, param_type = check_type(coords, 'vector3')
    if not bool and param_type ~= 'table' then error('bad argument #1 to \'ByCoords\' (vector3 or table expected, got ' ..param_type.. ')') end
    radius = radius or 1.0
    return get_all_blips():filter(function(blip)
      local blip_coords = GetBlipCoords(blip)
      if param_type == 'vector3' then
        return #(coords - blip_coords) <= radius
      else
        local _, dist = get_closest(blip_coords, coords)
        return dist <= radius
      end
    end, array.IN_PLACE)
  end

  ---@param sprite integer
  ---@return CArray blips An array of all currently active blip handles that have the specified sprite
  local function blipsBySprite(sprite)
    local bool, param_type = check_type(sprite, 'number')
    if not bool then error('bad argument #1 to \'BySprite\' (number expected, got ' ..param_type.. ')') end
    return get_all_blips():filter(function(blip) return GetBlipSprite(blip) == sprite end, array.IN_PLACE)
  end

  ---@enum (key) id_types
  local id_types = array{true, true, true, true, true, true, true}:setenum()
  ---@param id_type integer {1, 2, 3, 4, 5, 6, 7}
  ---@return CArray blips An array of all currently active blip handles that have the specified type
  local function blipsByType(id_type)
    if not check_type(id_type, 'number') or not id_types[id_type] then error('bad argument #1 to \'ByType\' (invalid id_type, got ' ..id_type.. ')') end
    return get_all_blips():filter(function(blip) return GetBlipInfoIdType(blip) == id_type end, array.IN_PLACE)
  end

  ---@param blips integer|integer[]
  local function removeBlips(blips)
    local bool, param_type = check_type(blips, 'table')
    if not bool and param_type ~= 'number' then error('bad argument #1 to \'Remove\' (table or number expected, got ' ..param_type.. ')') end
    blips = bool and array(blips) or array{blips} ---@cast blips -integer
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
    blips:foreach(function(blip)
      if does_blip_exist(blip) then RemoveBlip(blip) end
    end)
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(false)
  end

  return {GetAll = get_all_blips, GetOnScreen = onScreenBlips, ByCoords = blipsByCoords, BySprite = blipsBySprite, ByType = blipsByType, Remove = removeBlips}
end