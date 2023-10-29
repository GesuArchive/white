/// Logging for shuttle actions
/proc/log_shuttle(text)
	if (CONFIG_GET(flag/log_shuttle))
		WRITE_LOG(GLOB.world_shuttle_log, "SHUTTLE: [text]")

/proc/log_shuttle_movement(text)
	if (CONFIG_GET(flag/log_shuttle))
		WRITE_LOG(GLOB.world_shuttle_log, "SHUTTLE MOVEMENT: [text]")

/proc/log_shuttle_attack(text)
	if (CONFIG_GET(flag/log_shuttle))
		WRITE_LOG(GLOB.world_shuttle_log, "SHUTTLE ATTACK: [text]")
