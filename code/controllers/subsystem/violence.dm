SUBSYSTEM_DEF(violence)
	name = "Violence"
	wait = 1 SECONDS

	flags = SS_NO_INIT
	can_fire = FALSE

	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	// активность режима
	var/active = FALSE
	// текущий раунд
	var/current_round = 0
	// лимит времени раунда
	var/time_limit = 3 MINUTES
	// лимит кончился
	var/time_is_run_out = FALSE
	// огонь по своим
	var/friendlyfire = FALSE

	// тема, зависящая от карты
	var/theme
	// должны ли мы учитывать процессинг темы
	var/special_theme_process = FALSE
	// зафоршенная карта
	var/forced_map
	// режим игры
	var/playmode

	// датум команды
	var/datum/team/violence/red/red_team_datum
	var/datum/team/violence/red/blue_team_datum

	// список игроков в командах
	var/list/red_team = list()
	var/list/blue_team = list()
	// общий список датумов игроков
	var/list/players = list()
	// места для закладки бомб
	var/list/bomb_locations = list()
	// активна ли бомба
	var/bomb_active = FALSE
	// установлена ли бомба
	var/bomb_planted = FALSE
	// сдетонировала ли бомба
	var/bomb_detonated = FALSE

	// активен ли раунд
	var/round_active = FALSE
	// основная зона, которая отслеживается
	var/area/main_area

	// последнее количество игроков после начала раунда
	var/last_reds = 0
	var/last_blues = 0

	// счётчик побед
	var/wins_reds = 0
	var/wins_blues = 0

	// стрик поражений
	var/losestreak_reds = 0
	var/losestreak_blues = 0

	// выплата в каждом раунде и за убийство
	var/payout = 75

	// текущий цвет на арене
	var/default_color

	// текущая альфа цвета на арене
	var/default_alpha

	// чёрных список предметов для сохранения
	var/list/blacklisted_types = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/terroristsc4,
		/obj/item/clothing/under/color/red,
		/obj/item/clothing/under/color/blue,
		/obj/item/card/id/red,
		/obj/item/card/id/blue,
		/obj/item/radio/headset,
		/obj/item/clothing/under/chronos,
		/obj/item/clothing/neck/cape/chronos,
		/obj/item/clothing/head/beret/chronos,
		/obj/item/offhand, // Это же The offhand!
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/duffelbag,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/gun/energy/wormhole_projector/core_inserted,
	)

/datum/controller/subsystem/violence/stat_entry(msg)
	msg += "RO:[current_round]"
	msg += "|FF:[friendlyfire]"
	msg += "|TH:[theme]"
	msg += "|FM:[forced_map]"
	msg += "|PM:[playmode]"
	msg += "|PL:[LAZYLEN(players)]"
	msg += "|RP:[LAZYLEN(red_team)]"
	msg += "|BP:[LAZYLEN(blue_team)]"
	msg += "|RA:[round_active]"
	msg += "|PO:[payout]"
	return msg

