--[[
    File name: monster.lua
    Description: create serene monster/enemys
    Author: oldmilk
--]]

-- import services
local pathfindingService = game:GetService("PathfindingService")
local tweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local item = require(game.ReplicatedStorage:WaitForChild("modules").item)
local levels = require(game.ReplicatedStorage:WaitForChild("modules").levels)
local gameDatabase = require(game.ReplicatedStorage:WaitForChild("modules").gameDatabase)
-- init module
local module = {}
local monsterClass = {}
monsterClass.__index = monsterClass
monsterClass.root = nil
monsterClass.config = {}
-- internal functions
local function GetNearestPlayer(minimumDistance, NPC)
	local closestMagnitude = minimumDistance or math.huge
	--minimumDistance is a number in studs
	local closestPlayer
	for i,v in next, game.Players:GetPlayers() do
		local Character = v.Character
		if (Character) then
			local humanoid = Character.Humanoid
			if Character:FindFirstChild("HumanoidRootPart") ~= nil then
				local HRP = Character.HumanoidRootPart
				if (humanoid.Health > 0) then
					local mag = (NPC.Position - HRP.Position).Magnitude
					if (mag <= closestMagnitude) then
						closestPlayer = v
						closestMagnitude = mag
					end
				end
			end
		end
	end
	return closestPlayer
end
-- findNearestPlayer: find the nearest player to the enemy root
function monsterClass:findNearestPlayer()
	-- the root part of the enemy
	local enemyRoot = self.root
	local target = GetNearestPlayer(70, enemyRoot)
	-- return the target
	return target
end
-- setReward: set the exp and loot table reward data, takes in the mob id for the loot
function monsterClass:setReward(loot_table)
	local root = self.root
	if root.Parent:FindFirstChildOfClass("Humanoid") == nil then
		error("Failed to set reward: monster must have a humanoid!")
	end
	local humanoid = root.Parent:FindFirstChildOfClass("Humanoid")
	-- fetch the loot data
	local loot_data = module.getLootInfo(loot_table)
	humanoid.Died:Connect(function ()
		-- get all of the players that killed the mob
		local players = {}
		for index, player in pairs(root.Parent.killers:GetChildren()) do
			if game.Players[player.Value] ~= nil then
				table.insert(players, game.Players[player.Value])
			end
		end
		-- drop the items
		item.dropItems(loot_data.loot_data, players)
		-- give xp, and remove tags
		for i, player in pairs(players) do
			levels.grantXp(player, loot_data.loot_xp)
			if player:GetAttribute("Damage") ~= nil then
				player:SetAttribute("Damage", nil)
			end
		end
		root.Parent:Destroy()
	end)
end
-- pathfindToPosition: pathfind to a 3D position in the world
function monsterClass:pathfindToPosition(fromPos, toPos)
	local root = self.root
	-- prevent @oldmilk from being stupid when making stuff
	if fromPos == nil or toPos == nil then
		error("Failed to init pathfind: fromPos or toPos is missing or nil")
	end
	-- K, we good now.
	
	-- how do I use this again?
	--  - @oldmilk, 2021 sometime in the moring
	-- docs link for reference: https://developer.roblox.com/en-us/articles/Pathfinding
	local agent = pathfindingService:CreatePath({
		-- no, you cannot jump :)
		AgentCanJump = false
	})
	-- compute the path with ComputeAsync
	agent:ComputeAsync(fromPos, toPos)
	-- get the path waypoints
	local waypoints = agent:GetWaypoints()
	-- check for humanoid
	local humanoid = nil
	if root.Parent:FindFirstChildOfClass("Humanoid") == nil then
		error("Failed to pathfind: failed to find humanoid")
	else
		humanoid = root.Parent:FindFirstChildOfClass("Humanoid")
	end
	for _, waypoint in pairs(waypoints) do
		-- move humanoid
		humanoid:MoveTo(waypoint.Position)
	end
end
-- onTouch: listen for when the player touches the enemy
function monsterClass:onTouch(renderMesh, callback) 
	renderMesh.Touched:Connect(function (hit)
		local player = nil
		if game.Players:GetPlayerFromCharacter(hit.Parent) ~= nil then
			player = game.Players:GetPlayerFromCharacter(hit.Parent)
			callback(player)
		end
	end)
	
end
--playAnimation: player an animation for the current mob
function monsterClass:playAnimation(animationId)
	local animator = nil
	local enemyRoot = self.root
	local humanoid = enemyRoot.Parent:FindFirstChildOfClass("Humanoid")
	if humanoid == nil then
		error("Failed to play animation: humanoid is nil")
	end
	if humanoid:FindFirstChildOfClass("Animator") == nil then
		animator = Instance.new("Animator")	
		animator.Parent = humanoid
	else
		animator = humanoid:FindFirstChildOfClass("Animator")
	end
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://"..animationId
	local track = animator:LoadAnimation(animation)
	track:Play()
	return track
end
--onWalk: listen for when the mob starts walking
function monsterClass:onWalk(callback)
	local enemyRoot = self.root
	local humanoid = enemyRoot.Parent:FindFirstChildOfClass("Humanoid")
	if humanoid == nil then
		error("Failed to connect to event: humanoid is nil")
	end
	humanoid.Running:Connect(function(speed)
		callback(speed)
	end)
end
-- onAttackTick: listen for the attack tick event
function monsterClass:onAttackTick(callback)
	-- TODO: Get it working
end
-- register: return a new monsterClass
module.register = function(root)
	local self = {
		root = root
	}
	setmetatable(self, monsterClass)
	-- setup basic stuff
	local baseHealthBar = game.ReplicatedStorage:WaitForChild("gui"):WaitForChild("healthBarRoot")
	local healthBar = baseHealthBar:Clone()
	healthBar.Parent = root
	-- setup
	local humanoid = root.Parent:FindFirstChildOfClass("Humanoid")
	if humanoid == nil then
		error("Failed to setup: monster must have a valid humanoid")
	else
		humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		healthBar.healthTxt.Text = "Health: "..math.round(humanoid.Health).."/"..humanoid.MaxHealth
		humanoid.HealthChanged:Connect(function()
			local health = humanoid.Health/humanoid.MaxHealth
			local info = TweenInfo.new(humanoid.Health / humanoid.MaxHealth) --Tween Info
			healthBar.healthTxt.Text = "Health: "..math.round(humanoid.Health).."/"..humanoid.MaxHealth
			tweenService:Create(healthBar.Frame.health,info,{Size = UDim2.new(health, 0, 0, 100)}):Play() -- Create The Tween Then Play It
		end)
	end
	return self
end
-- getLootInfo: returns the loot info for a monster from the game database
function module.getLootInfo(monster)
	local info = gameDatabase.getLootTable(monster)
	return info
end

return module