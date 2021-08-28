--[[
    File name: backpack.lua
    Description: save backpack items between places
    Author: oldmilk
--]]
local module = {}
local ridge = require(game.ReplicatedStorage.modules.ridge)
local itemLoader = require(game.ReplicatedStorage.modules.item)

module.autoSave = function(player)
	local backpack = player:WaitForChild("Backpack")
	backpack.ChildAdded:Connect(function(child)
		module.saveBackpack(player)
	end)
	backpack.ChildRemoved:Connect(function(child)
		module.saveBackpack(player)
	end)
end

module.loadBackpack = function(player)
	local playerBackpackStore = ridge.loadPlayerDatastore("playerBackpack", player)
	local playerBackpack = playerBackpackStore:getAsync()
	if playerBackpack == nil then
		warn("no items in backpack: will not load")
		return "NoItems"
	end
	local backpack = player:WaitForChild("Backpack")
	for i, item in pairs(playerBackpack) do
		if item.assetName ~= nil then
			local itemAsset = itemLoader.loadItem(item.assetName, backpack)
			itemAsset.Name = item.name
			if item["attributes"] ~= nil then
				print("adding attributes")
				for key, value in pairs(item["attributes"]) do
					itemAsset:SetAttribute(key, value)
				end
			end
		end
	end
end
module.saveBackpack = function(player)
	local backpackItems = player.Backpack:GetChildren()
	local dataStore = {}
	for i, item in pairs(backpackItems) do
		if item:GetAttribute("asset_name") == nil then
			warn("Will not save item "..item.Name.." if it does not have a asset_name")
		else
			table.insert(dataStore, {
				assetName = item:GetAttribute("asset_name"),
				name = item.Name,
				attributes = item:GetAttributes()
			})
		end
	end
	if player.Character:FindFirstChildOfClass("Tool") then
		local tool = player.Character:FindFirstChildOfClass("Tool")
		table.insert(dataStore, {
			assetName = tool:GetAttribute("asset_name"),
			name = tool.Name,
			attributes = tool:GetAttributes()
		})
	end
	-- save to the datastore
	local playerBackpack = ridge.loadPlayerDatastore("playerBackpack", player)
	playerBackpack:setAsync(dataStore)
end
return module