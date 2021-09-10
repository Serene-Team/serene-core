local network = require(game.ReplicatedStorage:WaitForChild("modules").network)
local playerModule = require(game.ReplicatedStorage:WaitForChild("modules").player)

-- empty event for the client
network.event("playLocalSound", function()
    
end)
network.event("teleportPlayer", function()
    
end)
network.event("addPlayer", function (player)
	if player:GetAttribute("hasBeenAdded") == nil then
		playerModule.playerForceAdd(player)
	end
end)
-- empty event for the client
network.event("playLocalSoundEffect", function()
	
end)
network.event("sendCurrencyAlert", function()
	
end)
network.event("sendItemAlert", function()
		
end)