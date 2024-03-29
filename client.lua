if not lib then return end

local Utils = client.utils
local currentWeapon

playerJob = {onduty = false}

gCanPlayerCloseInventory = true

RegisterNetEvent('JOB:Client:OnJobUpdate', function(jobInfo)
	playerJob = jobInfo
end)

RegisterNetEvent('nxt_inventory:disarm', function(newSlot)
	currentWeapon = Utils.Disarm(currentWeapon, newSlot)
end)

RegisterNetEvent('nxt_inventory:clearWeapons', function()
	Utils.ClearWeapons(currentWeapon)
end)

local StashTarget
exports('setStashTarget', function(id, owner)
	StashTarget = id and {id=id, owner=owner}
end)

local invBusy = true
invOpen = false

local function canOpenInventory()
	return PlayerData.loaded
	and not invBusy
	and not PlayerData.dead
	and not GetPedConfigFlag(cache.ped, 120, true)
	and (currentWeapon == nil or currentWeapon.timer == 0)
	and not IsPauseMenuActive()
	and not IsPedFatallyInjured(cache.ped)
	and invOpen ~= nil
end

local defaultInventory = {
	type = 'newdrop',
	slots = shared.playerslots,
	weight = 0,
	maxWeight = shared.playerweight,
	items = {}
}
local currentInventory = defaultInventory

