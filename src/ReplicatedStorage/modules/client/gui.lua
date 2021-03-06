local module = {}
local mathLibrary = require(game.ReplicatedStorage:WaitForChild("modules").math)
local gameDatabase = require(game.ReplicatedStorage:WaitForChild("modules").gameDatabase)
local DraggableObject	= require(script.Parent.DraggableObject)
module.getGameUi = function()
	local ui = game.Players.LocalPlayer.PlayerGui:WaitForChild("gameUi")
	return ui
end
module.showNote = function(noteConfig)
	if noteConfig.title == nil then
		error("Failed to show note: noteConfig.title is nil")
	elseif noteConfig.text == nil then
		error("Failed to show note: noteConfig.text is nil")
	end
	local player = game.Players.LocalPlayer
	if player:GetAttribute("hasOpenNote") == nil then
		player:SetAttribute("hasOpenNote", true)
		-- Open the gui
		player.PlayerGui.gameUi.note.Visible = true
		player.PlayerGui.gameUi.note.title.Text = noteConfig.title
		player.PlayerGui.gameUi.note.text.Text = noteConfig.text
		module.waitForMouseover(player.PlayerGui.gameUi.note.close, "Close Note")
		module.setupDraggableWindow(player.PlayerGui.gameUi.note)
		player.PlayerGui.gameUi.note.close.MouseButton1Click:Connect(function()
			player.PlayerGui.gameUi.note.Visible = false
		end)
	else
		warn("Note already open!")
	end
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
	local co = coroutine.create(function()
		task.wait(1)
		uiObject:Destroy()
	end)
	coroutine.resume(co)
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
	if (xp/xpCap) == 1 then
		xpBar.xp:TweenSize(UDim2.new(0, 0, 0, 8))
	else
		xpBar.xp:TweenSize(UDim2.new(xp/xpCap, 0, 0, 8))
	end
end
-- showItemAlert: wrapper around game.StarterGui:SetCore
module.showItemAlert = function(itemName)
	local itemIcon = gameDatabase.getItemInfo(itemName).icon
	game.StarterGui:SetCore("SendNotification", {
		Title = "+1 "..itemName:gsub("^%l", string.upper),
		Text = "Backpack",
		Icon = "rbxassetid://"..itemIcon
	})
end
-- setupDraggableWindow: setup a draggable window
module.setupDraggableWindow = function(guiObject)
	if not guiObject:IsA("GuiObject") then
		error("setupDraggableWindow only works on GuiObjects")
	end
	local FrameDrag = DraggableObject.new(guiObject)
	FrameDrag:Enable()
end
-- showCurrencyAlert: show alert 
module.showCurrencyAlert = function(currency, subtract)
	if subtract then
		game.StarterGui:SetCore("SendNotification", {
			Title = "-"..currency.." coins",
			Text = "Bank Vault",
			Icon = "rbxassetid://7197434001"
		})
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "+"..currency.." coins",
			Text = "Bank Vault",
			Icon = "rbxassetid://7197434001"
		})
	end
end
return module
