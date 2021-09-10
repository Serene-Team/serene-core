local module = {}	
local InsertService = game:GetService("InsertService")
local sereneMath = require(game.ReplicatedStorage:WaitForChild("modules").math)
local monster = sereneMath.import("monster")
local gameDatabase = require(game.ReplicatedStorage:WaitForChild("modules").gameDatabase)
module.getInfo = function (item)
	local itemInfo = gameDatabase.getItemInfo(item)
	return itemInfo
end
module.loadItem = function (item, location)
	local data = module.getInfo(item)
	if data.error then
		error("Failed to load item: "..data.type)
	else
		local assetId = data.loadId
		local assetItem = InsertService:LoadAsset(assetId):GetChildren()[1]
		assetItem.Parent = location
		return assetItem
	end
end
-- dropItems: drops a list of items with a given drop rate at a part
module.dropItems = function(items, players)
	local itemDrops = nil
	if game.Workspace:FindFirstChild("itemDrops") == nil then
		itemDrops = Instance.new("Folder")	
		itemDrops.Name = "itemDrops"
		itemDrops.Parent = game.Workspace
	else
		itemDrops = game.Workspace:FindFirstChild("itemDrops")
	end
	for index, item in pairs(items) do
		local canDropItem = monster.calculateDropRate(item.drop_chance)
		if canDropItem then
			local player = players[math.random(#players)]
			module.loadItem(index, player.Backpack)	
		end
	end
end

return module
