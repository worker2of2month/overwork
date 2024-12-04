
CreateLayer("Ugly","Top")
CreateLayer("Ugly2","Top")
CreateLayer("Ugly3","Top")

stalkercape = CreateSprite("stalker/stalkercape0", "Ugly")
stalkerfeet = CreateSprite("stalker/stalkerfeet", "Ugly")
stalkerlegs = CreateSprite("stalker/stalkerlegs", "Ugly")
stalkerdress = CreateSprite("stalker/stalkerdress", "Ugly")
stalkertorso = CreateSprite("stalker/stalkertorso", "Ugly")
stalkerhead = CreateSprite("stalker/stalkerhead", "Ugly")

stalkerspear = CreateSprite("stalker/Stalkerspear", "Ugly")

stalkerarmr = CreateSprite("stalker/stalkerarmright")
stalkerarml = CreateSprite("stalker/stalkerarmleft")
stalkerupperarmr = CreateSprite("stalker/stalkerballarm")
stalkerupperarml = CreateSprite("stalker/stalkerballarm")
stalkerhandr = CreateSprite("stalker/stalkerhandr")
stalkerhandl = CreateSprite("stalker/stalkerhandl")

stalkerlegs.SetParent(stalkerfeet)
stalkerdress.SetParent(stalkerlegs)
stalkertorso.SetParent(stalkerdress)
stalkerhead.SetParent(stalkertorso)

stalkerarmr.SetParent(stalkertorso)
stalkerarml.SetParent(stalkertorso)
stalkerupperarmr.SetParent(stalkerarmr)
stalkerupperarml.SetParent(stalkerarml)

stalkerspear.SetParent(stalkerupperarml)

stalkerhandl.SetParent(stalkerspear)
stalkerhandr.SetParent(stalkerspear)

offset_anim_stalker = 20

stalkerlegs.y = 2 
stalkerdress.y = -2 + offset_anim_stalker
stalkerdress.x = 0
stalkertorso.y = -2 + offset_anim_stalker
stalkerfeet.y = 246 + offset_anim_stalker
stalkerfeet.x = 320
stalkerfeet.xscale = 0.5
stalkerfeet.yscale = 0.5
stalkerhead.y = -4 

stalkerarml.y = -50 
stalkerarmr.y = -50 

stalkerarml.x = -95
stalkerarmr.x = 95

stalkerupperarml.y = -40
stalkerupperarmr.y = -55

stalkerupperarml.x = -10
stalkerupperarmr.x = 0

stalkerhandl.y = -15
stalkerhandr.y = 11 

stalkerspear.x = -30
stalkerspear.y = 68
stalkerspear.rotation = -21

stalkerhandl.x = -140
stalkerhandr.x = 30

stalkerupperarml.xscale = 1
stalkerupperarml.yscale = 1.25
stalkerupperarml.rotation = 2

stalkerupperarmr.xscale = 0.8
stalkerupperarmr.yscale = 1
stalkerupperarmr.rotation = 12

stalkerhandl.rotation = -20
stalkerhandr.rotation = -25

stalkerfeet.SetPivot(0.5, 0)
stalkerlegs.SetPivot(0.5, 0)
stalkerdress.SetPivot(0.5, 0)
stalkertorso.SetPivot(0.5, 0)
stalkercape.SetPivot(0.515, -0.05)
stalkerhead.SetPivot(0.5, 0)

stalkerarml.SetPivot(0, 0)
stalkerarmr.SetPivot(1, 0)
stalkerupperarml.SetPivot(0.5, 0)
stalkerupperarmr.SetPivot(0.5, 0)
stalkerspear.SetPivot(0.1, 0.86)
stalkerhandl.SetPivot(0.4, 0)
stalkerhandr.SetPivot(0.7, 1)

stalkercapemark1mark = 0.5
stalkercapemark2mark = 0.5
stalkercapemark1 = 0.5
stalkercapemark2 = 1


function Hidestalker()
	stalkercape.alpha = 0
	stalkerfeet.alpha = 0
	stalkerlegs.alpha = 0
	stalkerdress.alpha = 0
	stalkertorso.alpha = 0
	stalkerhead.alpha = 0

	stalkerspear.alpha = 0

	stalkerarmr.alpha = 0
	stalkerarml.alpha = 0
	stalkerupperarmr.alpha = 0
	stalkerupperarml.alpha = 0
	stalkerhandr.alpha = 0
	stalkerhandl.alpha = 0
end

function Showstalker()
	stalkercape.alpha = 1
	stalkerfeet.alpha = 1
	stalkerlegs.alpha = 1
	stalkerdress.alpha = 1
	stalkertorso.alpha = 1
	stalkerhead.alpha = 1

	stalkerspear.alpha = 1

	stalkerarmr.alpha = 1
	stalkerarml.alpha = 1
	stalkerupperarmr.alpha = 1
	stalkerupperarml.alpha = 1
	stalkerhandr.alpha = 1
	stalkerhandl.alpha = 1
end

function Updatestalker()
	if currenttime > stalkercapemark1 then
		stalkercape.Set("stalker/stalkercape0")
		stalkercapemark1 = stalkercapemark1 + (stalkercapemark1mark*2)
	end
	if currenttime > stalkercapemark2 then
		stalkercape.Set("stalker/stalkercape1")
		stalkercapemark2 = stalkercapemark2 + (stalkercapemark2mark*2)
	end
		
	stalkerdress.MoveTo(stalkerdress.x,-8+(math.sin(Time.time*1.4)*1.5))
	stalkertorso.MoveTo(stalkertorso.x,14+(math.cos(Time.time*1.7)*1.2))
	stalkercape.MoveTo(stalkerfeet.x,stalkerfeet.y+(math.sin(Time.time*1.7)*1.2))
	stalkerhead.MoveTo(stalkerhead.x,-4+(math.sin(Time.time*1.35)*1.5))
	stalkerupperarml.MoveTo(stalkerupperarml.x,-40+(math.sin(Time.time*1.2)*1.6))
	stalkerupperarmr.MoveTo(stalkerupperarmr.x,-55+(math.sin(Time.time*1.2)*1.6))
	stalkerspear.MoveTo(stalkerspear.x,68+(math.sin(Time.time*1.35)*1.5))
		
	SetGlobal("speary", stalkerspear.y)
end