local function closeTrunk()
	if currentInventory?.type == 'trunk' then
		local coords = GetEntityCoords(cache.ped, true)
		if IS_GTAV then
			Utils.PlayAnimAdvanced(900, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', coords.x, coords.y, coords.z, 0.0, 0.0, GetEntityHeading(cache.ped), 2.0, 2.0, 1000, 49, 0.25)
		end
		CreateThread(function()
			local entity = currentInventory.entity
			local door = currentInventory.door
			Wait(900)
			SetVehicleDoorShut(entity, door, false)
		end)
	end
end

local Interface = client.interface
local plyState = LocalPlayer.state

---@param inv string inventory type
---@param data table id and owner
---@return boolean
function openInventory(inv, data)
	if invOpen then
		if not inv and currentInventory.type == 'newdrop' then
			return TriggerEvent('nxt_inventory:closeInventory')
		end

		if inv == 'container' and currentInventory.id == PlayerData.inventory[data].metadata.container then
			return TriggerEvent('nxt_inventory:closeInventory')
		end

		if currentInventory.type == 'drop' and (not data or currentInventory.id == (type(data) == 'table' and data.id or data)) then
			return TriggerEvent('nxt_inventory:closeInventory')
		end
	end

	if inv == 'dumpster' and cache.vehicle then
		return Utils.Notify({type = 'error', text = shared.locale('inventory_right_access'), duration = 2500})
	end

	if canOpenInventory() then
		local left, right

		if inv == 'shop' and invOpen == false then
			if data.type == "PoliceArmoury" then
				if not playerJob.onduty then
					TriggerEvent("texas:notify:native", "Você precisa estar em serviço", 3000)
					return
				end
			end
			
			left, right = lib.callback.await('nxt_inventory:openShop', 200, data)
		elseif invOpen ~= nil then

			--[[ Veicúlos também é aqui ]]
				if inv == 'policeevidence' then					
					if playerJob.onduty then
						local input = Interface.Keyboard(shared.locale('police_evidence'), {shared.locale('locker_number')})

						if input then
							input = tonumber(input[1])
						else
							return Utils.Notify({text = shared.locale('locker_no_value'), type = 'error'})
						end

						if type(input) ~= 'number' then
							return Utils.Notify({text = shared.locale('locker_must_number'), type = 'error'})
						else
							data = input
						end
					else
						TriggerEvent("texas:notify:native", "Você precisa estar em serviço", 3000)
					end
				end
			left, right = lib.callback.await('nxt_inventory:openInventory', false, inv, data)
		end

		if left then
			if inv ~= 'trunk' and not cache.vehicle then
				if IS_GTAV then
					Utils.PlayAnim(1000, 'pickup_object', 'putdown_low', 5.0, 1.5, -1, 48, 0.0, 0, 0, 0)
				end
			end

			plyState.invOpen = true
			SetInterval(client.interval, 100)
			SetNuiFocus(true, true)

			if IS_GTAV then
				SetNuiFocusKeepInput(true)
			end

			if IS_GTAV then
				if client.screenblur then TriggerScreenblurFadeIn(0) end
			end
			closeTrunk()
			currentInventory = right or defaultInventory
			left.items = PlayerData.inventory
			SendNUIMessage({
				action = 'setupInventory',
				data = {
					leftInventory = left,
					rightInventory = currentInventory
				}
			})

			if not currentInventory.coords and not inv == 'container' then
				currentInventory.coords = GetEntityCoords(cache.ped)
			end

			-- Stash exists (useful for custom stashes)
			return true
		else
			-- Stash does not exist
			if left == false then return false end
			if invOpen == false then Utils.Notify({type = 'error', text = shared.locale('inventory_right_access'), duration = 2500}) end
			if invOpen then TriggerEvent('nxt_inventory:closeInventory') end
		end
	elseif invBusy then Utils.Notify({type = 'error', text = shared.locale('inventory_player_access'), duration = 2500}) end
end
RegisterNetEvent('nxt_inventory:openInventory', openInventory)
exports('openInventory', openInventory)

---@param data table
---@param cb function
local function useItem(data, cb)
	
	if invOpen and data.close then TriggerEvent('nxt_inventory:closeInventory') end
	if not invBusy and not PlayerData.dead and not Interface.ProgressActive and not IsPedRagdoll(cache.ped) and not IsPedFalling(cache.ped) then
		if currentWeapon and currentWeapon?.timer > 100 then
			return
		end
		invBusy = true
		local result = lib.callback.await('nxt_inventory:useItem', 200, data.name, data.slot, PlayerData.inventory[data.slot].metadata)

		if not result then
			Wait(500)
			invBusy = false
			return
		end

		local p
		if result and invBusy then
			plyState.invBusy = true
			if data.client then data = data.client end
			if data.usetime then
				p = promise.new()
				Interface.Progress({
					duration = data.usetime,
					label = data.label or shared.locale('using', result.label),
					useWhileDead = data.useWhileDead or false,
					canCancel = data.cancel or false,
					disable = data.disable,
					anim = data.anim or data.scenario,
					prop = data.prop,
					propTwo = data.propTwo
				}, function(cancel)
					p:resolve(PlayerData.dead or cancel)
				end)
			end

			if p then
				Citizen.Await(p)
			end

			if not p or not p.value then
				if result.consume and result.consume ~= 0 and not result.component then
					TriggerServerEvent('nxt_inventory:removeItem', result.name, result.consume, result.metadata, result.slot, true)
				end

				if data.status then
					for k, v in pairs(data.status) do
						if v > 0 then TriggerEvent('esx_status:add', k, v) else TriggerEvent('esx_status:remove', k, -v) end
					end
				end

				if data.notification then
					Utils.Notify({text = data.notification})
				end

				if cb then
					cb(result)
				end

				Wait(500)
				plyState.invBusy = false
				return
			end
		end
	end
	if cb then cb(false) end
	Wait(200)
	plyState.invBusy = false
end
AddEventHandler('nxt_inventory:item', useItem)
exports('useItem', useItem)

local Items = client.items

---@param slot number
---@return boolean
local function useSlot(slot)
	if PlayerData.loaded and not PlayerData.dead and not invBusy and not Interface.ProgressActive then		

		local item = PlayerData.inventory[slot]

		if not item then return end
		
		local data = item and Items[item.name]
		if not data or not data.usable then return end

		if data.component and not currentWeapon then
			return Utils.Notify({type = 'error', text = shared.locale('weapon_hand_required')})
		end

		data.slot = slot

		if item.metadata.container then
			return openInventory('container', item.slot)
		elseif data.client then
			if invOpen and data.close then TriggerEvent('nxt_inventory:closeInventory') end

			if data.export then
				return data.export(data, {name = item.name, slot = item.slot, metadata = item.metadata})
			elseif data.client.event then -- deprecated, to be removed
				return error(('unable to trigger event for %s, data.client.event has been removed. utilise exports instead.'):format(item.name))
			end
		end

		if data.effect then
			data:effect({name = item.name, slot = item.slot, metadata = item.metadata})
		elseif data.weapon then
			if client.weaponWheel then return end
			useItem(data, function(result)
				if result then
					if currentWeapon?.slot == result.slot then
						--[[ Só manter no coldre caso não seja um throwable ]]
						local keepHolstered = data.throwable ~= true

						currentWeapon = Utils.Disarm(currentWeapon, nil, keepHolstered)
						return
					end

					local playerPed = cache.ped
					ClearPedSecondaryTask(playerPed)
					if data.throwable then item.throwable = true end

					if IS_GTAV then
						if currentWeapon then
							currentWeapon = Utils.Disarm(currentWeapon)
						end
					end

					local sleep = 0
					
					if IS_GTAV then
						sleep = (client.hasGroup(shared.police) and (GetWeapontypeGroup(data.hash) == 416676503 or GetWeapontypeGroup(data.hash) == 690389602)) and 400 or 1200
					end

					local coords = GetEntityCoords(playerPed, true)

					if IS_GTAV then
						if item.hash == `WEAPON_SWITCHBLADE` then
							Utils.PlayAnimAdvanced(sleep*2, 'anim@melee@switchblade@holster', 'unholster', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 48, 0.1)
							Wait(100)
						else
							Utils.PlayAnimAdvanced(sleep*2, sleep == 400 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h', 'intro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0.1)
							Wait(sleep)
						end
					end

					SetPedAmmo(playerPed, data.hash, 0)

					if IS_GTAV then
						GiveWeaponToPed(playerPed, data.hash, 0, false, true)
					elseif IS_RDR3 then

						if not HasPedGotWeapon(playerPed, data.hash, 0, false) then

							local currentWeaponAmmo = GetAmmoInPedWeapon(playerPed, data.hash)

							-- RemoveAmmoFromPed
							N_0xf4823c813cb8277d(playerPed, data.hash, currentWeaponAmmo, `REMOVE_REASON_DEBUG`)

							--[[ GiveWeaponToPed ]]
							if data.throwable then
								Citizen.InvokeNative(0xB282DC6EBD803C75, playerPed, data.hash, tonumber(item.count), true, 0) -- GIVE_DELAYED_WEAPON_TO_PED
							else	
								Citizen.InvokeNative(0xB282DC6EBD803C75, playerPed, data.hash, item.metadata.ammo, true, 0) -- GIVE_DELAYED_WEAPON_TO_PED
							end
						
							-- Citizen.InvokeNative(0x5E3BDDBCB83F3D84,
							-- 	playerPed --[[ Ped ]], 
							-- 	data.hash --[[ Hash ]], 
							-- 	0 --[[ integer ]], 
							-- 	true --[[ boolean ]], 
							-- 	false --[[ boolean ]], 
							-- 	0 --[[ integer ]], 
							-- 	false --[[ boolean ]], 
							-- 	0 --[[ number ]], 
							-- 	0 --[[ number ]], 
							-- 	0 --[[ Hash ]], 
							-- 	true --[[ boolean ]], 
							-- 	false --[[ number ]], 
							-- 	00 --[[ boolean ]]
							-- )

							-- print('gave weapon to ped')
						end
					end

					if item.metadata.tint then
						SetPedWeaponTintIndex(playerPed, data.hash, item.metadata.tint)
					end

					if item.metadata.components then
						for i = 1, #item.metadata.components do
							local components = Items[item.metadata.components[i]].client.component
							for v=1, #components do
								local component = components[v]
								if DoesWeaponTakeWeaponComponent(data.hash, component) then
									if not HasPedGotWeaponComponent(playerPed, data.hash, component) then
										GiveWeaponComponentToPed(playerPed, data.hash, component)
									end
								end
							end
						end
					end

					item.hash = data.hash
					item.ammo = data.ammoname
					item.melee = (not item.throwable and not data.ammoname) and 0
					item.timer = 0
					
					if IS_GTAV then
						SetCurrentPedWeapon(playerPed, data.hash, true)
						SetPedCurrentWeaponVisible(playerPed, true, false, false, false)

						AddAmmoToPed(playerPed, data.hash, item.metadata.ammo or 100)
					elseif IS_RDR3 then
						
						-- print(data.hash,  `weapon_revolver_lemat`)

						-- if not HasPedGotWeapon(playerPed, data.hash, true) then
						-- 	print('ped tem a arma?')
						-- 	-- _ADD_AMMO_TO_PED
						-- 	N_0xb190bca3f4042f95(
						-- 		playerPed --[[ Ped ]], 
						-- 		data.hash --[[ Hash ]], 
						-- 		item.metadata.ammo or 100 --[[ integer ]], 
						-- 		`ADD_REASON_DEFAULT` --[[ Hash ]]
						-- 	)
						-- end

						SetCurrentPedWeapon(playerPed, data.hash, false, 0, false, false)
						-- TaskSwapWeapon(playerPed, 1, 0, 0, 0)

						-- print('adding ammo and swapping to weapon')
					end

					Wait(0)

					if IS_GTAV then
						RefillAmmoInstantly(playerPed)
					end


					if data.hash == `WEAPON_PETROLCAN` or data.hash == `WEAPON_HAZARDCAN` or data.hash == `WEAPON_FIREEXTINGUISHER` then
						item.metadata.ammo = item.metadata.durability
						SetPedInfiniteAmmo(playerPed, true, data.hash)
					end

					currentWeapon = item
					TriggerEvent('nxt_inventory:currentWeapon', item)
					Utils.ItemNotify({item.label, item.name, shared.locale('equipped')})
					Wait(sleep)
					ClearPedSecondaryTask(playerPed)
				end
			end)
		elseif currentWeapon then
			local playerPed = cache.ped
			if data.ammo then
				if client.weaponWheel or currentWeapon.metadata.durability <= 0 then return end

				local currentWeaponHash = currentWeapon.hash

				local maxAmmo = GetMaxAmmoInClip(playerPed, currentWeaponHash, true)
				local currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)

				local isABow = currentWeaponHash == `WEAPON_BOW` or currentWeaponHash == `WEAPON_BOW_IMPROVED`

				if IS_RDR3 then
					if isABow then
						--[[ 
							Permitir usar até o máximo de munições possiveis quando estiver usando um arco, ao inves
							de usar só o máximo possivo no clip, que no arco é 1
						--]]

						--[[
							A rockstar também define o máximo de munição manualmente nos scripts dela ;)
						--]]
						maxAmmo = 5
					end
				end

				if currentAmmo ~= maxAmmo and currentAmmo < maxAmmo then
					useItem(data, function(data)

						if data then
							if data.name == currentWeapon.ammo then
								local missingAmmo = 0
								local newAmmo = 0

								missingAmmo = maxAmmo - currentAmmo

								if missingAmmo > data.count then
									newAmmo = currentAmmo + data.count
								else
									--[[ Overflow ]]
									newAmmo = maxAmmo
								end

								if newAmmo < 0 then
									newAmmo = 0
								end

								SetPedAmmo(playerPed, currentWeapon.hash, newAmmo)

								local makePedReload = IS_GTAV and MakePedReload or N_0x79e1e511ff7efb13
								makePedReload(playerPed)

								currentWeapon.metadata.ammo = newAmmo
								
								TriggerServerEvent('nxt_inventory:updateWeapon', 'load', currentWeapon.metadata.ammo)
							end
						end
					end)
				end
			elseif data.component then
				local components = data.client.component
				local componentType = data.type
				local weaponComponents = PlayerData.inventory[currentWeapon.slot].metadata.components
				-- Checks if the weapon already has the same component type attached
				for componentIndex = 1, #weaponComponents do
					if componentType == Items[weaponComponents[componentIndex]].type then
						-- todo: Update locale?
						return Utils.Notify({type = 'error', text = shared.locale('component_has', data.label)})
					end
				end
				for i = 1, #components do
					local component = components[i]

					if DoesWeaponTakeWeaponComponent(currentWeapon.hash, component) then
						if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component) then
							Utils.Notify({type = 'error', text = shared.locale('component_has', data.label)})
						else
							useItem(data, function(data)
								if data then
									GiveWeaponComponentToPed(playerPed, currentWeapon.hash, component)
									table.insert(PlayerData.inventory[currentWeapon.slot].metadata.components, data.name)
									TriggerServerEvent('nxt_inventory:updateWeapon', 'component', tostring(data.slot), currentWeapon.slot)
								end
							end)
						end
						return
					end
				end
				Utils.Notify({type = 'error', text = shared.locale('component_invalid', data.label) })
			elseif data.allowArmed then
				useItem(data)
			end
		else
			useItem(data)
		end
	end
