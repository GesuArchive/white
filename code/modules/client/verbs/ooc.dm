GLOBAL_VAR_INIT(OOC_COLOR, null)//If this is null, use the CSS for OOC. Otherwise, use a custom colour.
GLOBAL_VAR_INIT(normal_ooc_colour, "#002eb8")
GLOBAL_LIST_INIT(retard_words, list("подливит" = "МЕНЯ В ЗАД ЕБУТ", "оникс" = "говно", "опух" = "говнище", "валтос" = "мяу"))
GLOBAL_LIST_INIT(alko_list, list("zarri", "maxsc", "nfogmann", "unitazik", "sranklin"))
//GLOBAL_LIST_INIT(boosty_subs, list("nikitauou", "aldodonkar", "trora", "roundead", "valtosss"))

/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("ОЙ."))
		return

	if(!mob)
		return

	if(!holder)
		if(!GLOB.ooc_allowed)
			to_chat(src, span_danger("OOC выключен. Приятной игры."))
			return
		if(!GLOB.dooc_allowed && (mob.stat == DEAD) && !isnewplayer(mob))
			to_chat(usr, span_danger("OOC трупам не разрешён. Приятной игры."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("Тебе нельзя. Приятной игры."))
			return
		if(is_banned_from(ckey, "OOC"))
			to_chat(src, span_danger("Не-а."))
			return

	if(QDELETED(src))
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)

	var/raw_msg = msg

	if(!msg)
		return

	for(var/word in GLOB.retard_words)
		msg = replacetext_char(msg, word, GLOB.retard_words[word])

	msg = emoji_parse(msg)

	if(ckey in GLOB.alko_list)
		msg = slur(msg)


	if(SSticker.HasRoundStarted() && (msg[1] in list(".",";",":","#") || findtext_char(msg, "Сказать", 1, 5)))
		if(tgui_alert(usr, "Похоже \"[raw_msg]\" выглядит как внутриигровое сообщение, написать его в OOC?", "Для OOC?", list("Да", "Нет")) != "Да")
			return

	if(!holder)
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Привет, ты что, охуел?</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			qdel(src)
			return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("Тебе нельзя."))
		return

	//lobby ooc
	var/tagmsg = "bepis"
	if(isnewplayer(mob))
		tagmsg = "LOBBY"
		mob.log_talk(raw_msg, LOG_LOBBY)
	else
		tagmsg = "OOC"
		mob.log_talk(raw_msg, LOG_OOC)

	var/keyname = key
	if(prefs.hearted)
		var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/chat)
		keyname = "[sheet.icon_tag("emoji-heart")][keyname]"
	if(prefs.unlock_content)
		if(prefs.toggles & MEMBER_PUBLIC)
			keyname = "<font color='[prefs.ooccolor ? prefs.ooccolor : GLOB.normal_ooc_colour]'>[icon2html('icons/member_content.dmi', world, "blag")][keyname]</font>"
	//The linkify span classes and linkify=TRUE below make ooc text get clickable chat href links if you pass in something resembling a url
	for(var/client/C in GLOB.clients)
		if(isnewplayer(mob) && !isnewplayer(C.mob))
			if(!C.holder)
				continue
		if(C.prefs.chat_toggles & CHAT_OOC)
			if(holder?.fakekey in C.prefs.ignoring)
				continue
			if(holder)
				if(!holder.fakekey || C.holder)
					if(check_rights_for(src, R_ADMIN))
						to_chat(C, "<span class='adminooc'>[CONFIG_GET(flag/allow_admin_ooccolor) && prefs.ooccolor ? "<font color=[prefs.ooccolor]>" :"" ]<span class='prefix'>[tagmsg]</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]</span></span></font>")
					else
						to_chat(C, span_adminobserverooc(span_prefix("[tagmsg]</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]")))
				else
					if(GLOB.OOC_COLOR)
						to_chat(C, span_ooc("<font color='[GLOB.OOC_COLOR]'><b><span class='prefix'>[tagmsg]</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]</span></b></font>"))
					else
						to_chat(C, span_ooc(span_prefix("[tagmsg]</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]")))

			else if(!(key in C.prefs.ignoring))
				if(check_donations(ckey) >= 100)
					to_chat(C, span_ooc("<font color='[prefs.ooccolor ? prefs.ooccolor : GLOB.normal_ooc_colour]'><b><span class='prefix'>[tagmsg]</span> <EM>[random_emoji()] [keyname]:</EM> <span class='message linkify'>[msg]</span></b></font>"))
				else if(GLOB.OOC_COLOR)
					to_chat(C, span_ooc("<font color='[GLOB.OOC_COLOR]'><b><span class='prefix'>[tagmsg]</span> <EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></b></font>"))
				else
					to_chat(C, span_ooc(span_prefix("[tagmsg]</span> <EM>[keyname]:</EM> <span class='message linkify'>[msg]")))
	if(isnewplayer(mob))
		webhook_send_lobby(key, raw_msg)
	else
		webhook_send_ooc(key, raw_msg)

