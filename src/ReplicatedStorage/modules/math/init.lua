--[[
    File name: init.lua
    Description: expose the serene math API
    Author: oldmilk
--]]


local module = {}

module.import = function(module)
    if script.packages:FindFirstChild(module) == nil then
        error("Failed to import package: invalid name")
    else
        return require(script.packages:FindFirstChild(module))
    end
end


return module