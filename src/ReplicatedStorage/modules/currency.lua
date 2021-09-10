local module = {}
local ridge = require(game.ReplicatedStorage:WaitForChild("modules").ridge)
module.giveCoins = function(player, amount)
    local playerDataStore = ridge.getPlayerDataStore(player)        
    local currentCoins = playerDataStore:getAsync("currency")
    if currentCoins == nil then
        currentCoins = 1
    end
    if shared[player.UserId.."_currency_callback"] ~= nil then
        shared[player.UserId.."_currency_callback"](amount, "added")
    end
    playerDataStore:setAsync("currency", currentCoins + amount)
end
module.currencyUpdated = function(player, callback)
    if player:GetAttribute("hasCurrencyUpdatedListener") == nil then
        player:SetAttribute("hasCurrencyUpdatedListener", true)
        shared[player.UserId.."_currency_callback"] = callback
    else
        warn("Failed to subscribe to event: event already listening")
    end
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
    local currentCoins = module.getCoins(player)
    playerDataStore:setAsync("currency", currentCoins - amount)
    if shared[player.UserId.."_currency_callback"] ~= nil then
        shared[player.UserId.."_currency_callback"](amount, "taken")
    end
    return currentCoins - amount
end
return module