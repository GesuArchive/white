/// The defines for the appropriate config files
#define WHITE_MENTOR_CONFIG_FILE "[global.config.directory]/mentors.txt"
#define WHITE_EXRP_CONFIG_FILE "[global.config.directory]/whitelist_exrp.txt"
#define WHITE_SOUP_CONFIG_FILE "[global.config.directory]/whitelist_soup.txt"

/// The list of the available special player ranks
#define WHITE_PLAYER_RANKS list("Mentor", "EXRP", "SOUP")

/client/proc/manage_player_ranks()
	set category = "Особенное"
	set name = "Manage Player Ranks"
	set desc = "Manage who has the special player ranks while the server is running."
	if(!check_rights(R_PERMISSIONS))
		return
	usr.client.holder.manage_player_ranks()

/// Proc for admins to change people's "player" ranks (donator, mentor, veteran, etc.)
/datum/admins/proc/manage_player_ranks()
	if(!check_rights(R_PERMISSIONS))
		return

	var/choice = tgui_alert(usr, "Which rank would you like to manage?", "Manage Player Ranks", WHITE_PLAYER_RANKS+"Cancel")
	if(!choice || !(choice in WHITE_PLAYER_RANKS))
		return

	manage_player_rank_in_group(choice)

/// Proc that helps a bit with repetition, basically an extension of `manage_player_ranks()`
/datum/admins/proc/manage_player_rank_in_group(group)
	if(!(group in WHITE_PLAYER_RANKS))
		CRASH("[key_name(usr)] attempted to add someone to an invalid \"[group]\" group.")

	var/group_title = lowertext(group)

	var/list/choices = list("Add", "Remove")
	switch(tgui_alert(usr, "What would you like to do?", "Manage [group]s", choices))
		if("Add")
			var/name = tgui_input_text(usr, "Please enter the CKEY (case-insensitive) of the person you would like to make a [group_title]:", "Add a [group_title]")
			if(!name)
				return

			var/player_to_be = ckey(name)
			if(!player_to_be)
				to_chat(usr, span_warning("\"[name]\" is not a valid CKEY."))
				return

			switch(group)
				if("Mentor")
					for(var/a_mentor as anything in GLOB.mentor_datums)
						if(player_to_be == a_mentor)
							to_chat(usr, span_warning("\"[player_to_be]\" is already a [group_title]!"))
							return
					// Now that we know that the ckey is valid and they're not already apart of that group, let's add them to it!
					new /datum/mentors(player_to_be)
					text2file(player_to_be, WHITE_MENTOR_CONFIG_FILE)
				if("EXRP")
					for(var/a_exrp as anything in GLOB.whitelist_exrp)
						if(player_to_be == a_exrp)
							to_chat(usr, span_warning("\"[player_to_be]\" is already a [group_title]!"))
							return
					// Now that we know that the ckey is valid and they're not already apart of that group, let's add them to it!
					LAZYADD(GLOB.whitelist_exrp, player_to_be)
					text2file(player_to_be, WHITE_EXRP_CONFIG_FILE)
				if("SOUP")
					for(var/a_soup as anything in GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal)
						if(player_to_be == a_soup)
							to_chat(usr, span_warning("\"[player_to_be]\" is already a [group_title]!"))
							return
					LAZYADD(GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal, player_to_be)
					text2file(player_to_be, WHITE_SOUP_CONFIG_FILE)
				else
					return

			message_admins("[key_name(usr)] has granted [group_title] status to [player_to_be].")
			log_admin_private("[key_name(usr)] has granted [group_title] status to [player_to_be].")


		if("Remove")
			var/name = tgui_input_text(usr, "Please enter the CKEY (case-insensitive) of the person you would like to no longer be a [group_title]:", "Remove a [group_title]")
			if(!name)
				return

			var/player_that_was = ckey(name)
			if(!player_that_was)
				to_chat(usr, span_warning("\"[name]\" is not a valid CKEY."))
				return

			var/changes = FALSE
			switch(group)
				if("Mentor")
					for(var/a_mentor as anything in GLOB.mentor_datums)
						if(player_that_was == a_mentor)
							var/datum/mentors/mentor_datum = GLOB.mentor_datums[a_mentor]
							mentor_datum.remove_mentor()
							changes = TRUE
					if(!changes)
						to_chat(usr, span_warning("\"[player_that_was]\" was already not a [group_title]."))
					save_mentors()
				if("EXRP")
					for(var/a_exrp as anything in GLOB.whitelist_exrp)
						if(player_that_was == a_exrp)
							GLOB.whitelist_exrp -= player_that_was
							changes = TRUE
					if(!changes)
						to_chat(usr, span_warning("\"[player_that_was]\" was already not a [group_title]."))
						return
					save_exrp_players()
				if("SOUP")
					for(var/a_soup as anything in GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal)
						if(player_that_was == a_soup)
							GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal -= player_that_was
							changes = TRUE
					if(!changes)
						to_chat(usr, span_warning("\"[player_that_was]\" was already not a [group_title]."))
						return
					save_soup_players()
				else
					return
			message_admins("[key_name(usr)] has revoked [group_title] status from [player_that_was].")
			log_admin_private("[key_name(usr)] has revoked [group_title] status from [player_that_was].")

		else
			return


/// Proc to save the current mentor list into the config, overwriting it.
/proc/save_mentors()
	usr = null
	var/mentor_list = ""

	// This whole mess is just to create a cache of all the mentors that were in the config already
	// so that we don't add every admin to the list, which would be a pain to maintain afterwards.
	var/list/existing_mentor_config = world.file2list(WHITE_MENTOR_CONFIG_FILE)
	var/list/existing_mentors = list()
	for(var/line in existing_mentor_config)
		if(!length(line))
			continue
		if(findtextEx(line, "#", 1, 2))
			continue
		var/existing_mentor = ckey(line)
		if(!existing_mentor)
			continue
		existing_mentors[existing_mentor] = TRUE

	for(var/mentor as anything in GLOB.mentor_datums)
		// We're doing this check to not add admins to the file, as explained above.
		if(existing_mentors[mentor] == TRUE)
			mentor_list += mentor + "\n"
	rustg_file_write(mentor_list, WHITE_MENTOR_CONFIG_FILE)

/proc/save_exrp_players()
	var/exrp_list = ""
	for(var/exrp in GLOB.whitelist_exrp)
		exrp_list += exrp + "\n"
	rustg_file_write(exrp_list, WHITE_EXRP_CONFIG_FILE)

/proc/save_soup_players()
	var/soup_list = ""
	for(var/soup in GLOB.ya_ne_ebanulsya_prosto_produlo_i_mozg_vipal)
		soup_list += soup + "\n"
	rustg_file_write(soup_list, WHITE_SOUP_CONFIG_FILE)

#undef WHITE_MENTOR_CONFIG_FILE
#undef WHITE_EXRP_CONFIG_FILE
#undef WHITE_PLAYER_RANKS

