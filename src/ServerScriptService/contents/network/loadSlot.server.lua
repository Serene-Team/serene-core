local network = require(game.ReplicatedStorage.modules.network)
local slot = require(game.ReplicatedStorage.modules.characterSlot)
network.event("loadCharacterSlot", function(player, characterSlotId)
    print("Update: Slot id")
    slot.updateSlotId(player, characterSlotId)
    print("Load: character data")
    local lastPlace = slot.getLastPlace(player)
end)
-- create a empty event for the client
network.event("teleportPlayerToPlace", function(player, placeId)
    
end)