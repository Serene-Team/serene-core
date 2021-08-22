--[[
    File name: percent.lua
    Description: calculate percents and other things like that
    Author: oldmilk
--]]

local module = {}

-- percentToDecimal: converts the given percent to a decimal number
-- Example:
-- print(percentToDecimal(50))  -- This returns 0.5
module.percentToDecimal = function(percent)
    if type(percent) ~= "number" then
        error("expected number got "..type(percent))
    else
        return percent / 100
    end
end

-- decimalToPercent: converts the given decimal to a percent
-- Example:
-- print(decimalToPercent(0.5))  -- This returns 50
module.decimalToPercent = function(decimal)
    if type(decimal) ~= "number" then
        error("expected number got "..type(decimal))
    else
        return decimal * 100
    end
end

return module