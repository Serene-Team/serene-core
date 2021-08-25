local teleport = {}
local teleportService = game:GetService("TeleportService")
local runService = game:GetService("RunService")
local marketplace = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer
if runService:IsServer() then
    error("the teleport module is client only, for a server side version look at teleportServer.")
end
local placeDesc = {
    ["Serene"] = "Ah yes! The main menu!",
    ["Ashtown"] = "A great place to start!"
}
local placeIcons = {
    ["Serene"] = "rbxassetid://7193700987",
    ["Ashtown"] = "rbxassetid://7321958897"
}


teleport.teleportAsync = function(placeId, extraTeleportOptions)
    print("-- teleport client start --")
    -- clone uis
    print("awaiting teleportUi clone.")
    local teleportUi = game.ReplicatedStorage:WaitForChild("gui"):WaitForChild("teleportUi"):Clone()
    -- load teleport info
    print("loading place travel info")
    local teleportInfo = marketplace:GetProductInfo(placeId)
    if teleportInfo["Name"] == nil then
        teleportUi.Parent = player.PlayerGui
        teleportUi.Frame.title.Text = "Error!"
        teleportUi.Frame.title.Text = "failed to load teleport info!"
        error("Failed to load teleport info.")
    end
    print("updating teleportUi")
    teleportUi.Frame.title.Text = teleportInfo.Name
    if placeDesc[teleportInfo.Name] ~= nil then
        teleportUi.Frame.desc.Text = placeDesc[teleportInfo.Name]
    else
        teleportUi.Frame.desc.Text = "Serene: created by @oldmilk"
    end
    if placeIcons[teleportInfo.Name] ~= nil then
        teleportUi.Frame.bgImage.Image = placeIcons[teleportInfo.Name]
    end
    print("loading teleportUi")
    teleportUi.Parent = player.PlayerGui
    print("updating teleport settings")
    teleportService:SetTeleportGui(teleportUi)
    print("adding teleportOptions")
    local teleportOptions = Instance.new("TeleportOptions")
    teleportOptions:SetTeleportData({
        lastPlaceId = game.PlaceId,
        lastPlaceName = marketplace:GetProductInfo(game.PlaceId).Name,
        extraOptions = extraTeleportOptions
    })
    print("teleport is ready to start.")
    print("teleport started.")
    teleportService:Teleport(placeId, game.Players.LocalPlayer, teleportOptions)
end

return teleport