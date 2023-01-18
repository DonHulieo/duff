--------------------------------- Loading Assets --------------------------------- 

---@param model string or hash | Model to load
---@return boolean | Returns true if model is loaded
local function ReqModel(model)
    local loaded = false
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then print('^3DUF^7: ^1Invalid model requested^7: ' .. model) return loaded end
    if type(model) == 'string' then
        model = joaat(model)
    end

    loaded = HasModelLoaded(model)
    if not loaded then
        RequestModel(model)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param model string or hash | Model to load collision for
---@return boolean | Returns true if collision is loaded
local function ReqCollision(model)
    local loaded = false
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then print('^3DUF^7: ^1Invalid model requested^7: ' .. model) return loaded end
    if type(model) == 'string' then
        model = joaat(model)
    end

    loaded = HasCollisionForModelLoaded(model)
    if not loaded then
        RequestCollisionForModel(model)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param dict string | Animation Dictionary (e.g. 'anim@mp_player_intmenu@key_fob@')
---@return boolean | Returns true if animation dictionary is loaded
local function ReqAnimDict(dict)
    local loaded = false
    loaded = HasAnimDictLoaded(dict)
    if not loaded then
        RequestAnimDict(dict)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
---@return boolean | Returns true if animation set is loaded
local function ReqAnimSet(animSet)
    local loaded = false
    loaded = HasAnimSetLoaded(animSet)
    if not loaded then
        RequestAnimSet(animSet)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
---@return boolean | Returns true if animation set is loaded
local function ReqClipSet(clipSet)
    local loaded = false
    loaded = HasClipSetLoaded(clipSet)
    if not loaded then
        RequestClipSet(clipSet)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param ipl string | IPL to load (e.g. 'TrevorsTrailerTrash')
---@return boolean | Returns true if IPL is loaded
local function ReqIpl(ipl)
    local loaded = false
    loaded = IsIplActive(ipl)
    if not loaded then
        RequestIpl(ipl)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param asset string | Particle FX Asset (e.g. 'scr_jewelheist')
---@return boolean | Returns true if Particle FX Asset is loaded
local function ReqNamedPtfxAsset(asset)
    local loaded = false
    loaded = HasNamedPtfxAssetLoaded(asset)
    if not loaded then
        RequestNamedPtfxAsset(asset)
        while not loaded do
            Wait(100)
        end
    end
    if loaded then UseParticleFxAsset(asset) end
    return loaded
end

---@param scaleform string | Scaleform to load (e.g. 'mp_big_message_freemode')
---@param return boolean | Returns true if Scaleform is loaded
local function ReqScaleformMovie(scaleform)
    local loaded = false
    loaded = HasScaleformMovieLoaded(scaleform)
    if not loaded then
        RequestScaleformMovie(scaleform)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param dict string | Texture Dictionary to load (e.g. 'mpleaderboard')
---@return boolean | Returns true if Texture Dictionary is loaded
local function ReqStreamedTextureDict(dict)
    local loaded = false
    loaded = HasStreamedTextureDictLoaded(dict)
    if not loaded then
        RequestStreamedTextureDict(dict, true)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

---@param asset string or hash | Weapon Asset to load (e.g. 'WEAPON_PISTOL')
---@return boolean | Returns true if Weapon Asset is loaded
local function ReqWeaponAsset(asset)
    local loaded = false
    if type(asset) == 'string' then
        asset = joaat(asset)
    end

    loaded = HasWeaponAssetLoaded(asset)
    if not loaded then
        RequestWeaponAsset(asset, 31, 0)
        while not loaded do
            Wait(100)
        end
    end
    return loaded
end

exports('ReqModel', function(model) return ReqModel(model) end)
exports('ReqCollision', function(model) return ReqCollision(model) end)
exports('ReqAnimDict', function(dict) return ReqAnimDict(dict) end)
exports('ReqAnimSet', function(animSet) return ReqAnimSet(animSet) end)
exports('ReqClipSet', function(clipSet) return ReqClipSet(clipSet) end)
exports('ReqIpl', function(ipl) return ReqIpl(ipl) end)
exports('ReqNamedPtfxAsset', function(asset) return ReqNamedPtfxAsset(asset) end)
exports('ReqScaleformMovie', function(scaleform) return ReqScaleformMovie(scaleform) end)
exports('ReqStreamedTextureDict', function(dict) return ReqStreamedTextureDict(dict) end)
exports('ReqWeaponAsset', function(asset) return ReqWeaponAsset(asset) end)
--[[
    Example usage:
    exports['duf']:ReqModel('prop_cs_cardbox_01') | exports['duf']:ReqModel(1302435108)
]]

--------------------------------- DrawText --------------------------------- 

---@param x number | X coordinate
---@param y number | Y coordinate
---@param z number | Z coordinate
---@param text string | Text to draw
---@param scale number | Scale of text
local function DrawText3D(x, y, z, text, scale)
    if type(x) == 'vector3' then
        scale = z
        text = y
        x, y, z = x.x, x.y, x.z
    end
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local coords = GetFinalRenderedCamCoord()
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

exports('DrawText3D', function(x, y, z, text, scale) return DrawText3D(x, y, z, text, scale) end)
--[[ 
    Example usage:
    local coords = GetEntityCoords(PlayerPedId())
    exports['duf']:DrawText3D(coords, 'Hello World!', 0.35)
]]