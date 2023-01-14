--------------------------------- Loading Assets --------------------------------- 

---@param model string or hash | Model to load
local function ReqModel(model)
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
local function ReqCollision(model)
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
local function ReqAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
local function ReqAnimSet(animSet)
    if not HasAnimSetLoaded(animSet) then
        RequestAnimSet(animSet)
        while not HasAnimSetLoaded(animSet) do
            Wait(0)
        end
    end
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
local function ReqClipSet(clipSet)
    if not HasClipSetLoaded(clipSet) then
        RequestClipSet(clipSet)
        while not HasClipSetLoaded(clipSet) do
            Wait(0)
        end
    end
end

---@param ipl string | IPL to load (e.g. 'TrevorsTrailerTrash')
local function ReqIpl(ipl)
    if not IsIplActive(ipl) then
        RequestIpl(ipl)
        while not IsIplActive(ipl) do
            Wait(0)
        end
    end
end

---@param asset string | Particle FX Asset (e.g. 'scr_jewelheist')
local function ReqNamedPtfxAsset(asset)
    if not HasNamedPtfxAssetLoaded(asset) then
        RequestNamedPtfxAsset(asset)
        while not HasNamedPtfxAssetLoaded(asset) do
            Wait(0)
        end
    end
    UseParticleFxAsset(asset)
end

---@param scaleform string | Scaleform to load (e.g. 'mp_big_message_freemode')
local function ReqScaleformMovie(scaleform)
    if not HasScaleformMovieLoaded(scaleform) then
        RequestScaleformMovie(scaleform)
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(0)
        end
    end
end

---@param dict string | Texture Dictionary to load (e.g. 'mpleaderboard')
local function ReqStreamedTextureDict(dict)
    if not HasStreamedTextureDictLoaded(dict) then
        RequestStreamedTextureDict(dict, true)
        while not HasStreamedTextureDictLoaded(dict) do
            Wait(0)
        end
    end
end

---@param asset string or hash | Weapon Asset to load (e.g. 'WEAPON_PISTOL')
local function ReqWeaponAsset(asset)
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

exports('DrawText3D', function(x, y, z, text, scale) return DrawText3D(x, y, z, text, scale) end)
--[[ 
    Example usage:
    local coords = GetEntityCoords(PlayerPedId())
    exports['duf']:DrawText3D(coords.x, coords.y, coords.z, 'Hello World!', 0.35)
]]