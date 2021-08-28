local module = {}
local mathLibrary = require(game.ReplicatedStorage.modules.math)
module.getGameUi = function()
	local ui = game.Players.LocalPlayer.PlayerGui:WaitForChild("gameUi")
	return ui
end
module.waitForMouseover = function (uiObject, text)
	if not uiObject:IsA("GuiObject") then
		error("waitForMouseover only works on GuiObjects")
	end
	local mouse = game.Players.LocalPlayer:GetMouse()
	local player = game.Players.LocalPlayer
	local connect
	uiObject.MouseEnter:Connect(function ()
		connect = mouse.Move:Connect(function ()
			if uiObject.Parent ~= nil then
				player.PlayerGui.gameUi.mouseOverText.Visible = true
				player.PlayerGui.gameUi.mouseOverText.Position = UDim2.new(0, mouse.X + 15, 0, mouse.Y - 40)
				player.PlayerGui.gameUi.mouseOverText.Text = text	
			else
				connect:Disconnect()
				player.PlayerGui.gameUi.mouseOverText.Visible = false
			end
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
-- setXpBarData: tween the size of the xp bar to a point
module.setXpBarData = function(currentLevel, xp)
	local levels = mathLibrary.import("level")
	local xpCap = levels.xpToLevelUp(currentLevel)
	local currentXp = 100
	local gameUi = module.getGameUi()
	local xpBar = gameUi.xpBar
	print((xp/xpCap))
	if (xp/xpCap) == 1 then
		xpBar.xp:TweenSize(UDim2.new(0, 0, 0, 8))
	else
		xpBar.xp:TweenSize(UDim2.new(xp/xpCap, 0, 0, 8))
	end
end
return module
