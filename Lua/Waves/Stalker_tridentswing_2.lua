
---------------------------------------
--          Setup                    --
---------------------------------------

require "GlobalAnimFunc"
require "AdditionalMath"

local blue = require "bluesoul"
blue.enableFakePlayer = true
blue.maxjump = 5
blue.Initialize() 
blue.Dir("down")

Arena.Resize(480,70)
Arena.MoveTo(Arena.x, Arena.y -10, true, false)

--переменные
local elapsedTime = 0 -- время с начала волны. Надо бы в глобальные функции вынести
local attackStage = 1 -- (*)

local currentAttackNum = 0
local tempPLYx = nil
local eyeflashStatus = false
-- от сложности

local fireballsSpeedEasy = 1
local amountOfAttacksEasy = 5
local delayAfterHitEasy = 120
local speedMultiplierEasy = 1.5
local amountOfSpaceBetweenEasy = 9
local blueSpeedEasy = 3.5

-- Уровень сложности: Бодренько
local fireballsSpeedAlr = 2
local amountOfAttacksAlr = 4
local delayAfterHitAlr = 90
local speedMultiplierAlr = 2
local amountOfSpaceBetweenAlr = 7
local blueSpeedAlr = 4

-- Уровень сложности: "СПАСИ МЕНЯ МАМА!"
local fireballsSpeedIWantToGoHome = 2.5
local amountOfAttacksIWantToGoHome = 4 -- math.random(3,5) для случайного выбора между 3 и 5
local delayAfterHitIWantToGoHome = 50
local speedMultiplierIWantToGoHome = 3
local amountOfSpaceBetweenIWantToGoHome = 6
local blueSpeedIWantToGoHome = 5

-- Временная хрень
local currentDifficulty = "I wanna go home"

if currentDifficulty == "easy" then
    fireballsSpeed = fireballsSpeedEasy
    amountOfAttacks = amountOfAttacksEasy
    delayAfterHit = delayAfterHitEasy
    speedMultiplier = speedMultiplierEasy
    amountOfSpaceBetween = amountOfSpaceBetweenEasy
    blue.speed = blueSpeedEasy
elseif currentDifficulty == "alr" then
    fireballsSpeed = fireballsSpeedAlr
    amountOfAttacks = amountOfAttacksAlr
    delayAfterHit = delayAfterHitAlr
    speedMultiplier = speedMultiplierAlr
    amountOfSpaceBetween = amountOfSpaceBetweenAlr
    blue.speed = blueSpeedAlr
elseif currentDifficulty == "I wanna go home" then
    fireballsSpeed = fireballsSpeedIWantToGoHome
    amountOfAttacks = amountOfAttacksIWantToGoHome
    delayAfterHit = delayAfterHitIWantToGoHome
    speedMultiplier = speedMultiplierIWantToGoHome
    amountOfSpaceBetween = amountOfSpaceBetweenIWantToGoHome
    blue.speed = blueSpeedIWantToGoHome
end

--константы
local fireballsMaxAmount = 30 -- 480 (размер арены) \ 16 (16x16 - спрайт файерболла); по 15 с каждой стороны
--таблички
local fireballs = {}
--эммиторы (штука для спавна fireballs)
local emitters = {}

function EmitterConfig() -- firewall_number - номер волны огня 

    local emitter_r = {}
    local emitter_l = {}

    emitter_r.init_y = Arena.height / 2 - 8
    emitter_r.init_x = Arena.width / 2 + 16
    emitter_r.index = #emitters + 1

    emitter_l.init_y = -Arena.height / 2 +8
    emitter_l.init_x = -Arena.width / 2 - 48
    emitter_l.index = #emitters

    table.insert(emitters, emitter_l)
    table.insert(emitters, emitter_r)
end

EmitterConfig() 

--остальное
Encounter["wavetimer"] = math.huge

local Stalker = CreateProjectileAbs("stalker/tridentswing", 320, 360, "BelowArena")
Stalker.sprite.xscale = 0.34
Stalker.sprite.yscale = 0.34

local Trident = CreateProjectileAbs("stalker/Stalkerspear", 320, 360, "Top")
Trident.sprite.xscale = 0.9
Trident.sprite.yscale = 0.9
Trident.sprite.rotation = 30
Trident.sprite.alpha32 = 0
Trident.ppcollision = true

whiteover = CreateSprite("bgwhite", "Top")
whiteover.alpha = 1 



Hidestalker()

-----------------------------------------
--          Attack Stages              --
-----------------------------------------

function StalkerStartingAnimationFunc()
    Trident.sprite.alpha32 = math.min(elapsedTime * 4, 255)
    Trident.sprite.rotation = Trident.sprite.rotation - 5 * (Trident.sprite.alpha32 == 255 and 1 or 0)

    attackStage = Trident.sprite.rotation == 270 and 2 or attackStage
    --tempPLYx, attackStage = (Trident.sprite.rotation == 270) and Player.x or tempPLYx, (Trident.sprite.rotation == 270) and 2 or attackStage
end

