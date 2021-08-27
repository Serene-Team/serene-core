--[[
    File name: backpackManager.client.lua
    Description: backpack gui manager for the client
    Author: oldmilk
--]]

-- services
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
-- modules
local network = require(game.ReplicatedStorage.modules.network)
local gui = require(game.ReplicatedStorage.modules.client.gui)
-- globals
local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local backpackGui = player:WaitForChild("PlayerGui"):WaitForChild("backpackView")

-- functions
function openBackpack()
    print("Loading items")
    local items = backpack:GetChildren()
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
        backpackGui.Frame.Visible = false
    end)
end

-- create network items
print("creating new network objects")
local openBackpackEvent = network.bindableEvent("openUserBackpack", function()
    openBackpack()
end)
print("awaiting user input.")
-- wait for user input
userInputService.InputBegan:Connect(function (input, isProcessed)
    if not isProcessed then
        if input.KeyCode == Enum.KeyCode.E then
            openBackpackEvent:Fire()
        end
    end
end)