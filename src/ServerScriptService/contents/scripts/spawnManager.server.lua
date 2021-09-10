local collectionService = game:GetService("CollectionService")
local insert = game:GetService("InsertService")
-- https://devforum.roblox.com/t/how-can-i-get-a-random-position-located-through-the-size-of-the-part/253540/6
function getRandomInPart(part)
	local random = Random.new()
	local randomCFrame = part.CFrame * CFrame.new(random:NextNumber(-part.Size.X/2,part.Size.X/2), random:NextNumber(-part.Size.Y/2,part.Size.Y/2), random:NextNumber(-part.Size.Z/2,part.Size.Z/2))
	return randomCFrame
end
print("loading server spawn manager cleanup proccess...")
local cleanup = coroutine.create(function ()
	while true do
		wait(5)
		for i, item in pairs(game.Workspace:WaitForChild("spawnStorage"):GetDescendants()) do
			if item:IsA("Model") then
				local innerCount = #item:GetChildren()
				if innerCount == 0 then
					item:Destroy()
				end
			end
		end
	end
end)
coroutine.resume(cleanup)
print("loading server spawn manager...")
-- configure this table for new mobs
local mobSpawns = {
    bull = collectionService:GetTagged("BullSpawn"),
    forestMage = collectionService:GetTagged("ForestMageSpawn")
}
local mobIds = {
    bull = 7214764565,
	forestMage = 7384742784
}
local tick = 5
-- every tick, we spawn new mobs at areas that need them
local enableSpawnInstance = game.ServerStorage:FindFirstChild("enableMobSpawn")
local enableSpawn = true
if enableSpawnInstance ~= nil then
    enableSpawn = enableSpawnInstance.Value    
end
function spawnMob(mobName, instances)
    if game.Workspace:FindFirstChild("spawnStorage") == nil then
        warn("creating spawn storage in studio is recommened.")
        local spawnStorage = Instance.new("Folder")
        spawnStorage.Name = "spawnStorage"
        spawnStorage.Parent = game.Workspace
    end
    local spawnStorage = game.Workspace:FindFirstChild("spawnStorage")
    if spawnStorage:FindFirstChild(mobName) == nil then
        local folder = Instance.new("Folder")
        folder.Name = mobName
        folder.Parent = game.Workspace.spawnStorage
    end
    for mobIndex, instance in pairs(instances) do
        local spawnLimit = instance:FindFirstChild("maxLimit")
        if spawnLimit == nil then
            spawnLimit = 15
        else
            spawnLimit = spawnLimit.Value
        end
        local mobStore = spawnStorage[mobName]:FindFirstChild(tostring(mobIndex))
        if mobStore == nil then
            local inst = Instance.new("Folder")
            inst.Name = tostring(mobIndex)
            inst.Parent = spawnStorage[mobName]
            mobStore = inst
        end
        local currentSpawns = #mobStore:GetChildren()
        if currentSpawns >= spawnLimit then
            print("not spawning: max limit reached.")
        else
            -- spawn mob
            if mobIds[mobName] == nil then
                warn("not spawning "..mobName..": asset id not found.")
            else
                local insertItem = insert:LoadAsset(mobIds[mobName])
                local mobModel = insertItem:GetChildren()[1]
                insertItem.Parent = mobStore
                mobModel:MoveTo(getRandomInPart(instance).Position)
            end
        end
    end
end
while enableSpawn do
    -- don't use wait, might migrate the reset of the codebase over to using task.wait soon
    task.wait(tick)
    for mobName, mobInstances in pairs(mobSpawns) do
        spawnMob(mobName, mobInstances)
    end
end