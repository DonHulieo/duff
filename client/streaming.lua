---@class streaming
---@field loadanimdict fun(dict: string, isAsync: boolean?): boolean?
---@field loadanimset fun(set: string, isAsync: boolean?): boolean?
---@field loadcollision fun(model: string|number, isAsync: boolean?): boolean?
---@field loadipl fun(ipl: string, isAsync: boolean?): boolean?
---@field loadmodel fun(model: string|number, isAsync: boolean?): boolean?
---@field loadptfx fun(fx: string, isAsync: boolean?): boolean?
local streaming do
  local require = require
  local timer = require('duff.shared.math').timer
  local type, error, tostring = type, error, tostring
  local check_type = require('duff.shared.debug').checktype
  local promise, table = promise, table
  local await, wait, create_thread = Citizen.Await, Wait, CreateThread
  local game_timer, in_cd, joaat, valid = GetGameTimer, IsModelInCdimage, joaat, IsModelValid

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

  ---@async
  ---@param fn function
  ---@param ... any
  ---@return boolean?
  local function async_call(fn, ...)
    if not check_type(fn, 'function', async_call, 1) then return end
    wait(0) -- Yield to ensure the promise is created in a new thread
    local args = {...}
    local p = promise.new()
    create_thread(function()
      p:resolve(fn(table.unpack(args)))
    end)
    return await(p)
  end

  ---@param dict string
  ---@param isAsync boolean?
  ---@return boolean?
  local function req_anim_dict(dict, isAsync)
    if not dict or not check_type(dict, 'string', req_anim_dict, 1) or not DoesAnimDictExist(dict) then return end
    return not isAsync and load_asset(dict, HasAnimDictLoaded, RequestAnimDict) or async_call(load_asset, dict, HasAnimDictLoaded, RequestAnimDict)
  end

  ---@param set string
  ---@param isAsync boolean?
  ---@return boolean?
  local function req_anim_set(set, isAsync)
    if not set or not check_type(set, 'string', req_anim_set, 1) then return end
    return not isAsync and load_asset(set, HasAnimSetLoaded, RequestAnimSet) or async_call(load_asset, set, HasAnimSetLoaded, RequestAnimSet)
  end

  ---@param model string|number
  ---@param isAsync boolean?
  ---@return boolean?
  local function req_collision(model, isAsync)
    if not model or not in_cd(model) or not valid(model) then error('Invalid model requested: ' .. tostring(model), 2) end
    model = type(model) == 'number' and model or joaat(model)
    return not isAsync and load_asset(model, HasCollisionForModelLoaded, RequestCollisionForModel) or async_call(load_asset, model, HasCollisionForModelLoaded, RequestCollisionForModel)
  end

  ---@param ipl string
  ---@param isAsync boolean?
  ---@return boolean?
  local function req_ipl(ipl, isAsync)
    if not ipl or not check_type(ipl, 'string', req_ipl, 1) then return end
    return not isAsync and load_asset(ipl, IsIplActive, RequestIpl) or async_call(load_asset, ipl, IsIplActive, RequestIpl)
  end

  ---@param model string|number
  ---@param isAsync boolean?
  ---@return boolean?
  local function req_model(model, isAsync)
    if not model or not in_cd(model) or not valid(model) then error('Invalid model requested: ' .. tostring(model), 2) end
    model = type(model) == 'number' and model or joaat(model)
    return not isAsync and load_asset(model, HasModelLoaded, RequestModel) or async_call(load_asset, model, HasModelLoaded, RequestModel)
  end

  ---@param fx string
  ---@param isAsync boolean?
  ---@return boolean?
  local function req_ptfx(fx, isAsync)
    if not fx or not check_type(fx, 'string', req_ptfx, 1) then return end
    return not isAsync and load_asset(fx, HasNamedPtfxAssetLoaded, RequestNamedPtfxAsset) or async_call(load_asset, fx, HasNamedPtfxAssetLoaded, RequestNamedPtfxAsset)
  end

  return {loadanimdict = req_anim_dict, loadanimset = req_anim_set, loadcollision = req_collision, loadipl = req_ipl, loadmodel = req_model, loadptfx = req_ptfx}
end