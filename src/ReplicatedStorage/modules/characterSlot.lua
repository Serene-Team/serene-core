--[[
    File: characterSlot.lua
    Description: Update a Character Slot for a player
--]]

local module = {}
local datastore = require(game.ReplicatedStorage.DataStore2)
-- getPlayerCharacterSlotid: Get current player slot id
module.getPlayerCharacterSlotid = function(player)
    local characterSlotStore = datastore("currentPlayerCharacterSlot", player)
    local currentCharacterSlot = characterSlotStore:Get(nil)
    if currentCharacterSlot == nil then
        warn("Failed to find current character slot: got nil")
        return nil
    else
        return currentCharacterSlot    
    end
end
-- updateSlotId: update a players current slot id
module.updateSlotId = function(player, slotId)
    local characterSlotStore = datastore("currentPlayerCharacterSlot", player)
    -- update the slotid to the id given
    characterSlotStore:Set(slotId)
    -- return the slotId
    return slotId
end
-- getLastPlace: get the last place a players character slot was in
module.getLastPlace = function(player)
    local currentSlot = module.getPlayerCharacterSlotid(player)
    if currentSlot == nil then
        warn("Failed to perform getLastPlace: Character slot is nil, assuming slot id is 1")
        currentSlot = 1
    end
    local lastPlaceStore = datastore("lastPlayerPlace"..currentSlot, player)
    return lastPlaceStore:Get(7193015497)
end
return module