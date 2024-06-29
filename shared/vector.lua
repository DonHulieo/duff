---@class CVector
---@field isvec fun(value: vector2|vector3|vector4): boolean Checks if `value` is a vector.
---@field tobin fun(value: vector): string Converts a vector, `value` to a binary string. <br> Uses double point precision for encoding.
---@field frombin fun(value: string): vector Converts a binary string, `value` to a vector.
---@field tovec fun(value: integer|vector|{x: number, y: number, z: number?, w: number?}|number[]): number|vector2|vector3|vector4 Checks `value`'s type and converts it to a vector. <br> If `value` is a table, it will be converted to a vector. <br> If `value` is a number, it's assumed to be an entity and its coordinates will be returned. <br> If `value` is a vector, it will be returned as is. <br> Original concept by: [Swkeep](https://github.com/swkeep).
---@field getclosest fun(check: integer|vector|string|{x: number, y: number, z: number}|number[], tbl: (integer|vector|{x: number, y: number, z: number?, w: number?}|number[])[], radius: number?, excluding: any?): integer|vector?, number?, (integer|vector)[]? Find the closest vector in `tbl` to `check`. <br> `check` can be an entity, vector or a table. <br> `tbl` can be an array of vectors, entities or table reps of coordinates. <br> `radius` is the maximum distance within. <br> `excluding` is the entity, vector or group of either to exclude from the search.
---@field getentitymatrix fun(entity: integer): vector3, vector3, vector3, vector3 Returns `entity`s forward, right, up and position vectors. <br> Credits go to: [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297).
---@field getentityforward fun(entity: integer): vector3 Returns the forward vector of `entity`.
---@field getentityright fun(entity: integer): vector3 Returns the right vector of `entity`. <br> Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980).
---@field getentityup fun(entity: integer): vector3 Returns the up vector of `entity`. <br> Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980).
---@field getoffsetfromentityinworldcoords fun(entity: integer, offset_x: number, offset_y: number, offset_z: number): vector3 Returns the world coordinates of `offset` from `entity`. <br> Credits go to: [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297).
do
  local load, load_resource_file = load, LoadResourceFile
  local require = duff?.packages.require or load(load_resource_file('duff', 'shared/packages.lua'), '@duff/shared/packages.lua', 'bt', _ENV)().require
  local array, math = require 'duff.shared.array', require 'duff.shared.math'
  local string, table = string, table
  local contains = array.contains
  local rad, cos, sin, huge = math.rad, math.cos, math.sin, math.huge
  local s_pack, s_unpack = string.pack, string.unpack
  ---@diagnostic disable-next-line: deprecated
  local t_unpack = table.unpack or unpack
  local vector = vector
  local does_entity_exist, get_coords, get_rot = DoesEntityExist, GetEntityCoords, GetEntityRotation
  local is_server = IsDuplicityVersion() == 1

  ---@enum (key) vector_types
  local vector_types = {['vector'] = 'd', ['vector2'] = 'dd', ['vector3'] = 'ddd', ['vector4'] = 'dddd'}
  ---@param value vector2|vector3|vector4|string Checks if `value` is a vector.
  ---@return boolean is_vector `true` if `vec` is a vector.
  local function is_vector(value)
    local param_type = type(value)
    return vector_types[param_type ~= 'string' and param_type or value] ~= nil
  end

  ---@param value vector The vector to convert to a binary string.
  ---@return string binary `value` converted to a binary string.
  local function to_binary(value)
    local vec_type = type(value)
    if not vector_types[vec_type] then error('bad argument to \'%s\' (expected vector, got '..vec_type..')', 0) end
    return s_pack(vector_types[vec_type], t_unpack(value))
  end

  ---@enum (key) vector_res
  local vector_res = {[8] = 'd', [16] = 'dd', [24] = 'ddd', [32] = 'dddd'}
  ---@param value string The value to convert to a vector.
  ---@return number|vector vector `value` converted to a vector.
  local function from_binary(value)
    local len = #value
    if not len or not vector_res[len] then error('bad argument to \'%s\' (expected binary string, got '..type(value)..')', 0) end
    return vector(t_unpack({s_unpack(vector_res[len], value)}, 1, len / 8))
  end

  ---@param tbl {x: number, y: number, z: number?, w: number?}|number[] The table to convert to a vector. <br> Can be a table with `x`, `y`, `z`, and `w` keys or an array with the same values.
  ---@return number|vector2|vector3|vector4 vector `tbl` converted to a vector.
  local function tbl_to_vector(tbl) -- Original concept by: [Swkeep](https://github.com/swkeep).
    local param_type = type(tbl)
    if param_type ~= 'table' then error('bad argument to \'%s\' (expected table, got '..param_type..')', 0) end
    tbl = not tbl[1] and {tbl.x, tbl.y, tbl.z, tbl.w} or tbl
    return vector(t_unpack(tbl))
  end

  ---@param entity integer The entity to retrieve the coordinates from.
  ---@return vector3 coords `coords` of the entity.
  local function ent_to_vector(entity)
    if not math.isint(entity) then error('bad argument to \'%s\' (expected integer, got '..type(entity)..')', 0) end
    if not does_entity_exist(entity) then error('bad argument to \'%s\' (entity does not exist)', 0) end
    return get_coords(entity)
  end

  ---@param value integer|vector|{x: number, y: number, z: number?, w: number?}|number[] The value to convert to a vector.
  ---@return integer|vector vector `value` returned as a vector.
  local function to_vector(value) -- Checks `value`'s type and converts it to a vector. <br> If `value` is a table, it will be converted to a vector. <br> If `value` is a number, it's assumed to be an entity and its coordinates will be returned. <br> If `value` is a vector, it will be returned as is.
    local param_type = type(value)
    return
    (is_vector(param_type --[[@as vector]]) and value) or
    (param_type == 'string' and from_binary(value)) or
    (param_type == 'table' and tbl_to_vector(value)) or
    (param_type == 'number' and ent_to_vector(value)) or 0
  end

  ---@param value any The value to check.
  ---@param types string[] The types to check against.
  ---@param arg integer The argument number.
  ---@return boolean|string `true` if `value` is one of the types in `types`, otherwise an error message.
  local function check_types(value, types, arg)
    local value_type = type(value)
    local err = 'bad argument #'..arg..' to \'%s\' (expected '..table.concat(types, ', ', 1, #types - 1)..' or '..types[#types]..', got '..value_type..')'
    for i = 1, #types do
      local found_type = types[i]
      if value_type == found_type then return true end
      if found_type == 'vector' and is_vector(value_type) then return true end
    end
    return err
  end

  ---@param check integer|vector|{x: number, y: number, z: number?, w: number?}|number[] The value to check.
  ---@param tbl (integer|vector|{x: number, y: number, z: number?, w: number?}|number[])[] The list of vectors to check against.
  ---@param radius number? The maximum distance within.
  ---@param excluding any|any[]? The entity, vector or group of either to exclude from the search.
  ---@return integer|vector|{x: number, y: number, z: number?, w: number?}|number[]? closest, number? dist, (integer|vector)[]? closests <br> `closest` is the closest value to `check`. <br>  `dist` is the distance to the closest value. <br> `closests` is an array of all vectors within `radius`.
  local function get_closest(check, tbl, radius, excluding) -- Find the closest vector in `tbl` to `check`.
    if check_types(check, {'number', 'table', 'vector'}, 1) ~= true then error(check_types(check, {'number', 'table', 'vector'}, 1), 0) end
    if table.type(tbl) ~= 'array' then error('bad argument #2 to \'%s\' (expected array, got '..(table.type(tbl) or type(tbl))..')', 0) end
    local coords = to_vector(check) --[[@as vector|integer]]
    tbl = type(tbl) == 'table' and tbl or {tbl}
    local closest, dist, closests = nil, radius or huge, {}
    local exc_type = type(excluding)
    for i = 1, #tbl do
      local found = tbl[i]
      if not excluding or (exc_type == 'table' and not contains(excluding, nil, found) or found ~= excluding) then
        local distance = #(coords - to_vector(found) --[[@as vector]])
        if distance < dist then closest, dist = found, distance end
        closests[#closests + 1] = found
      end
    end
    return closest, dist, closests
  end

  ---@param entity integer The entity to retrieve the matrix from.
  ---@return vector3 forward, vector3 right, vector3 up, vector3 pos <br> `forward` vector. <br> `right` vector. <br> `up` vector. <br> `pos` vector of the entity.
  local function sv_get_entity_matrix(entity) -- Credits go to: [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
    if not is_server then error('called a server only function \'%s\'', 0) end
    local coords = ent_to_vector(entity)
    local rot = get_rot(entity)
    local x, y, z = rot.x, rot.y, rot.z
    x, y, z = rad(x), rad(y), rad(z)
    local matrix = {
      {cos(z) * cos(y) - sin(z) * sin(x) * sin(y), cos(y) * sin(z) + cos(z) * sin(x) * sin(y), -cos(x) * sin(y), 1},
      {-cos(x) * sin(z), cos(z) * cos(x), sin(x), 1},
      {cos(z) * sin(y) + cos(y) * sin(z) * sin(x), sin(z) * sin(y) - cos(z) * cos(y) * sin(x), cos(x) * cos(y), 1},
      {coords.x, coords.y, coords.z - 1.0, 1}
    }
    local forward = vector(matrix[1][2], matrix[2][2], matrix[3][2])
    local right = vector(matrix[1][1], matrix[2][1], matrix[3][1])
    local up = vector(matrix[1][3], matrix[2][3], matrix[3][3])
    local pos = vector(matrix[4][1], matrix[4][2], matrix[4][3])
    return forward, right, up, pos
  end

  local get_entity_matrix = GetEntityMatrix or sv_get_entity_matrix

  ---@param entity integer The entity to retrieve the forward vector from.
  ---@return vector3 forward `forward` vector of the entity.
  local function get_entity_forward_vec(entity)
    if not is_server then error('called a server only function \'%s\'', 0) end
    local forward = get_entity_matrix(entity)
    return forward
  end

  ---@param entity integer The entity to retrieve the right vector from.
  ---@return vector3? right `right` vector of the entity.
  local function sv_get_entity_right_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if not is_server then error('called a server only function \'%s\'', 0) end
    local _, right = get_entity_matrix(entity)
    return right
  end

  ---@param entity integer The entity to retrieve the up vector from.
  ---@return vector3 up `up` vector of the entity.
  local function sv_get_entity_up_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if not is_server then error('called a server only function \'%s\'', 0) end
    local _, _, up = get_entity_matrix(entity)
    return up
  end

  ---@param entity integer The entity to retrieve the offset from.
  ---@param offset_x number The offset on the x-axis.
  ---@param offset_y number The offset on the y-axis.
  ---@param offset_z number The offset on the z-axis.
  ---@return vector3 offset The world coordinates of the entity with the offset.
  local function get_offset_entity_worldcoords(entity, offset_x, offset_y, offset_z) -- Credits go to: [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
    if not is_server then error('called a server only function \'%s\'', 0) end
    local forward, right, up, pos = get_entity_matrix(entity)
    local x = offset_x * forward.x + offset_y * right.x + offset_z * up.x + pos.x
    local y = offset_x * forward.y + offset_y * right.y + offset_z * up.y + pos.y
    local z = offset_x * forward.z + offset_y * right.z + offset_z * up.z + pos.z
    return vector(x, y, z)
  end

  ---@param entity integer The entity to retrieve the right vector from.
  ---@return vector3 right `right` vector of the entity.
  local function get_entity_right_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if is_server then error('called a client only function \'%s\'', 0) end
    local _, right = get_entity_matrix(entity)
    return right
  end

  ---@param entity integer The entity to retrieve the up vector from.
  ---@return vector3 up `up` vector of the entity.
  local function get_entity_up_vec(entity) -- Credits go to: [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
    if is_server then error('called a client only function \'%s\'', 0) end
    local _, _, up = get_entity_matrix(entity)
    return up
  end

  --------------------- OBJECT ---------------------

  local _vector = {isvec = is_vector, tobin = to_binary, frombin = from_binary, tovec = to_vector, getclosest = get_closest}
  if not is_server then
    _vector.getentityright = get_entity_right_vec
    _vector.getentityup = get_entity_up_vec
  else
    _vector.getentitymatrix = get_entity_matrix
    _vector.getentityforward = get_entity_forward_vec
    _vector.getentityright = sv_get_entity_right_vec
    _vector.getentityup = sv_get_entity_up_vec
    _vector.getoffsetfromentityinworldcoords = get_offset_entity_worldcoords
  end
  return _vector
end