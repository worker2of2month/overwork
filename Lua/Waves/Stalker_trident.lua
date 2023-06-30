
spawntimer = 0 -- нужен для вызова трезубца 
last_beep_time = 0 -- время, через которое спрайт воск. знака поменяет цвет

warning_beep_time = 3 -- константа

attack_number = 0 -- это - 1 = сколько копий уже было брошено

Encounter["wavetimer"] = math.huge

fireballs = {}
emitters = {}

Arena.Resize(150,150)

CreateLayer("Ugly", "Top", true)
Void = CreateSprite("masks/Arena_150x170", "Ugly", -1)
Void.MoveTo(Arena.x - 155, Arena.y + 89)
Void2 = CreateSprite("masks/Arena_150x170", "Ugly", -1)
Void2.MoveTo(Arena.x - 155 - 150, Arena.y + 89)

function Update()

    if firewall_status == true then
        for i = 1, #fireballs do
            update_fireball(fireballs[i])
        end
    end

    --DEBUG(Player.y)

    --spawntimer = spawntimer + 1

    --[[CreateLayer("void", "BelowUI", true)
    void = CreateSprite("void")
    void.MoveToAbs(0,0)]]

    beep_update()
    if spawntimer == 4 then
        Audio.PlaySound("bwoar")
        --create_trident()
    end

    if spawntimer > 45 and spawntimer < 100 and bullet.x != -15 then
        bullet.Move(15, 0)
        warning.Remove()
        warning_sign.Remove()
        battle_status = nil
        if spawntimer > 46 and spawntimer < 48 then
            Audio.PlaySound("spearswing")
        end
        if bullet.x < -14 then
            Misc.ShakeScreen( 5, 10, false)
        end
    elseif spawntimer > 100 and bullet.x != -200 then
        bullet.Move(-5, 0)
    elseif spawntimer > 100 and bullet.x == -200 then
        bullet.Remove()
        if attack_number == 6 then 
            EndWave()
        end
        spawntimer = 0
    end

end

function firewall_configuration(x) -- firewall_number - номер волны огня 

    local emitter_r = {}

    emitter_r.init_y = 110
    emitter_r.init_x = -100 + x * 64
    emitter_r.y_velocity = -2.85

    table.insert(emitters, emitter_r)

    firewall_status = true 

    if #fireballs == 0 and #emitters == 7 then
        for i=1,7 do
            create_fireball(emitters[i])
        end
    end
end

function create_fireball(emitter)
    local fireball = CreateProjectile("hitbox_fire", math.random(30,60), emitter.init_y)
    
    table.insert(fireballs, fireball)
end

function update_fireball(fireball)
    fireball.Move(0, -1)
 
    for key, value in pairs(fireballs) do
        DEBUG(key, value)
    end
end

for i=1,7 do
	firewall_configuration(i)
end


function create_trident()
    if Player.y < -43 then
		offset = 30
	elseif Player.y > 50 then
		offset = -30
	elseif Player.y > -43 and Player.y < 50 then
		offset = 0
	end
    attack_number = attack_number + 1
    Audio.PlaySound("Warning")
    bullet = CreateProjectile("trident_attack", -195, Player.y + offset --[[math.random(-40, 40)]])
    bullet.ppcollision = true

    beep()

    warning = CreateSprite("warning/WarningTrident", "BelowPlayer", -1)
    warning.color = {0.9, 0.9, 0.9}
    warning.Scale(0.75, 0.75)
    warning.MoveTo(Arena.x, 167 + bullet.y)

end 

function beep()
    warning_sign = CreateSprite("warning/warning_exclamation", "BelowPlayer", -1)
    warning_sign.MoveTo(Arena.x, 167 + bullet.y)
    battle_status = "warning"
    last_beep_time = Time.time
end

function beep_update()
    if battle_status != "warning" then
        return 
    end

    
    if not warning_is_yellow then 
        if Time.time - last_beep_time >= warning_beep_time / 30 then
            warning_is_yellow = true
            last_beep_time = Time.time
            warning_sign.color = {1, 1, 0.5}
        end
    else
        warning_is_yellow = false
        warning_sign.color = {1, 0.25, 0.25}
    end
end


function EndingWave() 
    Void.Remove()
    warning.Remove()
    Void2.Remove()
end

function OnHit(bullet)
    Player.Hurt(5) --EndWave()
end