function AttackStagePreparing()
    tempPLYx = tempPLYx or Player.x

    local absoluteError = math.ceil(Trident.x - Player.x) -- вычисление абсолютной (вроде) погрешности
    local adjustment = (math.abs(absoluteError) > 10) and eyeflashStatus == false and -math.sign(absoluteError) * (1 * speedMultiplier + math.abs(absoluteError) * 0.1) or 0


    if Trident.y <= 240 then
        Trident.y = math.min(Trident.y + 10 - speedMultiplier * 3, 241)
    else
        Trident.x = Trident.x + adjustment
        Stalker.x = Stalker.x + adjustment

        Trident.y = math.min(Trident.y + 1 * speedMultiplier, 300)
    end

    --attackStage = (adjustment == 0 and Trident.y == 300) and 3 or attackStage
    if adjustment == 0 and Trident.y == 300 then
        if eyeflashStatus == false then
            eyeflash = CreateSprite("stalker/normal_eyeflash1", "Top")
            eyeflash.SetAnchor(0.5, 0)
            eyeflash.Scale(1, 1)
            eyeflash.Move(Stalker.x, 190)
            eyeflash.SetAnimation({"stalker/normal_eyeflash1", "stalker/eyeflash1", "stalker/eyeflash3", "stalker/eyeflash3","stalker/normal_eyeflash3", "stalker/normal_eyeflash4", "stalker/normal_eyeflash5", "stalker/normal_eyeflash5", "empty"}, 0.15 - 0.04 * speedMultiplier)
            eyeflashStatus = true
        else
            if eyeflash.currentframe == 9 then
                eyeflash.Remove()
                attackStage = 3
                Misc.ShakeScreen(40, 5, true)
            end
        end
    end
end

function AttackStageHitting()
    Trident.y = math.max(Trident.y - 10, Arena.y + Arena.height + 20)

    WaitVar = WaitVar or elapsedTime + delayAfterHit

    if elapsedTime - WaitVar >= 0 then
        attackStage = 2
        eyeflashStatus = false
        tempPLYx = nil
        WaitVar = nil
        currentAttackNum = currentAttackNum + 1

        if currentAttackNum == amountOfAttacks then
            attackStage = 4
        end
    end
end

function StalkerEndingAnimationFunc()

    Trident.sprite.rotation = math.min(Trident.sprite.rotation + 2, 30)
    Trident.y = math.min(Trident.y + 5 , 240)

    Trident.x = (math.abs(Trident.x) >= 11) and Trident.x - math.sign(Trident.x) * 10 or 0
    Stalker.x = Trident.x

    WaitVar = (Trident.x == 0) and (WaitVar or elapsedTime + 30) or WaitVar
    if Trident.x == 0 and elapsedTime - WaitVar >= 0 then
        EndWave()
    end
end

local attackStages = { -- (*)
    StalkerStartingAnimationFunc, -- 1 (пропускается после первого раза)
    AttackStagePreparing,         -- 2
    AttackStageHitting,           -- 3
    StalkerEndingAnimationFunc    -- 4
}

-----------------------------------------
--    Funcs related to fire            --
-----------------------------------------

function CreateFireball(emitter)
    local fireball = CreateProjectile("hitbox_fire", emitter.init_x, emitter.init_y)
    fireball.sprite.Set("firebullet0")

    fireball.SetVar("timeFromFireballSpawn", 0)
    fireball.SetVar("direction", math.sign(emitter.init_x))
    fireball.SetVar("type", 1)

    table.insert(fireballs, fireball)
end

function UpdateFireball(fireball)
    local timeFromFireballSpawn = fireball.GetVar("timeFromFireballSpawn") + 1
    fireball.SetVar("timeFromFireballSpawn", timeFromFireballSpawn)

    local direction = fireball.GetVar("direction")

    fireball.x = fireball.x - fireballsSpeed * direction
end

----------------------------------------
--          Update funcs              --
----------------------------------------

function Update()
    elapsedTime = elapsedTime + 1

    FireballWaitVar = FireballWaitVar or elapsedTime + (16 * amountOfSpaceBetween / fireballsSpeed) -- amountOfSpaceBetween - кол-во фаерболлов между друг другом

    if elapsedTime - FireballWaitVar >= 0 then
        for i=1,2 do
            CreateFireball(emitters[i])
            FireballWaitVar = nil
        end
    end

    for i = 1, #fireballs do
        UpdateFireball(fireballs[i])
    end

    attackStages[attackStage]()
    UpdateBlueSoulFunc()

    if whiteover.alpha > 0 and whiteover.isactive then
        UpdateWhiteoverAlpha()
    end
end

function UpdateBlueSoulFunc()
    blue.Update()
end

function UpdateWhiteoverAlpha()
    whiteover.alpha = math.max(whiteover.alpha - 0.045, 0)
end


function OnHit(bullet)
    local type = bullet.GetVar("type")
    if type == 1 then
        Player.Hurt(3, 0.5)
    else
        if Player.hp == 1 then
            Player.Hurt(1, 1.7) --dead
        else
            Player.Hurt(Player.hp - 1, 1.7)
        end
    end
end