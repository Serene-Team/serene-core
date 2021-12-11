--https://devforum.roblox.com/t/a-guide-to-a-better-looking-and-more-realistic-day-night-cycle/392643
--time changer
local mam --minutes after midnight
local timeShift = 1 --how many minutes you shift every "tick"
local waitTime = 15/30 --length of the tick
local pi = math.pi

--brightness
local amplitudeB = 1
local offsetB = 2

--outdoor ambieant
local var
local amplitudeO = 20
local offsetO = 100

--shadow softness
local amplitudeS = .2
local offsetS = .8

--color shift top
local pointer
                 -- 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
local rColorList = {000,000,000,000,000,255,255,255,255,255,255,255,255,255,255,255,255,255,255,000,000,000,000,000}
local gColorList = {165,165,165,165,165,255,215,230,255,255,255,255,255,255,255,245,230,215,255,165,165,165,165,165}
local bColorList = {255,255,255,255,255,255,110,135,255,255,255,255,255,255,255,215,135,110,255,255,255,255,255,255}
local r
local g
local b
if game.ServerStorage:FindFirstChild("disableNightCycle") == nil then
     while true do
          --time changer
          mam = game.Lighting:GetMinutesAfterMidnight() + timeShift
          game.Lighting:SetMinutesAfterMidnight(mam)
          mam = mam/60
     
          --brightness
          game.Lighting.Brightness = amplitudeB*math.cos(mam*(pi/12)+pi)+offsetB
     
          --outdoor ambient
          var=amplitudeO*math.cos(mam*(pi/12)+pi)+offsetO
          game.Lighting.OutdoorAmbient = Color3.fromRGB(var,var,var)
     
          --shadow softness
          game.Lighting.ShadowSoftness = amplitudeS*math.cos(mam*(pi/6))+offsetS
     
          --color shift top
          pointer= math.clamp(math.ceil(mam), 1, 24)
          r=((rColorList[pointer%24+1]-rColorList[pointer])*(mam-pointer+1))+rColorList[pointer]
          g=((gColorList[pointer%24+1]-gColorList[pointer])*(mam-pointer+1))+gColorList[pointer]
          b=((bColorList[pointer%24+1]-bColorList[pointer])*(mam-pointer+1))+bColorList[pointer]
          game.Lighting.ColorShift_Top=Color3.fromRGB(r,g,b)
     
          --tick
          wait(waitTime)
     end  
end