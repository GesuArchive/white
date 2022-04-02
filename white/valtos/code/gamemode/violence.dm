// дохуя пиздатый код ниже, не завидую тому, кто попытается спиздить его

GLOBAL_VAR_INIT(violence_mode_activated, FALSE)
GLOBAL_VAR_INIT(violence_current_round, 0)
GLOBAL_VAR_INIT(violence_random_theme, 1)
GLOBAL_VAR(violence_landmark)
GLOBAL_VAR(violence_red_datum)
GLOBAL_VAR(violence_blue_datum)
GLOBAL_LIST_EMPTY(violence_red_team)
GLOBAL_LIST_EMPTY(violence_blue_team)
GLOBAL_LIST_EMPTY(violence_teamlock)
GLOBAL_LIST_EMPTY(violence_players)

#define VIOLENCE_FINAL_ROUND 11

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

	// последнее количество игроков после начала раунда
	var/last_reds = 0
	var/last_blues = 0

	// выплата в каждом раунде
	var/payout = 600

	announce_span = "danger"
	announce_text = "Резня!"

/datum/game_mode/violence/pre_setup()
	// меняем тему в лобби на задорную
	SSticker.login_music = sound('white/valtos/sounds/menue.ogg')
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			C.mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)
			C.playtitlemusic()
	// генерируем штуки для закупа
	generate_violence_gear()
	// делаем датумы игроков на всякий случай
	for(var/client/C in GLOB.clients)
		if(!GLOB.violence_players[C.ckey])
			GLOB.violence_players[C.ckey] = new /datum/violence_player
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
				play_sound_to_everyone(pick(list('white/valtos/sounds/fame1.ogg', 'white/valtos/sounds/fame2.ogg', 'white/valtos/sounds/fame3.ogg', 'white/valtos/sounds/fame4.ogg', 'white/valtos/sounds/fame5.ogg')), rand(25, 50))
				GLOB.violence_red_team -= R
				to_chat(world, span_red("[LAZYLEN(GLOB.violence_red_team)]/[last_reds]"))
				var/mob/living/carbon/human/H = R?.original_character?.resolve()
				if(GLOB.violence_players[H?.lastattackermob?.ckey])
					var/datum/violence_player/VP = GLOB.violence_players[H.lastattackermob.ckey]
					VP.money += VP.team == "blue" ? 300 : -300
					VP.kills += VP.team == "blue" ? 1 : -1
					to_chat(H.lastattackermob.ckey, span_boldnotice("[VP.team == "blue" ? "+300" : "-300"]₽"))
					var/datum/violence_player/VP2 = GLOB.violence_players[H.ckey]
					if(VP2)
						VP2.deaths++
			else if(R?.current?.stat == DEAD)
				play_sound_to_everyone(pick(list('white/valtos/sounds/fame1.ogg', 'white/valtos/sounds/fame2.ogg', 'white/valtos/sounds/fame3.ogg', 'white/valtos/sounds/fame4.ogg', 'white/valtos/sounds/fame5.ogg')), rand(25, 50))
				GLOB.violence_red_team -= R
				to_chat(world, span_red("[LAZYLEN(GLOB.violence_red_team)]/[last_reds]"))
				if(GLOB.violence_players[R?.current?.lastattackermob?.ckey])
					var/datum/violence_player/VP = GLOB.violence_players[R.current.lastattackermob.ckey]
					VP.money += VP.team == "blue" ? 300 : -300
					VP.kills += VP.team == "blue" ? 1 : -1
					to_chat(R.current.lastattackermob, span_boldnotice("[VP.team == "blue" ? "+300" : "-300"]₽"))
					var/datum/violence_player/VP2 = GLOB.violence_players[R.current.ckey]
					if(VP2)
						VP2.deaths++
		for(var/datum/mind/B in GLOB.violence_blue_team)
			if(!B?.current)
				play_sound_to_everyone(pick(list('white/valtos/sounds/fame1.ogg', 'white/valtos/sounds/fame2.ogg', 'white/valtos/sounds/fame3.ogg', 'white/valtos/sounds/fame4.ogg', 'white/valtos/sounds/fame5.ogg')), rand(25, 50))
				GLOB.violence_blue_team -= B
				to_chat(world, span_blue("[LAZYLEN(GLOB.violence_blue_team)]/[last_blues]"))
				var/mob/living/carbon/human/H = B?.original_character?.resolve()
				if(GLOB.violence_players[H?.lastattackermob?.ckey])
					var/datum/violence_player/VP = GLOB.violence_players[H.lastattackermob.ckey]
					VP.money += VP.team == "red" ? 300 : -300
					VP.kills += VP.team == "red" ? 1 : -1
					to_chat(H.lastattackermob.ckey, span_boldnotice("[VP.team == "red" ? "+300" : "-300"]₽"))
					var/datum/violence_player/VP2 = GLOB.violence_players[H.ckey]
					if(VP2)
						VP2.deaths++
			else if(B?.current?.stat == DEAD)
				play_sound_to_everyone(pick(list('white/valtos/sounds/fame1.ogg', 'white/valtos/sounds/fame2.ogg', 'white/valtos/sounds/fame3.ogg', 'white/valtos/sounds/fame4.ogg', 'white/valtos/sounds/fame5.ogg')), rand(25, 50))
				GLOB.violence_blue_team -= B
				to_chat(world, span_blue("[LAZYLEN(GLOB.violence_blue_team)]/[last_blues]"))
				if(GLOB.violence_players[B?.current?.lastattackermob?.ckey])
					var/datum/violence_player/VP = GLOB.violence_players[B.current.lastattackermob.ckey]
					VP.money += VP.team == "red" ? 300 : -300
					VP.kills += VP.team == "red" ? 1 : -1
					to_chat(B.current.lastattackermob, span_boldnotice("[VP.team == "red" ? "+300" : "-300"]₽"))
					var/datum/violence_player/VP2 = GLOB.violence_players[B.current.ckey]
					if(VP2)
						VP2.deaths++
		// добейте выживших
		for(var/mob/living/carbon/human/H in main_area)
			if(H.stat != DEAD && H.health <= 0)
				var/datum/disease/D = new /datum/disease/heart_failure()
				D.stage = 5
				H.ForceContractDisease(D, FALSE, TRUE)
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
	// исправляем свет
	main_area.update_base_lighting()
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
	// необходимо кинуть всех в лобби и сохранить экипировку, чтобы была возможность вступить в бой
	if(GLOB.violence_current_round != 1)
		for(var/mob/M in GLOB.player_list)
			if(ishuman(M) && M?.stat == CONSCIOUS && GLOB.violence_players[M?.ckey])
				var/datum/violence_player/VP = GLOB.violence_players[M.ckey]
				var/mob/living/carbon/human/H = M
				var/list/saved_shit = list()
				// ммм
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_HEAD))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_OCLOTHING))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_BELT))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_SUITSTORE))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_RPOCKET))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_LPOCKET))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_EYES))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_FEET))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_GLOVES))
				LAZYADD(saved_shit, H.get_item_by_slot(ITEM_SLOT_MASK))
				LAZYADD(saved_shit, H.get_active_held_item())
				LAZYADD(saved_shit, H.get_inactive_held_item())
				for(var/obj/item/I in saved_shit)
					if(!I)
						continue
					LAZYADD(VP.saved_items, I.type)
			M?.mind?.remove_all_antag_datums()
			SEND_SOUND(M, sound(null, channel = CHANNEL_VIOLENCE_MODE))
			var/mob/dead/new_player/NP = new()
			NP.ckey = M.ckey
			qdel(M)
	// раздаём деньги бомжам и выводим статистику КД
	to_chat(world, leader_brass("vvvvvvvvvvvvvvvvvvvvvvv"))
	var/list/stats_reds = list()
	var/list/stats_blues = list()
	var/list/stats = list()
	stats += "<table><tr><td>Игрок</td><td>Убийств</td><td>Смертей</td></tr>"
	for(var/key in GLOB.violence_players)
		var/datum/violence_player/VP = GLOB.violence_players[key]
		VP.money += payout * GLOB.violence_current_round
		if(VP.team == "red")
			stats_reds += "<tr><td><b class='red'>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>"
		else if (VP.team == "blue")
			stats_blues += "<tr><td><b class='blue'>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>"
	LAZYADD(stats, stats_reds)
	LAZYADD(stats, stats_blues)
	stats += "</table>"
	to_chat(world, span_info(stats.Join()))
	to_chat(world, leader_brass("^^^^^^^^^^^^^^^^^^^^^^^"))
	to_chat(world, leader_brass("Выдано [payout * GLOB.violence_current_round]₽ каждому за раунд!"))
	// вызов очистки
	clean_arena()
	spawn(10 SECONDS)
		// сбрасываем статистику
		SSjob.ResetOccupations("Violence")
		SSjob.SetJobPositions(/datum/job/combantant/red, 999, 999, TRUE)
		SSjob.SetJobPositions(/datum/job/combantant/blue, 999, 999, TRUE)
		// активируем раунд
		round_active = TRUE
		// метим время начала
		round_started_at = world.time
		// оповещаем игроков
		to_chat(world, leader_brass("РАУНД [GLOB.violence_current_round]!"))
		play_sound_to_everyone('white/valtos/sounds/horn.ogg')
		// открываем шаттерсы через время
		spawn(30 SECONDS)
			to_chat(world, leader_brass("В БОЙ!"))
			last_reds = LAZYLEN(GLOB.violence_red_team)
			last_blues = LAZYLEN(GLOB.violence_blue_team)
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

