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

-- Item('bandage', function(data, slot)
-- 	local maxHealth = GetEntityMaxHealth(cache.ped)
-- 	local health = GetEntityHealth(cache.ped)
-- 	nxt_inventory:useItem(data, function(data)
-- 		if data then
-- 			SetEntityHealth(cache.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
-- 			nxt_inventory:notify({text = 'You feel better already'})
-- 		end
-- 	end)
-- end)

Item('apito', function(data, slot)
    exports.nxt_inventory:useItem(data, function(data)
        if data then
            TriggerEvent("tx_apitopolice")
        end
    end)
end)

Item('badge_deputy', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then				
			TriggerEvent('police:client:applyBadgeInPlayer', 's_badgedeputy01x')
		end
	end)
end)
Item('badge_pinkerton', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then				
			TriggerEvent('police:client:applyBadgeInPlayer', 's_badgepinkerton01x')
		end
	end)
end)
Item('badge_sheriff', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then				
			TriggerEvent('police:client:applyBadgeInPlayer', 's_badgesherif01x')
		end
	end)
end)
Item('badge_marshal', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then				
			TriggerEvent('police:client:applyBadgeInPlayer', 's_badgeusmarshal01x')
		end
	end)
end)
Item('badge_police', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('police:client:applyBadgeInPlayer', 's_badgepolice01x')
		end
	end)
end)

Item('badge_officer', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('police:client:applyBadgeInPlayer', 's_badgedeputy01x')
		end
	end)
end)
Item('badge_texas_ranger', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('police:client:applyBadgeInPlayer', 's_badgepinkerton01x')
		end
	end)
end)

Item('dogfood', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then				
			TriggerEvent('ricx_dogs:checkdog')
		end
	end)
end)

local baits = {
    'p_baitbread01x',
    'p_baitcorn01x',
    'p_baitcheese01x',
    'p_baitworm01x',
    'p_baitcricket01x',
    'p_crawdad01x',
    'p_finishedragonfly01x',
    'p_finishdcrawd01x',
	'p_finisdfishlure01x',
    'p_finishedragonflylegendary01x',
    'p_finisdfishlurelegendary01x',
    'p_finishdcrawdlegendary01x',
    'p_lgoc_spinner_v4',
    'p_lgoc_spinner_v6'
}
Citizen.CreateThread(function()
    for i = 1, #baits do

        local bait = baits[i]


		Item(bait, function(data, slot)
			exports.nxt_inventory:useItem(data, function(data)
				if data then				
					TriggerEvent("FISHING:UseBait", bait)
				end
			end)
		end)
    end
end)


Item('peneira', function(data, slot)
	TriggerEvent('goldpanner:StartPaning')
end)

Item('balsamo', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("RESPAWN:Curandeiro:Balsamo", slot)
		end
	end)
end)

Item('cocainepaste', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("FRP:RESPAWN:CocainePasteUse")
			TriggerServerEvent('inventory:server:RemoveDurability', slot, 2)
		end
	end)
end)

Item('tonico', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("FRP:RESPAWN:Usetonico")

			TriggerServerEvent('inventory:server:RemoveDurability', slot, 7.5)
		end
	end)
end)

Item('tonicop', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("FRP:RESPAWN:UsetonicoP")

			TriggerServerEvent('inventory:server:RemoveDurability', slot, 7.5)
		end
	end)
end)

Item('roupaspreso', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("TexasRoupasPreso")
		end
	end)
end)

Item('handcuffs', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("police:client:CuffPlayerSoft")
		end
	end)
end)

Item('handcuffs_keys', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("police:client:CuffPlayerForceRemove")
		end
	end)
end)

-- Item('apito', function(data, slot)
-- 	exports.nxt_inventory:useItem(data, function(data)
-- 		if data then
-- 			TriggerEvent("ricx_dogs:pegarcachorro")
-- 		end
-- 	end)
-- end)

Item('escova', function(data, slot)
	TriggerEvent("HORSES:startbrush")
end)

Item('baldes', function(data, slot)
	TriggerEvent("lto_headbucket:Verification")
end)

Item('wheat', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("dar:trigo")
		end
	end)
end)

Item('corn', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent("dar:maiz")
		end
	end)
end)

