GLOBAL_VAR_INIT(violence_mode_activated, FALSE)
GLOBAL_VAR_INIT(violence_current_round, 0)
GLOBAL_VAR_INIT(violence_random_theme, 1)
GLOBAL_VAR(violence_landmark)
GLOBAL_VAR(violence_red_datum)
GLOBAL_VAR(violence_blue_datum)
GLOBAL_LIST_EMPTY(violence_red_team)
GLOBAL_LIST_EMPTY(violence_blue_team)

/datum/game_mode/violence
	name = "violence"
	config_tag = "violence"
	report_type = "violence"
	enemy_minimum_age = 0

	var/round_active = FALSE
	var/round_started_at = 0
	var/shutters_closed = TRUE
	var/area/main_area

	var/max_reds = 2
	var/max_blues = 2

	announce_span = "danger"
	announce_text = "Резня!"

/datum/game_mode/violence/pre_setup()
	SSticker.login_music = sound('white/valtos/sounds/quiet_theme.ogg')
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			C.mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			C.playtitlemusic()
	var/obj/effect/landmark/violence/V = GLOB.violence_landmark
	V.load_map()
	GLOB.disable_fucking_station_shit_please = TRUE
	GLOB.violence_mode_activated = TRUE
	main_area = GLOB.areas_by_type[/area/violence]
	SSair.flags |= SS_NO_FIRE
	SSevents.flags |= SS_NO_FIRE
	SSnightshift.flags |= SS_NO_FIRE
	SSorbits.flags |= SS_NO_FIRE
	SSweather.flags |= SS_NO_FIRE
	SSeconomy.flags |= SS_NO_FIRE
	SSjob.DisableAllJobs()
	GLOB.violence_red_datum = new /datum/team/violence/red
	GLOB.violence_blue_datum = new /datum/team/violence/blue
	GLOB.position_categories = list(
		EXP_TYPE_COMBATANT_RED = list("jobs" = GLOB.combatant_red_positions, "color" = "#ff0000", "runame" = "Красные"),
		EXP_TYPE_COMBATANT_BLUE = list("jobs" = GLOB.combatant_blue_positions, "color" = "#0000ff", "runame" = "Синие")
	)
	GLOB.exp_jobsmap = list(
		EXP_TYPE_COMBATANT_RED = list("titles" = GLOB.combatant_red_positions),
		EXP_TYPE_COMBATANT_BLUE = list("titles" = GLOB.combatant_blue_positions)
	)
	return TRUE

/datum/game_mode/violence/can_start()
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	return TRUE

/datum/game_mode/violence/post_setup()
	..()
	SSjob.DisableAllJobs()
	CONFIG_SET(flag/allow_random_events, FALSE)
	spawn(1 SECONDS)
		new_round()

/datum/game_mode/violence/generate_report()
	return "В вашем секторе проводится самый кровавый чемпионат, а также мы тестируем нашу новейшую систему удалённого клонирования. Приятной смены!"

/datum/game_mode/violence/send_intercept(report = 0)
	return

/datum/game_mode/violence/proc/play_sound_to_everyone(snd)
	for(var/mob/M in GLOB.player_list)
		SEND_SOUND(M, snd)

