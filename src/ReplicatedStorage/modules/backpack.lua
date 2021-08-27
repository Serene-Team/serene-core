--[[
    File name: backpack.lua
    Description: save backpack items between places
    Author: oldmilk
--]]
local module = {}
local dataStore = require(game.ReplicatedStorage.DataStore2)
module.loadBackpack = function(player)
    -- load backpack
    local backpackStore = dataStore("playerBackpackData", player)
	local backpack = backpackStore:Get({})
end
module.saveBackpack = function (player)
	local items = player.Backpack:GetChildren() 	
	local dataSave = {}
	for i, item in pairs(items) do
		dataSave[item.Name] = {
			itemName = item.Name,
			itemData = item:GetAttributes()
		}
	end
	local backpackStore = dataStore("playerBackpackData", player)
	backpackStore:Set(dataSave)
end
return module