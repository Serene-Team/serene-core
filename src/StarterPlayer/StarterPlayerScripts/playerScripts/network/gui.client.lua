local updateXpBar = game.ReplicatedStorage.events:WaitForChild("updateXpBar")
local gui = require(game.ReplicatedStorage:WaitForChild("modules").client.gui)
local makeChatMessage = game.ReplicatedStorage.events:WaitForChild("makeChatMessage")
local sendItemAlert = game.ReplicatedStorage.events:WaitForChild("sendItemAlert")
local currencyAlert = game.ReplicatedStorage.events:WaitForChild("sendCurrencyAlert")
updateXpBar.OnClientEvent:Connect(function(xp, currentLevel)
    gui.setXpBarData(currentLevel, xp)
end)
makeChatMessage.OnClientEvent:Connect(function(message, textColor, textSize)
    gui.printChatMessage(message, textColor, textSize)
end)
sendItemAlert.OnClientEvent:Connect(function(itemName)
    gui.showItemAlert(itemName)
end)
currencyAlert.OnClientEvent:Connect(function(currency, eventType)
    print(eventType)
    if eventType == "taken" then
        gui.showCurrencyAlert(currency, true)     
    else
        gui.showCurrencyAlert(currency, false)    
    end
end)