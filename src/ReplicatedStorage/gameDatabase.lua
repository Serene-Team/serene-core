local database = {}

-- list of all of the in-game loot tables
database.lootTables = {
	guardianMage = {
		loot_data = {
			cookie = { 
				drop_chance = 20
			},
			woodenSword = {
				drop_chance = 5
			}
		},
		loot_xp = 400
	},
	bull = {
		loot_data = {
			cookie =  { 
				drop_chance = 20
			}
		},
		loot_xp = 37
	}
}
-- list of all items in serene, and what shops sell them, and for what price.
-- loadId: the asset id the item will be loaded from
-- name: nothing really, just the name of the item
-- itemId: the id of the item, not used in code
-- shops: a table of shopIds that the item is sold at, and for what price
-- every item should be sold at the admin shop for 1 coin
database.items = {
	cookie = {
		name = "Cookie",
		itemId = "cookieItem",
		loadId = 7234916884,
		icon = 7335856220,
		shops = {
			johnAshtown = 20,
			adminShop = 1
		}
	},
	woodenSword = {
		name = "Wooden Sword",
		itemId = "woodenSword",
		loadId = 7312327359,
		icon = 7254489223,
		shops = {
			johnAshtown = 15,
			adminShop = 1
		}
	},
	healthPotion = {
		name = "Health Potion",
		itemId = "healthPotion",
		loadId = 7464532589,
		icon = 7464730973,
		shops = {
			johnAshtown = 60,
			adminShop = 1
		}
	}
}

database.server = {
	-- startupConfig: runs when ever the server starts or when ever the database is re-installed
	startupConfig = function()
		print("Hello, World!")
	end
}
return database
