local module = {}
local ridge = require(game.ReplicatedStorage:WaitForChild("modules").ridge)

local baseStats = {
	statPoints = {
		int = 0,
		str = 0,
		vit = 0,	
	},
	abilityBook = {
		currentClass = "None",
		currentSubclass = "None"
	},
	currentPoints = 0
}

function getStatProfile(player)
	local playerDataStore = ridge.getPlayerDataStore(player)
	local statProfile = playerDataStore:getAsync("statProfile")
	if statProfile == nil then
		return baseStats
	else
		return statProfile
	end
end
function setStatProfile(player, value)
	local playerDataStore = ridge.getPlayerDataStore(player)
	playerDataStore:setAsync("statProfile", value)
end

module.applyStatPoints = function (player)
	local statPoints = getStatProfile(player).statPoints
	for pointName, points in pairs(statPoints) do
		if script.statPoints:FindFirstChild(pointName) == nil then
			warn("Skill point has no active module, skipping.")
		else
			local skillMod = require(script.statPoints[pointName])
			if skillMod["statPointAdded"] == nil then
				warn("Skill point has no statPointAdded event, skipping.")
			else
				skillMod.statPointAdded(player, points)
			end
		end
	end
end
module.getInvestPoints = function (player)
	local statProfile = getStatProfile(player)
	return statProfile.currentPoints
end
module.giveInvestPoints = function (player, num)
	local statProfile = getStatProfile(player)
	statProfile.currentPoints += num
	setStatProfile(player, statProfile)
end
module.addStatPoint = function (player, statType, num)
	local statProfile = getStatProfile(player)
	if statProfile.statPoints[statType] == nil then
		error("Failed to add point to a invalid statType")
	else
		statProfile.statPoints[statType] += num
		statProfile.currentPoints -= num
		setStatProfile(player, statProfile)
		if script.statPoints:FindFirstChild(statType) ~= nil then
			local statModule = require(script.statPoints[statType])
			statModule.statPointAdded(player, statProfile.statPoints[statType])
		end
	end
end
module.getStatPoints = function (player)
	local statProfile = getStatProfile(player)
	return statProfile.statPoints
end

return module