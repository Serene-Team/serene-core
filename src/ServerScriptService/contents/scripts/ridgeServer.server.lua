--[[
    File name: ridgeServer.lua
    Description: auto save data when the player leaves the game. DO NOT move this into the main ridge module
    Author: oldmilk
--]]
function saveData(player)
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
                    print("Emptied cache.")
                    -- empty cache
                    shared[dataStoreName.."_cache"] = nil
                    -- empty database
                    shared["ridgeDatabase_"..player.UserId][dataStoreName] = nil
                else
                    print("Failed to save!!")
                    warn(errorMessage)
                end
            else
                print("Save fail: cache empty, but database populated!")
            end
        end
    end   
end
game.Players.ChildRemoved:Connect(function(player)
    saveData(player)
end)
-- setting up a BindToClose allows the server to save data
game:BindToClose(function()
    print("Server shutting down, allow server to save data.")
    for i, player in pairs(game.Players:GetChildren()) do
        saveData(player)
    end
end)

