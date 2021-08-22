local teleport = {}
local teleportService = game:GetService("TeleportService")
local marketplace = game:GetService("MarketplaceService")
local placeDesc = {
    ["Serene"] = "Ah yes! The main menu!",
    ["Ashtown"] = "A great place to start!"
}
local placeIcons = {
    ["Serene"] = "rbxassetid://7193700987",
    ["Ashtown"] = ""
}
teleport.setDepartArgs = function(player)
    local teleportOptions = Instance.new("TeleportOptions")
    teleportOptions.Parent = player
    local departArgs = {
        lastPlace = game.PlaceId
    }
    teleportOptions:SetTeleportData(departArgs)
end
teleport.getTeleportArgs = function()
    return teleportService:GetLocalPlayerTeleportData()
end
teleport.teleportAsync = function(placeId)
    -- prep data
    local placeName = marketplace:GetProductInfo(placeId).Name
    local teleportUi = game.ReplicatedFirst.gui:WaitForChild("teleportUi"):Clone()
    teleportUi.Parent = game.Players.LocalPlayer.PlayerGui
    teleportUi.Frame.title.Text = placeName
    teleportUi.Frame.desc.Text = placeDesc[placeName]
    teleportService:SetTeleportGui(teleportUi)
    teleportService:Teleport(placeId, game.Players.LocalPlayer)
end

return teleport