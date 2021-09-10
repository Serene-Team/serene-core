local package = {}
local insertService = game:GetService("InsertService")
package.gamePackages = {
	{
		parent = game.ReplicatedStorage,
		asset_id = 7390664957
	},
	{
		parent = game.StarterGui,
		asset_id = 7390699266
	},
	{
		parent = game.ReplicatedStorage,
		asset_id = 7390704196
	},
	{
		parent = game.ReplicatedStorage,
		asset_id = 7390727320
	},
	{
		parent = game.ServerScriptService,
		asset_id = 7390760184
	},
	{
		parent = game.StarterPlayer.StarterCharacterScripts,
		asset_id = 7390778993
	},
	{
		parent = game.StarterPlayer.StarterPlayerScripts,
		asset_id = 7390884714
	},
	{
		parent = game.ReplicatedStorage,
		asset_id = 7418954161
	}
}



-- loadPackages: called when the server start
function package:loadPackages()
	if game.Players.CharacterAutoLoads then
		game.Players.CharacterAutoLoads = false
		warn("Disabled character auto loads until, game server has loaded packages.")
	end
	print("Loading folders...")
	if game.ReplicatedStorage:FindFirstChild("events") == nil then
		local events = Instance.new("Folder")
		events.Name = "events"
		events.Parent = game.ReplicatedStorage	
	end
	for index, package in pairs(package.gamePackages) do
		local insertItem = insertService:LoadAsset(package.asset_id)
		if package.parent:FindFirstChild(insertItem:GetChildren()[1].Name) ~= nil then
			warn("Package already loaded")
			insertItem:Destroy()
		else
			insertItem.Parent = game.ServerStorage
			insertItem:GetChildren()[1].Parent = package.parent
			print("Loaded server package.")	
		end
	end
	local network = require(game.ReplicatedStorage:WaitForChild("modules").network)
	network.event("loadPlayerscripts", function ()
	end)
	print("Packages loaded, allowing server to load characters")
	game.Players.CharacterAutoLoads = true
	-- load characters
	local playerModule = require(game.ReplicatedStorage:WaitForChild("modules").player)
	local players = game.Players:GetChildren()
	
	local inst = Instance.new("BoolValue")
	inst.Name = "serverPackagesLoaded"
	inst.Value = true
	inst.Parent = game.ReplicatedStorage
	for i, player in pairs (players) do		
		if (not game.Workspace:FindFirstChild(player.Name)) then
			game.ReplicatedStorage.events.loadPlayerscripts:FireClient(player)
			player:LoadCharacter()	
		end
	end
end

package:loadPackages()