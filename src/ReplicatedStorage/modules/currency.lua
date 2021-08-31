local module = {}
local ridge = require(game.ReplicatedStorage.modules.ridge)
module.giveCoins = function(player, amount)
    local playerDataStore = ridge.getPlayerDataStore(player)        
    local currentCoins = playerDataStore:getAsync("currency")
    if currentCoins == nil then
        currentCoins = 1
    end
    playerDataStore:setAsync("currency", currentCoins + amount)
end
module.getCoins = function(player)
    local playerDataStore = ridge.getPlayerDataStore(player)        
    local currentCoins = playerDataStore:getAsync("currency")
    if currentCoins == nil then
        currentCoins = 0
    end
    return currentCoins
end
module.takeCoins = function(player, amount)
    local playerDataStore = ridge.getPlayerDataStore(player)        
    local coinStore = playerDataStore:getAsync("currency")
    local currentCoins = module.getCoins(player)
    playerDataStore:setAsync("currency", currentCoins - amount)
    return currentCoins - amount
end
return module