local messageService = game:GetService("MessagingService")
print("loaded message service.")
messageService:SubscribeAsync("systemGlobalUpdate", function ()
	warn("Servers updating! Global update forced!")
	for i, player in pairs(game.Players:GetPlayers()) do
		game.ReplicatedStorage.gui.globalUpdate:Clone().Parent = player.PlayerGui
	end
	print("Players notified!")
	wait(5)
	print("Kicking all players!")
	for i, player in pairs(game.Players:GetPlayers()) do
		player:Kick("Servers restarted! You can now join again.")
	end
end)