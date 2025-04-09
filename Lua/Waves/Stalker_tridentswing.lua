require "GlobalAnimFunc"
Stalker = CreateProjectileAbs("stalker/tridentswing", 320, 360, "BelowArena")
Stalker.sprite.xscale = 0.34
Stalker.sprite.yscale = 0.34

Encounter["wavetimer"] = math.huge

Arena.Resize(150, 100)
Arena.MoveTo(Arena.x, Arena.y + 50, true, false)

--- константы
from_flash_to_blink = 70

--- здесь находятся переменные, которые нужно скейлить от сложности
TimeBetweenBlinks = 1 --- время между сверканием глаз и ударами
NumOfStandartBlinks = math.random(2, 4) --- кол-во сверкающих глаз
NumOfComplexBlinks = math.random(0, 3) --- кол-во комплексных сверкающих глаз
SpeedOfBlinks = 0.03333 --- время анимации блинков

difficulty = 4 --- зависит от того, сколько раз повторилась эта волна. НАДО СДЕЛАТЬ!!!

--- переменные
begin_timer = 0 --- время с начала волны
blinkstage = 0 --- 0 - экран становится белым, 1 - экран перестаёт быть белым, 2 - Азгор ждёт, 3 - стандартное сверкание глаз, 4 - комплексное сверкание глаз (работает только при поздних стадиях битвы), 5 - атака обычными, 6 - атака комплексными, 7 - оутро
WhatBlinkThisIs = 0 --- номер сверк. глаза
BlinkTimer = 0 --- таймер от одного обычного сверкающего глаза до следующего
AnimSwing = 0 --- номер фрейма анимации удара трезубца

--- таблички
flashcolors = {{1.0, 0.65, 0.0}, {0.25, 1.0, 1.0}, {200, 0, 0}}
flashc = {} --- отвечает за логику цвета обычного сверк. глаза
for i = 1, NumOfStandartBlinks do
    flashc[i] = math.random(1, 2)
end
for i = NumOfStandartBlinks + 1, NumOfStandartBlinks + NumOfComplexBlinks + 1 do
    if i == NumOfStandartBlinks + 1 then
        flashc[i] = math.random(1, 3)
    elseif flashc[i - 1] == 3 then
        flashc[i] = math.random(1, 2)
    else
        flashc[i] = 3
    end
end

