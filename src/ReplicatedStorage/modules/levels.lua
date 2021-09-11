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
function playLevelUpSound(player)
    game.ReplicatedStorage:WaitForChild("events"):WaitForChild("playLocalSoundEffect"):FireClient(player, "levelUp")
end
function resetXpbar(player)
    local currentLevel = module.getLevel(player)
    player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: 0".."/"..(levelsMath.xpToLevelUp(currentLevel)))
end
function updateXpBar(player)
    local currentLevel = module.getLevel(player)
    local currentXp = module.getXp(player)
    game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, currentXp, currentLevel)
    player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: "..currentXp.."/"..(levelsMath.xpToLevelUp(currentLevel)))
end
-- core functions

module.getXp = function(player)
    local playerProfile = ridge.getPlayerDataStore(player)    
    local xp = playerProfile:getAsync("currentXp")
    if xp == nil then
        return 0
    end
    return xp
end
module.getLevel = function(player)
    local playerProfile = ridge.getPlayerDataStore(player)    
    local level = playerProfile:getAsync("currentLevel")
    if level == nil then
        return 1
    end
    return level
end

module.grantLevel = function(player, levels)
    print("granted "..levels.." to "..player.Name)
    local playerProfile = ridge.getPlayerDataStore(player)    
    local currentLevel = module.getLevel(player)
    local givenLevel = currentLevel + levels
    playerProfile:setAsync("currentLevel", givenLevel)
end
module.resetXp = function(player)
    local playerProfile = ridge.getPlayerDataStore(player)
    playerProfile:setAsync("currentXp", 0)
end

module.grantXp = function(player, amount)
    local playerProfile = ridge.getPlayerDataStore(player)    
    local currentXp = module.getXp(player)
    local currentLevel = module.getLevel(player)
    playerProfile:setAsync("currentXp", currentXp + amount)
    local givenAmount = currentXp + amount
    local xpToLevel = levelsMath.xpToLevelUp(currentLevel)
    if givenAmount >= xpToLevel then
        print(givenAmount)
        print(xpToLevel)
        module.resetXp(player)
        module.grantLevel(player, 1)
        -- extra.make(player.Name.." has reached level "..(currentLevel + 1).."!", Color3.fromRgb(255,170,29), 18)
        -- extra.makeChatMessage(player, "+3 stat points are avalible in the stat book", Color3.fromRgb(50,205,50), 18)
        playLevelUpSound(player)
        resetXpbar(player)
        playerStats.giveInvestPoints(player, 3)
    else
        updateXpBar(player)
    end
end

module.loadLevelData = function(player)
    local currentXp = module.getXp(player)
    local currentLevel = module.getLevel(player)
    game.ReplicatedStorage.events:WaitForChild("updateXpBar"):FireClient(player, currentXp, currentLevel)
    player.PlayerGui:WaitForChild("gameUi").xpBar:SetAttribute("xpBarText", "EXP: "..currentXp.."/"..(levelsMath.xpToLevelUp(currentLevel)))
end
return module