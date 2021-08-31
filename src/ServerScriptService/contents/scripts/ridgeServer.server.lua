--[[
    File name: ridgeServer.lua
    Description: auto save data when the player leaves the game. DO NOT move this into the main ridge module
    Author: oldmilk
--]]
local dataStoreService = game:GetService("DataStoreService")
function getPlayerProfile(player)
    return dataStoreService:GetDataStore("profile_"..player.UserId)
end
function saveData(player)
    print("saving started.")
    if player:GetAttribute("isSaving") == true then
        warn("datasave already in progress")
        return "DataSavedByOtherProccess"
    end
    player:SetAttribute("isSaving", true)
    local cache = shared["ridgeProfile_"..player.UserId]
    if cache == nil then
        warn("nothing to save.")
        return "NothingToSave"
    end
    local profile = getPlayerProfile(player)
    local good, errorMessage = pcall(function()
        profile:SetAsync("profileData", cache)    
    end)
    if good then
        print("saved data!")
        player:SetAttribute("isSaving", false)
    else
        print("failed to save data:")
        error(errorMessage)
    end
end
local ridge = require(game.ReplicatedStorage.modules.ridge)
game.Players.ChildRemoved:Connect(function(player)
    saveData(player)
end)
game:BindToClose(function()
    print("Server closing, saving data.")
    for i, player in pairs(game.Players:GetChildren()) do
        saveData(player)
    end
end)