/datum/controller/subsystem/violence/proc/setup_everything()
	// ставим тематическую заставку
	var/icon/great_title_icon = icon(pick('white/valtos/icons/violence/violence1.jpg', 'white/valtos/icons/violence/violence2.jpg', 'white/valtos/icons/violence/violence3.jpg'))
	SStitle.autorotate = FALSE
	SStitle.icon = great_title_icon
	SStitle.icon = great_title_icon
	// выключаем ротацию картинок в лобби
	SStitle.autorotate = FALSE
	message_admins(span_nezbere("VM: SStitle Success!"))
	// создаём команды
	red_team_datum = new
	blue_team_datum = new
	message_admins(span_nezbere("VM: Teams Success!"))
	// делаем датумы игроков на всякий случай
	for(var/client/C in GLOB.clients)
		if(!players[C.ckey])
			players[C.ckey] = new /datum/violence_player
	message_admins(span_nezbere("VM: Total players created [LAZYLEN(players)]!"))
	// пикаем арену
	var/obj/effect/landmark/violence/V = GLOB.violence_landmark
	V.load_map()
	message_admins(span_nezbere("VM: Map loaded!"))
	// включаем киллкаунтер
	GLOB.prikol_mode = TRUE
	message_admins(span_nezbere("VM: KC enabled!"))
	// включаем турнирный режим
	GLOB.is_tournament_rules = TRUE
	message_admins(span_nezbere("VM: Tournament mode enabled!"))
	// заполняем карту генераторными штуками
	SSmapping.seedStation()
	message_admins(span_nezbere("VM: Map seeded!"))
	// генерируем штуки для закупа
	generate_violence_gear()
	message_admins(span_nezbere("VM: Gear generated!"))
	// отключаем ивенты станции
	GLOB.disable_fucking_station_shit_please = TRUE
	message_admins(span_nezbere("VM: Misc station things disabled!"))
	// включаем режим насилия, который немного изменяет правила игры
	active = TRUE
	message_admins(span_nezbere("VM: Active!"))
	// выбираем зону (если её нет, то высрет рантайм)
	main_area = GLOB.areas_by_type[/area/violence]
	message_admins(span_nezbere("VM: Main area selected!"))
	// настраиваем свет в основной зоне
	adjust_arena_light(default_color, default_alpha)
	message_admins(span_nezbere("VM: Area lighting adjusted!"))
	// отключаем лишние подсистемы
	SSair.flags |= SS_NO_FIRE
	SSevents.flags |= SS_NO_FIRE
	SSnightshift.flags |= SS_NO_FIRE
	SSorbits.flags |= SS_NO_FIRE
	SSweather.flags |= SS_NO_FIRE
	SSeconomy.flags |= SS_NO_FIRE
	// чёрный ящик будет пуст
	SSblackbox.Seal()
	message_admins(span_nezbere("VM: Some SS disabled!"))
	// отключаем все станционные джобки и создаём специальные
	GLOB.position_categories = list(
		EXP_TYPE_COMBATANT_RED = list("jobs" = GLOB.combatant_red_positions, "color" = "#ff0000", "runame" = "Красные"),
		EXP_TYPE_COMBATANT_BLUE = list("jobs" = GLOB.combatant_blue_positions, "color" = "#0000ff", "runame" = "Синие")
	)
	GLOB.exp_jobsmap = list(
		EXP_TYPE_COMBATANT_RED = list("titles" = GLOB.combatant_red_positions),
		EXP_TYPE_COMBATANT_BLUE = list("titles" = GLOB.combatant_blue_positions)
	)
	message_admins(span_nezbere("VM: Positions overwriten!"))
	// удаляем все CTF из мира
	for(var/obj/machinery/capture_the_flag/CTF in GLOB.machines)
		qdel(CTF)
	message_admins(span_nezbere("VM: CTF removed!"))
	// выставляем особый параллакс
	GLOB.forced_parallax_type = 100
	message_admins(span_nezbere("VM: Parallax adjusted!"))
	// маркируем все текущие атомы, чтобы чистильщик их не удалил
	for(var/atom/A in main_area)
		A.flags_1 |= KEEP_ON_ARENA_1
	message_admins(span_nezbere("VM: KEEP_ON_ARENA_1 items Marked!"))
	// отменяем готовность и тут на всякий случай
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	message_admins(span_nezbere("VM: Unreadied players in case of sending them into nullspace!"))
	// 2x урон всегда
	CONFIG_SET(number/damage_multiplier, 2)
	message_admins(span_nezbere("VM: 2x damage enabled!"))
	// выбираем рандом по весу, если не зафоршен режим
	if(!playmode)
		playmode = pick_weight(list(VIOLENCE_PLAYMODE_TEAMFIGHT = 80, VIOLENCE_PLAYMODE_BOMBDEF = 10, VIOLENCE_PLAYMODE_TAG = 10))
	to_chat(world, leader_brass("Был выбран режим [playmode]!"))
	// выключаем рандомные ивенты наверняка
	CONFIG_SET(flag/allow_random_events, FALSE)
	message_admins(span_nezbere("VM: Random events disabled!"))
	// удаляем все спаунеры из мира, дополнительно
	for(var/list/spawner in GLOB.mob_spawners)
		QDEL_LIST_ASSOC(spawner)
	message_admins(span_nezbere("VM: All ghost spawners removed!"))
	// готовим новый раунд
	spawn(1 SECONDS)
		new_round()
	message_admins(span_nezbere("VM: New round preparing in background!"))
	// регистрируем сигнал о смерти
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(someone_has_died))
	message_admins(span_nezbere("VM: Death signal registered!"))
	message_admins(span_nezbere("VM: Init complete!"))

