local module = {}

module.event = function(name, callback)
    local event = Instance.new("RemoteEvent")
    event.Name = name
    event.Parent = game.ReplicatedStorage.events
    -- listen for event
    event.OnServerEvent:Connect(function(player, ...)
        callback(player, ...)
    end)
end
module.remotefunction = function (name, callback)
	local event = Instance.new("RemoteFunction")
	event.Name = name
	event.Parent = game.ReplicatedStorage.events
	-- listen for function
	event.OnServerInvoke = function(player, ...)
		return callback(player, ...)
	end
end

return module