--------------------------------- Entity Enumerator --------------------------------- [[Credits goes to: IllidanS4 | https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2]]

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

local function DUF_EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function DUF_EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

local function DUF_EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local function DUF_EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

---@param model string or hash | Model to search for
---@param entType string | Type of entity to search for (object, ped, vehicle, pickup)
local function DUF_ReturnEntitiesWithModel(model, entType)
    if type(model) == 'string' then
        model = joaat(model)
    end

    local entities = {}
    if entType == 'object' then
        for obj in DUF_EnumerateObjects() do
            if GetEntityModel(obj) == model then
                entities[#entities + 1] = obj
            end
        end
    elseif entType == 'ped' then
        for ped in DUF_EnumeratePeds() do
            if GetEntityModel(ped) == model then
                entities[#entities + 1] = ped
            end
        end
    elseif entType == 'vehicle' then
        for veh in DUF_EnumerateVehicles() do
            if GetEntityModel(veh) == model then
                entities[#entities + 1] = veh
            end
        end
    elseif entType == 'pickup' then
        for pickup in DUF_EnumeratePickups() do
            if GetPickupHash(pickup) == model then
                entities[#entities + 1] = pickup
            end
        end
    end
    return entities
end

---@param zone string or table | Zone to search for entities in
---@param entType string | Type of entity to search for (object, ped, vehicle, pickup)
local function DUF_ReturnEntitiesInZone(zone, entType)
    if type(zone) == 'table' then
        zone = GetZoneAtCoords(zone.x, zone.y, zone.z)
    elseif type(zone) == 'string' then
        zone = GetZoneFromNameId(zone)
    end

    local entities = {}
    if entType == 'object' then
        for obj in DUF_EnumerateObjects() do
            if IsEntityInZone(obj, zone) then
                entities[#entities + 1] = obj
            end
        end
    elseif entType == 'ped' then
        for ped in DUF_EnumeratePeds() do
            if IsEntityInZone(ped, zone) then
                entities[#entities + 1] = ped
            end
        end
    elseif entType == 'vehicle' then
        for veh in DUF_EnumerateVehicles() do
            if IsEntityInZone(veh, zone) then
                entities[#entities + 1] = veh
            end
        end
    elseif entType == 'pickup' then
        for pickup in DUF_EnumeratePickups() do
            if IsEntityInZone(pickup, zone) then
                entities[#entities + 1] = pickup
            end
        end
    end
    return entities
end

exports('EnumerateObjects', function() return DUF_EnumerateObjects() end) 
exports('EnumeratePeds', function() return DUF_EnumeratePeds() end)
exports('EnumerateVehicles', function() return DUF_EnumerateVehicles() end)
exports('EnumeratePickups', function() return DUF_EnumeratePickups() end)
exports('ReturnEntitiesWithModel', function(model, entType) return DUF_ReturnEntitiesWithModel(model, entType) end)
exports('ReturnEntitiesInZone', function(zone, entType) return DUF_ReturnEntitiesInZone(zone, entType) end)
--[[ 
    Example usage:
        local Objects = exports['duf']:EnumerateObjects() | exports['duf']:EnumeratePeds() | exports['duf']:EnumerateVehicles() | exports['duf']:EnumeratePickups()
    for obj in Objects do 
        -- Do something with obj
    end
    ------------------------------------------------------------------ 
    Example usage:
    local Objects = exports['duf']:ReturnEntitiesWithModel('prop_cs_cardbox_01', 'object')
    for obj in Objects do 
        -- Do something with obj
    end
    ------------------------------------------------------------------
    Example usage:
    local Peds = exports['duf']:ReturnEntitiesInZone('AIRP', 'ped')
    for ped in Peds do 
        -- Do something with ped
    end
]]

--------------------------------- Loading Assets --------------------------------- 

---@param model string or hash | Model to load
local function DUF_RequestModel(model)
    if type(model) == 'string' then
        model = joaat(model)
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    end
end

---@param model string or hash | Model to load collision for
local function DUF_RequestCollision(model)
    if type(model) == 'string' then
        model = joaat(model)
    end

    if not HasCollisionForModelLoaded(model) then
        RequestCollisionForModel(model)
        while not HasCollisionForModelLoaded(model) do
            Wait(0)
        end
    end
end

---@param dict string | Animation Dictionary (e.g. 'anim@mp_player_intmenu@key_fob@')
local function DUF_RequestAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
local function DUF_RequestAnimSet(animSet)
    if not HasAnimSetLoaded(animSet) then
        RequestAnimSet(animSet)
        while not HasAnimSetLoaded(animSet) do
            Wait(0)
        end
    end
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
local function DUF_RequestClipSet(clipSet)
    if not HasClipSetLoaded(clipSet) then
        RequestClipSet(clipSet)
        while not HasClipSetLoaded(clipSet) do
            Wait(0)
        end
    end
end

---@param ipl string | IPL to load (e.g. 'TrevorsTrailerTrash')
local function DUF_RequestIpl(ipl)
    if not IsIplActive(ipl) then
        RequestIpl(ipl)
        while not IsIplActive(ipl) do
            Wait(0)
        end
    end
end

---@param asset string | Particle FX Asset (e.g. 'scr_jewelheist')
local function DUF_RequestNamedPtfxAsset(asset)
    if not HasNamedPtfxAssetLoaded(asset) then
        RequestNamedPtfxAsset(asset)
        while not HasNamedPtfxAssetLoaded(asset) do
            Wait(0)
        end
    end
    UseParticleFxAsset(asset)
end

---@param scaleform string | Scaleform to load (e.g. 'mp_big_message_freemode')
local function DUF_RequestScaleformMovie(scaleform)
    if not HasScaleformMovieLoaded(scaleform) then
        RequestScaleformMovie(scaleform)
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(0)
        end
    end
end

---@param dict string | Texture Dictionary to load (e.g. 'mpleaderboard')
local function DUF_RequestStreamedTextureDict(dict)
    if not HasStreamedTextureDictLoaded(dict) then
        RequestStreamedTextureDict(dict, true)
        while not HasStreamedTextureDictLoaded(dict) do
            Wait(0)
        end
    end
end

---@param asset string or hash | Weapon Asset to load (e.g. 'WEAPON_PISTOL')
local function DUF_RequestWeaponAsset(asset)
    if type(asset) == 'string' then
        asset = joaat(asset)
    end

    if not HasWeaponAssetLoaded(asset) then
        RequestWeaponAsset(asset, 31, 0)
        while not HasWeaponAssetLoaded(asset) do
            Wait(0)
        end
    end
end

exports('ReqModel', function(model) return DUF_RequestModel(model) end)
exports('ReqCollision', function(model) return DUF_RequestCollision(model) end)
exports('ReqAnimDict', function(dict) return DUF_RequestAnimDict(dict) end)
exports('ReqAnimSet', function(animSet) return DUF_RequestAnimSet(animSet) end)
exports('ReqClipSet', function(clipSet) return DUF_RequestClipSet(clipSet) end)
exports('ReqIpl', function(ipl) return DUF_RequestIpl(ipl) end)
exports('ReqNamedPtfxAsset', function(asset) return DUF_RequestNamedPtfxAsset(asset) end)
exports('ReqScaleformMovie', function(scaleform) return DUF_RequestScaleformMovie(scaleform) end)
exports('ReqStreamedTextureDict', function(dict) return DUF_RequestStreamedTextureDict(dict) end)
exports('ReqWeaponAsset', function(asset) return DUF_RequestWeaponAsset(asset) end)
--[[
    Example usage:
    exports['duf']:ReqModel('prop_cs_cardbox_01') | exports['duf']:RequestModel(1302435108)
]]

--------------------------------- Blips & DrawText --------------------------------- 

---@param x number | X coordinate
---@param y number | Y coordinate
---@param z number | Z coordinate
---@param text string | Text to draw
---@param scale number | Scale of text
local function DUF_DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local coords = GetFinalRenderedCamCoord()
    local pX, pY, pZ = coords.x, coords.y, coords.z
    local dist = #(coords - vector3(x, y, z))
    local scale = (1 / dist) * scale
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function DUF_GetAllBlips()
    local blips = {}
    local blipIterator = GetStandardBlipEnumId()
    local blip = GetFirstBlipInfoId(blipIterator)
    while DoesBlipExist(blip) do
        blips[#blips + 1] = blip
        blip = GetNextBlipInfoId(blipIterator)
    end
    return blips
end

---@param text string | Text
---@param sprite number | Sprite 
---@param colour number | Colour 
---@param scale number | Scale
---@param category number | Category
---@param display number | Display
---@param blipType string | Type of blip (e.g. 'entity', 'coord', 'pickup')
---@param info any | Info (e.g. entity, coords, pickup)
local function DUF_CreateBlipFor(text, sprite, colour, scale, category, display, blipType, info)
    local blip = nil
    if blipType == 'entity' then
        blip = AddBlipForEntity(info)
    elseif blipType == 'coord' then
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
        SetBlipAsShortRange(blip, true)
        AddTextEntry(text, text)
        BeginTextCommandSetBlipName(text)
        EndTextCommandSetBlipName(blip)
    end
    return blip
end

exports('DrawText3D', function(x, y, z, text, scale) return DUF_DrawText3D(x, y, z, text, scale) end)
exports('GetAllBlips', function() return GetAllBlips() end)
exports('CreateBlipFor', function(text, sprite, colour, scale, category, display, blipType, info) return DUF_CreateBlipFor(text, sprite, colour, scale, category, display, blipType, info) end)
--[[ 
    Example usage:
    exports['duf']:DrawText3D(0.0, 0.0, 0.0, 'Hello World!', 1.0)
    ------------------------------------------------------------------ 
    Example usage:
    local blips = exports['duf']:GetAllBlips()
    for i = 1, #blips do
        RemoveBlip(blips[i])
    end
    ------------------------------------------------------------------
    Example usage:
    exports['duf']:CreateBlipFor('Player', 1, 1, 1.0, 1, 1, 'entity', PlayerPedId())
]]