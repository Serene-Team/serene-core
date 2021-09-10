print("Loading client gui settings.")
local starterGui = game.StarterGui
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
starterGui:SetCore("ChatWindowPosition", UDim2.new(0,0,0.665,0))
print("done loading client gui settings.")
