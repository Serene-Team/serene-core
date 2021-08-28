# Serene API
The serene API docs

## Item storage
The items API route

## Get item info
```
https://serene-api.herokuapp.com/item/[item]
```

## DataStore
Serene uses a datastore module called ridge, heres some example code:

### Set data
```lua
local ridge = ...
local coinStore = ridge.loadPlayerDatastore("coinStore", game.Players.OtherLuaDeveloper)
-- data is put into cache, when the player leaves we save the data in cache to roblox datastores
coinStore:setAsync(100)
```

## Quest
```lua
local quest = ...
quest:getQuestInfo("maryQuest")
```