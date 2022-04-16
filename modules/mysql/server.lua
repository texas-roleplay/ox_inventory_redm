local Query = {
	SELECT_STASH = 'SELECT data FROM ox_inventory WHERE owner = ? AND name = ?',
	UPDATE_STASH = 'INSERT INTO ox_inventory (owner, name, data) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
	SELECT_GLOVEBOX = 'SELECT plate, glovebox FROM `vehicles` WHERE plate = ?',
	SELECT_TRUNK = 'SELECT plate, trunk FROM `vehicles` WHERE plate = ?',
	SELECT_PLAYER = 'SELECT inventory FROM `characters` WHERE charid = ?',
	UPDATE_TRUNK = 'UPDATE `vehicles` SET trunk = ? WHERE plate = ?',
	UPDATE_GLOVEBOX = 'UPDATE `vehicles` SET glovebox = ? WHERE plate = ?',
	UPDATE_PLAYER = 'UPDATE `characters` SET inventory = ? WHERE charid = ?',
}

--[[
	Separar as colunas `glovebox` e `trunk` em tabelas diferentes.
--]]

local function replace(playerColumn, vehicleColumn)
	for k, v in pairs(Query) do
		if v:find('vehicles') then
			Query[k] = v:gsub('vehicles', vehicleColumn)
		elseif v:find('characters') then
			Query[k] = v:gsub('characters', playerColumn)
		end
	end
end

if shared.framework == 'esx' then
	replace('users', 'owned_vehicles')
end

if shared.framework == 'redemrp' then
	Query.SELECT_PLAYER = 'SELECT inventory FROM `characters` WHERE id = ?'
	Query.UPDATE_PLAYER = 'UPDATE `characters` SET inventory = ? WHERE id = ?'

	Query.SELECT_GLOVEBOX = 'SELECT id, inventory FROM `horse` WHERE id = ?'
	Query.UPDATE_GLOVEBOX = 'UPDATE `horse` SET inventory = ? WHERE id = ?'

	Query.SELECT_TRUNK = 'SELECT id, trunk FROM `stagecoaches` WHERE id = ?'
	Query.UPDATE_TRUNK = 'UPDATE `stagecoaches` SET trunk = ? WHERE id = ?'
end

function MySQL:loadPlayer(characterid)
	local inventory = self.prepare.await(Query.SELECT_PLAYER, { characterid })
	return inventory and json.decode(inventory)
end

function MySQL:savePlayer(characterid, inventory )
	return self.prepare(Query.UPDATE_PLAYER, { inventory, characterid })
end

function MySQL:saveStash(owner, dbId, inventory)
	return self.prepare(Query.UPDATE_STASH, { owner or '', dbId, inventory })
end

function MySQL:loadStash(owner, name)
	return self.prepare.await(Query.SELECT_STASH, { owner or '', name })
end

function MySQL:saveGlovebox(plate, inventory)
	return self.prepare(Query.UPDATE_GLOVEBOX, { inventory, plate })
end

function MySQL:loadGlovebox(plate)
	return self.prepare.await(Query.SELECT_GLOVEBOX, { plate })
end

function MySQL:saveTrunk(plate, inventory)
	return self.prepare(Query.UPDATE_TRUNK, { inventory, plate })
end

function MySQL:loadTrunk(plate)
	return self.prepare.await(Query.SELECT_TRUNK, { plate })
end

function MySQL:saveInventories(trunks, gloveboxes, stashes)

	if #trunks > 0 then
		self.prepare(Query.UPDATE_TRUNK, trunks)
	end

	if #gloveboxes > 0 then
		self.prepare(Query.UPDATE_GLOVEBOX, gloveboxes)
	end

	if #stashes > 0 then
		self.prepare(Query.UPDATE_STASH, stashes)
	end
end

function MySQL:selectLicense(name, owner)
	return self.scalar.await('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { name, owner })
end
