local module = {}
local playerList = require(game.ReplicatedStorage:WaitForChild("modules").playerlist)
local backpack = require(game.ReplicatedStorage:WaitForChild("modules").backpack)
local levels = require(game.ReplicatedStorage:WaitForChild("modules").levels)
local statPoints = require(game.ReplicatedStorage:WaitForChild("modules").playerStat)
local teleportServer = require(game.ReplicatedStorage:WaitForChild("modules").teleportServer)
local currency = require(game.ReplicatedStorage:WaitForChild("modules").currency)
local extra = require(game.ReplicatedStorage:WaitForChild("modules").extra)
module.playerAdded = function(player)
	if player:GetAttribute("hasBeenAdded") == nil then
		player:SetAttribute("hasBeenAdded", true)
		print("loading in player info for "..player.Name)
		local backpackFolder = Instance.new("Folder")
		backpackFolder.Name = player.Name
		backpackFolder.Parent = game.ServerStorage
		player.CharacterAdded:Connect(function()
			backpack.loadBackpack(player)
			backpack.autoSave(player)
			-- load player info
			levels.loadLevelData(player)
		end)
		currency.currencyUpdated(player, function(currency, eventType)
			game.ReplicatedStorage:WaitForChild("events"):WaitForChild("playLocalSoundEffect"):FireClient(player, "getCoins")
			extra.sendCurrencyAlert(player, currency, eventType)
		end)
		statPoints.applyStatPoints(player)
		if game.PlaceId ~= 7193001633 then
			teleportServer.saveCurrentPlace(player)
		end
	end
end
module.playerForceAdd = function (player)
	if player:GetAttribute("hasBeenAdded") == nil then
		player:SetAttribute("hasBeenAdded", true)
		print("loading in player info for "..player.Name)
		local backpackFolder = Instance.new("Folder")
		backpackFolder.Name = player.Name
		backpackFolder.Parent = game.ServerStorage
		backpack.loadBackpack(player)
		backpack.autoSave(player)
		-- load player info
		levels.loadLevelData(player)
		statPoints.applyStatPoints(player)
		player.CharacterAdded:Connect(function ()
			backpack.loadBackpack(player)
			-- load player info
			levels.loadLevelData(player)
			statPoints.applyStatPoints(player)
		end)
		currency.currencyUpdated(player, function(currency, eventType)
			game.ReplicatedStorage:WaitForChild("events"):WaitForChild("playLocalSoundEffect"):FireClient(player, "getCoins")
			extra.sendCurrencyAlert(player, currency, eventType)
		end)
		if game.PlaceId ~= 7193001633 then
			teleportServer.saveCurrentPlace(player)
		end
	end
end

return module
