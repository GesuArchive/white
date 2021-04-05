/proc/priority_announce(text, title = "", sound = 'sound/ai/announcer/alert.ogg', type, sender_override)
	if(!text)
		return

	var/announcement

	//announcement += "<hr class='veryalert'>"

	if(type == "Priority")
		announcement += "<h1 class='alert'>Срочное Объявление</h1>"
		if (title && length(title) > 0)
			announcement += "<h2 class='alert'>[html_encode(title)]</h2>"
	else if(type == "Captain")
		announcement += "<h1 class='alert'>Капитан Объявляет</h1>"
		GLOB.news_network.SubmitArticle(text, "Капитан Объявляет", "Станционные Объявления", null)

	else
		if(!sender_override)
			announcement += "<h1 class='alert'>[command_name()]</h1>"
		else
			announcement += "<h1 class='alert'>[sender_override]</h1>"
		if (title && length(title) > 0)
			announcement += "<h2 class='alert'>[html_encode(title)]</h2>"

		if(!sender_override)
			if(title == "")
				GLOB.news_network.SubmitArticle(text, "Центральное Командование", "Станционные Объявления", null)
			else
				GLOB.news_network.SubmitArticle(title + "\n" + text, "Центральное Командование", "Станционные Объявления", null)

	announcement += "<span class='alert'><big>[html_encode(text)]</big></span>"
	announcement += "\n\n"

	var/s = sound(sound)
	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear() && (is_station_level(M.z) || is_mining_level(M.z) || is_centcom_level(M.z)))
			to_chat(M, announcement)
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				SEND_SOUND(M, s)

/**
 * Summon the crew for an emergency meeting
 *
 * Teleports the crew to a specified area, and tells everyone (via an announcement) who called the meeting. Should only be used during april fools!
 * Arguments:
 * * user - Mob who called the meeting
 * * button_zone - Area where the meeting was called and where everyone will get teleported to
 */
/proc/call_emergency_meeting(mob/living/user, area/button_zone)
	var/meeting_sound = sound('sound/misc/emergency_meeting.ogg')
	var/announcement
	announcement += "<h1 class='alert'>ТРЕВОГА!</h1>"
	announcement += "<br><span class='alert'>[user] делает экстренный сбор!</span><br><br>"

	for(var/mob/mob_to_teleport in GLOB.player_list) //gotta make sure the whole crew's here!
		if(isnewplayer(mob_to_teleport) || iscameramob(mob_to_teleport))
			continue

		to_chat(mob_to_teleport, announcement)
		SEND_SOUND(mob_to_teleport, meeting_sound) //no preferences here, you must hear the funny sound
		mob_to_teleport.overlay_fullscreen("emergency_meeting", /atom/movable/screen/fullscreen/emergency_meeting, 1)
		addtimer(CALLBACK(mob_to_teleport, /mob/.proc/clear_fullscreen, "emergency_meeting"), 3 SECONDS)

		if (is_station_level(mob_to_teleport.z)) //teleport the mob to the crew meeting
			var/turf/target
			var/list/turf_list = get_area_turfs(button_zone)
			while (!target && turf_list.len)
				target = pick_n_take(turf_list)
				if (isclosedturf(target))
					target = null
					continue
				mob_to_teleport.forceMove(target)

/proc/print_command_report(text = "", title = null, announce=TRUE)
	if(!title)
		title = "Секретно: [command_name()]"

	if(announce)
		priority_announce("Отчет был загружен и распечатан на всех коммуникационных консолях.", "Входящее Секретное Сообщение", 'sound/ai/announcer/alert.ogg')

	var/datum/comm_message/M  = new
	M.title = title
	M.content =  text

	SScommunications.send_message(M)

/proc/minor_announce(message, title = "Внимание!", alert, html_encode = TRUE)
	if(!message)
		return

	if (html_encode)
		title = html_encode(title)
		message = html_encode(message)

	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear() && (is_station_level(M.z) || is_mining_level(M.z) || is_centcom_level(M.z)))
			to_chat(M, "<h1 class='alert'>[title]</h1><span class='alert'><big>[message]</big></span>\n\n")
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				if(alert)
					SEND_SOUND(M, sound('sound/misc/notice1.ogg'))
				else
					SEND_SOUND(M, sound('sound/misc/notice2.ogg'))
