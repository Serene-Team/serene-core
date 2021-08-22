local package = {}
local messageService = game:GetService("MessagingService")
-- forceGlobalUpdate: restart all servers
package.forceGlobalUpdate = function ()
	warn("global update forced on all servers!")
	messageService:PublishAsync("systemGlobalUpdate")
	print("publish success!")
end
return package
