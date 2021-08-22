local ChatServiceRunner = game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner")
local ChatService = require(ChatServiceRunner.ChatService)

local MainChannel = ChatService:GetChannel("all")
MainChannel.WelcomeMessage = ""
print("updated global chat settings.")