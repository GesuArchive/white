/datum/game_mode/prison
	name = "prison"
	config_tag = "prison"
	report_type = "prison"
	enemy_minimum_age = 0
	maximum_players = 64

	announce_span = "danger"
	announce_text = "Тюрьма. Самая настоящая."

/datum/game_mode/prison/pre_setup()
	// отключаем все лишние джобки и ставим свои
	GLOB.position_categories = list(
		EXP_TYPE_SECURITY = list("jobs" = list("Captain", "Security Officer"), "color" = "#ff4444", "runame" = "Охрана"),
		EXP_TYPE_SCUM = list("jobs" = list("Prisoner"), "color" = "#fa8729", "runame" = "Заключённые")
	)
	GLOB.exp_jobsmap = list(
		EXP_TYPE_SECURITY = list("titles" = list("Captain", "Security Officer")),
		EXP_TYPE_SCUM = list("titles" = list("Prisoner"))
	)
	return TRUE

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
