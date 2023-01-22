--------------------------------- Compare Tables ---------------------------------

---@param t1 table
---@param t2 table
---@return boolean
local function CompareTables(t1, t2)
    if #t1 ~= #t2 then return false end
    for k, v in pairs(t1) do
        if t2[k] ~= v then return false end
    end
    return true
end

exports('CompareTables', function(t1, t2) return CompareTables(t1, t2) end)

--------------------------------- Round Number ---------------------------------

---@param num number
---@param numDecimalPlaces number
---@return number
local function RoundNumber(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10^numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    
    return math.floor(num + 0.5)
end

exports('RoundNumber', function(num, numDecimalPlaces) return RoundNumber(num, numDecimalPlaces) end)

--------------------------------- Get Random Number ---------------------------------

---@param min number
---@param max number
---@return number
local function GetRandomNumber(min, max)
    return math.random() * (max - min) + min
end

exports('GetRandomNumber', function(min, max) return GetRandomNumber(min, max) end)

--------------------------------- Converting Tables to Vectors --------------------------------- [Credits go to: Swkeep | https://github.com/swkeep]

---@param table table
---@return 'vector2'
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

--------------------------------- Get Distance Between Coords ---------------------------------

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
local function GetDistVec2(x1, y1, x2, y2)
    local from, to = nil, nil
    if type(x1) == 'table' and type(y1) == 'table' then
        from = ConvertToVec2(x1)
        to = ConvertToVec2(y1)
    elseif type(x1) == 'vector2' and type(y1) == 'vector2' then
        from = x1
        to = y1
    else
        from = vector2(x1, y1)
        to = vector2(x2, y2)
    end
    return #(from - to)
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
local function GetDistVec3(x1, y1, z1, x2, y2, z2)
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
    return #(from - to)
end

exports('GetDistVec2', function(x1, y1, x2, y2) return GetDistVec2(x1, y1, x2, y2) end)
exports('GetDistVec3', function(x1, y1, z1, x2, y2, z2) return GetDistVec3(x1, y1, z1, x2, y2, z2) end)

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

exports('GetHeadingBetweenCoords', function(x1, y1, z1, x2, y2, z2) return GetHeadingBetweenCoords(x1, y1, z1, x2, y2, z2) end)

--------------------------------- Is Point Within Polygon ---------------------------------

---@param point 'vector3' | 'vector2' | table
---@param polygon table
---@return boolean
local function IsPointInPolygon(point, polygon)
    local x, y = nil, nil
    if type(point) == 'table' then
        x = point.x
        y = point.y
    elseif type(point) == 'vector2' then
        x = point.x
        y = point.y
    elseif type(point) == 'vector3' then
        x = point.x
        y = point.y
    end
    local inside = false
    local j = #polygon
    for i = 1, #polygon do
        if ((polygon[i].y > y) ~= (polygon[j].y > y)) and (x < (polygon[j].x - polygon[i].x) * (y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) then
            inside = not inside
        end
        j = i
    end
    return inside
end

exports('IsPointInPolygon', function(point, polygon) return IsPointInPolygon(point, polygon) end)