/proc/toggle_ooc(toggle = null)
	if(toggle != null) //if we're specifically en/disabling ooc
		if(toggle != GLOB.ooc_allowed)
			GLOB.ooc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.ooc_allowed = !GLOB.ooc_allowed
	to_chat(world, "<B>Чат ООС был глобально [GLOB.ooc_allowed ? "включен" : "отключен"]!</B>")

/proc/toggle_dooc(toggle = null)
	if(toggle != null)
		if(toggle != GLOB.dooc_allowed)
			GLOB.dooc_allowed = toggle
		else
			return
	else
		GLOB.dooc_allowed = !GLOB.dooc_allowed


/client/proc/set_ooc()
	set name = "Set Player OOC Color"
	set desc = "Modifies player OOC Color"
	set category = "Срв"
	if(IsAdminAdvancedProcCall())
		return
	var/newColor = input(src, "Please select the new player OOC color.", "OOC color") as color|null
	if(isnull(newColor))
		return
	if(!check_rights(R_FUN))
		message_admins("[usr.key] has attempted to use the Set Player OOC Color verb!")
		log_admin("[key_name(usr)] tried to set player ooc color without authorization.")
		return
	var/new_color = sanitize_ooccolor(newColor)
	message_admins("[key_name_admin(usr)] has set the players' ooc color to [new_color].")
	log_admin("[key_name_admin(usr)] has set the player ooc color to [new_color].")
	GLOB.OOC_COLOR = new_color


/client/proc/reset_ooc()
	set name = "❌ Reset Player OOC Color"
	set desc = "Returns player OOC Color to default"
	set category = "Срв"
	if(IsAdminAdvancedProcCall())
		return
	if(tgui_alert(usr, "Are you sure you want to reset the OOC color of all players?", "Reset Player OOC Color", list("Yes", "No")) != "Yes")
		return
	if(!check_rights(R_FUN))
		message_admins("[usr.key] has attempted to use the Reset Player OOC Color verb!")
		log_admin("[key_name(usr)] tried to reset player ooc color without authorization.")
		return
	message_admins("[key_name_admin(usr)] has reset the players' ooc color.")
	log_admin("[key_name_admin(usr)] has reset player ooc color.")
	GLOB.OOC_COLOR = null


/client/verb/colorooc()
	set name = "Свой цвет OOC"
	set category = null

	if(!holder || !check_rights_for(src, R_ADMIN))
		if(!check_donations(ckey) >= 100)
			if(!is_content_unlocked())
				return

	var/new_ooccolor = input(src, "Выбирай цвет OOC. Учитывай тёмную и светлую темы.", "Цвет OOC", prefs.ooccolor) as color|null
	if(isnull(new_ooccolor))
		return
	new_ooccolor = sanitize_ooccolor(new_ooccolor)
	prefs.ooccolor = new_ooccolor
	prefs.save_preferences()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set OOC Color") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/resetcolorooc()
	set name = "❌ Сбросить свой цвет OOC"
	set desc = "Returns your OOC Color to default"
	set category = null

	if(!holder || !check_rights_for(src, R_ADMIN))
		if(!check_donations(ckey) >= 100)
			if(!is_content_unlocked())
				return

		prefs.ooccolor = initial(prefs.ooccolor)
		prefs.save_preferences()

//Checks admin notice
/client/verb/admin_notice()
	set name = "📘 Заметки раунда"
	set category = null
	set desc ="Check the admin notice if it has been set"

	if(GLOB.admin_notice)
		to_chat(src, "<span class='boldnotice'>Заметка:</span>\n \t [GLOB.admin_notice]")
	else
		to_chat(src, span_notice("Нет ничего особенного на этот раунд."))