Item('destilador', function(data, slot)
	TriggerEvent("drugs.moonshine:client:RequestSpawnItem")
end)

Item('xmastree', function(data, slot)
	TriggerEvent("xmas.client:RequestSpawnItem")
end)

Item('barril', function(data, slot)
	TriggerEvent("barril")
end)

Item('lockpick', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('tryLockpickingDoor', 50)
		end
	end)
end)
Item('lockpickr', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('tryLockpickingDoor', 100)
		end
	end)
end)

Item('idcard', function(data, slot)
    TriggerServerEvent("idcard:show",slot.metadata)
end)

Item('water', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'water')
		end
	end)
end)
Item('chadewayuizena', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'chadewayuizena')
		end
	end)
end)
Item('apple', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'apple')
		end
	end)
end)
Item('enlatadocarne', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'enlatadocarne')
		end
	end)
end)
Item('enlatadomilho', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'enlatadomilho')
		end
	end)
end)

Item('enlatadofeijoada', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'enlatadofeijoada')
		end
	end)
end)
Item('bolocenoura', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'bolocenoura')
		end
	end)
end)
Item('boloamora', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'boloamora')
		end
	end)
end)
Item('bread', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'bread')
		end
	end)
end)
Item('paesaveia', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'paesaveia')
		end
	end)
end)
Item('bolacha', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'bolacha')
		end
	end)
end)
Item('biscoito', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'biscoito')
		end
	end)
end)

Item('absinto', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'absinto')
		end
	end)
end)
Item('vodka', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'vodka')
		end
	end)
end)
Item('arake', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'arake')
		end
	end)
end)
Item('licorchocolate', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'licorchocolate')
		end
	end)
end)
Item('licorcobra', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'licorcobra')
		end
	end)
end)
Item('champagne', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'champagne')
		end
	end)
end)
Item('hidromel', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'hidromel')
		end
	end)
end)
Item('bberrypie', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'bberrypie')
		end
	end)
end)
Item('washingtoncake', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'washingtoncake')
		end
	end)
end)
Item('raspberryjuice', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'raspberryjuice')
		end
	end)
end)
Item('sidra', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'sidra')
		end
	end)
end)
Item('gin', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'gin')
		end
	end)
end)
Item('vinho', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'vinho')
		end
	end)
end)

Item('sucodeamora', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'sucodeamora')
		end
	end)
end)
Item('sucomaca', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'sucomaca')
		end
	end)
end)
Item('bolomilho', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'bolomilho')
		end
	end)
end)
Item('colacola', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'colacola')
		end
	end)
end)
Item('cantilcheio', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'cantilcheio')
		end
	end)
end)
Item('vitamina', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'vitamina')
		end
	end)
end)
Item('garrafadeleite', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'garrafadeleite')
		end
	end)
end)
Item('cerveja', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'cerveja')
		end
	end)
end)

Item('espumante', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'espumante')
		end
	end)
end)
Item('whisky', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'whisky')
		end
	end)
end)
Item('rum', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'rum')
		end
	end)
end)
Item('moonshine', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'moonshine')
		end
	end)
end)
Item('opio', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'opio')
		end
	end)
end)
Item('cigarette', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'cigarette')
		end
	end)
end)
Item('cigar', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'cigar')
		end
	end)
end)
Item('pipe', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'pipe')
		end
	end)
end)
Item('rape', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'rape')
		end
	end)
end)


Item('stringy_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'stringy_meat_roasted')
		end
	end)
end)
Item('flaky_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'flaky_meat_roasted')
		end
	end)
end)
Item('succulent_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'succulent_meat_roasted')
		end
	end)
end)
Item('gritty_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'gritty_meat_roasted')
		end
	end)
end)
Item('herptile_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'herptile_meat_roasted')
		end
	end)
end)
Item('plump_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'plump_meat_roasted')
		end
	end)
end)
Item('game_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'game_meat_roasted')
		end
	end)
end)
Item('gristly_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'gristly_meat_roasted')
		end
	end)
end)
Item('crustacean_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'crustacean_meat_roasted')
		end
	end)
end)
Item('prime_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'prime_meat_roasted')
		end
	end)
end)
Item('mature_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'mature_meat_roasted')
		end
	end)
end)
Item('tender_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'tender_meat_roasted')
		end
	end)
