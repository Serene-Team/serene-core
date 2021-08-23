local module = {}

module.waitForMouseover = function (uiObject, text)
	if not uiObject:IsA("GuiObject") then
		error("waitForMouseover only works on GuiObjects")
	end
	local mouse = game.Players.LocalPlayer:GetMouse()
	local player = game.Players.LocalPlayer
	local connect
	uiObject.MouseEnter:Connect(function ()
		connect = mouse.Move:Connect(function ()
			player.PlayerGui.gameUi.mouseOverText.Visible = true
			player.PlayerGui.gameUi.mouseOverText.Position = UDim2.new(0, mouse.X + 15, 0, mouse.Y - 40)
			player.PlayerGui.gameUi.mouseOverText.Text = text	
		end)
	end)
	uiObject.MouseLeave:Connect(function ()
		connect:Disconnect()
		player.PlayerGui.gameUi.mouseOverText.Visible = false
	end)
end
module.moveAway = function (uiObject)
	if not uiObject:IsA("GuiObject") then
		error("moveAway only works on GuiObjects")
	end
	uiObject:TweenPosition(UDim2.new(0, 0, 0, 10000))
	wait(1)
	uiObject:Destroy()
end
module.printChatMessage = function(message, textColor, textSize)
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = message,
		Color = textColor,
		TextSize = textSize
	})
end

return module
