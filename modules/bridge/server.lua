function server.hasGroup(inv, group)
	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = inv.player.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = inv.player.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

function server.setPlayerData(player)
	if not player.groups then
		shared.warning(("server.setPlayerData did not receive any groups for '%s'"):format(player?.name or GetPlayerName(player)))
	end

	return {
		source = player.source,
		name = player.name,
		groups = player.groups or {},
		sex = player.sex,
		dateofbirth = player.dateofbirth,
	}
end

if shared.framework == 'esx' then
	local ESX = exports['es_extended']:getSharedObject()

	if ESX.CreatePickup then
		error('Ox Inventory requires a modified version of ESX, refer to the documentation.')
	end

	ESX = {
		GetUsableItems = ESX.GetUsableItems,
		GetPlayerFromId = ESX.GetPlayerFromId,
		UseItem = ESX.UseItem
	}

	server.UseItem = ESX.UseItem
	server.UsableItemsCallbacks = ESX.GetUsableItems
	server.GetPlayerFromId = ESX.GetPlayerFromId

	-- Accounts that need to be synced with physical items
	server.accounts = {
		money = 0,
		black_money = 0,
	}

	function server.setPlayerData(player)
		local groups = {
			[player.job.name] = player.job.grade
		}

		return {
			source = player.source,
			name = player.name,
			groups = groups,
			sex = player.sex or player.variables.sex,
			dateofbirth = player.dateofbirth or player.variables.dateofbirth,
		}
	end

	RegisterServerEvent('nxt_inventory:requestPlayerInventory', function()
		local source = source
		local player = server.GetPlayerFromId(source)

		if player then
			setPlayerInventory(player, player?.inventory)
		end
	end)
end

if shared.framework == 'redemrp' then
	UsableItemsCallbacks = {}

	-- function RegisterUsableItem(item, cb)
	-- 	UsableItemsCallbacks[item] = cb
	-- end
	
	-- function UseItem(source, item, data)
	-- 	UsableItemsCallbacks[item](source, item, data)
	-- end
	
	-- function GetItemLabel(item)	
	-- 	item = exports.nxt_inventory:Items(item)
	-- 	if item then return item.label end
	-- end
	
	-- function GetUsableItems()
	-- 	local Usables = {}
	-- 	for k in pairs(UsableItemsCallbacks) do
	-- 		Usables[k] = true
	-- 	end
	-- 	return Usables
	-- end

	-- server.UseItem = UseItem
	-- server.UsableItemsCallbacks = GetUsableItems

	server.GetPlayerFromId = function(...)		
		return exports['redemrp_roleplay']:getPlayerFromId(...)
	end

	
	-- Accounts that need to be synced with physical items
	server.accounts = {
		money = 0,
		gold = 0,
	}

	function server.setPlayerData(player)
		if not player.job then			
			player.job = {}
			player.job.name = player.getJobName()
			player.job.grade = player.getJobGrade().level
		end

		local groups = {
			[player.job.name] = player.job.grade
		}
		return {
			name = player.name,
			groups = groups,
			-- sex = player.sex or player.variables.sex,
			-- dateofbirth = player.dateofbirth or player.variables.dateofbirth,
		}
	end

	RegisterServerEvent('nxt_inventory:requestPlayerInventory', function()
		local source = source
		local player = server.GetPlayerFromId(source)

		server.accounts.money = player.getMoney()
		server.accounts.gold = player.getGold()

		print('money', server.accounts.money)
		print('gold', server.accounts.gold)
		
		Inventory.SetItem(source, 'money', server.accounts.money, nil)

		if player then
			setPlayerInventory(player, player?.inventory)
		end
	end)
end

--[[ Inicializar o 'Inventory Player' dos players que já estavam online enquanto o script foi reiniciado ]]
--[[ Só server para debug, porque não verifica se o user tem um character ativo. ]]
CreateThread(function()
	Wait(2000)

	for _, playerId in ipairs(GetPlayers()) do

		local user = server.GetPlayerFromId(tonumber(playerId))

		if user then

			local playerData =
			{
				userId = user.getId(),

				characterId = user.getCharacterId(),
				name = user.getFirstname() .. ' ' .. user.getLastname(),

				job = user.getJob(),
				
				group = user.getGroup(),
				accounts = {}
			}

			playerData.accounts.money = user.getMoney()
			playerData.accounts.gold = user.getGold()

			TriggerClientEvent("net.setCharacterData", playerId, playerData)
		end
	end
end)
