local sound = require(game.ReplicatedStorage.modules.client.sound)
if game.PlaceId == 7207718284 then
	sound.playSong("Ashtown")	
end

game.ReplicatedStorage:WaitForChild("events"):WaitForChild("playLocalSound").OnClientEvent:Connect(function(soundId)
	sound.playLocalSound(soundId)
end)