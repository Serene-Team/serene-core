local network = require(game.ReplicatedStorage:WaitForChild("modules").network)
local userInputService = game:GetService("UserInputService")
local gui = require(game.ReplicatedStorage:WaitForChild("modules").client.gui)
local player = game.Players.LocalPlayer


network.bindableEvent("openStatBook", function ()
	if player:WaitForChild("PlayerGui"):FindFirstChild("statBook") == nil then
		local statBook = game.ReplicatedStorage:WaitForChild("gui").statBook:Clone()
		statBook.Parent = player.PlayerGui	
		gui.waitForMouseover(statBook.Frame.close, "Close window")
		statBook.Frame.close.MouseButton1Click:Connect(function ()
			statBook:Destroy()
		end)
	else
		player.PlayerGui.statBook:Destroy()
	end
end)

userInputService.InputBegan:Connect(function (input, isGood)
	if not isGood then
		if input.KeyCode == Enum.KeyCode.Q then
			game.ReplicatedStorage:WaitForChild("events").openStatBook:Fire()
		end
	end
end)