--[[
    File name: extra.lua
    Description: extra utils
    Author: oldmilk
--]]

local module = {}

module.makeChatMessageGlobal = function(message, textColor, textSize)
    game.ReplicatedStorage.events:WaitForChild("makeChatMessage"):FireAllClients(message, textColor, textSize)
end
module.makeChatMessage = function(player, message, textColor, textSize)
    game.ReplicatedStorage.events:WaitForChild("makeChatMessage"):FireClient(player, message, textColor, textSize)
end

return module