end)
Item('exotic_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'exotic_meat_roasted')
		end
	end)
end)
Item('big_meat_roasted', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'big_meat_roasted')
		end
	end)
end)

Item('stringy_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'stringy_meat_cooked')
		end
	end)
end)
Item('flaky_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'flaky_meat_cooked')
		end
	end)
end)
Item('succulent_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'succulent_meat_cooked')
		end
	end)
end)
Item('gritty_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'gritty_meat_cooked')
		end
	end)
end)
Item('herptile_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'herptile_meat_cooked')
		end
	end)
end)
Item('plump_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'plump_meat_cooked')
		end
	end)
end)
Item('game_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'game_meat_cooked')
		end
	end)
end)
Item('gristly_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'gristly_meat_cooked')
		end
	end)
end)
Item('crustacean_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'crustacean_meat_cooked')
		end
	end)
end)
Item('prime_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'prime_meat_cooked')
		end
	end)
end)
Item('mature_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'mature_meat_cooked')
		end
	end)
end)
Item('tender_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'tender_meat_cooked')
		end
	end)
end)
Item('exotic_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'exotic_meat_cooked')
		end
	end)
end)
Item('big_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'big_meat_cooked')
		end
	end)
end)
Item('big_meat_cooked', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent("HUD:Consumable:Item", 'big_meat_cooked')
		end
	end)
end)

Item('campfiremed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('CAMPFIRE:Client:SpawnCampfire', "p_campfire01x")
		end
	end)
end)
Item('campfiresmall', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('CAMPFIRE:Client:SpawnCampfire', "p_campfire03x")
		end
	end)
end)

Item('scratch_ticket', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent("scratching:isActiveCooldown")
		end
	end)
end)

Item('newspaper', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent("newspaper:openNewspaper")
		end
	end)
end)

Item('cantil', function(data, slot)
	TriggerEvent("cantil_encher")
end)

Item('bberryseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "bberryseed",`CRP_BERRY_SAP_AA_sim`, `CRP_BERRY_SAP_AA_sim`, `CRP_BERRY_SAP_AA_sim`)
		end
	end)
end)

Item('seedlingseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "bberryseed",`CRP_BERRY_SAP_AA_sim`, `CRP_BERRY_SAP_AA_sim`, `CRP_BERRY_SAP_AA_sim`)
		end
	end)
    TriggerEvent('poke_planting:planto1', 'seedlingseed',`crp_wheat_sap_long_aa_sim`, `crp_wheat_sap_long_aa_sim`, `crp_wheat_sap_long_aa_sim`)
end)

Item('tobaccoseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', 'tobaccoseed',`CRP_TOBACCOPLANT_AA_SIM`, `CRP_TOBACCOPLANT_AB_SIM`, `CRP_TOBACCOPLANT_AC_SIM`)
		end
	end)
end)

Item('tomatoseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "tomatoseed",`CRP_TOMATOES_AA_SIM`, `CRP_TOMATOES_AA_SIM`, `CRP_TOMATOES_AA_SIM`)
		end
	end)
end)

Item('btobaccoseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "btobaccoseed",`crp_tobaccoplant_Ba_sim`, `crp_tobaccoplant_Bb_sim`, `crp_tobaccoplant_Bc_sim`)
		end
	end)
end)

Item('wheatseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "wheatseed",`CRP_WHEAT_SAP_LONG_AB_SIM`, `CRP_WHEAT_SAP_LONG_AB_SIM`, `CRP_WHEAT_SAP_LONG_AB_SIM`)
		end
	end)
end)

Item('carrotseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "carrotseed",`crp_carrots_Aa_sim`, `crp_carrots_Aa_sim`, `crp_carrots_Aa_sim`)
		end
	end)
end)

Item('lettuceseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "lettuceseed",`CRP_LETTUCE_AA_SIM`, `CRP_LETTUCE_AA_SIM`, `CRP_LETTUCE_AA_SIM`)
		end
	end)
end)

Item('berryseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "berryseed",`CRP_BERRY_AA_SIM`, `CRP_BERRY_AA_SIM`, `CRP_BERRY_AA_SIM`)
		end
	end)
end)

Item('ginsengseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "ginsengseed",`s_inv_ginseng01x`, `s_inv_ginseng01x`, `s_inv_alaskanginseng01x`)
		end
	end)
