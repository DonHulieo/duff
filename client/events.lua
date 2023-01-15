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

--------------------------------- Damage Events --------------------------------- [Credits goes to: evTestingPizza | https://github.com/DevTestingPizza/DamageEvents]

---@param vehicle number | Vehicle Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function VehicleDestroyed(vehicle, attacker, weapon, isMelee, flags)
	if IsEntityAVehicle(vehicle) then
		if IsEntityAVehicle(attacker) then
			-- Vehicle Killed by Vehicle Event
			print('Vehicle killed with a vehicle!')
		elseif IsEntityAPed(attacker) then
			if IsPedAPlayer(attacker) then
				-- Player Killed Vehicle Event
				print('Player killed a vehicle!')
			else
				-- Ped Killed Vehicle Event
				print('Ped killed a vehicle!')
			end
		else
			-- Vehicle Killed Event
			print('Vehicle killed!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param vehicle number | Vehicle Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedKilledByVehicle(ped, vehicle, weapon, isMelee, flags)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Killed by Vehicle Event
			print('Player killed by a vehicle!')
		else
			-- Ped Killed by Vehicle Event
			print('Ped killed by a vehicle!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param player number | Player Ped Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedKilledByPlayer(ped, player, weapon, isMelee)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Killed by Player Event
			print('Player killed by a player!')
		else
			-- Ped Killed by Player Event
			print('Ped killed by a player!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedKilledByPed(ped, attacker, weapon, isMelee)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Killed by Ped Event
			print('Player killed by a ped!')
		else
			-- Ped Killed by Ped Event
			print('Ped killed by a ped!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedKilled(ped, attacker, weapon, isMelee, flags)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Killed Event
			print('Player killed!')
		else
			-- Ped Killed Event
			print('Ped killed!')
		end
	end
end

---@param entity number | Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function EntityKilled(entity, attacker, weapon, isMelee, flags)
	print('Something killed!')
end

---@param vehicle number | Vehicle Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function VehicleDamaged(vehicle, attacker, weapon, isMelee, flags)
	if IsEntityAVehicle(vehicle) then
		if IsEntityAVehicle(attacker) then
			-- Vehicle Damaged by Vehicle Event
			print('Vehicle damaged with a vehicle!')
		elseif IsEntityAPed(attacker) then
			if IsPedAPlayer(attacker) then
				-- Player Damaged Vehicle Event
				print('Player damaged a vehicle!')
			else
				-- Ped Damaged Vehicle Event
				print('Ped damaged a vehicle!')
			end
		else
			-- Vehicle Damaged Event
			print('Vehicle damaged!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param vehicle number | Vehicle Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedDamagedByVehicle(ped, vehicle, weapon, isMelee, flags)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Damaged by Vehicle Event
			print('Player damaged by a vehicle!')
		else
			-- Ped Damaged by Vehicle Event
			print('Ped damaged by a vehicle!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param player number | Player Ped Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedDamagedByPlayer(ped, player, weapon, isMelee)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Damaged by Player Event
			print('Player damaged by a player!')
		else
			-- Ped Damaged by Player Event
			print('Ped damaged by a player!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedDamagedByPed(ped, attacker, weapon, isMelee)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Damaged by Ped Event
			print('Player damaged by a ped!')
		else
			-- Ped Damaged by Ped Event
			print('Ped damaged by a ped!')
		end
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedDamaged(ped, attacker, weapon, isMelee, flags)
	if IsEntityAPed(ped) then
		if IsPedAPlayer(ped) then
			-- Player Damaged Event
			print('Player damaged!')
		else
			-- Ped Damaged Event
			print('Ped damaged!')
		end
	end
end

---@param entity number | Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function EntityDamaged(entity, attacker, weapon, isMelee, flags)
	print('Something damaged!')
end

AddEventHandler('gameEventTriggered', function(name, args)
	if name == 'CEventNetworkEntityDamage' then
		victim = args[1]
		attacker = args[2]
		isDead = args[6] == 1
		weapon = args[7]
		isMelee = args[12]
		flags = args[13]
		if victim and attacker then
			if isDead then
				if IsEntityAVehicle(victim) then
					-- Vehilce Death Event
					print('Vehicle Destroyed')
					VehicleDestroyed(victim, attacker, weapon, isMelee, flags)
				elseif IsEntityAPed(victim) then
					if IsEntityAVehicle(attacker) then
						-- Ped Killed by Vehicle Event
						print('Ped killed with a vehicle!')
						PedKilledByVehicle(victim, attacker, weapon, isMelee, flags)
					elseif IsEntityAPed(attacker) then
						if IsPedAPlayer(attacker) then
							-- Player Killed Ped Event
							print('Player killed a ped!')
							PedKilledByPlayer(victim, attacker, weapon, isMelee)
						else
							-- Ped Killed Ped Event
							print('Ped killed a ped!')
							PedKilledByPed(victim, attacker, weapon, isMelee)
						end
					else
						-- Ped Killed Event
						print('Ped killed!')
						PedKilled(victim, attacker, weapon, isMelee, flags)
					end
				else
					-- Something Died Event
					print('Something died!')
					EntityKilled(victim, attacker, weapon, isMelee)
				end
			else
				if IsEntityAVehicle(victim) then
					-- Vehicle Damaged Event
					print('Vehicle Damaged')
					VehicleDamaged(victim, attacker, weapon, isMelee, flags)
				elseif IsEntityAPed(victim) then
					if IsEntityAVehicle(attacker) then
						-- Ped Damaged by Vehicle Event
						print('Ped damaged with a vehicle!')
						PedDamagedByVehicle(victim, attacker, weapon, isMelee, flags)
					elseif IsEntityAPed(attacker) then
						if IsPedAPlayer(attacker) then
							-- Player Damaged Ped Event
							print('Player damaged a ped!')
							PedDamagedByPlayer(victim, attacker, weapon, isMelee)
						else
							-- Ped Damaged Ped Event
							print('Ped damaged a ped!')
							PedDamagedByPed(victim, attacker, weapon, isMelee)
						end
					else
						-- Ped Damaged Event
						print('Ped damaged!')
						PedDamaged(victim, attacker, weapon, isMelee, flags)
					end
				else
					-- Something Damaged Event
					print('Something damaged!')
					EntityDamaged(victim, attacker, weapon, isMelee, flags)
				end
			end
		end
	else
		local _text = "gameEventTriggered \npid: "..PlayerPedId().."\nname: "..name.."\nargs: "..json.encode(args)
		print(_text)
	end
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
	local _text = "CEventShockingSeenNiceCar \nPlyPId: "..PlayerPedId().."\nVehicle: "..vehicle.."\nWitnesses: "..json.encode(witnessess).."\nCoords: "..json.encode(x, y, z)
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