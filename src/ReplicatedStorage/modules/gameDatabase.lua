--[[
    File name: gameDatabase.lua
    Description: lookup values in the game database
    Author: oldmilk
--]]

local module = {}
local InsertService = game:GetService("InsertService")
-- updateConfig: update the game config/database
function module.updateConfig()
    warn("Game database updating....")
    if game.ReplicatedStorage:FindFirstChild("gameDatabase") ~= nil then
        game.ReplicatedStorage.gameDatabase:Destroy()
    end
    InsertService:LoadAsset(7418954161):GetChildren()[1].Parent = game.ReplicatedStorage
    warn("Game database updated!")
end
-- runStartupConfig: run the server startup function located in the game database
function module.runStartupConfig()
    local gameConfig = require(game.ReplicatedStorage:WaitForChild("gameDatabase"))    
    gameConfig.server.startupConfig()
end
-- getLootTable: returns the raw loot table data for a given mob
function module.getLootTable(mobName)
    local gameConfig = require(game.ReplicatedStorage:WaitForChild("gameDatabase"))    
    if gameConfig.lootTables[mobName] == nil then
        error("Failed to lookup: invalid mobName")
    else
        return gameConfig["lootTables"][mobName]
    end
end
-- getItemInfo: returns the raw item info for a given item
function module.getItemInfo(itemName)
    local gameConfig = require(game.ReplicatedStorage:WaitForChild("gameDatabase"))    
    if gameConfig["items"][itemName] == nil then
        error("Failed to lookup: invalid itemName")
    else
        return gameConfig["items"][itemName]
    end
end

return module