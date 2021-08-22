local proximityPrompt = game:GetService("ProximityPromptService")
local gui = game.ReplicatedStorage.gui.prompt
proximityPrompt.PromptShown:Connect(function (prompt, input)
	local promptUi = gui:Clone()
	promptUi.Adornee = prompt.Parent
	promptUi.Frame.ActionText.Text = prompt.ActionText
	promptUi.Parent = prompt.Parent
end)
proximityPrompt.PromptHidden:Connect(function (prompt)
	if prompt.Parent:FindFirstChild("prompt") ~= nil then
		prompt.Parent.prompt:Destroy()
	end
end)