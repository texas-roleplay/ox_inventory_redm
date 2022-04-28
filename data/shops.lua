return {
	General = {
		name = 'Shop',
		prompt = true,
		blip = {
			id = 59, colour = 69, scale = 0.8
		}, inventory = {
			{name = "corn", price = 0.15},
			{name = "cantil", price = 1.25},
			{name = "nozcoca", price = 0.11},
			{name = "dogfood", price = 5.00},
			{name = "tigela", price = 0.05},
			{name = "compass", price = 0.50},
			{name = "apple", price = 0.10},
			{name = "notepad", price = 0.15},
			{name = "enlatadocarne", price = 0.15},
			{name = "enlatadomilho", price = 0.10},
			{name = "enlatadofeijoada", price = 0.15},
			{name = "water", price = 0.10},
			{name = "hay", price = 0.10},
			{name = "escova", price = 0.35},
			{name = "pombocorreio", price = 0.25},
			{name = "machado", price = 1}, 
			{name = "peneira", price = 1}, 			
			{name = "picareta", price = 1.50},
			{name = "wateringcan", price = 2.50},
			{name = "garrafavazia", price = 0.01},
			{name = "sacovazio", price = 0.05},
			{name = "campfiremed", price = 6.0},
			{name = "campfiresmall", price = 4.0},
			{name = "apito", price =  5.0},			
			
			{name = "pote", price =  0.01},
			{name = "potesal", price =  0.05},
			{name = "potefermento", price =  0.10},
			{name = "potefarinha", price =  0.10},
			{name = "poteacucar", price =  0.10},
			{name = "butter", price =  0.15},
			{name = "ovo", price =  0.05},
			{name = "xaropechocolate", price =  0.30},
			{name = "essbaun", price =  0.30},
			{name = "whipcream", price =  0.30},
		}, locations = {
			vec3(2825.75, -1318.34, 46.76),
			vec3( 1328.48, -1292.83, 77.02),
			vec3(-322.22, 803.26, 117.85),
			vec3(-785.20, -1323.84, 43.89),
			vec3(-3685.508, -2623.638, -13.431),
			vec3(-5487.755, -2938.284, -0.388),
			vec3(-1791.316, -387.160, 160.334)
		}, targets = {
			-- { loc = vec3(25.06, -1347.32, 29.5), length = 0.7, width = 0.5, heading = 0.0, minZ = 29.5, maxZ = 29.9, distance = 1.5 },
		}
	},

	Saloon = {
		name = 'Saloon',
		prompt = true,
		groups = {
			['saloon'] = 0,
			['sallon'] = 0,
			['saloonarmadillo'] = 0,
			['saloonblackwater'] = 0,
			['saloonrhodes'] = 0,
		},	
		blip = {
			id = 93, colour = 69, scale = 0.8
		}, inventory = {

			{name = "cerveja", price = 0.15},
			{name = "whisky", price = 0.20},
			{name = "rum", price = 0.25},
			{name = "ticket", price = 0.15},
			{name = "scratch_ticket", price = 1.50},

		}, locations = {
			vec3(-1303.076, 395.0508, 95.12),
		}, targets = {
			-- { loc = vec3(1134.9, -982.34, 46.41), length = 0.5, width = 0.5, heading = 96.0, minZ = 46.4, maxZ = 46.8, distance = 1.5 },
		}
	},
	

	Pexeiro = {
		name = 'Estação',
		prompt = true,
		blip = {
			id = 402, colour = 69, scale = 0.8
		}, inventory = {
			{name = "WEAPON_FISHINGROD", price = 0.5},
			{name = "p_baitBread01x", price = 0.02},
			{name = "p_baitCorn01x", price = 0.02},
			{name = "p_baitCheese01x", price = 0.02},
			{name = "p_baitWorm01x", price = 0.02},
			{name = "p_baitCricket01x", price = 0.02},			
			{name = "p_crawdad01x", price = 0.02},
			{name = "p_FinisdFishlure01x", price = 0.05},
			{name = "p_finishdcrawd01x", price = 0.05},
			{name = "p_finishedragonflylegendary01x", price = 2},
			{name = "p_finisdfishlurelegendary01x", price = 0.12},						
			{name = "p_finishdcrawdlegendary01x", price = 0.12},			
			{name = "p_lgoc_spinner_v4", price = 0.12},
			{name = "p_lgoc_spinner_v6", price = 0.12},
		}, locations = {
			vec3(2662.841, -1505.69, 45.978),  -- saint denis
			vec3(-757.3929, -1360.937, 43.737)  -- black water
		}, targets = {
			-- { loc = vec3(2746.8, 3473.13, 55.67), length = 0.6, width = 3.0, heading = 65.0, minZ = 55.0, maxZ = 56.8, distance = 3.0 }
		}
	},

	Ammunation = {
		name = 'Ammunation',
		prompt = true,
		blip = {
			id = 110, colour = 69, scale = 0.8
		}, inventory = {
			{name = "weapon_melee_lantern", price = 3},
            {name = "weapon_melee_davy_lantern", price = 3},

            {name = "WEAPON_KIT_BINOCULARS", price = 5},			
            {name = "WEAPON_LASSO", price = 4},
            {name = "WEAPON_MELEE_KNIFE", price = 5},
            {name = "WEAPON_BOW", price = 25},
            {name = "WEAPON_REVOLVER_DOUBLEACTION", price = 30},
            {name = "WEAPON_REVOLVER_DOUBLEACTION_GAMBLER", price = 33},
            {name = "WEAPON_REVOLVER_CATTLEMAN", price = 17},
            {name = "WEAPON_REVOLVER_CATTLEMAN_MEXICAN", price = 28},

            {name = "WEAPON_REVOLVER_NAVY", price = 35},
            {name = "WEAPON_PISTOL_MAUSER", price = 100},
            {name = "WEAPON_RIFLE_VARMINT", price = 20},
            {name = "WEAPON_REPEATER_CARBINE", price = 40},	

            {name = "ammo_22", price = 0.03},
            {name = "ammo_revolver", price = 0.04},
            {name = "ammo_pistol", price = 0.05},
            {name = "ammo_rifle", price = 0.06},
            {name = "ammo_repeater", price = 0.04},
            {name = "ammo_arrow", price = 0.13},

			-- { name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' }
		}, locations = {
			vec3(2715.9, -1285.04, 49.63), -- Saint Denis
			vec3(1323.09, -1321.63, 77.8), -- Rhodes
			vec3(2946.47, 1319.74, 44.88), -- Annesburg
			vec3(-281.26, 780.72, 119.49), -- Valentine
			vec3(-5508.22, -2964.26, -0.62), -- Tumb
		}, targets = {
			-- { loc = vec3(-660.92, -934.10, 21.94), length = 0.6, width = 0.5, heading = 180.0, minZ = 21.8, maxZ = 22.2, distance = 2.0 },
		}
	},


	Jornaleiro = {
		name = 'Jornaleiro',
		prompt = true,
		blip = {
			id = 93, colour = 69, scale = 0.8
		}, inventory = {
			{name = "newspaper", price = 0.10},
		}, locations = {
			vec3(2699.525, -1381.241, 46.859),
		}, targets = {
			-- { loc = vec3(1134.9, -982.34, 46.41), length = 0.5, width = 0.5, heading = 96.0, minZ = 46.4, maxZ = 46.8, distance = 1.5 },
		}
	},


	MercadoClandestino = {
		name = 'Mercado Clandestino',
		prompt = true,
		blip = {
			id = 93, colour = 69, scale = 0.8
		}, inventory = {
			{name = "alcool", price = 0.15},
			{name = "lockpick", price = 1},
			{name = "lockpickr", price = 2},
			{name = "baldes", price = 0.50},

			{ name = 'handcuffs', price = 2 },
			{ name = 'handcuffs_keys', price = 1 },
		}, locations = {
			vec3(2859.706,-1200.646,49.590), -- saint dennis
			vec3(496.5856, 672.968, 121.0131)
		}, targets = {
			-- { loc = vec3(1134.9, -982.34, 46.41), length = 0.5, width = 0.5, heading = 96.0, minZ = 46.4, maxZ = 46.8, distance = 1.5 },
		}
	},

		
	Fazenda = {
		name = 'Fazenda',
		prompt = true,
		blip = {
			id = 93, colour = 69, scale = 0.8
		}, inventory = {
			{name = "aloeseed", price = 0.05},
			{name = "agaveseed", price = 0.05},
			{name = "wintergreenseed", price = 0.05},
			{name = "huckleberryseed", price = 0.05},
			{name = "burdockseed", price = 0.05},
			{name = "bulrushseed", price = 0.05},
			{name = "alaskanginseed", price = 0.05},
			{name = "yarrowseed", price = 0.05},
			{name = "viosnwdrpseed", price = 0.05},
			{name = "thymeseed", price = 0.05},
			{name = "redsageseed", price = 0.05},
			{name = "prariepoppyseed", price = 0.05},
			{name = "orleanderseed", price = 0.05},
			{name = "oreganoseed", price = 0.05},
			{name = "texasbonseed", price = 0.05},
			{name = "agaritaseed", price = 0.05},
			{name = "wrhubarbseed", price = 0.05},
			{name = "agaritaseed", price = 0.05},
			{name = "wrhubarbseed", price = 0.05},
			{name = "chocdaisyseed", price = 0.05},
			{name = "cardinalflowerseed", price = 0.05},
			{name = "bloodflowerseed", price = 0.05},
			{name = "bitterweedseed", price = 0.05},
			{name = "milkweedseed", price = 0.05},
			{name = "indtobaccoseed", price = 0.05},
			{name = "humbirdsageseed", price = 0.05},
			{name = "goldencurrantseed", price = 0.05},
			{name = "feverfewseed", price = 0.05},
			{name = "engmaceseed", price = 0.05},
			{name = "desertsageseed", price = 0.05},
			{name = "garlicseed", price = 0.05},
			{name = "tobaccoseed", price = 0.05},			
			{name = "potatoseed", price = 0.05},
			{name = "btobaccoseed", price = 0.05},
			{name = "wheatseed", price = 0.05},
			{name = "carrotseed", price = 0.05},
			{name = "lettuceseed", price = 0.05},
			{name = "ginsengseed", price = 0.05},
			{name = "berryseed", price = 0.05},
			{name = "bberryseed", price = 0.05},
			{name = "artichokeseed", price = 0.05},
			{name = "cottonseed", price = 0.05},
			{name = "sugarcaneseed", price = 0.05},
			{name = "cornseed", price = 0.05},
			{name = "tomatoseed", price = 0.05},
			{name = "seedlingseed", price = 0.05},
		}, locations = {
			vec3(2587.909, -1010.728, 44.23), -- Rhodes
			vec3(-404.58, 662.45, 115.55), -- Valentine
			vec3(-965.825, -1252.956, 53.9652), -- BlackWater
		}, targets = {
			-- { loc = vec3(1134.9, -982.34, 46.41), length = 0.5, width = 0.5, heading = 96.0, minZ = 46.4, maxZ = 46.8, distance = 1.5 },
		}
	},
	PoliceArmoury = {
		name = 'Armário de Sheriff',
		prompt = true,
		groups = shared.police,
		blip = {
			id = 110, colour = 84, scale = 0.8
		}, 
		inventory = {
			{ name = 'badge_officer', price = 0, grade = 0 },
			{ name = 'badge_texas_ranger', price = 0, grade = 3 },
			{ name = 'badge_sheriff', price = 0, grade = 4 },
			{ name = 'badge_deputy', price = 0, grade = 5 },
			{ name = 'badge_marshal', price = 0, grade = 7 },

			{ name = 'handcuffs', price = 0 },
			{ name = 'handcuffs_keys', price = 0 },

			{ name = 'ammo_revolver', price = 0.01 },
			{ name = 'ammo_rifle', price = 0.01 },
			{ name = 'ammo_repeater', price = 0.01 },

			{ name = 'weapon_melee_knife', price = 0 },
			{ name = 'weapon_lasso', price = 0 },

			{ name = 'weapon_revolver_schofield', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },
			{ name = 'weapon_revolver_cattleman', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },
			{ name = 'weapon_revolver_navy', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },
			{ name = 'weapon_revolver_lemat', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },

			{ name = 'weapon_repeater_carbine', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },
			{ name = 'weapon_repeater_winchester', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },

			{ name = 'weapon_rifle_springfield', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },
			{ name = 'weapon_rifle_boltaction', price = 0, metadata = { registered = true, serial = 'OFICIAL' } },
		
			-- { name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon', grade = 3 },			
		}, locations = {
			vec3(2494.307, -1304.298, 48.953), -- saint dennis
			vec3(1361.17, -1305.839, 77.760), -- rhodes			
			vec3(2906.925, 1315.27, 44.938), -- annesburg
			vec3(-278.4373, 805.3104, 119.38), -- valentine
			vec3(1813.964, -354.7716, 164.649), -- Strawberry
			vec3(-764.753, -1272.402, 44.0413), -- blackwater
			vec3(-3623.315, -2602.468, -13.342), -- armadillo
			vec3(-5526.658, -2928.369, -1.3609), -- Thumbweed
		}, targets = {
			{ loc = vec3(453.21, -980.03, 30.68), length = 0.5, width = 3.0, heading = 270.0, minZ = 30.5, maxZ = 32.0, distance = 6 }
		}
	},

	Smuggling = {
		name = 'Contrabando de Armas',
		prompt = true,
		groups = { ['raven'] = 0 },
		blip = {
			id = 110, colour = 84, scale = 0.8
		}, 
		inventory = {
			{ name = 'weapon_pistol_m1899', price = 42, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_pistol_mauser', price = 35, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_pistol_semiauto', price = 32, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_pistol_volcanic', price = 75, metadata = { registered = false, serial = 'Numeração Raspada' } },

			{ name = 'weapon_revolver_doubleaction', price = 14, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_revolver_doubleaction_gambler', price = 14, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_revolver_cattleman', price = 09, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_revolver_cattleman_mexican', price = 12, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_revolver_lemat', price = 20, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_revolver_navy', price = 20, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_revolver_schofield', price = 15, metadata = { registered = false, serial = 'Numeração Raspada' } },

			{ name = 'weapon_repeater_winchester', price = 18, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_repeater_carbine', price = 18, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_repeater_evans', price = 20, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_repeater_henry', price = 20, metadata = { registered = false, serial = 'Numeração Raspada' } },

			{ name = 'weapon_rifle_springfield', price = 26, metadata = { registered = false, serial = 'Numeração Raspada' } },
			{ name = 'weapon_rifle_boltaction', price = 32, metadata = { registered = false, serial = 'Numeração Raspada' } },
		
		}, locations = {
			vec3(2275.67, 1460.301, 83.992), -- saint dennis
		}, targets = {
			-- { loc = vec3(453.21, -980.03, 30.68), length = 0.5, width = 3.0, heading = 270.0, minZ = 30.5, maxZ = 32.0, distance = 6 }
		}
	},



	-- Medicine = {
	-- 	name = 'Medicine Cabinet',
	-- 	groups = {
	-- 		['ambulance'] = 0
	-- 	},
	-- 	blip = {
	-- 		id = 403, colour = 69, scale = 0.8
	-- 	}, inventory = {
	-- 		{ name = 'medikit', price = 26 },
	-- 		{ name = 'bandage', price = 5 }
	-- 	}, locations = {
	-- 		vec3(306.3687, -601.5139, 43.28406)
	-- 	}, targets = {

	-- 	}
	-- },

	-- BlackMarketArms = {
	-- 	name = 'Black Market (Arms)',
	-- 	inventory = {
	-- 		{ name = 'WEAPON_DAGGER', price = 5000, metadata = { registered = false	}, currency = 'black_money' },
	-- 		{ name = 'WEAPON_CERAMICPISTOL', price = 50000, metadata = { registered = false }, currency = 'black_money' },
	-- 		{ name = 'at_suppressor_light', price = 50000, currency = 'black_money' },
	-- 		{ name = 'ammo-rifle', price = 1000, currency = 'black_money' },
	-- 		{ name = 'ammo-rifle2', price = 1000, currency = 'black_money' }
	-- 	}, locations = {
	-- 		vec3(309.09, -913.75, 56.46)
	-- 	}, targets = {

	-- 	}
	-- },

	-- VendingMachineDrinks = {
	-- 	name = 'Vending Machine',
	-- 	inventory = {
	-- 		{ name = 'water', price = 10 },
	-- 		{ name = 'cola', price = 10 },
	-- 	},
	-- 	model = {
	-- 		`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
	-- 	}
	-- }
}
