--[[
    File name: monster.lua
    Description: calculate drop chances, and spawn rates of mobs in serene
    Author: oldmilk
--]]


local module = {}

local percent = require(script.Parent.percent)
module.calculateDropRate = function(chance)
    if type(chance) ~= "number" then
        error("expected number got ", type(chance))
    end
    -- convert the percent given to a decimal
    chance = percent.percentToDecimal(chance)
    local random = math.random()
    if random < chance then
        return true
    else
        return false
    end
end


return module