/datum/controller/subsystem/violence/fire()
	if(!active || !round_active)
		return

	// удаляем хотспоты
	for(var/obj/effect/hotspot/H in SSair.hotspots)
		qdel(H)

	// добейте выживших и сбежавших
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat != DEAD && H.health <= 0)
			if(!(get_turf(H) in main_area))
				REMOVE_TRAIT(H, TRAIT_CORPSELOCKED, "violence")
				H.dust()
				continue

			if(isandroid(H) || is_ipc(H) || playmode == VIOLENCE_PLAYMODE_TAG)
				H.death()
				continue

			var/datum/disease/D = new /datum/disease/heart_failure()
			D.stage = 5
			H.ForceContractDisease(D, FALSE, TRUE)

	// специальные тематические приколы
	if(special_theme_process)
		process_theme()

	// заставляем людей произносить рандомные реплики
	for(var/mob/living/carbon/human/H in main_area)
		if(prob(2) && H.stat == CONSCIOUS)
			random_speech(H)

	// обновляем таймер
	update_timer()
	if(playmode == VIOLENCE_PLAYMODE_BOMBDEF)
		if(bomb_detonated)
			end_round("КРАСНЫХ")
			return

		if(bomb_planted && !bomb_active)
			end_round("СИНИХ")
			return

		if(bomb_active)
			return

	// принуждаем торопиться
	if(!time_is_run_out && time_limit <= 0)
		to_chat(world, leader_brass("ВРЕМЯ НА ИСХОДЕ!"))
		play_sound_to_everyone('sound/effects/violence/notime.ogg')
		time_is_run_out = TRUE

	if(time_is_run_out)
		if(bomb_planted && LAZYLEN(blue_team))
			return

		if(playmode == VIOLENCE_PLAYMODE_BOMBDEF)
			end_round("СИНИХ")
			return

		if(LAZYLEN(red_team) < LAZYLEN(blue_team))
			end_round("СИНИХ")
			return

		if(LAZYLEN(red_team) > LAZYLEN(blue_team))
			end_round("КРАСНЫХ")
			return

		if(LAZYLEN(red_team) == LAZYLEN(blue_team))
			for(var/mob/living/carbon/human/H in main_area)
				// добиваем шутников
				H.apply_damage(1, BRUTE, wound_bonus = 100, forced = TRUE, sharpness = pick(NONE, SHARP_EDGED, SHARP_POINTY))

	if(LAZYLEN(red_team) == 0 && LAZYLEN(blue_team))
		end_round("СИНИХ")

	if(LAZYLEN(blue_team) == 0 && LAZYLEN(red_team))
		end_round("КРАСНЫХ")

	if(LAZYLEN(red_team) == 0 && LAZYLEN(blue_team) == 0)
		end_round()

/datum/controller/subsystem/violence/proc/process_theme()
	switch(theme)
		if(VIOLENCE_THEME_PORTAL)
			if(current_round >= 10)
				time_limit = rand(20, 900)
				for(var/turf/open/T as() in main_area)
					if(prob(95) || !istype(T, /turf/open))
						continue
					T.ChangeTurf(pick(subtypesof(/turf/open)))
					adjust_arena_light(pick(COLOR_YELLOW, COLOR_LIME, COLOR_RED, COLOR_BLUE_LIGHT, COLOR_CYAN, COLOR_MAGENTA), rand(1, 255))
		if(VIOLENCE_THEME_CYBER)
			for(var/turf/open/T as() in main_area)
				if(prob(99.5) || !istype(T, /turf/open))
					continue
				if(prob(2.5))
					new /obj/effect/powerup/health/violence(T)
				else
					new /obj/effect/attack_spike(T)