/datum/job/combantant/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	var/client/C = H.client ? H.client : M.client
	if(!(C?.ckey in GLOB.violence_teamlock))
		GLOB.violence_teamlock[C.ckey] = title

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

/datum/id_trim/combatant
	assignment = "white"
	access = list(ACCESS_CENT_SPECOPS)

/datum/id_trim/combatant/red
	assignment = "red"

/datum/id_trim/combatant/blue
	assignment = "blue"

/datum/outfit/job/combantant
	name = "Combantant"
	jobtype = /datum/job/combantant
	uniform = /obj/item/clothing/under/syndicate/camo
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = null
	r_pocket = null
	id = null
	belt = null
	ears = /obj/item/radio/headset
	box = null
	var/team = "white"

/datum/outfit/job/combantant/red
	name = "Combantant: Red"
	jobtype = /datum/job/combantant/red
	uniform = /obj/item/clothing/under/color/red
	id = /obj/item/card/id/red
	team = "red"

/datum/outfit/job/combantant/blue
	name = "Combantant: Blue"
	jobtype = /datum/job/combantant/blue
	uniform = /obj/item/clothing/under/color/blue
	id = /obj/item/card/id/blue
	team = "blue"

/datum/outfit/job/combantant/pre_equip(mob/living/carbon/human/H)
	..()
	// something

