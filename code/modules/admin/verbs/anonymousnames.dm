/client/proc/anon_names()
	set category = "Адм.События"
	set name = "Setup Anonymous Names"


	if(SSticker.current_state > GAME_STATE_PREGAME)
		to_chat(usr, "This option is currently only usable during pregame.")
		return

	if(SSticker.anonymousnames)
		/*
		SSticker.anonymousnames = ANON_DISABLED
		to_chat(usr, "Disabled anonymous names.")
		message_admins(span_adminnotice("[key_name_admin(usr)] has disabled anonymous names.") )
		*/
		var/response = tgui_alert(usr, "Anon mode is currently enabled. Disable?", "cold feet", list("Disable Anon Names", "Keep it Enabled"))
		if(response != "Disable Anon Names")
			return
		QDEL_NULL(SSticker.anonymousnames)
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has disabled anonymous names.</span>")
		if(SSticker.current_state < GAME_STATE_PREGAME)
			return
		priority_announce("Names and Identities have been restored.", "Identity Restoration", SSstation.announcer.get_rand_alert_sound())
		for(var/mob/living/player in GLOB.player_list)
			if(!player.mind || (!ishuman(player) && !issilicon(player)) || !SSjob.GetJob(player.mind.assigned_role))
				continue
			var/old_name = player.real_name //before restoration
			if(issilicon(player))
				var/is_AI = isAI(player)
				player.apply_pref_name("[is_AI ? "ai" : "cyborg"]", player.client)
			else
				player.client.prefs.copy_to(player, antagonist = (LAZYLEN(player.mind.antag_datums) > 0), is_latejoiner = FALSE)
				player.fully_replace_character_name(old_name, player.real_name) //this changes IDs and PDAs and whatnot
		return
	var/list/names = list("Cancel", ANON_RANDOMNAMES, ANON_EMPLOYEENAMES)
	var/result = input(usr, "Choose an anonymous theme","going dark") as null|anything in names
	if(!usr || !result || result == "Cancel")
		return
	/*
	if(SSticker.current_state > GAME_STATE_PREGAME)
		to_chat(usr, "You took too long! The game has started.")
		return
	*/
	result = input_list[result]
	var/alert_players = "No"
	if(SSticker.current_state > GAME_STATE_PREGAME) //before anonnames is done, for asking a sleep
		alert_players = tgui_alert(usr, "Alert crew? These are IC Themed FROM centcom.", "2016 admins didn't miss roundstart", list("Yes", "No"))
	SSticker.anonymousnames = new result()
	if(alert_players == "Yes")
		priority_announce(SSticker.anonymousnames.announcement_alert, "Identity Loss", SSstation.announcer.get_rand_alert_sound())
	anonymous_all_players()

	message_admins("<span class='adminnotice'>[key_name_admin(usr)] has enabled anonymous names. THEME: [SSticker.anonymousnames].</span>")

/**
 * anonymous_all_players: sets all crewmembers on station anonymous.
 *
 * why is this a proc instead of just part of above? events use this as well.
 */
/proc/anonymous_all_players()
	var/datum/anonymous_theme/theme = SSticker.anonymousnames
	for(var/mob/living/player in GLOB.player_list)
		if(!player.mind || (!ishuman(player) && !issilicon(player)) || !SSjob.GetJob(player.mind.assigned_role))
			continue
		if(issilicon(player))
			player.fully_replace_character_name(player.real_name, theme.anonymous_ai_name(isAI(player)))
		else
			var/original_name = player.real_name //id will not be changed if you do not do this
			randomize_human(player) //do this first so the special name can be given
			player.fully_replace_character_name(original_name, theme.anonymous_name(player))

	SSticker.anonymousnames = result
	to_chat(usr, "Enabled anonymous names. THEME: [SSticker.anonymousnames].")
	message_admins(span_adminnotice("[key_name_admin(usr)] has enabled anonymous names. THEME: [SSticker.anonymousnames].") )

/**
 * anonymous_name: generates a corporate random name. used in admin event tool anonymous names
 *
 * first letter is always a letter
 * Example name = "Employee Q5460Z"
 * Arguments:
 * * M - mob for preferences and gender
 */
/proc/anonymous_name(mob/M)
	switch(SSticker.anonymousnames)
		if(ANON_RANDOMNAMES)
			return M.client.prefs.pref_species.random_name(M.gender,1)
		if(ANON_EMPLOYEENAMES)
			var/name = "Employee "

			for(var/i in 1 to 6)
				if(prob(30) || i == 1)
					name += ascii2text(rand(65, 90)) //A - Z
				else
					name += ascii2text(rand(48, 57)) //0 - 9
			return name

/**
 * anonymous_ai_name: generates a corporate random name (but for sillycones). used in admin event tool anonymous names
 *
 * first letter is always a letter
 * Example name = "Employee Assistant Assuming Delta"
 * Arguments:
 * * is_ai - boolean to decide whether the name has "Core" (AI) or "Assistant" (Cyborg)
 */
/proc/anonymous_ai_name(is_ai = FALSE)
	switch(SSticker.anonymousnames)
		if(ANON_RANDOMNAMES)
			return pick(GLOB.ai_names)
		if(ANON_EMPLOYEENAMES)
			var/verbs = capitalize(pick(GLOB.ing_verbs))
			var/phonetic = pick(GLOB.phonetic_alphabet)

			return "Employee [is_ai ? "Core" : "Assistant"] [verbs] [phonetic]"
