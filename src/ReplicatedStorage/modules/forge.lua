--[[
    File name: forge.lua
    Description: weapon system, this SHOULD NOT be used for items. For items look at "pine"
    Author: oldmilk
--]]

local forge = {}

-- defaults
local forgeDefaults = {
    defaultDamage = {
        min = 10,
        max = 30
    }
}
local playerStats = require(game.ReplicatedStorage:WaitForChild("modules").playerStat)
-- core functions

-- loadAnimation: loads an animation onto the players humanoid, and returns the animation track
function loadAnimation(player, id)
    -- check for animator
    local animator = nil
    if player.Character.Humanoid:FindFirstChildOfClass("Animator") == nil then
        animator = Instance.new("Animator")
    else
        animator = player.Character.Humanoid:FindFirstChildOfClass("Animator")
    end
    -- build animation
    local animationBuild = Instance.new("Animation")
    animationBuild.AnimationId = "rbxassetid://"..id
    -- load the animation
    local animationTrack = animator:LoadAnimation(animationBuild)
    return animationTrack
end


local forgeClass = {}
forgeClass.__index = forgeClass
forgeClass.config = {}
forgeClass.tool = nil
-- getValue: get a value from inside the config
function forgeClass:getValue(key)
    local config = self.config
    if config[key] == nil then
        warn("key not found in config table.")
        return nil
    else
        return config[key]
    end
end
-- setValue: set a value inside of the config
function forgeClass:setValue(key, value)
    if self.config[key] ~= nil then
		warn("data overwrited.")	
    end
    self.config[key] = value
end

-- swing: swing the tool
function forgeClass:swing()
    -- prep everything before we do any tool animations/damage
    -- check for the player
    if self:getValue("owner") == nil then
        error("Failed to swing: owner of tool is nil!")
    end
    local player = self:getValue("owner")
    -- look for the swing animation
    local config = self.config
    local animations = self:getValue("animations")
    if animations == nil then
        warn("no tool animations found in config.")
    end
    -- check for damage config
    local damageConfig = self:getValue("damage")
    if damageConfig == nil then
        warn("damageConfig is nil, using default value")
        damageConfig = forgeDefaults.defaultDamage
    end
    -- look for the handle in the tool
    local tool = self.tool
    if tool:FindFirstChild("Handle") == nil then
        error("The weapon must have a handle, for items please use pine.")
    end
	-- play animations
	if tool:GetAttribute("coolDownEnabled") == nil then
		tool:SetAttribute("coolDownEnabled", true)
	else
		return
	end
    if animations ~= nil then 
        local track = loadAnimation(player, animations[forge.enums.animationTypes.ItemUse])
        track:Play()
	end
	local currentStats = playerStats.getStatPoints(player)
	local strPoints = currentStats.str
	local damagePerPoint = 6
	local damageAdd = strPoints * damagePerPoint
	-- do da math
    -- NOTE: Only boost the min damage, cause if we boost the max then any weapon can become OP
	local minDamage = damageConfig.min + damageAdd
    -- Prevent bug
    if (damageConfig.min + damageAdd) > damageConfig.max then
        minDamage = damageConfig.max - 1
    end
    local maxDamage = damageConfig.max
    -- check if server pvp is enabled.
    local serverPvpEnabled = game.ServerStorage:FindFirstChild("pvpEnabled")
    -- calculate the damage in the range of maxDamage, and minDamage
	local damageCalc = math.random(minDamage, maxDamage)
    local toolConnect = tool.Handle.Touched:Connect(function (hit)
        -- check if the thing we hit has a humanoid
        if hit.Parent:FindFirstChildOfClass("Humanoid") ~= nil then
            -- pvp checks
            local hitPlayer = game.Players:GetPlayerFromCharacter(hit.Parent)
            if hitPlayer ~= nil then
                if serverPvpEnabled ~= nil then
                    hitPlayer.Character.Humanoid:TakeDamage(damageCalc)
                else
                    warn("global pvp is disabled, to enable it create a item inside of ServerStorage named 'pvpEnabled'")
                end
			else
				tool:SetAttribute("coolDownEnabled", true)
				local killers = hit.Parent:FindFirstChild("killers")
				if killers == nil then
					killers = Instance.new("Folder")
					killers.Name = "killers"
					killers.Parent = hit.Parent
				end
				if killers:FindFirstChild(player.Name) == nil then
					local killerTag = Instance.new("StringValue")
					killerTag.Name = player.Name
					killerTag.Value = player.Name
					killerTag.Parent = killers
				end
				hit.Parent.Humanoid:TakeDamage(damageCalc)
            end
        end
	end)
	task.wait(0.1)
    -- give some time for the player to hit the target
	tool:SetAttribute("coolDownEnabled", nil)
    -- remove the event from memory
    toolConnect:Disconnect()
end
forge.enums = {}
forge.enums.animationTypes = {
    ["Idle"] = "AnimationIdle",
    ["ItemUse"] = "AnimationUse"
}
-- register: returns a new instance of the forge class
forge.register = function(tool)
    local self = {
        tool = tool
    }
    setmetatable(self, forgeClass)
    return self
end

return forge