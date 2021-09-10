for i, player in pairs(game.Players:GetPlayers()) do
    require(game.ReplicatedStorage.modules.item).loadItem("cookie", player.Backpack)
end