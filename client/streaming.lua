---@class CStreaming
---@field LoadAnimDict fun(dict: string, isAsync: boolean?): boolean?
---@field LoadAnimSet fun(set: string, isAsync: boolean?): boolean?
---@field LoadCollision fun(model: string|number, isAsync: boolean?): boolean?
---@field LoadIpl fun(ipl: string, isAsync: boolean?): boolean?
---@field LoadModel fun(model: string|number, isAsync: boolean?): boolean?
---@field LoadPtfx fun(fx: string, isAsync: boolean?): boolean?
local CStreaming do
  local game_timer = GetGameTimer
  local timer = require('duf.shared.math').timer
  local type = type
  local error = error
  local tostring = tostring
  local async_call = AsyncCall
  local in_cd = IsModelInCdimage
  local valid = IsModelValid
  local joaat = joaat

  ---@param asset string|number
  ---@param loaded function
  ---@param load function
  local function load_asset(asset, loaded, load)
    if not loaded(asset) then
      local time = game_timer()
      load(asset)
      repeat Wait(0) until loaded(asset) or timer(time, 1000)
    end
    return loaded(asset)
  end

  ---@param dict string
  ---@param isAsync boolean?
  ---@return boolean?
  local function reqAnimDict(dict, isAsync)
    if not dict or type(dict) ~= 'string' or not DoesAnimDictExist(dict) then error('Invalid animation dictionary requested: ' .. tostring(dict)) end
    return not isAsync and load_asset(dict, HasAnimDictLoaded, RequestAnimDict) or async_call(load_asset, dict, HasAnimDictLoaded, RequestAnimDict)
  end

  ---@param set string
  ---@param isAsync boolean?
  ---@return boolean?
  local function reqAnimSet(set, isAsync)
    if not set or type(set) ~= 'string' then error('Invalid animation set requested: ' .. tostring(set)) end
    return not isAsync and load_asset(set, HasAnimSetLoaded, RequestAnimSet) or async_call(load_asset, set, HasAnimSetLoaded, RequestAnimSet)
  end

  ---@param model string|number
  ---@param isAsync boolean?
  ---@return boolean?
  local function reqCollision(model, isAsync)
    if not model or not in_cd(model) or not valid(model) then error('Invalid model requested: ' .. tostring(model)) end
    model = type(model) == 'number' and model or joaat(model)
    return not isAsync and load_asset(model, HasCollisionForModelLoaded, RequestCollisionForModel) or async_call(load_asset, model, HasCollisionForModelLoaded, RequestCollisionForModel)
  end

  ---@param ipl string
  ---@param isAsync boolean?
  ---@return boolean?
  local function reqIpl(ipl, isAsync)
    if not ipl or type(ipl) ~= 'string' then error('Invalid IPL requested: ' .. tostring(ipl)) end
    return not isAsync and load_asset(ipl, IsIplActive, RequestIpl) or async_call(load_asset, ipl, IsIplActive, RequestIpl)
  end

  ---@param model string|number
  ---@param isAsync boolean?
  ---@return boolean?
  local function reqModel(model, isAsync)
    if not model or not in_cd(model) or not valid(model) then error('Invalid model requested: ' .. tostring(model)) end
    model = type(model) == 'number' and model or joaat(model)
    return not isAsync and load_asset(model, HasModelLoaded, RequestModel) or async_call(load_asset, model, HasModelLoaded, RequestModel)
  end

  ---@param fx string
  ---@param isAsync boolean?
  ---@return boolean?
  local function reqPtfx(fx, isAsync)
    if not fx or type(fx) ~= 'string' then error('Invalid PTFX requested: ' .. tostring(fx)) end
    return not isAsync and load_asset(fx, HasNamedPtfxAssetLoaded, RequestNamedPtfxAsset) or async_call(load_asset, fx, HasNamedPtfxAssetLoaded, RequestNamedPtfxAsset)
  end

  return {LoadAnimDict = reqAnimDict, LoadAnimSet = reqAnimSet, LoadCollision = reqCollision, LoadIpl = reqIpl, LoadModel = reqModel, LoadPtfx = reqPtfx}
end