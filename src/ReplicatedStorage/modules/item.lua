local module = {}	
local http = game:GetService("HttpService")
local insert = game:GetService("InsertService")
local sereneMath = require(game.ReplicatedStorage.modules.math)
local monster = sereneMath.import("monster")
module.getInfo = function (item)
	local rawData = http:GetAsync("http://serene-api.herokuapp.com/item/"..item)
	local info = http:JSONDecode(rawData)
	return info
end
module.loadItem = function (item, location)
	local data = module.getInfo(item)
	if data.error then
		error("Failed to load item: "..data.type)
	else
		data = data.data
		local assetId = data.loadId
		local assetItem = insert:LoadAsset(assetId):GetChildren()[1]
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
			print("dropped: "..index.." into "..player.Name.."'s backpack")
			local itemAsset = module.loadItem(index, player.Backpack)
		end
	end
end

return module
