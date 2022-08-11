/proc/log_cloning(text, mob/initiator)
	if(CONFIG_GET(flag/log_cloning))
		WRITE_LOG(GLOB.world_cloning_log, "CLONING: [text]")
