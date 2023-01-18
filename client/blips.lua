--------------------------------- Blip Enumerators --------------------------------- [Credits go to: negbook | https://github.com/negbook/nbk_blips]

---@return table | Array of all blip handles
local function GetAllBlips() 
    local blips = {}
    for i = 1, 826 do 
        local blip = GetFirstBlipInfoId(i) 
        local found = DoesBlipExist(blip)    
        while found do 
            blips[#blips + 1] = blip
            blip = GetNextBlipInfoId(i)
            found = DoesBlipExist(blip)
            if not found then 
                break
            end 
        end 
    end 
    return blips
end

---@return table | Array of all on screen blip handles
local function GetOnScreenBlips()
    local blips = GetAllBlips()
    local onScreenBlips = {}
    for i = 1, #blips do
        local blip = blips[i]
        if IsBlipOnMinimap(blip) then
            onScreenBlips[#onScreenBlips + 1] = blip
        end
    end
    return onScreenBlips
end

exports('GetAllBlips', function() return GetAllBlips() end)
exports('GetOnScreenBlips', function() return GetOnScreenBlips() end)
--[[
    local blips = export['duf']:GetAllBlips()
    for i = 1, #blips do 
        local blip = blips[i]
        -- Do something with blip
    end
]]

--------------------------------- Blip Utility Functions ---------------------------------

local function RemoveAllBlips()
    local blips = GetAllBlips()
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
    for i = 1, #blips do
        local blip = blips[i]
        RemoveBlip(blip)
    end
end

local function RemoveOnScreenBlips()
    local blips = GetOnScreenBlips()
    SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
    for i = 1, #blips do
        local blip = blips[i]
        RemoveBlip(blip)
    end
end

exports('RemoveAllBlips', function() return RemoveAllBlips() end)
exports('RemoveOnScreenBlips', function() return RemoveOnScreenBlips() end)

------------------------------------------------------------------

---@param sprite number | Blip Sprite ID to search for
local function GetBlipsBySprite(sprite)
    local blips = GetAllBlips()
    local blipsBySprite = {}
    for i = 1, #blips do
        local blip = blips[i]
        if GetBlipSprite(blip) == sprite then
            blipsBySprite[#blipsBySprite + 1] = blip
        end
    end
    return blipsBySprite
end

exports('GetBlipsBySprite', function(sprite) return GetBlipsBySprite(sprite) end)
--[[
    local blips = GetBlipsBySprite(1)
    for i = 1, #blips do
        local blip = blips[i]
        -- Do something with blip
    end
]]

---@param blipType string | Type of blip (e.g. 'entity', 'coord', 'pickup')
---@param info any | Info (e.g. entity, coords, pickup)
---@param text string | Text
---@param sprite number | Sprite 
---@param colour number | Colour 
---@param scale number | Scale
---@param category number | Category
---@param display number | Display
---@param shortRange boolean | Short Range
---@return number | Blip Handle
local function CreateBlipFor(blipType, info, text, sprite, colour, scale, category, display, shortRange) 
    local blip = nil
    if not sprite then sprite = 1 end
    if not colour then colour = 1 end
    if not scale then scale = 0.5 end
    if not category then category = 1 end
    if not display then display = 2 end
    if not shortRange then shortRange = true end
    if blipType == 'entity' then
        blip = AddBlipForEntity(info)
    elseif blipType == 'coords' then
        blip = AddBlipForCoord(info)
    elseif blipType == 'pickup' then
        blip = AddBlipForPickup(info)
    end
    if blip then
        SetBlipSprite(blip, sprite)
        SetBlipColour(blip, colour)
        SetBlipScale(blip, scale)
        SetBlipCategory(blip, category)
        SetBlipDisplay(blip, display)
        SetBlipAsShortRange(blip, shortRange)
        AddTextEntry(text, text)
        BeginTextCommandSetBlipName(text)
        EndTextCommandSetBlipName(blip)
    end
    return blip
end

exports('CreateBlipFor', function(blipType, info, text, sprite, colour, scale, category, display) return CreateBlipFor(blipType, info, text, sprite, colour, scale, category, display) end)
--[[
    Example usage:
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 2.0, -0.5)
    local entity = CreateVehicle(joaat('adder'), coords, 0.0, true, false)
    local blip = exports['duf']:CreateBlipFor('entity', entity, 'Sick Car!', 1, 1, 0.5, 1, 2)
]]