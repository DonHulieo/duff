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