print("Hello, World from the client.")
game.ReplicatedStorage:WaitForChild("events"):WaitForChild("loadPlayerscripts").OnClientEvent:Connect(function ()
	print("started loading client player packages.")
	if game.Players.LocalPlayer.PlayerScripts:FindFirstChild("playerScripts") == nil then
		game.StarterPlayer.StarterPlayerScripts.playerScripts:Clone().Parent = game.Players.LocalPlayer.PlayerScripts
		print("loaded client player packages.")	
	end
end)