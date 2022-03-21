GLOBAL_VAR_INIT(violence_mode_activated, FALSE)
GLOBAL_VAR_INIT(violence_current_round, 0)
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

	announce_span = "danger"
	announce_text = "Резня!"

/datum/game_mode/violence/pre_setup()
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
	return TRUE

/datum/game_mode/violence/can_start()
	if(!GLOB.areas_by_type[/area/violence])
		message_admins("КАРТА НЕ ПОДХОДИТ ДЛЯ ЭТОГО РЕЖИМА!")
		return FALSE
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player = PLAYER_NOT_READY
	return TRUE

/datum/game_mode/violence/post_setup()
	..()
	CONFIG_SET(flag/allow_random_events, FALSE)
	spawn(3 SECONDS)
		new_round()

/datum/game_mode/violence/generate_report()
	return "В вашем секторе проводится самый кровавый чемпионат, а также мы тестируем нашу новейшую систему удалённого клонирования. Приятной смены!"

/datum/game_mode/violence/send_intercept(report = 0)
	return

/datum/game_mode/violence/process()
	if(round_active)
		if(GLOB.violence_red_team.len == SSjob.GetJobPositions(/datum/job/combantant/red))
			SSjob.AddJobPositions(/datum/job/combantant/red)
		if(GLOB.violence_blue_team.len == SSjob.GetJobPositions(/datum/job/combantant/blue))
			SSjob.AddJobPositions(/datum/job/combantant/blue)
		if(shutters_closed && round_started_at + 30 SECONDS < world.time)
			shutters_closed = FALSE
			for(var/mob/M in GLOB.player_list)
				SEND_SOUND(M, 'white/valtos/sounds/gong.ogg')
			for(var/obj/machinery/door/poddoor/D in main_area)
				INVOKE_ASYNC(D, /obj/machinery/door/poddoor.proc/open)
		if(round_started_at + 120 SECONDS < world.time)
			if(GLOB.violence_red_team.len == 0 && GLOB.violence_blue_team.len)
				end_round("СИНИХ")
			if(GLOB.violence_blue_team.len == 0 && GLOB.violence_red_team.len)
				end_round("КРАСНЫХ")
			if(GLOB.violence_red_team.len == 0 && GLOB.violence_blue_team.len == 0)
				end_round()
		for(var/mob/living/L in main_area)
			if(L.stat == DEAD)
				L?.mind?.remove_all_antag_datums()

/datum/game_mode/violence/proc/end_round(winner = "ХУЙ ЕГО ЗНАЕТ КОГО")
	round_active = FALSE
	SSjob.SetJobPositions(/datum/job/combantant/red, 0, 0, TRUE)
	SSjob.SetJobPositions(/datum/job/combantant/blue, 0, 0, TRUE)
	spawn(3 SECONDS)
		to_chat(world, span_reallybig("РАУНД [GLOB.violence_current_round] ЗАВЕРШЁН!"))
		to_chat(world, span_reallybig("ПОБЕДА [winner]!"))
	for(var/mob/M in GLOB.player_list)
		SEND_SOUND(M, 'white/valtos/sounds/crowd_win.ogg')
		spawn(3 SECONDS)
			SEND_SOUND(M, 'white/valtos/sounds/gong.ogg')
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
	for(var/obj/machinery/door/poddoor/D in main_area)
		INVOKE_ASYNC(D, /obj/machinery/door/poddoor.proc/close)

/datum/game_mode/violence/proc/new_round()
	GLOB.violence_current_round++
	for(var/mob/M in main_area)
		M?.mind?.remove_all_antag_datums()
		SEND_SOUND(M, sound(null, channel = CHANNEL_VIOLENCE_MODE))
		var/mob/dead/new_player/NP = new()
		NP.ckey = M.ckey
		qdel(M)
	clean_arena()
	spawn(10 SECONDS)
		round_active = TRUE
		round_started_at = world.time
		to_chat(world, span_reallybig("РАУНД [GLOB.violence_current_round] НАЧАЛСЯ!"))
		SSjob.SetJobPositions(/datum/job/combantant/red, 2, 2, TRUE)
		SSjob.SetJobPositions(/datum/job/combantant/blue, 2, 2, TRUE)
		for(var/mob/M in GLOB.player_list)
			SEND_SOUND(M, 'white/valtos/sounds/horn.ogg')

/datum/game_mode/violence/check_finished()
	if(GLOB.violence_current_round == 6)
		return TRUE
	else
		return ..()

/datum/team/violence
	name = "Боевики: Белые"

