--[[
    File name: init.lua
    Description: main module code for the serene quest system
    Author: oldmilk
--]]

local module = {}
local class = require(script.class)

--importFromModule: import a quest from a module script
module.importFromModule = function(path)
    if not path:IsA("ModuleScript") then
        error("Failed to load quest data: given Instance must be of class ModuleScript")
    end
    local questData = require(path)
    local coreData = {
        questData = require(path),
        modulePath = path
    }
    setmetatable(coreData, class)
    return coreData
end

return module