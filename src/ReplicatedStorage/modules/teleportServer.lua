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
    local lastPlaceStore = ridge.loadPlayerDatastore("lastPlayerPlace", player)
    lastPlaceStore:setAsync(game.PlaceId)
end
module.getCurrentPlace = function(player)
    local lastPlaceStore = ridge.loadPlayerDatastore("lastPlayerPlace", player)
    local lastPlaceData = lastPlaceStore:getAsync()
    if lastPlaceData == nil then
        lastPlaceData = 7207718284
    end
    return lastPlaceData
end
return module