/datum/outfit/job/combantant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	W.registered_name = H.real_name
	W.update_label()
	var/obj/item/radio/R = H.ears
	switch(team)
		if("red")
			R.set_frequency(FREQ_CTF_RED)
			SSid_access.apply_trim_to_card(W, /datum/id_trim/combatant/red)
		if("blue")
			R.set_frequency(FREQ_CTF_BLUE)
			SSid_access.apply_trim_to_card(W, /datum/id_trim/combatant/blue)
	R.AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
	R.freqlock = TRUE
	R.independent = TRUE
	H.sec_hud_set_ID()
	// экипируем штуки спустя секунду, чтобы некоторый стаф не падал в нуллспейс случайно
	spawn(1 SECONDS)
		if(GLOB.violence_players[H?.ckey])
			var/datum/violence_player/VP = GLOB.violence_players[H.ckey]
			VP.equip_everything(H)
			VP.team = team
	// запрет на снятие ID и униформы
	ADD_TRAIT(W, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	ADD_TRAIT(H.w_uniform, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

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
		if(3 to 5)
			S = 'white/valtos/sounds/battle_mid.ogg'
		if(6 to 8)
			S = 'white/valtos/sounds/battle_hi.ogg'
		if(9 to 10)
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
	weight = 5
	max_players = 24

/datum/map_template/violence/chinatown
	name = "Чайнатаун"
	description = "Деликатное отсечение голов в восточном стиле."
	mappath = "_maps/map_files/Warfare/violence2.dmm"
	weight = 6
	max_players = 16

/datum/map_template/violence/centralpolygon
	name = "Тренировочный Центр"
	description = "Здесь проходят обучение все офицеры Нанотрейзен."
	mappath = "_maps/map_files/Warfare/violence3.dmm"
	weight = 4
	max_players = 64

/datum/map_template/violence/de_dust2
	name = "de_dust2"
	description = "Здесь происходит что-то странное на польском языке."
	mappath = "_maps/map_files/Warfare/violence4.dmm"
	weight = 2
	max_players = 64

/datum/map_template/violence/dunes
	name = "Дюны"
	description = "Не кормите червей!"
	mappath = "_maps/map_files/Warfare/violence5.dmm"
	weight = 6
	max_players = 16

/datum/violence_player
	var/money = 0
	var/team = "white"
	var/kills = 0
	var/deaths = 0
	var/list/loadout_items = list()
	var/list/saved_items = list()

/datum/violence_player/proc/equip_everything(mob/living/carbon/human/H)
	var/list/full_of_items = list()
	for(var/datum/violence_gear/VG as anything in loadout_items)
		for(var/item in VG.items)
			LAZYADD(full_of_items, item)
	LAZYADD(full_of_items, saved_items)
	for(var/item in full_of_items)
		var/obj/item/O = new item(get_turf(H))
		if(H.equip_to_appropriate_slot(O, FALSE))
			continue
		if(H.put_in_hands(item))
			continue
		var/obj/item/storage/B = (locate() in H)
		if(B && O)
			O.forceMove(B)
	saved_items = list()
	loadout_items = list()

/mob/dead/new_player/proc/violence_choices()
	var/dat = ""
	if(!GLOB.violence_players[ckey])
		GLOB.violence_players[ckey] = new /datum/violence_player
	var/datum/violence_player/VP = GLOB.violence_players[ckey]
	// да я пидорас и ебусь в очко с неграми неплохо как ты узнал???
	dat += "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\"><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta http-equiv='X-UA-Compatible' content='IE=edge'><style>*{transition:.1s}body{background:#010901;color:#4a4;font-family:Tahoma;font-size:12px;margin:0;padding:0}#zakup{background:#050905;border:1px solid #141;width:240px;vertical-align:top;margin-left:2px;margin-top:4px;display:inline-block}#zakup-cat,#zakup-cat-name{display:inline-block}#zakup-cat-name{height:100%;width:100%;font-size:18px;background:#121;padding-bottom:4px;border-bottom:1px solid #141;color:#ada;text-align:center}#zakup-item{display:block;background:#051105;margin:4px;margin-bottom:2px;margin-top:2px;padding:4px;border:1px solid #141;width:222px;cursor:pointer;color:#9f9}#zakup-item:hover{background:#9f9;color:#000}#zakup-price{display:inline-block;font-weight:700;width:64px}#zakup-name{display:inline-block;text-transform:uppercase}a{color:#9f9}#footer{display:block;position:fixed;bottom:0;width:100%;height:48px;background:#121;color:#fff;text-decoration:none;font-size:38px;text-align:center;border-top:1px solid #141}#header{display:block;width:100%;height:28px;background:#121;color:#fff;text-decoration:none;font-size:24px;text-align:center;border-bottom:1px solid #141}#footer:hover{background:#9f9;color:#000}#zakup-item-disabled{display:inline-block;background:#020502;margin:4px;margin-bottom:2px;margin-top:2px;padding:4px;border:1px solid #141;width:222px;cursor:pointer;color:#292}</style>"
	dat += "</head><body scroll=auto><div id=header>[VP.money]₽</div><div id=zakup-main>"
	for(var/thing_cat in GLOB.violence_gear_categories)
		var/datum/violence_gear_category/VC = GLOB.violence_gear_categories[thing_cat]
		dat += "<div id=zakup><div id=zakup-cat-name>[VC.cat]</div><div id=zakup-cat>"
		for(var/thing_gear in VC.gear)
			var/datum/violence_gear/VG = VC.gear[thing_gear]
			if(VG.cost > VP.money)
				dat += "<div id=zakup-item-disabled><div id=zakup-price><strike>[VG.cost]₽</strike></div><div id=zakup-name><strike>[VG.name]</strike></div></div>"
			else
				dat += "<a href='byond://?src=[REF(src)];violence=[VG.name]' id=zakup-item><div id=zakup-price>[VG.cost]₽</div><div id=zakup-name>[VG.name]</div></a>"
		dat += "</div></div>"
	dat += "<div id=zakup><div id=zakup-cat-name>Разгрузка</div><div id=zakup-cat>"
	for(var/datum/violence_gear/VG in VP.loadout_items)
		dat += "<div id=zakup-item-disabled><div id=zakup-price>[VG.cost]₽</div><div id=zakup-name>[VG.name]</div></div>"
	dat += "</div></div>"
	dat += "</div><a id=footer href='byond://?src=[REF(src)];violence=joinmefucker'>ПОГНАЛИ!</a></body></html>"
	usr << browse(dat, "window=violence;size=750x690")

GLOBAL_LIST_EMPTY(violence_gear_categories)
GLOBAL_LIST_EMPTY(violence_gear_datums)

/proc/generate_violence_gear()
	for(var/geartype in subtypesof(/datum/violence_gear))
		var/datum/violence_gear/VG = geartype
		if(!initial(VG.cost))
			continue
		if(!GLOB.violence_gear_categories[initial(VG.cat)])
			GLOB.violence_gear_categories[initial(VG.cat)] = new /datum/violence_gear_category(initial(VG.cat))
		GLOB.violence_gear_datums[initial(VG.name)] = new geartype
		var/datum/violence_gear_category/VC = GLOB.violence_gear_categories[initial(VG.cat)]
		VC.gear[initial(VG.name)] = GLOB.violence_gear_datums[initial(VG.name)]
	GLOB.violence_gear_categories = sortAssoc(GLOB.violence_gear_categories)
	return TRUE

/datum/violence_gear_category
	var/cat = ""
	var/list/gear = list()

/datum/violence_gear_category/New(new_cat)
	cat = new_cat
	..()

/datum/violence_gear
	var/name = "???"
	var/cat = "ХУЙ"
	var/cost = 0
	var/items = list()

/datum/violence_gear/melee
	cat = "Ближний бой"

/datum/violence_gear/melee/extinguisher
	name = "Огнетушитель"
	cost = 100
	items = list(/obj/item/extinguisher)

/datum/violence_gear/melee/toolbox
	name = "Ящик с инструментами"
	cost = 200
	items = list(/obj/item/storage/toolbox/mechanical/empty)

/datum/violence_gear/melee/kitchen
	name = "Кухонный нож"
	cost = 600
	items = list(/obj/item/kitchen/knife)

/datum/violence_gear/melee/combat
	name = "Боевой нож"
	cost = 900
	items = list(/obj/item/kitchen/knife/combat)

/datum/violence_gear/melee/sabre
	name = "Сабля"
	cost = 1200
	items = list(/obj/item/melee/sabre/german)

/datum/violence_gear/melee/energy_sabre
	name = "Энергомеч"
	cost = 3500
	items = list(/obj/item/melee/energy/sword/saber)

/datum/violence_gear/melee/katana
	name = "Катана"
	cost = 4000
	items = list(/obj/item/katana)

/datum/violence_gear/pistol
	cat = "Пистолеты"

/datum/violence_gear/pistol/handmade
	name = "Самодельный"
	cost = 800
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/fallout/m9mm/handmade,
		/obj/item/ammo_box/magazine/fallout/m9mm
	)

/datum/violence_gear/pistol/mauser
	name = "Маузер"
	cost = 1000
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/mauser,
		/obj/item/ammo_box/magazine/mauser/battle
	)