end
exports('useSlot', useSlot)

---@param id number
---@param slot number
local function useButton(id, slot)
	if PlayerData.loaded and not invBusy and not Interface.ProgressActive then
		local item = PlayerData.inventory[slot]
		if not item then return end
		local data = item and Items[item.name]
		if data.buttons and data.buttons[id]?.action then
			data.buttons[id].action(slot)
		end
	end
end



---@param ped number
---@return boolean
local function canOpenTarget(ped)
	return IsEntityPlayingAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3) or IsPedFatallyInjured(ped) or IsEntityDead(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or GetPedConfigFlag(ped, 120, true)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end

local function openNearbyInventory()
	if canOpenInventory() then
		local closestPlayer, dist = Utils.GetClosestPlayer()
		if dist < 2 and (client.hasGroup(shared.police) or canOpenTarget(GetPlayerPed(closestPlayer))) then
			if IS_GTAV then
				Utils.PlayAnim(2000, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 50, 0.0, 0, 0, 0)
			end
			openInventory('player', GetPlayerServerId(closestPlayer))
		end
	end
end
exports('openNearbyInventory', openNearbyInventory)

local currentInstance
local nearbyMarkers, closestMarker = {}, {}
local drops, playerCoords

local function markers(tb, type, rgb, name, vehicle)
	if tb then
		for k, v in pairs(tb) do
			if not v.instance or v.instance == currentInstance then
				if not v.groups or client.hasGroup(v.groups) then
					local coords = v.coords or v
					local distance = #(playerCoords - coords)
					local id = name and type..name..k or type..k
					local marker = nearbyMarkers[id]

					if distance < 1.2 then
						if not marker then
							nearbyMarkers[id] = mat(vec3(coords), vec3(rgb))
						end

						if not vehicle then
							if closestMarker[1] == nil or (closestMarker and distance < closestMarker[1]) then
								closestMarker[1] = distance
								closestMarker[2] = k
								closestMarker[3] = type
								closestMarker[4] = name or v.name
							end
						end
					elseif not marker and distance < 8 then
						nearbyMarkers[id] = mat(vec3(coords), vec3(rgb))
					elseif marker and distance > 8 then
						nearbyMarkers[id] = nil
					end
				end
			end
		end
	end
end

local table = lib.table
local Shops = client.shops
local Inventory = client.inventory

function OnPlayerData(key, val)
	if key == 'groups' then
		Shops()
		if shared.qtarget then
			Inventory.Stashes()
			Inventory.Evidence()
		end
		table.wipe(nearbyMarkers)
	elseif key == 'dead' and val then
		currentWeapon = Utils.Disarm(currentWeapon)
		TriggerEvent('nxt_inventory:closeInventory')
	end

	Utils.WeaponWheel()
end

local function registerCommands()

	RegisterCommand('inv', function()
		tryOpenInventory()
	end)

	function tryOpenInventory()
		if closestMarker[1] and closestMarker[3] ~= 'license' then
			openInventory(closestMarker[3], {id=closestMarker[2], type=closestMarker[4]})
		else openInventory() end
	end

	RegisterKeyMapping('inv', shared.locale('open_player_inventory'), 'keyboard', client.keys[1])
	TriggerEvent('chat:removeSuggestion', '/inv')

	local Vehicles = data 'vehicles'
	
	RegisterCommand('inv2', function()
		tryOpenVehicleInventory()
	end)

	function tryOpenVehicleInventory()
		if not invOpen then
			if invBusy then return Utils.Notify({type = 'error', text = shared.locale('inventory_player_access'), duration = 2500})
			else
				if not canOpenInventory() then
					return Utils.Notify({type = 'error', text = shared.locale('inventory_player_access'), duration = 2500})
				end

				if StashTarget then
					openInventory('stash', StashTarget)
				elseif cache.vehicle then
					local vehicle = cache.vehicle

					if NetworkGetEntityIsNetworked(vehicle) then
						local checkVehicle = Vehicles.Storage[GetEntityModel(vehicle)]
						if checkVehicle == 0 or checkVehicle == 2 then -- No storage or no glovebox
							return
						end

						if IS_GTAV then
							local plate = client.trimplate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
							OpenInventory('glovebox', {id='glove'..plate, class=GetVehicleClass(vehicle), model=GetEntityModel(vehicle), label="Alforge"})
						end
						if IS_RDR3 then

							local horseUUID = Entity(vehicle).state.horseUUID

							if not horseUUID then
								--[[ O cavalo não faz parte do nosso sistema. ]]
								return
							end

							local gloveId = ('glove%d' --[[ é junto assim mesmo... não tá errado ]]):format(horseUUID)

							--[[ Achar `class` e `model` a partir do id server-side. ]]
							OpenInventory('glovebox',
								{
									id = gloveId,                                                            
									class = 8,
									model = GetEntityModel(vehicle),
									label="Alforge"
								}
							)
						end

						while true do
							Wait(100)
							if not invOpen then break
							elseif not cache.vehicle then
								TriggerEvent('nxt_inventory:closeInventory')
								break
							end
						end
					end
				else
					local entity, type = Utils.Raycast(2|1024|2048)
					
					if not entity then return end

					local vehicle, position
					if not shared.qtarget then
						if type == 2 or type == 1 then vehicle, position = entity, GetEntityCoords(entity)

						elseif type == 3 and table.contains(Inventory.Dumpsters, GetEntityModel(entity)) then
							local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

							if not netId then
								NetworkRegisterEntityAsNetworked(entity)
								netId = NetworkGetNetworkIdFromEntity(entity)
								NetworkUseHighPrecisionBlending(netId, false)
								SetNetworkIdExistsOnAllMachines(netId, true)
								SetNetworkIdCanMigrate(netId, true)
							end

							return openInventory('dumpster', 'dumpster'..netId)
						end
					elseif type == 2 then
						vehicle, position = entity, GetEntityCoords(entity)				
					else return end

					local lastVehicle = nil
					local class = nil

					if IS_GTAV then
						class = GetVehicleClass(vehicle)
					end
					
					local vehHash = GetEntityModel(vehicle)
					
					if vehicle and (Vehicles.trunk['models'][vehHash] or Vehicles.trunk[class]) or (Vehicles.glovebox['models'][vehHash] or Vehicles.glovebox[class]) and #(playerCoords - position) < 6 and NetworkGetEntityIsNetworked(vehicle) then

						if IS_GTAV then
							local locked = GetVehicleDoorLockStatus(vehicle)

							if locked == 0 or locked == 1 then
								local checkVehicle = Vehicles.Storage[vehHash]
								local open, vehBone

								if checkVehicle == nil then -- No data, normal trunk
									open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot')
								elseif checkVehicle == 3 then -- Trunk in hood
									open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
								else -- No storage or no trunk
									return
								end

								if vehBone == -1 then vehBone = GetEntityBoneIndexByName(vehicle, Vehicles.trunk.boneIndex[vehHash] or 'platelight') end

								position = GetWorldPositionOfEntityBone(vehicle, vehBone)
								local distance = #(playerCoords - position)
								local closeToVehicle = distance < 2 and (open == 5 and (checkVehicle == nil and true or 2) or open == 4)

								if closeToVehicle then
									local plate = client.trimplate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)

									TaskTurnPedToFaceCoord(cache.ped, position.x, position.y, position.z)

									lastVehicle = vehicle
									openInventory('trunk', {id='trunk'..plate, class=class, model=vehHash})

									local timeout = 20
									repeat Wait(50)
										timeout -= 1
									until (currentInventory and currentInventory.type == 'trunk') or timeout == 0

									if timeout == 0 then
										closeToVehicle, lastVehicle = false, nil
										return
									end

									SetVehicleDoorOpen(vehicle, open, false, false)
									Wait(200)
									if IS_GTAV then
										Utils.PlayAnim(0, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0.0, 0, 0, 0)
									end
									currentInventory.entity = lastVehicle
									currentInventory.door = open

									while true do
										Wait(50)

										if closeToVehicle and invOpen then
											position = GetWorldPositionOfEntityBone(vehicle, vehBone)

											if #(GetEntityCoords(cache.ped) - position) >= 2 or not DoesEntityExist(vehicle) then
												break
											else TaskTurnPedToFaceCoord(cache.ped, position.x, position.y, position.z) end
										else break end
									end

									if lastVehicle then TriggerEvent('nxt_inventory:closeInventory') end
								end
							else Utils.Notify({type = 'error', text = shared.locale('vehicle_locked'), duration = 2500}) end
						end

						if IS_RDR3 then
							
							local netId = NetworkGetNetworkIdFromEntity(vehicle)

							if not netId then
								return
							end

							local vehicleUUID 

							local timeout = 20
							
							local distance = #(playerCoords - position)

							local closeToVehicle = distance < 2

							if closeToVehicle then

								if Vehicles.trunk['models'][vehHash] then
									if Entity(vehicle).state.wagonId then 
										vehicleUUID = Entity(vehicle).state.wagonId
									else
										vehicleUUID = "temp:" .. netId
									end
									
									lastVehicle = vehicle

									openInventory('trunk', {id='trunk'..vehicleUUID, model=vehHash, label="Carroça"})						
									
								elseif Vehicles.glovebox['models'][vehHash] then
									if Citizen.InvokeNative(0xAAB0FE202E9FC9F0, vehicle, -1) then -- _IS_MOUNT_SEAT_FREE
										
										vehicleUUID = Entity(vehicle).state.horseUUID 											
										if not vehicleUUID then
											print('não achei o UUID')
											return
										end
										
										lastVehicle = exports.horses:tryOpenSaddleInventory(vehicleUUID, vehicle)
									end
								end

								if lastVehicle and currentInventory then
									currentInventory.entity = lastVehicle
								end
							end

							Wait(200)

							while true do
								Wait(50)

								distance = #(playerCoords - position)

								if closeToVehicle and invOpen then
									if #(GetEntityCoords(cache.ped) - GetEntityCoords(currentInventory.entity)) >= 2 or not DoesEntityExist(vehicle) then
										break
									else 
										-- TaskTurnPedToFaceCoord(cache.ped, position.x, position.y, position.z) 
									end
								else 
									break
								end

							end
						
							if lastVehicle then TriggerEvent('nxt_inventory:closeInventory') end
						end
					end
				end
			end
		else return TriggerEvent('nxt_inventory:closeInventory')
		end
	end
	RegisterKeyMapping('inv2', shared.locale('open_secondary_inventory'), 'keyboard', client.keys[2])
	TriggerEvent('chat:removeSuggestion', '/inv2')

	RegisterCommand('reload', function()
		playerReload()
	end)

	function playerReload()
		if currentWeapon?.ammo then
			if currentWeapon.metadata.durability > 0 then
				local ammo = Inventory.Search(1, currentWeapon.ammo)
				if ammo[1] then useSlot(ammo[1].slot) end
			else
				Utils.Notify({type = 'error', text = shared.locale('no_durability', currentWeapon.label), duration = 2500})
			end
		end
	end	
	RegisterKeyMapping('reload', shared.locale('reload_weapon'), 'keyboard', 'r')
	TriggerEvent('chat:removeSuggestion', '/reload')

	RegisterCommand('hotbar', function()
		if not client.weaponWheel and not IsPauseMenuActive() then
			SendNUIMessage({ action = 'toggleHotbar' })
		end
	end)
	RegisterKeyMapping('hotbar', shared.locale('disable_hotbar'), 'keyboard', client.keys[3])
	TriggerEvent('chat:removeSuggestion', '/hotbar')

	RegisterCommand('revistar', function()
		openNearbyInventory()
	end)

	for i = 1, 5 do
		local hotkey = ('hotkey%s'):format(i)
		RegisterCommand(hotkey, function() if not invOpen then useSlot(i) end end)
		RegisterKeyMapping(hotkey, shared.locale('use_hotbar', i), 'keyboard', i)
		TriggerEvent('chat:removeSuggestion', '/'..hotkey)
	end

