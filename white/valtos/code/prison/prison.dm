/datum/game_mode/prison
	name = "prison"
	config_tag = "prison"
	report_type = "prison"
	enemy_minimum_age = 0
	maximum_players = 64

	var/mob/living/spawned_captain = null
	var/is_really_dead_counter = 0

	announce_span = "danger"
	announce_text = "Тюрьма. Самая настоящая."

/datum/game_mode/prison/pre_setup()
	// отключаем все лишние джобки и ставим свои
	GLOB.position_categories = list(
		EXP_TYPE_SECURITY = list("jobs" = list(JOB_CAPTAIN, JOB_SECURITY_OFFICER), "color" = "#ff4444", "runame" = "Охрана"),
		EXP_TYPE_SCUM = list("jobs" = list(JOB_PRISONER), "color" = "#fa8729", "runame" = "Заключённые")
	)
	GLOB.exp_jobsmap = list(
		EXP_TYPE_SECURITY = list("titles" = list(JOB_CAPTAIN, JOB_SECURITY_OFFICER)),
		EXP_TYPE_SCUM = list("titles" = list(JOB_PRISONER))
	)
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/make_prisoner_suffer)
	return TRUE

/datum/game_mode/prison/proc/make_prisoner_suffer(datum/source, datum/job/job, mob/living/living_mob, client/player_client)
	SIGNAL_HANDLER

	if(job.title == JOB_PRISONER)
		living_mob.set_nutrition(NUTRITION_LEVEL_HUNGRY)
		living_mob.hydration = HYDRATION_LEVEL_THIRSTY
		ADD_TRAIT(living_mob, TRAIT_PACIFISM, "grace_period")
		spawn(5 MINUTES)
			if(living_mob)
				REMOVE_TRAIT(living_mob, TRAIT_PACIFISM, "grace_period")

		to_chat(living_mob, span_userdanger("За недавно совершённый бунт нас оставили здесь на сутки без еды и воды."))

	if(job.title == JOB_SECURITY_OFFICER)
		var/datum/martial_art/cqc/glinomes = new
		glinomes.teach(living_mob)

		to_chat(living_mob, span_info("После недавнего бунта нас научили более понятному языку жестов. Так как данный проект полностью засекречен, <i>случайные</i> трупы заключённых необходимо хранить в морге."))

	if(job.title == JOB_CAPTAIN)
		spawned_captain = living_mob
		to_chat(living_mob, span_info("Необходимо обеспечить автономную работу аванпоста. Используйте труд выделенных вам заключённых для достижения этой цели."))
		to_chat(living_mob, span_userdanger("Если я погибну, то со мной погибнет и весь аванпост."))

/datum/game_mode/prison/process()
	if(spawned_captain)
		// примерно 2 минуты на откачку
		if(is_really_dead_counter >= 60)
			is_really_dead_counter = -900
			priority_announce("Судя по нашим датчикам, капитан вашего аванпоста погиб. Ожидайте минуту до внесения корректировок и желательно не двигайтесь.", "Экстренное сообщение")
			spawn(1 MINUTES)
				for(var/mob/living/carbon/human/H in GLOB.joined_player_list)
					var/turf/T = get_turf(H)
					if(is_station_level(T.z))
						inc_metabalance(H, -10, reason="Капитан погиб. Нам всем конец!")
						spawn(1 SECONDS)
							explosion(H, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 3)
			return
		if(spawned_captain.stat == DEAD)
			is_really_dead_counter++
		else
			is_really_dead_counter = 0

/datum/game_mode/prison/can_start()
	// отменяем готовность у всех игроков, чтобы их случайно не закинуло в нуллспейс
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	return TRUE

/datum/game_mode/prison/generate_report()
	return "В вашем секторе был открыт новый тюремный аванпост. Приятной смены!"

/datum/game_mode/prison/send_intercept(report = 0)
	return