--DEBUG(#flashc)

function Update()
    begin_timer = begin_timer + 1
    Hidestalker()
    if (blinkstage == 0) then
        if begin_timer == 1 then
            Audio.PlaySound("blink")
            whiteover = CreateProjectileAbs("bgwhite", 320, 240)
            whiteover.sprite.alpha = 1
            blinkstage = 1
        end
    elseif (blinkstage == 1) then
        if (whiteover.isactive) then
            whiteover.sprite.alpha = whiteover.sprite.alpha - 0.045
            if (whiteover.sprite.alpha == 0) then
                whiteover.Remove()
            end
        end
        if (begin_timer >= from_flash_to_blink) then
            blinkstage = 2
        end
    elseif (blinkstage == 2) then
        BlinkTimer = BlinkTimer + 1
        if (BlinkTimer == TimeBetweenBlinks and WhatBlinkThisIs <= NumOfStandartBlinks) then
            WhatBlinkThisIs = WhatBlinkThisIs + 1 --- обновляет номер сверк. глаза
            if WhatBlinkThisIs == NumOfStandartBlinks + NumOfComplexBlinks then
                Audio.PlaySound("eyeflash_final")
                eyeflash = CreateSprite("stalker/eyeflash1", "Top")
            else
                Audio.PlaySound("eyeflash")
                eyeflash = CreateSprite("stalker/normal_eyeflash1", "Top")
            end
            
            eyeflash.SetAnchor(0.5, 0)
            eyeflash.Scale(1, 1)
            eyeflash.color = flashcolors[flashc[WhatBlinkThisIs]]

            if (WhatBlinkThisIs % 2 == 0) then
                eyeflash.MoveTo(335, 425)
            else
                eyeflash.MoveTo(335 - 22, 425)
            end

            if WhatBlinkThisIs == NumOfStandartBlinks + NumOfComplexBlinks then
                eyeflash.SetAnimation({"stalker/eyeflash1", "stalker/eyeflash2", "stalker/eyeflash3", "stalker/eyeflash3",
                "stalker/eyeflash4", "stalker/eyeflash5", "empty"}, SpeedOfBlinks * 2)
                Audio.PlaySound("Warning_2")
            else
                eyeflash.SetAnimation({"stalker/normal_eyeflash1", "stalker/normal_eyeflash2", "stalker/normal_eyeflash3",
                "stalker/normal_eyeflash3", "stalker/normal_eyeflash4", "stalker/normal_eyeflash5", "empty"}, SpeedOfBlinks)
            end
        end
        if BlinkTimer >= TimeBetweenBlinks then
            if eyeflash.currentframe == 7 then
                eyeflash.Remove()
                BlinkTimer = 0
                if WhatBlinkThisIs == NumOfStandartBlinks then
                    if (NumOfComplexBlinks > 0) then
                        blinkstage = 3
                    else
                        blinkstage = 4
                        WhatBlinkThisIs = 0
                    end
                end
            end
        end
    elseif (blinkstage == 3) then
        BlinkTimer = BlinkTimer + 1
        if (BlinkTimer == TimeBetweenBlinks + 15 and WhatBlinkThisIs < NumOfComplexBlinks + NumOfStandartBlinks) then
            WhatBlinkThisIs = WhatBlinkThisIs + 1

            Audio.PlaySound("eyeflash_hard")
            eyeflash = CreateSprite("stalker/normal_eyeflash1", "Top")
            eyeflash2 = CreateSprite("stalker/normal_eyeflash1", "Top")

            eyeflash.SetAnchor(0.5, 0)
            eyeflash.Scale(1, 1)
            eyeflash2.color = flashcolors[flashc[WhatBlinkThisIs]]
            eyeflash.color = flashcolors[flashc[WhatBlinkThisIs + 1]]
            
            eyeflash.MoveTo(335, 425) ---RIGHT
            eyeflash2.MoveTo(335 - 22, 425)

        --[[if (WhatBlinkThisIs == NumOfStandartBlinks + NumOfComplexBlinks ) then
            if Player.x <= 0 then
                eyeflash.MoveTo(335, 425)
                eyeflash2.MoveTo(335 - 22, 425)
            else
                eyeflash2.MoveTo(335, 425)
                eyeflash.MoveTo(335 - 22, 425)
            end
        else
            if Player.x <= 0 then
                eyeflash2.MoveTo(335 + 22, 425)
                eyeflash.MoveTo(335 - 22, 425)
            else
                eyeflash.MoveTo(335, 425)
                eyeflash2.MoveTo(335 - 22, 425)
            end
        end]]

            if WhatBlinkThisIs == NumOfComplexBlinks + NumOfStandartBlinks then
                eyeflash2.SetAnimation({"stalker/eyeflash1", "stalker/eyeflash2", "stalker/eyeflash3", "stalker/eyeflash3",
                "stalker/eyeflash4", "stalker/eyeflash5", "stalker/eyeflash5", "stalker/normal_eyeflash5", "empty"}, SpeedOfBlinks * 2)
                eyeflash.SetAnimation({"stalker/normal_eyeflash1", "stalker/eyeflash1", "stalker/eyeflash3", "stalker/eyeflash3",
                "stalker/normal_eyeflash3", "stalker/normal_eyeflash4", "stalker/normal_eyeflash5", "stalker/normal_eyeflash5", "empty"}, SpeedOfBlinks * 2)
                eyeflash.rotation = 45
                eyeflash2.rotation = 25
                Audio.PlaySound("Warning_2")
            else
                eyeflash.SetAnimation({"stalker/normal_eyeflash1", "stalker/normal_eyeflash2", "stalker/normal_eyeflash3",
                "stalker/normal_eyeflash3", "stalker/normal_eyeflash4", "stalker/normal_eyeflash5", "stalker/normal_eyeflash5", "stalker/normal_eyeflash5", "empty"}, SpeedOfBlinks * 2)
                eyeflash2.SetAnimation({"stalker/eyeflash1", "stalker/eyeflash2", "stalker/eyeflash3", "stalker/eyeflash3",
                "stalker/eyeflash4", "stalker/eyeflash5", "stalker/eyeflash5", "stalker/normal_eyeflash5", "empty"}, SpeedOfBlinks * 2)
            end
        end
        if BlinkTimer >= TimeBetweenBlinks + 15 then
            if eyeflash2.currentframe == 9 then
                eyeflash.Remove()
                eyeflash2.Remove()
                BlinkTimer = 0
                if WhatBlinkThisIs == NumOfStandartBlinks + NumOfComplexBlinks then
                    blinkstage = 4
                    WhatBlinkThisIs = 0
                    ---DEBUG("done")
                end
            end
        end
    elseif (blinkstage == 4) then
        BlinkTimer = BlinkTimer + 1
        if (BlinkTimer == TimeBetweenBlinks) then --- ждёт
            if WhatBlinkThisIs ~= NumOfStandartBlinks + NumOfComplexBlinks then
                WhatBlinkThisIs = WhatBlinkThisIs + 1
            end
            if WhatBlinkThisIs > 1 then
                trident.Remove()
                hands.Remove()
            end
            Stalker.Remove()
            Stalker = CreateSprite("stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs), "Top")
            Stalker.Scale(2, 2)
            Stalker.SetPivot(0.5, 0)
            Stalker.MoveTo(320, 235)
            trident = CreateSprite("stalker/spear_spearhold" .. GetDirection(WhatBlinkThisIs), "Top")
            trident.Scale(2, 2)
            trident.SetPivot(0.5, 0)
            trident.MoveTo(320, 235)
            trident.color = flashcolors[flashc[WhatBlinkThisIs]]
            hands = CreateSprite("stalker/asgore_spearhold_hands" .. GetDirection(WhatBlinkThisIs), "Top")
            hands.Scale(2, 2)
            hands.SetPivot(0.5, 0)
            hands.MoveTo(320, 235)
        end
        if a == b then --- замах
        end
        if BlinkTimer == TimeBetweenBlinks + 15 then --- удар анимация
            Audio.PlaySound("spearswing")
            Stalker.SetAnimation({"stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs), "stalker/asgore_spearswing", "stalker/asgore_spearswing", "stalker/asgore_spearswing" .. GetDirection(WhatBlinkThisIs + 1),
            "stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs + 1), "empty"}, SpeedOfBlinks)

            trident.Remove()
            trident = CreateProjectileAbs("stalker/spear_spearswing", 320, 270)
            trident.sprite.color = flashcolors[flashc[WhatBlinkThisIs]]
            trident.SetVar('color', flashc[WhatBlinkThisIs])

            hands.Remove()
        end

        if (BlinkTimer >= TimeBetweenBlinks + 15) then --- удар конец
            if Stalker.currentframe == 3 then
                trident.sprite.Set("stalker/spear_spearswing" .. GetDirection(WhatBlinkThisIs + 1), 320, 270)
            end
            if Stalker.currentframe == 5 then
                Stalker.Remove()
                Stalker = CreateSprite("stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs + 1))
                Stalker.Scale(2, 2)
                Stalker.SetPivot(0.5, 0)
                Stalker.MoveTo(320, 235)

                trident.Remove()
                trident = CreateSprite("stalker/spear_spearhold" .. GetDirection(WhatBlinkThisIs + 1), "Top")
                trident.Scale(2, 2)
                trident.SetPivot(0.5, 0)
                trident.MoveTo(320, 235)
                trident.color = flashcolors[flashc[WhatBlinkThisIs]]

                hands = CreateSprite("stalker/asgore_spearhold_hands" .. GetDirection(WhatBlinkThisIs + 1), "Top")
                hands.Scale(2, 2)
                hands.SetPivot(0.5, 0)
                hands.MoveTo(320, 235)

                BlinkTimer = 0

                if WhatBlinkThisIs == NumOfStandartBlinks then
                    if NumOfComplexBlinks > 0 then
                        Arena.Resize(Arena.width * 2, Arena.height)
                        blinkstage = 5
                        BlinkTimer = 0
                        Player.speed = 200
                    else
                        blinkstage = 6
                    end
                end
            end
        end
    elseif (blinkstage == 5) then
        BlinkTimer = BlinkTimer + 1
        if BlinkTimer == TimeBetweenBlinks then
            WhatBlinkThisIs = WhatBlinkThisIs + 1

            Audio.PlaySound("pierce")
            
            if WhatBlinkThisIs ~= NumOfStandartBlinks + 1 then
                trident_right.Remove()
                hands_right.Remove()
                Stalker_right.Remove()
                Stalker_left.Remove()
                hands_left.Remove()
                trident_left.Remove()
            end
            
            trident_right = CreateSprite("stalker/spear_spearhold" .. GetDirection(WhatBlinkThisIs), "Top")
            trident_right.Scale(2, 2)
            trident_right.SetPivot(0.5, 0)
            trident_right.color = flashcolors[flashc[WhatBlinkThisIs + 1]]

            hands_right = CreateSprite("stalker/asgore_spearhold_hands" .. GetDirection(WhatBlinkThisIs), "Top")
            hands_right.Scale(2, 2)
            hands_right.SetPivot(0.5, 0)
                
            Stalker_right = CreateSprite("stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs), "Top")
            Stalker_right.Scale(2, 2)
            Stalker_right.SetPivot(0.5, 0)
            
            hands_left = CreateSprite("stalker/asgore_spearhold_hands" .. GetDirection(WhatBlinkThisIs), "Top")
            hands_left.Scale(2, 2)
            hands_left.SetPivot(0.5, 0)
                
            trident_left = CreateSprite("stalker/spear_spearhold" .. GetDirection(WhatBlinkThisIs), "Top")
            trident_left.Scale(2, 2)
            trident_left.SetPivot(0.5, 0)
            trident_left.color = flashcolors[flashc[WhatBlinkThisIs]]
            
            Stalker_left = CreateSprite("stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs), "Top")
            Stalker_left.Scale(2, 2)
            Stalker_left.SetPivot(0.5, 0)
            
            if WhatBlinkThisIs == NumOfStandartBlinks + 1 then --Азгор раздваивается
                Stalker.Remove()
                trident.Remove()
                hands.Remove()

                Arena.Resize(150, 20)
                Arena.MoveTo(Arena.x, Arena.y + 50, false, false)
                    
                trident_left.MoveTo(320, 235)
                Stalker_left.MoveTo(320, 235)
                hands_left.MoveTo(320, 235)
                Stalker_right.MoveTo(320, 235)
                trident_right.MoveTo(320, 235)
                hands_right.MoveTo(320, 235)
            else
                trident_left.MoveTo(320 - 190, 235)
                Stalker_left.MoveTo(320 - 190, 235)
                hands_left.MoveTo(320 - 190, 235)
                Stalker_right.MoveTo(320 + 190, 235)
                trident_right.MoveTo(320 + 190, 235)
                hands_right.MoveTo(320 + 190, 235)
            end
        end
        if BlinkTimer >= TimeBetweenBlinks and Stalker_left.x ~= 320 - 190 and WhatBlinkThisIs == NumOfStandartBlinks + 1 then
            Stalker_left.Move(-10, 0)
            trident_left.Move(-10, 0)
            hands_left.Move(-10, 0)

            Stalker_right.Move(10, 0)
            trident_right.Move(10, 0)
            hands_right.Move(10, 0)
        end
        if BlinkTimer == TimeBetweenBlinks + 50 and WhatBlinkThisIs ~= NumOfStandartBlinks + NumOfComplexBlinks + 1 then --- анимация двух ударов
            Audio.PlaySound("spearswing")
            
            Stalker_left.SetAnimation({"stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs), "stalker/asgore_spearswing" .. GetDirection(WhatBlinkThisIs + 1),
            "stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs + 1), "empty"}, SpeedOfBlinks * 1.5)
            Stalker_right.SetAnimation({"stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs), "stalker/asgore_spearswing" .. GetDirection(WhatBlinkThisIs + 1),
            "stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs + 1), "empty"}, SpeedOfBlinks * 1.5)

            trident_left.Remove()
            trident_left = CreateProjectileAbs("stalker/spear_spearswing", 320 - 180, 270)
            trident_left.sprite.color = flashcolors[flashc[WhatBlinkThisIs]]
            trident_left.SetVar('color', flashc[WhatBlinkThisIs])

            trident_right.Remove()
            trident_right = CreateProjectileAbs("stalker/spear_spearswing", 320 + 180, 270)
            trident_right.sprite.color = flashcolors[flashc[WhatBlinkThisIs + 1]]
            trident_right.SetVar('color', flashc[WhatBlinkThisIs + 1])

            hands_right.Remove()
            hands_left.Remove()
        end
        if (BlinkTimer >= TimeBetweenBlinks + 50) then --- удар конец
            if Stalker_left.currentframe == 2 then
                trident_left.sprite.Set("stalker/spear_spearswing" .. GetDirection(WhatBlinkThisIs + 1), 320 - 190, 270)
                trident_right.sprite.Set("stalker/spear_spearswing" .. GetDirection(WhatBlinkThisIs + 1), 320 + 190, 270)
            end
            if Stalker_left.currentframe == 4 then
                Stalker_right.Remove()
                Stalker_right = CreateSprite("stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs + 1))
                Stalker_right.Scale(2, 2)
                Stalker_right.SetPivot(0.5, 0)
                Stalker_right.MoveTo(320 + 190, 235)

                trident_right.Remove()
                trident_right = CreateSprite("stalker/spear_spearhold" .. GetDirection(WhatBlinkThisIs + 1), "Top")
                trident_right.Scale(2, 2)
                trident_right.SetPivot(0.5, 0)
                trident_right.MoveTo(320 + 190, 235)
                trident_right.color = flashcolors[flashc[WhatBlinkThisIs + 1]]

                hands_right = CreateSprite("stalker/asgore_spearhold_hands" .. GetDirection(WhatBlinkThisIs + 1), "Top")
                hands_right.Scale(2, 2)
                hands_right.SetPivot(0.5, 0)
                hands_right.MoveTo(320 + 190, 235)
                
                Stalker_left.Remove()
                Stalker_left = CreateSprite("stalker/asgore_spearhold" .. GetDirection(WhatBlinkThisIs + 1))
                Stalker_left.Scale(2, 2)
                Stalker_left.SetPivot(0.5, 0)
                Stalker_left.MoveTo(320 - 190, 235)

                trident_left.Remove()
                trident_left = CreateSprite("stalker/spear_spearhold" .. GetDirection(WhatBlinkThisIs + 1), "Top")
                trident_left.Scale(2, 2)
                trident_left.SetPivot(0.5, 0)
                trident_left.MoveTo(320 - 190, 235)
                trident_left.color = flashcolors[flashc[WhatBlinkThisIs]]

                hands_left = CreateSprite("stalker/asgore_spearhold_hands" .. GetDirection(WhatBlinkThisIs + 1), "Top")
                hands_left.Scale(2, 2)
                hands_left.SetPivot(0.5, 0)
                hands_left.MoveTo(320 - 190, 235)
                
                if WhatBlinkThisIs ~= NumOfStandartBlinks + NumOfComplexBlinks then
                    BlinkTimer = 0
                else
                    blinkstage = 6
                    BlinkTimer = 0
                end
            end
        end
        --[[ if BlinkTimer >= TimeBetweenBlinks and WhatBlinkThisIs == NumOfStandartBlinks + NumOfComplexBlinks then ---Азгор сдвигается
            if Stalker_left.x ~= 320 then
                Stalker_left.Move(10, 0)
                trident_left.Move(10, 0)
                hands_left.Move(10, 0)

                Stalker_right.Move(-10, 0)
                trident_right.Move(-10, 0)
                hands_right.Move(-10, 0)
            elseif Stalker_left.x == 320 then
                EndWave()
            end
        end ]]--
    elseif blinkstage == 6 then
        BlinkTimer = BlinkTimer + 1
        
        if NumOfComplexBlinks > 0 and Stalker_left.x ~= 320 then
            Stalker_left.Move(10, 0)
            trident_left.Move(10, 0)
            hands_left.Move(10, 0)

            Stalker_right.Move(-10, 0)
            trident_right.Move(-10, 0)
            hands_right.Move(-10, 0)
            --elseif Stalker_left.x == 320 then
            
        end

        if BlinkTimer == 60 then
            EndWave()
        end
    end
end

function EndingWave() 
    if NumOfComplexBlinks > 0 then
        trident_right.Remove()
        hands_right.Remove()
        Stalker_right.Remove()
        Stalker_left.Remove()
        hands_left.Remove()
        trident_left.Remove()
        Player.speed = 120
    else
        Stalker.Remove()
        trident.Remove()
        hands.Remove()
    end
end

function OnHit(bullet)
    if blinkstage == 5 or blinkstage == 4 then
        local color = bullet.GetVar("color")
        if color == 1 then
            if not Player.isMoving then
                Player.Hurt(5, 0.5)
            end
        elseif color == 2 then
            if Player.isMoving then
                Player.Hurt(5, 0.5)
            end
        else
            if Player.hp == 1 then
                Player.Hurt(1, 1.7) --dead
            else
                Player.Hurt(Player.hp - 1, 1.7)
            end
        end
    end
end

function GetDirection(swing)
    if (swing % 2 == 0) then
        return "left"
    else
        return "right"
    end
end