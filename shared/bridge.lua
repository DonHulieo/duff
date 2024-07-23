---@class CBridge
---@field _DATA {FRAMEWORK: string?, LIB: string?, INVENTORY: string?, EVENTS: {LOAD: string?, UNLOAD: string?, JOBDATA: string?, PLAYERDATA: string?, UPDATEOBJECT: string?}, ITEMS: {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}?}
---@field getframework fun(): string Returns the name of the framework being used. <br> Returns `esx` if [es_extended](https://github.com/esx-framework/esx_core/tree/main/%5Bcore%5D/es_extended) is present. <br> Returns `qb` if [qb-core](https://github.com/qbcore-framework/qb-core) is present.
---@field getlib fun(): string Returns the library object being used. <br> Returns `ox_lib` if [ox_lib](https://github.com/overextended/ox_lib) is present.
---@field getinventory fun(): string Returns the name of the inventory system being used. <br> Returns `ox` if [ox_inventory](https://github.com/overextended/ox_inventory) is present. <br> Returns `qb` if [qb-inventory](https://github.com/qbcore-framework/qb-inventory) is present.
---@field getcore fun(): table Returns the shared object for the framework being used.
---@field getplayer fun(player: integer|string?): table Returns the player data for `player`. <br> If `player` is nil, the source's (server) or client's (client) player data is returned.
---@field getidentifier fun(player: integer|string?): string Returns the identifier of `player`. <br> If `player` is nil, the source's (server) or client's (client) player identifier is returned.
---@field getplayername fun(player: integer|string?): string Returns the name of `player`. <br> If `player` is nil, the source's (server) or client's (client) player name is returned.
---@field getjob fun(player: integer|string?): {name: string, label: string, grade: number, grade_name: string, grade_label: string, job_type: string, salary: number}? Returns the job data for `player`. <br> If `player` is nil, the source's (server) or client's (client) player job data is returned.
---@field doesplayerhavegroup fun(player: integer|string?, groups: string|string[]): boolean? Returns whether `player` has the specified group(s). <br> If `player` is nil, the source's (server) or client's (client) player group(s) are checked.
---@field isplayerdowned fun(player: integer|string?): boolean Returns whether the `player` is downed. <br> If `player` is nil, the source's (server) or client's (client) player downed status is checked.
---@field createcallback fun(name: string, cb: function) Creates a callback, `name` that triggers the `cb` function when called.
---@field triggercallback fun(player: integer|string?, name: string, cb: function, ...: any) Triggers the callback, `name` with the specified arguments. <br> If triggered from the server, the `player` argument is required and is the client to trigger the callback for.
---@field getallitems fun(): {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}? Returns a table of all items available in the inventory system. <br> **Note**: This is a server-only function.
---@field getitem fun(name: string): {name: string, label: string, weight: number, usable: boolean, unique: boolean}? Returns the item data for `item`. <br> **Note**: This is a server-only function.
---@field createuseableitem fun(name: string, cb: fun(src: number|string)) Creates a useable item, `name` that calls the `cb` function when used. <br> **Note**: This is a server-only function.
---@field additem fun(player: integer|string?, item: string, amount: integer): boolean? Adds `item` to the player's inventory. <br> **Note**: This is a server-only function.
---@field removeitem fun(player: integer|string?, item: string, amount: integer): boolean? Removes `item` from the player's inventory. <br> **Note**: This is a server-only function.
---@field addlocalentity fun(entities: integer|integer[], options: {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: (fun(entity: number, distance: number): boolean?)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]}) Adds a target to `entities` with the specified `options`. <br> **Note**: This is a client-only function.
---@field removelocalentity fun(entities: integer|integer[], targets: string|string[]?) Removes the target from `entities` with the specified `targets`. <br> **Note**: This is a client-only function.
---@field addboxzone fun(data: {center: vector3, size: vector3, heading: number?, debug: boolean?}, options: {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: (fun(entity: integer, distance: number): boolean?)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?}): integer|string Adds a box zone with the specified `data` and `options`. <br> **Note**: This is a client-only function. 
---@field removezone fun(id: integer|string) Removes the zone with the specified `id`. <br> **Note**: This is a client-only function.
do
  local load, load_resource_file = load, LoadResourceFile
  local package = duff?.package or load(load_resource_file('duff', 'shared/package.lua'), '@duff/shared/package.lua', 't', _ENV)()
  local get_resource_state = GetResourceState
  local Frameworks = {['es_extended'] = 'esx', ['qb-core'] = 'qb'}
  local Inventories = {['ox_inventory'] = 'ox', ['qb-inventory'] = 'qb'}
  local Libs = {['ox_lib'] = 'ox'}
  local Targets = {['ox_target'] = 'ox', ['qb-target'] = 'qb'}
  local is_server = IsDuplicityVersion() == 1

  --------------------- INTERNAL ---------------------

  ---@param resource string The name of the resource.
  ---@return boolean is_present Whether the resource is present.
  local function is_resource_present(resource)
    local state = get_resource_state(resource)
    return state ~= 'missing' and state ~= 'unknown' and (state == 'started' or state == 'starting')
  end

  ---@param table table<any, any>|any? The table to iterate over.
  ---@param fn fun(key: any, value: any?): boolean The evaluation function.
  ---@return any value The value that matches the evaluation function.
  local function for_each(table, fn)
    table = type(table) == 'table' and table or {table}
    local value = nil
    if not table then return value end
    for k, v in pairs(table) do
      if fn(k, v) then value = v break end
    end
    return value
  end

  ---@param table table<any, any>|any? The table to iterate over.
  ---@param value any The value to find.
  ---@return any? key The key that matches the value.
  local function get_key(table, value)
    local key = nil
    table = type(table) == 'table' and table or {table}
    if not table then return key end
    for k, v in pairs(table) do
      if v == value then key = k break end
    end
    return key
  end

  ---@param table {[string]: {resource: string, method: string?}} The table of exports.
  ---@param export_type string The type of export to consume.
  ---@return any export The exported value.
  local function consume_export(table, export_type)
    if not table or not table[export_type] then return end
    local export = table[export_type]
    if not export then error(export_type..' export not valid', 2) end
    return export.method and exports[export.resource][export.method]() or exports[export.resource]
  end

  ---@param array1 any[]|any The first array to merge.
  ---@param array2 any[]|any The second array to merge.
  ---@return any[]|any merged The merged array.
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
  -- Each framework and/or resource has a different way of exporting their shared object.
  -- The `EXPORTS` table contains the possible exports for each framework and resource.
  -- Where `key` is the type of resource (ie. CORE, INV, TARG) and `value` is a table of possible exports.
  -- For each `value`, the key is the resource name and the value is the method to call to get the shared object.
  -- If the export is just a table call (ie. `exports['ox_inventory']`), the method is the resource name and the resource type should be flagged in `NO_METHODS`.
  local EXPORTS = {
    CORE = {['esx'] = 'getSharedObject', ['qb'] = 'GetCoreObject'},
    INV = {['ox'] = 'ox_inventory', ['qb'] = 'qb-inventory'},
    TARG = {['ox'] = 'ox_target', ['qb'] = 'qb-target'}
  }
  -- Each framework has different events that are triggered when certain actions occur.
  -- The `EVENTS` table contains the possible events for each framework.
  -- Where `key` is the type of event (ie. LOAD, UNLOAD, JOBDATA, PLAYERDATA, OBJECTUPDATE) and `value` is table of possible events.
  -- For each `value`, the key is the framework name and the value is the event name.
  local EVENTS = {
    LOAD = {['esx'] = 'esx:playerLoaded', ['qb'] = 'QBCore:Client:OnPlayerLoaded'},
    UNLOAD = {['esx'] = 'esx:onPlayerLogout', ['qb'] = 'QBCore:Client:OnPlayerUnload'},
    JOBDATA = {['esx'] = 'esx:setJob', ['qb'] = 'QBCore:Client:OnJobUpdate'},
    PLAYERDATA = {['esx'] = 'esx:setPlayerData', ['qb'] = 'QBCore:Player:SetPlayerData'},
    OBJECTUPDATE = {['qb'] = not is_server and 'QBCore:Client:UpdateObject' or 'QBCore:Server:UpdateObject'}
  }
  -- The `NO_METHODS` table contains the resources that do not have a method to call to get the shared object.
  -- Where `key` is the type of resource (ie. CORE, INV, TARG) and `value` is a table of resources that do not have a method.
  local NO_METHODS = {['INV'] = {'ox', 'qb'}, ['TARGET'] = {'ox', 'qb'}}
  EXPORTS = {
    CORE = {resource = get_key(Frameworks, FRAMEWORK), method = for_each(NO_METHODS.CORE, function(_, value) return value == FRAMEWORK end) == nil and EXPORTS.CORE[FRAMEWORK] or nil},
    INV = {resource = get_key(Inventories, INVENTORY), method = for_each(NO_METHODS.INV, function(_, value) return value == INVENTORY end) == nil and EXPORTS.INV[INVENTORY] or nil},
    TARG = {resource = get_key(Targets, TARGET), method = for_each(NO_METHODS.TARGET, function(_, value) return value == TARGET end) == nil and EXPORTS.TARG[TARGET] or nil}
  }
  local Core, Lib, Inv = consume_export(EXPORTS, 'CORE') --[[@as table]], consume_export(EXPORTS, 'LIB'), consume_export(EXPORTS, 'INV') --[[@as ox_inventory|table?]]
  local PlayerData = nil

  ---@return string FRAMEWORK The name of the framework being used.
  local function get_framework()
    if not FRAMEWORK then error('framework is invalid', 2) end
    return FRAMEWORK
  end

  ---@return string INVENTORY The name of the inventory system being used.
  local function get_inventory()
    if not INVENTORY then error('inventory system is invalid', 2) end
    return INVENTORY
  end

  ---@return table Core The shared object for the framework being used.
  local function get_core_object()
    if not FRAMEWORK then error('framework is invalid', 2) end
    Core = Core or consume_export(EXPORTS, 'CORE')
    if not Core then error('core object is invalid', 2) end
    return Core
  end

  ---@return table Lib The library object being used.
  local function get_lib_object()
    if not LIB then error('library is invalid', 2) end
    if Lib then return Lib end
    if LIB == 'ox' then
      if not Lib then package.import('ox_lib') end
      Lib = lib
    end
    if type(Lib) ~= 'table' then error('library object is invalid', 2) end
    return Lib
  end

  ---@param func_name string The name of the function calling this function.
  ---@param player integer|string? The source of the player.
  ---@param arg number? The argument number.
  ---@return integer player The source of the player.
  local function validate_source(func_name, player, arg)
    player = player or source
    local param_type = type(player)
    if param_type ~= 'number' and param_type ~= 'string' then error('bad argument #'..(arg or 1)..' to \''..func_name..'\' (player or source is invalid)', 3) end
    return type(player) ~= 'number' and tonumber(player) or player
  end

  ---@param player integer|string? The source of the player. <br> `player` is a server-side only argument, and if not provided, the source is used.
  ---@return table PlayerData The player data for `player`.
  local function get_player_data(player)
    Core = get_core_object()
    local player_data = nil
    if is_server then
      player = validate_source('getplayer', player or source, 1)
      if FRAMEWORK == 'esx' then
        player_data = Core.GetPlayerFromId(player)
      elseif FRAMEWORK == 'qb' then
        player_data = Core.Functions.GetPlayer(player)
      end
    else
      if not PlayerData or type(PlayerData) ~= 'table' then
        if FRAMEWORK == 'esx' then
          player_data = Core.GetPlayerData()
        elseif FRAMEWORK == 'qb' then
          player_data = Core.Functions.GetPlayerData()
        end
        PlayerData = player_data
      else
        player_data = PlayerData
      end
    end
    if not player_data then error('error calling \'getplayer\' (player data is invalid)', 2) end
    return player_data
  end

  -- If the framework is ESX, the enum job_types below is used to determine the job type of the player.
  -- Add the job type to the job_types enum if it is not already present, as well as any additional jobs that should be considered part of that job type.
  ---@enum job_types
  local job_types = {['leo'] = {['police'] = true, ['fib'] = true, ['sheriff'] = true}, ['ems'] = {['ambulance'] = true, ['fire'] = true}}
  ---@param func_name string The name of the function calling this function.
  ---@param data table The job data to convert.
  ---@return {name: string, label: string, grade: number, grade_name: string, grade_label: string, job_type: string, salary: number} job_data The converted job data.
  local function convert_job_data(func_name, data)
    if not data then error('error calling \''..func_name..'\' (attempting to convert nil job data)', 3) end
    local job_data = {name = data.name, label = data.label, grade = 0, grade_name = '', grade_label = '', job_type = '', salary = 0}
    if FRAMEWORK == 'esx' then
      job_data.grade = data.grade
      job_data.grade_name = data.grade_name
      job_data.grade_label = data.grade_label
      job_data.job_type = for_each(job_types, function(_, value) return value[data.name] end) or ''
      job_data.salary = data.salary
    elseif FRAMEWORK == 'qb' then
      local grade = data.grade
      job_data.grade = grade.level
      job_data.grade_name = grade.name
      job_data.grade_label = grade.name
      job_data.job_type = data.type or for_each(job_types, function(_, value) return value[data.name] end) or ''
      job_data.salary = data.payment
    end
    if not next(job_data) then error('error calling \''..func_name..'\' (job data not valid)', 3) end
    return job_data
  end

  EVENTS = {
    LOAD = not is_server and EVENTS.LOAD[FRAMEWORK] or nil,
    UNLOAD = not is_server and EVENTS.UNLOAD[FRAMEWORK] or nil,
    JOBDATA = not is_server and EVENTS.JOBDATA[FRAMEWORK] or nil,
    PLAYERDATA = not is_server and EVENTS.PLAYERDATA[FRAMEWORK] or nil,
    OBJECTUPDATE = EVENTS.OBJECTUPDATE[FRAMEWORK]
  }

  for event_type, event in pairs(EVENTS) do
    if event then ---@cast event -table
      RegisterNetEvent(event, function(...)
        if event_type == 'LOAD' then
          PlayerData = get_player_data()
        elseif event_type == 'UNLOAD' then
          PlayerData = nil
        elseif event_type == 'JOBDATA' then
          if not PlayerData then return end
          PlayerData.job = convert_job_data(event, ...)
        elseif event_type == 'PLAYERDATA' then
          PlayerData = ...
        elseif event_type == 'OBJECTUPDATE' then
          if not validate_source(event, source) then return end
          Core = get_core_object()
        end
      end)
    end
  end

  ---@param player integer|string? The `player` to retrieve the identifier for. <br> When called from the server and `player` is nil, the source is used. <br> Otherwise, `player` is the PlayerId to retrieve the identifier for.
  ---@return string|integer identifier The identifier of the `player`. <br> If called from the server, `identifier` is either the player's FiveM identifier or the player's identifier from the framework being used. <br> If called from the client, `identifier` is the player's server ID or the player's identifier from the framework being used.
  local function get_player_identifier(player)
    player = player or source or PlayerId()
    local player_data = FRAMEWORK and get_player_data(player)
    local identifier = nil
    if is_server then
      identifier = not player_data and GetPlayerIdentifierByType(player, 'fivem')
      if FRAMEWORK == 'esx' then  ---@cast player_data -?
        identifier = player_data.getIdentifier()
      elseif FRAMEWORK == 'qb' then  ---@cast player_data -?
        identifier = player_data.PlayerData.citizenid
      end
    else
      identifier = not player_data and GetPlayerServerId(player)
      if FRAMEWORK == 'esx' then  ---@cast player_data -?
        identifier = player_data.identifier
      elseif FRAMEWORK == 'qb' then  ---@cast player_data -?
        identifier = player_data.citizenid
      end
    end
    if not identifier then error('error calling \'getidentifier\' (identifier for player \''..player..'\' not valid)', 2) end
    return identifier
  end

  ---@param player integer|string? The `player` to retrieve the name for. <br> When called from the server and `player` is nil, the source is used. <br> Otherwise, `player` is the PlayerId to retrieve the name for.
  ---@return string name The name of the `player`.
  local function get_player_name(player)
    player = player or source or -1
    local player_data = FRAMEWORK and get_player_data(player)
    local name = ''
    if is_server then
      if FRAMEWORK == 'esx' then ---@cast player_data -?
        name = player_data.getName()
      elseif FRAMEWORK == 'qb' then ---@cast player_data -?
        name = player_data.PlayerData.charinfo.firstname..' '..player_data.PlayerData.charinfo.lastname
      end
    else
      if FRAMEWORK == 'esx' then ---@cast player_data -?
        name = player_data.firstName..' '..player_data.lastName
      elseif FRAMEWORK == 'qb' then ---@cast player_data -?
        name = player_data.charinfo.firstname..' '..player_data.charinfo.lastname
      end
    end
    return name ~= '' and name or GetPlayerName(player)
  end

  ---@param player integer|string? The `player` to retrieve the job data for. <br> `player` is a server-side only argument, and is the player's server ID. <br> If `player` is nil, the source is used.
  ---@return {name: string, label: string, grade: number, grade_name: string, grade_label: string, job_type: string, salary: number}? job_data The job data for the `player`.
  local function get_job_data(player)
    local player_data = get_player_data(player)
    local found_data = nil
    if is_server then
      if FRAMEWORK == 'esx' then
        found_data = player_data.getJob()
      elseif FRAMEWORK == 'qb' then
        found_data = player_data.PlayerData.job
      end
    else
      if FRAMEWORK == 'esx' then
        found_data = player_data.job
      elseif FRAMEWORK == 'qb' then
        found_data = player_data.job
      end
    end
    if not found_data then return end
    return convert_job_data('getjob', found_data)
  end

  ---@param player integer|string? The `player` to retrieve the gang data for. <br> `player` is a server-side only argument, and is the player's server ID. <br> If `player` is nil, the source is used.
  ---@return {name: string, label: string, grade: number, grade_name: string}? gang_data The gang data for the `player`.
  local function get_gang_data(player)
    local player_data = get_player_data(player)
    local found_data = nil
    if is_server then
      if FRAMEWORK == 'qb' then
        found_data = player_data.PlayerData.gang
      end
    else
      if FRAMEWORK == 'qb' then
        found_data = player_data.gang
      end
    end
    if not found_data then return end
    local grade = found_data.grade
    return {
      name = found_data.name,
      label = found_data.label,
      grade = grade.level,
      grade_name = grade.name
    }
  end

  ---@param player integer|string? The `player` to check for the specified group(s). <br> If `player` is nil, the source is used. <br> `player` is a server-side only argument.
  ---@param groups string|string[] The group(s) to check for. <br> If `groups` is a string, it is the name of the group to check for. <br> If `groups` is a table, it is a list of group names to check for. <br> The group name can be the job name, job label, job type, gang name or gang label.
  ---@return boolean has_group Whether the `player` has the specified group(s).
  local function does_player_have_group(player, groups)
    local job_data = get_job_data(player or source or nil)
    local gang_data = get_gang_data(player or source or nil)
    if not job_data and not gang_data then return false end
    groups = type(groups) == 'table' and groups or {groups}
    if not groups or type(groups) ~= 'table' then error('bad argument #2 to \'doesplayerhavegroup\' (string or table expected, got '..type(groups)..')', 2) end
    for i = 1, #groups do
      local group = groups[i]
      if job_data and (job_data.name == group or job_data.label == group or job_data.job_type == group) then return true end
      if gang_data and (gang_data.name == group or gang_data.label == group) then return true end
    end
    return false
  end

  ---@param player integer|string? The `player` to check if they are downed. <br> If `player` is nil, the source is used. <br> `player` is a server-side only argument.
  ---@return boolean isDowned Whether the `player` is downed.
  local function is_player_downed(player)
    local player_data = get_player_data(player)
    local is_downed = false
    if is_server then
      if FRAMEWORK == 'esx' then
        is_downed = player_data.getMeta('dead')
      elseif FRAMEWORK == 'qb' then
        is_downed = player_data.PlayerData.metadata['inlaststand'] or player_data.PlayerData.metadata['isdead']
      end
    else
      if FRAMEWORK == 'esx' then
        is_downed = player_data.dead
      elseif FRAMEWORK == 'qb' then
        is_downed = player_data.metadata['inlaststand'] or player_data.metadata['isdead']
      end
    end
    return is_downed
  end

  ---@param name string The name of the callback to create.
  ---@param cb function The function to call when the callback is triggered.
  local function create_callback(name, cb, ...)
    Core = get_core_object()
    if is_server then
      if LIB == 'ox' then
        Lib = get_lib_object()
        Lib.callback.register(name, cb)
      elseif FRAMEWORK == 'esx' then
        Core.RegisterServerCallback(name, cb, ...)
      elseif FRAMEWORK == 'qb' then
        Core.Functions.CreateCallback(name, cb)
      end
    else
      if LIB == 'ox' then
        Lib = get_lib_object()
        Lib.callback.register(name, cb)
      elseif FRAMEWORK == 'esx' then
        Core.RegisterClientCallback(name, cb)
      elseif FRAMEWORK == 'qb' then
        Core.Functions.CreateClientCallback(name, cb)
      end
    end
  end

  ---@param player integer|string? The `player` to trigger the callback for. <br> `player` is a server-side only argument, and is the client's server ID. <br> If `player` is nil, the source is used.
  ---@param name string The name of the callback to trigger.
  ---@param cb function The function to call when the callback is received.
  ---@param ... any Additional arguments to pass to the callback.
  local function trigger_callback(player, name, cb, ...)
    Core = get_core_object()
    if is_server then
      player = validate_source('triggercallback', player or source)
      if LIB == 'ox' then
        Lib = get_lib_object()
      elseif FRAMEWORK == 'esx' then
        Core.TriggerClientCallback(player, name, cb, ...)
      elseif FRAMEWORK == 'qb' then
      end
    else
      if LIB == 'ox' then
        Lib = get_lib_object()
      elseif FRAMEWORK == 'esx' then
      elseif FRAMEWORK == 'qb' then
        Core.Functions.TriggerCallback(name, cb, ...)
      end
    end
  end

  ---@return ox_inventory|table Inv The inventory object being used.
  local function get_inv_object()
    if not INVENTORY then error('inventory system is invalid', 2) end
    if INVENTORY == 'esx' and not MySQL then
      package.import('oxmysql.lib.MySQL')
    else
      Inv = Inv or consume_export(EXPORTS, 'INV')
    end
    if not Inv then error('inventory object is invalid', 2) end
    return Inv
  end

  --------------------- SERVER ---------------------

  local Items = nil

  ---@return {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}} Items A table of all items available in the inventory system.
  local function get_all_items() -- **Note**: This is a server-only function.
    if not is_server then error('called a server only function \'getallitems\'', 2) end
    Core, Inv = get_core_object(), get_inv_object()
    if Items then return Items end
    if not Items then Items = {} end
    local found_items = nil
    if INVENTORY == 'ox' then
      found_items = Inv:Items()
      if not found_items then error('error calling \'getallitems\' (items not valid)', 2) end
      for name, data in pairs(found_items) do
        local client_data, server_data = data.client, data.server
        local useable = not data.consume and (client_data?.status or client_data?.useTime or client_data?.export or server_data?.export) or data.consume == 1
        Items[name] = {name = name, label = data.label, weight = data.weight or 0, useable = useable, unique = data.stack == nil and true or data.stack}
      end
    elseif INVENTORY == 'esx' then
      found_items = MySQL.Sync.fetchAll('SELECT * FROM items')
      if not found_items then error('error calling \'getallitems\' (items not valid)', 2) end
      for _, item in ipairs(found_items) do
        local name = item.name
        Items[name] = {name = name, label = item.label, weight = item.weight, useable = Core.GetUsableItems()[name] ~= nil, unique = item.rare}
      end
    elseif INVENTORY == 'qb' then
      found_items = Core.Shared.Items
      if not found_items then error('error calling \'getallitems\' (items not valid)', 2) end
      for name, item in pairs(found_items) do
        Items[name] = {name = name, label = item.label, weight = item.weight, useable = item.useable, unique = item.unique}
      end
    end
    return Items
  end

  ---@param item string The name of the item to retrieve.
  ---@return {name: string, label: string, weight: number, useable: boolean, unique: boolean}? item_data The data for the specified `item`.
  local function get_item(item) -- **Note**: This is a server-only function.
    if not is_server then error('called a server only function \'getitem\'', 2) end
    if not item or type(item) ~= 'string' then error('bad argument #1 to \'getitem\' (string expected, got '..type(item)..')', 2) end
    Items = Items or get_all_items()
    return Items[item]
  end

  ---@param name string The item's `name` to create a useable item callback for.
  ---@param cb fun(src: number|string) The function to call when the item is used.
  local function create_useable_item(name, cb)
    if not is_server then error('called a server only function \'createuseableitem\'', 2) end
    if not get_item(name) then error('bad argument #1 to \'createuseableitem\' (item \''..name..'\' not valid)', 2) end
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

  ---@param player integer|string? The `player` to add the item to. <br> If `player` is nil, the source is used.
  ---@param item string The name of the item to add.
  ---@param amount number? The amount of the item to add. <br> If `amount` is nil, the default amount is 1.
  ---@return boolean added Whether the item was added to the `player`.
  local function add_item(player, item, amount) -- **Note**: This is a server-only function.
    if not is_server then error('called a server only function \'additem\'', 2) end
    player = validate_source('additem', player or source)
    if not get_item(item) then error('bad argument #2 to \'additem\' (item \''..item..'\' not valid)', 2) end
    Inv = get_inv_object()
    local added = false
    amount = amount or 1
    if INVENTORY == 'ox' then
      added = Inv:CanCarryItem(player, item, amount) and Inv:AddItem(player, item, amount) or false
    elseif INVENTORY == 'esx' then
      local player_data = get_player_data(player)
      if player_data.canCarryItem(item, amount) then player_data.addInventoryItem(item, amount) end
      added = player_data.hasItem(item, amount)
    elseif INVENTORY == 'qb' then
      ---@diagnostic disable-next-line: param-type-mismatch
      added = Inv:CanAddItem(player, item, amount) and Inv:AddItem(player, item, amount, false, false, 'duff shared bridge added item:' ..item)
    end
    return added
  end

  ---@param player integer|string? The `player` to remove the item from. <br> If `player` is nil, the source is used.
  ---@param item string The name of the item to remove.
  ---@param amount number? The amount of the item to remove. <br> If `amount` is nil, the default amount is 1.
  ---@return boolean removed Whether the item was removed from the `player`.
  local function remove_item(player, item, amount) -- **Note**: This is a server-only function.
    if not is_server then error('called a server only function \'removeitem\'', 2) end
    player = validate_source('removeitem', player or source)
    if not get_item(item) then error('bad argument #2 to \'removeitem\' (item \''..item..'\' not valid)', 2) end
    Inv = get_inv_object()
    local removed = false
    amount = amount or 1
    if INVENTORY == 'ox' then
      removed = Inv:RemoveItem(player, item, amount) or false
    elseif INVENTORY == 'esx' then
      local player_data = get_player_data(player)
      player_data.removeInventoryItem(item, amount)
      removed = not player_data.hasItem(item, amount)
    elseif INVENTORY == 'qb' then
      ---@diagnostic disable-next-line: param-type-mismatch
      removed = Inv:RemoveItem(player, item, amount, false, 'duff shared bridge removed item:' ..item) or false
    end
    return removed
  end

  --------------------- CLIENT ---------------------

  local Target = not is_server and consume_export(EXPORTS, 'TARG') --[[@as ox_target|table?]]

  ---@return ox_target|table Target The target object being used.
  local function get_targ_object() -- **Note**: This is a client-only function.
    if is_server then error('called a client only function', 2) end
    if not TARGET then error('target system is invalid', 2) end
    Target = Target or consume_export(EXPORTS, 'TARG')
    if not Target then error('target object not valid', 2) end
    return Target
  end

  ---@param options {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: fun(entity: integer, distance: number)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?} The options for the target.
  ---@return {name: string, label: string, icon: string?, distance: number, items: string?, canInteract: fun(entity: integer, distance: number)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?} converted_options The converted options for the target.
  local function convert_target_options(options)
    return TARGET == 'ox' and {
      {
        name = options.name or options.label,
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
    } or {
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
    }
  end

  ---@param entities integer|integer[] The entity or entities to add a target to
  ---@param options {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: fun(entity: integer, distance: number)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?} The options for the target.
  local function add_local_entity(entities, options) -- **Note**: This is a client-only function.
    if is_server then error('called a client only function \'addlocalentity\'', 2) end
    Target = get_targ_object()
    if not entities or (type(entities) ~= 'number' and type(entities) ~= 'table') then error('bad argument #1 to \'addlocalentity\' (number or table expected, got '..type(entities)..')', 2) end
    if not options or type(options) ~= 'table' then error('bad argument #2 to \'addlocalentity\' (table expected, got '..type(options)..')', 2) end
    if not options.label or type(options.label) ~= 'string' then error('bad argument #2 to \'addlocalentity\' (options must contain a label)', 2) end
    if TARGET == 'ox' then
      Target:addLocalEntity(entities, convert_target_options(options))
    elseif TARGET == 'qb' then
      Target:AddTargetEntity(entities, convert_target_options(options))
    end
  end

  ---@param entities integer|integer[] The entity or entities to remove a target from.
  ---@param targets string|string[]?
  local function remove_local_entity(entities, targets) -- **Note**: This is a client-only function.
    if is_server then error('called a client only function \'removelocalentity\'', 2) end
    Target = get_targ_object()
    if not entities or (type(entities) ~= 'number' and type(entities) ~= 'table') then error('bad argument #1 to \'removelocalentity\' (number or table expected, got '..type(entities)..')', 2) end
    if targets and (type(targets) ~= 'string' and type(targets) ~= 'table') then error('bad argument #2 to \'removelocalentity\' (string or table expected, got '..type(targets)..')', 2) end
    if TARGET == 'ox' then
      Target:removeLocalEntity(entities, targets)
    elseif TARGET == 'qb' then
      Target:RemoveTargetEntity(entities, targets)
    end
  end

  ---@param data {center: vector3, size: vector3, heading: number?, debug: boolean?} The data for the box zone.
  ---@param options {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: (fun(entity: integer, distance: number): boolean?)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?} The options for the target.
  ---@return integer|string? box_zone The ID of the box zone (if using the ox_target system).
  local function add_box_zone(data, options)
    if is_server then error('called a client only function \'addboxzone\'', 2) end
    Target = get_targ_object()
    if not data or type(data) ~= 'table' then error('bad argument #1 to \'addboxzone\' (table expected, got '..type(data)..')', 2) end
    if not data.center or type(data.center) ~= 'vector3' then error('bad argument #1 to \'addboxzone\' (center vector3 expected, got '..type(data.center)..')', 2) end
    if not data.size or type(data.size) ~= 'vector3' then error('bad argument #1 to \'addboxzone\' (size vector3 expected, got '..type(data.size)..')', 2) end
    if not options or type(options) ~= 'table' then error('bad argument #2 to \'addboxzone\' (table expected, got '..type(options)..')', 2) end
    if not options.label or type(options.label) ~= 'string' then error('bad argument #2 to \'addboxzone\' (options must contain a label)', 2) end
    if TARGET == 'ox' then
      return Target:addBoxZone({
        coords = data.center,
        size = data.size,
        rotation = data.heading or 0,
        debug = data.debug or false,
        options = convert_target_options(options)
      })
    elseif TARGET == 'qb' then
      local name = options.name or options.label
      local size = data.size
      local center = data.center
      local min_z, max_z = center.z - size.z / 2, center.z + size.z / 2
      Target:AddBoxZone(name, data.center, size.x, size.y, {
        name = name,
        heading = data.heading or 0,
        debugPoly = data.debug or false,
        minZ = min_z,
        maxZ = max_z,
      }, convert_target_options(options))
      return name
    end
  end

  ---@param id string|integer The ID of the box zone to remove.
  local function remove_zone(id)
    if is_server then error('called a client only function \'removezone\'', 2) end
    Target = get_targ_object()
    if not id or (type(id) ~= 'string' and type(id) ~= 'number') then error('bad argument #1 to \'removeboxzone\' (string or number expected, got '..type(id)..')', 2) end
    if TARGET == 'ox' then
      Target:removeZone(id)
    elseif TARGET == 'qb' then
      Target:RemoveZone(id)
    end
  end

  --------------------- OBJECT ---------------------

  local bridge = {
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
    bridge.addboxzone = add_box_zone
    bridge.removezone = remove_zone
  end

  return bridge
end