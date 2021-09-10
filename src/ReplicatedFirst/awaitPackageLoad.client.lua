-- await package load
if not game:IsLoaded() then
	game.Loaded:Wait()
end
game.ReplicatedFirst:RemoveDefaultLoadingScreen()
local packageLoaded = game.ReplicatedStorage:WaitForChild("serverPackagesLoaded")
if packageLoaded.Value then
	print("server has loaded packages!!")
end