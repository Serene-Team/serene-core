local gui = require(game.ReplicatedStorage:WaitForChild("modules").client.gui)
gui.printChatMessage("Welcome to serene, developed by @oldmilk!", Color3.fromRGB(100, 255, 0), 18)
print("sent default chat message!")
print("checking if player is added")
local player = game.Players.LocalPlayer
if player:GetAttribute("hasBeenAdded") == nil then
	print("player not added! sending event to server")
	game.ReplicatedStorage:WaitForChild("events"):WaitForChild("addPlayer"):FireServer()
end