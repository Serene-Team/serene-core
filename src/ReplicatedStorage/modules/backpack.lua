--[[
    File name: backpack.lua
    Description: save backpack items between places
    Author: oldmilk
--]]
local module = {}
local ridge = require(game.ReplicatedStorage.modules.ridge)
module.loadBackpack = function(player)
    -- load backpack
    local backpackStore = ridge.loadPlayerDatastore("playerBackpack", player)
	local backpack = backpackStore:getAsync({})
	if backpack == nil then
		backpack = {}
	end
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
	local backpackStore = ridge.loadPlayerDatastore("playerBackpack", player)
	backpackStore:setAsync(dataSave)
end
return module