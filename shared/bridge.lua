---@class bridge
---@field _DATA {FRAMEWORK: string, LIB: string?, INVENTORY: string?, EVENTS: {LOAD: string?, UNLOAD: string?, JOBDATA: string?, PLAYERDATA: string?, UPDATEOBJECT: string}}
---@field getframework fun(): string
---@field getlib fun(): string
---@field getinventory fun(): string
---@field getevents fun(): table
---@field getcore fun(): table
---@field getplayer fun(player: number|string?): table
---@field getidentifier fun(player: number|string?): string
---@field getjob fun(player: number|string?): table
---@field isplayerdowned fun(player: number|string?): boolean
---@field createcallback fun(name: string, cb: function)
---@field triggercallback fun(player: number|string?, name: string, cb: function, ...: any)
local bridge do
  local get_resource_state = GetResourceState
  local Frameworks = {['es_extended'] = 'esx', ['qb-core'] = 'qb'}
  local Inventories = {['ox_inventory'] = 'ox'}
  local Libs = {['ox_lib'] = 'ox'}
  local check_type = require('shared.debug').checktype
  local is_server = IsDuplicityVersion() == 1

  ---@param resource string
  ---@return boolean
  local function is_resource_present(resource)
    return get_resource_state(resource) ~= 'missing' and get_resource_state(resource) ~= 'unknown'
  end

  ---@param table table
  ---@param fn function
  ---@return any value
  local function for_each(table, fn)
    for key, value in pairs(table) do
      if fn(key) then return value end
    end
  end

  local FRAMEWORK = for_each(Frameworks, is_resource_present) --[[@as string?]]
  local INVENTORY = for_each(Inventories, is_resource_present) or FRAMEWORK --[[@as string?]]
  local LIB = for_each(Libs, is_resource_present) --[[@as string?]]
  local Core, Lib, PlayerData = nil, nil, nil
  local EVENTS = {
    LOAD = {['esx'] = 'esx:playerLoaded', ['qb'] = 'QBCore:Client:OnPlayerLoaded'},
    UNLOAD = {['esx'] = 'esx:onPlayerLogout', ['qb'] = 'QBCore:Client:OnPlayerUnload'},
    JOBDATA = {['esx'] = 'esx:setJob', ['qb'] = 'QBCore:Client:OnJobUpdate'},
    PLAYERDATA = {['esx'] = 'esx:setPlayerData', ['qb'] = 'QBCore:Player:SetPlayerData'},
    OBJECTUPDATE = {['qb'] = not is_server and 'QBCore:Client:UpdateObject' or 'QBCore:Server:UpdateObject'}
  }

  ---@return string?
  local function get_framework()
    return FRAMEWORK
  end

  ---@return string?
  local function get_inventory()
    return INVENTORY
  end

  ---@return QBCore|es_extended?
  local function get_core_object()
    if Core then return Core end
    if FRAMEWORK == 'esx' then
      ---@alias es_extended table
      Core = exports.es_extended:getSharedObject() --[[@as es_extended]]
    elseif FRAMEWORK == 'qb' then
      Core = exports['qb-core']:GetCoreObject() --[[@as QBCore]]
    end
    return Core
  end

  local function get_lib_object()
    if Lib then return Lib end
    if LIB == 'ox' then
      Lib = lib
    end
    return Lib
  end

  ---@param player number|string?
  ---@param fn function
  ---@param arg string|number?
  ---@return number|string?
  local function validate_source(player, fn, arg)
    player = player or source
    if check_type(player, {'number', 'string'}, fn, arg) then return end
    return player
  end

  ---@param fn function
  ---@param arg string|number?
  ---@return boolean?, string?
  local function ensure_core_object(fn, arg)
    if not Core then Core = get_core_object() end
    return check_type(Core, 'table', fn, arg)
  end

  ---@param player number|string?
  ---@return table? PlayerData
  local function get_player_data(player)
    if not ensure_core_object(get_player_data, 1) then return end
    if is_server then
      player = validate_source(player or source, get_player_data, 'player')
      if FRAMEWORK == 'esx' then
        return Core?.GetPlayerFromId(player)
      elseif FRAMEWORK == 'qb' then
        return Core?.Functions.GetPlayer(player)
      end
    else
      if FRAMEWORK == 'esx' then
        return Core?.GetPlayerData()
      elseif FRAMEWORK == 'qb' then
        return Core?.Functions.GetPlayerData()
      end
    end
  end

  local _DATA = {FRAMEWORK = FRAMEWORK, LIB = LIB, INVENTORY = INVENTORY,
    EVENTS = {
      LOAD = not is_server and EVENTS.LOAD[FRAMEWORK] or nil,
      UNLOAD = not is_server and EVENTS.UNLOAD[FRAMEWORK] or nil,
      JOBDATA = not is_server and EVENTS.JOBDATA[FRAMEWORK] or nil,
      PLAYERDATA = not is_server and EVENTS.PLAYERDATA[FRAMEWORK] or nil,
      OBJECTUPDATE = EVENTS.OBJECTUPDATE[FRAMEWORK]
    }
  }

  for event_type, event in pairs(_DATA.EVENTS) do
    if not event then goto continue end
    RegisterNetEvent(event, function(...)
      if event_type == 'LOAD' then
        PlayerData = get_player_data()
      elseif event_type == 'UNLOAD' then
        PlayerData = nil
      elseif event_type == 'JOBDATA' then
        if not PlayerData then return end
        PlayerData.job = ...
      elseif event_type == 'PLAYERDATA' then
        PlayerData = ...
      elseif event_type == 'OBJECTUPDATE' then
        if not validate_source(source, RegisterNetEvent, 'source') then return end
        Core = get_core_object()
      end
    end)
    ::continue::
  end

  ---@param player number|string? The source of the player
  ---@return string? identifier The identifier of the player
  local function get_player_identifier(player)
    if is_server then
      local player_data = get_player_data(validate_source(player or source, get_player_identifier, 'player'))
      if FRAMEWORK == 'esx' then
        return player_data?.getIdentifier()
      elseif FRAMEWORK == 'qb' then
        return player_data?.PlayerData.citizenid
      end
    else
      PlayerData = PlayerData or get_player_data()
      if FRAMEWORK == 'esx' then
        return PlayerData?.identifier
      elseif FRAMEWORK == 'qb' then
        return PlayerData?.citizenid
      end
    end
  end

  ---@param player number|string?
  ---@return table? JobData
  local function get_job_data(player)
    if is_server then
      local player_data = get_player_data(validate_source(player or source, get_job_data, 'player'))
      if FRAMEWORK == 'esx' then
        return player_data?.getJob()
      elseif FRAMEWORK == 'qb' then
        return player_data?.PlayerData.job
      end
    else
      PlayerData = PlayerData or get_player_data()
      if FRAMEWORK == 'esx' then
        return PlayerData?.job
      elseif FRAMEWORK == 'qb' then
        return PlayerData?.job
      end
    end
  end

  ---@param player number|string?
  ---@return boolean? isDowned
  local function is_player_downed(player)
    if is_server then
      local player_data = get_player_data(validate_source(player or source, is_player_downed, 'player'))
      if FRAMEWORK == 'esx' then
        return player_data?.getMeta('dead') or false
      elseif FRAMEWORK == 'qb' then
        return player_data?.PlayerData.metadata['inlaststand'] or player_data?.PlayerData.metadata['isdead'] or false
      end
    else
      PlayerData = PlayerData or get_player_data()
      if FRAMEWORK == 'esx' then
        return PlayerData?.dead or false
      elseif FRAMEWORK == 'qb' then
        return PlayerData?.metadata?['inlaststand'] or PlayerData?.metadata?['isdead'] or false
      end
    end
    return false
  end

  ---@param fn function
  ---@param arg string|number?
  ---@return boolean?, string?
  local function ensure_lib_object(fn, arg)
    if not Lib then Lib = get_lib_object() end
    return check_type(Lib, 'table', fn, arg)
  end

  ---@param name string The name of the callback
  ---@param cb function The callback to call when the event is triggered
  local function create_callback(name, cb, ...)
    if not ensure_core_object(create_callback, 'Core') then return end
    if is_server then
      if LIB == 'ox' then
        if not ensure_lib_object(create_callback, 'Lib') then return end
        Lib?.callback.register(name, cb)
      elseif FRAMEWORK == 'esx' then
        Core?.RegisterServerCallback(name, cb, ...)
      elseif FRAMEWORK == 'qb' then
        Core?.Functions.CreateCallback(name, cb)
      end
    else
      if LIB == 'ox' then
        if not ensure_lib_object(create_callback, 'Lib') then return end
        Lib?.callback.register(name, cb)
      elseif FRAMEWORK == 'esx' then
        Core?.RegisterClientCallback(name, cb)
      elseif FRAMEWORK == 'qb' then
        Core?.Functions.CreateClientCallback(name, cb)
      end
    end
  end

  ---@param player number|string? The source of the player if triggering a Client Callback
  ---@param name string The name of the callback to trigger
  ---@param cb function The callback to call when the event is triggered
  ---@param ... any The arguments to pass to the callback
  local function trigger_callback(player, name, cb, ...)
    if not ensure_core_object(create_callback, 'Core') then return end
    if is_server then
      player = validate_source(player or source, trigger_callback, 'player')
      if LIB == 'ox' then
        if not ensure_lib_object(trigger_callback, 'Lib') then return end
        return Lib?.callback(name, player, cb, ...)
      elseif FRAMEWORK == 'esx' then
        return Core?.TriggerClientCallback(player, name, cb, ...)
      elseif FRAMEWORK == 'qb' then
        return Core?.Functions.TriggerClientCallback(name, player, cb, ...)
      end
    else
      if LIB == 'ox' then
        if not ensure_lib_object(trigger_callback, 'Lib') then return end
        return Lib?.callback(name, false, cb, ...)
      elseif FRAMEWORK == 'esx' then
        return Core?.TriggerServerCallback(name, cb, ...)
      elseif FRAMEWORK == 'qb' then
        return Core?.Functions.TriggerCallback(name, cb, ...)
      end
    end
  end

  return {
    _DATA = _DATA,
    getframework = get_framework,
    getinventory = get_inventory,
    getcore = get_core_object,
    getlib = get_lib_object,
    getplayer = get_player_data,
    getidentifier = get_player_identifier,
    getjob = get_job_data,
    isplayerdowned = is_player_downed,
    createcallback = create_callback,
    triggercallback = trigger_callback
  }
end