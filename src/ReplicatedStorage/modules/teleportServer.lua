--[[
    File name: teleportServer.lua
    Description: server interface for the teleport system
    Author: oldmilk
--]]

local module = {}

module.teleportPlayer = function(player, placeId, extraTeleports)
    game.ReplicatedStorage:WaitForChild("events"):WaitForChild("teleportPlayer"):FireClient(player, placeId, extraTeleports)
end

return module