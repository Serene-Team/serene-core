--[[
    File name: levels.lua
    Description: serene leveling system
    Author: oldmilk
--]]

local module = {}
local dataStore = require(game.ReplicatedStorage.DataStore2)
local mathLibrary = require(game.ReplicatedStorage.modules.math)
local levelsMath = mathLibrary.import("level")

-- core functions
function getLevelData(player)
    local playerLevelDataStore = dataStore("playerLevelData", player)        
    local playerLevelData = playerLevelDataStore:Get({
        currentLevel = 1,
        currentXp = 0
    })
    return playerLevelData
end
function setLevelData(player, value)
    local playerLevelDataStore = dataStore("playerLevelData", player)        
    playerLevelDataStore:Set(value)
end

module.grantXp = function(player, xpToGrant)
    local levelData = getLevelData(player)
    local xpToLevel = levelsMath.xpToLevelUp(levelData.currentLevel)
    levelData.currentXp += xpToGrant
    setLevelData(player, levelData)
    if levelData.currentXp >= xpToLevel then
        levelData.currentXp = 0
        levelData.currentLevel += 1
        setLevelData(player, levelData)
        game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, 0, levelData.currentLevel)
    else
        -- fire events to update the xp bar
        game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, levelData.currentXp, levelData.currentLevel)
    end
end


return module