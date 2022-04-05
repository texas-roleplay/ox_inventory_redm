local Utils = {}

function Utils.PlayAnim(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	lib.requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnim(cache.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(cache.ped) end
	end)
end

function Utils.PlayAnimAdvanced(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time)
	lib.requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnimAdvanced(cache.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time, 0, 0)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(cache.ped) end
	end)
end

function Utils.Raycast(flag)
	local playerCoords = GetEntityCoords(cache.ped)
	local plyOffset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.2, -0.05)
	local rayHandle = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 2.2, flag or 30, cache.ped)
	while true do
		Wait(0)
		local result, _, _, _, entityHit = GetShapeTestResult(rayHandle)
		if result ~= 1 then
			local entityType
			if entityHit then entityType = GetEntityType(entityHit) end
			if entityHit and entityType ~= 0 then
				return entityHit, entityType
			end
			return false
		end
	end
end

function Utils.GetClosestPlayer()
	local closestPlayer, playerId, playerCoords = vec3(10, 0, 0), PlayerId(), GetEntityCoords(cache.ped)
	local coords
	for k, player in pairs(GetActivePlayers()) do
		if player ~= playerId then
			local ped = GetPlayerPed(player)
			coords = GetEntityCoords(ped)
			local distance = #(playerCoords - coords)
			if distance < closestPlayer.x then
				closestPlayer = vec3(distance, player, ped)
			end
		end
	end
	return closestPlayer, coords
end

function Utils.Notify(data) SendNUIMessage({ action = 'showNotif', data = data }) end
function Utils.ItemNotify(data) SendNUIMessage({action = 'itemNotify', data = data}) end
RegisterNetEvent('nxt_inventory:notify', Utils.Notify)
exports('notify', Utils.Notify)

function Utils.Disarm(currentWeapon, newSlot, keepHolstered, fallbackRemoveWeaponName)
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
	if IS_GTAV then
		SetPedCanSwitchWeapon(cache.ped, 0)
		SetPedEnableWeaponBlocking(cache.ped, 1)
	end

	-- print('Utils.Disarm(currentWeapon, newSlot)', json.encode(currentWeapon, { indent = true }), newSlot)

	if currentWeapon or fallbackRemoveWeaponName then
		local playerPed = cache.ped

		local useFallback = fallbackRemoveWeaponName ~= nil

		local weaponName  = useFallback and fallbackRemoveWeaponName		 		  or currentWeapon?.name
		local weaponHash  = useFallback and GetHashKey(fallbackRemoveWeaponName) 	  or currentWeapon?.hash
		local weaponAmmo  = useFallback and GetAmmoInPedWeapon(playerPed, weaponHash) or currentWeapon?.ammo
		local weaponLabel = useFallback and 'UNKNOWN' 								  or currentWeapon?.label

		SetPedAmmo(playerPed, weaponHash, 0)

		local removeWeaponCompletly = not newSlot

		if removeWeaponCompletly then
			if IS_GTAV then
				ClearPedSecondaryTask(playerPed)

				local weapontypeGroup = GetWeapontypeGroup(weaponHash)

				local sleep = (client.hasGroup(shared.police) and (weapontypeGroup == 416676503 or weapontypeGroup == 690389602)) and 450 or 1400
				
				local coords = GetEntityCoords(playerPed, true)

				if currentWeapon.hash == `WEAPON_SWITCHBLADE` then
					Utils.PlayAnimAdvanced(sleep, 'anim@melee@switchblade@holster', 'holster', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 48, 0)
					Wait(600)
				else
					Utils.PlayAnimAdvanced(sleep, (sleep == 450 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h'), 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0)
					Wait(sleep)
				end

			elseif IS_RDR3 and keepHolstered ~= true then
				--[[ _REMOVE_AMMO_FROM_PED_BY_TYPE ]]
				-- Citizen.InvokeNative(0xB6CFEC32E3742779, playerPed, ammoHash, weaponAmmo, GetHashKey('REMOVE_REASON_DROPPED'))

				local ammoHash = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)
				Citizen.InvokeNative(0xB6CFEC32E3742779, playerPed, ammoHash, weaponAmmo, GetHashKey('REMOVE_REASON_DROPPED'))  --_REMOVE_AMMO_FROM_PED_BY_TYPE

				RemoveWeaponFromPed(playerPed, weaponHash)
			end

			Utils.ItemNotify({weaponLabel, weaponName, shared.locale('holstered')})
		end

		if IS_GTAV then
			RemoveAllPedWeapons(playerPed, true)
		elseif IS_RDR3 then

			--[[ GetPedCurrentHeldWeapon]]
			local heldWeapon = N_0x8425c5f057012dab(playerPed)

			--[[ Só usar o Swap caso a arma atualmente carregada pelo ped é a mesma que a gente tá tentando desarmar. ]]
			if heldWeapon == weaponHash then
				--[[ HolsterPedWeapons ]]
				N_0x94a3c1b804d291ec(playerPed, false, false, true, false)

				TaskSwapWeapon(playerPed, 0, 0, 0, 0)

				-- print('Swapping disarm ped weapon')
			end
		end

		if newSlot then
			TriggerServerEvent('nxt_inventory:updateWeapon', weaponAmmo and 'ammo' or 'melee', weaponAmmo or currentWeapon?.melee, newSlot)
		end

		currentWeapon = nil
		TriggerEvent('nxt_inventory:currentWeapon')
	end
end

function Utils.ClearWeapons(currentWeapon)
	currentWeapon = Utils.Disarm(currentWeapon)
	RemoveAllPedWeapons(cache.ped, true)
	if client.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(cache.ped, chute, 0, true, false)
		SetPedGadget(cache.ped, chute, true)
	end
end

function Utils.DeleteObject(obj)
	SetEntityAsMissionEntity(obj, false, true)
	DeleteObject(obj)
end

-- Enables the weapon wheel, but disables the use of inventory items
-- Mostly used for weaponised vehicles, though could be called for "minigames"
function Utils.WeaponWheel(state)
	if state == nil then state = client.weaponWheel end

	client.weaponWheel = state

	SetWeaponsNoAutoswap(not state)
	SetWeaponsNoAutoreload(not state)
	if IS_GTAV then
		SetPedCanSwitchWeapon(cache.ped, state)
		SetPedEnableWeaponBlocking(cache.ped, not state)
	end

end
exports('weaponWheel', Utils.WeaponWheel)

client.utils = Utils
