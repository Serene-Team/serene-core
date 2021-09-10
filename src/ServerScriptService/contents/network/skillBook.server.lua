-- NOTE: This script is used for the skill book, and the stat book
local network = require(game.ReplicatedStorage:WaitForChild("modules").network)
local playerStats = require(game.ReplicatedStorage:WaitForChild("modules").playerStat)
network.remotefunction("getStatPoints", function (player)
	return playerStats.getStatPoints(player)
end)
network.remotefunction("investPoint", function (player, statType)
	local points = playerStats.getInvestPoints(player)
	if points == 0 then
		return "NoPointsLeft"
	else
		playerStats.addStatPoint(player, statType, 1)
	end
end)
network.remotefunction("getUsablePoints", function (player)
	return playerStats.getInvestPoints(player)
end)