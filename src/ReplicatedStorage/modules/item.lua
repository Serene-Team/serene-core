local module = {}	
local http = game:GetService("HttpService")
local insert = game:GetService("InsertService")
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
		local asset = insert:LoadAsset(assetId)
		asset:GetChildren()[1].Parent = location
		return asset
	end
end
return module
