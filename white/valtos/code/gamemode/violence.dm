GLOBAL_VAR_INIT(violence_mode_activated, FALSE)
GLOBAL_VAR_INIT(violence_current_round, 0)
GLOBAL_VAR_INIT(violence_random_theme, 1)
GLOBAL_VAR(violence_landmark)
GLOBAL_VAR(violence_red_datum)
GLOBAL_VAR(violence_blue_datum)
GLOBAL_LIST_EMPTY(violence_red_team)
GLOBAL_LIST_EMPTY(violence_blue_team)

#define VIOLENCE_FINAL_ROUND 7

/datum/game_mode/violence
	name = "violence"
	config_tag = "violence"
	report_type = "violence"
	enemy_minimum_age = 0
	maximum_players = 64

	// активен ли раунд
	var/round_active = FALSE
	// когда был начат раунд
	var/round_started_at = 0
	// основная зона, которая отслеживается
	var/area/main_area

	// балансировочные якори команд
	var/max_reds = 2
	var/max_blues = 2

	announce_span = "danger"
	announce_text = "Резня!"

/datum/game_mode/violence/pre_setup()
	// меняем тему в лобби на задорную
	SSticker.login_music = sound('white/valtos/sounds/quiet_theme.ogg')
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			C.mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			C.playtitlemusic()
	// пикаем арену
	var/obj/effect/landmark/violence/V = GLOB.violence_landmark
	V.load_map()
	// отключаем ивенты станции
	GLOB.disable_fucking_station_shit_please = TRUE
	// включаем режим насилия, который немного изменяет правила игры
	GLOB.violence_mode_activated = TRUE
	// выбираем зону (если её нет, то высрет рантайм)
	main_area = GLOB.areas_by_type[/area/violence]
	// отключаем лишние подсистемы
	SSair.flags |= SS_NO_FIRE
	SSevents.flags |= SS_NO_FIRE
	SSnightshift.flags |= SS_NO_FIRE
	SSorbits.flags |= SS_NO_FIRE
	SSweather.flags |= SS_NO_FIRE
	SSeconomy.flags |= SS_NO_FIRE
	// назначаем глобальные команды для худов
	GLOB.violence_red_datum = new /datum/team/violence/red
	GLOB.violence_blue_datum = new /datum/team/violence/blue
	// отключаем все станционные джобки и создаём специальные
	GLOB.position_categories = list(
		EXP_TYPE_COMBATANT_RED = list("jobs" = GLOB.combatant_red_positions, "color" = "#ff0000", "runame" = "Красные"),
		EXP_TYPE_COMBATANT_BLUE = list("jobs" = GLOB.combatant_blue_positions, "color" = "#0000ff", "runame" = "Синие")
	)
	GLOB.exp_jobsmap = list(
		EXP_TYPE_COMBATANT_RED = list("titles" = GLOB.combatant_red_positions),
		EXP_TYPE_COMBATANT_BLUE = list("titles" = GLOB.combatant_blue_positions)
	)
	// маркируем все текущие атомы, чтобы чистильщик их не удалил
	for(var/atom/A in main_area)
		A.flags_1 |= KEEP_ON_ARENA_1
	return TRUE

/datum/game_mode/violence/can_start()
	// отменяем готовность у всех игроков, чтобы их случайно не закинуло в нуллспейс
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	return TRUE

/datum/game_mode/violence/post_setup()
	..()
	// выключаем рандомные ивенты наверняка
	CONFIG_SET(flag/allow_random_events, FALSE)
	// готовим новый раунд
	spawn(1 SECONDS)
		new_round()

/datum/game_mode/violence/generate_report()
	return "В вашем секторе проводится самый кровавый чемпионат, а также мы тестируем нашу новейшую систему удалённого клонирования. Приятной смены!"

/datum/game_mode/violence/send_intercept(report = 0)
	return

/datum/game_mode/violence/proc/play_sound_to_everyone(snd, volume = 100)
	for(var/mob/M in GLOB.player_list)
		var/sound/S = sound(snd, volume = volume)
		SEND_SOUND(M, S)

