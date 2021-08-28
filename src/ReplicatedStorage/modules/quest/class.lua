local quest = {}
quest.__index = quest
quest.questData = {}
quest.modulePath = nil
-- modules
local ridge = require(game.ReplicatedStorage.modules.ridge)

-- core functions

-- https://devforum.roblox.com/t/tell-if-table-is-equal-to-another-table/567580/2   
function checkTable(t1,t2)
    for i,v in next, t1 do if t2[i]~=v then return false end end
    for i,v in next, t2 do if t1[i]~=v then return false end end
    return true
end
function removeFromQuestHist(questDataName, player)
    local playerQuestHistStore = ridge.loadPlayerDatastore("playerQuestHist", player)
    local completedQuests = playerQuestHistStore:getAsync()
    if completedQuests == nil then
        completedQuests = {}
    end
    completedQuests[questDataName] = nil
    playerQuestHistStore:setAsync(completedQuests)
end
function addToQuestHist(questDataName, player)
    local playerQuestHistStore = ridge.loadPlayerDatastore("playerQuestHist", player)
    local completedQuests = playerQuestHistStore:getAsync()
    if completedQuests == nil then
        completedQuests = {}
    end
    completedQuests[questDataName] = true
    playerQuestHistStore:setAsync(completedQuests)
end

--updateQuestData: update datastore quest data
function quest:updateQuestData(player, key, value)
    local playerQuestStore = ridge.loadPlayerDatastore("playerCurrentQuests", player)
    local quests = playerQuestStore:getAsync()
    -- pre-checks
    if quests == nil then
        warn("Failed to update quest data: no quests found in dataStore")
        return "DataStoreEmpty"
    end
    local questName = self.modulePath.Name
    if quests[questName] == nil then
        warn("Failed to update quest data: quest not found in dataStore")
        return "DataStoreQuestEmpty"
    end
    -- update the quest data
    local keyData = quests[questName].questData[key]
    if keyData == nil then
        warn("data in dataStore is nil, this will create a new value. its recommended to only update existing values")
    end
    quests[questName].questData[key] = value
    playerQuestStore:setAsync(quests)
end
--completeQuest: completes the quest for a player if the questData matches the final quest data
function quest:completeQuest(player)
    local playerQuestStore = ridge.loadPlayerDatastore("playerCurrentQuests", player)
    local quests = playerQuestStore:getAsync()
    local questName = self.modulePath.Name
    if quests == nil then
        quest:displayQuestAlert(player, "No quests in DataStore.", "danger")
        return "NoQuests"
    end
    if quests[questName] == nil then
        quest:displayQuestAlert(player, "You can't end a quest you havent started!", "danger")
        return "QuestNotStarted"
    end
    local finalQuestData = self.questData["questData"]["endData"]
    -- check if the quest data is the same as the expected version
    if not checkTable(quests[questName].questData, finalQuestData) then
        quest:displayQuestAlert(player, "You lack the requirments to complete this quest!", "danger")
        return "QuestDataFailed"
    end
    local questFullName = quests[questName]["fullName"]
    -- fire event before we delete the data
    local questData = self.questData  
    if questData["events"] ~= nil then
        if questData.events["playerCompletedQuest"] ~= nil then
            local dataReturn = questData.events.playerCompletedQuest(player)
            if dataReturn["client"] ~= nil then
                local clientEvent = dataReturn.client
                clientEvent:FireClient(player)
            end
        end
    end
    quests[questName] = nil
    playerQuestStore:setAsync(quests)
    quest:displayQuestAlert(player, "Quest completed: "..questFullName, "success")
