--------------------------------- Handlers ---------------------------------

RegisterNetEvent('duf:Cl_PlayerEnteredNone')

for _, zone in pairs(Zones.Data) do
    RegisterNetEvent('duf:PlayerEnteredZone' .. zone.Name)
    AddEventHandler('duf:PlayerEnteredZone' .. zone.Name, function(zone)
        print('Player entered ' .. zone)
    end)
end

RegisterNetEvent('duf:Cl_SyncPlayerZones')
AddEventHandler('duf:Cl_SyncPlayerZones', function(PlayerZones)
    Zones.Players = PlayerZones
end)

--------------------------------- Utilities ---------------------------------

local function GetZoneIndex(zone)
    for i = 1, #Zones.Data do
        if Zones.Data[i].Name == zone then
            return i
        end
    end
end

local function getAngle(p, center)
    local angle = math.atan2(p.y - center.y, p.x - center.x)
    if angle < 0 then
        angle = angle + 2 * math.pi
    end
    return angle
end

local function getDistance(p1, p2)
    return math.sqrt((p2.x - p1.x) ^ 2 + (p2.y - p1.y) ^ 2)
end

local function getAngleBetweenPoints(p1, p2)
    local angle = math.atan2(p2.y - p1.y, p2.x - p1.x)
    if angle < 0 then
        angle = angle + 2 * math.pi
    end
    return angle
end

local function sortTable(t, center)
    for i = 1, #t do
        for j = i + 1, #t do
            if getAngle(t[i], center) > getAngle(t[j], center) then
                t[i], t[j] = t[j], t[i]
            end
        end
    end
end

local function isConcave(a, b, c)
    local ab = b - a
    local bc = c - b
    local cross = ab.x * bc.y - ab.y * bc.x
    return cross < 0
end

local function removeConcavePoints(points)
    local i = 1
    while i <= #points do
        local a, b, c = points[i], points[i + 1], points[i + 2]
        if not a or not b or not c then
            break
        end
        if isConcave(a, b, c) then
            table.remove(points, i + 1)
        else
            i = i + 1
        end
    end
    return points
end

local function removeAngledPoints(points)
    local i = 1
    while i <= #points do
        local a, b, c = points[i], points[i + 1], points[i + 2]
        if not a or not b or not c then
            break
        end
        local angle1 = getAngleBetweenPoints(a, b)
        local angle2 = getAngleBetweenPoints(a, c)
        if angle1 > angle2 then
            table.remove(points, i + 1)
        else
            i = i + 1
        end
    end
    return points
end

local function findHeights(heights)
    local min, max = math.huge, -math.huge
    for _, v in pairs(heights) do
        if v < min then
            min = v
        end
        if v > max then
            max = v
        end
    end
    return min, max
end

local function approximateZone(points, center)
    if #points == 2 then
        local p1, p2 = points[1], points[2]
        local p3 = vector2(p1.x, p2.y)
        local p4 = vector2(p2.x, p1.y)
        return {p1, p3, p2, p4}
    elseif #points == 3 then
        local p1, p2, p3 = points[1], points[2], points[3]
        local p4 = vector2(p1.x, p3.y)
        local p5 = vector2(p3.x, p1.y)
        return {p1, p4, p3, p5}
    end
end

--------------------------------- PolyZone ---------------------------------

---@param zone string | Zone name to create a PolyZone for
local function CreatePolyZoneforZone(zone)
    local data = Zones.Data[GetZoneIndex(zone)]
    local bounds = data.Bounds
    local points, heights = {}, {}
    for _, j in pairs(bounds) do
        for k, j in pairs(j) do
            if k == 'Minimum' then
                points[#points + 1] = vector2(j.X, j.Y)
                heights[#heights + 1] = j.Z
            elseif k == 'Maximum' then
                points[#points + 1] = vector2(j.X, j.Y)
                heights[#heights + 1] = j.Z
            end
        end
    end
    local lowest, highest = findHeights(heights)
    local center = vector2(0, 0)
    for k, v in pairs(points) do
        center = center + v
    end
    center = center / #points
    sortTable(points, center)
    points = removeConcavePoints(removeConcavePoints(removeConcavePoints(points)))
    points = removeAngledPoints(points)
    if #points <= 3 then points = approximateZone(points, center) end
    local zone = PolyZone:Create(points, {
        name = data.Name,
        minZ = lowest,
        maxZ = highest,
        debugGrid = false,
        gridDivisions = 25
    })
    Zones.PolyZones[data.Name] = zone
end

exports('CreatePolyZoneforZone', function(zone) CreatePolyZoneforZone(zone) end)

local function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

for k, v in pairs(Zones.Data) do
    CreatePolyZoneforZone(v.Name)
    print('Created PolyZone for ' .. v.Name)
end

if Zones.PolyZones then
    for k, v in pairs(Zones.PolyZones) do
        local msBetweenPointCheck = 100
        v:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
            if isPointInside then
                Notify('Entered ' .. v.name)
            else
                Notify('Exited ' .. v.name)
            end
        end, msBetweenPointCheck)
    end
end