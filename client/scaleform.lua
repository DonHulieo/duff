---@class CScaleform
---@field callmain fun(scaleform_handle: integer, method: string, ...: any): any?
---@field callfrontend fun(method: string, ...: any): any?
---@field callfrontendheader fun(method: string, ...: any): any?
---@field callhud fun(hud_component: integer, method: string, ...: any): any?
do
  local load, load_resource_file = load, LoadResourceFile
  local require = duff?.package.require or load(load_resource_file('duff', 'shared/package.lua'), '@duff/shared/package.lua', 't', _ENV)().require
  local math = duff?.math or require 'duff.shared.math'
  local begin_method, begin_method_frontend, begin_method_frontend_header, begin_method_hud = BeginScaleformMovieMethod, BeginScaleformMovieMethodOnFrontend, BeginScaleformMovieMethodOnFrontendHeader, BeginScaleformScriptHudMovieMethod
  local begin_param_string, end_param_string = BeginTextCommandScaleformString, EndTextCommandScaleformString
  local add_param_int, add_param_float =  ScaleformMovieMethodAddParamInt, ScaleformMovieMethodAddParamFloat
  local add_param_bool, add_param_texture = ScaleformMovieMethodAddParamBool, ScaleformMovieMethodAddParamTextureNameString
  local add_param_player, add_param_brief = ScaleformMovieMethodAddParamPlayerNameString, ScaleformMovieMethodAddParamLatestBriefString
  local end_method, end_method_return = EndScaleformMovieMethod, EndScaleformMovieMethodReturnValue
  local scaleform_labels = 0
  local is_int = math.isint

  ---@param key string
  ---@param label string
  local function add_label(key, label)
    if DoesTextLabelExist(key) and GetLabelText(key) == label then return end
    AddTextEntry(key, label)
  end

  ---@enum (key) brief_types
  local brief_types = {dialogue_brief = 0, help_brief = 1, mission_brief = 2}

  ---@param ... any
  local function add_params(...)
    local lim = select('#', ...)
    for i = 1, lim do
      local value = select(i, ...)
      local value_type = type(value)
      if value_type == 'string' then
        if not brief_types[value] then
          scaleform_labels += 1
          local key = 'SC_LBL_'..scaleform_labels
          add_label(key, value)
          begin_param_string(key)
          end_param_string()
        else
          add_param_brief(brief_types[value])
        end
      elseif value_type == 'number' then
        if is_int(value) then
          add_param_int(value)
        else
          add_param_float(value)
        end
      elseif value_type == 'boolean' then
        add_param_bool(value)
      elseif value_type == 'table' then
        if value.texture then
          add_param_texture(value.name)
        end
      end
    end
  end

  ---@param begin fun(): boolean
  ---@param finish fun(): any?
  ---@param ... any
  ---@return any?
  local function call_scaleform(begin, finish, ...)
    if not begin() then return end
    add_params(...)
    return finish()
  end

  ---@param scaleform_handle integer
  ---@param method string
  ---@param ... any
  ---@return any?
  local function call_main(scaleform_handle, method, ...)
    return call_scaleform(function() return begin_method(scaleform_handle, method) end, end_method, ...)
  end

  ---@param method string
  ---@param ... any
  ---@return any?
  local function call_frontend(method, ...)
    return call_scaleform(function() return begin_method_frontend(method) end, end_method, ...)
  end

  ---@param method string
  ---@param ... any
  ---@return any?
  local function call_frontend_header(method, ...)
    return call_scaleform(function() return begin_method_frontend_header(method) end, end_method, ...)
  end

  ---@param hud_component integer
  ---@param method string
  ---@param ... any
  local function call_hud(hud_component, method, ...)
    return call_scaleform(function() return begin_method_hud(hud_component, method) end, end_method_return, ...)
  end

  return {callmain = call_main, callfrontend = call_frontend, callfrontendheader = call_frontend_header, callhud = call_hud}
end