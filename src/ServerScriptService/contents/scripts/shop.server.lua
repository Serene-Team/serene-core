local shop = require(game.ReplicatedStorage.modules.shop)
print("loading shops")

local adminShop = shop.register({
    -- not seen by the user
    id = "adminShop",
    -- seen by the user
    name = "The Admin NPC Shop"
})
adminShop:addItem({
    -- not seen by the user
    id = "appleItemAdminNpc",
    name = "A fresh apple!",
    -- price for the item
	price = 100,
	-- item id to use
	itemId = 21571150
})