end
--endQuest: force ends a quest and removes it from the dataStore
function quest:endQuest(player)
    warn("force removing quest from datastore.")
    local playerQuestStore = ridge.loadPlayerDatastore("playerCurrentQuests", player)
    local quests = playerQuestStore:getAsync()
    if quests == nil then
        warn("Failed to remove quest: no quests in datastore")
        return "Failed"
    end
    local questDataName = self.modulePath.Name
    local questData = self.questData
    if quests[questDataName] ~= nil then
        -- fire event before we delete the data
        if questData["events"] ~= nil then
            if questData.events["playerCompletedQuest"] ~= nil then
                local dataReturn = questData.events.playerCompletedQuest(self.currentPlayer)
                if dataReturn["client"] ~= nil then
                    local clientEvent = dataReturn.client
                    clientEvent:FireClient(player)
                end
            end
        end
        quests[questDataName] = nil
        removeFromQuestHist(self.modulePath.Name, player)
        playerQuestStore:setAsync(quests)
        quest:displayQuestAlert(player, "Removed quest!", "success")
    else
        warn("Failed to remove quest: quest not in datastore")
        quest:displayQuestAlert(player, "Failed to end quest: quest invalid", "danger")
        return "Failed"
    end
end

-- displayQuestAlert: displays a on-screen alert to a player
function quest:displayQuestAlert(player, text, type)
    local dangerColor = Color3.fromRGB(200, 0, 0)
    local infoColor = Color3.fromRGB(153, 153, 153)
    local successColor = Color3.new(124,252,0)
    local alertType = "info"
    if type ~= nil then
        alertType = type
    end
    local textAlert = player.PlayerGui:WaitForChild("gameUi").questAlert
    if type == "danger" then
        textAlert.BackgroundColor3 = dangerColor
    elseif type == "success" then
        textAlert.BackgroundColor3 = successColor
        textAlert.TextColor3 = Color3.fromRGB(0,0,0)
    else
        textAlert.BackgroundColor3 = infoColor
    end
    textAlert.Text = text
    textAlert.Visible = true
    wait(3)
    textAlert.TextColor3 = Color3.fromRGB(255,255,255)
    textAlert.Visible = false
end
--startQuest: start the quest for a given player
function quest:startQuest(player)
    print("Starting quest")
    local questData = self.questData
    local questDataName = self.modulePath.Name
    local playerQuestStore = ridge.loadPlayerDatastore("playerCurrentQuests", player)
    local quests = playerQuestStore:getAsync()
    if quests == nil then
        quests = {}
    end
    quests[questDataName] = {
        fullName = questData.fullName,
        questData = questData.questData.starterData
    }
    -- save quest data
    playerQuestStore:setAsync(quests)
    -- trigger events
    if questData["events"] ~= nil then
        addToQuestHist(self.modulePath.Name, player)
        if questData.events["playerStartedQuest"] ~= nil then
            local dataReturn = questData.events.playerStartedQuest(self.currentPlayer)
            if dataReturn["client"] ~= nil then
                local clientEvent = dataReturn.client
                clientEvent:FireClient(player)
            end
        end
    end
    print("Quest started for "..player.Name)
    quest:displayQuestAlert(player, "Quest Added: "..questData.fullName)
end
--getQuestData: returns the current quest data in the datastore for the given player
function quest:getQuestData(player)
    local playerQuestStore = ridge.loadPlayerDatastore("playerCurrentQuests", player)
    local quests = playerQuestStore:getAsync()
    local questDataName = self.modulePath.Name
    if quests == nil then
        warn("Failed to lookup quest data: no quests found in dataStore")
    end
    if quests[questDataName] == nil then
        warn("Failed to lookup quest data: the given quest was not found in the dataStore")
    end
    -- look up the quest data
    local questData = quests[questDataName]["questData"]
    return questData
end
--isDoingQuest: returns if the player is doing the current quest or not
function quest:isDoingQuest(player)
    local playerQuestStore = ridge.loadPlayerDatastore("playerCurrentQuests", player)
    local quests = playerQuestStore:getAsync()
    local questDataName = self.modulePath.Name
    if quests == nil then
        return false
    elseif quests[questDataName] == nil then
        return false
    else
        return true
    end
end
--hasDoneQuest: returns if the player has done the current quest or not
function quest:hasDoneQuest(player)
    local playerQuestHistStore = ridge.loadPlayerDatastore("playerQuestHist", player)
    local questHist = playerQuestHistStore:getAsync()
    print(questHist)
    local questDataName = self.modulePath.Name
    if questHist == nil then
        return false
    elseif questHist[questDataName] == nil then
        return false
    else
        return true
    end
end
return quest