end)

Item('artichokeseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "artichokeseed",`CRP_artichoke_Aa_sim`, `CRP_artichoke_Aa_sim`, `CRP_artichoke_Aa_sim`)
		end
	end)
end)

Item('cottonseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "cottonseed",`CRP_cotton_Bc_sim`, `CRP_cotton_Bb_sim`, `CRP_cotton_Ba_sim`)
		end
	end)
end)

Item('sugarcaneseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "sugarcaneseed",`CRP_SUGARCANE_AA_sim`, `CRP_SUGARCANE_AB_sim`, `CRP_SUGARCANE_AC_sim`)
		end
	end)
end)

Item('cornseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "cornseed",`CRP_CORNSTALKS_CB_sim`, `CRP_CORNSTALKS_CA_sim`, `CRP_CORNSTALKS_AB_sim`)
		end
	end)
end)

Item('broccoliseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "broccoliseed",`CRP_broccoli_Aa_sim`, `CRP_broccoli_Aa_sim`, `CRP_broccoli_Aa_sim`)
		end
	end)
end)

Item('potatoseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "potatoseed",`CRP_POTATO_AA_sim`, `CRP_POTATO_AA_sim`, `CRP_POTATO_AA_sim`)
		end
	end)
end)

Item('garlicseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "garlicseed",`crowsgarlic_p`, `crowsgarlic_p`, `crowsgarlic_p`)
		end
	end)
end)

Item('desertsageseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "desertsageseed",`desertsage_p`, `desertsage_p`, `desertsage_p`)
		end
	end)
end)

Item('engmaceseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "engmaceseed",`engmace_p`, `engmace_p`, `engmace_p`)
		end
	end)
end)

Item('feverfewseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "feverfewseed",`feverfew_p`, `feverfew_p`, `feverfew_p`)
		end
	end)
end)

Item('goldencurrantseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "goldencurrantseed",`goldencurrant_p`, `goldencurrant_p`, `goldencurrant_p`)
		end
	end)
end)

Item('humbirdsageseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "humbirdsageseed",`humbirdsage_p`, `humbirdsage_p`, `humbirdsage_p`)
		end
	end)
end)

Item('indtobaccoseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "indtobaccoseed",`indtobacco_p`, `indtobacco_p`, `indtobacco_p`)
		end
	end)
end)

Item('milkweedseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "milkweedseed",`milkweed_p`, `milkweed_p`, `milkweed_p`)
		end
	end)
end)

Item('bitterweedseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "bitterweedseed",`mp005_bitterweed_p`, `mp005_bitterweed_p`, `mp005_bitterweed_p`)
		end
	end)
end)

Item('bloodflowerseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "bloodflowerseed",`mp005_bloodflower_p`, `mp005_bloodflower_p`, `mp005_bloodflower_p`)
		end
	end)
end)

Item('cardinalflowerseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "cardinalflowerseed",`mp005_cardinalflw_p`, `mp005_cardinalflw_p`, `mp005_cardinalflw_p`)
		end
	end)
end)

Item('chocdaisyseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "chocdaisyseed",`mp005_chocdaisy_p`, `mp005_chocdaisy_p`, `mp005_chocdaisy_p`)
		end
	end)
end)

Item('wrhubarbseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "wrhubarbseed",`mp005_rhubarb_p`, `mp005_rhubarb_p`, `mp005_rhubarb_p`)
		end
	end)
end)

Item('agaritaseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "agaritaseed",`mp005_s_inv_agarita_01x`, `mp005_s_inv_agarita_01x`, `mp005_s_inv_agarita_01x`)
		end
	end)
end)

Item('wisteriaseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "wisteriaseed",`mp005_s_inv_wisteria01x`, `mp005_s_inv_wisteria01x`, `mp005_s_inv_wisteria01x`)
		end
	end)
end)

Item('texasbonseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "texasbonseed",`mp005_texasbon_p`, `mp005_texasbon_p`, `mp005_texasbon_p`)
		end
	end)
end)

Item('oreganoseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "oreganoseed",`oregano_p`, `oregano_p`, `oregano_p`)
		end
	end)
end)

Item('orleanderseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "orleanderseed",`orleander_p`, `orleander_p`, `orleander_p`)
		end
	end)
