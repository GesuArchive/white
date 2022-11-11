// дохуя пиздатый код ниже, не завидую тому, кто попытается спиздить его

GLOBAL_VAR_INIT(violence_mode_activated, FALSE)
GLOBAL_VAR_INIT(violence_current_round, 0)
GLOBAL_VAR_INIT(violence_time_limit, 3 MINUTES)
GLOBAL_VAR_INIT(violence_friendlyfire, FALSE)
GLOBAL_DATUM(violence_red_datum, /datum/team/violence/red)
GLOBAL_DATUM(violence_blue_datum, /datum/team/violence/blue)
GLOBAL_VAR(violence_theme)
GLOBAL_VAR(violence_forced_map)
GLOBAL_VAR(violence_playmode)
GLOBAL_LIST_EMPTY(violence_red_team)
GLOBAL_LIST_EMPTY(violence_blue_team)
GLOBAL_LIST_EMPTY(violence_bomb_locations)

/datum/game_mode/violence
	name = "violence"
	config_tag = "violence"
	report_type = "violence"
	enemy_minimum_age = 0
	maximum_players = 64

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
	var/payout = 50

	announce_span = "danger"
	announce_text = "Резня!"

/datum/game_mode/violence/pre_setup()
	// ускоряем тикер вдвое, экспериментально
	SSticker.wait = 1 SECONDS
	// ставим тематическую заставку
	var/icon/great_title_icon = icon(pick('white/valtos/icons/violence/violence1.jpg', 'white/valtos/icons/violence/violence2.jpg'))
	SStitle.icon = great_title_icon
	SStitle.splash_turf.icon = great_title_icon
	// создаём команды
	GLOB.violence_red_datum = new
	GLOB.violence_blue_datum = new
	// делаем датумы игроков на всякий случай
	for(var/client/C in GLOB.clients)
		if(!GLOB.violence_players[C.ckey])
			GLOB.violence_players[C.ckey] = new /datum/violence_player
	// пикаем арену
	var/obj/effect/landmark/violence/V = GLOB.violence_landmark
	V.load_map()
	// включаем ТТС
	GLOB.tts = TRUE
	// включаем киллкаунтер
	GLOB.prikol_mode = TRUE
	// включаем турнирный режим
	GLOB.is_tournament_rules = TRUE
	// заполняем карту генераторными штуками
	SSmapping.seedStation()
	// генерируем штуки для закупа
	generate_violence_gear()
	// выключаем ротацию картинок в лобби
	SStitle.autorotate = FALSE
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
	// отключаем все станционные джобки и создаём специальные
	GLOB.position_categories = list(
		EXP_TYPE_COMBATANT_RED = list("jobs" = GLOB.combatant_red_positions, "color" = "#ff0000", "runame" = "Красные"),
		EXP_TYPE_COMBATANT_BLUE = list("jobs" = GLOB.combatant_blue_positions, "color" = "#0000ff", "runame" = "Синие")
	)
	GLOB.exp_jobsmap = list(
		EXP_TYPE_COMBATANT_RED = list("titles" = GLOB.combatant_red_positions),
		EXP_TYPE_COMBATANT_BLUE = list("titles" = GLOB.combatant_blue_positions)
	)
	// удаляем все CTF из мира
	for(var/obj/machinery/capture_the_flag/CTF in GLOB.machines)
		qdel(CTF)
	// выставляем особый параллакс
	GLOB.forced_parallax_type = 100
	// маркируем все текущие атомы, чтобы чистильщик их не удалил
	for(var/atom/A in main_area)
		A.flags_1 |= KEEP_ON_ARENA_1
	// отменяем готовность и тут на всякий случай
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	return TRUE

/datum/game_mode/violence/can_start()
	// отменяем готовность у всех игроков, чтобы их случайно не закинуло в нуллспейс
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	// удаляем все спаунеры из мира, дополнительно
	for(var/list/spawner in GLOB.mob_spawners)
		QDEL_LIST_ASSOC(spawner)
	return TRUE

/datum/game_mode/violence/post_setup()
	..()
	// выбираем рандом, если не зафоршен режим
	if(!GLOB.violence_playmode)
		GLOB.violence_playmode = pick(list(VIOLENCE_PLAYMODE_TEAMFIGHT, VIOLENCE_PLAYMODE_BOMBDEF, VIOLENCE_PLAYMODE_TAG))
	to_chat(world, leader_brass("Был выбран режим [GLOB.violence_playmode]!"))
	// выключаем рандомные ивенты наверняка
	CONFIG_SET(flag/allow_random_events, FALSE)
	// готовим новый раунд
	spawn(1 SECONDS)
		new_round()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/someone_has_died)

/datum/game_mode/violence/generate_report()
	return "В вашем секторе проводится самый кровавый чемпионат, а также мы тестируем нашу новейшую систему удалённого клонирования. Приятной смены!"

