--[[
    File name: backpack.lua
    Description: save backpack items between places
    Author: oldmilk
--]]
local module = {}
local dataStore = require(game.ReplicatedStorage.DataStore2)
module.loadBackpack = function(player)
    -- get backpack for save slot
    
end
module.saveBackpack = function (player)
	local items = player.Backpack:GetChildren() 	
	local dataStore = {}
	for i, item in pairs(items) do
		print(i)
		dataStore[item.Name] = {
			itemName = item.Name,
			itemData = item:GetAttributes()
		}
	end
	print(dataStore)
end
return module