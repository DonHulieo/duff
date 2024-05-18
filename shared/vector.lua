---@class vector
---@field tabletovector fun(tbl: {x: number, y: number, z: number?, w: number?}): vector2|vector3|vector4? Check if the table is a vector and convert it to a vector @shared
---@field getclosest fun(check: integer|vector3|{x: number, y: number, z: number}, tbl: vector3[]|integer[], radius: number?, excluding: any[]?): integer|vector3?, number?, array? Finds the closest vector3 from an array of vector3s @shared
---@field getentitymatrix fun(entity: integer): vector3?, vector3?, vector3?, vector3? Get the forward, right, up, and position of an entity @server
---@field getentityforward fun(entity: integer): vector3? Get the forward vector of an entity @server
---@field getentityright fun(entity: integer): vector3? Get the right vector of an entity @shared
---@field getentityup fun(entity: integer): vector3? Get the up vector of an entity @shared
---@field getoffsetfromentityinworldcoords fun(entity: integer, offset_x: number, offset_y: number, offset_z: number): vector3? Get the world coordinates of an entity with an offset @server
local vector do
  local type, error = type, error
  local does_entity_exist, get_coords = DoesEntityExist, GetEntityCoords
  local require = require
  ---@module 'shared.debug'
  local debug = require 'shared.debug'
  local get_fn_info, raise_error, check_type = debug.getfuncinfo, debug.raiseerror, debug.checktype
  local math, vector3 = math, vector3
  ---@module 'duf.shared.array'
  local array = require 'shared.array'
  local is_server = IsDuplicityVersion() == 1
  local rad, cos, sin = math.rad, math.cos, math.sin

  ---@param tbl {x: number, y: number, z: number?, w: number?}
  ---@return vector2|vector3|vector4?
  local function convert_to_vector(tbl, fn) -- Credits go to: [Swkeep](https://github.com/swkeep)
    if not check_type(tbl, 'table', fn or convert_to_vector, 1) then return end
    if not tbl.x or not tbl.y then error('bad argument #1 to \'ConvertToVec\' (invalid vector)', 5) return end
    return tbl.w and vector4(tbl.x, tbl.y, tbl.z, tbl.w) or tbl.z and vector3(tbl.x, tbl.y, tbl.z) or vector2(tbl.x, tbl.y)
  end

  ---@param check integer|vector3|{x: number, y: number, z: number}
  ---@param fn function
  ---@return vector3?
  local function ensure_vector3(check, fn)
    if not check_type(check, {'number', 'vector3', 'table'}, fn, 1) then return end
    local param_type = type(check)
    check = param_type == 'vector3' and check or param_type == 'number' and does_entity_exist(check) and get_coords(check) or convert_to_vector(check --[[@as table]], fn) --[[@as vector3]]
    if not check_type(check, 'vector3', fn, 1) then return end
    return check
  end

  ---@param entity integer
  ---@param fn function
  ---@return boolean?
  local function ensure_entity(entity, fn)
    if not check_type(entity, 'number', fn, 1) then return end
    local info, level = get_fn_info(fn)
    if not info or not level then return end
    if not does_entity_exist(entity) then raise_error(info, level, 1, 'entity does not exist') return end
    return true
  end

  ---@param check integer|vector3|{x: number, y: number, z: number}
  ---@param tbl vector3[]|integer[]|array
  ---@param radius number?
  ---@param excluding any|any[]|array?
  ---@return integer|vector3?, number?, array?
  local function get_closest(check, tbl, radius, excluding)
    local coords = ensure_vector3(check, get_closest) --[[@as vector3]]
    if not coords or not check_type(coords, 'vector3', get_closest, 1) then return end
    tbl = tbl.__type == 'array' and tbl or type(tbl) == 'table' and array.new(tbl) or array.new{tbl}
    local closest, dist = nil, nil
    excluding = excluding and (excluding.__type == 'array' and excluding or type(excluding) == 'table' and array.new(excluding) or array.new{excluding}) or excluding
    local closests = tbl:filter(function(found)
      local distance = #(coords - ensure_vector3(found, get_closest))
      local contains = excluding and excluding:contains(nil, found)
      if (not excluding or not contains) and (not dist or distance < dist) then closest, dist = found, distance end
      return (not excluding or not contains) and (radius and distance <= radius or distance == dist)
    end, true)
    return closest, dist, closests
  end

  local get_rotation = GetEntityRotation

  ---@param entity integer
  ---@return vector3?, vector3?, vector3?, vector3?
  local function sv_get_entity_matrix(entity) -- Credits go to: [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
    if not is_server or not get_rotation then return end
    if not ensure_entity(entity, sv_get_entity_matrix) then return end
    local rot = get_rotation(entity)
    local x, y, z in rot
    x, y, z = rad(x), rad(y), rad(z)
    local matrix = {{}, {}, {}, {}}
    matrix[1] = {cos(z) * cos(y) - sin(z) * sin(x) * sin(y), cos(y) * sin(z) + cos(z) * sin(x) * sin(y), -cos(x) * sin(y), 1}
    matrix[2] = {-cos(x) * sin(z), cos(z) * cos(x), sin(x), 1}
    matrix[3] = {cos(z) * sin(y) + cos(y) * sin(z) * sin(x), sin(z) * sin(y) - cos(z) * cos(y) * sin(x), cos(x) * cos(y), 1}
    local coords = get_coords(entity)
    matrix[4] = {coords.x, coords.y, coords.z - 1.0, 1}
    local forward = vector3(matrix[1][2], matrix[2][2], matrix[3][2])
    local right = vector3(matrix[1][1], matrix[2][1], matrix[3][1])
    local up = vector3(matrix[1][3], matrix[2][3], matrix[3][3])
    local pos = vector3(matrix[4][1], matrix[4][2], matrix[4][3])
    return forward, right, up, pos
  end

  local get_entity_matrix = GetEntityMatrix or sv_get_entity_matrix

  ---@param entity integer
  ---@return vector3?
  local function get_entity_forward_vec(entity)
    if not is_server then return end
    if not ensure_entity(entity, get_entity_forward_vec) then return end
    local forward = get_entity_matrix(entity)
    return forward
  end

  ---@param entity integer
  ---@return vector3?
  local function sv_get_entity_right_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if not is_server then return end
    if not ensure_entity(entity, sv_get_entity_right_vec) then return end
    local _, right = get_entity_matrix(entity)
    return right
  end

  ---@param entity integer
  ---@return vector3?
  local function sv_get_entity_up_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if not is_server then return end
    if not ensure_entity(entity, sv_get_entity_up_vec) then return end
    local _, _, up = get_entity_matrix(entity)
    return up
  end

  ---@param entity integer
  ---@param offset_x number
  ---@param offset_y number
  ---@param offset_z number
  ---@return vector3?
  local function get_offset_entity_worldcoords(entity, offset_x, offset_y, offset_z) -- Credits go to: [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
    if not is_server then return end
    if not ensure_entity(entity, get_offset_entity_worldcoords) then return end
    local forward, right, up, pos = get_entity_matrix(entity)
    if not forward or not right or not up or not pos then return end
    local x = offset_x * forward.x + offset_y * right.x + offset_z * up.x + pos.x
    local y = offset_x * forward.y + offset_y * right.y + offset_z * up.y + pos.y
    local z = offset_x * forward.z + offset_y * right.z + offset_z * up.z + pos.z
    return vector3(x, y, z)
  end

  ---@param entity integer
  ---@return vector3?
  local function get_entity_right_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if is_server then return end
    if not ensure_entity(entity, get_entity_right_vec) then return end
    local _, right = get_entity_matrix(entity)
    return right
  end

  ---@param entity integer
  ---@return vector3?
  local function get_entity_up_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if is_server then return end
    if not ensure_entity(entity, get_entity_up_vec) then return end
    local _, _, up = get_entity_matrix(entity)
    return up
  end

  --------------------- OBJECT ---------------------

  vector = {tabletovector = convert_to_vector, getclosest = get_closest}

  if not is_server then
    vector.getentityright = get_entity_right_vec
    vector.getentityup = get_entity_up_vec
  else
    vector.getentitymatrix = get_entity_matrix
    vector.getentityforward = get_entity_forward_vec
    vector.getentityright = sv_get_entity_right_vec
    vector.getentityup = sv_get_entity_up_vec
    vector.getoffsetfromentityinworldcoords = get_offset_entity_worldcoords
  end

  return vector
end