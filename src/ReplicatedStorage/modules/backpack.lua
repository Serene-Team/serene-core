--[[
    File name: backpack.lua
    Description: save backpack items between places
    Author: oldmilk
--]]
local module = {}
local ridge = require(game.ReplicatedStorage:WaitForChild("modules").ridge)
local extra = require(game.ReplicatedStorage:WaitForChild("modules").extra)
local itemLoader = require(game.ReplicatedStorage:WaitForChild("modules").item)
local ServerStorage = game.ServerStorage
module.loadBackpack = function (player)
	local backpackFolder = ServerStorage:FindFirstChild("backpackSave_"..player.Name)
	if player:GetAttribute("hasLoadedBackpack") == nil then
		local playerProfile = ridge.getPlayerDataStore(player)
		local backpack = playerProfile:getAsync("backpack")
		if backpackFolder == nil then
			backpackFolder = Instance.new("Folder")
			backpackFolder.Parent = ServerStorage
			backpackFolder.Name = "backpackSave_"..player.Name
		end
		player:SetAttribute("hasLoadedBackpack", true)
		if backpack == nil then
			backpack = {}
		end
		for _, item in pairs(backpack) do
			local itemName = item.assetName
			-- local attrs = item.attributes
			itemLoader.loadItem(itemName, backpackFolder)
		end
	end
	-- if we have already loaded in the backpack data just clone everything into the players backpack
	for _, tool in pairs(backpackFolder:GetChildren()) do
		tool:Clone().Parent = player.Backpack
	end
end
module.saveBackpack = function (player: Player)
	player:SetAttribute("systemPreventAutosave", true)
	local playerProfile = ridge.getPlayerDataStore(player)
	local backpackFolder = ServerStorage:FindFirstChild("backpackSave_"..player.Name)
	if backpackFolder == nil then
		warn("Not saving: backpack save file empty.")
		return
	end
	local dataStore = {}
	for _, tool in pairs(backpackFolder:GetChildren()) do
		local assetName = tool:GetAttribute("asset_name")
		table.insert(dataStore, {
			assetName = assetName,
			attributes = tool:GetAttributes()
		})
	end
	-- remove the backpack save file on the server.
	backpackFolder:Destroy()
	playerProfile:setAsync("backpack", dataStore)
	print("saved backpack for player: "..player.Name)	
end
module.autoSave = function(player: Player)
	if player:GetAttribute("backpackAutoSavedEnabled") == nil then
		player:SetAttribute("backpackAutoSavedEnabled", true)
		player:WaitForChild("Backpack").ChildAdded:Connect(function(tool)
			if player:GetAttribute("systemPreventAutosave") == nil then
				local backpackFolder = ServerStorage:WaitForChild("backpackSave_"..player.Name)
				if player:FindFirstChild("Backpack") == nil then
					warn("Failed to find backpack")
				else
					extra.sendItemAlert(player, tool:GetAttribute("asset_name"))
					tool:Clone().Parent = backpackFolder
				end
			end
		end)
		player:WaitForChild("Backpack").ChildRemoved:Connect(function(tool)
			if player:GetAttribute("systemPreventAutosave") == nil then
				local backpackFolder = ServerStorage:WaitForChild("backpackSave_"..player.Name)
				if player:FindFirstChild("Backpack") == nil then
					warn("Failed to find backpack")
				else
					backpackFolder:ClearAllChildren()
					local equippedTool = player.Character:FindFirstChildOfClass("Tool")
					if equippedTool ~= nil then
						equippedTool:Clone().Parent = backpackFolder
					end
					for _, tool in pairs(player:WaitForChild("Backpack"):GetChildren()) do
						tool:Clone().Parent = backpackFolder
					end
				end
			end
		end)
	end
end
return module