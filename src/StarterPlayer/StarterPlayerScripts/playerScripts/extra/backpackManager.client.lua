--[[
    File name: backpackManager.client.lua
    Description: backpack gui manager for the client
    Author: oldmilk
--]]

-- services
local userInputService = game:GetService("UserInputService")
-- modules
local network = require(game.ReplicatedStorage.modules.network)
local gui = require(game.ReplicatedStorage.modules.client.gui)
-- globals
local player = game.Players.LocalPlayer
local backpackGuiSource = game.ReplicatedStorage:WaitForChild("gui"):WaitForChild("backpackView")
local computeItemInfoForPlayer = game.ReplicatedStorage:WaitForChild("events"):WaitForChild("computeItemInfoForPlayer")

function displayItemInfo(gui, tool)
    print("loading item info...")
    local itemInfo = computeItemInfoForPlayer:InvokeServer(tool)
    gui.Frame.itemInfo.title.Text = tool.Name
    if itemInfo.error ~= "NotWeapon" then
        gui.Frame.itemInfo.minDmg.Text = "Item min damage: "..itemInfo.minDamage
        gui.Frame.itemInfo.maxDmg.Text = "Item max damage: "..itemInfo.maxDamage    
    else
        gui.Frame.itemInfo.minDmg.Text = "Item min damage: ??"
        gui.Frame.itemInfo.maxDmg.Text = "Item max damage: ??"
    end
end

-- functions
function openBackpack()
	print("Loading items")
	local backpack = player:WaitForChild("Backpack")
	local items = backpack:GetChildren()
    local backpackGui = backpackGuiSource:Clone()
    gui.setupDraggableWindow(backpackGui.Frame)
    backpackGui.Parent = player.PlayerGui
    local addConnect = backpack.ChildAdded:Connect(function(item)
        -- Refresh
        local button = backpackGui.Frame.itemTemplate:Clone()
        button.Name = item.Name
        button.Parent = backpackGui.Frame.items
        button.Visible = true
        button.icon.Image = item.TextureId
        gui.waitForMouseover(button, item.Name)
        local btnConnect = button.icon.MouseEnter:Connect(function()
            displayItemInfo(backpackGui, item)
        end)
        button.icon.InputBegan:Connect(function(input)
            print("Equiped tool.")
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                print("Equiped tool.")
                player.Character.Humanoid:EquipTool(item)
            end
        end)
    end)
    local removeConnect = backpack.ChildRemoved:Connect(function(item)
        backpackGui.Frame.items[item.Name]:Destroy()
    end)
    -- remove buttons
    for i, v in pairs(backpackGui.Frame.items:GetChildren()) do
        if v.ClassName == "Frame" then
            v:Destroy()
        end
    end
    for index, item in pairs(items) do
        -- load item
        local button = backpackGui.Frame.itemTemplate:Clone()
        button.Name = item.Name
        button.Parent = backpackGui.Frame.items
        button.Visible = true
        button.icon.Image = item.TextureId
        gui.waitForMouseover(button, item.Name)
        local btnConnect = button.icon.MouseEnter:Connect(function()
            displayItemInfo(backpackGui, item)
        end)
        button.icon.InputBegan:Connect(function(input)
            print("Equiped tool.")
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                print("Equiped tool.")
                player.Character.Humanoid:EquipTool(item)
            end
        end)
    end
    backpackGui.Frame.Visible = true
    print("Loading extra gui.")
    gui.waitForMouseover(backpackGui.Frame.close, "Close window")
    backpackGui.Frame.close.MouseButton1Click:Connect(function ()
        addConnect:Disconnect()
        removeConnect:Disconnect()
        backpackGui:Destroy()
    end)
end

-- create network items
print("creating new network objects")
local openBackpackEvent = game.ReplicatedStorage:WaitForChild("events"):FindFirstChild("openUserBackpack")
if openBackpackEvent == nil  then
	openBackpackEvent = network.bindableEvent("openUserBackpack", function()
		openBackpack()
	end)	
end
print("awaiting user input.")
-- wait for user input
userInputService.InputBegan:Connect(function (input, isProcessed)
    if not isProcessed then
        if input.KeyCode == Enum.KeyCode.E then
            openBackpackEvent:Fire()
        end
    end
end)