/datum/violence_gear/pistol/m1911
	name = "M1911"
	cost = 1250
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/m1911,
		/obj/item/ammo_box/magazine/m45
	)

/datum/violence_gear/pistol/makarov
	name = "Макаров"
	cost = 1500
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/makarov,
		/obj/item/ammo_box/magazine/m9mm
	)

/datum/violence_gear/pistol/aps
	name = "АПС"
	cost = 1750
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/aps,
		/obj/item/ammo_box/magazine/m9mm_aps
	)

/datum/violence_gear/pistol/mateba
	name = "Матеба"
	cost = 2250
	items = list(
		/obj/item/gun/ballistic/revolver/mateba,
		/obj/item/ammo_box/a357
	)

/datum/violence_gear/pistol/deagle
	name = "Пустынный орёл"
	cost = 2500
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/deagle,
		/obj/item/ammo_box/magazine/m50
	)

/datum/violence_gear/rifle
	cat = "Винтовки"

/datum/violence_gear/rifle/kar98k
	name = "Болтовка"
	cost = 1500
	items = list(
		/obj/item/gun/ballistic/rifle/boltaction/kar98k,
		/obj/item/ammo_box/n792x57
	)

/datum/violence_gear/rifle/mini_uzi
	name = "U3 Uzi"
	cost = 1750
	items = list(
		/obj/item/gun/ballistic/automatic/mini_uzi,
		/obj/item/ammo_box/magazine/uzim9mm
	)

