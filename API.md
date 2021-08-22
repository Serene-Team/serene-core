# Serene API
The serene API docs

## Item storage
The items API route

## Get item info
```
https://serene-api.herokuapp.com/item/[item]
```


## Teleport
Example:
```lua
local teleport = ...
local playerTeleport = teleportMod.new(game.Players.OtherLuaDeveloper)
-- Client Only:
playerTeleport:TeleportAsync({
    placeId = 1233333,
    extraTeleport = {
        -- default
        example = "Bob"
    }
})
-- Server Only:
playerTeleport:Teleport(Vector3.new(0, 0, 0))
```