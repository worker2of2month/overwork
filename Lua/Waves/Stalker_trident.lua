
spawntimer = 0 -- нужен для вызова трезубца 
last_beep_time = 0 -- время, через которое спрайт воск. знака поменяет цвет

warning_beep_time = 3 -- константа

attack_number = 0 -- это - 1 = сколько копий уже было брошено
spawn_shit_timer = 0

--epsilon = 5e-4

Encounter["wavetimer"] = math.huge

fireballs = {}
emitters = {}

FireWallEmitters = {}
FireWall = {}

Arena.Resize(150,150)

CreateLayer("Ugly", "Top", true)
Void = CreateSprite("masks/Arena_150x170", "Ugly", -1)
Void.MoveTo(Arena.x - 155, Arena.y + 89)
Void2 = CreateSprite("masks/Arena_150x170", "Ugly", -1)
Void2.MoveTo(Arena.x - 155 - 150, Arena.y + 89)
Void3 = CreateSprite("masks/Void_sprite", "Ugly", -1)
Void3.MoveTo(Arena.x - 10, Arena.y * 2 + 77)

arenaover = CreateSprite('masks/arenaover', "Ugly", -1)
arenaover.Scale(0.765, 0.765)
arenaover.MoveTo(Arena.x + 0.4, Arena.y * 2 - 10)

--Border = CreateSprite("masks/fwall", "Ugly", -1)
--Border.MoveTo(Arena.x - 155 - 150, Arena.y + 89)

function Update()



    if spawn_shit_timer % 7 == 0 and #emitters == 6 and #fireballs <= 100 then
        for i=1,6 do
            create_fireball(emitters[i])
        end
    end

    if wavy_fire_status== true and #emitters == 6 then
        for i = 1, #fireballs do
            update_fireball(fireballs[i])
        end
    end

    if #FireWallEmitters == 2 and #FireWall <= 66 and spawn_shit_timer % 15 == 0 then
        for i=1,2 do
            fire_wall_el_spawn(FireWallEmitters[i])
        end
    end

    if #FireWallEmitters == 2 then
        for i=#FireWall, 1 , -1 do
            local current_bullet = FireWall[i]

            if current_bullet.y < -Arena.height/2 + 10then
                table.remove(FireWall, i)
                current_bullet.Remove()
            else
                fire_wall_update(FireWall[i])
            end
        end
    end

    --DEBUG(Player.y)

    spawn_shit_timer = spawn_shit_timer + 1
    spawntimer = spawntimer + 1

    --[[CreateLayer("void", "BelowUI", true)
    void = CreateSprite("void")
    void.MoveToAbs(0,0)]]

    beep_update()
    if spawntimer == 4 then
        Audio.PlaySound("bwoar")
        create_trident()
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

function firewall_configuration()

    local wall_r = {}
    local wall_l = {}

    wall_l.amplitude = 0.95
	wall_r.amplitude = 0.95

    wall_r.init_x = -150

    wall_l.init_x = wall_r.init_x + 255

    table.insert(FireWallEmitters, wall_l)
    table.insert(FireWallEmitters, wall_r)

end

function fire_wall_el_spawn(wallemitter)

    local fire_wall_el = CreateProjectile("fire_wall", wallemitter.init_x, 69)

    fire_wall_el.SetVar("amplitude", wallemitter.amplitude)
    fire_wall_el.SetVar("time_from_beggin", 0)

    table.insert(FireWall, fire_wall_el)

end

function fire_wall_update(fire_wall_el)

    local time_from_beggin = fire_wall_el.GetVar("time_from_beggin") + 1
    fire_wall_el.SetVar("time_from_beggin", time_from_beggin)

    local Newx = fire_wall_el.GetVar("amplitude") * math.cos(time_from_beggin / 40 )

    fire_wall_el.Move(Newx, -0.8)
end

firewall_configuration()

function wavy_fire_configuration(x) -- firewall_number - номер волны огня 

    local emitter_r = {}
    local emitter_l = {}

    emitter_l.amplitude = -0.95
	emitter_r.amplitude = 0.95

    emitter_r.init_y = 222 + x * 15
    emitter_r.init_x = -110 + x * 55
    emitter_r.y_velocity = -2.85

    emitter_r.index = #emitters + 1

    emitter_l.init_y = 222 + x * 15
    emitter_l.init_x = -110 + x * 55
    emitter_l.y_velocity = -2.85

    emitter_l.index = #emitters

    table.insert(emitters, emitter_l)
    table.insert(emitters, emitter_r)

    wavy_fire_status= true 
end

--for i=1,3 do
--	wavy_fire_configuration(i)
--end

function create_fireball(emitter)

    local fireball = CreateProjectile("hitbox_fire", emitter.init_x, emitter.init_y)
    fireball.sprite.Scale (0.95, 0.95)
    fireball.sprite.Set("firebullet0")

    fireball.SetVar("time_from_beggin", 0)
    fireball.SetVar("amp_mul", 1)
    fireball.SetVar("amplitude", emitter.amplitude)
    fireball.SetVar("init_x", emitter.init_x)
    --fireball.SetVar("amp_mul_cooldown", 0)
    fireball.SetVar("Period", 0)
    fireball.SetVar("Period_timer", 0)


    table.insert(fireballs, fireball)

end

function update_fireball(fireball)

    local time_from_beggin = fireball.GetVar("time_from_beggin") + 1
    fireball.SetVar("time_from_beggin", time_from_beggin)

    --[[if math.abs(1 - math.cos(time_from_beggin / 40)) <= epsilon and Time.time - fireball.GetVar("amp_mul_cooldown") >= 40  then
        if (fireball.GetVar("amp_mul") == 1) then
            fireball.SetVar("amp_mul", 1/2)
        else 
            fireball.SetVar("amp_mul", 1)
        end
        fireball.SetVar("amp_mul_cooldown", Time.time)
    end]]

    if fireball.GetVar("init_x") == fireball.x and fireball.GetVar("Period") == 0 then 
        fireball.SetVar("amp_mul", 1/55)
        fireball.SetVar("Period", 1)
        fireball.SetVar("Period_timer", 0)
    elseif fireball.GetVar("Period") == 1 and fireball.GetVar("Period_timer") == 5 then
        fireball.SetVar("amp_mul", 1)
        fireball.SetVar("Period", 0)
    end

    if fireball.GetVar("Period") == 1 then
        fireball.SetVar("Period_timer", fireball.GetVar("Period_timer") + 1)
    end


    --DEBUG(fireball.GetVar("amp_mul_cooldown"))

    --DEBUG(tostring(math.abs(1 - math.cos(time_from_beggin / 40))))

    local amp_mul = fireball.GetVar("amp_mul")

    local amplitude = fireball.GetVar("amplitude") * amp_mul

    local Newx = 1.5 * amplitude * math.cos(time_from_beggin / 40 * 4)

    fireball.Move(Newx, -1.9)

    --DEBUG(tostring(Newx))
 
    --[[for key, value in pairs(fireballs) do
        DEBUG(key, value)
    end]]

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
    Void3.Remove()
    arenaover.Remove()
end

function OnHit(bullet)
    Player.Hurt(5) --EndWave()
end