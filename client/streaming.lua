---@class CStreaming
---@field async {[string]: fun(...: any): any?}
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
  local load, load_resource_file = load, LoadResourceFile
  local require = duff?.packages.require or load(load_resource_file('duff', 'shared/packages.lua'), '@duff/shared/packages.lua', 'bt', _ENV)().require
  local async_fn, math = duff?.async or require 'duff.shared.async', duff?.math or require 'duff.shared.math'
  local timer = math.timer
  local type, error = type, error
  local does_anim_dict_exist, has_anim_dict_loaded, request_anim_dict = DoesAnimDictExist, HasAnimDictLoaded, RequestAnimDict
  local has_anim_set_loaded, request_anim_set = HasAnimSetLoaded, RequestAnimSet
  local has_collision_for_model_loaded, request_collision_for_model = HasCollisionForModelLoaded, RequestCollisionForModel
  local is_ipl_active, request_ipl = IsIplActive, RequestIpl
  local is_model_in_cd, is_model_in_valid, has_model_loaded, request_model = IsModelInCdimage, IsModelValid, HasModelLoaded, RequestModel
  local has_named_ptfx_asset_loaded, request_named_ptfx_asset = HasNamedPtfxAssetLoaded, RequestNamedPtfxAsset

  ---@param func_name string The name of the function.
  ---@param param any The parameter to check.
  ---@param expected string|string[]? The expected type(s) of the parameter.
  ---@param check_fn (fun(param: any): boolean)? A function to check the parameter.
  ---@param errmsg string? The error message to display.
  ---@return boolean? valid Whether the parameter is valid.
  local function is_valid(func_name, param, expected, check_fn, errmsg)
    local param_type = type(param)
    local expected_type = type(expected)
    if not param or (expected and (param_type ~= expected and (expected_type == 'table' and not expected[param_type]))) then
      local concat_keys = function(tbl, sep) local string = '' for k in pairs(tbl) do string = string..k..sep end return string end
      error('bad argument #1 to \''..func_name..'\' ('..(expected_type == 'table' and 'expected one of '..concat_keys(expected, ', ')..'got ' or 'expected '..expected..' got ')..param_type..')', 3)
    end
    if check_fn and not check_fn(param) then
      error('bad argument #1 to \''..func_name..'\' ('..(errmsg or 'invalid parameter')..')', 3)
    end
    return true
  end

  ---@param asset string|number The asset to load.
  ---@param loaded function The function to check if the asset is loaded.
  ---@param load_fn function The function to load the asset.
  ---@return boolean loaded Whether the asset was loaded.
  local function load_asset(asset, loaded, load_fn)
    if not loaded(asset) then
      local time = game_timer()
      load_fn(asset)
      repeat Wait(0) until loaded(asset) or timer(time, 1000)
    end
    return loaded(asset) == 1
  end

  ---@param dict string The animation dictionary to load.
  ---@return boolean loaded Whether the animation dictionary was loaded.
  local function req_anim_dict(dict)
    if not is_valid('loadanimdict', dict, 'string', does_anim_dict_exist, 'invalid animation dictionary requested') then return false end
    return load_asset(dict, has_anim_dict_loaded, request_anim_dict)
  end

  ---@param dict string The animation dictionary to load.
  ---@return boolean? loaded Whether the animation dictionary was loaded.
  local function async_req_anim_dict(dict)
    if not is_valid('async.loadanimdict', dict, 'string', does_anim_dict_exist, 'invalid animation dictionary requested') then return false end
    return async_fn(req_anim_dict, dict)
  end

  ---@param set string The animation set to load.
  ---@return boolean loaded Whether the animation set was loaded.
  local function req_anim_set(set)
    if not is_valid('loadanimset', set, 'string', does_anim_dict_exist, 'invalid animation set requested') then return false end
    return load_asset(set, has_anim_set_loaded, request_anim_set)
  end

  ---@param set string The animation set to load.
  ---@return boolean? loaded Whether the animation set was loaded.
  local function async_req_anim_set(set)
    if not is_valid('async.loadanimset', set, 'string', does_anim_dict_exist, 'invalid animation set requested') then return false end
    return async_fn(req_anim_set, set)
  end

  ---@param model string|number The model to load collision for.
  ---@return boolean loaded Whether the collision was loaded.
  local function req_collision(model)
    if not is_valid('loadcollision', model, {['string'] = true, ['number'] = true}, function(fnd_mod)
      model = type(fnd_mod) == 'number' and fnd_mod or joaat(fnd_mod) & 0xFFFFFFFF
      return is_model_in_cd(model) and is_model_in_valid(model) end, 'invalid model requested')
    then return false end
    return load_asset(model, has_collision_for_model_loaded, request_collision_for_model)
  end

  ---@param model string|number The model to load collision for.
  ---@return boolean? loaded Whether the collision was loaded.
  local function async_req_collision(model)
    if not is_valid('async.loadcollision', model, {['string'] = true, ['number'] = true}, function(fnd_mod)
      model = type(fnd_mod) == 'number' and fnd_mod or joaat(fnd_mod) & 0xFFFFFFFF
      return is_model_in_cd(model) and is_model_in_valid(model) end, 'invalid model requested')
    then return false end
    return async_fn(req_collision, model)
  end

  ---@param ipl string The IPL to load.
  ---@return boolean loaded Whether the IPL was loaded.
  local function req_ipl(ipl)
    if not is_valid('loadipl', ipl, 'string') then return false end
    return load_asset(ipl, is_ipl_active, request_ipl)
  end

  ---@param ipl string The IPL to load.
  ---@return boolean? loaded Whether the IPL was loaded.
  local function async_req_ipl(ipl)
    if not is_valid('async.loadipl', ipl, 'string') then return false end
    return async_fn(req_ipl, ipl)
  end

  ---@param model string|number The model to load.
  ---@return boolean loaded Whether the model was loaded.
  local function req_model(model)
    if not is_valid('loadmodel', model, {['string'] = true, ['number'] = true}, function(fnd_mod)
      model = type(fnd_mod) == 'number' and fnd_mod or joaat(fnd_mod) & 0xFFFFFFFF
      return is_model_in_cd(model) and is_model_in_valid(model) end, 'invalid model requested')
    then return false end
    return load_asset(model, has_model_loaded, request_model)
  end

  ---@param model string|number The model to load.
  ---@return boolean? loaded Whether the model was loaded.
  local function async_req_model(model)
    if not is_valid('async.loadmodel', model, {['string'] = true, ['number'] = true}, function(fnd_mod)
      model = type(fnd_mod) == 'number' and fnd_mod or joaat(fnd_mod) & 0xFFFFFFFF
      return is_model_in_cd(model) and is_model_in_valid(model) end, 'invalid model requested')
    then return false end
    return async_fn(req_model, model)
  end

  ---@param fx string The particle effect asset to load.
  ---@return boolean loaded Whether the particle effect asset was loaded.
  local function req_ptfx(fx)
    if not is_valid('loadptfx', fx, 'string') then return false end
    return load_asset(fx, has_named_ptfx_asset_loaded, request_named_ptfx_asset)
  end

  ---@param fx string The particle effect asset to load.
  ---@return boolean? loaded Whether the particle effect asset was loaded.
  local function async_req_ptfx(fx)
    if not is_valid('async.loadptfx', fx, 'string') then return false end
    return async_fn(req_ptfx, fx)
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