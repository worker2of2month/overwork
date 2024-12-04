Encounter["wavetimer"] = math.huge

Arena.Resize(150,150)

begin_timer = 0

granades = {}

fireballsFromExplosions = {}

function Update()

	begin_timer = begin_timer + 1
	
	for i, v in ipairs(granades) do
	    if v != "done" then --- "done" означает, что Пуля удалена из виду и вычисления уже не важны. Нулл нельзя использовать, т.к. я ещё не знаю способа реиндексации таблиции
		GranadesUpdate(granades[i], i)
	    end
	end
	
	for i, v in ipairs(fireballsFromExplosions) do
	    if v != "done" then
		FireballsUpdate(fireballsFromExplosions[i], i)
	    end
	end
	
end

function CreateGranade(StartingX, ExplosionY, SpeedValue)
	 local granade = CreateProjectileAbs("bigfire", StartingX, 500)
	 
	 granade.SetVar("SpeedValue", SpeedValue) 
	 granade.SetVar("ExplosionY", ExplosionY) -- Y, где взорвётся граната
	
	 table.insert(granades, granade)
end

function GranadesUpdate(WhichOneToUpdate, i)

	if WhichOneToUpdate.y != WhichOneToUpdate.GetVar("ExplosionY") then
		WhichOneToUpdate.MoveTo(WhichOneToUpdate.x, WhichOneToUpdate.y - WhichOneToUpdate.GetVar("SpeedValue"))
	else
		CreateAGranadeExplosion(8, WhichOneToUpdate.x, WhichOneToUpdate.y)
		WhichOneToUpdate.Remove()
		granades[i] = "done"
	end
	
end

function CreateAGranadeExplosion(AmountOfFireballs, ExplosionX, ExplosionY)
	for i=1,AmountOfFireballs do
	
		local fireball = CreateProjectile("firebullet0", ExplosionX, ExplosionY)
		
		
		local coef = 0 -- нужен, чтобы не допускать горизонтальных линий и в целях ОДЗ
		
		if i % 2 == 0 then
			coef = i + 1
		else
			coef = i
		end
		
		if i <= AmountOfFireballs / 2 then
			local DirectionX = 1
			fireball.SetVar("DirectionX", DirectionX)
		else
			local DirectionX = -1
			fireball.SetVar("DirectionX", DirectionX)
		end
		
		local TanAngle = math.tan(coef *  math.pi / AmountOfFireballs)
		
		fireball.SetVar("TanAngle", TanAngle)
		
		
		
		--fireball.SetVar("InitialX", ExplosionX)
		fireball.SetVar("InitialY", ExplosionY)
		
		table.insert(fireballsFromExplosions, fireball)
	end
end

function FireballsUpdate(WhichOneToUpdate, i)

	if math.abs(WhichOneToUpdate.x) > Arena.x + 400 or math.abs(WhichOneToUpdate.y) > Arena.y + 400 then
		WhichOneToUpdate.Remove()
		DEBUG("deleted")
		fireballsFromExplosions[i] = "done"
	else
		local InitialY = WhichOneToUpdate.GetVar("InitialY")
		local DirectionX = WhichOneToUpdate.GetVar("DirectionX")
		local TanAngle = WhichOneToUpdate.GetVar("TanAngle")
		
		local NewX = WhichOneToUpdate.x + 4 * DirectionX
		local NewY = InitialY + NewX * TanAngle
		
		WhichOneToUpdate.MoveTo(NewX, NewY)
	end
	
end

--[[function ReindexMyTable(myTable)
	temptable = {}

	for i, v in ipairs(myTable) do
	    if v != nil then
		table.insert(temptable, v)
	    end
	end

	myTable = temptable
	table.remove(temptable)
end]]

CreateGranade(200, -100, 10)
CreateGranade(400, -100, 10)