end


if IS_RDR3 then
	local function useHotKeyByControl(key)
		if not IsEntityDead(PlayerPedId()) and not IsPauseMenuActive() then
			if not invOpen then
				CreateThread(function()
					--[[ useSlot is thread-blocking af. ]]
					useSlot(key)
				end)
			end		
		end
	end	

	Citizen.CreateThread(function()

		local HOTKEY_CONTROL_MAPPING =
		{
			{
				1, --[[ Hotkey ]]
				{
					`INPUT_SELECT_QUICKSELECT_SIDEARMS_LEFT`, --[[ Botão padrão ]]
					`INPUT_EMOTE_DANCE`, --[[ Botão usado para quando o menu de ação está aberto ]]
				},
			},
			{
				2,
				{
					`INPUT_SELECT_QUICKSELECT_DUALWIELD`,
					`INPUT_EMOTE_GREET`,
				},
			},
			{
				3,
				{
					`INPUT_SELECT_QUICKSELECT_SIDEARMS_RIGHT`,
					`INPUT_EMOTE_COMM`,
				},
			},
			{
				4,
				{
					`INPUT_SELECT_QUICKSELECT_UNARMED`,
					`INPUT_EMOTE_TAUNT`,
				},
			},
			{
				5,
				{
					`INPUT_SELECT_QUICKSELECT_MELEE_NO_UNARMED`,
				},
			},
		}

		while true do
			Citizen.Wait(0)
	
			if PlayerData then

				for _, mapping in ipairs(HOTKEY_CONTROL_MAPPING) do
					local controlHashes = mapping[2]

					for _, controlHash in ipairs(controlHashes) do						
						DisableControlAction(0, controlHash, true)
						if IsDisabledControlJustPressed(0, controlHash) then
							local hotkey = mapping[1]

							useHotKeyByControl(hotkey)

							goto skip_hotkey_processing
						end
					end
				end

				:: skip_hotkey_processing ::
				
				if IsDisabledControlJustPressed(0, `INPUT_OPEN_WHEEL_MENU`) then -- tab
					if not client.weaponWheel and not IsPauseMenuActive() then
						SendNUIMessage({ action = 'toggleHotbar' })
					end
				end

				if IsControlJustReleased(0, `INPUT_QUICK_USE_ITEM`) then -- open inventory I
					tryOpenInventory()
				end

				if IsControlJustReleased(0,  `INPUT_RELOAD`) then -- reload R
					playerReload()
				end

				if IsControlJustReleased(0,  `INPUT_AIM_IN_AIR`) then -- open inventory U
					tryOpenVehicleInventory()
				end
			end
		end
	end)
end

RegisterNetEvent('nxt_inventory:closeInventory', function(server)
	if invOpen then
		invOpen = nil
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		if IS_GTAV then
			TriggerScreenblurFadeOut(0)
		end
		closeTrunk()
		SendNUIMessage({ action = 'closeInventory' })
		SetInterval(client.interval, 200)
		Wait(200)

		if not server and currentInventory then
			TriggerServerEvent('nxt_inventory:closeInventory')
		end

		currentInventory = false
		plyState.invOpen = false
		defaultInventory.coords = nil

		--[[ Resetar, o inventário foi fechado pelo próprio script. ]]
		gCanPlayerCloseInventory = true
	end
end)

