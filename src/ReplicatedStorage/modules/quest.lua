local module = {}

local dataStore = require(game.ReplicatedStorage.DataStore2)
local characterSlot = require(game.ReplicatedStorage.modules.characterSlot)

module.startQuest = function(player, questInfo)
    -- fail safe
    if questInfo["name"] == nil or questInfo["levelReq"] == nil then
        error("quest init failed: invalid payload")
    end
    local extraData = {}
    if questInfo["questExtra"] == nil then 
        warn("no extra quest data given. default is {}")
    else
        extraData = questInfo["questExtra"] 
    end
    -- get character slot
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    -- datastore stuff
    local questStore = dataStore("questStore_"..currentSlot, player)
    local questData = questStore:Get({})
    -- storage
    questData[questInfo.name] = {
        name = questInfo.name,
        levelReq = questInfo.levelReq,
        storage = extraData
    }
    -- update
    questStore:Set(questData)
end
module.isDoingQuest = function(player, name)
    -- get character slot
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    -- datastore stuff
    local questStore = dataStore("questStore_"..currentSlot, player)
    local questData = questStore:Get({})
    if questData[name] == nil then
        return false
    else
        return true
    end
end
module.completeQuest = function(player, name)
    -- get character slot
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    -- datastore stuff
    local questStore = dataStore("questStore_"..currentSlot, player)
    local questData = questStore:Get({})
    questData[name] = nil
    questStore:Set(questData)
    return true
end
module.addQuestData = function(player, name, info)
    -- get character slot
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    -- datastore stuff
    local questStore = dataStore("questStore_"..currentSlot, player)
    local questData = questStore:Get({})
    if questData[name] == nil then
        warn("Failed to add quest data: quest invalid")
        return "invalid"
    end
    local questStorage = questData[name]["storage"]
    if info["key"] == nil or info["value"] then
        error("Failed to write to datastore: missing key, and/or value")
    end
    questStorage[info.key] = info.value
    questStore:Set(questData)
end
module.getQuestData = function(player, name)
    -- get character slot
    local currentSlot = characterSlot.getPlayerCharacterSlotid(player)
    -- datastore stuff
    local questStore = dataStore("questStore_"..currentSlot, player)
    local questData = questStore:Get({})
    if questData[name] == nil then
        warn("Failed to read quest data: quest invalid")
        return "invalid"
    end
    return questData[name]["storage"]
end
module.sendQuestAlert = function(player, message)
    player.PlayerGui:WaitForChild("gameUi").questAlert.Text = message
    player.PlayerGui.gameUi.questAlert.Visible = true
    wait(4)
    player.PlayerGui.gameUi.questAlert.Visible = false
end
return module