/datum/game_mode/violence/process()
	if(round_active)
		for(var/datum/mind/R in GLOB.violence_red_team)
			if(!R?.current)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')))
				GLOB.violence_red_team -= R
			else if(R?.current?.stat == DEAD)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')))
				GLOB.violence_red_team -= R
		for(var/datum/mind/B in GLOB.violence_blue_team)
			if(!B?.current)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')))
				GLOB.violence_blue_team -= B
			else if(B?.current?.stat == DEAD)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')))
				GLOB.violence_blue_team -= B
		if(GLOB.violence_red_team.len == max_reds)
			max_reds++
			SSjob.AddJobPositions(/datum/job/combantant/red, max_reds, max_reds)
		if(GLOB.violence_blue_team.len == max_blues)
			max_blues++
			SSjob.AddJobPositions(/datum/job/combantant/blue, max_blues, max_blues)
		if(shutters_closed && round_started_at + 30 SECONDS < world.time)
			shutters_closed = FALSE
			to_chat(world, leader_brass("В БОЙ!"))
			play_sound_to_everyone('white/valtos/sounds/gong.ogg')
			for(var/obj/machinery/door/poddoor/D in main_area)
				INVOKE_ASYNC(D, /obj/machinery/door/poddoor.proc/open)
		if(round_started_at + 30 SECONDS < world.time)
			if(GLOB.violence_red_team.len == 0 && GLOB.violence_blue_team.len)
				end_round("СИНИХ")
			if(GLOB.violence_blue_team.len == 0 && GLOB.violence_red_team.len)
				end_round("КРАСНЫХ")
			if(GLOB.violence_red_team.len == 0 && GLOB.violence_blue_team.len == 0)
				end_round()

/datum/game_mode/violence/proc/end_round(winner = "ХУЙ ЕГО ЗНАЕТ КОГО")
	round_active = FALSE
	SSjob.SetJobPositions(/datum/job/combantant/red, 0, 0, TRUE)
	SSjob.SetJobPositions(/datum/job/combantant/blue, 0, 0, TRUE)
	spawn(3 SECONDS)
		play_sound_to_everyone('white/valtos/sounds/gong.ogg')
		to_chat(world, leader_brass("РАУНД [GLOB.violence_current_round] ЗАВЕРШЁН!"))
		to_chat(world, leader_brass("ПОБЕДА [winner]!"))
	play_sound_to_everyone('white/valtos/sounds/crowd_win.ogg')
	spawn(10 SECONDS)
		new_round()

/datum/game_mode/violence/proc/clean_arena()
	shutters_closed = TRUE
	for(var/obj/item/clothing/O in main_area)
		qdel(O)
	for(var/obj/item/kitchen/O in main_area)
		qdel(O)
	for(var/obj/item/melee/O in main_area)
		qdel(O)
	for(var/obj/item/weldingtool/O in main_area)
		qdel(O)
	for(var/obj/item/grenade/O in main_area)
		qdel(O)
	for(var/obj/item/wrench/O in main_area)
		qdel(O)
	for(var/obj/item/extinguisher/O in main_area)
		qdel(O)
	for(var/obj/item/restraints/O in main_area)
		qdel(O)
	for(var/obj/item/shield/O in main_area)
		qdel(O)
	for(var/obj/item/gun/O in main_area)
		qdel(O)
	for(var/obj/item/storage/O in main_area)
		qdel(O)
	for(var/obj/item/reagent_containers/O in main_area)
		qdel(O)
	for(var/obj/item/ammo_casing/O in main_area)
		qdel(O)
	for(var/obj/effect/hotspot/O in main_area)
		qdel(O)
	for(var/obj/item/bodypart/O in main_area)
		qdel(O)
	for(var/obj/item/organ/O in main_area)
		qdel(O)
	for(var/obj/item/katana/O in main_area)
		qdel(O)
	for(var/obj/effect/decal/cleanable/O in main_area)
		qdel(O)
	for(var/mob/M in main_area)
		qdel(M)
	for(var/obj/machinery/door/poddoor/D in main_area)
		INVOKE_ASYNC(D, /obj/machinery/door/poddoor.proc/close)

/datum/game_mode/violence/proc/new_round()
	GLOB.violence_current_round++
	GLOB.violence_random_theme = rand(1, 2)
	if(GLOB.violence_current_round == 6)
		return
	GLOB.violence_red_team = list()
	GLOB.violence_blue_team = list()
	for(var/mob/M in GLOB.player_list)
		M?.mind?.remove_all_antag_datums()
		SEND_SOUND(M, sound(null, channel = CHANNEL_VIOLENCE_MODE))
		var/mob/dead/new_player/NP = new()
		NP.ckey = M.ckey
		qdel(M)
	clean_arena()
	spawn(10 SECONDS)
		max_reds = 2
		max_blues = 2
		round_active = TRUE
		round_started_at = world.time
		to_chat(world, leader_brass("РАУНД [GLOB.violence_current_round] НАЧАЛСЯ!"))
		SSjob.ResetOccupations("Violence")
		SSjob.SetJobPositions(/datum/job/combantant/red, 200, 200, TRUE)
		SSjob.SetJobPositions(/datum/job/combantant/blue, 200, 200, TRUE)
		play_sound_to_everyone('white/valtos/sounds/horn.ogg')

