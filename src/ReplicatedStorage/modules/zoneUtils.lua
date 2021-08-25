--[[
    File name: zoneUtils.lua
    Description: utils for the ZonePlus library, for serene
    Author: oldmilk
--]]

local module = {}

module.displayZoneName = function(player, zoneName)
    local currentZone = player.PlayerGui:WaitForChild("gameUi").currentZone
    currentZone.Text = zoneName
    wait(3)
    currentZone.Text = ""
end

return module