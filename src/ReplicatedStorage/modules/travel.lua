local travel = {}
local CollectionService = game:GetService("CollectionService")

function travel:initDoorSystem()
	local doors = CollectionService:GetTagged("Door")
    for index, door in pairs(doors) do
        if door:FindFirstChild("exitZone") == nil then
            warn("Skipping item , exitZone not found.")
        else
            door.Touched:Connect(function(hit)
                local player = game.Players:GetPlayerFromCharacter(hit.Parent)
                if player ~= nil then
                    if player:GetAttribute("usingDoor") == nil or player:GetAttribute("usingDoor") == false then
                        local exitZone = door.exitZone.Value
                        player:SetAttribute("usingDoor", true)
                        player.Character.HumanoidRootPart.CFrame = exitZone.CFrame
                        task.wait(5)
                        player:SetAttribute("usingDoor", false)
                    end
                end
            end)
        end
    end
end
return travel
