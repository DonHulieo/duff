local function RoundNumber(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10^numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    
    return math.floor(num + 0.5)
end

exports('RoundNumber', function(num, numDecimalPlaces) return RoundNumber(num, numDecimalPlaces) end)