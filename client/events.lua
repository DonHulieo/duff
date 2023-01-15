--[[local function GetAllEvents()
    local events = {}
    for k, v in pairs(_G) do
        if type(v) == 'table' and v.name ~= nil then
            events[#events + 1] = v.name
        end
    end
    return events
end]]

--[[---@param group number | 0 = SCRIPT_EVENT_QUEUE_AI (CEventGroupScriptAI), 1 = SCRIPT_EVENT_QUEUE_NETWORK (CEventGroupScriptNetwork)
local function GetAllEvents(group)
    local events = {}
    for i = 1, GetNumberOfEvents(group) do
        local name = GetEventAtIndex(group, i)
        events[#events + 1] = name
    end
    return events
end]]

-- exports('GetAllEvents', function(group) return GetAllEvents(group) end)

AddEventHandler('gameEventTriggered', function(name, args)
	local _text = "gameEventTriggered \npid: "..PlayerPedId().."\nname: "..name.."\nargs: "..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventWatch', function(entities, eventEntity, args)
	local _text = "CEventDataResponseTaskShockingEventWatch \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventThreatResponse', function(entities, eventEntity, args)
	local _text = "CEventDataResponseTaskShockingEventThreatResponse \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventReact', function(entities, eventEntity, args)
	local _text = "CEventDataResponseTaskShockingEventReact \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventFlee', function(entities, eventEntity, args)
	local _text = "CEventDataResponseTaskShockingEventFlee \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventInvestigate', function(entities, eventEntity, args)
	local _text = "CEventDataResponseTaskShockingEventInvestigate \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingGunshotFired', function(witnesses, ped, x, y, z)
	local _text = "CEventShockingGunshotFired \nPlyPId: "..PlayerPedId().."\nShooter: "..ped.."\nWitnesses: "..json.encode(witnesses).."\nCoords: "..json.encode(x, y, z)
	print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingVisibleWeapon', function(witnesses, ped, x, y, z)
	local _text = "CEventShockingVisibleWeapon \nPlyPId: "..PlayerPedId().."\nPed: "..ped.."\nWitnesses: "..json.encode(witnesses).."\nargs: "..json.encode(x, y, z)
	print(_text)
end)


---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingWeaponThreat', function(witnesses, ped, x, y, z)
	local _text = "CEventShockingWeaponThreat \nPlyPId: "..PlayerPedId().."\nPed: "..ped.."\nWitnesses: "..json.encode(witnesses).."\nargs: "..json.encode(x, y, z)
	print(_text)
end)

AddEventHandler('CEventShockingSeenDeadBody', function(entities, eventEntity, args)
	local _text = "CEventShockingSeenDeadBody \nPlyPId: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingInDangerousVehicle', function(entities, eventEntity, args)
	local _text = "CEventShockingInDangerousVehicle \nPlyPId: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingMadDriver', function(witnesses, ped, x, y, z)
	local _text = "CEventShockingMadDriver \nPlyPId: "..PlayerPedId().."\nPed: "..ped.."\nWitnesses: "..json.encode(witnesses).."\nCoords: "..json.encode(x, y, z)
	print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingMadDriverExtreme', function(ped, witnesses, x, y, z)
	local _text = "CEventShockingMadDriverExtreme \nPlyPId: "..PlayerPedId().."\nPed: "..ped.."\nWitnesses: "..json.encode(witnesses).."\naCoords: "..json.encode(x, y, z)
	print(_text)
end)

AddEventHandler('CEventReactionEnemyPed', function(entities, eventEntity, args)
	local _text = "CEventReactionEnemyPed \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the vehicle who triggered the event
---@param x number | X coord of vehicle
---@param y number | Y coord of vehicle
---@param z number | Z coord of vehicle
AddEventHandler('CEventShockingSeenNiceCar', function(witnessess, vehicle, x, y, z)
	local _text = "CEventShockingSeenNiceCar \nPlyPId: "..PlayerPedId().."\nVehicle: "..vehicle.."\nWitnesses: "..json.encode(witnessess).."\nargs: "..json.encode(x, y, z)
	print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who fired the gun
AddEventHandler('CEventGunShot', function(witnesses, ped)
	local _text = "CEventGunShot \nPlyPId: "..PlayerPedId().."\nShooter: "..ped.."\nWitnesses: "..json.encode(witnesses)
	print(_text)
end)

---@param peds table | Array of entity handles who received the command
AddEventHandler('CEventScriptCommand', function(peds)
	local _text = "CEventScriptCommand \nPlyPId: "..PlayerPedId().."\nPed: "..json.encode(peds)
	print(_text)
end)

AddEventHandler('CEventScriptWithData', function(entities, eventEntity, args)
	local _text = "CEventScriptWithData \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

---@param peds table | Array of entity handles who received the task
AddEventHandler('CEventGivePedTask', function(peds)
	local _text = "CEventGivePedTask \npid: "..PlayerPedId().."\nPeds: "..json.encode(peds)
	print(_text)
end)

AddEventHandler('CEventNewTask', function(entities, eventEntity, args)
	local _text = "CEventNewTask \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventOpenDoor', function(entities, eventEntity, args)
	local _text = "CEventOpenDoor \npid: "..PlayerPedId().."\neventEnt: "..eventEntity.."\nentities: "..json.encode(entities).."\nargs: "..json.encode(args)
	print(_text)
end)