local function updateInventory(items, weight)
	
	-- todo: combine iterators
	local changes = {}
	local itemCount = {}
	-- swapslots
	if type(weight) == 'number' then
		for slot, v in pairs(items) do
			local item = PlayerData.inventory[slot]

			if item then
				itemCount[item.name] = (itemCount[item.name] or 0) - item.count
			end

			if v then
				itemCount[v.name] = (itemCount[v.name] or 0) + v.count
			end

			PlayerData.inventory[slot] = v and v or nil
			changes[slot] = v
		end
		client.setPlayerData('weight', weight)
	else
		for i = 1, #items do
			local v = items[i].item
			local item = PlayerData.inventory[v.slot]

			if item?.name then
				itemCount[item.name] = (itemCount[item.name] or 0) - item.count
			end

			if v.count then
				itemCount[v.name] = (itemCount[v.name] or 0) + v.count
			end

			changes[v.slot] = v.count and v or false
			if not v.count then v.name = nil end
			PlayerData.inventory[v.slot] = v.name and v or nil
		end
		client.setPlayerData('weight', weight.left)
		SendNUIMessage({ action = 'refreshSlots', data = items })
	end

	for item, count in pairs(itemCount) do
		local data = Items[item]
		
		if count < 0 then
			data.count += count

			if shared.framework == 'esx' then
				TriggerEvent('esx:removeInventoryItem', data.name, data.count)
			else
				TriggerEvent('nxt_inventory:itemCount', data.name, data.count)
			end

			if data.client?.remove then
				data.client.remove(data.count)
			end
		elseif count > 0 then
			data.count += count

			if shared.framework == 'esx' then
				TriggerEvent('esx:addInventoryItem', data.name, data.count)
			else
				TriggerEvent('nxt_inventory:itemCount', data.name, data.count)
			end

			if data.client?.add then
				data.client.add(data.count)
			end
		end
	end

	client.setPlayerData('inventory', PlayerData.inventory)
	TriggerEvent('nxt_inventory:updateInventory', changes)
end

RegisterNetEvent('nxt_inventory:updateSlots', function(items, weights, count, removed)
	if count then
		local item = items[1].item

		local localeKey = removed and 'removed' or 'added'

		if item.name == "money" then
			localeKey = localeKey .. '_money'

			count = count / 100
		end

		Utils.ItemNotify({item.label, item.name, shared.locale(localeKey, count)})
	end

	updateInventory(items, weights)
end)

RegisterNetEvent('nxt_inventory:inventoryReturned', function(data)
	Utils.Notify({text = shared.locale('items_returned'), duration = 2500})
	if currentWeapon then currentWeapon = Utils.Disarm(currentWeapon) end
	TriggerEvent('nxt_inventory:closeInventory')
	PlayerData.inventory = data[1]
	client.setPlayerData('inventory', data[1])
	client.setPlayerData('weight', data[3])
end)

RegisterNetEvent('nxt_inventory:inventoryConfiscated', function(message)
	if message then Utils.Notify({text = shared.locale('items_confiscated'), duration = 2500}) end
	if currentWeapon then currentWeapon = Utils.Disarm(currentWeapon) end
	TriggerEvent('nxt_inventory:closeInventory')
	table.wipe(PlayerData.inventory)
	client.setPlayerData('weight', 0)
end)

RegisterNetEvent('nxt_inventory:createDrop', function(drop, data, owner, slot)
	if drops then
		drops[drop] = data
	end

	if owner == PlayerData.source and invOpen and #(GetEntityCoords(cache.ped) - data.coords) <= 1 then
		if currentWeapon?.slot == slot then currentWeapon = Utils.Disarm(currentWeapon) end

		if not cache.vehicle then
			openInventory('drop', drop)
		else
			SendNUIMessage({
				action = 'setupInventory',
				data = { rightInventory = currentInventory }
			})
		end
	end
end)

RegisterNetEvent('nxt_inventory:removeDrop', function(id)
	if closestMarker?[3] == id then table.wipe(closestMarker) end
	if drops then drops[id] = nil end
	nearbyMarkers['drop'..id] = nil
end)

local uiLoaded = false

local function setStateBagHandler(id)
	AddStateBagChangeHandler(nil, 'player:'..id, function(bagName, key, value, _, _)
		if key == 'invOpen' then
			invOpen = value
		elseif key == 'invBusy' then
			invBusy = value
			if value then
				lib.disableControls:Add(23, 25, 36, 263)
			else
				lib.disableControls:Remove(23, 25, 36, 263)
			end
		elseif key == 'instance' then
			currentInstance = value
		elseif key == 'dead' then
			PlayerData.dead = value
			Utils.WeaponWheel()
		elseif shared.police[key] then
			PlayerData.groups[key] = value
			OnPlayerData('groups')
		end
	end)

	setStateBagHandler = nil
end

lib.onCache('ped', function()
	Utils.WeaponWheel()
end)

lib.onCache('seat', function(seat)
	SetTimeout(0, function()
		if seat then
			if IS_GTAV then
				if DoesVehicleHaveWeapons(cache.vehicle) then
					Utils.WeaponWheel(true)

					-- todo: all weaponised vehicle data
					if cache.seat == -1 then
						if GetEntityModel(cache.vehicle) == `firetruk` then
							SetCurrentPedVehicleWeapon(cache.ped, 1422046295)
						end
					end

					return
				end
			end
		end

		Utils.WeaponWheel(false)
	end)
end)

