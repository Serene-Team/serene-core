--[[
    File name: ridgeServer.lua
    Description: auto save data when the player leaves the game. DO NOT move this into the main ridge module
    Author: oldmilk
--]]
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