/datum/game_mode/violence/process()
	if(round_active)
		// удаляем хотспоты если повезёт
		for(var/obj/effect/hotspot/H in main_area)
			if(prob(50))
				qdel(H)
		// проверяем наличие моба и его состояние
		for(var/datum/mind/R in GLOB.violence_red_team)
			if(!R?.current)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')), rand(25, 50))
				GLOB.violence_red_team -= R
			else if(R?.current?.stat == DEAD)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')), rand(25, 50))
				GLOB.violence_red_team -= R
		for(var/datum/mind/B in GLOB.violence_blue_team)
			if(!B?.current)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')), rand(25, 50))
				GLOB.violence_blue_team -= B
			else if(B?.current?.stat == DEAD)
				play_sound_to_everyone(pick(list('white/valtos/sounds/aplause1.ogg', 'white/valtos/sounds/aplause2.ogg')), rand(25, 50))
				GLOB.violence_blue_team -= B
		// добейте выживших
		for(var/mob/living/carbon/human/H in main_area)
			if(H.stat != DEAD && H.health <= 0)
				var/datum/disease/D = new /datum/disease/heart_failure()
				D.stage = 5
				H.ForceContractDisease(D, FALSE, TRUE)
		// балансируем команды
		if(GLOB.violence_red_team.len == max_reds && max_reds <= max_blues)
			max_reds = max_blues + 1
			SSjob.AddJobPositions(/datum/job/combantant/red, max_reds, max_reds)
		if(GLOB.violence_blue_team.len == max_blues && max_blues <= max_reds)
			max_blues = max_reds + 1
			SSjob.AddJobPositions(/datum/job/combantant/blue, max_blues, max_blues)
		// проверяем, умерли ли все после открытия ворот
		if(round_started_at + 30 SECONDS < world.time)
			if(GLOB.violence_red_team.len == 0 && GLOB.violence_blue_team.len)
				end_round("СИНИХ")
			if(GLOB.violence_blue_team.len == 0 && GLOB.violence_red_team.len)
				end_round("КРАСНЫХ")
			if(GLOB.violence_red_team.len == 0 && GLOB.violence_blue_team.len == 0)
				end_round()

// конец раунда и запуск начала нового раунда
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

// удаляет все атомы без флага KEEP_ON_ARENA_1 в основной зоне, также закрывает шаттерсы
/datum/game_mode/violence/proc/clean_arena()
	var/count_deleted = 0
	for(var/atom/A in main_area)
		if(!(A.flags_1 & KEEP_ON_ARENA_1))
			count_deleted++
			qdel(A)
	message_admins("УДАЛЕНО [count_deleted] РАЗЛИЧНЫХ ШТУК.")
	for(var/obj/machinery/door/poddoor/D in main_area)
		INVOKE_ASYNC(D, /obj/machinery/door/poddoor.proc/close)

// новый раунд, отправляет всех в лобби и очищает арену
/datum/game_mode/violence/proc/new_round()
	GLOB.violence_current_round++
	// генерируем случайную тему для экипировки
	GLOB.violence_random_theme = rand(1, 2)
	// проверяем, был ли предыдущий раунд финальным
	if(GLOB.violence_current_round == VIOLENCE_FINAL_ROUND)
		return
	// очищаем команды
	GLOB.violence_red_team = list()
	GLOB.violence_blue_team = list()
	// необходимо кинуть всех в лобби, чтобы была возможность вступить в бой
	if(GLOB.violence_current_round != 1)
		for(var/mob/M in GLOB.player_list)
			M?.mind?.remove_all_antag_datums()
			SEND_SOUND(M, sound(null, channel = CHANNEL_VIOLENCE_MODE))
			var/mob/dead/new_player/NP = new()
			NP.ckey = M.ckey
			qdel(M)
	// вызов очистки
	clean_arena()
	spawn(10 SECONDS)
		// сбрасываем балансировку
		max_reds = 2
		max_blues = 2
		SSjob.ResetOccupations("Violence")
		SSjob.SetJobPositions(/datum/job/combantant/red, 2, 2, TRUE)
		SSjob.SetJobPositions(/datum/job/combantant/blue, 2, 2, TRUE)
		// активируем раунд
		round_active = TRUE
		// метим время начала
		round_started_at = world.time
		// оповещаем игроков
		to_chat(world, leader_brass("РАУНД [GLOB.violence_current_round]! [get_round_desc()]!"))
		play_sound_to_everyone('white/valtos/sounds/horn.ogg')
		// открываем шаттерсы через время
		spawn(30 SECONDS)
			to_chat(world, leader_brass("В БОЙ!"))
			play_sound_to_everyone('white/valtos/sounds/gong.ogg')
			for(var/obj/machinery/door/poddoor/D in main_area)
				INVOKE_ASYNC(D, /obj/machinery/door/poddoor.proc/open)

// получаем описание текущего раунда
/datum/game_mode/violence/proc/get_round_desc()
	switch(GLOB.violence_current_round)
		if(1)
			return "РАЗМИНКА"
		if(2)
			return "КЛАССИЧЕСКАЯ РЕЗНЯ"
		if(3)
			return "ГРАЖДАНСКИЙ МАСТЕРКРАФТ"
		if(4)
			return "ТАКТИЧЕСКОЕ РУБИЛОВО"
		if(5)
			return "ТЯЖЁЛАЯ АРТИЛЛЕРИЯ"
		if(6)
			return "МЕХАНИЧЕСКОЕ ПРЕВОСХОДСТВО"
		else
			return "Хуйня какая-то"

