local vit = {}

-- statPointAdded is fired with the amount of points the player has.
vit.statPointAdded = function (player, amount)
	local character = game.Workspace:WaitForChild(player.Name)
	local humanoid = character:WaitForChild("Humanoid")
	local healthPerPoint = 20
	local maxHealth = healthPerPoint * amount
	-- reset everything before we apply the data
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	-- apply the data
	humanoid.MaxHealth += maxHealth
	humanoid.Health += maxHealth - 5
end

return vit