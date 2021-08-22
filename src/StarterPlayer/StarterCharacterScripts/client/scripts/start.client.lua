local clientConfig = require(game.ReplicatedStorage:WaitForChild("config"):WaitForChild("clientConfig"))
if clientConfig.enableClientCharacterWarn == true then
    print("----- Character Loaded -----")
    print("Please report all errors below this line to the developers.")
end