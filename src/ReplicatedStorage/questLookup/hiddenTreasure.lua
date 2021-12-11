local coins = require(game.ReplicatedStorage:WaitForChild("modules").currency)
local level = require(game.ReplicatedStorage:WaitForChild("modules").levels)
local quest = {
    levelReq = 3,
    -- used in the quest log, and alerts
    fullName = "Hidden Treasure",
    events = {
        -- playerCompletedQuest: called when ever the player completes this quest, or removes it via the quest book
        playerCompletedQuest = function(player)
            print("giving rewards.")
            coins.giveCoins(player, 50)
            level.grantXp(player, 600)
            print("sending client code to execute")
            return {
                executeExtra = false
            }  
        end,
        --playerStartedQuest: called when ever the player starts this quest, or logs into the game with the quest active
        playerStartedQuest = function(player)
            -- you can return extra code like this:
            return {
                executeExtra = true,
                client = game.ReplicatedStorage:WaitForChild("hiddenTreasureQuestStart")
            }
        end
    },
    questData = {
        --startedData: data set in the quest profile when the player starts the quest
        -- NOTE: this can be updated via the quest api
        starterData = {
            hasFoundKey = false,
            hasFoundChest = false
        },
        --endData: the players quest profile for this quest MUST match this data to complete the quest
        endData = {
            hasFoundKey = true,
            hasFoundChest = true
        }
    },
    -- used for the quest log
    questDesc = "I need to find a hidden treasure located somewhere in forgotten passage"
}

return quest