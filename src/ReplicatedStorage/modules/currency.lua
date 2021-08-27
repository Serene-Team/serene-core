local module = {}
local ridge = require(game.ReplicatedStorage.modules.ridge)
module.giveCoins = function(player, amount)
    local coinStore = ridge.loadPlayerDatastore("playerCoinStore", player)
    local currentCoins = coinStore:getAsync(0)
    coinStore:setAsync(currentCoins + amount)
    return currentCoins + amount
end
module.getCoins = function(player)
    local coinStore =  ridge.loadPlayerDatastore("playerCoinStore", player)
    local currentCoins = coinStore:getAsync()
    print(currentCoins)
    if currentCoins == nil then
        currentCoins = 0
    end
    print(currentCoins)
    return currentCoins
end
module.takeCoins = function(player, amount)
    local coinStore =  ridge.loadPlayerDatastore("playerCoinStore", player)
    local currentCoins = module.getCoins(player)
    coinStore:setAsync(currentCoins - amount)
    return currentCoins - amount
end
return module