/client/verb/update_ping(time as num)
	set instant = TRUE
	set name = ".update_ping"
	var/ping = (pingfromtime(time)/4) //MASTERMIND
	lastping = ping
	if (!avgping)
		avgping = ping
	else
		avgping = MC_AVERAGE_SLOW(avgping, ping)

/client/proc/pingfromtime(time)
	return ((world.time+world.tick_lag*TICK_USAGE_REAL/100)-time)*100

/client/verb/display_ping(time as num)
	set instant = TRUE
	set name = ".display_ping"
	to_chat(src, span_notice("Время отклика [round(pingfromtime(time)/4, 1)]мс."))

/client/verb/ping()
	set name = "Пинг"
	set category = "OOC"
	winset(src, null, "command=.display_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")
