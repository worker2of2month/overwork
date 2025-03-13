-- made by WD200019
local self = {}
self.slamthreshold = -6                                                     --the vertical speed you must have to play a slam sound when you hit the arena.
self.maxjump = 5.8                                                          --the amount of vertical velocity applied on the first frame of jumping.
local jump = 0                                                              --the current amount of vertical velocity being applied.
local decrease = 0.20                                                       --the amount by which the vertical velocity diminishes each frame.
self.speed = 2                                                              --the speed by which the player moves sideways.
local direction = "down"                                                    --the current direction of gravity.
local movex = 0                                                             --movement induced by platforms
local movey = 0                                                             --update: added vertically-moving platform support
self.platformhitbox = -2.9                                                  --distance from center of hitbox to bottom of hitbox
self.enableFakePlayer = false                                               --set to true to automatically use a fake player projectile, to make it appear above platforms

local platform = nil
local wallsound = "slam"
local div = 10
self.PlaySoundWhenHitWall = false

self.platforms = {}

function self.Initialize()
    Player.SetControlOverride(true)
    Player.sprite.color = {0,0,1}
end

function self.SetSound(sound)
    wallsound = sound
end

--[[function self.SetCurrentPlatform(platformy)
    platform = platformy
end]]--

function self.SetJump(var)
    jump = var                                                            --you can set the amount of velocity from outside this library!
end

function self.Dir(dir)                                                    --you can change the current direction of gravity from outside the library.
    if dir ~= nil then
        direction = dir
        if direction == "right" then
            Player.sprite.rotation = 90
        elseif direction == "up" then
            Player.sprite.rotation = 180
        elseif direction == "left" then
            Player.sprite.rotation = 270
        elseif direction == "down" then
            Player.sprite.rotation = 0
        end
    end
    return direction
end
function self.Update()
    for i = 1, div do                                                    --here is where we move the player according to gravity.
        if direction == "down" then                                            
            Player.MoveTo(Player.x + (self.GetSideInput()/div),Player.y + (self.GetVertInput()/div),false)
        elseif direction == "right" then
            Player.MoveTo(Player.x - (self.GetVertInput()/div),Player.y + (self.GetSideInput()/div),false)
        elseif direction == "up" then
            Player.MoveTo(Player.x + (self.GetSideInput()/div),Player.y - (self.GetVertInput()/div),false)
        elseif direction == "left" then
            Player.MoveTo(Player.x + (self.GetVertInput()/div),Player.y + (self.GetSideInput()/div),false)
        end
        if not platforming then
            for i = #self.platforms, 1, -1 do
                if self.platforms[i].isactive then
                    local plat = self.platforms[i]
                    if Player.x >= plat.x - (plat.sprite.width/2) and Player.x <= plat.x + (plat.sprite.width/2) then
                        if Player.y - (Player.sprite.height/2) <= plat.y + 4 and Player.y - (Player.sprite.height/2) >= plat.y + self.platformhitbox then
                            if self.GetVertInput()/div <= 0 then
                                
                                if self.fakeplayer == nil and self.enableFakePlayer then
                                    self.fakeplayer = CreateProjectile("ut-heart", Player.x, Player.y)
                                    self.fakeplayer.SetVar("canhit", false)
                                    self.fakeplayer.SetVar("safe", true)
                                    self.fakeplayer.sprite.color = Player.sprite.color
                                end
                                
                                platforming = true
                                platform = plat
                                movex = platform.GetVar("speed") ~= nil and platform.GetVar("speed") or 0
                                movey = platform.GetVar("vely") ~= nil and platform.GetVar("vely") or 0
                                Player.MoveTo(Player.x,platform.y + 5.5, false)
                                
                                break
                            end
                        end
                    end
                end
            end
        elseif platforming and platform ~= nil then
            if Player.x < platform.x - (platform.sprite.width/2) or Player.x > platform.x + (platform.sprite.width/2)
            or Player.y - (Player.sprite.height/2) > platform.y + 4 or Player.y - (Player.sprite.height/2) < platform.y + self.platformhitbox then
                if self.fakeplayer ~= nil then
                    self.fakeplayer.Remove()
                    self.fakeplayer = nil
                end
                
                platforming = false
                platform = nil
                movex = 0
                movey = 0
            else
                Player.MoveTo(Player.x, platform.y + 5.5, false)
                
                if self.fakeplayer then
                    self.fakeplayer.MoveTo(Player.x, Player.y)
                end
            end
        end
    end
    
    if self.fakeplayer then
        self.fakeplayer.sprite.alpha = Player.isHurting and 0 or 1
    end
    
    if platforming == true then
        Player.MoveToAbs(Player.absx, platform.absy + 5.5, false)
        if self.fakeplayer ~= nil then
            self.fakeplayer.MoveTo(Player.x, Player.y)
        end
    else
        if self.fakeplayer ~= nil then
            self.fakeplayer.Remove()
            self.fakeplayer = nil
        end
    end
