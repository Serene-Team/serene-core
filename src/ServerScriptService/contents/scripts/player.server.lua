local playersService = game.Players
local playerList = require(game.ReplicatedStorage.modules.playerlist)
local backpack = require(game.ReplicatedStorage.modules.backpack)
local quest = require(game.ReplicatedStorage.modules.quest)
local levels = require(game.ReplicatedStorage.modules.levels)
local teleportServer = require(game.ReplicatedStorage.modules.teleportServer)
playersService.PlayerAdded:Connect(function(player)
    print(player.DisplayName.." joined the game, awaiting player load.")
    player.CharacterAdded:Connect(function()
		print(player.DisplayName.." character loaded!")
		backpack.saveBackpack(player)
		quest.sendQuestAlert(player, "Quest Started: Mary's Quest")	
		if game.PlaceId ~= 7193001633 then
			teleportServer.saveCurrentPlace(player)
		end
	end)
	-- load player info
	levels.loadLevelData(player)
end)