// проверка на финальный раунд
/datum/game_mode/violence/check_finished()
	if(GLOB.violence_current_round == VIOLENCE_FINAL_ROUND)
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

// добавляем худ в зависимости от команды
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
	box = null
	var/team = "white"

/datum/outfit/job/combantant/red
	name = "Combantant: Red"
	jobtype = /datum/job/combantant/red
	uniform = /obj/item/clothing/under/color/red
	team = "red"

/datum/outfit/job/combantant/blue
	name = "Combantant: Blue"
	jobtype = /datum/job/combantant/blue
	uniform = /obj/item/clothing/under/color/blue
	team = "blue"

/datum/outfit/job/combantant/pre_equip(mob/living/carbon/human/H)
	..()
	back = null
	backpack_contents = null
	id = /obj/item/card/id/advanced/centcom/ert/deathsquad
	// пиздец
	switch(GLOB.violence_current_round)
		if(1)
			if(prob(35))
				r_hand = pick(list(/obj/item/melee/brick, /obj/item/tank/internals/oxygen, /obj/item/extinguisher))
		if(2)
			if(GLOB.violence_random_theme == 1)
				suit = /obj/item/clothing/suit/armor/vest/durathread
				head = /obj/item/clothing/head/beret/durathread
				if(prob(50))
					r_hand = pick(list(/obj/item/kitchen/knife/combat, /obj/item/melee/sabre/officer, /obj/item/melee/baseball_bat, /obj/item/melee/energy/sword/saber))
					l_hand = pick(list(/obj/item/shield/riot/buckler, /obj/item/restraints/legcuffs/bola))
				else
					r_hand = pick(list(/obj/item/melee/baton/loaded, /obj/item/assembly/flash))
					if(prob(25))
						glasses = /obj/item/clothing/glasses/sunglasses
			else
				head = /obj/item/clothing/head/turban
				suit = /obj/item/clothing/suit/chaplainsuit/studentuni
				shoes = /obj/item/clothing/shoes/sandal
				l_pocket = /obj/item/grenade/frag
				r_hand = pick(list(/obj/item/kitchen/knife/combat, /obj/item/melee/sabre/officer, /obj/item/melee/energy/sword/saber))
		if(3)
			if(GLOB.violence_random_theme == 1)
				suit = /obj/item/clothing/suit/armor/bulletproof
				head = /obj/item/clothing/head/helmet/alt
				r_hand = pick(list(/obj/item/gun/ballistic/shotgun/automatic/combat, /obj/item/gun/ballistic/automatic/mini_uzi, /obj/item/gun/ballistic/automatic/pistol/m1911, /obj/item/gun/ballistic/automatic/pistol/makarov, /obj/item/gun/ballistic/automatic/pistol/luger, /obj/item/gun/ballistic/automatic/pistol/aps))
				l_pocket = pick(list(/obj/item/reagent_containers/hypospray/medipen/salacid, /obj/item/grenade/frag))
			else
				uniform = pick(list(/obj/item/clothing/under/costume/kamishimo, /obj/item/clothing/under/costume/kimono/dark, /obj/item/clothing/under/costume/kimono/sakura, /obj/item/clothing/under/costume/kimono/fancy, /obj/item/clothing/under/costume/kamishimo, /obj/item/clothing/under/costume/bathrobe))
				head = /obj/item/clothing/head/rice_hat
				if(prob(25))
					uniform = /obj/item/clothing/under/costume/kimono
					suit = /obj/item/clothing/suit/costume/samurai
					head = /obj/item/clothing/head/costume/kabuto
				shoes = /obj/item/clothing/shoes/sandal
				belt = /obj/item/katana
		if(4)
			if(GLOB.violence_random_theme == 1)
				gloves = /obj/item/clothing/gloves/combat/sobr
				switch(rand(1, 2))
					if(1)
						mask = /obj/item/clothing/mask/gas/heavy/m40
						head = /obj/item/clothing/head/helmet/maska/altyn/black
						suit = /obj/item/clothing/suit/armor/heavysobr
						belt = /obj/item/storage/belt/military/assault/sobr/specialist
						back = /obj/item/gun/ballistic/shotgun/saiga
					if(2)
						mask = /obj/item/clothing/mask/gas/heavy/gp7vm
						head = /obj/item/clothing/head/helmet/maska/altyn
						suit = /obj/item/clothing/suit/armor/opvest/sobr
						belt = /obj/item/storage/belt/military/assault/sobr
						back = /obj/item/gun/ballistic/automatic/ak74m
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
			if(GLOB.violence_random_theme == 1)
				glasses = /obj/item/clothing/glasses/hud/toggle/thermal
				gloves = /obj/item/clothing/gloves/tackler/combat/insulated
				mask = /obj/item/clothing/mask/gas/sechailer/swat
				shoes = /obj/item/clothing/shoes/combat/swat
				suit = /obj/item/clothing/suit/space/hardsuit/deathsquad
				belt = /obj/item/gun/ballistic/revolver/mateba
				r_hand = /obj/item/gun/energy/pulse
				l_hand = /obj/item/shield/riot/military
				r_pocket = /obj/item/shield/energy
				l_pocket = /obj/item/melee/energy/sword/saber
				if(prob(50))
					suit = /obj/item/clothing/suit/space/officer
					head = /obj/item/clothing/head/helmet/space/beret
					mask = null
					r_hand = /obj/item/gun/ballistic/automatic/hs010
					r_pocket = /obj/item/ammo_box/magazine/hs010
			else
				glasses = /obj/item/clothing/glasses/thermal
				mask = /obj/item/clothing/mask/gas/syndicate
				shoes = /obj/item/clothing/shoes/combat
				gloves =  /obj/item/clothing/gloves/combat
				belt = /obj/item/storage/belt/military/assault/c20r4
				r_pocket = /obj/item/gun/ballistic/automatic/pistol/tanner
				l_pocket = /obj/item/melee/energy/sword/saber
				suit_store = /obj/item/gun/ballistic/automatic/c20r/unrestricted
				suit = /obj/item/clothing/suit/space/hardsuit/shielded/syndi
		if(6)
			if(prob(50))
				head = /obj/item/clothing/head/welding/open
				belt = /obj/item/storage/belt/military/abductor/full
				spawn(3 SECONDS) // because shit spawned after
					if(GLOB.violence_current_round == 6)
						var/obj/vehicle/sealed/mecha/combat/V
						if(prob(75))
							V = new /obj/vehicle/sealed/mecha/combat/gygax(get_turf(H))
							var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/thrusters/ion(V)
							ME.attach(V)
							ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg(V)
							ME.attach(V)
							ME = new /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster(V)
							ME.attach(V)
							ME = new /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster(V)
							ME.attach(V)
							ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/breaching(V)
							ME.attach(V)
							V.max_ammo()
						else
							V = new /obj/vehicle/sealed/mecha/combat/marauder/loaded(get_turf(H))
						V.color = team == "red" ? "#ff2222" : "#2222ff"
			else
				head = /obj/item/clothing/head/helmet/alt
				suit = /obj/item/clothing/suit/armor/bulletproof
				suit_store = /obj/item/gun/ballistic/automatic/pistol/golden_eagle
				belt = /obj/item/storage/belt/military/assault/rockets
				l_hand = /obj/item/gun/ballistic/rocketlauncher/unrestricted
				l_pocket = /obj/item/pamk

