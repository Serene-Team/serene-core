-- thanks topbar plus!
local icon = require(game.ReplicatedStorage:WaitForChild("modules").vendor.Icon)
local iconFolder = game.ReplicatedStorage:WaitForChild("modules").vendor.Icon
local IconController = require(iconFolder.IconController)
local Themes = require(iconFolder.Themes)
local showStatPointAlerts = game.ReplicatedStorage:WaitForChild("events"):WaitForChild("showStatPointAlerts")
IconController.setGameTheme(Themes["BlueGradient"])

local stats = icon.new()
stats:setImage(7230252017)
stats:setLabel("Stat Book")
-- network events
showStatPointAlerts.OnClientEvent:Connect(function(statPoints)
	local tick = 1
	while true do
		if tick == statPoints then
			print("alerted user of statpoints!")
			break
		end
		stats:notify()
		task.wait(0.1)
		tick += 1
	end
	stats:notify()
end)
stats:bindEvent("selected", function ()
	game.ReplicatedStorage:WaitForChild("events").openStatBook:Fire()
end)
stats:bindEvent("deselected", function()
	local statsGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("statBook")
	if statsGui ~= nil then
		statsGui:Destroy()
	end
end)
local book = icon.new()
book:setImage(7230254493)
book:setLabel("Ability Book")
book:bindEvent("selected", function ()
	print("bob")
end)
local backpack = icon.new()
backpack:setImage(7230246878)
backpack:setLabel("Backpack")
backpack:bindEvent("selected", function ()
	-- wait for the event to be created by backpackManager
	game.ReplicatedStorage.events:WaitForChild("openUserBackpack"):Fire()
end)
backpack:bindEvent("deselected", function()
	local backpackUi = game.Players.LocalPlayer.PlayerGui:FindFirstChild("backpackView")
	if backpackUi ~= nil then
		backpackUi:Destroy()
	end
end)