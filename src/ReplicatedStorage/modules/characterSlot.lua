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
return module