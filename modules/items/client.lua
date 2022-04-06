local Items = shared.items

local function GetItem(item)
	if item then
		item = string.lower(item)
		if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end
		return Items[item]
	end
	return Items
end

local function Item(name, cb)
	local item = Items[name]
	if item then
		if not item.client?.export and not item.client?.event then
			item.effect = cb
		end
	end
end

local ox_inventory = exports[shared.resource]
-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------

Item('bandage', function(data, slot)
	local maxHealth = GetEntityMaxHealth(cache.ped)
	local health = GetEntityHealth(cache.ped)
	nxt_inventory:useItem(data, function(data)
		if data then
			SetEntityHealth(cache.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
			nxt_inventory:notify({text = 'You feel better already'})
		end
	end)
end)

Item('badge_deputy', function(data, slot)
	TriggerEvent('police:client:applyBadgeInPlayer', 's_badgedeputy01x')
end)
Item('badge_pinkerton', function(data, slot)
	TriggerEvent('police:client:applyBadgeInPlayer', 's_badgepinkerton01x')
end)
Item('badge_sheriff', function(data, slot)
	TriggerEvent('police:client:applyBadgeInPlayer', 's_badgesherif01x')
end)
Item('badge_marshal', function(data, slot)
	TriggerEvent('police:client:applyBadgeInPlayer', 's_badgeusmarshal01x')
end)
Item('badge_police', function(data, slot)
	TriggerEvent('police:client:applyBadgeInPlayer', 's_badgepolice01x')
end)


-- Item('armour', function(data, slot)
-- 	if GetPedArmour(cache.ped) < 100 then
-- 		nxt_inventory:useItem(data, function(data)
-- 			if data then
-- 				SetPlayerMaxArmour(PlayerData.id, 100)
-- 				SetPedArmour(cache.ped, 100)
-- 			end
-- 		end)
-- 	end
-- end)

-- client.parachute = false
-- Item('parachute', function(data, slot)
-- 	if not client.parachute then
-- 		nxt_inventory:useItem(data, function(data)
-- 			if data then
-- 				local chute = `GADGET_PARACHUTE`
-- 				SetPlayerParachuteTintIndex(PlayerData.id, -1)
-- 				GiveWeaponToPed(cache.ped, chute, 0, true, false)
-- 				SetPedGadget(cache.ped, chute, true)
-- 				lib.requestModel(1269906701)
-- 				client.parachute = CreateParachuteBagObject(cache.ped, true, true)
-- 				if slot.metadata.type then
-- 					SetPlayerParachuteTintIndex(PlayerData.id, slot.metadata.type)
-- 				end
-- 			end
-- 		end)
-- 	end
-- end)

-- Item('phone', function(data, slot)
-- 	exports.npwd:setPhoneVisible(not exports.npwd:isPhoneVisible())
-- end)

-----------------------------------------------------------------------------------------------

exports('Items', GetItem)
exports('ItemList', GetItem)
client.items = Items