/datum/controller/subsystem/violence/proc/random_speech(mob/living/carbon/human/H)
	var/is_heavy = FALSE
	if(H.wear_mask)
		is_heavy = TRUE
	var/sound/S
	if(H?.mind?.has_antag_datum(/datum/antagonist/combatant/red))
		if(is_heavy)
			S = "sound/voice/violence/bear/h/[rand(1, 45)].ogg"
		else
			S = "sound/voice/violence/bear/[rand(1, 52)].ogg"
	else if(H?.mind?.has_antag_datum(/datum/antagonist/combatant/blue))
		if(is_heavy)
			S = "sound/voice/violence/usec/h/[rand(1, 38)].ogg"
		else
			S = "sound/voice/violence/usec/[rand(1, 31)].ogg"
	if(S)
		H.visible_message("<b>[H]</b> выкрикивает что-то!", pick("Щас мы им!", "Засранец!", "Ну-ну, сволочь!"))
		playsound(get_turf(H), S, 100)
		var/list/speech_bubble_recipients = list()
		for(var/mob/M in view(7, get_turf(H)))
			if(M.client)
				speech_bubble_recipients.Add(M.client)
		var/image/I = image('icons/mob/talk.dmi', H, "default2", FLY_LAYER)
		SET_PLANE(I, ABOVE_GAME_PLANE, H)
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, TYPE_PROC_REF(/, flick_overlay), I, speech_bubble_recipients, 30)

