---@class bridge
---@field _DATA {FRAMEWORK: string?, LIB: string?, INVENTORY: string?, EVENTS: {LOAD: string?, UNLOAD: string?, JOBDATA: string?, PLAYERDATA: string?, UPDATEOBJECT: string?}, ITEMS: {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}?}
---@field getframework fun(): string
---@field getlib fun(): string
---@field getinventory fun(): string
---@field getcore fun(): table
---@field getplayer fun(player: integer|string?): table
---@field getidentifier fun(player: integer|string?): string
---@field getplayername fun(player: integer|string?): string
---@field getjob fun(player: integer|string?): {name: string, label: string, grade: number, grade_name: string, grade_label: string, job_type: string, salary: number}?
---@field doesplayerhavegroup fun(player: integer|string?, groups: string|string[]): boolean?
---@field isplayerdowned fun(player: integer|string?): boolean
---@field createcallback fun(name: string, cb: function)
---@field triggercallback fun(player: integer|string?, name: string, cb: function, ...: any): any?
---@field getallitems fun(): {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}?
---@field getitem fun(name: string): {name: string, label: string, weight: number, usable: boolean, unique: boolean}?
---@field createuseableitem fun(name: string, cb: fun(src: number|string))
---@field additem fun(player: integer|string?, item: string, amount: integer): boolean?
---@field removeitem fun(player: integer|string?, item: string, amount: integer): boolean?
---@field addlocalentity fun(entities: integer|integer[], options: {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: fun(entity: number, distance: number)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]})
---@field removelocalentity fun(entities: integer|integer[], targets: string|string[]?)
local bridge do
  local get_resource_state = GetResourceState
  local Frameworks = {['es_extended'] = 'esx', ['qb-core'] = 'qb'}
  local Inventories = {['ox_inventory'] = 'ox'}
  local Libs = {['ox_lib'] = 'ox'}
  local Targets = {['ox_target'] = 'ox', ['qb_target'] = 'qb'}
  local check_type = require('duff.shared.debug').checktype
  local is_server = IsDuplicityVersion() == 1

  --------------------- INTERNAL ---------------------

  ---@param resource string
  ---@return boolean
  local function is_resource_present(resource)
    local state = get_resource_state(resource)
    return state ~= 'missing' and state ~= 'unknown'
  end

  ---@param table table<any, any>|any?
  ---@param fn fun(key: any, value: any?): boolean
  ---@return any value
  local function for_each(table, fn)
    table = type(table) == 'table' and table or {table}
    local value = nil
    if not table then return value end
    for k, v in pairs(table) do
      if fn(k, v) then value = v break end
    end
    return value
  end

  ---@param table table<any, any>|any?
  ---@param value any
  ---@return any?
  local function get_key(table, value)
    local key = nil
    table = type(table) == 'table' and table or {table}
    if not table then return key end
    for k, v in pairs(table) do
      if v == value then key = k break end
    end
    return key
  end

  ---@param table {[string]: {resource: string, method: string?}}
  ---@param export_type string
  ---@return any?
  local function consume_export(table, export_type)
    if not table or not table[export_type] then return end
    local export = table[export_type]
    return export.method and exports[export.resource][export.method]() or exports[export.resource]
  end

  ---@param array1 any[]|any
  ---@param array2 any[]|any
  ---@return any[]|any
  local function merge_arrays(array1, array2)
    if not array1 then return end
    if not array2 then return array1 end
    array1, array2 = type(array1) == 'table' and array1 or {array1}, type(array2) == 'table' and array2 or {array2}
    for i = 1, #array2 do array1[#array1 + 1] = array2[i] end
    return array1
  end

  --------------------- SHARED ---------------------

  local FRAMEWORK = for_each(Frameworks, is_resource_present) --[[@as 'esx'|'qb'?]]
  local INVENTORY = for_each(Inventories, is_resource_present) or FRAMEWORK --[[@as string?]]
  local LIB = for_each(Libs, is_resource_present) --[[@as string?]]
  local TARGET = for_each(Targets, is_resource_present) --[[@as string?]]
  local EXPORTS = {
    CORE = {['esx'] = 'getSharedObject', ['qb'] = 'GetCoreObject'},
    INV = {['ox'] = 'ox_inventory'},
    TARG = {['ox'] = 'ox_target', ['qb'] = 'qb-target'}
  }
  local EVENTS = {
    LOAD = {['esx'] = 'esx:playerLoaded', ['qb'] = 'QBCore:Client:OnPlayerLoaded'},
    UNLOAD = {['esx'] = 'esx:onPlayerLogout', ['qb'] = 'QBCore:Client:OnPlayerUnload'},
    JOBDATA = {['esx'] = 'esx:setJob', ['qb'] = 'QBCore:Client:OnJobUpdate'},
    PLAYERDATA = {['esx'] = 'esx:setPlayerData', ['qb'] = 'QBCore:Player:SetPlayerData'},
    OBJECTUPDATE = {['qb'] = not is_server and 'QBCore:Client:UpdateObject' or 'QBCore:Server:UpdateObject'}
  }
  local NO_METHODS = {['INV'] = 'ox', ['TARGET'] = {'ox', 'qb'}}
  EXPORTS = {
    CORE = {resource = get_key(Frameworks, FRAMEWORK), method = for_each(NO_METHODS.CORE, function(_, value) return value == FRAMEWORK end) == nil and EXPORTS.CORE[FRAMEWORK] or nil},
    INV = {resource = get_key(Inventories, INVENTORY), method = for_each(NO_METHODS.INV, function(_, value) return value == INVENTORY end) == nil and EXPORTS.INV[INVENTORY] or nil},
    TARG = {resource = get_key(Targets, TARGET), method = for_each(NO_METHODS.TARGET, function(_, value) return value == TARGET end) == nil and EXPORTS.TARG[TARGET] or nil}
  }
  local Core, Lib, Inv = consume_export(EXPORTS, 'CORE') --[[@as QBCore|table?]], consume_export(EXPORTS, 'LIB'), consume_export(EXPORTS, 'INV') --[[@as ox_inventory|table?]]
  local PlayerData = nil

  ---@return string?
  local function get_framework()
    return FRAMEWORK
  end

  ---@return string?
  local function get_inventory()
    return INVENTORY
  end

  ---@return QBCore|table?
  local function get_core_object()
    if not FRAMEWORK then return end
    Core = not Core and consume_export(EXPORTS, 'CORE') or Core
    return Core
  end

  local function get_lib_object()
    if not LIB then return end
    if Lib then return Lib end
    if LIB == 'ox' then
      Lib = lib
    end
    return Lib
  end

  ---@param player integer|string?
  ---@param fn function
  ---@param arg string|number?
  ---@return integer?
  local function validate_source(player, fn, arg)
    player = player or source
    if not check_type(player, {'number', 'string'}, fn, arg) then return end
    return type(player) ~= 'number' and tonumber(player) or player
  end

  ---@param fn function
  ---@param arg string|number?
  ---@return boolean?, string?
  local function ensure_core_object(fn, arg)
    if not Core then Core = get_core_object() end
    return check_type(Core, 'table', fn, arg)
  end

  ---@param player integer|string?
  ---@return table? PlayerData
  local function get_player_data(player)
    if not ensure_core_object(get_player_data, 1) then return end ---@cast Core -?
    if is_server then
      player = validate_source(player or source, get_player_data, 'player')
      if FRAMEWORK == 'esx' then
        return Core.GetPlayerFromId(player)
      elseif FRAMEWORK == 'qb' then
        return Core.Functions.GetPlayer(player)
      end
    else
      if PlayerData then return PlayerData end
      if FRAMEWORK == 'esx' then
        PlayerData = Core.GetPlayerData()
      elseif FRAMEWORK == 'qb' then
        PlayerData = Core.Functions.GetPlayerData()
      end
      return PlayerData
    end
  end

  ---@enum job_types
  local job_types = {['leo'] = {['police'] = true, ['fib'] = true, ['sheriff'] = true}, ['ems'] = {['ambulance'] = true, ['fire'] = true}}
  local function convert_job_data(data)
    if not data then return end
    if FRAMEWORK == 'esx' then
      local name = data.name
      return {
        name = name,
        label = data.label,
        grade = data.grade,
        grade_name = data.grade_name,
        grade_label = data.grade_label,
        job_type = for_each(job_types, function(_, value) return value[name] end) or '',
        salary = data.salary
      }
    elseif FRAMEWORK == 'qb' then
      local name = data.name
      local grade = data.grade
      return {
        name = name,
        label = data.label,
        grade = grade.level,
        grade_name = grade.name,
        grade_label = grade.name,
        job_type = data.type or for_each(job_types, function(_, value) return value[name] end) or '',
        salary = data.payment
      }
    end
  end

  EVENTS = {
    LOAD = not is_server and EVENTS.LOAD[FRAMEWORK] or nil,
    UNLOAD = not is_server and EVENTS.UNLOAD[FRAMEWORK] or nil,
    JOBDATA = not is_server and EVENTS.JOBDATA[FRAMEWORK] or nil,
    PLAYERDATA = not is_server and EVENTS.PLAYERDATA[FRAMEWORK] or nil,
    OBJECTUPDATE = EVENTS.OBJECTUPDATE[FRAMEWORK]
  }

  for event_type, event in pairs(EVENTS) do
    if event then
      RegisterNetEvent(event, function(...)
        if event_type == 'LOAD' then
          PlayerData = get_player_data()
        elseif event_type == 'UNLOAD' then
          PlayerData = nil
        elseif event_type == 'JOBDATA' then
          if not PlayerData then return end
          PlayerData.job = convert_job_data(...)
        elseif event_type == 'PLAYERDATA' then
          PlayerData = ...
        elseif event_type == 'OBJECTUPDATE' then
          if not validate_source(source, RegisterNetEvent, 'source') then return end
          Core = get_core_object()
        end
      end)
    end
  end

  ---@param player integer|string?
  ---@param fn function
  ---@param arg string|number?
  ---@return table|boolean?
  local function ensure_player_data(player, fn, arg)
    local player_data = get_player_data(is_server and validate_source(player or source, fn, 'player') or nil)
    if not is_server and not PlayerData then PlayerData = player_data end
    return check_type(not is_server and PlayerData or player_data, 'table', fn, arg) and player_data
  end

  ---@param player integer|string? The source of the player
  ---@return string? identifier The identifier of the player
  local function get_player_identifier(player)
    local player_data = ensure_player_data(player or source, get_player_identifier, 'player') ---@cast player_data -?
    if is_server then
      if FRAMEWORK == 'esx' then
        return player_data.getIdentifier()
      elseif FRAMEWORK == 'qb' then
        return player_data.PlayerData.citizenid
      end
    else
      if FRAMEWORK == 'esx' then
        return player_data.identifier
      elseif FRAMEWORK == 'qb' then
        return player_data.citizenid
      end
    end
  end

  ---@param player integer|string? The source of the player if calling from the server
  ---@return string? name The name of the player
  local function get_player_name(player)
    local player_data = ensure_player_data(player or source, get_player_identifier, 'player') ---@cast player_data -?
    if is_server then
      if FRAMEWORK == 'esx' then
        return player_data.getName()
      elseif FRAMEWORK == 'qb' then
        return player_data.PlayerData.charinfo.firstname..' '..player_data.PlayerData.charinfo.lastname
      end
    else
      if FRAMEWORK == 'esx' then
        return player_data.firstName..' '..player_data.lastName
      elseif FRAMEWORK == 'qb' then
        return player_data.charinfo.firstname..' '..player_data.charinfo.lastname
      end
    end
  end

  ---@param player integer|string?
  ---@return {name: string, label: string, grade: number, grade_name: string, grade_label: string, job_type: string, salary: number}? job_data
  local function get_job_data(player)
    local player_data = ensure_player_data(player or source, get_job_data, 'player') ---@cast player_data -?
    local found_data = nil
    if is_server then
      if FRAMEWORK == 'esx' then
        found_data = player_data.getJob()
        if not found_data then return end
        return convert_job_data(found_data)
      elseif FRAMEWORK == 'qb' then
        found_data = player_data.PlayerData.job
        if not found_data then return end
        return convert_job_data(found_data)
      end
    else
      if FRAMEWORK == 'esx' then
        found_data = player_data.job
        if not found_data then return end
        return convert_job_data(found_data)
      elseif FRAMEWORK == 'qb' then
        found_data = player_data.job
        if not found_data then return end
        return convert_job_data(found_data)
      end
    end
  end

  ---@param player integer|string?
  ---@return {name: string, label: string, grade: number, grade_name: string}? gang_data
  local function get_gang_data(player)
    local player_data = ensure_player_data(player or source or nil, get_gang_data, 'player') ---@cast player_data -?
    if is_server then
      if FRAMEWORK == 'qb' then
        local found_data = player_data.PlayerData.gang
        if not found_data then return end
        local grade = found_data.grade
        return {
          name = found_data.name,
          label = found_data.label,
          grade = grade.level,
          grade_name = grade.name
        }
      end
    else
      if FRAMEWORK == 'qb' then
        local found_data = player_data.gang
        if not found_data then return end
        local grade = found_data.grade
        return {
          name = found_data.name,
          label = found_data.label,
          grade = grade.level,
          grade_name = grade.name
        }
      end
    end
  end

  ---@param player integer|string?
  ---@param groups string|string[]
  ---@return boolean? has_group
  local function does_player_have_group(player, groups)
    local job_data = get_job_data(player or source or nil)
    local gang_data = get_gang_data(player or source or nil)
    if not job_data and not gang_data then return end
    if not check_type(groups, {'string', 'table'}, does_player_have_group, 'groups') then return end
    groups = type(groups) == 'table' and groups or {groups}
    for i = 1, #groups do
      local group = groups[i]
      if job_data and (job_data.name == group or job_data.label == group or job_data.job_type == group) then return true end
      if gang_data and (gang_data.name == group or gang_data.label == group) then return true end
    end
    return false
  end

  ---@param player integer|string?
  ---@return boolean? isDowned
  local function is_player_downed(player)
    local player_data = ensure_player_data(player or source, is_player_downed, 'player') ---@cast player_data -?
    if is_server then
      if FRAMEWORK == 'esx' then
        return player_data.getMeta('dead') or false
      elseif FRAMEWORK == 'qb' then
        return player_data.PlayerData.metadata['inlaststand'] or player_data.PlayerData.metadata['isdead'] or false
      end
    else
      if FRAMEWORK == 'esx' then
        return player_data.dead or false
      elseif FRAMEWORK == 'qb' then
        return player_data.metadata['inlaststand'] or player_data.metadata['isdead'] or false
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
    if not ensure_core_object(create_callback, 'Core') then return end ---@cast Core -?
    if is_server then
      if LIB == 'ox' then
        if not ensure_lib_object(create_callback, 'Lib') then return end ---@cast Lib -?
        Lib.callback.register(name, cb)
      elseif FRAMEWORK == 'esx' then
        Core.RegisterServerCallback(name, cb, ...)
      elseif FRAMEWORK == 'qb' then
        Core.Functions.CreateCallback(name, cb)
      end
    else
      if LIB == 'ox' then
        if not ensure_lib_object(create_callback, 'Lib') then return end ---@cast Lib -?
        Lib.callback.register(name, cb)
      elseif FRAMEWORK == 'esx' then
        Core.RegisterClientCallback(name, cb)
      elseif FRAMEWORK == 'qb' then
        Core.Functions.CreateClientCallback(name, cb)
      end
    end
  end

  ---@param player integer|string? The source of the player if triggering a Client Callback
  ---@param name string The name of the callback to trigger
  ---@param cb function The callback to call when the event is triggered
  ---@param ... any The arguments to pass to the callback
  local function trigger_callback(player, name, cb, ...)
    if not ensure_core_object(create_callback, 'Core') then return end ---@cast Core -?
    if is_server then
      if not ensure_player_data(source, trigger_callback, 'source') then return end
      player = validate_source(player or source, trigger_callback, 'player') ---@cast player -?
      if LIB == 'ox' then
        if not ensure_lib_object(trigger_callback, 'Lib') then return end ---@cast Lib -?
        return Lib.callback(name, player, cb, ...)
      elseif FRAMEWORK == 'esx' then
        return Core.TriggerClientCallback(player, name, cb, ...)
      elseif FRAMEWORK == 'qb' then
        return Core.Functions.TriggerClientCallback(name, player, cb, ...)
      end
    else
      if LIB == 'ox' then
        if not ensure_lib_object(trigger_callback, 'Lib') then return end ---@cast Lib -?
        return Lib.callback(name, false, cb, ...)
      elseif FRAMEWORK == 'esx' then
        return Core.TriggerServerCallback(name, cb, ...)
      elseif FRAMEWORK == 'qb' then
        return Core.Functions.TriggerCallback(name, cb, ...)
      end
    end
  end

  ---@return ox_inventory|table?
  local function get_inv_object()
    if not INVENTORY or INVENTORY == FRAMEWORK then return end
    if Inv then return Inv end
    Inv = consume_export(EXPORTS, 'INV')
    return Inv
  end

  ---@param fn function
  ---@param arg string|number?
  ---@return boolean?, string?
  local function ensure_inv_object(fn, arg)
    if not Inv and INVENTORY ~= FRAMEWORK then
      Inv = get_inv_object()
    elseif INVENTORY == FRAMEWORK then
      if ensure_core_object(fn, arg) then Inv = {} end
    end
    return check_type(Inv, 'table', fn, arg)
  end

  --------------------- SERVER ---------------------

  local Items = nil

  ---@return {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}?
  local function get_all_items()
    if not is_server then return end
    if not ensure_inv_object(get_all_items, 'Inventory') then return end
    ---@cast Inv -?
    ---@cast Core -?
    if Items then return Items end
    if not Items then Items = {} end
    local found_items = nil
    if INVENTORY == 'ox' then
      found_items = Inv:Items()
      if not found_items then return end
      for name, data in pairs(found_items) do
        local client_data, server_data = data.client, data.server
        local useable = not data.consume and (client_data?.status or client_data?.useTime or client_data?.export or server_data?.export) or data.consume == 1
        Items[name] = {name = name, label = data.label, weight = data.weight or 0, useable = useable, unique = data.stack == nil and true or data.stack}
      end
    elseif INVENTORY == 'esx' then
      found_items = MySQL.Async.fetchAll('SELECT * FROM items')
      if not found_items then return end
      for _, item in ipairs(found_items) do
        local name = item.name
        Items[name] = {name = name, label = item.label, weight = item.weight, useable = Core.GetUsableItems()[name] ~= nil, unique = item.rare}
      end
    elseif INVENTORY == 'qb' then
      found_items = Core.Shared.Items
      for name, item in pairs(found_items) do
        Items[name] = {name = name, label = item.label, weight = item.weight, useable = item.useable, unique = item.unique}
      end
    end
    return Items
  end

  ---@param fn function
  ---@param arg string|number?
  ---@return boolean?, string?
  local function ensure_items_object(fn, arg)
    if not Items then Items = get_all_items() end
    return check_type(Items, 'table', fn, arg)
  end

  ---@param name string The name of the item
  ---@return {name: string, label: string, weight: number, usable: boolean, unique: boolean}? item_data
  local function get_item(name)
    if not is_server or not name then return end
    if not ensure_inv_object(get_item, 'Inventory') then return end ---@cast Inv -?
    if not ensure_items_object(get_item, 'Items') then return end ---@cast Items -?
    return Items[name]
  end

  ---@param name string The name of the usable item
  ---@param cb fun(src: number|string) The callback to call when the item is used
  local function create_useable_item(name, cb)
    if not is_server then return end
    if not ensure_inv_object(create_useable_item, 'Inventory') then return end
    ---@cast Inv -?
    ---@cast Core -?
    if not ensure_items_object(create_useable_item, 'Items') then return end ---@cast Items -?
    if not get_item(name) then return end
    if INVENTORY == 'ox' then
      exports(name, function(event, _, inventory)
        if event ~= 'usingItem' then return end
        cb(inventory.id)
      end)
    elseif INVENTORY == 'esx' then
      Core.RegisterUsableItem(name, cb)
    elseif INVENTORY == 'qb' then
      Core.Functions.CreateUseableItem(name, cb)
    end
  end

  ---@param player integer|string? The source of the player
  ---@param item string The item to add
  ---@param amount number The amount to add
  ---@return boolean?
  local function add_item(player, item, amount)
    if not is_server then return end
    if not ensure_inv_object(add_item, 'Inventory') then return end ---@cast Inv -?
    if not ensure_items_object(add_item, 'Items') then return end ---@cast Items -?
    player = validate_source(player or source, add_item, 'player') ---@cast player -?
    local player_data = ensure_player_data(player, add_item, 'player') ---@cast player_data -?
    if not get_item(item) then return end
    if INVENTORY == 'ox' then
      if not Inv:CanCarryItem(player, item, amount) then return false end
      return Inv:AddItem(player, item, amount) and true or false
    elseif INVENTORY == 'esx' then
      if not player_data.canCarryItem(item, amount) then return false end
      player_data.addInventoryItem(item, amount)
      return player_data.hasItem(item, amount)
    elseif INVENTORY == 'qb' then
      return player_data.Functions.AddItem(item, amount)
    end
  end

  ---@param player integer|string? The source of the player
  ---@param item string The item to remove
  ---@param amount number The amount to remove
  ---@return boolean?
  local function remove_item(player, item, amount)
    if not is_server then return end
    if not ensure_inv_object(remove_item, 'Inventory') then return end ---@cast Inv -?
    if not ensure_items_object(remove_item, 'Items') then return end
    player = validate_source(player or source, remove_item, 'player') ---@cast player -?
    local player_data = ensure_player_data(player, add_item, 'player') ---@cast player_data -?
    if not get_item(item) then return end
    if INVENTORY == 'ox' then
      return Inv:RemoveItem(player, item, amount)
    elseif INVENTORY == 'esx' then
      player_data.removeInventoryItem(item, amount)
      return not player_data.hasItem(item, amount)
    elseif INVENTORY == 'qb' then
      return player_data.Functions.RemoveItem(item, amount)
    end
  end

  --------------------- CLIENT ---------------------

  local Target = not is_server and consume_export(EXPORTS, 'TARGET') --[[@as ox_target|table?]]

  ---@param fn function
  ---@param arg string|number?
  local function ensure_target_object(fn, arg)
    if is_server then return end
    if not Target then Target = consume_export(EXPORTS, 'TARGET') end
    return check_type(Target, 'table', fn, arg)
  end

  ---@param entities integer|integer[] The entity or entities to add a target to
  ---@param options {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: fun(entity: integer, distance: number)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?}
  local function add_local_entity(entities, options)
    if is_server then return end
    if not ensure_target_object(add_local_entity, 'Target') then return end ---@cast Target -?
    if not check_type(entities, {'number', 'table'}, add_local_entity, 'entities') then return end
    if not check_type(options, 'table', add_local_entity, 'options') then return end
    if not check_type(options.label, 'string', add_local_entity, 'options.label') then return end
    if not check_type(options.icon, 'string', add_local_entity, 'options.icon') then return end
    if TARGET == 'ox' then
      Target:addLocalEntity(entities, {
        {
          name = options.name,
          label = options.label,
          icon = options.icon,
          distance = options.distance or 2.5,
          items = options.item,
          canInteract = options.canInteract,
          onSelect = options.onSelect,
          event = options.event_type == 'client' and options.event or nil,
          serverEvent = options.event_type == 'server' and options.event or nil,
          command = options.event_type == 'command' and options.event or nil,
          groups = merge_arrays(options.jobs, options.gangs)
        }
      })
    elseif TARGET == 'qb' then
      Target:AddTargetEntity(entities, {
        options = {
          {
            type = options.event_type,
            event = options.event,
            icon = options.icon,
            label = options.label,
            item = options.item,
            canInteract = options.canInteract,
            action = options.onSelect,
            job = options.jobs,
            gang = options.gangs
          }
        },
        distance = options.distance or 2.5
      })
    end
  end

  ---@param entities integer|integer[] The entity or entities to remove a target from
  ---@param targets string|string[]? The target or targets to remove
  local function remove_local_entity(entities, targets)
    if is_server then return end
    if not ensure_target_object(remove_local_entity, 'Target') then return end ---@cast Target -?
    if not check_type(entities, {'number', 'table'}, remove_local_entity, 'entities') then return end
    if not check_type(targets, {'string', 'table', 'nil'}, remove_local_entity, 'targets') then return end
    if TARGET == 'ox' then
      Target:removeLocalEntity(entities, targets)
    elseif TARGET == 'qb' then
      Target:RemoveTargetEntity(entities, targets)
    end
  end

  --------------------- OBJECT ---------------------

  bridge = {
    _DATA = {FRAMEWORK = FRAMEWORK, LIB = LIB, INVENTORY = INVENTORY, EXPORTS = EXPORTS, EVENTS = EVENTS},
    getframework = get_framework,
    getinventory = get_inventory,
    getcore = get_core_object,
    getlib = get_lib_object,
    getinv = get_inv_object,
    getplayer = get_player_data,
    getidentifier = get_player_identifier,
    getplayername = get_player_name,
    getjob = get_job_data,
    doesplayerhavegroup = does_player_have_group,
    isplayerdowned = is_player_downed,
    createcallback = create_callback,
    triggercallback = trigger_callback
  }

  if is_server then
    bridge['_DATA'].ITEMS = Items
    bridge.getallitems = get_all_items
    bridge.getitem = get_item
    bridge.createuseableitem = create_useable_item
    bridge.additem = add_item
    bridge.removeitem = remove_item
  else
    bridge.addlocalentity = add_local_entity
    bridge.removelocalentity = remove_local_entity
  end

  return bridge
end