end)

Item('prariepoppyseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "prariepoppyseed",`prariepoppy_p`, `prariepoppy_p`, `prariepoppy_p`)
		end
	end)
end)

Item('redsageseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "redsageseed",`redsage_p`, `redsage_p`, `redsage_p`)
		end
	end)
end)

Item('thymeseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "thymeseed",`thyme_p`, `thyme_p`, `thyme_p`)
		end
	end)
end)

Item('viosnwdrpseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "viosnwdrpseed",`viosnwdrp_p`, `viosnwdrp_p`, `viosnwdrp_p`)
		end
	end)
end)

Item('wildmintseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "wildmintseed",`wildmint_p`, `wildmint_p`, `wildmint_p`)
		end
	end)
end)

Item('yarrowseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "yarrowseed",`yarrow01_p`, `yarrow01_p`, `yarrow01_p`)
		end
	end)
end)

Item('alaskanginseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "alaskanginseed",`s_inv_alaskanginseng01x`, `s_inv_alaskanginseng01x`, `s_inv_alaskanginseng01x`)
		end
	end)
end)

Item('blackcurrantseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "blackcurrantseed",`blackcurrant_p`, `blackcurrant_p`, `blackcurrant_p`)
		end
	end)
end)

Item('bulrushseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "bulrushseed",`bulrush_p`, `bulrush_p`, `bulrush_p`)
		end
	end)
end)

Item('burdockseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "burdockseed",`burdock_p`, `burdock_p`, `burdock_p`)
		end
	end)
end)

Item('huckleberryseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "huckleberryseed",`s_inv_huckleberry01x`, `s_inv_huckleberry01x`, `s_inv_huckleberry01x`)
		end
	end)
end)

Item('wintergreenseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "wintergreenseed",`s_inv_wintergreen01x`, `s_inv_wintergreen01x`, `s_inv_wintergreen01x`)
		end
	end)
end)

Item('agaveseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "agaveseed",`rdr_bush_agave_ab_sim`, `rdr_bush_agave_ab_sim`, `rdr_bush_agave_aa_sim`)
		end
	end)
end)

Item('aloeseed', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:planto1', "aloeseed",`rdr_bush_aloe_aa_sim`, `rdr_bush_aloe_aa_sim`, `rdr_bush_aloe_aa_sim`)
		end
	end)
end)

Item('wateringcan', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('poke_planting:regar1')
		end
	end)
end)

Item('relogio', function(data, slot)	
    local playerPed = PlayerPedId()
    local coords =  GetEntityCoords(playerPed)

    local hash = GetHashKey('s_inv_pocketWatch01x')
    
    if not HasModelLoaded(hash) then
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			Citizen.Wait(10)
		end
	end

    local object = CreateObject(hash, coords.x+0.5, coords.y+0.5, coords.z, true, false, false, false, true)
	TaskItemInteraction_2(playerPed, GetHashKey("POCKETWATCH@D6-5_H1-5_InspectZ	"), object, GetHashKey("PrimaryItem"), GetHashKey("POCKET_WATCH_INSPECT_UNHOLSTER"), 1, 0, -1) -- this native requires an object    
end)

Item('robbery_dynamite', function(data, slot)
	exports.nxt_inventory:useItem(data, function(data)
		if data then    
			TriggerEvent('BANK:initGameplayToTryOpenDoors')
		end
	end)
end)


Item("joint", function(data, slot)
	local sort = math.random(1,100)

	if sort >= 95 then
		TriggerServerEvent('weed:interaction:giveSeed', 'femaleseed')
	elseif sort <= 5 then
		TriggerServerEvent('weed:interaction:giveSeed', 'maleseed')
	end

	nxt_inventory:useItem(data, function(data)
		TriggerServerEvent("HUD:Consumable:Item", 'joint')
    end)
end)

Item("femaleseed", function(data, slot)
    TriggerEvent('plantation:tryPlantWeed', slot.name)
end)


Item("rolling_paper", function(data, slot)
    TriggerServerEvent("weed:interaction:tryCombineItem", 'rolling_paper')
end)

Item("empty_weed_bag", function(data, slot)
    TriggerServerEvent("weed:interaction:tryCombineItem", 'empty_weed_bag')
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
