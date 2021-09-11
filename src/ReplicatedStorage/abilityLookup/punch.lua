local module = {}
module.coreLib = {}
module.abilityLevel = 2
module.info = {
    fullName = "Punch",
    fullDesc = "Punch a enemy!"
}
module.baseConfig = {
    -- readable from the ability code
    baseDamage = 15,
    cooldown = 5,
    useAnimation = 7447772788
}
module.playerConfig = {
    currentCooldown = 0
}
module.events = {
    -- onUse: used when the player uses the ability
    onUse = function(player)
        local coreLib = module.coreLib
        coreLib:playAnimation(player, coreLib:getConfig(""))
    end,
    onEquip = function(player, lib)
        print(player.Name.." equipped the punch ability!")
    end
}