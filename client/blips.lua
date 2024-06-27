---@class CBlips
---@field getall fun(): integer[] Returns an array of all active blip handles. <br> Credits go to: [negbook](https://github.com/negbook/nbk_blips).
---@field onscreen fun(): integer[] Returns an array of all active blip handles that are on the minimap.
---@field bycoords fun(coords: vector3|vector3[], radius: number?): integer[]? Finds all active blip handles at `coords` within `radius`. <br> `coords` can be a vector3 or any array of vector3's. <br> If `radius` is not provided, it defaults to `1.0`.
---@field bysprite fun(sprite: integer): integer[]? Finds all active blip handles with `sprite`.
---@field bytype fun(id_type: integer): integer[]? Finds all active blip handles with `id_type`.
---@field getblips fun(filter: fun(blip: integer, index: integer): boolean): integer[] Finds all active blip handles that pass `filter`.
---@field getinfo fun(blip: integer): {alpha: integer, coords: vector3, colour: integer, display: integer, fade: boolean, hud_colour: integer, type: integer, rotation: number, is_shortrange: boolean}? Returns information about `blip`.
---@field remove fun(blips: integer|integer[]) Removes `blips` from the map. <br> If `blips` is a number, it removes that blip. <br> If `blips` is an array, it removes all blips in the array.
do
  local load, load_resource_file = load, LoadResourceFile
  local load_module = function(module) return load(load_resource_file('duff', 'shared/'..module..'.lua'), '@duff/shared/'..module..'.lua', 't', _ENV)() end
  local array, vector = duff?.array or load_module('array'), duff?.vector or load_module('vector')
  local push, filter = array.push, array.filter
  local get_closest = vector.getclosest
  local does_blip_exist = DoesBlipExist
  local type, error = type, error

  ---@return integer[] blip_ids An array of all active blip handles.
  local function get_all() -- Credits go to: [negbook](https://github.com/negbook/nbk_blips)
    local blip_ids = {}
    for i = 0, 883 do -- 884 is the max number of default blips b3095, if you have custom blips you need to increase this number
      local blip = GetFirstBlipInfoId(i)
      local exists = does_blip_exist(blip)
      while exists do
        blip_ids = push(blip_ids, blip)
        blip = GetNextBlipInfoId(i)
        exists = does_blip_exist(blip)
        if not exists then break end
      end
    end
    return blip_ids
  end

  ---@return integer[]? blip_ids An array of all active blip handles that are on the minimap.
  local function on_screen()
    return filter(get_all(), IsBlipOnMinimap, true)
  end

  ---@param coords vector3|vector3[] The coordinates to search for blips. <br> Can be a vector3 or any array of vector3's.
  ---@param radius number? The radius to search for blips. <br> Defaults to `1.0`.
  ---@return integer[]? blip_ids An array of all active blip handles at `coords` within `radius`.
  local function by_coords(coords, radius)
    local param_type = type(coords)
    if not coords or (param_type ~= 'vector3' and param_type ~= 'table') then error('bad argument to \'%s\' (expected vector3 or table, got '..param_type, 0) end
    radius = radius or 1.0
    return filter(get_all(), function(blip_id)
      local blip_coords = GetBlipCoords(blip_id)
      param_type = type(coords)
      if param_type == 'vector3' then
        return #(coords - blip_coords) <= radius
      else
        local _, dist = get_closest(blip_coords, coords)
        return dist <= radius
      end
    end, true)
  end

  ---@param sprite integer The sprite to search for.
  ---@return integer[]? blip_ids An array of all active blip handles with `sprite`.
  local function by_sprite(sprite)
    if not sprite or type(sprite) ~= 'number' then error('bad argument to \'%s\' (expected number, got '..type(sprite), 0) end
    return filter(get_all(), function(blip) return GetBlipSprite(blip) == sprite end, true)
  end

  ---@enum (key) id_types
  local id_types = array.setenum{true, true, true, true, true, true, true}
  ---@param id_type integer The blip type to search for. <br> Can be; `1`, `2`, `3`, `4`, `5`, `6`, `7`. <br> See [GetBlipInfoIdType](https://docs.fivem.net/natives/?_0xBE9B0959FFD0779B) for more information.
  ---@return integer[]? blip_ids An array of all active blip handles with `id_type`.
  local function by_type(id_type)
    if not id_types[id_type] then error('bad argument to \'%s\' (expected number, got '..type(id_type), 0) end
    return filter(get_all(), function(blip) return GetBlipInfoIdType(blip) == id_type end, true)
  end

  ---@param fn fun(blip: integer, index: integer): boolean The function to filter blips.
  ---@return integer[] blip_ids An array of all active blip handles that pass `filter`.
  local function get_blips(fn)
    return filter(get_all(), fn, true)
  end

  ---@param blip integer The blip handle to get information about.
  ---@return {alpha: integer, coords: vector3, colour: integer, display: integer, fade: boolean, hud_colour: integer, type: integer, rotation: number, is_shortrange: boolean}? info Information about `blip`.
  local function get_info(blip)
    if not blip or type(blip) ~= 'number' then error('bad argument to \'%s\' (expected number, got '..type(blip), 0) end
    if not does_blip_exist(blip) then error('bad argument to \'%s\' (blip does not exist)', 0) end
    return {
      alpha = GetBlipAlpha(blip),
      coords = GetBlipCoords(blip),
      colour = GetBlipColour(blip),
      display = GetBlipInfoIdDisplay(blip),
      fade = N_0x2c173ae2bdb9385e(blip),
      hud_colour = GetBlipHudColour(blip),
      type = GetBlipInfoIdType(blip),
      rotation = GetBlipRotation(blip),
      is_shortrange = IsBlipShortRange(blip) == 1,
    }
  end

  ---@param blip_ids integer|integer[] The blip handle(s) to remove. <br> If `blip_ids` is a number, it removes that blip. <br> If `blip_ids` is an array, it removes all blips in the array.
  local function remove_blips(blip_ids)
    local param_type = type(blip_ids)
    if not blip_ids or (param_type ~= 'number' and param_type ~= 'table') then error('bad argument to \'%s\' (expected number or table, got '..param_type, 0) end
    blip_ids = param_type == 'table' and blip_ids or {blip_ids--[[@as integer]]} --[[@as integer[]=]]
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
    for i = 1, #blip_ids do
      local blip = blip_ids[i]
      if does_blip_exist(blip) then RemoveBlip(blip) end
    end
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(false)
  end

  return {getall = get_all, onscreen = on_screen, bycoords = by_coords, bysprite = by_sprite, bytype = by_type, getblips = get_blips, getinfo = get_info, remove = remove_blips}
end