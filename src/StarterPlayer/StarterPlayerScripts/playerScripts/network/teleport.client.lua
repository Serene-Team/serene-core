local clientTeleport = require(game.ReplicatedStorage:WaitForChild("modules").client.teleport)
game.ReplicatedStorage.events:WaitForChild("teleportPlayer").OnClientEvent:Connect(function(placeId, extraTeleports)
    clientTeleport.teleportAsync(placeId, extraTeleports)
end)