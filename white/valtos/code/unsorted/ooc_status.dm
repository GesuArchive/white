/client/verb/roundstatus()
	set name = "Статус раунда"
	set category = null

	var/round_time = world.time - SSticker.round_start_time

	var/list/data_list = list(
		"Карта: [SSmapping.config?.map_name || "Загрузка..."]",
		SSmapping.next_map_config ? "Следующая: [SSmapping.next_map_config.map_name]" : null,
		"ID раунда: [GLOB.round_id ? GLOB.round_id : "NULL"]",
		"Серверное время: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]",
		"Длительность раунда: [round_time > MIDNIGHT_ROLLOVER ? "[round(round_time/MIDNIGHT_ROLLOVER)]:[worldtime2text()]" : worldtime2text()]",
		"Время на станции: [station_time_timestamp()]",
		"Замедление времени: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)"
	)

	var/data_to_send = jointext(data_list, "\n")
	to_chat(src, "<span class='notice'>\n[data_to_send]\n</span>")
