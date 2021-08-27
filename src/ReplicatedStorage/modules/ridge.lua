--[[
    File name: ridge.lua
    Description: datastore module for serene
    Author: oldmilk
--]]

local module = {}
-- services
local dataStoreService = game:GetService("DataStoreService")


-- core functions

--setValueCache: sets a value in the cache
function setValueCache(key, value)
    shared[key] = value
end
--getValueCache: gets a value from the cache
function getValueCache(key)
    return shared[key]
end
--forceUpdateCache: called if the cache for a value is nil, this function sets the cache value to the current DataStore version
function forceUpdateCache(key, dataStore)
   -- get the latest data
   local currentData = nil
   local good, errorMessage = pcall(function()
       currentData = dataStore:GetAsync("MainValue")
   end)
   if good then
    -- update the cache
    setValueCache(key, currentData)
    print("Updated cache with force update.")
    return currentData
   else
        warn("Failed to force update cache: "..errorMessage)
        return "CacheUpdateFailed"
   end
end

-- class
local ridgeClass = {}
ridgeClass.__index = ridgeClass
ridgeClass.dataStore = nil
ridgeClass.isGlobal = false
ridgeClass.dataStoreName = nil
--setAsync: update the cache value
function ridgeClass:setAsync(value)
    -- update cache
    local keyName = self.dataStoreName.."_cache"
    setValueCache(keyName, value)
end
--getAsync: return the current value from cache, if the cache is empty the cache is updated to the latest DataStore version
function ridgeClass:getAsync()
    local cacheKey = self.dataStoreName.."_cache"
    local keyData = getValueCache(cacheKey)
    if keyData == nil then
        print("cache empty, force updating.")
        local data = forceUpdateCache(cacheKey, self.dataStore)
        return data
    else
        return getValueCache(cacheKey)
    end
end
--save: force save the cache into the datastore
function ridgeClass:save()
    print("Flushing cache into datastore.")
    local keyName = self.dataStoreName.."_cache"
    local cacheData = getValueCache(keyName)
    if cacheData == nil then
        warn("Failed to save: cache is empty")
        return "CacheEmpty"
    else
        local good, errorMessage = pcall(function()
            self.dataStore:SetAsync("MainValue", cacheData)
        end)
        if good then
            print("Data saved!")
        else
            print("Failed to save data!")
            error(errorMessage)
        end
    end
end

-- module functions
module.loadPlayerDatastore = function(name, player)
    local coreData = {
        dataStoreName = name,
        dataStore = dataStoreService:GetDataStore(name.."_"..player.UserId),
        isGlobal = false
    }
    setmetatable(coreData, ridgeClass)
    if shared["ridgeDatabase_"..player.UserId] == nil then
        shared["ridgeDatabase_"..player.UserId] = {
            [name] = dataStoreService:GetDataStore(name.."_"..player.UserId)
        }
    else
        if shared["ridgeDatabase_"..player.UserId][name] ~= nil then
            shared["ridgeDatabase_"..player.UserId][name] = dataStoreService:GetDataStore(name.."_"..player.UserId)
        end
    end
    return coreData
end
game.Players.PlayerRemoving:Connect(function(player)
    local indexKey = shared["ridgeDatabase_"..player.UserId]
    if indexKey == nil then
        print("nothing to save!")
    else
        for dataStoreName, dataStore in pairs(indexKey) do
            print("Saving: "..dataStoreName)
            local dataStoreCache = shared[dataStoreName.."_cache"]
            if dataStoreCache ~= nil then
                local isGood, errorMessage = pcall(function()
                    dataStore:SetAsync("MainValue", dataStoreCache)
                end)
                if isGood then
                    print("Saved: "..dataStoreName)
                else
                    print("Failed to save!!")
                    warn(errorMessage)
                end
            else
                print("Save fail: cache empty, but database populated!")
            end
        end
    end
end)


return module