/datum/game_mode/violence/send_intercept(report = 0)
	return

/proc/play_sound_to_everyone(snd, volume = 100, channel = null)
	for(var/mob/M in GLOB.player_list)
		var/sound/S = sound(snd, volume = volume)
		if(channel)
			S.channel = channel
		SEND_SOUND(M, S)

/datum/game_mode/violence/process()
	if(round_active)
		// удаляем хотспоты
		for(var/obj/effect/hotspot/H in main_area)
			qdel(H)
		// добейте выживших и сбежавших
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat != DEAD && H.health <= 0)
				if(!(get_turf(H) in main_area))
					REMOVE_TRAIT(H, TRAIT_CORPSELOCKED, "violence")
					H.dust()
					continue
				if(isandroid(H) || isIPC(H) || GLOB.violence_playmode == VIOLENCE_PLAYMODE_TAG)
					H.death()
					continue
				var/datum/disease/D = new /datum/disease/heart_failure()
				D.stage = 5
				H.ForceContractDisease(D, FALSE, TRUE)
		// специальные тематические приколы
		switch(GLOB.violence_theme)
			if("portal")
				if(GLOB.violence_current_round >= 10)
					GLOB.violence_time_limit = rand(20, 900)
					for(var/turf/open/T as() in main_area)
						if(prob(95) || !istype(T, /turf/open))
							continue
						T.ChangeTurf(pick(subtypesof(/turf/open)))
			if("cyber")
				for(var/turf/open/T as() in main_area)
					if(prob(99.5) || !istype(T, /turf/open))
						continue
					if(prob(2.5))
						new /obj/effect/powerup/health/violence(T)
					else
						new /obj/effect/attack_spike(T)
		// заставляем людей произносить рандомные реплики
		for(var/mob/living/carbon/human/H in main_area)
			if(prob(2) && H.stat == CONSCIOUS)
				random_speech(H)
		// обновляем таймер
		update_timer()
		if(GLOB.violence_playmode == VIOLENCE_PLAYMODE_BOMBDEF)
			if(GLOB.violence_bomb_detonated)
				end_round("КРАСНЫХ")
				return
			if(GLOB.violence_bomb_planted && !GLOB.violence_bomb_active)
				end_round("СИНИХ")
				return
			if(GLOB.violence_bomb_active)
				return
		if(GLOB.violence_time_limit <= 0)
			if(GLOB.violence_bomb_planted && LAZYLEN(GLOB.violence_blue_team))
				return
			if(GLOB.violence_playmode == VIOLENCE_PLAYMODE_BOMBDEF)
				end_round("СИНИХ")
				return
			if(LAZYLEN(GLOB.violence_red_team) < LAZYLEN(GLOB.violence_blue_team))
				end_round("СИНИХ")
				return
			if(LAZYLEN(GLOB.violence_red_team) > LAZYLEN(GLOB.violence_blue_team))
				end_round("КРАСНЫХ")
				return
		if(LAZYLEN(GLOB.violence_red_team) == 0 && LAZYLEN(GLOB.violence_blue_team))
			end_round("СИНИХ")
		if(LAZYLEN(GLOB.violence_blue_team) == 0 && LAZYLEN(GLOB.violence_red_team))
			end_round("КРАСНЫХ")
		if(LAZYLEN(GLOB.violence_red_team) == 0 && LAZYLEN(GLOB.violence_blue_team) == 0)
			end_round()

/datum/game_mode/violence/proc/random_speech(mob/living/carbon/human/H)
	var/is_heavy = FALSE
	if(H.wear_mask)
		is_heavy = TRUE
	var/sound/S
	if(H?.mind?.has_antag_datum(/datum/antagonist/combatant/red))
		if(is_heavy)
			S = "white/valtos/sounds/ts/bear/h/[rand(1, 45)].ogg"
		else
			S = "white/valtos/sounds/ts/bear/[rand(1, 52)].ogg"
	else if(H?.mind?.has_antag_datum(/datum/antagonist/combatant/blue))
		if(is_heavy)
			S = "white/valtos/sounds/ts/usec/h/[rand(1, 38)].ogg"
		else
			S = "white/valtos/sounds/ts/usec/[rand(1, 31)].ogg"
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
		INVOKE_ASYNC(GLOBAL_PROC, /.proc/flick_overlay, I, speech_bubble_recipients, 30)