/datum/controller/subsystem/violence/proc/someone_has_died(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER

	var/datum/violence_player/vp_dead = vp_get_player(dead?.ckey)

	// если нет датума игрока, то игнорируем
	if(!vp_dead)
		return

	play_sound_to_everyone(pick(list('sound/effects/violence/fame1.ogg', 'sound/effects/violence/fame2.ogg', 'sound/effects/violence/fame3.ogg', 'sound/effects/violence/fame4.ogg', 'sound/effects/violence/fame5.ogg')), rand(25, 50))

	vp_dead.deaths++

	if(!dead?.mind || !ishuman(dead))
		return

	var/datum/violence_player/vp_killer = vp_get_player(dead?.lastattackermob?.ckey)

	if(vp_killer)

		var/rightkill = vp_dead.team != vp_killer.team

		vp_killer.money += rightkill ? payout : -payout
		vp_killer.kills += rightkill ? 1 : -1

		to_chat(dead?.lastattackermob, span_boldnotice("[rightkill ? "+[payout]" : "-[payout]"]₽"))

	if(playmode != VIOLENCE_PLAYMODE_TAG)
		switch(vp_dead.team)
			if("red")
				red_team -= dead.mind
				to_chat(world, span_red("[LAZYLEN(red_team)]/[last_reds]"))
			if("blue")
				blue_team -= dead.mind
				to_chat(world, span_blue("[LAZYLEN(blue_team)]/[last_blues]"))
		return

	var/mob/living/carbon/human/H = dead
	var/obj/item/card/id/new_card
	qdel(H.wear_id)
	var/obj/item/radio/R = H.ears
	switch(vp_dead.team)
		if("red")
			vp_dead.team = "blue"
			new_card = new /obj/item/card/id/blue
			R?.set_frequency(FREQ_CTF_BLUE)
			SSid_access.apply_trim_to_card(new_card, /datum/id_trim/combatant/blue)
			dead.mind.remove_antag_datum(/datum/antagonist/combatant/red)
			dead.mind.add_antag_datum(/datum/antagonist/combatant/blue)
			H.faction = list("combatant_blue")
			H.w_uniform?.set_greyscale("#52aecc")
		if("blue")
			vp_dead.team = "red"
			new_card = new /obj/item/card/id/red
			R?.set_frequency(FREQ_CTF_RED)
			SSid_access.apply_trim_to_card(new_card, /datum/id_trim/combatant/red)
			dead.mind.remove_antag_datum(/datum/antagonist/combatant/blue)
			dead.mind.add_antag_datum(/datum/antagonist/combatant/red)
			H.faction = list("combatant_red")
			H.w_uniform?.set_greyscale("#eb0c07")
	H.revive(TRUE)
	H.equip_to_slot_or_del(new_card, ITEM_SLOT_ID)
	new_card.update_label()
	H.sec_hud_set_ID()
	H.update_clothing(ITEM_SLOT_ICLOTHING)
	to_chat(world, leader_brass("Красные: [LAZYLEN(red_team)] | Синие: [LAZYLEN(blue_team)]"))

/datum/controller/subsystem/violence/proc/update_timer()
	var/formatted_time = "XX:XX"
	if(time_is_run_out)
		formatted_time = pick("УБЕЙ!", "БЕГИ!", "ДАВИ!", "ААААА", "?????", "ДАВАЙ", "ЖМИ!", "НУ ЖЕ", "УМРИ!")
	else
		time_limit -= 1 SECONDS
		time_limit = max(0, time_limit)
		formatted_time = time2text(time_limit, "mm:ss")
	for(var/mob/M in GLOB.player_list)
		M?.hud_used?.timelimit?.update_info(formatted_time)

// конец раунда и запуск начала нового раунда
/datum/controller/subsystem/violence/proc/end_round(winner = "ХУЙ ЕГО ЗНАЕТ КОГО")
	message_admins(span_nezbere("VM: Round has ended!"))
	round_active = FALSE
	bomb_detonated = FALSE
	bomb_active = FALSE
	bomb_planted = FALSE
	time_limit = 3 MINUTES
	time_is_run_out = FALSE
	SSjob.SetJobPositions(/datum/job/combantant/red, 0, 0, TRUE)
	SSjob.SetJobPositions(/datum/job/combantant/blue, 0, 0, TRUE)
	switch(winner)
		if("КРАСНЫХ")
			wins_reds++
			losestreak_reds = 0
			losestreak_blues++
		if("СИНИХ")
			wins_blues++
			losestreak_blues = 0
			losestreak_reds++
	spawn(3 SECONDS)
		sortTim(players, GLOBAL_PROC_REF(cmp_violence_players), TRUE)
		play_sound_to_everyone('sound/effects/violence/gong.ogg')
		var/list/stats_reds = list()
		var/list/stats_blues = list()
		var/list/stats = list()
		stats += "<table><tr><td>Игрок</td><td>Убийств</td><td>Смертей</td></tr>"
		if(playmode != VIOLENCE_PLAYMODE_TAG)
			for(var/key in players)
				var/datum/violence_player/VP = players[key]
				// раздаём деньги бомжам
				VP.money += payout * current_round
				VP.money += VP.team == "red" ? losestreak_reds * payout : losestreak_blues * payout
				if(VP.team == "red")
					stats_reds += "<tr><td><b class='red'>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>"
				else if (VP.team == "blue")
					stats_blues += "<tr><td><b class='blue'>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>"
			LAZYADD(stats, stats_reds)
			LAZYADD(stats, stats_blues)
		else
			for(var/key in players)
				var/datum/violence_player/VP = players[key]
				LAZYADD(stats, "<tr><td><b>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>")
		stats += "</table>"
		to_chat(world, span_info(stats.Join()))
		to_chat(world, leader_brass("РАУНД [current_round]/[VIOLENCE_FINAL_ROUND-1] ЗАВЕРШЁН!"))
		if(playmode != VIOLENCE_PLAYMODE_TAG)
			to_chat(world, leader_brass("ПОБЕДА [winner]! <b class='red'>[wins_reds]</b>/<b class='blue'>[wins_blues]</b>"))
			to_chat(world, leader_brass("Выдано [payout * current_round]₽ победителям и [(payout * current_round) + (winner != "КРАСНЫХ" ? losestreak_reds * payout : losestreak_blues * payout)]₽ проигравшим!"))
	play_sound_to_everyone('sound/effects/violence/crowd_win.ogg')
	message_admins(span_nezbere("VM: Trying to start a new round!"))
	spawn(10 SECONDS)
		new_round()

// удаляет все атомы без флага KEEP_ON_ARENA_1 в основной зоне, также закрывает шаттерсы
/datum/controller/subsystem/violence/proc/clean_arena()
	var/count_deleted = 0
	for(var/atom/A in main_area)
		if(!(A.flags_1 & KEEP_ON_ARENA_1) && (isobj(A) || ismob(A)))
			count_deleted++
			qdel(A)
	message_admins("УДАЛЕНО [count_deleted] РАЗЛИЧНЫХ ШТУК.")
	// исправляем свет
	main_area.update_base_lighting()
	for(var/obj/machinery/door/poddoor/D in main_area)
		INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door/poddoor, close))

