-- A basic encounter script skeleton you can copy and modify for your own creations.



-- music = "shine_on_you_crazy_diamond" --Either OGG or WAV. Extension is added automatically. Uncomment for custom music.
--encountertext = "Hello and welcome to los pollos hermanos" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"Stalker_trident_easy"}
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

intro = true
intro_battle_dialog = 0
starttime = Time.time

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
possible_attacks = {"Stalker_granades"}

function Update()
	currenttime = Time.time - starttime
    if intro then 
        --stalker_intro()
        --intro = false
    end
	Updatestalker()
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
    --BattleDialog({"[effect:none][novoice][noskip][waitall:2][font:Russian](А)[w:1000][next]"})

    -- If you want to change the game state immediately, this is the place.
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
    --if intro then
    --    enemies[1]["currentdialogue"] = {"[noskip][w:30][next]",
	--                                 "[effect:none][voice:v_fluffybuns][waitall:1]Ivan...[w:30][next]",
	--								 "[effect:none][voice:v_fluffybuns][waitall:1]It was nice to meet you once again.[w:30][next]",
    --                                 "[effect:none][voice:v_fluffybuns][waitall:1]Goodbye.[w:30][next]"}
    --end
end

function EnemyDialogueEnding()

	stalkercape.layer = "Ugly"
	stalkerfeet.layer = "Ugly"

    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    nextwaves = { possible_attacks[math.random(#possible_attacks)] }
end

function DefenseEnding() --This built-in function fires after the defense round ends
    stalkercape.layer = "BelowArena"
	stalkerfeet.layer = "BelowArena"
end

function HandleSpare()
    State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end