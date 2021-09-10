local module = {}
local currency = require(game.ReplicatedStorage:WaitForChild("modules").currency)
-- updatePlayerInfo: Update player info on the playerlist
module.updatePlayerInfo = function(player, key, value)
    
end
-- addPlayerInfo: Add player info to the playerlist
module.addPlayerInfo = function(player)
    local playerIcon, isReady = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    for i, loopPlayer in pairs(game.Players:GetPlayers()) do 
        local template = loopPlayer.PlayerGui:WaitForChild("leaderBoard").Frame.template:Clone()
        template.Name = player.Name
        template.Visible = true
        template.icon.Image = playerIcon
        template.coins.Text = currency.getCoins(player)
        template.Parent = loopPlayer.PlayerGui:WaitForChild("leaderBoard").Frame
    end
    -- load data from datastore
end
-- removePlayerInfo: Remove player info from the playerlist
module.removePlayerInfo = function(player)
    
end

return module