/client/verb/motd()
	set name = "📘 Приветствие"
	set category = "OOC"
	set desc ="Check the Message of the Day"

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>")
	else
		to_chat(src, span_notice("The Message of the Day has not been set."))

/client/proc/self_notes()
	set name = "📘 Просмотреть чем я отличился"
	set category = "OOC"
	set desc = "View the notes that admins have written about you"

	if(!CONFIG_GET(flag/see_own_notes))
		to_chat(usr, span_notice("Sorry, that function is not enabled on this server."))
		return

	browse_messages(null, usr.ckey, null, TRUE)

/client/proc/self_playtime()
	set name = "📘 Моё время игры"
	set category = "OOC"
	set desc = "View the amount of playtime for roles the server has tracked."

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, span_notice("Sorry, tracking is currently disabled."))
		return

	new /datum/job_report_menu(src, usr)

// Ignore verb
/client/verb/select_ignore()
	set name = "❌ Игнорировать"
	set category = "OOC"
	set desc ="Ignore a player's messages on the OOC channel"

	// Make a list to choose players from
	var/list/players = list()

	// Use keys and fakekeys for the same purpose
	var/displayed_key = ""

	// Try to add every player who's online to the list
	for(var/client/C in GLOB.clients)
		// Don't add ourself
		if(C == src)
			continue

		// Don't add players we've already ignored if they're not using a fakekey
		if((C.key in prefs.ignoring) && !C.holder?.fakekey)
			continue

		// Don't add players using a fakekey we've already ignored
		if(C.holder?.fakekey in prefs.ignoring)
			continue

		// Use the player's fakekey if they're using one
		if(C.holder?.fakekey)
			displayed_key = C.holder.fakekey

		// Use the player's key if they're not using a fakekey
		else
			displayed_key = C.key

		// Check if both we and the player are ghosts and they're not using a fakekey
		if(isobserver(mob) && isobserver(C.mob) && !C.holder?.fakekey)
			// Show us if the player is a ghost or not after their displayed key
			// Add the player's displayed key to the list
			players["[displayed_key](ghost)"] = displayed_key

		// Add the player's displayed key to the list if we or the player aren't a ghost or they're using a fakekey
		else
			players[displayed_key] = displayed_key

	// Check if the list is empty
	if(!players.len)
		// Express that there are no players we can ignore in chat
		to_chat(src, "There are no other players you can ignore!")

		// Stop running
		return

	// Sort the list
	players = sort_list(players)

	// Request the player to ignore
	var/selection = tgui_input_list(usr, "Please, select a player!", "Ignore", players)

	// Stop running if we didn't receieve a valid selection
	if(!selection || !(selection in players))
		return

	// Store the selected player
	selection = players[selection]

	// Check if the selected player is on our ignore list
	if(selection in prefs.ignoring)
		// Express that the selected player is already on our ignore list in chat
		to_chat(src, "You are already ignoring [selection]!")

		// Stop running
		return

	// Add the selected player to our ignore list
	prefs.ignoring.Add(selection)

	// Save our preferences
	prefs.save_preferences()

	// Express that we've ignored the selected player in chat
	to_chat(src, "You are now ignoring [selection] on the OOC channel.")

// Unignore verb
/client/verb/select_unignore()
	set name = "❌ Не игнорировать"
	set category = "OOC"
	set desc = "Stop ignoring a player's messages on the OOC channel"

	// Check if we've ignored any players
	if(!prefs.ignoring.len)
		// Express that we haven't ignored any players in chat
		to_chat(src, "You haven't ignored any players!")

		// Stop running
		return

	// Request the player to unignore
	var/selection = tgui_input_list(usr, "Please, select a player!", "Unignore", prefs.ignoring)

	// Stop running if we didn't receive a selection
	if(!selection)
		return

	// Check if the selected player is not on our ignore list
	if(!(selection in prefs.ignoring))
		// Express that the selected player is not on our ignore list in chat
		to_chat(src, "You are not ignoring [selection]!")

		// Stop running
		return

	// Remove the selected player from our ignore list
	prefs.ignoring.Remove(selection)

	// Save our preferences
	prefs.save_preferences()

	// Express that we've unignored the selected player in chat
	to_chat(src, "You are no longer ignoring [selection] on the OOC channel.")

/client/proc/show_previous_roundend_report()
	set name = "📘 Мой последний раунд"
	set category = "OOC"
	set desc = "View the last round end report you've seen"

	SSticker.show_roundend_report(src, report_type = PERSONAL_LAST_ROUND)

