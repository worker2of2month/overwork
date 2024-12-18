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
		local coef = 0 -- нужен, чтобы не допускать горизонтальных линий и в целях ОДЗ
	
		if AmountOfFireballs == 4 then
			
			if i % 2 == 0 then
				coef = i + 1
			else
				coef = i
			end
		else
			coef = i
		end
		
		local TanAgleArg = (coef * math.pi / (AmountOfFireballs / 2))

		local fireball = CreateProjectile("firebullet0", ExplosionX, ExplosionY)
		
		if TanAgleArg == math.pi / 2 or TanAgleArg == 3 * math.pi / 2 then
			if TanAgleArg == math.pi / 2 then
				
			else
			
			end
		else
			if (TanAgleArg == math.pi or TanAgleArg == 2 math.pi) then
				fireball.SetVar("TanAngle", 0)
			else
				local TanAngle = math.tan(TanAgleArg)
				fireball.SetVar("TanAngle", TanAngle)
			end
			
			if (TanAgleArg > math.pi / 2 and TanAgleArg < 3 * math.pi / 2) or TanAgleArg > 3 * math.pi / 2 then
				local DirectionX = 1
				fireball.SetVar("DirectionX", DirectionX)
			else
				local DirectionX = -1
				fireball.SetVar("DirectionX", DirectionX)
			end
		end
		
		fireball.SetVar("InitialY", ExplosionY)
		
		table.insert(fireballsFromExplosions, fireball)
	end
end

function FireballsUpdate(WhichOneToUpdate, i)

	if math.abs(WhichOneToUpdate.x) > Arena.x + 400 or math.abs(WhichOneToUpdate.y) > Arena.y + 400 then
		--WhichOneToUpdate.Remove()
		--DEBUG("deleted")
		--fireballsFromExplosions[i] = "done"
	else
		local InitialY = WhichOneToUpdate.GetVar("InitialY")
		local DirectionX = WhichOneToUpdate.GetVar("DirectionX")
		local TanAngle = WhichOneToUpdate.GetVar("TanAngle")
		
		local NewX = WhichOneToUpdate.x + 1 * DirectionX
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

--CreateGranade(200, -100, 10)
CreateGranade(300, 50, 10)
