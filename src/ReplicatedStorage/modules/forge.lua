--[[
    File name: forge.lua
    Description: weapon system.
    Author: oldmilk
--]]

local forge = {}

local forgeDefaults = {
    defaultDamage = {
        Min = 10,
        Max = 30
    }
}


local forgeClass = {}
forgeClass.__index = forgeClass
forgeClass.config = {}
forgeClass.tool = nil
-- getValue: get a value from inside the config
function forgeClass:getValue(key)
    local config = self.config
    if config[key] == nil then
        warn("key not found in config table.")
        return nil
    else
        return config[key]
    end
end
-- setValue: set a value inside of the config
function forgeClass:setValue(key, value)
    if self.config[key] ~= nil then
        warn("data overwrited. old: "..self.config[key].." new: "..value)
    end
    self.config[key] = value
end
-- swingConnect: await the tool swing, and run a function.
-- NOTE: This wraps the Activated event on tools
function forgeClass:swingConnect(callback)
    local tool = self.tool
    -- make sure we don't connect multiple times
    if self:getValue("hasConnectedSwing") == nil then
        self:setValue("hasConnectedSwing", true)
        tool.Activated:Connect(function()
            -- execute the callback function
            callback()
        end)
    else
        warn("Failed to connect: you can only connect to this event once!")
    end
end
-- swing: swing the tool
function forgeClass:swing()
    
end
forge.enums = {}
forge.enums.animationTypes = {
    ["Idle"] = "AnimationIdle",
    ["ItemUse"] = "AnimationUse"
}
-- register: returns a new instance of the forge class
forge.register = function(tool)
    local self = {
        tool = tool
    }
    setmetatable(self, forgeClass)
    return self
end

return forge