/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<table><thead><tr><th class='rhead'>cKey</th><th class='rreg'>Дата регистрации</th><th class='rping'>Пинг</th><th>?</th></tr></thead><tbody>"

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

				var/entry = "<tr><td>"

				if (check_donations(C.ckey))
					entry += "$ "

				entry += "[C.key]"
				if(C.holder && C.holder.fakekey)
					entry += " <i>([C.holder.fakekey])</i>"
				entry += "</td>"
				entry += "<td>[C.account_join_date ? splittext(C.account_join_date, " ")?[1] : "NaN"]</td>"
				entry += "<td>[round(C.avgping, 1)]</td>"
				entry += "<td>"

				if(!C.mob)
					entry += "<i>НЕТ МОБА</i></td></tr>"
					Lines += entry
					continue

				if (isnewplayer(C.mob))
					entry += "<font color='darkgray'><b>Лобби</b></font>"
					lobby++
				else
					entry += "[C.mob.real_name]"
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
									entry += " - <font color='white'><b>МЁРТВ</b></font>"
									dead++
							else
								entry += " - <font color='white'><b>МЁРТВ</b></font>"
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

				entry += " - [ADMIN_QUE_NB(C.mob)]"
				entry += "</td></tr>"
				Lines += entry

		else//If they don't have +ADMIN, only show hidden admins
			for(var/client/C in GLOB.clients)
				if(C.ckey in GLOB.anonists_deb)
					continue
				var/entry = "<tr><td>"
				entry += "[C.key]"
				if(C.holder && C.holder.fakekey)
					entry += " <i>([C.holder.fakekey])</i>"
				entry += "</td>"

				entry += "<td>[C.account_join_date ? splittext(C.account_join_date, " ")?[1] : "NaN"]</td>"
				entry += "<td>[round(C.avgping, 1)]</td>"

				entry += "<td>[C.holder ? C.holder.rank : "Космонавт"]</td></tr>"
				Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(C.ckey in GLOB.anonists_deb)
				continue

			var/ajd = C.account_join_date ? splittext(C.account_join_date, " ")?[1] : "NaN"

			if(C.holder && C.holder.fakekey)
				Lines += "<tr><td>[C.holder.fakekey]</td><td>[ajd]</td><td>[round(C.avgping, 1)]</td><td>Космонавт</td></tr>"
			else if (C.holder)
				Lines += "<tr><td class='admin'>[C.key]</td><td>[ajd]</td><td>[round(C.avgping, 1)]</td><td>[C.holder.rank]</td></tr>"
			else if (C.mentor_datum)
				Lines += "<tr><td class='mentor'>[C.key]</td><td>[ajd]</td><td>[round(C.avgping, 1)]</td><td>Знаток</td></tr>"
			else
				Lines += "<tr><td>[C.key]</td><td>[ajd]</td><td>[round(C.avgping, 1)]</td><td>Космонавт</td></tr>"

	for(var/line in sort_list(Lines))
		msg += "[line]"

	msg += "</tbody></table>"

	if(check_rights(R_ADMIN, 0))
		msg += "<b><font color='green'>Живые: [living]</font></br>Мёртвые: [dead]</br><font color='gray'>Призраки: [observers]</font></br><font color='#006400'>Лобби: [lobby]</font></br><font color='#8100aa'>Антаги: [living_antags]</font></br><font color='#9b0000'>Мёртвые антаги: [dead_antags]</font></b></br>"

	msg += "</br><b>Всего нас [length(Lines)] космонавтов.</b>"

	var/datum/browser/popup = new(src, "adv_who", null, holder ? 600 : 450, 700)
	popup.add_stylesheet("adv_whocss", 'html/adv_who.css')
	popup.set_content(msg)
	popup.open(FALSE)

/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "[round(seconds / 60)] минут, [seconds % 60] секунд"
