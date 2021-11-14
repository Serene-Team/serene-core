local collectionService = game:GetService("CollectionService")
local lanterns = collectionService:GetTagged("Lantern")
local activateTime = 17.617
local disableTime = 6.15
local enabledLanterns = false

function setLanternEnabled(enabled)
    for _, lantern in pairs(lanterns) do
        lantern.CandleTip:FindFirstChildOfClass("SurfaceLight").Enabled = enabled
    end
    print("Job complete")
end

while true do
    local time = game.Lighting.ClockTime
    if time >= activateTime then
        if not enabledLanterns then
            setLanternEnabled(true)
            enabledLanterns = true
        end
    elseif time >= disableTime then
        if enabledLanterns then
            setLanternEnabled(false)
            enabledLanterns = false
        end
    end
    task.wait(1)
end