RegisterNetEvent('nxt_inventory:setPlayerInventory', function(currentDrops, inventory, weight, esxItem, player, source)
	PlayerData = player
	PlayerData.id = cache.playerId
	PlayerData.source = source

	setmetatable(PlayerData, {
		__index = function(self, key)
			if key == 'ped' then
				return PlayerPedId()
			end
		end
	})

	if setStateBagHandler then setStateBagHandler(source) end

	for _, data in pairs(inventory) do
		Items[data.name].count += data.count
	end

	if IS_GTAV then
		if Items['phone']?.count < 1 and GetResourceState('npwd') == 'started' then
			exports.npwd:setPhoneDisabled(true)
		end
	end

	client.setPlayerData('inventory', inventory)
	client.setPlayerData('weight', weight)
	currentWeapon = nil
	drops = currentDrops
	Utils.ClearWeapons()

	local ItemData = table.create(0, #Items)

	for _, v in pairs(Items) do
		v.usable = (v.client and next(v.client) or v.effect or v.consume == 0 or esxItem[v.name] or v.weapon or v.component or v.ammo or v.tint) and true

		local buttons = {}
		if v.buttons then
			for id, button in pairs(v.buttons) do
				buttons[id] = button.label
			end
		end

		ItemData[v.name] = {
			label = v.label,
			usable = v.usable,
			stack = v.stack,
			close = v.close,
			description = v.description,
			image = v.image,
			buttons = buttons
		}
	end

	local locales = {}
	for k, v in pairs(shared.locale()) do
		if k:find('ui_') or k == '$' then
			locales[k] = v
		end
	end

	while not uiLoaded do Wait(50) end

	SendNUIMessage({
		action = 'init',
		data = {
			locale = locales,
			items = ItemData,
			leftInventory = {
				id = cache.playerId,
				slots = shared.playerslots,
				items = PlayerData.inventory,
				maxWeight = shared.playerweight,
			}
		}
	})

	PlayerData.loaded = true

	Shops()
	Inventory.Stashes()
	Inventory.Evidence()
	registerCommands()

	plyState:set('invBusy', false, false)
	plyState:set('invOpen', false, false)
	TriggerEvent('nxt_inventory:updateInventory', PlayerData.inventory)
	Utils.Notify({text = shared.locale('inventory_setup'), duration = 2500})
	Utils.WeaponWheel(false)

	local Licenses = data 'licenses'

	client.interval = SetInterval(function()
		local playerPed = cache.ped

		if invOpen == false then
			playerCoords = GetEntityCoords(playerPed)

			if closestMarker[1] then
				table.wipe(closestMarker)
			end

			local vehicle = cache.vehicle

			markers(drops, 'drop', vec3(150, 30, 30), nil, vehicle)

			if not shared.qtarget then
				if client.hasGroup(shared.police) then		
					markers(Inventory.Evidence, 'policeevidence', vec(30, 30, 150), nil, vehicle)
				end
				markers(Inventory.Stashes, 'stash', vec3(30, 30, 150), nil, vehicle)

				-- for k, v in pairs(Shops) do
				-- 	if not v.groups or client.hasGroup(v.groups) then
				-- 		markers(v.locations, 'shop', vec3(30, 150, 30), k, vehicle)
				-- 	end
				-- end
			end

			markers(Licenses, 'license', vec(30, 150, 30), nil, vehicle)

			if currentWeapon and IsPedUsingActionMode(cache.ped) then SetPedUsingActionMode(cache.ped, false, -1, 'DEFAULT_ACTION')	end

		elseif invOpen == true then
			if not canOpenInventory() then
				TriggerEvent('nxt_inventory:closeInventory')
			else
				playerCoords = GetEntityCoords(playerPed)
				if currentInventory then

					if currentInventory.type == 'otherplayer' then
						local id = GetPlayerFromServerId(currentInventory.id)
						local ped = GetPlayerPed(id)
						local pedCoords = GetEntityCoords(ped)

						if not id or #(playerCoords - pedCoords) > 1.8 or not (client.hasGroup(shared.police) or canOpenTarget(ped)) then
							TriggerEvent('nxt_inventory:closeInventory')
							Utils.Notify({type = 'error', text = shared.locale('inventory_lost_access'), duration = 2500})
						else
							TaskTurnPedToFaceCoord(playerPed, pedCoords.x, pedCoords.y, pedCoords.z, 50)
						end

					elseif currentInventory.coords and (#(playerCoords - currentInventory.coords) > 2 or canOpenTarget(playerPed)) then
						TriggerEvent('nxt_inventory:closeInventory')
						Utils.Notify({type = 'error', text = shared.locale('inventory_lost_access'), duration = 2500})
					end
				end
			end
		end

		if IS_GTAV then
			if currentWeapon then
				if GetSelectedPedWeapon(playerPed) ~= currentWeapon.hash then
					currentWeapon = Utils.Disarm(currentWeapon)
				end
			end
		end
		if client.parachute and GetPedParachuteState(playerPed) ~= -1 then
			Utils.DeleteObject(client.parachute)
			client.parachute = false
		end
	end, 200)

	local EnableKeys = client.enablekeys
	client.tick = SetInterval(function(disableControls)
		local playerId = cache.playerId
		if IS_GTAV then
			DisablePlayerVehicleRewards(playerId)
		end

		if invOpen then
			DisableAllControlActions(0)
			HideHudAndRadarThisFrame()

			for i = 1, #EnableKeys do
				EnableControlAction(0, EnableKeys[i], true)
			end

			if currentInventory.type == 'newdrop' then
				EnableControlAction(0, 30, true)
				EnableControlAction(0, 31, true)
			end
		else
			disableControls()
			if invBusy then DisablePlayerFiring(playerId, true) end

			for _, v in pairs(nearbyMarkers) do
				local coords, rgb = v[1], v[2]
				if IS_GTAV then
					DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, rgb.x, rgb.y, rgb.z, 222, false, false, false, true, false, false, false)
				elseif IS_RDR3 then
					local _, groundZ = GetGroundZAndNormalFor_3dCoord(coords.x, coords.y, coords.z)
					if #(GetEntityCoords(cache.ped) - coords) <= 2 then
						DrawText3D(vec3(coords.x, coords.y, coords.z-0.6), "Aperte I para interagir")
					end
					Citizen.InvokeNative(0x2A32FAA57B937173,0x07DCE236,coords.x, coords.y, groundZ+0.08, 0,0,0,0,0,0,0.15, 0.15,1.0, rgb.x, rgb.y, rgb.z, 150,0, 0, 2, 0, 0, 0, 0)
					-- Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, rgb.x, rgb.y, rgb.z, 222, false, false, false, true, false, false, false)
				end
			end

			-- if closestMarker and IsControlJustReleased(0, `INPUT_PICKUP_CARRIABLE`) then
			-- 	if closestMarker[3] == 'license' then
			-- 		lib.callback('nxt_inventory:buyLicense', 1000, function(success, message)
			-- 			if success == false then
			-- 				Utils.Notify({type = 'error', text = shared.locale(message), duration = 2500})
			-- 			else
			-- 				Utils.Notify({text = shared.locale(message), duration = 2500})
			-- 			end
			-- 		end, closestMarker[2])
			-- 	elseif closestMarker[3] == 'shop' then openInventory(closestMarker[3], {id=closestMarker[2], type=closestMarker[4]})
			-- 	elseif closestMarker[3] == 'policeevidence' then 
			-- 		openInventory(closestMarker[3])
			-- 	end
			-- end

			if currentWeapon then
				if IS_GTAV then
					DisableControlAction(0, 80, true)
					DisableControlAction(0, 140, true)
				end

				--[[
				-- Remover coronhada? mas buga o prompt de 'Matar'
				-- nos animais ao laçar eles.

				if IS_RDR3 then					
					DisableControlAction(0, `INPUT_MELEE_ATTACK`, true)
				end
				--]]

				if currentWeapon.metadata.durability <= 0 then
					DisablePlayerFiring(playerId, true)
				elseif client.aimedfiring and not IsPlayerFreeAiming(playerId) then
					DisablePlayerFiring(playerId, true)
				end

				local playerPed = cache.ped

				if not invBusy and currentWeapon.timer ~= 0 and currentWeapon.timer < GetGameTimer() then
					currentWeapon.timer = 0
					if currentWeapon.metadata.ammo then
						TriggerServerEvent('nxt_inventory:updateWeapon', 'ammo', currentWeapon.metadata.ammo)
					elseif currentWeapon.metadata.durability then
						TriggerServerEvent('nxt_inventory:updateWeapon', 'melee', currentWeapon.melee)
						currentWeapon.melee = 0
					end
				elseif currentWeapon.metadata.ammo or currentWeapon.throwable then

					if IsPedShooting(playerPed) then

						if currentWeapon.throwable then
							RemoveWeaponFromPed(playerPed, currentWeapon.hash)

							TriggerServerEvent('nxt_inventory:updateWeapon', 'throw')
							currentWeapon = nil
							TriggerEvent('nxt_inventory:currentWeapon')
						else
							local currentAmmo

							if currentWeapon.hash == `WEAPON_PETROLCAN` or currentWeapon.hash == `WEAPON_HAZARDCAN` or currentWeapon.hash == `WEAPON_FIREEXTINGUISHER` then
								currentAmmo = currentWeapon.metadata.ammo - 0.05

								if currentAmmo <= 0 then
									SetPedInfiniteAmmo(playerPed, false, currentWeapon.hash)
								end

							else
								currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
							end

							currentWeapon.metadata.ammo = (currentWeapon.metadata.ammo < currentAmmo) and 0 or currentAmmo

							local weaponObj = Citizen.InvokeNative(0x3B390A939AF0B5FC, playerPed, 0)
							
							Citizen.InvokeNative(0xA9EF4AD10BDDDB57, weaponObj, weaponDegradation, false) -- SetWeaponSoot
							Citizen.InvokeNative(0xE22060121602493B, weaponObj, weaponDegradation, false) -- SetWeaponDamage
							Citizen.InvokeNative(0xA7A57E89E965D839, weaponObj, weaponDegradation) -- SetWeaponDegradation

							if currentAmmo <= 0 then
								ClearPedTasks(playerPed)
								SetCurrentPedWeapon(playerPed, currentWeapon.hash, true)
								SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
								if currentWeapon?.ammo and shared.autoreload and not Interface.ProgressActive and not IsPedRagdoll(playerPed) and not IsPedFalling(playerPed) then
									currentWeapon.timer = 0
									local ammo = Inventory.Search(1, currentWeapon.ammo)						

									if ammo[1] then
										TriggerServerEvent('nxt_inventory:updateWeapon', 'ammo', currentWeapon.metadata.ammo)
										useSlot(ammo[1].slot)
									end
								else
									currentWeapon.timer = GetGameTimer() + 400
								end
							else
								currentWeapon.timer = GetGameTimer() + 400
							end
						end
					end
				elseif IsControlJustReleased(0, `INPUT_ATTACK`) then
					if IsPedPerformingMeleeAction(playerPed) then
						currentWeapon.melee += 1
						currentWeapon.timer = GetGameTimer() + 400
					end
				end
			end
		end
	end, 0, lib.disableControls)

	collectgarbage('collect')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if shared.resource == resourceName then
		if client.parachute then
			Utils.DeleteObject(client.parachute)
		end

		if invOpen then
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			if IS_GTAV then
				TriggerScreenblurFadeOut(0)
			end
		end
	end
end)

