local playersService = game:GetService("Players")
local playerList = require(game.ReplicatedStorage.modules.playerlist)
local backpack = require(game.ReplicatedStorage.modules.backpack)
local levels = require(game.ReplicatedStorage.modules.levels)
local teleportServer = require(game.ReplicatedStorage.modules.teleportServer)
playersService.PlayerAdded:Connect(function(player)
    print(player.DisplayName.." joined the game, awaiting player load.")
    player.CharacterAdded:Connect(function()
		print(player.DisplayName.." character loaded!")
		backpack.loadBackpack(player)
		backpack.autoSave(player)
		-- load player info
		levels.loadLevelData(player)
	end)
	if game.PlaceId ~= 7193001633 then
		teleportServer.saveCurrentPlace(player)
	end
end)