/datum/game_mode/violence/check_finished()
	if(GLOB.violence_current_round == 6)
		if(!GLOB.admins.len && !GLOB.deadmins.len)
			GLOB.master_mode = "secret"
			SSticker.save_mode(GLOB.master_mode)
			SSmapping.changemap(config.maplist["Box Station"])
		return TRUE
	else
		return ..()

/datum/team/violence
	name = "Боевики: Белые"

/datum/team/violence/red
	name = "Боевики: Красные"
	member_name = "Боевик красных"

/datum/team/violence/blue
	name = "Боевики: Синие"
	member_name = "Боевик синих"

/datum/antagonist/combatant
	name = "Боевик белых"

/datum/antagonist/combatant/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)

/datum/antagonist/combatant/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)

/datum/antagonist/combatant/red
	name = "Боевик красных"
	antag_hud_type = ANTAG_HUD_CULT
	antag_hud_name = "hog-red-2"

/datum/antagonist/combatant/red/get_team()
	return GLOB.violence_red_datum

/datum/antagonist/combatant/red/on_gain()
	. = ..()
	GLOB.violence_red_team |= owner
	var/datum/team/T = GLOB.violence_red_datum
	if(T)
		T.add_member(owner)

/datum/antagonist/combatant/blue
	name = "Боевик синих"
	antag_hud_type = ANTAG_HUD_CLOCKWORK
	antag_hud_name = "hog-blue-2"

/datum/antagonist/combatant/blue/get_team()
	return GLOB.violence_blue_datum

/datum/antagonist/combatant/blue/on_gain()
	. = ..()
	GLOB.violence_blue_team |= owner
	var/datum/team/T = GLOB.violence_blue_datum
	if(T)
		T.add_member(owner)

/datum/job/combantant
	title = "Combantant"
	ru_title = "Комбатант"
	faction = "Violence"
	total_positions = 0
	spawn_positions = 0
	supervisors = "практически всем"
	selection_color = "#dddddd"
	outfit = /datum/outfit/job/combantant
	antag_rep = 0

/datum/job/combantant/red
	title = "Combantant: Red"
	ru_title = "Комбатант: Красные"
	faction = "Violence"
	supervisors = "красным"
	selection_color = "#dd0000"
	outfit = /datum/outfit/job/combantant/red

/datum/job/combantant/red/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	var/datum/antagonist/combatant/red/comb = new
	H.mind.add_antag_datum(comb)

/datum/job/combantant/blue
	title = "Combantant: Blue"
	ru_title = "Комбатант: Синие"
	faction = "Violence"
	supervisors = "синим"
	selection_color = "#0000dd"
	outfit = /datum/outfit/job/combantant/blue

/datum/job/combantant/blue/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	var/datum/antagonist/combatant/blue/comb = new
	H.mind.add_antag_datum(comb)

/datum/outfit/job/combantant
	name = "Combantant"
	jobtype = /datum/job/combantant
	uniform = /obj/item/clothing/under/syndicate/camo
	shoes = /obj/item/clothing/shoes/combat
	l_pocket = null
	r_pocket = null
	id = null
	belt = null
	ears = null

/datum/outfit/job/combantant/red
	name = "Combantant: Red"
	jobtype = /datum/job/combantant/red
	uniform = /obj/item/clothing/under/color/red

/datum/outfit/job/combantant/blue
	name = "Combantant: Blue"
	jobtype = /datum/job/combantant/blue
	uniform = /obj/item/clothing/under/color/blue

