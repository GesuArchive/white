/datum/game_mode/rust
	name = "rust"
	config_tag = "rust"
	report_type = "rust"
	enemy_minimum_age = 0
	maximum_players = 128

	announce_span = "danger"
	announce_text = "Выживи или умри!"

/datum/game_mode/rust/pre_setup()
	SSrust_mode.can_fire = TRUE
	SSrust_mode.fire()
	SSrust_mode.active = TRUE
	SSrust_mode.setup_everything()
	return TRUE

/datum/game_mode/rust/can_start()
	// отменяем готовность у всех игроков, чтобы их случайно не закинуло в нуллспейс
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	return TRUE

/datum/game_mode/rust/generate_report()
	return "Толпа безумных дикарей засела на одной из планет в вашем секторе. Приятной смены!"

/datum/game_mode/rust/send_intercept(report = 0)
	return
