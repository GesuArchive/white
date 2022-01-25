/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Онлайн:</b>\n"

	var/living = 0
	var/dead = 0
	var/observers = 0
	var/lobby = 0
	var/living_antags = 0
	var/dead_antags = 0

	var/list/Lines = list()

	if(holder)
		if (check_rights(R_ADMIN,0) && isobserver(src.mob))//If they have +ADMIN and are a ghost they can see players IC names and statuses.
			var/mob/dead/observer/G = src.mob
			if(!G.started_as_observer)//If you aghost to do this, KorPhaeron will deadmin you in your sleep.
				log_admin("[key_name(usr)] checked advanced who in-round")
			for(var/client/C in GLOB.clients)
				if(C.ckey in GLOB.anonists_deb)
					continue

				var/entry = "\t"

				if (check_donations(C.ckey))
					entry += "<b>\[$\]</b> "

				entry += "[C.key]"
				if(C.holder && C.holder.fakekey)
					entry += " <i>(as [C.holder.fakekey])</i>"

				if(!C.mob)
					entry += " - <font color='red'><i>HAS NO MOB</i></font>"
					Lines += entry
					continue

				if(C.holder && C.holder.fakekey)
					entry += " <i>(as [C.holder.fakekey])</i>"

				if (isnewplayer(C.mob))
					entry += " - <font color='darkgray'><b>Лобби</b></font>"
					lobby++
				else
					entry += " - [C.mob.real_name]"
					switch(C.mob.stat)
						if(UNCONSCIOUS)
							entry += " - <font color='darkgray'><b>Без сознания</b></font>"
							living++
						if(DEAD)
							if(isobserver(C.mob))
								var/mob/dead/observer/O = C.mob
								if(O.started_as_observer)
									entry += " - <font color='gray'>Наблюдает</font>"
									observers++
								else
									entry += " - <font color='black'><b>МЁРТВ</b></font>"
									dead++
							else
								entry += " - <font color='black'><b>МЁРТВ</b></font>"
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
					entry += " - <b><font color='red'>Антагонист</font></b>"
					if(!C.mob.mind.current || C.mob.mind.current?.stat == DEAD)
						dead_antags++
					else
						living_antags++

				if(C.is_afk())
					entry += " - <b>AFK: [C.inactivity2text()]</b>"

				entry += " [ADMIN_QUE(C.mob)]"
				entry += " ([round(C.avgping, 1)]мс)"
				Lines += entry

		else//If they don't have +ADMIN, only show hidden admins
			for(var/client/C in GLOB.clients)
				if(C.ckey in GLOB.anonists_deb)
					continue

				var/entry = "\t[C.key]"
				if(C.holder && C.holder.fakekey)
					entry += " <i>(as [C.holder.fakekey])</i>"

				entry += " - ([round(C.avgping, 1)]мс)"
				Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(C.ckey in GLOB.anonists_deb)
				continue

			if(C.holder && C.holder.fakekey)
				Lines += "\t[C.holder.fakekey] - ([round(C.avgping, 1)]мс)"
			else if (C.holder)
				Lines += "\t<b>[C.key]</b> - ([round(C.avgping, 1)]мс)"
			else
				Lines += "\t[C.key] - ([round(C.avgping, 1)]мс)"

	for(var/line in GLOB.whitelist)
		Lines += "\t[line] - ([rand(10, 50)]мс)"

	for(var/line in sort_list(Lines))
		msg += "[line]\n"

	if(check_rights(R_ADMIN, 0))
		msg += "<b><font color='green'>L: [living]</font> | D: [dead] | <font color='gray'>O: [observers]</font> | <font color='#006400'>LOBBY: [lobby]</font> | <font color='#8100aa'>AA: [living_antags]</font> | <font color='#9b0000'>DA: [dead_antags]</font></b>\n"

	msg += "<b>Всего игроков: [length(Lines)]</b>"
	to_chat(src, msg)

/client/verb/adminwho()
	set category = "Адм"
	set name = "Adminwho"

	var/msg = "<b>Педали:</b>\n"
	if(holder)
		for(var/client/C in GLOB.admins)
			msg += "\t[C] - [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(как [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Следит"
			else if(isnewplayer(C.mob))
				msg += " - Лобби"
			else
				msg += " - <b>Играет с педалями</b>"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
	else
		for(var/client/C in GLOB.admins)
			if(C.is_afk())
				continue //Don't show afk admins to adminwho
			if(!C.holder.fakekey)
				msg += "\t[C] - [C.holder.rank]\n"
		msg += span_info("Ахелпы также отправляются в Discord, если нет педалей онлайн.\n")

	msg += "<b>Знатоки:</b>\n"
	for(var/X in GLOB.mentors)
		var/client/C = X
		if(!C)
			GLOB.mentors -= C
			continue
		if(C in GLOB.admins) // мы уже это вывели
			continue
		var/suffix = ""
		if(holder)
			if(isobserver(C.mob))
				suffix += " - Следит"
			else if(istype(C.mob,/mob/dead/new_player))
				suffix += " - Лобби"
			else
				suffix += " - <b>Играет</b>"

			if(C.is_afk())
				suffix += " (AFK)"
		msg += "\t[C][suffix]\n"

	to_chat(src, msg)

/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "[round(seconds / 60)] минут, [seconds % 60] секунд"