/datum/game_mode/violence/proc/someone_has_died(datum/source, mob/living/dead, gibbed)
	SIGNAL_HANDLER

	var/datum/violence_player/vp_dead = vp_get_player(dead?.ckey)

	// если нет датума игрока, то игнорируем
	if(!vp_dead)
		return

	play_sound_to_everyone(pick(list('white/valtos/sounds/fame1.ogg', 'white/valtos/sounds/fame2.ogg', 'white/valtos/sounds/fame3.ogg', 'white/valtos/sounds/fame4.ogg', 'white/valtos/sounds/fame5.ogg')), rand(25, 50))

	vp_dead.deaths++

	if(!dead?.mind || !ishuman(dead))
		return

	var/datum/violence_player/vp_killer = vp_get_player(dead?.lastattackermob?.ckey)

	if(vp_killer)

		var/rightkill = vp_dead.team != vp_killer.team

		vp_killer.money += rightkill ? payout : -payout
		vp_killer.kills += rightkill ? 1 : -1

		to_chat(dead?.lastattackermob, span_boldnotice("[rightkill ? "+[payout]" : "-[payout]"]₽"))

	if(GLOB.violence_playmode == VIOLENCE_PLAYMODE_TAG)
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
		to_chat(world, leader_brass("Красные: [LAZYLEN(GLOB.violence_red_team)] | Синие: [LAZYLEN(GLOB.violence_blue_team)]"))
	else
		switch(vp_dead.team)
			if("red")
				GLOB.violence_red_team -= dead.mind
				to_chat(world, span_red("[LAZYLEN(GLOB.violence_red_team)]/[last_reds]"))
			if("blue")
				GLOB.violence_blue_team -= dead.mind
				to_chat(world, span_blue("[LAZYLEN(GLOB.violence_blue_team)]/[last_blues]"))

/datum/game_mode/violence/proc/update_timer()
	GLOB.violence_time_limit -= 1 SECONDS
	GLOB.violence_time_limit = max(0, GLOB.violence_time_limit)
	var/formatted_time = time2text(GLOB.violence_time_limit, "mm:ss")
	for(var/mob/M in GLOB.player_list)
		M?.hud_used?.timelimit?.update_info(formatted_time)

// конец раунда и запуск начала нового раунда
/datum/game_mode/violence/proc/end_round(winner = "ХУЙ ЕГО ЗНАЕТ КОГО")
	round_active = FALSE
	GLOB.violence_bomb_detonated = FALSE
	GLOB.violence_bomb_active = FALSE
	GLOB.violence_bomb_planted = FALSE
	GLOB.violence_time_limit = 3 MINUTES
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
		sortTim(GLOB.violence_players, /proc/cmp_violence_players, TRUE)
		play_sound_to_everyone('white/valtos/sounds/gong.ogg')
		var/list/stats_reds = list()
		var/list/stats_blues = list()
		var/list/stats = list()
		stats += "<table><tr><td>Игрок</td><td>Убийств</td><td>Смертей</td></tr>"
		if(GLOB.violence_playmode != VIOLENCE_PLAYMODE_TAG)
			for(var/key in GLOB.violence_players)
				var/datum/violence_player/VP = GLOB.violence_players[key]
				// раздаём деньги бомжам
				VP.money += payout * GLOB.violence_current_round
				VP.money += VP.team == "red" ? losestreak_reds * payout : losestreak_blues * payout
				if(VP.team == "red")
					stats_reds += "<tr><td><b class='red'>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>"
				else if (VP.team == "blue")
					stats_blues += "<tr><td><b class='blue'>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>"
			LAZYADD(stats, stats_reds)
			LAZYADD(stats, stats_blues)
		else
			for(var/key in GLOB.violence_players)
				var/datum/violence_player/VP = GLOB.violence_players[key]
				LAZYADD(stats, "<tr><td><b>[key]</b></td><td>[VP.kills]</td><td>[VP.deaths]</td></tr>")
		stats += "</table>"
		to_chat(world, span_info(stats.Join()))
		to_chat(world, leader_brass("РАУНД [GLOB.violence_current_round]/[VIOLENCE_FINAL_ROUND-1] ЗАВЕРШЁН!"))
		if(GLOB.violence_playmode != VIOLENCE_PLAYMODE_TAG)
			to_chat(world, leader_brass("ПОБЕДА [winner]! <b class='red'>[wins_reds]</b>/<b class='blue'>[wins_blues]</b>"))
			to_chat(world, leader_brass("Выдано [payout * GLOB.violence_current_round]₽ победителям и [(payout * GLOB.violence_current_round) + (winner != "КРАСНЫХ" ? losestreak_reds * payout : losestreak_blues * payout)]₽ проигравшим!"))
	play_sound_to_everyone('white/valtos/sounds/crowd_win.ogg')
	spawn(10 SECONDS)
		new_round()

/proc/cmp_violence_players(datum/violence_player/a, datum/violence_player/b)
	return a.kills - b.kills

