/proc/log_law(text)
	if (CONFIG_GET(flag/log_law))
		WRITE_LOG(GLOB.world_game_log, "LAW: [text]")
