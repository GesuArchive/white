/proc/log_mentor(text)
	GLOB.mentor_log.Add(text)
	WRITE_FILE(GLOB.world_game_log, "ZNATOK: [text]")
