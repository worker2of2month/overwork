-- A basic encounter script skeleton you can copy and modify for your own creations.



encountertext = "[font:uidialog]Едкий запах заполняет комнату."
nextwaves = {}
wavetimer = 4.0
arenasize = {155, 130}
music = ""

enemies = {
"Stalker"
}

enemypositions = {
{0, 0}
}

autolinebreak = true
backpink = nil
intro = true
intro_battle_dialog = 0
starttime = Time.time

possible_attacks = {"Stalker_tridentswing_2"--[[, "Stalker_tridentswing", "Stalker_trident"]]}

function Update()
	currenttime = Time.time - starttime
    if intro then 
        --stalker_intro()
        --intro = false
    end
	Updatestalker()
	backpink.yscale = 10 + math.sin(Time.time * 1.2) * 5
end

function stalker_intro()
    if(intro_battle_dialog == 0 and Audio.playtime >= 3) then --4
		BattleDialog({"[effect:none][novoice][waitall:2](Ivas is ugly.)[w:1000][next]"})
		intro_battle_dialog = 1
        --require "Animations/asgore"
	end
	if(intro_battle_dialog == 1 and Audio.playtime >= 6) then --8
		BattleDialog({"[effect:none][novoice][waitall:2](Memcree is memcree.)[w:1000][next]"})
		intro_battle_dialog = 2
	end
	if(intro_battle_dialog == 2 and Audio.playtime >= 9) then --12
		BattleDialog({"[starcolor:000000][effect:none][novoice][waitall:2]   * (You are filled with...\r      [w:3]DETERMINATION)[w:1000][next]"})
		intro_battle_dialog = 3
	end
	if(intro_battle_dialog == 3 and Audio.playtime >= 17) then --17
		Audio.Stop()
		intro_battle_dialog = Time.time
	end
	if(intro_battle_dialog > 3 and Time.time - intro_battle_dialog >= 1) then
		intro_battle_dialog = nil
		State("ENEMYDIALOGUE")
        intro = false
	end
end

function EncounterStarting()
	require "Animations/asgore"
    Player.name = "Ivan"
    Audio.LoadFile("Stalker_theme_phase1")

	stalkercape.layer = "BelowArena"
	stalkerfeet.layer = "BelowArena"

	backpink = CreateSprite("backpink", "BelowUI")
 	backpink.SetPivot(0, 0)
	backpink.MoveTo(0, 0)
end

function EnemyDialogueStarting()
        --enemies[1]["currentdialogue"] = {"[noskip][w:5][next]",
	 --                               "[effect:none][voice:v_fluffybuns][waitall:1] Здесь должен быть очень эпичный диалог"}
    --end
end

function EnemyDialogueEnding()

	stalkercape.layer = "Ugly"
	stalkerfeet.layer = "Ugly"

    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    nextwaves = { possible_attacks[math.random(1, #possible_attacks)] }

	if nextwaves[1] == "Stalker_tridentswing" or nextwaves[1] == "Stalker_tridentswing_2" then
		Hidestalker()
	else
		Showstalker()
	end
end

function DefenseEnding() --This built-in function fires after the defense round ends
    stalkercape.layer = "BelowArena"
	stalkerfeet.layer = "BelowArena"

	Showstalker()
end

function HandleSpare()
    State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end

