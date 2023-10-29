/proc/log_mechcomp(text)
	if (CONFIG_GET(flag/log_mechcomp))
		WRITE_LOG(GLOB.world_mechcomp_log, "MECHCOMP: [text]")
