--------------------------------- Loading Assets --------------------------------- 

---@param model string or hash | Model to load
---@return boolean | Returns true if model is loaded
local function ReqModel(model)
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then print('^3DUF^7: ^1Invalid model requested^7: ' .. model) return false end
    if type(model) == 'string' then
        model = joaat(model)
    end

    local loaded = function() return HasModelLoaded(model) end
    if not loaded() then
        RequestModel(model)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param model string or hash | Model to load collision for
---@return boolean | Returns true if collision is loaded
local function ReqCollision(model)
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then print('^3DUF^7: ^1Invalid model requested^7: ' .. model) return false end
    if type(model) == 'string' then
        model = joaat(model)
    end

    local loaded = function() return HasCollisionForModelLoaded(model) end
    if not loaded() then
        RequestCollisionForModel(model)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param dict string | Animation Dictionary (e.g. 'anim@mp_player_intmenu@key_fob@')
---@return boolean | Returns true if animation dictionary is loaded
local function ReqAnimDict(dict)
    local loaded = function() return HasAnimDictLoaded(dict) end
    if not loaded() then
        RequestAnimDict(dict)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
---@return boolean | Returns true if animation set is loaded
local function ReqAnimSet(animSet)
    local loaded = function() return HasAnimSetLoaded(animSet) end
    if not loaded() then
        RequestAnimSet(animSet)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param dict string | Animation Set (e.g. 'MOVE_M@DRUNK@VERYDRUNK')
---@return boolean | Returns true if animation set is loaded
local function ReqClipSet(clipSet)
    local loaded = function() return HasClipSetLoaded(clipSet) end
    if not loaded() then
        RequestClipSet(clipSet)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param ipl string | IPL to load (e.g. 'TrevorsTrailerTrash')
---@return boolean | Returns true if IPL is loaded
local function ReqIpl(ipl)
    local loaded = function() return IsIplActive(ipl) end
    if not loaded() then
        RequestIpl(ipl)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param asset string | Particle FX Asset (e.g. 'scr_jewelheist')
---@return boolean | Returns true if Particle FX Asset is loaded
local function ReqNamedPtfxAsset(asset)
    local loaded = function() return HasNamedPtfxAssetLoaded(asset) end
    if not loaded() then
        RequestNamedPtfxAsset(asset)
        repeat Wait(0) until loaded()
    end
    if loaded() then UseParticleFxAsset(asset) end
    return loaded()
end

---@param scaleform string | Scaleform to load (e.g. 'mp_big_message_freemode')
---@param return boolean | Returns true if Scaleform is loaded
local function ReqScaleformMovie(scaleform)
    local loaded = function() return HasScaleformMovieLoaded(scaleform) end
    if not loaded() then
        RequestScaleformMovie(scaleform)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param dict string | Texture Dictionary to load (e.g. 'mpleaderboard')
---@return boolean | Returns true if Texture Dictionary is loaded
local function ReqStreamedTextureDict(dict)
    local loaded = function() return HasStreamedTextureDictLoaded(dict) end
    if not loaded() then
        RequestStreamedTextureDict(dict, true)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@param asset string or hash | Weapon Asset to load (e.g. 'WEAPON_PISTOL')
---@return boolean | Returns true if Weapon Asset is loaded
local function ReqWeaponAsset(asset)
    if type(asset) == 'string' then
        asset = joaat(asset)
    end

    local loaded = function() return HasWeaponAssetLoaded(asset) end
    if not loaded() then
        RequestWeaponAsset(asset, 31, 0)
        repeat Wait(0) until loaded()
    end
    return loaded()
end

---@return boolean | Returns true if rope textures are loaded
local function ReqRopeTextures()
    local loaded = function() return RopeAreTexturesLoaded() end
    if not loaded() then
        RopeLoadTextures()
        repeat Wait(0) until loaded()
    end
    return loaded()
end

--------------------------------- Exports --------------------------------- 

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
exports('ReqRopeTextures', function() return ReqRopeTextures() end)

--[[
    Example usage:
    exports['duf']:ReqModel('prop_cs_cardbox_01') | exports['duf']:ReqModel(1302435108)
]]