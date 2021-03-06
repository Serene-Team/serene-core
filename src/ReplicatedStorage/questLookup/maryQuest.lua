local coins = require(game.ReplicatedStorage:WaitForChild("modules").currency)
local level = require(game.ReplicatedStorage:WaitForChild("modules").levels)
local quest = {
    levelReq = 1,
    -- used in the quest log, and alerts
    fullName = "Mary's Quest",
    events = {
        -- playerCompletedQuest: called when ever the player completes this quest, or removes it via the quest book
        playerCompletedQuest = function(player)
            print("giving rewards.")
            coins.giveCoins(player, 30)
            level.grantXp(player, 200)
            print("sending client code to execute")
            return {
                executeExtra = true,
                client = game.ReplicatedStorage.events:FindFirstChild("maryQuestCleanup")
            }  
        end,
        --playerStartedQuest: called when ever the player starts this quest, or logs into the game with the quest active
        playerStartedQuest = function(player)
            -- you can return extra code like this:
            return {
                executeExtra = true,
                client = game.ReplicatedStorage.events:FindFirstChild("maryQuestStart")
            }
        end
    },
    questData = {
        --startedData: data set in the quest profile when the player starts the quest
        -- NOTE: this can be updated via the quest api
        starterData = {
            hasTakenbox = false
        },
        --endData: the players quest profile for this quest MUST match this data to complete the quest
        endData = {
            hasTakenbox = true
        }
    },
    -- used for the quest log
    questDesc = "Mary needs me to collect the box of food from johns market in ashtown"
}

return quest