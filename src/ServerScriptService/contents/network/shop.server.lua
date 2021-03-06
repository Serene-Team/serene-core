local network = require(game.ReplicatedStorage:WaitForChild("modules").network)
local itemModule = require(game.ReplicatedStorage:WaitForChild("modules").item)
local currency = require(game.ReplicatedStorage:WaitForChild("modules").currency)
network.remotefunction("confirmPurchase", function (player, item, shopId, amount)
	-- lookup item info
	local itemInfo = itemModule.getInfo(item)
	local shops = itemInfo.shops
	if shops[shopId] == nil then
		warn("Failed to confirm purchase: item not sold at current shop, database out of date?")
		return "fail"
	end
	print("confirming purchase...")
	local itemAmount = 1
	if amount ~= nil then
		if amount ~= 0 then
			itemAmount = amount
		end
	end
	local currentShopPrice = shops[shopId]
	local playerCoins = currency.getCoins(player)
	if (currentShopPrice * itemAmount) > playerCoins then
		warn("Failed to confirm purchase: not enough money!")
		return "NotEnoughMoney"
	end
	local tickCounter = 1
	currency.takeCoins(player, (currentShopPrice * itemAmount))
	while true do
		itemModule.loadItem(item, player.Backpack)
		if tickCounter == itemAmount then
			break
		end
		tickCounter += 1
	end
	print("purchase confirmed!")
end)