local Blips = {}

if IS_RDR3 then
	function CreateLocationBlip(blipId, name, blip, location, color)
		Blips[blipId] = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, location.x, location.y, location.z)

		SetBlipSprite(Blips[blipId], blip, 1)
		SetBlipScale(Blips[blipId],0.2)
		
		if color then
			Citizen.InvokeNative(0x662D364ABF16DE2F, Blips[blipId], GetHashKey(color))
		else 
			Citizen.InvokeNative(0x662D364ABF16DE2F, Blips[blipId], `BLIP_MODIFIER_MP_COLOR_32`)
		end
		
		local varString = CreateVarString(10, 'LITERAL_STRING', name)
		Citizen.InvokeNative(0x9CB1A1623062F402, Blips[blipId], varString)
	end
end

local function OpenShop(data)
	exports.ox_inventory:openInventory('shop', data)
end

client.shops = setmetatable(data('shops'), {
	__call = function(self)
		if next(Blips) then
			for i = 1, #Blips do 
				if Blips[i] then
					RemoveBlip(Blips[i]) 					
				end
			end
			table.wipe(Blips)
		end

		local blipId = 0
		for type, shop in pairs(self) do
			if shop.jobs then shop.groups = shop.jobs end

			if not shop.groups or client.hasGroup(shop.groups) then
				if shop.blip then blipId += 1 end
				if shared.qtarget then
					if shop.model then
						exports.qtarget:AddTargetModel(shop.model, {
							options = {
								{
									icon = 'fas fa-shopping-basket',
									label = shop.label or shared.locale('open_shop', shop.name),
									action = function()
										exports.ox_inventory:openInventory('shop', {type=type})
									end
								},
							},
							distance = 2
						})
					elseif shop.targets then
						for id=1, #shop.targets do
							local target = shop.targets[id]
							local shopid = type..'-'..id
							exports.qtarget:RemoveZone(shopid)
							if shop.blip then CreateLocationBlip(blipId, shop.name, shop.blip, target.loc, shop.color or nil) end
							exports.qtarget:AddBoxZone(shopid, target.loc, target.length or 0.5, target.width or 0.5, {
								name = shopid,
								heading = target.heading or 0.0,
								debugPoly = false,
								minZ = target.minZ,
								maxZ = target.maxZ
							}, {
								options = {
									{
										icon = 'fas fa-shopping-basket',
										label = shop.label or shared.locale('open_shop', shop.name),
										job = shop.groups,
										action = function()
											OpenShop({id=id, type=type})
										end
									},
								},
								distance = target.distance or 3.0
							})
						end
					end
				elseif shop.blip then
					for i = 1, #shop.locations do
						blipId += 1
						CreateLocationBlip(blipId, shop.name, shop.blip, shop.locations[i], shop.color or nil)
					end
				end
			end
		end
	end
})
