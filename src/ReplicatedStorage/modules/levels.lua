--[[
    File name: levels.lua
    Description: serene leveling system
    Author: oldmilk
--]]

local module = {}
local ridge = require(game.ReplicatedStorage.modules.ridge)
local mathLibrary = require(game.ReplicatedStorage.modules.math)
local extra = require(game.ReplicatedStorage.modules.extra)
local levelsMath = mathLibrary.import("level")
--5736400107
-- core functions
function getLevelData(player)
    local playerLevelDataStore = ridge.loadPlayerDatastore("playerLevelData", player)        
    local playerLevelData = playerLevelDataStore:getAsync({
        currentLevel = 1,
        currentXp = 0
    })
    if playerLevelData == nil then
        return {
            currentLevel = 1,
            currentXp = 0
        }
    else
        return playerLevelData
    end
end
function setLevelData(player, value)
    local playerLevelDataStore = ridge.loadPlayerDatastore("playerLevelData", player)        
    playerLevelDataStore:setAsync(value)
end
function playLevelUpSound(player)
    game.ReplicatedStorage.events:WaitForChild("playLocalSound"):FireClient(player, 5736400107)
end
-- grantXp: grants a player xp
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
        extra.makeChatMessageGlobal(player.Name.." has reached level "..levelData.currentLevel.."!", Color3.fromRGB(0, 255, 0), 18)
        player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: 0".."/"..(levelsMath.xpToLevelUp(levelData.currentLevel)))
        playLevelUpSound(player)
    else
        -- fire events to update the xp bar
        game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, levelData.currentXp, levelData.currentLevel)
        player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: "..levelData.currentXp.."/"..(levelsMath.xpToLevelUp(levelData.currentLevel)))
    end
end
-- getXp: returns the current amount of xp a player has
module.getXp = function(player)
    local levelData = getLevelData(player)
    return levelData.currentXp
end
-- getLevel: returns the given players level
module.getXp = function(player)
    local levelData = getLevelData(player)
    return levelData.currentLevel
end
-- loadLevelData: loads level data into the game for the player(example: the xp bar)
module.loadLevelData = function(player)
    local levelData = getLevelData(player)
    game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, levelData.currentXp, levelData.currentLevel)
    player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: "..levelData.currentXp.."/"..(levelsMath.xpToLevelUp(levelData.currentLevel)))
end

return module