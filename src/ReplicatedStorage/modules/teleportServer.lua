--[[
    File name: teleportServer.lua
    Description: server interface for the teleport system
    Author: oldmilk
--]]

local module = {}
local ridge = require(game.ReplicatedStorage.modules.ridge)
module.teleportPlayer = function(player, placeId, extraTeleports)
    game.ReplicatedStorage:WaitForChild("events"):WaitForChild("teleportPlayer"):FireClient(player, placeId, extraTeleports)
end
module.saveCurrentPlace = function(player)
    local playerDataStore = ridge.getPlayerDataStore(player)
    local characterInfo = playerDataStore:getAsync("characterInfo")
    if characterInfo == nil then
        characterInfo = {}
    end
    characterInfo["placeId"] = game.PlaceId
    playerDataStore:setAsync("characterInfo", characterInfo)
end
module.getCurrentPlace = function(player)
    local playerDataStore = ridge.getPlayerDataStore(player)
    local characterInfo = playerDataStore:getAsync("characterInfo")
    if characterInfo == nil then
        characterInfo = {}
    end
    if characterInfo["placeId"] == nil then
        return 7207718284
    else
        return characterInfo["placeId"]
    end
end
return module