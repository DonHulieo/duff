--------------------------------- Compare Tables ---------------------------------

---@param t1 table
---@param t2 table
local function CompareTables(t1, t2)
    if #t1 ~= #t2 then return false end
    for k, v in pairs(t1) do
        if t2[k] ~= v then return false end
    end
    return true
end

exports('CompareTables', function(t1, t2) return CompareTables(t1, t2) end)

--------------------------------- Round Number ---------------------------------

local function RoundNumber(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10^numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    
    return math.floor(num + 0.5)
end

exports('RoundNumber', function(num, numDecimalPlaces) return RoundNumber(num, numDecimalPlaces) end)

--------------------------------- Converting Tables to Vectors --------------------------------- [Credits go to: Swkeep | https://github.com/swkeep]

---@param zones table
---@return table
local function ConvertToVec2(table)
    return vector2(table.x, table.y)
end

---@param table table
---@return 'vector3'
local function ConvertToVec3(table)
    return vector3(table.x, table.y, table.z)
end

---@param table table
---@return 'vector4'
local function ConvertToVec4(table)
    return vector4(table.x, table.y, table.z, table.w)
end

exports('ConvertToVec2', function(table) return ConvertToVec2(table) end)
exports('ConvertToVec3', function(table) return ConvertToVec3(table) end)
exports('ConvertToVec4', function(table) return ConvertToVec4(table) end)

--------------------------------- Get Heading Between Coords ---------------------------------

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
local function GetHeadingBetweenCoords(x1, y1, z1, x2, y2, z2)
    local from, to = nil, nil
    if type(x1) == 'table' and type(y1) == 'table' then
        from = ConvertToVec3(x1)
        to = ConvertToVec3(y1)
    elseif type(x1) == 'vector3' and type(y1) == 'vector3' then
        from = x1
        to = y1
    else
        from = vector3(x1, y1, z1)
        to = vector3(x2, y2, z2)
    end
    local dx = to.x - from.x
    local dy = to.y - from.y
    local heading = math.deg(math.atan2(dy, dx))
    if heading < 0 then heading = heading + 360 end
    return heading
end