/client/proc/show_servers_last_roundend_report()
	set name = "📘 Последний раунд сервера"
	set category = "OOC"
	set desc = "View the last round end report from this server"

	SSticker.show_roundend_report(src, report_type = SERVER_LAST_ROUND)

/client/verb/fit_viewport()
	set name = "ПОЧИНИТЬ ЭКРАН"
	set category = "Особенное"
	set desc = "Fit the width of the map window to match the viewport"

	var/shown_bars = NEOHUD_RIGHT

	if(ishuman(mob))
		shown_bars = NEOHUD_RIGHT|NEOHUD_BOTTOM

	if(isnewplayer(mob) || prefs?.retro_hud)
		shown_bars = null

	if(isovermind(mob))
		shown_bars = NEOHUD_RIGHT

	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/view_width = view_size[1] + ((shown_bars & NEOHUD_RIGHT) ? 1 : 0)
	var/view_height = view_size[2] + ((shown_bars & NEOHUD_BOTTOM) ? 1 : 0)
	var/aspect_ratio = view_width / view_height

	// Calculate desired pixel width using window size and aspect ratio
	var/list/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))

	// Client closed the window? Some other error? This is unexpected behaviour, let's
	// CRASH with some info.
	if(!sizes["mapwindow.size"])
		CRASH("sizes does not contain mapwindow.size key. This means a winget failed to return what we wanted. --- sizes var: [sizes] --- sizes length: [length(sizes)]")

	var/list/map_size = splittext(sizes["mapwindow.size"], "x")

	// Gets the type of zoom we're currently using from our view datum
	// If it's 0 we do our pixel calculations based off the size of the mapwindow
	// If it's not, we already know how big we want our window to be, since zoom is the exact pixel ratio of the map
	var/zoom_value = src.view_size?.zoom || 0

	var/desired_width = 0
	if(zoom_value)
		desired_width = round(view_width * zoom_value * world.icon_size)
	else
		// Looks like we expect mapwindow.size to be "ixj" where i and j are numbers.
		// If we don't get our expected 2 outputs, let's give some useful error info.
		if(length(map_size) != 2)
			CRASH("map_size of incorrect length --- map_size var: [map_size] --- map_size length: [length(map_size)]")
		var/height = text2num(map_size[2])
		desired_width = round(height * aspect_ratio)

	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Avoid auto-resizing the statpanel and chat into nothing.
	desired_width = min(desired_width, split_width - 300)

	// Calculate and apply a best estimate
	// +8 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	if(prefs.w_toggles & SCREEN_HORIZ_INV)
		winset(src, "mainwindow.split", "splitter=[-pct + 100]")
	else
		winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			set_hud_bar_visible(shown_bars)
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		if(prefs.w_toggles & SCREEN_HORIZ_INV)
			winset(src, "mainwindow.split", "splitter=[-pct + 100]")
		else
			winset(src, "mainwindow.split", "splitter=[pct]")

	set_hud_bar_visible(shown_bars)

/// Attempt to automatically fit the viewport, assuming the user wants it
/client/proc/attempt_auto_fit_viewport()
	if (!prefs.auto_fit_viewport && prefs.retro_hud)
		return
	if(fully_created)
		INVOKE_ASYNC(src, .verb/fit_viewport)
	else //Delayed to avoid wingets from Login calls.
		spawn(1 SECONDS) // this is because timer SS is not ticking during init, ПИДОРАС
			INVOKE_ASYNC(src, .verb/fit_viewport)

/client/verb/policy()
	set name = "📘 Показать политику"
	set desc = "Show special server rules related to your current character."
	set category = null

	//Collect keywords
	var/list/keywords = mob.get_policy_keywords()
	var/header = get_policy(POLICY_VERB_HEADER)
	var/list/policytext = list(header,"<meta http-equiv='Content-Type' content='text/html; charset=utf-8'><hr>")
	var/anything = FALSE
	for(var/keyword in keywords)
		var/p = get_policy(keyword)
		if(p)
			policytext += p
			policytext += "<hr>"
			anything = TRUE
	if(!anything)
		policytext += "Нет особых правил."

	usr << browse(policytext.Join(""),"window=policy")

/client/verb/fix_stat_panel()
	set name = "Починить ЭТУ панель"
	set hidden = TRUE

	init_verbs()