/datum/outfit/job/combantant/pre_equip(mob/living/carbon/human/H)
	..()
	back = null
	switch(GLOB.violence_current_round)
		if(1)
			r_hand = pick(list(null, /obj/item/weldingtool, /obj/item/grenade/iedcasing/spawned, /obj/item/wrench, /obj/item/extinguisher))
		if(2)
			if(GLOB.violence_random_theme == 1)
				suit = /obj/item/clothing/suit/armor/vest/durathread
				head = /obj/item/clothing/head/beret/durathread
				r_hand = pick(list(/obj/item/kitchen/knife/combat, /obj/item/melee/sabre/officer, /obj/item/melee/baseball_bat, /obj/item/melee/energy/sword/saber))
				l_hand = pick(list(/obj/item/shield/riot/buckler, /obj/item/restraints/legcuffs/bola))
			else
				head = /obj/item/clothing/head/turban
				suit = /obj/item/clothing/suit/chaplainsuit/studentuni
				shoes = /obj/item/clothing/shoes/sandal
				l_pocket = /obj/item/grenade/frag
				r_hand = pick(list(/obj/item/kitchen/knife/combat, /obj/item/melee/sabre/officer, /obj/item/melee/energy/sword/saber))
				l_hand = pick(list(/obj/item/kitchen/knife/combat, /obj/item/melee/sabre/officer, /obj/item/melee/energy/sword/saber))
		if(3)
			if(GLOB.violence_random_theme == 1)
				suit = /obj/item/clothing/suit/armor/bulletproof
				head = /obj/item/clothing/head/helmet/alt
				r_hand = pick(list(/obj/item/gun/ballistic/shotgun/automatic/combat, /obj/item/gun/ballistic/automatic/mini_uzi, /obj/item/gun/ballistic/automatic/pistol/m1911, /obj/item/gun/ballistic/automatic/pistol/makarov, /obj/item/gun/ballistic/automatic/pistol/luger, /obj/item/gun/ballistic/automatic/pistol/aps))
				l_pocket = pick(list(/obj/item/reagent_containers/hypospray/medipen/salacid, /obj/item/grenade/frag))
			else
				uniform = pick(list(/obj/item/clothing/under/costume/kamishimo, /obj/item/clothing/under/costume/kimono/dark, /obj/item/clothing/under/costume/kimono/sakura, /obj/item/clothing/under/costume/kimono/fancy, /obj/item/clothing/under/costume/kamishimo, /obj/item/clothing/under/costume/bathrobe))
				head = /obj/item/clothing/head/rice_hat
				if(prob(50))
					suit = /obj/item/clothing/suit/costume/samurai
					head = /obj/item/clothing/head/costume/kabuto
				shoes = /obj/item/clothing/shoes/sandal
				belt = /obj/item/katana
		if(4)
			if(GLOB.violence_random_theme == 1)
				gloves = /obj/item/clothing/gloves/combat/sobr
				suit = /obj/item/clothing/suit/armor/opvest/sobr
				belt = /obj/item/storage/belt/military/assault/sobr
				back = /obj/item/gun/ballistic/automatic/ak74m
				switch(rand(1, 2))
					if(1)
						back = /obj/item/gun/ballistic/shotgun/saiga
						suit = /obj/item/clothing/suit/armor/heavysobr
						belt = /obj/item/storage/belt/military/assault/sobr/specialist
						mask = /obj/item/clothing/mask/gas/heavy/m40
						head = /obj/item/clothing/head/helmet/maska/altyn/black
					if(2)
						mask = /obj/item/clothing/mask/gas/heavy/gp7vm
						head = /obj/item/clothing/head/helmet/maska/altyn
			else
				gloves = /obj/item/clothing/gloves/combat
				head = /obj/item/clothing/head/helmet/elite
				suit = /obj/item/clothing/suit/armor/vest/m35/black
				switch(rand(1, 2))
					if(1)
						mask = /obj/item/clothing/mask/gas/germanfull
						r_hand = /obj/item/gun/ballistic/automatic/mp40
						r_pocket = /obj/item/ammo_box/magazine/mp40
					if(2)
						mask = /obj/item/clothing/mask/gas/german
						r_hand = /obj/item/gun/ballistic/automatic/pistol/mauser
						r_pocket = /obj/item/ammo_box/magazine/mauser/battle
						belt = /obj/item/melee/sabre/marineofficer
		if(5)
			suit = /obj/item/clothing/suit/space/hardsuit/deathsquad
			belt = /obj/item/gun/ballistic/revolver/mateba
			r_hand = /obj/item/gun/energy/pulse
			r_pocket = /obj/item/shield/energy
			if(prob(50))
				suit = /obj/item/clothing/suit/space/officer
				head = /obj/item/clothing/head/helmet/space/beret
				r_hand = /obj/item/gun/ballistic/automatic/hs010
				r_pocket = /obj/item/ammo_box/magazine/hs010
			glasses = /obj/item/clothing/glasses/hud/toggle/thermal
			gloves = /obj/item/clothing/gloves/tackler/combat/insulated
			mask = /obj/item/clothing/mask/gas/sechailer/swat
			shoes = /obj/item/clothing/shoes/combat/swat
			l_pocket = /obj/item/melee/energy/sword/saber
			l_hand = /obj/item/shield/riot/military