RegisterNetEvent('nxt_inventory:viewInventory', function(data)
	if data and invOpen == false then
		data.type = 'admin'
		plyState.invOpen = true
		currentInventory = data
		SendNUIMessage({
			action = 'setupInventory',
			data = {
				rightInventory = currentInventory,
			}
		})
		SetNuiFocus(true, true)
	end
end)

RegisterNUICallback('uiLoaded', function(_, cb)
	uiLoaded = true
	cb(1)
end)

RegisterNUICallback('removeComponent', function(data, cb)
	cb(1)
	if currentWeapon then
		if data.slot ~= currentWeapon.slot then return Utils.Notify({type = 'error', text = shared.locale('weapon_hand_wrong')}) end
		local itemSlot = PlayerData.inventory[currentWeapon.slot]
		for _, component in pairs(Items[data.component].client.component) do
			if HasPedGotWeaponComponent(cache.ped, currentWeapon.hash, component) then
				RemoveWeaponComponentFromPed(cache.ped, currentWeapon.hash, component)
				for k, v in pairs(itemSlot.metadata.components) do
					if v == data.component then
						table.remove(itemSlot.metadata.components, k)
						TriggerServerEvent('nxt_inventory:updateWeapon', 'component', k)
						break
					end
				end
			end
		end
	else
		TriggerServerEvent('nxt_inventory:updateWeapon', 'component', data)
	end
end)

RegisterNUICallback('inspectWeapon', function(data, cb)	
	TriggerEvent('nxt_inventory:closeInventory')

	if currentWeapon then
		exports.gunsmith:weaponInspectTask()
	else
		TriggerClientEvent("texas:notify:Simple", "Você precisa estar com essa arma em mãos", 3200)
	end
	
	cb(1)
end)

RegisterNUICallback('useItem', function(slot, cb)
	useSlot(slot)
	cb(1)
end)

RegisterNUICallback('giveItem', function(data, cb)
	local input = Interface.Keyboard(shared.locale('send_title_confirmation'), {shared.locale('amount_items_to_give')})

	if not input then
		TriggerEvent('texas:notify:Simple', "Insira um valor que deseja enviar", 3000)
		return
	else
		input = tonumber(input[1])
		data.count = input
	end

	cb(input)

	if cache.vehicle then
		local seats = GetVehicleMaxNumberOfPassengers(cache.vehicle) - 1

		if seats >= 0 then
			local passenger = GetPedInVehicleSeat(cache.seat - 2 * (cache.seat % 2) + 1)

			if passenger ~= 0 then
				passenger = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger))
				TriggerServerEvent('nxt_inventory:giveItem', data.slot, passenger, data.count)
				if data.slot == currentWeapon?.slot then currentWeapon = Utils.Disarm(currentWeapon) end
			end
		end
	else
		local target = Utils.Raycast(12)

		if target and IsPedAPlayer(target) and #(GetEntityCoords(cache.ped, true) - GetEntityCoords(target, true)) < 2.3 then
			target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(target))
			if IS_GTAV then
				Utils.PlayAnim(2000, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 50, 0.0, 0, 0, 0)
			end
			TriggerServerEvent('nxt_inventory:giveItem', data.slot, target, data.count)

			if data.slot == currentWeapon?.slot then
				currentWeapon = Utils.Disarm(currentWeapon)
			end
		end
	end
end)

RegisterNUICallback('useButton', function(data, cb)
	useButton(data.id, data.slot)
	cb(1)
end)

RegisterNUICallback('exit', function(_, cb)
	
	if not gCanPlayerCloseInventory then
		cb(0)
		return
	end

	TriggerEvent('nxt_inventory:closeInventory')
	cb(1)
end)

---Synchronise and validate all item movement between the NUI and server.
RegisterNUICallback('swapItems', function(data, cb)

	if data.toType == "newdrop" then
		local input = Interface.Keyboard(shared.locale('split_title_confirmation'), {shared.locale('amount_items_to_split')})

		if not input then
			TriggerEvent("texas:notify:Simple", "Digite a quantidade que deseja dropar", 3000)
			return
		else
			input = tonumber(input[1])
			data.count = input
		end
	end

	if data.toType == 'newdrop' and cache.vehicle then
        return cb(false)
    end

	if currentInstance then
		data.instance = currentInstance
	end

	StartInventoryAction('swap', data, function()
		local success, response, weapon = lib.callback.await('nxt_inventory:swapItems', false, data)

		if response then
			updateInventory(response.items, response.weight)
	
			if response.items and (response.items[data.toSlot] or response.items[data.fromSlot]) then
	
				local item = response?.items[(data?.toSlot or data?.fromSlot)]

				if item then
					swapWeaponHotbar(item, data)
				end
			end
		end
	
		-- if weapon then
		-- 	if currentWeapon then
		-- 		currentWeapon.slot = weapon
		-- 		TriggerEvent('nxt_inventory:currentWeapon', currentWeapon)
		-- 	end
		-- end
	
		if data.toType == 'newdrop' then
			Wait(50)
		end
	
		cb(success or false)
	end)
end)

function swapWeaponHotbar(item, data)
	if string.find(string.lower(item.name), "weapon") then
		if data.toType == "player" then
			
			if data.fromSlot > 0 and data.fromSlot < 6 then
				
				local playerPed = PlayerPedId()
				local weaponHash = GetHashKey(item.name)
				local ammoHash = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

				Citizen.InvokeNative(0xB6CFEC32E3742779, playerPed, ammoHash, weaponAmmo, GetHashKey('REMOVE_REASON_DROPPED'))  --_REMOVE_AMMO_FROM_PED_BY_TYPE

				RemoveWeaponFromPed(playerPed, weaponHash)
			end
			
			--[[
				useSlot esta dando merda se usar ele por aqui, tem que usar pelo servidor
			]]
			
			-- if data.toSlot > 0 and data.toSlot < 6 then
			-- 	useSlot(data.toSlot)
			-- end
		end
	end
end

RegisterNUICallback('buyItem', function(data, cb)
	local input = Interface.Keyboard(shared.locale('buy_title_confirmation'), {shared.locale('amount_items_to_buy')})

	if not input then
		TriggerEvent("texas:notify:Simple", "Digite a quantidade que deseja comprar", 3000)
		return
	else
		input = tonumber(input[1])
		data.count = input
	end

	local response, data, message = lib.callback.await('nxt_inventory:buyItem', 100, data)
	if data then
		PlayerData.inventory[data[1]] = data[2]
		client.setPlayerData('inventory', PlayerData.inventory)
		client.setPlayerData('weight', data[3])
		SendNUIMessage({ action = 'refreshSlots', data = {item = data[2]} })
	end
	if message then Utils.Notify(message) end
	cb(response)
end)

function DrawText3D(coords, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    
    if onScreen then

        local camCoords = GetGameplayCamCoord()
        local distance = #(coords - camCoords)
        local fov = (1 / GetGameplayCamFov()) * 75
        local scale = (1 / distance) * (4) * fov * (0.23)
        
        SetTextScale(0.32, scale)

        SetTextFontForCurrentCommand(2)

        SetTextColor(255, 255, 255, 215)
        local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())

        SetTextCentre(1)
        DisplayText(str, _x, _y)
        SetTextDropshadow(1, 255, 0, 0, 200)
    end
end

