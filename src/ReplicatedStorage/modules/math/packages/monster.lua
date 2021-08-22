--[[
    File name: monster.lua
    Description: calculate drop chances, and spawn rates of mobs in serene
    Author: oldmilk
--]]


local module = {}

module.calculateDropRate = function(chance)
    if type(chance) ~= "number" then
        error("expected number got ", type(chance))
    end
end


return module