--[[
    File name: level.lua
    Description: calculate xp to level up, and other stuff
    Author: oldmilk
--]]

local module = {}
local gui = require(game.ReplicatedStorage:WaitForChild("modules").client.gui)
-- xpToLevelUp: compute how much exp the player needs to level up
module.xpToLevelUp = function(currentLevel)
    -- thanks devfourm
    return 7 + 100*(currentLevel - 2) + 600*(currentLevel - 2)^2
end
-- xpToLevels: convert the given xp into levels
module.xpToLevels = function(xp, currentLevel)
    -- return value:
    --[[
      {
        levels = 56,
        extraXp = 10
      }  
    --]]
    local xpToLevelUp = module.xpToLevelUp(currentLevel)
    local levels = 0
    local extraXp = 0
    
end

return module