local recoils = {
	[`weapon_pistol_m1899`] = 0.2,
	[`weapon_pistol_mauser`] = 0.3,
	[`weapon_pistol_mauser_drunk`] = 0.2,
	[`weapon_pistol_semiauto`] = 0.3,
	[`weapon_pistol_volcanic`] = 0.4,

	[`weapon_revolver_cattleman`] = 0.2,
	[`weapon_revolver_cattleman_john`] = 0.25,
	[`weapon_revolver_cattleman_mexican`] = 0.24,
	[`weapon_revolver_cattleman_pig`] = 0.3,
	[`weapon_revolver_doubleaction`] = 0.4,
	[`weapon_revolver_doubleaction_exotic`] = 0.5,
	[`weapon_revolver_doubleaction_gambler`] = 0.2,
	[`weapon_revolver_doubleaction_micah`] = 0.3,
	[`weapon_revolver_lemat`] = 0.4,
	[`weapon_revolver_schofield`] = 0.5,
	[`weapon_revolver_schofield_golden`] = 0.5,
	[`weapon_revolver_schofield_calloway`] = 0.5,
	[`weapon_revolver_navy`] = 0.5,

	[`weapon_repeater_winchester`] = 0.6,
	[`weapon_repeater_carbine`] = 0.6,
	[`weapon_repeater_evans`] = 0.6,
	[`weapon_repeater_henry`] = 0.6,

	[`weapon_rifle_boltaction`] = 0.6,
	[`weapon_rifle_springfield`] = 0.6,
	[`weapon_rifle_varmint`] = 0.6,

	[`weapon_sniperrifle_carcano`] = 0.7,
	[`weapon_sniperrifle_rollingblock`] = 0.7,
	[`weapon_sniperrifle_rollingblock_exotic`] = 0.7,

	[`weapon_shotgun_doublebarrel`] = 0.6,
	[`weapon_shotgun_doublebarrel_exotic`] = 0.6,
	[`weapon_shotgun_pump`] = 0.65,
	[`weapon_shotgun_repeating`] = 0.65,
	[`weapon_shotgun_sawedoff`] = 0.65,
	[`weapon_shotgun_semiauto`] = 0.65
}


CreateThread(function()
	while true do

        local gPlayerPed = PlayerPedId()

		if IsPedShooting(gPlayerPed) and not IsPedInAnyVehicle(gPlayerPed) then

            local _, wep = GetCurrentPedWeapon(gPlayerPed, true, 0, true)
			_,cAmmo = GetAmmoInClip(gPlayerPed, wep)

			if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0

                local randomH = math.random(-5, 5) / 10
                local randomP = math.random(-10, 10) / 10
                
                local isFirstPerson = Citizen.InvokeNative(0xD1BA66940E94C547)
                if not isFirstPerson then
                    repeat
                        Wait(0)
                        p = GetGameplayCamRelativePitch()
                        
                        SetGameplayCamRelativePitch(p + 0.1 + randomP, 0.2)

                        h = GetGameplayCamRelativeHeading()
                        SetGameplayCamRelativeHeading(h + 0.1 + randomH, 0.2)
                        tv = tv+0.1
                    until tv >= recoils[wep]
                else    
                    repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
                        h = GetGameplayCamRelativeHeading()

						if recoils[wep] > 0.1 then
							SetGameplayCamRelativePitch(p + 0.6 + randomP, 1.2)                            
                            SetGameplayCamRelativeHeading(h + 0.6 + randomH, 1.2)
							tv = tv+0.6
						else
							SetGameplayCamRelativePitch(p + 0.016 + randomP, 0.333)
                            SetGameplayCamRelativeHeading(h + 0.016 + randomH, 0.333)
							tv = tv+0.1
						end

					until tv >= recoils[wep]

                end

			end

		end

		Wait(0)
	end
end)

local SADDLEBAG_POINTS =
{
    {
        boneName = 'SPR_L_Saddlebag',

        lootAnimationDict = 'mech_pickup@loot@horse_saddlebags@live@lt'
    },
    {
        boneName = 'SPR_R_Saddlebag',
        
        lootAnimationDict = 'mech_pickup@loot@horse_saddlebags@live@rt'
    }
}

function StartInventoryAction(actionType, data, cb)
	if IS_RDR3 and (data.fromType == 'glovebox' or data.toType == 'glovebox') then

		--[[ Só bloquear o inventário caso esteja removendo item do cavalo ]]
		local lockInventory = (data.fromType == 'glovebox' and data.toType == 'player')
							-- true

		if lockInventory then
			gCanPlayerCloseInventory = false
		else
			cb()
		end

		local playerPed = PlayerPedId()
		local horseEntity = currentInventory.entity

		local closestSaddlebagPoint         = nil
		local closestSaddlebagPointDistance = nil
		local closestSaddlebagPointPosition = nil

		local playerPos = GetEntityCoords(playerPed)

		for _, saddlebagPoint in ipairs(SADDLEBAG_POINTS) do

			local boneName in saddlebagPoint

			local boneIndex = GetEntityBoneIndexByName(horseEntity, boneName)

			local bonePos = GetWorldPositionOfEntityBone(horseEntity, boneIndex)
			-- local bonePos = GetPedBoneCoords(horseEntity, 50064)

			local distanceToPlayer = #(playerPos - bonePos)

			if not closestSaddlebagPoint or distanceToPlayer < closestSaddlebagPointDistance then
				closestSaddlebagPoint         = saddlebagPoint
				closestSaddlebagPointDistance = distanceToPlayer
				closestSaddlebagPointPosition = bonePos
			end
		end

		local DICT = closestSaddlebagPoint.lootAnimationDict
		local ANIM = 'base'

		RequestAnimDict(DICT)

		while not HasAnimDictLoaded(DICT) do
			Citizen.Wait(0)
		end

		ClearPedTasks(playerPed, true, false) --[[ Flags de acordo com script da rockstar ]]
		ClearPedTasks(horseEntity)

        ClearPedSecondaryTask(playerPed)

		local taskSequenceId = OpenSequenceTask()
		--[[ 0 ]] TaskFollowNavMeshToCoord(0, closestSaddlebagPointPosition, 1.0, 20000, 0.1, 0, 40000.0)
        --[[ 1 ]] TaskTurnPedToFaceCoord(0, closestSaddlebagPointPosition, 0)
        --[[ 2 ]] TaskPlayAnim(0, DICT, ANIM, 4.0, -4.0, -1, 4, 0.0, false, 0, false, 0, false)
		CloseSequenceTask(taskSequenceId)
		TaskPerformSequence(playerPed, taskSequenceId)
		ClearSequenceTask(taskSequenceId)

        CreateThread(function()
            local sequenceProgress

            local taskedHorse = false

            while sequenceProgress ~= -1 do
                Wait(0)

                sequenceProgress = GetSequenceProgress(playerPed)

                if sequenceProgress == 2 and not taskedHorse then
                    TaskPlayAnim(horseEntity, DICT, 'base_horse', 4.0, -4.0, -1, 65552, 0.0, false, 0, false, 0, false)

                    taskedHorse = true
                end
            end

			if lockInventory then
				if taskedHorse then
					-- Animação acabou e tudo ocorreu como esperado, então a gente executa a ação do inventário
					cb()
				end

				gCanPlayerCloseInventory = true
			end

			RemoveAnimDict(DICT)
        end)

        --[=[
        do -- DEBUG
            CreateThread(function()
                while true do
                    Wait(0)

                    for _, saddlebagPoint in ipairs(SADDLEBAG_POINTS) do

                        local boneName in saddlebagPoint

                        local boneIndex = GetEntityBoneIndexByName(horseEntity, boneName)

                        local bonePos = GetWorldPositionOfEntityBone(horseEntity, boneIndex)

                        Citizen.InvokeNative(`DRAW_LINE` & 0xFFFFFFFF, bonePos, bonePos + vec3(0.0, 0.0, 0.5), 255, 0, 0, 255)
                    end
                end
            end)
        end
        --]=]
		
		return
	end

	cb()
end	

local attachOriginal = true

AddEventHandler("Inventory:Weapon:ReplaceCurrentAttachPoint", function(itemSlot)
	
	local weapon = lib.callback.await('nxt_inventory:getItemBySlot', nil, itemSlot)
	
	local attachPoint = 0

	if attachOriginal then
		attachPoint = 12
	end

    Citizen.InvokeNative(0xADF692B254977C0C, PlayerPedId(), GetHashKey(weapon), true, attachPoint)

	attachOriginal = not attachOriginal
end)