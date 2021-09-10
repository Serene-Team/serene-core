--[[
    File name: levels.lua
    Description: serene leveling system
    Author: oldmilk
--]]

local module = {}
local ridge = require(game.ReplicatedStorage:WaitForChild("modules").ridge)
local mathLibrary = require(game.ReplicatedStorage:WaitForChild("modules").math)
local extra = require(game.ReplicatedStorage:WaitForChild("modules").extra)
local levelsMath = mathLibrary.import("level")
local playerStats = require(game.ReplicatedStorage:WaitForChild("modules").playerStat)
--5736400107
-- core functions
function getLevelData(player)
    local playerDataStore = ridge.getPlayerDataStore(player)        
    local playerLevelData = playerDataStore:getAsync("levels")
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
    local playerDataStore = ridge.getPlayerDataStore(player)        
    playerDataStore:setAsync("levels", value)
end
function playLevelUpSound(player)
    game.ReplicatedStorage.events:WaitForChild("playLocalSound"):FireClient(player, 5736400107)
end
-- grantXp: grants a player xp
module.grantXp = function(player, xpToGrant)
    local levelData = getLevelData(player)
    local xpToLevel = levelsMath.xpToLevelUp(levelData.currentLevel)
    levelData.currentXp += xpToGrant
    if levelData.currentXp >= xpToLevel then
        levelData.currentXp = 0
        setLevelData(player, levelData)
        module.grantLevel(player, 1)
        player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: 0".."/"..(levelsMath.xpToLevelUp(levelData.currentLevel)))
    else
        -- fire events to update the xp bar
        game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, levelData.currentXp, levelData.currentLevel)
        player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: "..levelData.currentXp.."/"..(levelsMath.xpToLevelUp(levelData.currentLevel)))
        setLevelData(player, levelData)
    end
end
-- getXp: returns the current amount of xp a player has
module.getXp = function(player)
    local levelData = getLevelData(player)
    return levelData.currentXp
end
-- getLevel: returns the given players level
module.getLevel = function(player)
    local levelData = getLevelData(player)
    return levelData.currentLevel
end
-- grantLevel: give a level to a player
module.grantLevel = function(player, num)
    local levelData = getLevelData(player)
    levelData.currentLevel += num
    setLevelData(player, levelData)
    game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, 0, levelData.currentLevel)
    extra.makeChatMessageGlobal(player.Name.." has reached level "..levelData.currentLevel.."!", Color3.fromRGB(0, 255, 0), 18)
    local statPoints = levelData.currentLevel * 3
    extra.makeChatMessage(player, "+"..statPoints.." stat points are avalible in the stat book!", Color3.fromRGB(0, 100, 0), 20)        player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: 0".."/"..(levelsMath.xpToLevelUp(levelData.currentLevel)))
    playLevelUpSound(player)
    playerStats.giveInvestPoints(player, (levelData.currentLevel * 3))
    task.wait(0.4)
end
-- loadLevelData: loads level data into the game for the player(example: the xp bar)
module.loadLevelData = function(player)
    local levelData = getLevelData(player)
    game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, levelData.currentXp, levelData.currentLevel)
    player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: "..levelData.currentXp.."/"..(levelsMath.xpToLevelUp(levelData.currentLevel)))
end

return module