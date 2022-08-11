/proc/log_exrp(text)
	if (CONFIG_GET(flag/log_exrp))
		WRITE_LOG(GLOB.world_exrp_log, "EXRP: [text]")
