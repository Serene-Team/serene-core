task.wait(0.5)
local tweenService = game:GetService("TweenService")--Get Tween Service

local player = game:GetService("Players").LocalPlayer --Get The Player
local character = player.Character or player.CharacterAdded:Wait() --Wait For The Player Humanoid
local Humanoid = character:WaitForChild("Humanoid") --Get The Player Humanoid

local Healthbar = player.PlayerGui:WaitForChild("gameUi").hpBar.health

local function update() --Health Bar Size Change Function
	local health = Humanoid.Health/Humanoid.MaxHealth
	local info = TweenInfo.new(Humanoid.Health / Humanoid.MaxHealth,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0) --Tween Info
	Healthbar.Parent.txt.Text = "Health: "..math.round(Humanoid.Health).."/"..Humanoid.MaxHealth
	tweenService:Create(Healthbar,info,{Size = UDim2.new(health, 0, 0, 40)}):Play() -- Create The Tween Then Play It
end

update()--Update The Health Bar

Humanoid:GetPropertyChangedSignal("Health"):Connect(update) --Update The Health Bar When The Health Change
Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(update) --Update The Health Bar Wheb The MaxHealth Change