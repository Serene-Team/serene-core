local module = {}
local dataStore = require(game.ReplicatedStorage.DataStore2)
local characterSlot = require(game.ReplicatedStorage.modules.characterSlot)
module.giveCoins = function(player, amount)
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    local coinStore = dataStore("playerCoinStore"..currentSlot, player)
    local currentCoins = coinStore:Get(0)
    coinStore:Set(currentCoins + amount)
    return currentCoins + amount
end
module.getCoins = function(player)
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    local coinStore = dataStore("playerCoinStore"..currentSlot, player)
    local currentCoins = coinStore:Get(0)
    return currentCoins
end
module.takeCoins = function(player, amount)
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    local coinStore = dataStore("playerCoinStore"..currentSlot, player)
    local currentCoins = coinStore:Get(0)
    coinStore:Set(currentCoins - amount)
    return currentCoins - amount
end
return module