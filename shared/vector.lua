---@class CVector
---@field GetClosest fun(check: integer|vector3|{x: number, y: number, z: number}, tbl: vector3[]|integer[]): integer?, number? @shared
---@field GetEntityMatrix fun(entity: integer): vector3?, vector3?, vector3?, vector3? @server
---@field GetEntityForwardVector fun(entity: integer): vector3? @server
---@field GetEntityRightVector fun(entity: integer): vector3? @shared
---@field GetEntityUpVector fun(entity: integer): vector3? @shared
---@field GetOffsetFromEntityInWorldCoords fun(entity: integer, offset_x: number, offset_y: number, offset_z: number): vector3? @server
local CVector do
  local type = type
  local error = error
  local does_entity_exist = DoesEntityExist
  local get_coords = GetEntityCoords
  local vector3 = vector3
  local check_type = CheckType
  local require = require
  local array = require 'duf.shared.array'
  local is_server = IsDuplicityVersion() == 1

  ---@param check integer|vector3|{x: number, y: number, z: number}
  ---@param fn_name string
  ---@return vector3?
  local function ensure_vector3(check, fn_name)
    local param_type = type(check)
    if param_type ~= 'vector3' and param_type ~= 'number' and param_type ~= 'table' then
      error('bad argument #1 to \'' ..fn_name.. '\' (vector3, number or table expected, got ' ..param_type.. ')')
      return
    end
    check = param_type == 'vector3' and check or param_type == 'number' and does_entity_exist(check) and get_coords(check) or vector3(check.x, check.y, check.z)
    if not check then print('bad argument #1 to \'' ..fn_name.. '\' (invalid vector3)') return end
    return check
  end

  ---@param entity integer
  ---@param fn_name string
  ---@return boolean?
  local function ensure_entity(entity, fn_name)
    local bool, param_type = check_type(entity, 'number')
    if not bool then print('bad argument #1 to \'' ..fn_name.. '\' (number expected, got ' ..param_type.. ')') return end
    if not does_entity_exist(entity) then print('bad argument #1 to \'' ..fn_name.. '\' (entity does not exist)') return end
    return true
  end

  ---@param tbl table
  ---@return vector2|vector3|vector4
  local function convert_to_vector(tbl) -- [Credits go to: Swkeep](https://github.com/swkeep)
    local bool, param_type = check_type(tbl, 'table')
    if not bool then print('bad argument #1 to \'ConvertToVector\' (table expected, got ' ..param_type.. ')') end
    if not tbl.x or not tbl.y then print('bad argument #1 to \'ConvertToVector\' (invalid vector)') end
    return tbl.w and vector4(tbl.x, tbl.y, tbl.z, tbl.w) or tbl.z and vector3(tbl.x, tbl.y, tbl.z) or vector2(tbl.x, tbl.y)
  end

  ---@param check integer|vector3|{x: number, y: number, z: number}
  ---@param tbl vector3[]|integer[]
  ---@return integer|vector3? closest, number? distance
  local function get_closest(check, tbl, radius)
    local coords = ensure_vector3(check, 'GetClosest') --[[@as vector3]]
    if not coords or not check_type(coords, 'vector3') then return end
    tbl = not array.isarray(tbl) and array(tbl) or tbl --[[@as CArray]]
    local closest, dist = nil, nil
    local closests = tbl:filter(function(found)
      local distance = #(coords - ensure_vector3(found, 'GetClosest'))
      if not dist or distance < dist then
        closest, dist = found, distance
      end
      return radius and distance <= radius or distance == dist
    end, array.IN_PLACE)
    return closest, dist, closests
  end

  if not is_server then
    local get_entity_matrix = GetEntityMatrix

    ---@param entity integer
    ---@return vector3?
    local function getEntityRightVector(entity) -- [Credits go to: VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
      if not ensure_entity(entity, 'GetEntityRightVector') then return end
      local _, right = get_entity_matrix(entity)
      return right
    end

    ---@param entity integer
    ---@return vector3?
    local function getEntityUpVector(entity) -- [Credits go to: VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
      if not ensure_entity(entity, 'GetEntityUpVector') then return end
      local _, _, up = get_entity_matrix(entity)
      return up
    end

    return {
      ConvertToVec = convert_to_vector,
      GetClosest = get_closest,
      GetEntityRightVector = getEntityRightVector,
      GetEntityUpVector = getEntityUpVector
    }
  else
    local get_rotation = GetEntityRotation
    local rad = math.rad
    local cos = math.cos
    local sin = math.sin

    ---@param entity integer
    ---@return vector3?, vector3?, vector3?, vector3?
    local function getEntityMatrix(entity) -- [Credits goes to: draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
      if not ensure_entity(entity, 'GetEntityMatrix') then return end
      local rot = get_rotation(entity)
      local x, y, z in rot
      x, y, z = rad(x), rad(y), rad(z)
      local matrix = {{}, {}, {}, {}}
      matrix[1][1] = cos(z) * cos(y) - sin(z) * sin(x) * sin(y)
      matrix[1][2] = cos(y) * sin(z) + cos(z) * sin(x) * sin(y)
      matrix[1][3] = -cos(x) * sin(y)
      matrix[1][4] = 1
      matrix[2][1] = -cos(x) * sin(z)
      matrix[2][2] = cos(z) * cos(x)
      matrix[2][3] = sin(x)
      matrix[2][4] = 1
      matrix[3][1] = cos(z) * sin(y) + cos(y) * sin(z) * sin(x)
      matrix[3][2] = sin(z) * sin(y) - cos(z) * cos(y) * sin(x)
      matrix[3][3] = cos(x) * cos(y)
      matrix[3][4] = 1
      local coords = get_coords(entity)
      matrix[4][1], matrix[4][2], matrix[4][3] = coords.x, coords.y, coords.z - 1.0
      matrix[4][4] = 1

      local forward = vector3(matrix[1][2], matrix[2][2], matrix[3][2])
      local right = vector3(matrix[1][1], matrix[2][1], matrix[3][1])
      local up = vector3(matrix[1][3], matrix[2][3], matrix[3][3])
      local pos = vector3(matrix[4][1], matrix[4][2], matrix[4][3])
      return forward, right, up, pos
    end

    ---@param entity integer
    ---@return vector3?
    local function getEntityForwardVector(entity)
      if not ensure_entity(entity, 'GetEntityForwardVector') then return end
      local forward = getEntityMatrix(entity)
      return forward
    end

    ---@param entity integer
    ---@return vector3?
    local function getEntityRightVector(entity) -- [Credits goes to: VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
      if not ensure_entity(entity, 'GetEntityRightVector') then return end
      local _, right = getEntityMatrix(entity)
      return right
    end

    ---@param entity integer
    ---@return vector3?
    local function getEntityUpVector(entity) -- [Credits goes to: VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
      if not ensure_entity(entity, 'GetEntityUpVector') then return end
      local _, _, up = getEntityMatrix(entity)
      return up
    end

    ---@param entity integer
    ---@param offset_x number
    ---@param offset_y number
    ---@param offset_z number
    ---@return vector3?
    local function getOffsetFromEntityInWorldCoords(entity, offset_x, offset_y, offset_z) -- [Credits goes to: draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
      if not ensure_entity(entity, 'GetOffsetFromEntityInWorldCoords') then return end
      local forward, right, up, pos = getEntityMatrix(entity)
      if not forward or not right or not up or not pos then return end
      local x = offset_x * forward.x + offset_y * right.x + offset_z * up.x + pos.x
      local y = offset_x * forward.y + offset_y * right.y + offset_z * up.y + pos.y
      local z = offset_x * forward.z + offset_y * right.z + offset_z * up.z + pos.z
      return vector3(x, y, z)
    end

    return {
      ConvertToVec = convert_to_vector,
      GetClosest = get_closest,
      GetEntityMatrix = getEntityMatrix,
      GetEntityForwardVector = getEntityForwardVector,
      GetEntityRightVector = getEntityRightVector,
      GetEntityUpVector = getEntityUpVector,
      GetOffsetFromEntityInWorldCoords = getOffsetFromEntityInWorldCoords
    }
  end
end