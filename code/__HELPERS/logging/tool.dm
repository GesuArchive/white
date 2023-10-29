/// Logging for tool usage
/proc/log_tool(text, mob/initiator)
	WRITE_LOG(GLOB.world_tool_log, "TOOL: [text]")
