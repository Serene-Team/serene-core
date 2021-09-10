--[[
    File name: teleportServer.lua
    Description: server interface for the teleport system
    Author: oldmilk
--]]

local module = {}
local ridge = require(game.ReplicatedStorage:WaitForChild("modules").ridge)
module.teleportPlayer = function(player, placeId, extraTeleports)
    game.ReplicatedStorage:WaitForChild("events"):WaitForChild("teleportPlayer"):FireClient(player, placeId, extraTeleports)
end
module.saveCurrentPlace = function(player)
    local playerDataStore = ridge.getPlayerDataStore(player)
    local placeId = playerDataStore:getAsync("placeId")
    placeId = game.PlaceId
    playerDataStore:setAsync("placeId", placeId)
    print("saved current place id.")
end
module.getCurrentPlace = function(player)
    local playerDataStore = ridge.getPlayerDataStore(player)
    local placeId = playerDataStore:getAsync("placeId")
    if placeId == nil then
        placeId = 7207718284
    end
    return placeId
end
return module