--[[
    File name: questManager.server.lua
    Description: all place server sided quest code for serene
    Author: oldmilk
--]]

local quest = require(game.ReplicatedStorage:WaitForChild("modules").quest)

game.Players.PlayerAdded:Connect(function(player)
    quest.loadQuestData(player)
end)