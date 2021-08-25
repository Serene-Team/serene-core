--[[
    File name: teleportServer.lua
    Description: server interface for the teleport system
    Author: oldmilk
--]]

local module = {}
local characterSlot = require(game.ReplicatedStorage.modules.characterSlot)
local dataStore = require(game.ReplicatedStorage.DataStore2)
module.teleportPlayer = function(player, placeId, extraTeleports)
    game.ReplicatedStorage:WaitForChild("events"):WaitForChild("teleportPlayer"):FireClient(player, placeId, extraTeleports)
end
module.saveCurrentPlace = function(player)
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    if currentSlot == nil then
        warn("Failed to perform getLastPlace: Character slot is nil, assuming slot id is 1")
        currentSlot = 1
    end
    local lastPlaceStore = dataStore("lastPlayerPlace"..currentSlot, player)
    lastPlaceStore:Set(game.PlaceId)
end
module.getCurrentPlace = function(player)
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    if currentSlot == nil then
        warn("Failed to perform getLastPlace: Character slot is nil, assuming slot id is 1")
        currentSlot = 1
    end
    local lastPlaceStore = dataStore("lastPlayerPlace"..currentSlot, player)
    return lastPlaceStore:Get(7207718284)
end
return module