/datum/violence_gear/rifle/scope
	name = "Болтовка с оптикой"
	cost = 2250
	items = list(
		/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope,
		/obj/item/ammo_box/n792x57
	)

/datum/violence_gear/rifle/c20r
	name = "C-20r SMG"
	cost = 2500
	items = list(
		/obj/item/gun/ballistic/automatic/c20r/unrestricted,
		/obj/item/ammo_box/magazine/smgm45
	)

/datum/violence_gear/rifle/ak74m
	name = "АК-74m"
	cost = 2750
	items = list(
		/obj/item/gun/ballistic/automatic/ak74m,
		/obj/item/ammo_box/magazine/ak74m
	)

/datum/violence_gear/rifle/asval
	name = "Вал"
	cost = 3250
	items = list(
		/obj/item/gun/ballistic/automatic/asval,
		/obj/item/ammo_box/magazine/asval
	)

/datum/violence_gear/rifle/sar62l
	name = "NT SAR-62L"
	cost = 9500
	items = list(
		/obj/item/gun/ballistic/automatic/laser/sar62l,
		/obj/item/ammo_box/magazine/recharge/sar62l
	)

/datum/violence_gear/shotgun
	cat = "Дробовики"

/datum/violence_gear/shotgun/doublebarrel
	name = "Двухстволка"
	cost = 950
	items = list(
		/obj/item/gun/breakopen/doublebarrel,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/shotgun/combat
	name = "Боевой дробовик"
	cost = 1750
	items = list(
		/obj/item/gun/ballistic/shotgun/automatic/combat,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/shotgun/saiga
	name = "Сайга"
	cost = 2250
	items = list(
		/obj/item/gun/ballistic/shotgun/saiga,
		/obj/item/ammo_box/magazine/saiga,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/shotgun/bulldog
	name = "Bulldog"
	cost = 2500
	items = list(
		/obj/item/gun/ballistic/shotgun/bulldog/unrestricted,
		/obj/item/ammo_box/magazine/m12g,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/heavygun
	cat = "Тяжёлое оружие"

/datum/violence_gear/heavygun/rocketlauncher
	name = "PML-9"
	cost = 8500
	items = list(
		/obj/item/gun/ballistic/rocketlauncher/unrestricted,
		/obj/item/ammo_casing/caseless/rocket
	)

/datum/violence_gear/heavygun/l6_saw
	name = "L6 SAW"
	cost = 9250
	items = list(
		/obj/item/gun/ballistic/automatic/l6_saw/unrestricted,
		/obj/item/ammo_box/magazine/mm712x82
	)

/datum/violence_gear/heavygun/pulse
	name = "Пульсач"
	cost = 18500
	items = list(/obj/item/gun/energy/pulse)

/datum/violence_gear/heavygun/gyropistol
	name = "Гироджет"
	cost = 19500
	items = list(
		/obj/item/gun/ballistic/automatic/gyropistol,
		/obj/item/ammo_box/magazine/m75
	)

/datum/violence_gear/armor
	cat = "Броня"

/datum/violence_gear/armor/durathread
	name = "Бомжпакет"
	cost = 250
	items = list(
		/obj/item/clothing/suit/armor/vest/durathread,
		/obj/item/clothing/head/beret/durathread
	)

/datum/violence_gear/armor/basic
	name = "Бронежилет"
	cost = 650
	items = list(
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/gloves/fingerless
	)

/datum/violence_gear/armor/bulletproof
	name = "Пуленепробиваемый"
	cost = 1050
	items = list(
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/mask/gas/sechailer,
		/obj/item/clothing/head/helmet/alt,
		/obj/item/clothing/gloves/combat
	)

/datum/violence_gear/armor/specops
	name = "Спецназ"
	cost = 1250
	items = list(
		/obj/item/clothing/head/helmet/maska/altyn,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/suit/armor/opvest/sobr,
		/obj/item/clothing/gloves/combat/sobr,
		/obj/item/clothing/shoes/combat
	)

/datum/violence_gear/armor/heavy
	name = "Тяжёлый спецназ"
	cost = 1450
	items = list(
		/obj/item/clothing/head/helmet/maska/altyn/black,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/suit/armor/heavysobr,
		/obj/item/clothing/gloves/combat/sobr,
		/obj/item/clothing/shoes/combat/swat
	)

/datum/violence_gear/armor/shielded
	name = "Силовой"
	cost = 2000
	items = list(
		/obj/item/clothing/suit/space/hardsuit/shielded/syndi,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/gloves/tackler/combat/insulated,
		/obj/item/clothing/shoes/combat/swat
	)

/datum/violence_gear/armor/deathsquad
	name = "Дедушка"
	cost = 2500
	items = list(
		/obj/item/clothing/suit/space/hardsuit/deathsquad,
		/obj/item/clothing/gloves/tackler/combat/insulated,
		/obj/item/clothing/glasses/hud/toggle/thermal,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/shoes/combat/swat
	)

/datum/violence_gear/shield
	cat = "Щиты"

/datum/violence_gear/shield/buckler
	name = "Деревянный щит"
	cost = 500
	items = list(/obj/item/shield/riot/buckler)

/datum/violence_gear/shield/riot
	name = "Крепкий щит"
	cost = 750
	items = list(/obj/item/shield/riot)

/datum/violence_gear/shield/kevlar
	name = "Кевларовый щит"
	cost = 1000
	items = list(/obj/item/shield/riot/kevlar)

/datum/violence_gear/shield/energy
	name = "Энергощит"
	cost = 1250
	items = list(/obj/item/shield/energy)

/datum/violence_gear/shield/military
	name = "Титановый щит"
	cost = 1500
	items = list(/obj/item/shield/riot/military)

/datum/violence_gear/misc
	cat = "Различное"

/datum/violence_gear/misc/medkit
	name = "Аптечка"
	cost = 250
	items = list(/obj/item/storage/firstaid/regular)

/datum/violence_gear/misc/sunglasses
	name = "Солнцезащитные"
	cost = 350
	items = list(/obj/item/clothing/glasses/sunglasses)

/datum/violence_gear/misc/flashbang
	name = "Светошумовая"
	cost = 450
	items = list(/obj/item/grenade/flashbang)

/datum/violence_gear/misc/teargas
	name = "Перцовый газ"
	cost = 600
	items = list(/obj/item/grenade/chem_grenade/teargas)

/datum/violence_gear/misc/frag
	name = "Осколочная"
	cost = 900
	items = list(/obj/item/grenade/frag)

/datum/violence_gear/misc/pamk
	name = "ПАМК"
	cost = 1250
	items = list(/obj/item/pamk)

#undef VIOLENCE_FINAL_ROUND