end

function self.SpeedByInput(input)                                        --so that it works with the speed variable.
    if input > 0 then
        return self.speed
    else
        return 0
    end
end

function self.GetVertInput()                                            --controls jumping and movement.
    if self.CheckIfGrounded() and jump < self.slamthreshold and self.PlaySoundWhenHitWall then
        Audio.PlaySound(wallsound)
    end
    if self.CheckIfGrounded() and self.JumpInput() > 0 then
        jump = self.maxjump
    elseif not self.CheckIfGrounded() and self.JumpInput() == -1 and jump >= decrease then
        jump = jump/self.maxjump
    elseif self.CheckIfGrounded() and self.JumpInput() <= 0 then
        jump = 0
    end
    if not self.CheckIfGrounded() then
        jump = jump - (decrease/div)
    end
    return jump + math.abs(movey)
end

function self.JumpInput()                                                --gets the current jump button's input.
    if direction == "down" then
        return Input.Up
    elseif direction == "right" then
        return Input.Left
    elseif direction == "up" then
        return Input.Down
    elseif direction == "left" then
        return Input.Right
    end
end

function self.GetSideInput()                                            --gets the current side buttons' inputs.
    local num = 0
    if direction == "down" or direction == "up" then
        num = self.SpeedByInput(Input.Right) - self.SpeedByInput(Input.Left)
    elseif direction == "right" or direction == "left" then
        num = self.SpeedByInput(Input.Up) - self.SpeedByInput(Input.Down)
    end
    if Input.Cancel > 0 then
        return (num / 2) + (movex)
    else
        return (num) + (movex)
    end
end

function self.CheckIfGrounded()                                            --does exactly what its function name says.
    local bool = nil
    if     direction == "down"  and (Player.y - (Player.sprite.height/2)) > -(Arena.currentheight/2) then
        bool = false
    elseif direction == "right" and (Player.x + (Player.sprite.width/2))  <  (Arena.currentwidth/2)  then
        bool = false
    elseif direction == "up"    and (Player.y + (Player.sprite.height/2)) <  (Arena.currentheight/2) then
        bool = false
    elseif direction == "left"  and (Player.x - (Player.sprite.width/2))  > -(Arena.currentwidth/2)  then
        bool = false
    else
        bool = true
    end
    if platform ~= nil then
        if jump <= 0 and Player.x >= (platform.x - (platform.sprite.width/2)) and Player.x <= (platform.x + (platform.sprite.width/2)) then
            if Player.y >= platform.y + 1 and Player.y <= (platform.y + (platform.sprite.height/2)) then
                bool = true
                movex = platform.GetVar("speed") ~= nil and platform.GetVar("speed") or 0
                movey = platform.GetVar("vely") ~= nil and platform.GetVar("vely") or 0
                platforming = true
            else
                bool = false
                movex = 0
                movey = 0
                platforming = false
                platform = nil
            end
        else
            bool = false
            movex = 0
            movey = 0
            platforming = false
            platform = nil
        end
    end
    return bool
end

--[[function self.ResetPlat()
    platforming = false
    platform = nil
    movex = 0
    return false
end]]--

return self

--[[
Hey, wanna hear a joke?

So a library object walks into a bar.
He brings his own table. Which is himself.

...That was bad.
]]--