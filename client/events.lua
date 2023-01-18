--------------------------------- Damage Events --------------------------------- [Credits goes to: evTestingPizza | https://github.com/DevTestingPizza/DamageEvents]

---@param vehicle number | Vehicle Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function VehicleDestroyed(vehicle, attacker, weapon, isMelee, flags)
	if IsEntityAVehicle(attacker) then
		if vehicle ~= attacker then
			-- Vehicle Killed by Vehicle Event
			print('Vehicle killed with a vehicle!')
			TriggerEvent('duf:vehicleKilledByVehicle', vehicle, attacker, weapon, isMelee, flags)
		else
			-- Vehicle Killed Event
			print('Vehicle killed!')
			TriggerEvent('duf:vehicleDestroyed', vehicle, attacker, weapon, isMelee, flags)
		end
	elseif IsEntityAPed(attacker) then
		if IsPedAPlayer(attacker) then
			-- Player Killed Vehicle Event
			print('Player killed a vehicle!')
			TriggerEvent('duf:playerKilledVehicle', vehicle, attacker, weapon, isMelee, flags)
		else
			-- Ped Killed Vehicle Event
			print('Ped killed a vehicle!')
			TriggerEvent('duf:pedKilledVehicle', vehicle, attacker, weapon, isMelee, flags)
		end
	else
		-- Vehicle Killed Event
		print('Vehicle killed!')
		TriggerEvent('duf:vehicleDestroyed', vehicle, attacker, weapon, isMelee, flags)
	end
end

---@param ped number | Ped Entity Handle
---@param vehicle number | Vehicle Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedKilledByVehicle(ped, vehicle, weapon, isMelee, flags)
	if IsPedAPlayer(ped) then
		-- Player Killed by Vehicle Event
		print('Player Ped: ' .. ped .. ' killed by Vehicle: ' .. vehicle)
		TriggerEvent('duf:playerKilledByVehicle', ped, vehicle, weapon, isMelee, flags)
	else
		-- Ped Killed by Vehicle Event
		print('Ped: ' .. ped .. ' killed by Vehicle: ' .. vehicle)
		TriggerEvent('duf:pedKilledByVehicle', ped, vehicle, weapon, isMelee, flags)
	end
end

---@param ped number | Ped Entity Handle
---@param player number | Player Ped Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedKilledByPlayer(ped, player, weapon, isMelee)
	if IsPedAPlayer(ped) then
		if ped ~= player then
			-- Player Killed by Player Event
			print('Player Ped: ' .. ped .. ' killed by Player Ped: ' .. player)
			TriggerEvent('duf:playerKilledByPlayer', ped, player, weapon, isMelee)
		else
			-- Player Killed Self Event
			print('Player killed!')
			TriggerEvent('duf:playerKilled', ped, attacker, weapon, isMelee, flags)
		end
	else
		-- Ped Killed by Player Event
		print('Ped: ' .. ped .. ' killed by Player Ped: ' .. player)
		TriggerEvent('duf:pedKilledByPlayer', ped, player, weapon, isMelee)
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedKilledByPed(ped, attacker, weapon, isMelee)
	if IsPedAPlayer(ped) then
		-- Player Killed by Ped Event
		print('Player Ped: ' .. ped .. ' killed by Ped: ' .. attacker)
		TriggerEvent('duf:playerKilledByPed', ped, attacker, weapon, isMelee)
	else
		if ped ~= attacker then
			-- Ped Killed by Ped Event
			print('Ped: ' .. ped .. ' killed by Ped: ' .. attacker)
			TriggerEvent('duf:pedKilledByPed', ped, attacker, weapon, isMelee)
		else
			-- Ped Killed Self Event
			print('Ped killed!')
			TriggerEvent('duf:pedKilled', ped, attacker, weapon, isMelee, flags)
		end
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedKilled(ped, attacker, weapon, isMelee, flags)
	if IsPedAPlayer(ped) then
		-- Player Killed Event
		print('Player killed!')
		TriggerEvent('duf:playerKilled', ped, attacker, weapon, isMelee, flags)
	else
		-- Ped Killed Event
		print('Ped killed!')
		TriggerEvent('duf:pedKilled', ped, attacker, weapon, isMelee, flags)
	end
end

---@param entity number | Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function EntityKilled(entity, attacker, weapon, isMelee, flags)
	print('Something killed!')
	TriggerEvent('duf:entityKilled', entity, attacker, weapon, isMelee, flags)
end

---@param vehicle number | Vehicle Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function VehicleDamaged(vehicle, attacker, weapon, isMelee, flags)
	if IsEntityAVehicle(attacker) then
		if attacker ~= vehicle then
			-- Vehicle Damaged by Vehicle Event
			print('Vehicle: ' .. vehicle .. ' damaged by Vehicle: ' .. attacker)
			TriggerEvent('duf:vehicleDamagedByVehicle', vehicle, attacker, weapon, isMelee, flags)
		else
			-- Vehicle Damaged Event
			print('Vehicle: ' .. vehicle .. ' damaged!')
			TriggerEvent('duf:vehicleDamaged', vehicle, attacker, weapon, isMelee, flags)
		end
	elseif IsEntityAPed(attacker) then
		if IsPedAPlayer(attacker) then
			-- Player Damaged Vehicle Event
			print('Player Ped: ' .. attacker .. ' damaged Vehicle: ' .. vehicle)
			TriggerEvent('duf:playerDamagedVehicle', vehicle, attacker, weapon, isMelee, flags)
		else
			-- Ped Damaged Vehicle Event
			print('Ped: ' .. attacker .. ' damaged Vehicle: ' .. vehicle)
			TriggerEvent('duf:pedDamagedVehicle', vehicle, attacker, weapon, isMelee, flags)
		end
	else
		-- Vehicle Damaged Event
		print('Vehicle: ' .. vehicle .. ' damaged!')
		TriggerEvent('duf:vehicleDamaged', vehicle, attacker, weapon, isMelee, flags)
	end
end

---@param ped number | Ped Entity Handle
---@param vehicle number | Vehicle Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedDamagedByVehicle(ped, vehicle, weapon, isMelee, flags)
	if IsPedAPlayer(ped) then
		-- Player Damaged by Vehicle Event
		print('Player Ped: ' .. ped .. ' damaged by Vehicle: ' .. vehicle)
		TriggerEvent('duf:playerDamagedByVehicle', ped, vehicle, weapon, isMelee, flags)
	else
		-- Ped Damaged by Vehicle Event
		print('Ped: ' .. ped .. ' damaged by Vehicle: ' .. vehicle)
		TriggerEvent('duf:pedDamagedByVehicle', ped, vehicle, weapon, isMelee, flags)
	end
end

---@param ped number | Ped Entity Handle
---@param player number | Player Ped Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedDamagedByPlayer(ped, player, weapon, isMelee)
	if IsPedAPlayer(ped) then
		if ped ~= player then
			-- Player Damaged by Player Event
			print('Player Ped: ' .. ped .. ' damaged by Player Ped: ' .. player)
			TriggerEvent('duf:playerDamagedByPlayer', ped, player, weapon, isMelee)
		else
			-- Player Damaged Self Event
			print('Player damaged!')
			TriggerEvent('duf:playerDamaged', ped, attacker, weapon, isMelee, flags)
		end
	else
		-- Ped Damaged by Player Event
		print('Ped: ' .. ped .. ' damaged by Player Ped: ' .. player)
		TriggerEvent('duf:pedDamagedByPlayer', ped, player, weapon, isMelee)
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
local function PedDamagedByPed(ped, attacker, weapon, isMelee)
	if IsPedAPlayer(ped) then
		-- Player Damaged by Ped Event
		print('Player Ped: ' .. ped .. ' damaged by Ped: ' .. attacker)
		TriggerEvent('duf:playerDamagedByPed', ped, attacker, weapon, isMelee)
	else
		if ped ~= attacker then
			-- Ped Damaged by Ped Event
			print('Ped: ' .. ped .. ' damaged by Ped: ' .. attacker)
			TriggerEvent('duf:pedDamagedByPed', ped, attacker, weapon, isMelee)
		else
			-- Ped Damaged by Self Event
			print('Ped damaged!')
			TriggerEvent('duf:pedDamaged', ped, attacker, weapon, isMelee, flags)
		end
	end
end

---@param ped number | Ped Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function PedDamaged(ped, attacker, weapon, isMelee, flags)
	if IsPedAPlayer(ped) then
		-- Player Damaged Event
		print('Player damaged!')
		TriggerEvent('duf:playerDamaged', ped, attacker, weapon, isMelee, flags)
	else
		-- Ped Damaged Event
		print('Ped damaged!')
		TriggerEvent('duf:pedDamaged', ped, attacker, weapon, isMelee, flags)
	end
end

---@param entity number | Entity Handle
---@param attacker number | Attacker Entity Handle
---@param weapon number | Weapon Hash
---@param isMelee boolean | Is Melee Damage
---@param flags number | Damage Flags
local function EntityDamaged(entity, attacker, weapon, isMelee, flags)
	-- Entity Damaged Event
	print('Entity damaged!')
	TriggerEvent('duf:entityDamaged', entity, attacker, weapon, isMelee, flags)
end

--------------------------------- Network Game Events --------------------------------- [Credits goes to: FiveM Docs and FiveM Forums | https://docs.fivem.net/docs/game-references/game-events/]
-- NOTE: This is not a complete list of game events, I'm going through each event and finding their unknown parameters. If you know any of the unknown parameters, please let me know.

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
					VehicleDestroyed(victim, attacker, weapon, isMelee, flags)
				elseif IsEntityAPed(victim) then
					if IsEntityAVehicle(attacker) then
						PedKilledByVehicle(victim, attacker, weapon, isMelee, flags)
					elseif IsEntityAPed(attacker) then
						if IsPedAPlayer(attacker) then
							PedKilledByPlayer(victim, attacker, weapon, isMelee)
						else
							PedKilledByPed(victim, attacker, weapon, isMelee)
						end
					else
						PedKilled(victim, attacker, weapon, isMelee, flags)
					end
				else
					EntityKilled(victim, attacker, weapon, isMelee)
				end
			else
				if IsEntityAVehicle(victim) then
					VehicleDamaged(victim, attacker, weapon, isMelee, flags)
				elseif IsEntityAPed(victim) then
					if IsEntityAVehicle(attacker) then
						PedDamagedByVehicle(victim, attacker, weapon, isMelee, flags)
					elseif IsEntityAPed(attacker) then
						if IsPedAPlayer(attacker) then
							PedDamagedByPlayer(victim, attacker, weapon, isMelee)
						else
							PedDamagedByPed(victim, attacker, weapon, isMelee)
						end
					else
						PedDamaged(victim, attacker, weapon, isMelee, flags)
					end
				else
					EntityDamaged(victim, attacker, weapon, isMelee, flags)
				end
			end
		end
	elseif name == 'CEventNetworkPlayerEnteredVehicle' then
		local _ = args[1]
		local vehicle = args[2]
		-- local _text = 'CEventNetworkPlayerEnteredVehicle \npid: '..PlayerPedId()..'\nVehicle: '..vehicle..'\nUnknown: '.._
		-- print(_text)
	else
		local _text = 'gameEventTriggered \npid: '..PlayerPedId()..'\nname: '..name..'\nargs: '..json.encode(args)
		print(_text)
	end
end)

--------------------------------- Game Events ---------------------------------

---@param peds table | Array of entity handles who are agitated 
AddEventHandler('CEventAgitated', function(peds)
	-- local _text = 'CEventAgitated \nPeds: '..json.encode(peds)
	-- print(_text)
end)

---@param peds table | Array of entity handles who are agitated
---@param entity number | Handle of the entity which triggered the event
AddEventHandler('CEventAgitatedAction', function(peds, entity)
	-- local _text = 'CEventAgitatedAction \nPlyPId: '..PlayerPedId()..'\nSource: '..entity..'\nPeds: '..json.encode(peds)
	-- print(_text)
end)

---@param entities table | Array of entity handles to send the event to
---@param entity number | Handle of the entity which is sharing the event
AddEventHandler('CEventCommunicateEvent', function(entities, entity)
	-- local _text = 'CEventCommunicateEvent \nSource: '..entity..'\nEntities: '..json.encode(entities)
	-- print(_text)
end)

---@param victims table | Array of entities that were damaged
---@param attacker number | Entity that caused the damage
AddEventHandler('CEventDamage', function(victims, attacker)
	local _text = 'CEventDamage \npid: '..PlayerPedId()..'\nAttacker: '..attacker..'\nVictims: '..json.encode(victims)
	print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who fired the gun
AddEventHandler('CEventGunShot', function(witnesses, ped)
	-- local _text = 'CEventGunShot \nPlyPId: '..PlayerPedId()..'\nShooter: '..ped..'\nWitnesses: '..json.encode(witnesses)
	-- print(_text)
end)

---@param peds table | Array of entity handles who received the task
AddEventHandler('CEventGivePedTask', function(peds)
	-- local _text = 'CEventGivePedTask \nPeds: '..json.encode(peds)
	-- print(_text)
end)

---@param entities table | Array of entities that are in the air (usually peds)
---@param eventEntity number | Entity that triggered the event
AddEventHandler('CEventInAir', function(entities, eventEntity)
	-- local _text = 'CEventInAir \npid: '..PlayerPedId()..'\nEvent Entity: '..eventEntity..'\nEntities: '..json.encode(entities)
	-- print(_text)
end)

---@param entities table | Array of entity handles that are involved in the event (usually the ped which collided with the object)
AddEventHandler('CEventObjectCollision', function(entities)
	-- local _text = 'CEventObjectCollision \npid: '..PlayerPedId()..'\nEntities: '..json.encode(entities)
	-- print(_text)
end)

---@param victims table | Array of entities that could be run over by the vehicle
---@param driver number | The ped handle of the driver
AddEventHandler('CEventPotentialGetRunOver', function(victims, driver)
	-- local _text = 'CEventPotentialGetRunOver \npid: '..PlayerPedId()..'\nDriver: '..driver..'\nVictims: '..json.encode(victims)
	-- print(_text)
end)

---@param passengers table | Array of peds in the vehicle that ran someone over, index 1 is the driver
AddEventHandler('CEventRanOverPed', function(passengers)
	-- local _text = 'CEventRanOverPed \npid: '..PlayerPedId()..'\nDriver: '..passengers[1]..'\nPassengers: '..json.encode(passengers)
	-- print(_text)
end)

---@param peds table | Array of peds receiving the event
---@param initPed number | Ped that first responded to the threat
AddEventHandler('CEventRespondedToThreat', function(peds, initPed)
	-- local _text = 'CEventRespondedToThreat \npid: '..PlayerPedId()..'\nPeds: '..json.encode(peds)..'\nInitial Ped: '..initPed
	-- print(_text)
end)

---@param peds table | Array of entity handles who received the command
AddEventHandler('CEventScriptCommand', function(peds)
	-- local _text = 'CEventScriptCommand \nPed: '..json.encode(peds)
	-- print(_text)
end)

---@param entities table | Array of entities receiving position event
---@param ped number | Ped entity that is calling out shouting positon
AddEventHandler('CEventShoutTargetPosition', function(entities, ped)
	-- local _text = 'CEventShoutTargetPosition \nEntities: '..json.encode(entities)..'\nPed: '..ped
	-- print(_text)
end)

---@param entities table | Array of entity handles that have reached max count
AddEventHandler('CEventStaticCountReachedMax', function(entities)
	-- local _text = 'CEventStaticCountReachedMax \npid: '..PlayerPedId()..'\nEntities: '..json.encode(entities)
	-- print(_text)
end)

---@param peds table | Array of peds that are triggering suspicous activity
AddEventHandler('CEventSuspiciousActivity', function(peds)
	-- local _text = 'CEventSuspiciousActivity \npid: '..PlayerPedId()..'\nEntities: '..json.encode(peds)
	-- print(_text)
end)

-- This event is triggered when the player ped is damaged and has blood decals applied to it
---@param entities table | Array of entities switching to the new model
AddEventHandler('CEventSwitch2NM', function(entities)
	-- local _text = 'CEventSwitch2NM \npid: '..PlayerPedId()..'\nEntities: '..json.encode(entities)
	-- print(_text)
end)

-- Event only seems to return the entity that caused the colision, not the entities involved in the colision
---@param peds table | Table of peds, seems to only be 1 ped
AddEventHandler('CEventVehicleCollision', function(peds)
	-- local _text = 'CEventVehicleCollision \npid: '..PlayerPedId()..'\nPeds: '..json.encode(peds)
	-- print(_text)
end)

---@param passengers table | Array of peds in the vehicle
---@param attacker number | Ped that damaged the vehicle with a weapon
AddEventHandler('CEventVehicleDamageWeapon', function(passengers, attacker)
	-- local _text = 'CEventVehicleDamageWeapon \npid: '..PlayerPedId()..'\nAttacker: '..attacker..'\nPassengers: '..json.encode(passengers)
	-- print(_text)
end)

---@param vehicles table | Table of vehicle entities, the first being the vehicle on fire
AddEventHandler('CEventVehicleOnFire', function(vehicles)
	-- local _text = 'CEventVehicleOnFire \npid: '..PlayerPedId()..'\nVehicles: '..json.encode(vehicles)
	-- print(_text)
end)

---@param peds table | Array of peds that triggered the event
AddEventHandler('CEventWrithe', function(peds)
	-- local _text = 'CEventWrithe \npid: '..PlayerPedId()..'\nPeds: '..json.encode(peds)
	-- print(_text)
end)

--------------------------------- Shocking Events ---------------------------------

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingBicycleCrash', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingBicycleCrash \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the vehicle who triggered the event
---@param x number | X coord of vehicle
---@param y number | Y coord of vehicle
---@param z number | Z coord of vehicle
AddEventHandler('CEventShockingBicycleOnPavement', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingBicycleOnPavement \nPlyPId: '..PlayerPedId()..'\nVehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the vehicle who triggered the event
---@param x number | X coord of vehicle
---@param y number | Y coord of vehicle
---@param z number | Z coord of vehicle
AddEventHandler('CEventShockingCarAlarm', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingCarAlarm \nVehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param driver number | Entity handle of the ped who triggered the event
---@param x number | X coord of driver
---@param y number | Y coord of driver
---@param z number | Z coord of driver
AddEventHandler('CEventShockingCarCrash', function(witnesses, driver, x, y, z)
	-- local _text = 'CEventShockingCarCrash \nPlyPId: '..PlayerPedId()..'\nDriver: '..driver..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param driver number | Entity handle of the driver who triggered the event
---@param x number | X coord of driver
---@param y number | Y coord of driver
---@param z number | Z coord of driver
AddEventHandler('CEventShockingCarOnCar', function(witnesses, driver, x, y, z)
	-- local _text = 'CEventShockingCarOnCar \nPlyPId: '..PlayerPedId()..'\nDriver: '..driver..'\nWitnesses: '..json.encode(witnesses)..'\nargs: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param driver number | Entity handle of the driver who triggered the event
---@param x number | X coord of driver
---@param y number | Y coord of driver
---@param z number | Z coord of driver
AddEventHandler('CEventShockingCarPileUp', function(witnesses, driver, x, y, z)
	-- local _text = 'CEventShockingCarPileUp \npid: '..PlayerPedId()..'\nDriver: '..driver..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param animal number | Entity handle of the animal who triggered the event
---@param x number | X coord of animal
---@param y number | Y coord of animal
---@param z number | Z coord of animal
AddEventHandler('CEventShockingDangerousAnimal', function(witnesses, animal, x, y, z)
	-- local _text = 'CEventShockingDangerousAnimal \nAnimal: '..animal..'\nWitnesses: '..json.encode(witnesses)..'\nargs: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingDeadBody', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingDeadBody \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the vehicle which triggered the event
---@param x number | X coord of vehicle
---@param y number | Y coord of vehicle
---@param z number | Z coord of vehicle
AddEventHandler('CEventShockingDrivingOnPavement', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingDrivingOnPavement \nVehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the vehicle which triggered the event
---@param x number | X coord of vehicle
---@param y number | Y coord of vehicle
---@param z number | Z coord of vehicle
AddEventHandler('CEventShockingEngineRevved', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingEngineRevved \nVehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nargs: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the explosion
---@param entity number | Handle of the entity which triggered the explosion
---@param x number | X coordinate of the explosion
---@param y number | Y coordinate of the explosion
---@param z number | Z coordinate of the explosion
AddEventHandler('CEventShockingExplosion', function(witnesses, entity, x, y, z)
	-- local _text = 'CEventShockingExplosion \nPlyPId: '..PlayerPedId()..'\nSource: '..entity..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the fire
---@param entity number | Handle of the entity which thats on fire
---@param x number | X coordinate of the fire
---@param y number | Y coordinate of the fire
---@param z number | Z coordinate of the fire
AddEventHandler('CEventShockingFire', function(witnesses, entity, x, y, z)
	-- local _text = 'CEventShockingFire \npid: '..PlayerPedId()..'\nSource: '..entity..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param attacker number | Handle of the entity that triggered the event
---@param x number | X coord of attacker
---@param y number | Y coord of attacker
---@param z number | Z coord of attacker
AddEventHandler('CEventShockingGunFight', function(witnesses, attacker, x, y, z)
	-- local _text = 'CEventShockingGunFight \nAttacker: '..attacker..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingGunshotFired', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingGunshotFired \nPlyPId: '..PlayerPedId()..'\nShooter: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the helicopter
---@param x number | X coordinate of the helicopter
---@param y number | Y coordinate of the helicopter
---@param z number | Z coordinate of the helicopter
AddEventHandler('CEventShockingHelicopterOverhead', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingHelicopterOverhead \npid: '..PlayerPedId()..'\nVehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the vehicle which sounded their horn
---@param x number | X coordinate of the vehicle
---@param y number | Y coordinate of the vehicle
---@param z number | Z coordinate of the vehicle
AddEventHandler('CEventShockingHornSounded', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingHornSounded \nPlyPId: '..PlayerPedId()..'\nVehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param attacker number | Entity handle of the ped who injured the other ped
---@param x number | X coordinate of the injured ped
---@param y number | Y coordinate of the injured ped
---@param z number | Z coordinate of the injured ped
AddEventHandler('CEventShockingInjuredPed', function(witnesses, attacker, x, y, z)
	-- local _text = 'CEventShockingInjuredPed \nPlyPId: '..PlayerPedId()..'\nAttacker: '..attacker..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingMadDriver', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingMadDriver \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingMadDriverBicycle', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingMadDriverBicycle \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingMadDriverExtreme', function(ped, witnesses, x, y, z)
	-- local _text = 'CEventShockingMadDriverExtreme \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\naCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped that is parachuting
---@param x number | X coordinate of the parachuter
---@param y number | Y coordinate of the parachuter
---@param z number | Z coordinate of the parachuter
AddEventHandler('CEventShockingParachuterOverhead', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingParachuterOverhead \npid: '..PlayerPedId()..'\nWitnesses: '..json.encode(witnesses)..'\nPed: '..ped..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of peds that witnessed the event
---@param player number | Player ped that knocked into the ped
---@param x number | X coordinate of the event
---@param y number | Y coordinate of the event
---@param z number | Z coordinate of the event
AddEventHandler('CEventShockingPedKnockedIntoByPlayer', function(witnesses, player, x, y, z)
	-- local _text = 'CEventShockingPedKnockedIntoByPlayer \npid: '..PlayerPedId()..'\nWitnesses: '..json.encode(witnesses)..'\nPlayer: '..player..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param driver number | Entity handle of the ped who injured the other ped
---@param x number | X coordinate of the injured ped
---@param y number | Y coordinate of the injured ped
---@param z number | Z coordinate of the injured ped
AddEventHandler('CEventShockingPedRunOver', function(witnesses, driver, x, y, z)
	-- local _text = 'CEventShockingPedRunOver \nPlyPId: '..PlayerPedId()..'\nDriver: '..driver..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of peds that witnessed the event
---@param attacker number | The ped that attacked
---@param x number | The x position of the event
---@param y number | The y position of the event
---@param z number | The z position of the event
AddEventHandler('CEventShockingPedShot', function(witnesses, attacker, x, y, z)
	-- local _text = 'CEventShockingPedShot \nPlyPId: '..PlayerPedId()..'\nWitnesses: '..json.encode(witnesses)..'\nAttacker: '..attacker..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the plane that triggered the event
---@param x number | X coordinate of the plane
---@param y number | Y coordinate of the plane
---@param z number | Z coordinate of the plane
AddEventHandler('CEventShockingPlaneFlyby', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingPlaneFlyby \nWitnesses: '..json.encode(witnesses)..'\nVehicle: '..vehicle..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param entity number | Handle of the entity scared? by the event
---@param x number | X coordinate of the event
---@param y number | Y coordinate of the event
---@param z number | Z coordinate of the event
AddEventHandler('CEventShockingPotentialBlast', function(witnesses, entity, x, y, z)
	-- local _text = 'CEventShockingPotentialBlast \npid: '..PlayerPedId()..'\nWitnesses: '..json.encode(witnesses)..'\nEntity: '..entity..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param attacker number | Handle of the entity who triggered the event
---@param x number | X coord of entity
---@param y number | Y coord of entity
---@param z number | Z coord of entity
AddEventHandler('CEventShockingPropertyDamage', function(witnesses, attacker, x, y, z)
	-- local _text = 'CEventShockingPropertyDamage \nPlyPId: '..PlayerPedId()..'\nAttacker: '..attacker..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles that witnessed the event
---@param ped number | Entity handle of the ped is running
---@param x number | X coordinate of the ped
---@param y number | Y coordinate of the ped
---@param z number | Z coordinate of the ped
AddEventHandler('CEventShockingRunningPed', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingRunningPed \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of peds that witnessed the event
---@param ped number | Handle of the ped that is running (ie triggered the stampede)
---@param x number | X coord of the event
---@param y number | Y coord of the event
---@param z number | Z coord of the event
AddEventHandler('CEventShockingRunningStampede', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingRunningStampede \nPlyPId: '..PlayerPedId()..'\nWitnesses: '..json.encode(witnesses)..'\nPed: '..ped..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entities that witnessed the event
---@param jacker number | The ped that jacked the vehicle
---@param x number | The x coordinate of the vehicle
---@param y number | The y coordinate of the vehicle
---@param z number | The z coordinate of the vehicle
AddEventHandler('CEventShockingSeenCarStolen', function(witnesses, jacker, x, y, z)
	-- local _text = 'CEventShockingSeenCarStolen \npid: '..PlayerPedId()..'\nWitnesses: '..json.encode(witnesses)..'\nJacker: '..jacker..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of peds that witnessed the event
---@param attacker number | The ped that used the melee weapon
---@param x number | The x coordinate of the event
---@param y number | The y coordinate of the event
---@param z number | The z coordinate of the event
AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, attacker, x, y, z)
	-- local _text = 'CEventShockingSeenMeleeAction \nPlyPId: '..PlayerPedId()..'\nAttacker: '..attacker..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param vehicle number | Entity handle of the vehicle who triggered the event
---@param x number | X coord of vehicle
---@param y number | Y coord of vehicle
---@param z number | Z coord of vehicle
AddEventHandler('CEventShockingSeenNiceCar', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingSeenNiceCar \nPlyPId: '..PlayerPedId()..'\nVehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Table of entities that witnessed the event
---@param attacker number | Ped handle of the attacker
---@param x number | X coord of the attacker
---@param y number | Y coord of the attacker
---@param z number | Z coord of the attacker
AddEventHandler('CEventShockingSeenPedKilled', function(witnesses, attacker, x, y, z)
	-- local _text = 'CEventShockingSeenPedKilled \nPlyPId: '..PlayerPedId()..'\nAttacker: '..attacker..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Table of entities that witnessed the event
---@param vehicle number | Entity of the vehicle that triggered the event
---@param x number | X coord of the vehicle
---@param y number | Y coord of the vehicle
---@param z number | Z coord of the vehicle
AddEventHandler('CEventShockingSiren', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingSiren \nvehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entities that witnessed the event
---@param vehicle number | Entity handle of the vehicle towing
---@param x number | X coordinate of the vehicle towing
---@param y number | Y coordinate of the vehicle towing
---@param z number | Z coordinate of the vehicle towing
AddEventHandler('CEventShockingVehicleTowed', function(witnesses, vehicle, x, y, z)
	-- local _text = 'CEventShockingVehicleTowed \nTow Vehicle: '..vehicle..'\nWitnesses: '..json.encode(witnesses)..'\nCoords: '..json.encode(x, y, z)"
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingVisibleWeapon', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingVisibleWeapon \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nargs: '..json.encode(x, y, z)
	-- print(_text)
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingWeaponThreat', function(witnesses, ped, x, y, z)
	-- local _text = 'CEventShockingWeaponThreat \nPlyPId: '..PlayerPedId()..'\nPed: '..ped..'\nWitnesses: '..json.encode(witnesses)..'\nargs: '..json.encode(x, y, z)
	-- print(_text)
end)

--------------------------------- Unknown Parameters ---------------------------------

-- Shocking Events
AddEventHandler('CEventShocking', function(entities, eventEntity, args)
	local _text = 'CEventShocking \nPlyPId: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingCarChase', function(entities, eventEntity, args)
	local _text = 'CEventShockingCarChase \nPlyPId: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingInDangerousVehicle', function(entities, eventEntity, args)
	local _text = 'CEventShockingInDangerousVehicle \nPlyPId: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingMugging', function(entities, eventEntity, args)
	local _text = 'CEventShockingMugging \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingNonViolentWeaponAimedAt', function(entities, eventEntity, args)
	local _text = 'CEventShockingNonViolentWeaponAimedAt \nPlyPId: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingSeenConfrontation', function(entities, eventEntity, args)
	local _text = 'CEventShockingSeenConfrontation \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingSeenGangFight', function(entities, eventEntity, args)
	local _text = 'CEventShockingSeenGangFight \nPlyPId: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingSeenInsult', function(entities, eventEntity, args)
	local _text = 'CEventShockingSeenInsult \nPlyPId: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingStudioBomb', function(entities, eventEntity, args)
	local _text = 'CEventShockingStudioBomb \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingWeirdPed', function(entities, eventEntity, args)
	local _text = 'CEventShockingWeirdPed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShockingWeirdPedApproaching', function(entities, eventEntity, args)
	local _text = 'CEventShockingWeirdPedApproaching \nPlyPId: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

-- Low Level Events
AddEventHandler('CEventRequestHelp', function(entities, eventEntity, args)
	local _text = 'CEventRequestHelp \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventReactionInvestigateThreat', function(entities, eventEntity, args)
	local _text = 'CEventReactionInvestigateThreat \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventReactionInvestigateDeadPed', function(entities, eventEntity, args)
	local _text = 'CEventReactionInvestigateDeadPed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventProvidingCover', function(entities, eventEntity, args)
	local _text = 'CEventProvidingCover \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPotentialWalkIntoVehicle', function(entities, eventEntity, args)
	local _text = 'CEventPotentialWalkIntoVehicle \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPotentialBlast', function(entities, eventEntity, args)
	local _text = 'CEventPotentialBlast \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPotentialBeWalkedInto', function(entities, eventEntity, args)
	local _text = 'CEventPotentialBeWalkedInto \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPlayerUnableToEnterVehicle', function(entities, eventEntity, args)
	local _text = 'CEventPlayerUnableToEnterVehicle \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPlayerDeath', function(entities, eventEntity, args)
	local _text = 'CEventPlayerDeath \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPlayerCollisionWithPed', function(entities, eventEntity, args)
	local _text = 'CEventPlayerCollisionWithPed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPedSeenDeadPed', function(entities, eventEntity, args)
	local _text = 'CEventPedSeenDeadPed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPedOnCarRoof', function(entities, eventEntity, args)
	local _text = 'CEventPedOnCarRoof \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPedJackingMyVehicle', function(entities, eventEntity, args)
	local _text = 'CEventPedJackingMyVehicle \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPedEnteredMyVehicle', function(entities, eventEntity, args)
	local _text = 'CEventPedEnteredMyVehicle \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPedCollisionWithPlayer', function(entities, eventEntity, args)
	local _text = 'CEventPedCollisionWithPlayer \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventPedCollisionWithPed', function(entities, eventEntity, args)
	local _text = 'CEventPedCollisionWithPed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventOnFire', function(entities, eventEntity, args)
	local _text = 'CEventOnFire \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventMustLeaveBoat', function(entities, eventEntity, args)
	local _text = 'CEventMustLeaveBoat \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventMeleeAction', function(entities, eventEntity, args)
	local _text = 'CEventMeleeAction \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventLeaderUnholsteredWeapon', function(entities, eventEntity, args)
	local _text = 'CEventLeaderUnholsteredWeapon \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventLeaderLeftCover', function(entities, eventEntity, args)
	local _text = 'CEventLeaderLeftCover \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventCallForCover', function(entities, eventEntity, args)
	local _text = 'CEventCallForCover \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventCombatTaunt', function(entities, eventEntity, args)
	local _text = 'CEventCombatTaunt \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShoutBlockingLos', function(entities, eventEntity, args)
	local _text = 'CEventShoutBlockingLos \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventBackAway', function(entities, eventEntity, args)
	local _text = 'CEventDataResponseTaskShockingEventBackAway \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventGoto', function(entities, eventEntity, args)
	local _text = 'CEventDataResponseTaskShockingEventGoto \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventWatch', function(entities, eventEntity, args)
	local _text = 'CEventDataResponseTaskShockingEventWatch \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventThreatResponse', function(entities, eventEntity, args)
	local _text = 'CEventDataResponseTaskShockingEventThreatResponse \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventReact', function(entities, eventEntity, args)
	local _text = 'CEventDataResponseTaskShockingEventReact \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventFlee', function(entities, eventEntity, args)
	local _text = 'CEventDataResponseTaskShockingEventFlee \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventDataResponseTaskShockingEventInvestigate', function(entities, eventEntity, args)
	local _text = 'CEventDataResponseTaskShockingEventInvestigate \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventReactionEnemyPed', function(entities, eventEntity, args)
	local _text = 'CEventReactionEnemyPed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventScriptWithData', function(entities, eventEntity, args)
	local _text = 'CEventScriptWithData \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventNewTask', function(entities, eventEntity, args)
	local _text = 'CEventNewTask \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventOpenDoor', function(entities, eventEntity, args)
	local _text = 'CEventOpenDoor \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventRequestHelpWithConfrontation', function(entities, eventEntity, args)
	local _text = 'CEventRequestHelpWithConfrontation \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventScanner', function(entities, eventEntity, args)
	local _text = 'CEventScanner \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventScenarioForceAction', function(entities, eventEntity, args)
	local _text = 'CEventScenarioForceAction \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventVehicleDamage', function(entities, eventEntity, args)
	local _text = 'CEventVehicleDamage \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventUnidentifiedPed', function(entities, eventEntity, args)
	local _text = 'CEventUnidentifiedPed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventStatChangedValue', function(entities, eventEntity, args)
	local _text = 'CEventStatChangedValue \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventStuckInAir', function(entities, eventEntity, args)
	local _text = 'CEventStuckInAir \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventSoundBase', function(entities, eventEntity, args)
	local _text = 'CEventSoundBase \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)

AddEventHandler('CEventShovePed', function(entities, eventEntity, args)
	local _text = 'CEventShovePed \npid: '..PlayerPedId()..'\neventEnt: '..eventEntity..'\nentities: '..json.encode(entities)..'\nargs: '..json.encode(args)
	print(_text)
end)