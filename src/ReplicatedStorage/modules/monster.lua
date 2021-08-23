--[[
    File name: monster.lua
    Description: create serene monster/enemys
    Author: oldmilk
--]]

-- import services
local pathfindingService = game:GetService("PathfindingService")
local insertService = game:GetService("InsertService")
local httpService = game:GetService("HttpService")
local item = require(game.ReplicatedStorage.modules.item)
local levels = require(game.ReplicatedStorage.modules.levels)
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
		item.dropItems(loot_data.data.loot_data, players)
		-- give xp, and remove tags
		for i, player in pairs(players) do
			levels.grantXp(player, loot_data.data.loot_xp)
			if player:GetAttribute("Damage") ~= nil then
				player:SetAttribute("Damage", nil)
			end
		end
		root.Parent:Destroy()
	end)
end
-- pathfindToPosition: pathfind to a 3D position in the world
function monsterClass:pathfindToPosition(fromPos, toPos, enableDynamic)
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
-- getValue: get a value in the monster config
function monsterClass:getValue(key)
	local root = self.root
	local config = nil
	if root.Parent:FindFirstChildOfClass("Configuration") == nil then
		error("Failed to read value: config not found in model")
	else
		config = root.Parent:FindFirstChildOfClass("Configuration")
		if config.Name ~= "EnemyConfig" then
			warn("Default config name should be EnemyConfig")
		end
	end
	-- get value
	local value = nil
	if config:FindFirstChild(key) == nil then
		warn("Failed to read value: key not found in config")
		return "NoValue"
	else
		return config:FindFirstChild(key).Value
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

-- register: return a new monsterClass
module.register = function(root)
	local self = {
		root = root
	}
	setmetatable(self, monsterClass)
	return self
end
-- https://devforum.roblox.com/t/how-can-i-get-a-random-position-located-through-the-size-of-the-part/253540/6
function getRandomInPart(part)
	local random = Random.new()
	local randomCFrame = part.CFrame * CFrame.new(random:NextNumber(-part.Size.X/2,part.Size.X/2), random:NextNumber(-part.Size.Y/2,part.Size.Y/2), random:NextNumber(-part.Size.Z/2,part.Size.Z/2))
	return randomCFrame
end
-- spawnEntity: spawns a new instance of a monster
module.spawnEntity = function (spawnPlace, entityId)
	--7214764565
	if game.Workspace.spawnStorage:FindFirstChild(entityId) == nil then
		local inst = Instance.new("Folder")
		inst.Name = tostring(entityId)
		inst.Parent = game.Workspace.spawnStorage
	end
	local mob = insertService:LoadAsset(tonumber(entityId))
	mob.Parent = game.Workspace.spawnStorage[entityId]
	-- calc position to spawn
	local pos = getRandomInPart(spawnPlace)
	mob:MoveTo(pos.Position)
end
-- getLootInfo: returns the loot info for a monster from the REST api
function module.getLootInfo(monster)
	local rawData = httpService:GetAsync("http://serene-api.herokuapp.com/loot_table/"..monster)
	local info = httpService:JSONDecode(rawData)
	return info
end

return module