/datum/team/violence/red
	name = "Боевики: Красные"

/datum/team/violence/blue
	name = "Боевики: Синие"

/datum/antagonist/combatant
	var/datum/team/violence/team

/datum/antagonist/combatant/on_gain()
	. = ..()
	create_team()

/datum/antagonist/combatant/red
	name = "Боевик красных"
	antag_hud_type = ANTAG_HUD_CULT
	antag_hud_name = "hog-red-2"

/datum/antagonist/combatant/red/on_gain()
	. = ..()
	GLOB.violence_red_team |= owner

/datum/antagonist/combatant/red/on_removal()
	. = ..()
	GLOB.violence_red_team |= owner

/datum/antagonist/combatant/red/create_team()
	for(var/datum/antagonist/combatant/red/H in GLOB.antagonists)
		if(!H.owner)
			continue
		if(H.team)
			team = H.team
			return
	team = new /datum/team/violence/red

/datum/antagonist/combatant/blue
	name = "Боевик синих"
	antag_hud_type = ANTAG_HUD_CLOCKWORK
	antag_hud_name = "hog-blue-2"

/datum/antagonist/combatant/blue/on_gain()
	. = ..()
	GLOB.violence_blue_team |= owner

/datum/antagonist/combatant/blue/on_removal()
	. = ..()
	GLOB.violence_blue_team |= owner

/datum/antagonist/combatant/blue/create_team()
	for(var/datum/antagonist/combatant/blue/H in GLOB.antagonists)
		if(!H.owner)
			continue
		if(H.team)
			team = H.team
			return
	team = new /datum/team/violence/blue

/datum/job/combantant
	title = "Combantant"
	ru_title = "Комбатант"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "практически всем"
	selection_color = "#dddddd"
	outfit = /datum/outfit/job/combantant
	antag_rep = 0

/datum/job/combantant/red
	title = "Combantant: Red"
	ru_title = "Комбатант: Красные"
	faction = "Red"
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
	faction = "Blue"
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
			suit = /obj/item/clothing/suit/armor/vest/durathread
			head = /obj/item/clothing/head/beret/durathread
			r_hand = pick(list(/obj/item/kitchen/knife/combat, /obj/item/melee/sabre/officer, /obj/item/melee/baseball_bat, /obj/item/melee/energy/sword))
			l_hand = pick(list(/obj/item/shield/riot/buckler, /obj/item/restraints/legcuffs/bola))
		if(3)
			suit = /obj/item/clothing/suit/armor/vest
			head = /obj/item/clothing/head/helmet/sec
			r_hand = pick(list(/obj/item/gun/ballistic/shotgun/automatic/combat, /obj/item/gun/ballistic/automatic/mini_uzi, /obj/item/gun/ballistic/automatic/pistol/m1911, /obj/item/gun/energy/laser/retro))
			l_pocket = pick(list(/obj/item/reagent_containers/hypospray/medipen/salacid, /obj/item/grenade/frag))
		if(4)
			gloves = /obj/item/clothing/gloves/combat/sobr
			suit = /obj/item/clothing/suit/armor/opvest/sobr
			belt = /obj/item/storage/belt/military/assault/sobr
			suit_store = /obj/item/gun/ballistic/automatic/ak74m
			switch(rand(1, 2))
				if(1)
					suit_store = /obj/item/gun/ballistic/shotgun/saiga
					suit = /obj/item/clothing/suit/armor/heavysobr
					belt = /obj/item/storage/belt/military/assault/sobr/specialist
					mask = /obj/item/clothing/mask/gas/heavy/m40
					head = /obj/item/clothing/head/helmet/maska/altyn/black
				if(2)
					mask = /obj/item/clothing/mask/gas/heavy/gp7vm
					head = /obj/item/clothing/head/helmet/maska/altyn
		if(5)
			suit = /obj/item/clothing/suit/space/hardsuit/deathsquad
			belt = /obj/item/gun/ballistic/revolver/mateba
			glasses = /obj/item/clothing/glasses/hud/toggle/thermal
			gloves = /obj/item/clothing/gloves/tackler/combat/insulated
			mask = /obj/item/clothing/mask/gas/sechailer/swat
			shoes = /obj/item/clothing/shoes/combat/swat
			l_pocket = /obj/item/melee/energy/sword/saber
			r_pocket = /obj/item/shield/energy
			if(prob(50))
				l_hand = /obj/item/gun/energy/pulse
			else
				back = /obj/item/minigunpack

/area/violence
	name = "Насилие"
	icon_state = "yellow"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_color = COLOR_WHITE
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
