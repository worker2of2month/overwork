granades = {}

Encounter["wavetimer"] = math.huge

spawntime = 0

function math.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end


function granade_update(granade)
    local TimeFromStart = granade.GetVar("TimeFromStart")
    local function_t = TimeFromStart
    local ang = math.clamp(function_t, -90, 0)/180 * math.pi
    local Newy = math.sin(ang) 

    if math.clamp(function_t, -90, 0) > -90 then
        local Newx = 0.6
        granade.Move(Newx, Newy)
    else
        local Newx = 0
        granade.Move(Newx, Newy)
    end

    granade.SetVar("TimeFromStart", TimeFromStart - 1)
end

function granade_create()
    local granade = CreateProjectile("firebullet0", -50, 100)

    granade.SetVar("TimeFromStart", 0)


    table.insert(granades, granade)
end

granade_create()

function Update()
    spawntime = spawntime + 55

    if spawntime % 11 == 0 then 
        for i = 1, #granades do
            granade_update(granades[i])
        end
    end
end