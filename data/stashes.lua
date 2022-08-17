return {
	['hotel:valentine'] = {
		coords = vec3(-325.4, 767.02, 122.086),
		name = 'hotel:valentine',
		label = 'Baú do Hotel',
		owner = true,
		slots = 71,
		weight = 2500000,
	},

	['Bau:Padeiro'] = {
		coords = vec3(-1862.042, -1730.895, 89.25),
		name = 'Bau:Padeiro',
		label = 'Baú da Padaria',
		owner = nil,
		slots = 100,
		weight = 5000000,
		groups = {['padeiro'] = 0}
	},

	['indio:reserva'] = {
		coords = vec3(440.827, 2236.014, 248.43),
		name = 'indio:reserva',
		label = 'Baú da Reserva',
		owner = nil,
		slots = 100,
		weight = 5000000,
		groups = {['indio'] = 0}
	},

	['static:smuggling:chest'] = {
		coords = vec3(2272.342, 1459.121, 84.290),
		name = 'static:smuggling:chest',
		label = 'Baú',
		owner = nil,
		slots = 100,
		weight = 5000000,
		groups = {['raven'] = 0}
	},

	['Bau:Ferreiro'] = {
		coords = vec3(-1831.234, -618.1906, 154.6345),
		name = 'Bau:Ferreiro',
		label = 'Baú do Ferreiro',
		owner = nil,
		slots = 100,
		weight = 5000000,
		groups = {['ferreiro'] = 0}
	},
	
	-- ['Padeiro:BlackWater'] = {
	-- 	coords = vec3(-2778.04, -3048.852, -8.70),
	-- 	name = 'Padeiro:BlackWater',
	-- 	label = 'Baú da Padaria',
	-- 	owner = false,
	-- 	slots = 100,
	-- 	weight = 5000000,
	-- 	groups = {'padeiro'}
	-- },

	--[[
	{
		coords = vec3(451.25, -994.28, 30.69),
		target = {
			loc = vec3(451.25, -994.28, 30.69),
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Open personal locker'
		},
		name = 'policelocker',
		label = 'Armário pessoal',
		owner = true,
		slots = 50,
		weight = 70000,
		groups = shared.police
	},
	{
		coords = vec3(301.3, -600.23, 43.28),
		target = {
			loc = vec3(301.82, -600.99, 43.29),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Open personal locker'
		},
		name = 'emslocker',
		label = 'Armário pessoal',
		owner = true,
		slots = 50,
		weight = 70000,
		groups = {'doctor', 'doctorchefe'}
	},
	--]]
}
