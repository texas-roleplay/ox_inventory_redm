function client.setPlayerData(key, value)
	PlayerData[key] = value
	OnPlayerData(key, value)
end

function client.hasGroup(group)
	if PlayerData.loaded then
		if type(group) == 'table' then
			for name, rank in pairs(group) do
				local groupRank = PlayerData.groups[name]
				if groupRank and groupRank >= (rank or 0) then
					return name, groupRank
				end
			end
		else
			local groupRank = PlayerData.groups[group]
			if groupRank then
				return group, groupRank
			end
		end
	end
end

local Utils = client.utils

local function onLogout()
	if PlayerData.loaded then
		if client.parachute then
			Utils.DeleteObject(client.parachute)
			client.parachute = false
		end

		TriggerEvent('nxt_inventory:closeInventory')
		PlayerData.loaded = false
		ClearInterval(client.interval)
		ClearInterval(client.tick)
		currentWeapon = Utils.Disarm(currentWeapon)
	end
end

if shared.framework == 'ox' then

	RegisterNetEvent('ox:playerLogout', onLogout)

elseif shared.framework == 'esx' then

	local ESX = exports.es_extended:getSharedObject()

	ESX = {
		SetPlayerData = ESX.SetPlayerData,
		PlayerLoaded = ESX.PlayerLoaded
	}

	function client.setPlayerData(key, value)
		PlayerData[key] = value
		ESX.SetPlayerData(key, value)
	end

	RegisterNetEvent('esx:onPlayerLogout', onLogout)

	AddEventHandler('esx:setPlayerData', function(key, value)
		if PlayerData.loaded and GetInvokingResource() == 'es_extended' then
			if key == 'job' then
				key = 'groups'
				value = { [value.name] = value.grade }
			end

			PlayerData[key] = value
			OnPlayerData(key, value)
		end
	end)

	RegisterNetEvent('esx_policejob:handcuff', function()
		PlayerData.cuffed = not PlayerData.cuffed
		LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)
		if PlayerData.cuffed then
			currentWeapon = Utils.Disarm(currentWeapon)
		end
	end)

	RegisterNetEvent('esx_policejob:unrestrain', function()
		PlayerData.cuffed = false
		LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)
	end)

	if ESX.PlayerLoaded then
		TriggerServerEvent('nxt_inventory:requestPlayerInventory')
	end

elseif shared.framework == 'redemrp' then

	function client.setPlayerData(key, value)
		PlayerData[key] = value
		TriggerServerEvent("redemrp:SetPlayerData", key, value)
	end
	
	RegisterNetEvent('net.setCharacterData', function(data)		
		if PlayerData.loaded then
			for key, data in pairs(data) do

				if key == 'job' then
					key = 'groups'
					value = { [data.name] = data.grade.level }
				end

				PlayerData[key] = value
				OnPlayerData(key, value)
			end
		end
	end)

	RegisterNetEvent('JOB:Client:OnJobUpdate', function(data)		
		if PlayerData.loaded then
			local value = { [data.name] = data.grade.level }		
			PlayerData['job'] = value
			OnPlayerData('groups', value)
		end
	end)
	
	AddEventHandler('client.playerHasLoaded', function()
		PlayerData.loaded = true
	end)

	RegisterNetEvent('esx_policejob:handcuff', function()
		PlayerData.cuffed = not PlayerData.cuffed
		LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)
		if PlayerData.cuffed then
			currentWeapon = Utils.Disarm(currentWeapon)
		end
	end)

	RegisterNetEvent('esx_policejob:unrestrain', function()
		PlayerData.cuffed = false
		LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)
	end)

	Citizen.CreateThread(function()
		while not PlayerData.loaded do
			Citizen.Wait(0)
		end

		if PlayerData.loaded then
			TriggerServerEvent('nxt_inventory:requestPlayerInventory')
		end
	end)
end