// удаляет все атомы без флага KEEP_ON_ARENA_1 в основной зоне, также закрывает шаттерсы
/datum/game_mode/violence/proc/clean_arena()
	var/count_deleted = 0
	for(var/atom/A in main_area)
		if(!(A.flags_1 & KEEP_ON_ARENA_1) && (isobj(A) || ismob(A)))
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
	// проверяем, был ли предыдущий раунд финальным
	if(GLOB.violence_current_round == VIOLENCE_FINAL_ROUND)
		return
	// очищаем команды
	GLOB.violence_red_team = list()
	GLOB.violence_blue_team = list()
	// необходимо кинуть всех в лобби и сохранить экипировку, чтобы была возможность вступить в бой
	if(GLOB.violence_current_round != 1)
		for(var/mob/M in GLOB.player_list)
			if(ishuman(M) && M?.stat == CONSCIOUS)
				var/datum/violence_player/VP = vp_get_player(M.ckey)
				var/mob/living/carbon/human/H = M
				var/list/saved_shit = list()
				// получаем список предметов на персонаже, включая рюкзак
				LAZYADD(saved_shit, H.get_all_gear())
				// по идее должно исключить стакинг бесполезных предметов
				var/static/list/blacklisted_types = list(
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
	if(GLOB.violence_theme == "cyber")
		for(var/obj/effect/dz/ice/ICE in GLOB.hacked_ice)
			var/turf/T = get_turf(ICE)
			T.ChangeTurf(ICE.old_type)
		// на всякий случай принудительно очищаем список. Бьёнд умеет шутить и его шутки весьма подлые
		LAZYCLEARLIST(GLOB.hacked_ice)
	// вызов очистки
	clean_arena()
	spawn(10 SECONDS)
		// сбрасываем статистику
		SSjob.ResetOccupations("Violence")
		SSjob.SetJobPositions(/datum/job/combantant/red, 999, 999, TRUE)
		SSjob.SetJobPositions(/datum/job/combantant/blue, 999, 999, TRUE)
		// оповещаем игроков
		to_chat(world, leader_brass("РАУНД [GLOB.violence_current_round]!"))
		play_sound_to_everyone('white/valtos/sounds/horn.ogg')
		// открываем шаттерсы через время
		spawn(30 SECONDS)
			// активируем раунд
			round_active = TRUE
			if(GLOB.violence_playmode == VIOLENCE_PLAYMODE_BOMBDEF)
				var/datum/mind/terr_mind = pick(GLOB.violence_red_team)
				var/mob/living/carbon/human/terrorist = terr_mind.current
				var/obj/item/terroristsc4/terroristsc4 = new(get_turf(terrorist))
				terrorist.put_in_hands(terroristsc4)
				terrorist.visible_message(span_fuckingbig("<b>[terrorist]</b> получает бомбу! Помогите ему установить её."),
					span_fuckingbig("Мне досталась бомба. Необходимо установить её в заранее обозначенной точке."))
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

/mob/dead/new_player/proc/violence_choices()
	var/dat = ""
	var/datum/violence_player/VP = vp_get_player(ckey)
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
	usr << browse(dat, "window=violence;size=1050x690")

/client/proc/force_violence_map()
	set category = "Дбг"
	set name = "Violence Map"

	var/list/maplist = list()

	for(var/item in subtypesof(/datum/map_template/violence))
		LAZYADD(maplist, item)

	var/chosen_map = tgui_input_list(usr, "Maps?", "Gay Bitch Industries", maplist)

	if(!chosen_map)
		return

	GLOB.violence_forced_map = chosen_map

	log_admin("[key_name(src)] устанавливает карту [chosen_map] для насилия.")
	message_admins("[key_name_admin(src)] устанавливает карту [chosen_map] для насилия.")

/client/proc/force_violence_mode()
	set category = "Дбг"
	set name = "Violence Mode"

	var/list/modelist = list(VIOLENCE_PLAYMODE_TEAMFIGHT, VIOLENCE_PLAYMODE_BOMBDEF, VIOLENCE_PLAYMODE_TAG)

	var/chosen_mode = tgui_input_list(usr, "Modes?", "Cum Fuck Fuck Fuck Fuck", modelist)

	if(!chosen_mode)
		return

	GLOB.violence_playmode = chosen_mode

	log_admin("[key_name(src)] выбирает режим [chosen_mode] для насилия.")
	message_admins("[key_name_admin(src)] выбирает режим [chosen_mode] для насилия.")

/client/proc/violence_friendlyfire()
	set category = "Дбг"
	set name = "Violence Friendlyfire"

	GLOB.violence_friendlyfire = !GLOB.violence_friendlyfire

	log_admin("[key_name(src)] [GLOB.violence_friendlyfire ? "включает" : "выключает"] огонь по своим для насилия.")
	message_admins("[key_name_admin(src)] [GLOB.violence_friendlyfire ? "включает" : "выключает"] огонь по своим для насилия.")
