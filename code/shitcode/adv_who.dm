/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	var/living = 0
	var/dead = 0
	var/observers = 0
	var/lobby = 0
	var/living_antags = 0
	var/dead_antags = 0

	if(check_rights(R_ADMIN,0))//If they have +ADMIN and are a ghost they can see players IC names and statuses.
		if(isobserver(src.mob))
			var/mob/dead/observer/G = src.mob
			if(!G.started_as_observer)//If you aghost to do this, KorPhaeron will deadmin you in your sleep.
				log_admin("[key_name(usr)] checked advanced who in-round")
		for(var/client/C in GLOB.clients)
			if(C.ckey in GLOB.anonists && !(ckey in GLOB.anonists))
				continue

			var/entry = "\t[C.key]"
			if(!C.mob)
				entry += " - <font color='red'><i>HAS NO MOB</i></font>"
				Lines += entry
				continue

			if(isobserver(C.mob))
				entry += " - <font color='gray'><b>Наблюдает</b></font> as <b>[C.mob.real_name]</b>"
			else if(isliving(C.mob))
				entry += " - <font color='green'><b>Играет</b></font> as <b>[C.mob.real_name]</b>"

			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='#404040'><b>Без сознания</b></font>"
					living++
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							observers++
						else
							entry += " - <b>МЕРТВ</b>"
							dead++
					else if(isnewplayer(C.mob))
						entry += " - <font color='#006400'><b>В лобби</b></font>"
						lobby++
					else
						entry += " - <b>МЕРТВ</b>"
						dead++
				else
					living++

			if(isnum(C.player_age))
				var/age = C.player_age
				if(age <= 1)
					age = "<font color='#ff0000'><b>[age]</b></font>"
				else if(age < 10)
					age = "<font color='#ff8c00'><b>[age]</b></font>"
				entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Анатгонист</font></b>"
				if(!C.mob.mind.current || C.mob.mind.current?.stat == DEAD)
					dead_antags++
				else
					living_antags++

			if(C.is_afk())
				entry += " - <b>AFK: [C.inactivity2text()]</b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(C.ckey in GLOB.anonists && !(ckey in GLOB.anonists))
				continue

			if(TRUE)	// !C.is_stealthed()
				var/entry = "[C.key]"
				switch(C.mob.stat)
					if(DEAD)
						if(isobserver(C.mob))
							var/mob/dead/observer/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='gray'><b>Наюблюдает</b></font>"
							else
								entry += " - <font color='green'><b>Играет</b></font>"
						else if(isnewplayer(C.mob))
							entry += " - <font color='#006400'><b>В лобби</b></font>"
					else
						entry += " - <font color='green'><b>Играет</b></font>"

				if(C.is_afk())
					entry += " - <b>AFK: [C.inactivity2text()]</b>"

				Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	if(check_rights(R_ADMIN, 0))
		msg += "<b><font color='green'>Всего живо: [living]</font> | Всего мертво: [dead] | <font color='gray'>Наблюдают: [observers]</font> | <font color='#006400'>В лобби: [lobby]</font> | <font color='#8100aa'>Живых антагов: [living_antags]</font> | <font color='#9b0000'>Мертвых антагов: [dead_antags]</font></b>\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src, msg)

/client/proc/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/msg = "<b>Current Admins:</b>\n"
	if(holder)
		for(var/client/C in GLOB.admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(isnewplayer(C.mob))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
	else
		for(var/client/C in GLOB.admins)
			if(C.is_afk())
				continue //Don't show afk admins to adminwho
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]\n"
		msg += "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game adminhelp anyways and an admin on IRC will see it and respond.</span>"
	to_chat(src, msg)

/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "[round(seconds / 60)] minute\s, [seconds % 60] second\s"