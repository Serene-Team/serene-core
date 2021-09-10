-- NOTE: This file contains the source code for the ability library for serene.

local module = {}

function getAnimator(player)
    local value = nil
    if player.Character.Humanoid:FindFirstChildOfClass("Animator") then
        value = player.Character.Humanoid:FindFirstChildOfClass("Animator")
    else
        value = Instance.new("Animator")
        value.Parent = player.Character.Humanoid
    end
    return value
end
function module:playAnimation(player, animationId)
    local animator = getAnimator(player)
    local itemAnim = Instance.new("Animation")
    itemAnim.AnimationId = "rbxassetid://"..animationId
    local track = animator:LoadAnimation(itemAnim)
    track:Play()
    track.Stopped:Wait()
end

return module