--[[
    File name: pine.lua
    Description: item system, for weapons please use forge.
    Author: oldmilk
--]]
-- NOTE: I added this file like a loooooong time ago, and now at 12:00 a month later I'm working on it

local module = {}

local pineClass = {}
pineClass.__index = pineClass
pineClass.toolInstance = nil
pineClass.config = {}
pineClass.coreConfig = {
    onDrinkFunction = nil
}
pineClass.owner = {}
-- setConfig: set the config(takes in a table)
function pineClass:setConfig(config)
    if type(config) ~= "table" then
        error("Failed to set config: expected table, got "..type(config))
    end
    self.config = config
end
-- getConfig: returns the current tool config
function pineClass:getConfig()
    return self.config    
end
-- onDrink: listen for when the player drinks the item(only works for consumables)
function pineClass:onDrink(callback)
    self.coreConfig.onDrinkFunction = callback
end
-- setEnabled: disable/enable the tool
function pineClass:setEnabled(value)
    if type(value) ~= "boolean" then
        error("setEnabled only accepts bools")
    end
    self.coreConfig.enabled = value
end
-- isEnabled: returns if the tool is enabled
function pineClass:isEnabled()
    if self.coreConfig.enabled == nil then
        return true
    else
        return self.coreConfig.enabled
    end
end
-- init: should be called after config is set, listens for tool events
function pineClass:init()
    local tool = self.toolInstance
    local config = self.config
    if config["owner"] == nil then
        error("Failed to init tool: owner not set.")
    end
    local owner = config.owner
    if not owner:IsA("Player") then
        error("Failed to init tool: the tool owner must be of class Player")
    end
    tool.Activated:Connect(function()
        if self:isEnabled() == false then
            return
        end
        if config["toolType"] == nil then
            error("Failed to run tool activate: config does not have a toolType key.")
        end
        -- check for animations
        if config["useAnimation"] ~= nil then
            print("Playing animations")
            local animator = nil
            if owner.Character:WaitForChild("Humanoid"):FindFirstChildOfClass("Animator") then
                animator = owner.Character:WaitForChild("Humanoid"):FindFirstChildOfClass("Animator")
            else
                animator = Instance.new("Animator")
                animator.Parent = owner.Character:WaitForChild("Humanoid")
            end
            -- check if the hand out animation is playing
            if owner.Character:WaitForChild("Animate"):FindFirstChild("toolnone") ~= nil then
                owner:SetAttribute("deletedToolHand", true)
                owner.Character:WaitForChild("Animate"):FindFirstChild("toolnone").Parent = owner
            end
            local useAnim = Instance.new("Animation")
            useAnim.AnimationId = "rbxassetid://"..config.useAnimation
            local track = animator:LoadAnimation(useAnim)
            track:Play()
            track.Stopped:Connect(function()
                local finishedUsingItem = Instance.new("BoolValue")
                finishedUsingItem.Value = true
                finishedUsingItem.Name = "finishedUsingItem"
                finishedUsingItem.Parent = owner
            end)
        end
        if config.toolType == "food" then
            if self.coreConfig["onDrinkFunction"] ~= nil then
                self.coreConfig.onDrinkFunction()
                if game.ServerStorage["backpackSave_"..owner.Name]:FindFirstChild(self.toolInstance.Name) ~= nil then
                    game.ServerStorage["backpackSave_"..owner.Name]:FindFirstChild(self.toolInstance.Name):Destroy()
                end
                local finishedUsingItem = owner:WaitForChild("finishedUsingItem")
                if owner:GetAttribute("deletedToolHand") ~= nil then
                    owner:SetAttribute("deletedToolHand", true)
                    owner.toolnone.Parent = owner.Character.Animate
                end
                finishedUsingItem:Destroy()
                self.toolInstance:Destroy()
            end
        end
    end) 
end

module.new = function(tool)
    local coreData = {
        toolInstance = tool
    }
    setmetatable(coreData, pineClass)
    return coreData
end
return module