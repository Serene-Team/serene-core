local network = require(game.ReplicatedStorage:WaitForChild("modules").network)
local playerStats = require(game.ReplicatedStorage:WaitForChild("modules").playerStat)
local playerModule = require(game.ReplicatedStorage:WaitForChild("modules").player)

-- empty event for the client
network.event("playLocalSound", function()
    
end)
network.event("teleportPlayer", function()
    
end)
network.event("addPlayer", function (player)
	if player:GetAttribute("hasBeenAdded") == nil then
		playerModule.playerForceAdd(player)
	end
end)
-- empty event for the client
network.event("playLocalSoundEffect", function()
	
end)
network.remotefunction("computeItemInfoForPlayer", function (player, tool)
	-- Get damage config from tool
	local maxDamage = tool:GetAttribute("damageMax")
	local minDamage = tool:GetAttribute("damageMax")
	if tool:GetAttribute("isForgeWeapon") ~= nil then
		if maxDamage == nil then
			maxDamage = 10
		end
		if minDamage == nil then
			minDamage = 1
		end
		-- Get stat points for player
		local strPoints = playerStats.getStatPoints(player).str
		maxDamage = maxDamage * strPoints
		return {
			minDamage = minDamage,
			maxDamage = maxDamage,
			computedFromStr = strPoints
		}
	else
		return {
			error = "NotWeapon"
		}
	end
end)