/datum/outfit/job/combantant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()

/area/violence
	name = "Насилие"
	icon_state = "yellow"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_color = COLOR_LIGHT_GRAYISH_RED
	base_lighting_alpha = 255
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

// оверрайт прока для правильного вывода темы
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

	L?.hud_used?.update_parallax_pref(L, 1)

	switch(GLOB.violence_current_round)
		if(1 to 2)
			S = 'white/valtos/sounds/battle_small.ogg'
		if(3)
			S = 'white/valtos/sounds/battle_mid.ogg'
		if(4 to 5)
			S = 'white/valtos/sounds/battle_hi.ogg'
		if(6)
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
		if(C.max_players < GLOB.player_list.len)
			message_admins("[C.name]: максимум [C.max_players] игроков, пропускаем...")
			qdel(C)
			continue
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
	var/max_players = 0

/datum/map_template/violence/default
	name = "Карак"
	description = "Бойня в пустынном бункере."
	mappath = "_maps/map_files/Warfare/violence1.dmm"
	weight = 3
	max_players = 16

/datum/map_template/violence/chinatown
	name = "Чайнатаун"
	description = "Деликатное отсечение голов в восточном стиле."
	mappath = "_maps/map_files/Warfare/violence2.dmm"
	weight = 3
	max_players = 8

/datum/map_template/violence/centralpolygon
	name = "Тренировочный Центр"
	description = "Здесь проходят обучение все офицеры Нанотрейзен."
	mappath = "_maps/map_files/Warfare/violence3.dmm"
	weight = 1
	max_players = 64

#undef VIOLENCE_FINAL_ROUND
