--[[
Q: Why play music on the client??
A: Its better. If we play the music on the client, the music will start at the beginning, not pick up where the server wants it to pick up from
--]]

local module = {}
local soundService = game:GetService("SoundService")
local sounds = {
    ["Ashtown"] = 1837200619
}
module.playSong = function(place)
    if sounds[place] == nil then
        error("Failed to play sound: "..place.." is not a valid member of table sounds!")
    else
        if game.Workspace:FindFirstChild("bgSound") == nil then
            local soundInst = Instance.new("Sound")
            soundInst.Name = "bgSound"
            soundInst.SoundId = "rbxassetid://"..sounds[place]
            soundInst.Looped = true
            soundInst.Parent = game.Workspace
            soundInst:Play()
        end
    end
end
module.enableFootsteps = function(player)
	print("loading footsteps.")
	-- TODO
	
end

return module