local sound = require(game.ReplicatedStorage.modules.client.sound)
if game.PlaceId == 7207718284 then
	sound.playSong("Ashtown")	
end
if game.PlaceId == 7335918643 then
	sound.playSong("Hidden Valley")
end
if game.PlaceId == 7390543558 then
	sound.playSong("Build Env")
end
if game.PlaceId == 8158821463 then
	sound.playSong("Forgotten Passage")
end

game.ReplicatedStorage:WaitForChild("events"):WaitForChild("playLocalSound").OnClientEvent:Connect(function(soundId)
	sound.playLocalSound(soundId)
end)