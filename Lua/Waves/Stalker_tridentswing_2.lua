
require "GlobalAnimFunc"
blue = require "Libraries/bluesoul"
blue.enableFakePlayer = true

Stalker = CreateProjectileAbs("stalker/tridentswing", 320, 360, "BelowArena")
Stalker.sprite.xscale = 0.34
Stalker.sprite.yscale = 0.34
Trident = CreateProjectileAbs("stalker/Stalkerspear_attack_mode", 320, 300, "Top")
Trident.sprite.xscale = 0.9
Trident.sprite.yscale = 0.9

Arena.Resize(300,55)
Arena.MoveTo(Arena.x, Arena.y -10, true, false)

blue.Initialize()
    UpdateBlueSoul = true

function Update()
    Hidestalker()

    if UpdateBlueSoul == true then
        blue.Update()
    end
end