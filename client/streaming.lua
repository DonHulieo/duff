---@class CStreaming
---@field loadanimdict fun(dict: string): boolean Loads an animation dictionary.
---@field async.loadanimdict fun(dict: string): boolean? Loads an animation dictionary without blocking the main thread.
---@field loadanimset fun(set: string): boolean Loads an animation set.
---@field async.loadanimset fun(set: string): boolean? Loads an animation set without blocking the main thread.
---@field loadcollision fun(model: string|number): boolean Loads collision for a model.
---@field async.loadcollision fun(model: string|number): boolean? Loads collision for a model without blocking the main thread.
---@field loadipl fun(ipl: string): boolean Loads an IPL.
---@field async.loadipl fun(ipl: string): boolean? Loads an IPL without blocking the main thread.
---@field loadmodel fun(model: string|number): boolean Loads a model.
---@field async.loadmodel fun(model: string|number): boolean? Loads a model without blocking the main thread.
---@field loadptfx fun(fx: string): boolean Loads a particle effect asset.
---@field async.loadptfx fun(fx: string): boolean? Loads a particle effect asset without blocking the main thread.
do
  local game_timer = GetGameTimer
  local require = require
  local timer = require('duff.shared.math').timer
  local type, error, tostring = type, error, tostring
  local does_anim_dict_exist, has_anim_dict_loaded, request_anim_dict = DoesAnimDictExist, HasAnimDictLoaded, RequestAnimDict
  local has_anim_set_loaded, request_anim_set = HasAnimSetLoaded, RequestAnimSet
  local has_collision_for_model_loaded, request_collision_for_model = HasCollisionForModelLoaded, RequestCollisionForModel
  local is_ipl_active, request_ipl = IsIplActive, RequestIpl
  local is_model_in_cd, is_model_in_valid, has_model_loaded, request_model = IsModelInCdimage, IsModelValid, HasModelLoaded, RequestModel
  local has_named_ptfx_asset_loaded, request_named_ptfx_asset = HasNamedPtfxAssetLoaded, RequestNamedPtfxAsset
  ---@module 'duff.shared.async'
  local async = require 'duff.shared.async'

  ---@param asset string|number The asset to load.
  ---@param loaded function The function to check if the asset is loaded.
  ---@param load function The function to load the asset.
  ---@return boolean loaded Whether the asset was loaded.
  local function load_asset(asset, loaded, load)
    if not loaded(asset) then
      local time = game_timer()
      load(asset)
      repeat Wait(0) until loaded(asset) or timer(time, 1000)
    end
    return loaded(asset) == 1
  end

  ---@param dict string The animation dictionary to load.
  ---@return boolean? loaded Whether the animation dictionary was loaded.
  local function req_anim_dict(dict)
    if not dict or type(dict) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(dict)..')', 0) end
    if not does_anim_dict_exist(dict) then error('bad argument #1 to \'%s\' (dictionary does not exist)', 0) end
    return load_asset(dict, has_anim_dict_loaded, request_anim_dict)
  end

  ---@param dict string The animation dictionary to load.
  ---@return boolean? loaded Whether the animation dictionary was loaded.
  local function async_req_anim_dict(dict)
    if not dict or type(dict) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(dict)..')', 0) end
    return async(req_anim_dict, dict)
  end

  ---@param set string The animation set to load.
  ---@return boolean loaded Whether the animation set was loaded.
  local function req_anim_set(set)
    if not set or type(set) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(set)..')', 0) end
    return load_asset(set, has_anim_set_loaded, request_anim_set)
  end

  ---@param set string The animation set to load.
  ---@return boolean? loaded Whether the animation set was loaded.
  local function async_req_anim_set(set)
    if not set or type(set) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(set)..')', 0) end
    return async(req_anim_set, set)
  end

  ---@param model string|number The model to load collision for.
  ---@return boolean loaded Whether the collision was loaded.
  local function req_collision(model)
    local param_type = type(model)
    if not model or (param_type ~= 'string' and param_type ~= 'number') then error('bad argument #1 to \'%s\' (string or number expected, got '..param_type..')', 0) end
    model = type(model) == 'number' and model or joaat(model)
    if not is_model_in_cd(model) or not is_model_in_valid(model) then error('bad argument #1 to \'%s\' (invalid model requested: '..tostring(model)..')', 0) end
    return load_asset(model, has_collision_for_model_loaded, request_collision_for_model)
  end

  ---@param model string|number The model to load collision for.
  ---@return boolean? loaded Whether the collision was loaded.
  local function async_req_collision(model)
    local param_type = type(model)
    if not model or (param_type ~= 'string' and param_type ~= 'number') then error('bad argument #1 to \'%s\' (string or number expected, got '..param_type..')', 0) end
    model = type(model) == 'number' and model or joaat(model)
    if not is_model_in_cd(model) or not is_model_in_valid(model) then error('bad argument #1 to \'%s\' (invalid model requested: '..tostring(model)..')', 0) end
    return async(req_collision, model)
  end

  ---@param ipl string The IPL to load.
  ---@return boolean loaded Whether the IPL was loaded.
  local function req_ipl(ipl)
    if not ipl or type(ipl) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(ipl)..')', 0) end
    return load_asset(ipl, is_ipl_active, request_ipl)
  end

  ---@param ipl string The IPL to load.
  ---@return boolean? loaded Whether the IPL was loaded.
  local function async_req_ipl(ipl)
    if not ipl or type(ipl) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(ipl)..')', 0) end
    return async(req_ipl, ipl)
  end

  ---@param model string|number The model to load.
  ---@return boolean loaded Whether the model was loaded.
  local function req_model(model)
    local param_type = type(model)
    if not model or (param_type ~= 'string' and param_type ~= 'number') then error('bad argument #1 to \'%s\' (string or number expected, got '..param_type..')', 0) end
    model = type(model) == 'number' and model or joaat(model)
    if not is_model_in_cd(model) or not is_model_in_valid(model) then error('bad argument #1 to \'%s\' (invalid model requested: '..tostring(model)..')', 0) end
    return load_asset(model, has_model_loaded, request_model)
  end

  ---@param model string|number The model to load.
  ---@return boolean? loaded Whether the model was loaded.
  local function async_req_model(model)
    local param_type = type(model)
    if not model or (param_type ~= 'string' and param_type ~= 'number') then error('bad argument #1 to \'%s\' (string or number expected, got '..param_type..')', 0) end
    model = type(model) == 'number' and model or joaat(model)
    if not is_model_in_cd(model) or not is_model_in_valid(model) then error('bad argument #1 to \'%s\' (invalid model requested: '..tostring(model)..')', 0) end
    return async(req_model, model)
  end

  ---@param fx string The particle effect asset to load.
  ---@return boolean loaded Whether the particle effect asset was loaded.
  local function req_ptfx(fx)
    if not fx or type(fx) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(fx)..')', 0) end
    return load_asset(fx, has_named_ptfx_asset_loaded, request_named_ptfx_asset)
  end

  ---@param fx string The particle effect asset to load.
  ---@return boolean? loaded Whether the particle effect asset was loaded.
  local function async_req_ptfx(fx)
    if not fx or type(fx) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(fx)..')', 0) end
    return async(req_ptfx, fx)
  end

  return {
    async = {
      loadanimdict = async_req_anim_dict,
      loadanimset = async_req_anim_set,
      loadcollision = async_req_collision,
      loadipl = async_req_ipl,
      loadmodel = async_req_model,
      loadptfx = async_req_ptfx
    },
    loadanimdict = req_anim_dict,
    loadanimset = req_anim_set,
    loadcollision = req_collision,
    loadipl = req_ipl,
    loadmodel = req_model,
    loadptfx = req_ptfx
  }
end