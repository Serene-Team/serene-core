local module = {}

module.loadFromModule = function(module)
    if module.Parent == nil then
        error("Module does not have a valid parent!!")
    else
        local moduleTable = require(module)
        moduleTable.coreLib = require(script.core)
    end
end

return module