--[[
    File name: init.lua
    Description: main module code for ridge
    Author: oldmilk
--]]

local module = {}
local dataStoreService = game:GetService("DataStoreService")
-- class declaration
local class = {}
class.__index = class
class.dataStoreName = nil
class.player = nil

-- services

-- core functions
function getPlayerProfile(player)
    return dataStoreService:GetDataStore("profile_"..player.UserId)
end
function createCache(player)
    shared["ridgeProfile_"..player.UserId] = {

    }
end
function forceUpdateCache(player)
    print("Updating cache.")
    local profile = getPlayerProfile(player)
    local data = nil
    local good, errorMessage = pcall(function()
        data = profile:GetAsync("profileData")
    end)
    if good then
        if data == nil then
            data = {}
        end
        shared["ridgeProfile_"..player.UserId] = data
    else
        print("Failed to update cache:")
        error(errorMessage)
    end
end
function setValueCache(key, value, player)
    if not cacheExists(player) then
        forceUpdateCache(player)
    end
    shared["ridgeProfile_"..player.UserId][key] = value
end
function cacheExists(player)
    if shared["ridgeProfile_"..player.UserId] == nil then
        return false
    else
        return true
    end
end

--setAsync: update the cache with a new value
function class:setAsync(key, value)
    setValueCache(key, value, self.player)
end
--getAsync: get a value from the cache/datastore
function class:getAsync(key)
    local player = self.player
    if shared["ridgeProfile_"..player.UserId] == nil then
        forceUpdateCache(player)
    end
    return shared["ridgeProfile_"..player.UserId][key]
end


-- module functions
module.getPlayerDataStore = function(player)
    local coreData = {
        player = player
    }
    setmetatable(coreData, class)
    return coreData
end
module.playerAdded = function(player)
    print(player.Name.." added to game. updating cache")
    -- take the info from the dataStore and put into cache for use
    -- when the player leaves the data from the cache is flushed into the dataStore
    forceUpdateCache(player)
end
return module