// новый раунд, отправляет всех в лобби и очищает арену
/datum/controller/subsystem/violence/proc/new_round()
	current_round++
	// проверяем, был ли предыдущий раунд финальным
	if(current_round == VIOLENCE_FINAL_ROUND)
		return
	// очищаем команды
	red_team = list()
	blue_team = list()
	message_admins(span_nezbere("VM: Current round [current_round] preparing!"))
	// необходимо кинуть всех в лобби и сохранить экипировку, чтобы была возможность вступить в бой
	if(current_round != 1)
		for(var/mob/M in GLOB.player_list)
			if(ishuman(M) && M?.stat == CONSCIOUS)
				var/datum/violence_player/VP = vp_get_player(M.ckey)
				var/mob/living/carbon/human/H = M
				var/list/saved_shit = list()
				// получаем список предметов на персонаже, включая рюкзак
				LAZYADD(saved_shit, H.get_all_gear())
				// по идее должно исключить стакинг бесполезных предметов
				for(var/obj/item/I in saved_shit)
					if(!I || (I.type in blacklisted_types))
						continue
					LAZYADD(VP.saved_items, I.type)
			M?.mind?.remove_all_antag_datums()
			SEND_SOUND(M, sound(null, channel = CHANNEL_VIOLENCE_MODE))
			var/mob/dead/new_player/NP = new()
			NP.ckey = M.ckey
			qdel(M)
	// если сейчас киберспейс, то нам нужно отрегенерировать лёд
	if(theme == VIOLENCE_THEME_CYBER)
		for(var/obj/effect/dz/ice/ICE in GLOB.hacked_ice)
			var/turf/T = get_turf(ICE)
			T.ChangeTurf(ICE.old_type)
		message_admins(span_nezbere("VM: Starting to remove [LAZYLEN(GLOB.hacked_ice)] units of hacked ICE!"))
		// на всякий случай принудительно очищаем список. Бьёнд умеет шутить и его шутки весьма подлые
		LAZYCLEARLIST(GLOB.hacked_ice)
		message_admins(span_nezbere("VM: Success!"))
	// вызов очистки
	clean_arena()
	spawn(10 SECONDS)
		// сбрасываем статистику
		SSjob.ResetOccupations("Violence")
		SSjob.SetJobPositions(/datum/job/combantant/red, 999, 999, TRUE)
		SSjob.SetJobPositions(/datum/job/combantant/blue, 999, 999, TRUE)
		message_admins(span_nezbere("VM: Resetted statistics and enabling spawn!"))
		// оповещаем игроков
		to_chat(world, leader_brass("РАУНД [current_round]!"))
		play_sound_to_everyone('sound/effects/violence/horn.ogg')
		// открываем шаттерсы через время
		spawn(30 SECONDS)
			// активируем раунд
			round_active = TRUE
			message_admins(span_nezbere("VM: Round active!"))
			if(playmode == VIOLENCE_PLAYMODE_BOMBDEF)
				var/datum/mind/terr_mind = pick(red_team)
				var/mob/living/carbon/human/terrorist = terr_mind.current
				var/obj/item/terroristsc4/terroristsc4 = new(get_turf(terrorist))
				terrorist.put_in_hands(terroristsc4)
				terrorist.visible_message(span_fuckingbig("<b>[terrorist]</b> получает бомбу! Помогите ему установить её."),
					span_fuckingbig("Мне досталась бомба. Необходимо установить её в заранее обозначенной точке."))
			to_chat(world, leader_brass("В БОЙ!"))
			last_reds = LAZYLEN(red_team)
			last_blues = LAZYLEN(blue_team)
			play_sound_to_everyone('sound/effects/violence/gong.ogg')
			for(var/obj/machinery/door/poddoor/D in main_area)
				INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door/poddoor, open))

/datum/controller/subsystem/violence/proc/adjust_arena_light(new_color, new_alpha)
	main_area?.set_base_lighting(new_color, new_alpha)