/area/violence
	name = "Насилие"
	icon_state = "yellow"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_color = COLOR_LIGHT_GRAYISH_RED
	base_lighting_alpha = 255
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

/area/violence/Entered(atom/movable/arrived, area/old_area)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, arrived, old_area)
	if(!LAZYACCESS(arrived.important_recursive_contents, RECURSIVE_CONTENTS_AREA_SENSITIVE))
		return
	for(var/atom/movable/recipient as anything in arrived.important_recursive_contents[RECURSIVE_CONTENTS_AREA_SENSITIVE])
		SEND_SIGNAL(recipient, COMSIG_ENTER_AREA, src)

	if(!isliving(arrived))
		return

	var/mob/living/L = arrived
	if(!L.ckey)
		return

	var/S

	switch(GLOB.violence_current_round)
		if(1 to 2)
			S = 'white/valtos/sounds/battle_small.ogg'
		if(3)
			S = 'white/valtos/sounds/battle_mid.ogg'
		if(4)
			S = 'white/valtos/sounds/battle_hi.ogg'
		if(5)
			S = 'white/valtos/sounds/battle_fuck.ogg'

	if(S)
		SEND_SOUND(L, sound(S, repeat = 1, wait = 0, volume = 25, channel = CHANNEL_VIOLENCE_MODE))

/obj/effect/landmark/violence
	name = "Violence Map Spawner"

/obj/effect/landmark/violence/Initialize(mapload)
	. = ..()
	GLOB.violence_landmark = src

/obj/effect/landmark/violence/proc/load_map()

	var/turf/spawn_area = get_turf(src)
	var/datum/map_template/violence/current_map
	var/list/maplist = list()

	for(var/item in subtypesof(/datum/map_template/violence))
		var/datum/map_template/violence/C = new item()
		maplist[C] = C.weight

	current_map = pickweight(maplist)

	if(!spawn_area)
		CRASH("No spawn area detected for Violence!")
	else if(!current_map)
		CRASH("No map prepared")
	var/list/bounds = current_map.load(spawn_area, TRUE)
	spawn(3 SECONDS)
		to_chat(world, leader_brass("[current_map.name]! [current_map.description]"))
	if(!bounds)
		CRASH("Loading Violence map failed!")

/datum/map_template/violence
	var/description = ""
	var/weight = 0

/datum/map_template/violence/default
	name = "Карак"
	description = "Бойня в пустынном бункере."
	mappath = "_maps/map_files/Warfare/violence1.dmm"
	weight = 3

/datum/map_template/violence/chinatown
	name = "Чайнатаун"
	description = "Деликатное отсечение голов в восточном стиле."
	mappath = "_maps/map_files/Warfare/violence2.dmm"
	weight = 3
