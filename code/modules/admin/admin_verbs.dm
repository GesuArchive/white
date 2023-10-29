//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
//the procs are cause you can't put the comments in the GLOB var define
GLOBAL_LIST_INIT(admin_verbs_default, world.AVerbsDefault())
GLOBAL_PROTECT(admin_verbs_default)
/world/proc/AVerbsDefault()
	return list(
	/client/proc/deadmin,				/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/toggle_hear_radio,		/*allows admins to hide all radio output*/
	/client/proc/reload_admins,
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,		/*admin-pm list*/
	/client/proc/stop_sounds,
	/client/proc/requests,
	/client/proc/show_all_verbs
	)
GLOBAL_LIST_INIT(admin_verbs_admin, world.AVerbsAdmin())
GLOBAL_PROTECT(admin_verbs_admin)
/world/proc/AVerbsAdmin()
	return list(
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/datum/verbs/Admin/verb/playerpanel,
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/client/proc/ghost_pool_protection,	/*opens a menu for toggling ghost roles*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/togglelooc,		/*toggles looc on/off for everyone*/
	/datum/admins/proc/toggleloocdead,	/*toggles looc on/off for everyone who is dead */
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/getserverlogs,		/*for accessing server logs*/
	/client/proc/getcurrentlogs,		/*for accessing server logs for the current round*/
	/client/proc/cmd_admin_subtle_message,	/*send a message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_headset_message,	/*send a message to somebody through their headset as CentCom*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/datum/admins/proc/access_news_network,	/*allows access of newscasters*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/jumptoarea,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/admin_call_shuttle,	/*allows us to call the emergency shuttle*/
	/client/proc/admin_cancel_shuttle,	/*allows us to cancel the emergency shuttle, sending it back to centcom*/
	/client/proc/admin_disable_shuttle, /*allows us to disable the emergency shuttle admin-wise so that it cannot be called*/
	/client/proc/admin_enable_shuttle,  /*undoes the above*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_check_player_exp, /* shows players by playtime */
	/client/proc/toggle_combo_hud, // toggle display of the combination pizza antag and taco sci/med/eng hud
	/client/proc/cmd_admin_law_panel,
	/client/proc/toggle_AI_interact, /*toggle admin ability to interact with machines as an AI*/
	/client/proc/deadchat,
	/client/proc/toggleprayers,
	/client/proc/toggle_prayer_sound,
	/client/proc/colorasay,
	/client/proc/resetasaycolor,
	/client/proc/toggleadminhelpsound,
	/client/proc/respawn_character,
	/client/proc/open_killcounter_counts,
	/client/proc/secrets,
	/client/proc/darknesshelper,
	/datum/admins/proc/open_borgopanel,
	/datum/admins/proc/view_all_circuits,
	/datum/admins/proc/paintings_manager,
	/datum/admins/proc/known_alts_panel,
	/client/proc/clicker_panel,
	/datum/admins/proc/fishing_calculator,
	/datum/admins/proc/get_spd_list,
	)
GLOBAL_LIST_INIT(admin_verbs_ban, list(/client/proc/unban_panel, /client/proc/ban_panel, /client/proc/stickybanpanel, /client/proc/assblast_panel, /client/proc/show_assblasts))
GLOBAL_PROTECT(admin_verbs_ban)
GLOBAL_LIST_INIT(admin_verbs_sounds, list(/client/proc/play_local_sound_wrapper, /client/proc/play_direct_mob_sound, /client/proc/play_sound_wrapper, /client/proc/set_round_end_sound_wrapper))
GLOBAL_PROTECT(admin_verbs_sounds)
GLOBAL_LIST_INIT(admin_verbs_fun, list(
	/client/proc/enforce_containment_procedures,
	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
	/datum/admins/proc/show_lag_switch_panel,
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/set_admin_notice, /*announcement all clients see when joining the server.*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_local_narrate,	/*sends text to all mobs within view of atom*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_change_command_name,
	/datum/admins/proc/open_shuttlepanel, /* Opens shuttle manipulator UI */
	/datum/admins/proc/open_borgopanel,
	/client/proc/cmd_select_equipment,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/drop_bomb_verb,
	/client/proc/set_dynex_scale,
	/client/proc/drop_dynex_bomb,
	/client/proc/cinematic,
	/client/proc/one_click_antag,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/forceEvent,
	/client/proc/admin_change_sec_level,
	/client/proc/toggle_nuke,
	/client/proc/run_weather,
	/client/proc/mass_zombie_infection,
	/client/proc/mass_zombie_cure,
	/client/proc/polymorph_all,
	/client/proc/show_tip,
	/client/proc/smite,
	/client/proc/admin_away,
	/client/proc/add_mob_ability,
	/client/proc/toggle_prikol,
	/client/proc/centcom_podlauncher, /*Open a window to launch a Supplypod and configure it or it's contents*/
	/client/proc/battle_royale,
	/client/proc/load_circuit,
	/client/proc/change_lobby_music,
	/client/proc/cmd_admin_toggle_fov,
	/client/proc/validate_puzzgrids,
	/client/proc/force_say,
	/client/proc/force_violence_map,
	/client/proc/force_violence_mode,
	/client/proc/violence_friendlyfire,
	))
GLOBAL_PROTECT(admin_verbs_fun)
GLOBAL_LIST_INIT(admin_verbs_spawn, list(/datum/admins/proc/spawn_atom, TYPE_PROC_REF(/datum/admins, podspawn_atom),
										/datum/admins/proc/spawn_cargo, TYPE_PROC_REF(/datum/admins, spawn_objasmob),
										/client/proc/respawn_character, TYPE_PROC_REF(/datum/admins, beaker_panel)))
GLOBAL_PROTECT(admin_verbs_spawn)
GLOBAL_LIST_INIT(admin_verbs_server, world.AVerbsServer())
GLOBAL_PROTECT(admin_verbs_server)
/world/proc/AVerbsServer()
	return list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/end_round,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all_wrapper,
	/client/proc/toggle_random_events,
	/client/proc/forcerandomrotate,
	/client/proc/adminchangemap,
	/client/proc/panicbunker,
	/client/proc/toggle_hub,
	/client/proc/toggle_cdn,
	/client/proc/toggle_tournament_rules,
	/client/proc/toggle_major_mode,
	)
GLOBAL_LIST_INIT(admin_verbs_debug, world.AVerbsDebug())
GLOBAL_PROTECT(admin_verbs_debug)
/world/proc/AVerbsDebug()
	return list(
	/client/proc/restart_controller,
	/client/proc/nullify_garbage_list,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all_wrapper,
	/client/proc/enable_debug_verbs,
	/client/proc/enable_supercruise_verbs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/test_movable_UI,
	/client/proc/test_snap_UI,
	/client/proc/debugNatureMapGenerator,
	/client/proc/check_bomb_impacts,
	/proc/machine_upgrade,
	/client/proc/populate_world,
	/client/proc/get_dynex_power,		//*debug verbs for dynex explosions.
	/client/proc/get_dynex_range,		//*debug verbs for dynex explosions.
	/client/proc/set_dynex_scale,
	/client/proc/cmd_display_del_log,
	/client/proc/outfit_manager,
	/client/proc/open_colorblind_test,
	/client/proc/debug_plane_masters,
	/client/proc/modify_goals,
	/client/proc/debug_huds_wrapper,
	/client/proc/map_template_load,
	/client/proc/map_template_upload,
	/client/proc/jump_to_ruin,
	/client/proc/clear_dynamic_transit,
	/client/proc/toggle_medal_disable,
	/client/proc/view_runtimes,
	/client/proc/pump_random_event,
	/client/proc/cmd_display_init_log,
	/client/proc/cmd_display_overlay_log,
	/client/proc/reload_configuration,
	/client/proc/atmos_control,
	/client/proc/reload_cards,
	/client/proc/validate_cards,
	/client/proc/test_cardpack_distribution,
	/client/proc/print_cards,
	/client/proc/generate_ruin,
	/client/proc/create_orbital_objective,
	/client/proc/mark_datum_mapview,
	/client/proc/debugstatpanel,
	/client/proc/check_missing_sprites,
	/client/proc/check_missing_states,
	#ifdef TESTING
	/client/proc/run_dynamic_simulations,
	#endif
	/client/proc/display_sendmaps,
	/datum/admins/proc/create_or_modify_area,
	/client/proc/check_timer_sources,
	/client/proc/toggle_cdn,
	/client/proc/load_circuit,
	/client/proc/open_lua_editor,
	/client/proc/debug_hud_icon,
	)
GLOBAL_LIST_INIT(admin_verbs_possess, list(/proc/possess, GLOBAL_PROC_REF(possess), GLOBAL_PROC_REF(release)))
GLOBAL_PROTECT(admin_verbs_possess)
GLOBAL_LIST_INIT(admin_verbs_permissions, list(/client/proc/edit_admin_permissions, /client/proc/manage_lists, /client/proc/add_bug_down, /client/proc/change_server_theme))
GLOBAL_PROTECT(admin_verbs_permissions)
GLOBAL_LIST_INIT(admin_verbs_secured, list(
	/client/proc/de_admin,
	/client/proc/manage_some_donations,
	/client/proc/manage_player_ranks,
	/client/proc/raspidoars,
	/client/proc/commit_warcrime,
	/client/proc/uncommit_warcrime,
	/client/proc/kaboom,
	/client/proc/smooth_fucking_z_level,
	/client/proc/get_tacmap_for_test,
	/client/proc/fuck_pie,
	/client/proc/fix_air, /*resets air in designated radius to its default atmos composition*/
	/client/proc/reestablish_db_connection, /*reattempt a connection to the database*/
	/datum/admins/proc/kill_system32,
	/client/proc/reload_whitelist,
	))
GLOBAL_PROTECT(admin_verbs_secured)
GLOBAL_LIST_INIT(admin_verbs_poll, list(/client/proc/poll_panel))
GLOBAL_PROTECT(admin_verbs_poll)

GLOBAL_LIST_INIT(admin_verbs_sdql, list(/client/proc/SDQL2_query_wrapper))
GLOBAL_PROTECT(admin_verbs_sdql)

//verbs which can be hidden - needs work
GLOBAL_LIST_INIT(admin_verbs_hideable, list(
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/deadmin,
	/datum/admins/proc/show_skill_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/datum/admins/proc/set_admin_notice,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_headset_message,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/play_local_sound_wrapper,
	/client/proc/play_sound_wrapper,
	/client/proc/set_round_end_sound_wrapper,
	/client/proc/cmd_select_equipment,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/drop_bomb_verb,
	/client/proc/drop_dynex_bomb,
	/client/proc/get_dynex_range,
	/client/proc/get_dynex_power,
	/client/proc/set_dynex_scale,
	/client/proc/cinematic,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_change_command_name,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/restart_controller,
	/client/proc/nullify_garbage_list,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all_wrapper,
	/client/proc/enable_debug_verbs,
	/client/proc/enable_supercruise_verbs,
	/proc/possess,
	/proc/release,
	/client/proc/reload_admins,
	/client/proc/panicbunker,
	/client/proc/admin_change_sec_level,
	/client/proc/toggle_nuke,
	/client/proc/cmd_display_del_log,
	/client/proc/toggle_combo_hud,
	/client/proc/cmd_admin_law_panel,
	/client/proc/debug_huds_wrapper,
	/client/proc/fuck_pie,
	))
GLOBAL_PROTECT(admin_verbs_hideable)

GLOBAL_LIST_INIT(all_dumb_admin_verbs, world.get_all_fucking_admin_verbs())
GLOBAL_PROTECT(all_dumb_admin_verbs)

/world/proc/get_all_fucking_admin_verbs()
	return GLOB.admin_verbs_default + GLOB.admin_verbs_admin + GLOB.admin_verbs_ban + GLOB.admin_verbs_fun + GLOB.admin_verbs_server + GLOB.admin_verbs_debug + GLOB.admin_verbs_possess + GLOB.admin_verbs_permissions + GLOB.admin_verbs_secured + GLOB.admin_verbs_poll + GLOB.admin_verbs_sounds + GLOB.admin_verbs_spawn + GLOB.admin_verbs_debug_mapping + GLOB.admin_verbs_sdql + list(/client/proc/togglebuildmodeself, /client/proc/stealth, /client/proc/play_web_sound, /client/proc/disable_debug_verbs, /client/proc/disable_supercruise_verbs)

/client/proc/add_admin_verbs()
	if(holder)
		control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS

		var/rights = holder.rank.rights
		add_verb(src, GLOB.admin_verbs_default)
		if(rights & R_BUILD)
			add_verb(src, /client/proc/togglebuildmodeself, FALSE)
		if(rights & R_ADMIN)
			add_verb(src, GLOB.admin_verbs_admin, FALSE)
		if(rights & R_BAN)
			add_verb(src, GLOB.admin_verbs_ban, FALSE)
		if(rights & R_FUN)
			add_verb(src, GLOB.admin_verbs_fun, FALSE)
		if(rights & R_SERVER)
			add_verb(src, GLOB.admin_verbs_server, FALSE)
		if(rights & R_DEBUG)
			add_verb(src, GLOB.admin_verbs_debug, FALSE)
		if(rights & R_POSSESS)
			add_verb(src, GLOB.admin_verbs_possess, FALSE)
		if(rights & R_PERMISSIONS)
			add_verb(src, GLOB.admin_verbs_permissions, FALSE)
		if(rights & R_SECURED)
			add_verb(src, GLOB.admin_verbs_secured, FALSE)
		if(rights & R_STEALTH)
			add_verb(src, /client/proc/stealth, FALSE)
		if(rights & R_ADMIN)
			add_verb(src, GLOB.admin_verbs_poll, FALSE)
		if(rights & R_SDQL)
			add_verb(src, GLOB.admin_verbs_sdql, FALSE)
		if(rights & R_SOUND)
			add_verb(src, GLOB.admin_verbs_sounds, FALSE)
			if(CONFIG_GET(string/invoke_youtubedl))
				add_verb(src, /client/proc/play_web_sound, FALSE)
		if(rights & R_SPAWN)
			add_verb(src, GLOB.admin_verbs_spawn, FALSE)

/client/proc/remove_admin_verbs()
	remove_verb(src, list(
		GLOB.admin_verbs_default,
		/client/proc/togglebuildmodeself,
		GLOB.admin_verbs_admin,
		GLOB.admin_verbs_ban,
		GLOB.admin_verbs_fun,
		GLOB.admin_verbs_server,
		GLOB.admin_verbs_debug,
		GLOB.admin_verbs_possess,
		GLOB.admin_verbs_permissions,
		GLOB.admin_verbs_secured,
		/client/proc/stealth,
		GLOB.admin_verbs_poll,
		GLOB.admin_verbs_sounds,
		/client/proc/play_web_sound,
		GLOB.admin_verbs_spawn,
		/*Debug verbs added by "show debug verbs"*/
		GLOB.admin_verbs_debug_mapping,
		GLOB.admin_verbs_sdql,
		/client/proc/disable_debug_verbs,
		/client/proc/disable_supercruise_verbs,
		/client/proc/readmin
		))

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Адм"

	remove_admin_verbs()
	add_verb(src, /client/proc/show_verbs, FALSE)

	to_chat(src, span_interface("Almost all of your adminverbs have been hidden."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Hide All Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Адм"

	remove_verb(src, /client/proc/show_verbs)
	add_admin_verbs()

	to_chat(src, span_interface("All of your adminverbs are now visible."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!




/client/proc/admin_ghost()
	set category = "Адм.Игра"
	set name = "Aghost"
	if(!holder)
		return
	. = TRUE
	if(isobserver(mob))
		//re-enter
		var/mob/dead/observer/ghost = mob
		if(!ghost.mind || !ghost.mind.current) //won't do anything if there is no body
			return FALSE
		if(!ghost.can_reenter_corpse)
			log_admin("[key_name(usr)] re-entered corpse")
			message_admins("[key_name_admin(usr)] re-entered corpse")
		ghost.can_reenter_corpse = 1 //force re-entering even when otherwise not possible
		ghost.reenter_corpse()
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Reenter") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else if(isnewplayer(mob))
		to_chat(src, span_red("Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first."))
		return FALSE
	else
		//ghostize
		log_admin("[key_name(usr)] admin ghosted.")
		message_admins("[key_name_admin(usr)] admin ghosted.")
		var/mob/body = mob
		body.ghostize(1)
		init_verbs()
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Ghost") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Адм.Игра"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(initial(mob.invisibility) == INVISIBILITY_OBSERVER)
			to_chat(mob, span_boldannounce("Invisimin toggle failed. You are already an invisible mob like a ghost."))
			return
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			to_chat(mob, span_boldannounce("Invisimin off. Invisibility reset."))
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			to_chat(mob, span_adminnotice("<b>Invisimin on. You are now as invisible as a ghost.</b>"))

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Адм.Игра"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
		if(!isobserver(usr) && SSticker.HasRoundStarted())
			message_admins("[key_name_admin(usr)] checked antagonists.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Check Antagonists") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/ban_panel()
	set name = "Banning Panel"
	set category = "Адм"
	if(!check_rights(R_BAN))
		return
	holder.ban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Banning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/unban_panel()
	set name = "Unbanning Panel"
	set category = "Адм"
	if(!check_rights(R_BAN))
		return
	holder.unban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unbanning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Адм.Игра"
	if(holder)
		holder.Game()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Game Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/poll_panel()
	set name = "Server Poll Management"
	set category = "Адм"
	if(!check_rights(R_POLL))
		return
	holder.poll_list_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Server Poll Management") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in GLOB.stealthminID)
			if(GLOB.stealthminID[P] == txt)
				return P
	txt = GLOB.stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	GLOB.stealthminID["[ckey]"] = "@[num2text(num)]"

/client/proc/stealth()
	set category = "Адм"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
			if(isobserver(mob))
				mob.invisibility = initial(mob.invisibility)
				mob.alpha = initial(mob.alpha)
				if(mob.mind)
					if(mob.mind.ghostname)
						mob.name = mob.mind.ghostname
					else
						mob.name = mob.mind.name
				else
					mob.name = mob.real_name
				mob.mouse_opacity = initial(mob.mouse_opacity)
		else
			var/new_key = stripped_input(usr, "Выбери сикей. Можно на русском!", "Маскируемся", key, 26)
			if(!new_key)
				return
			holder.fakekey = new_key
			createStealthKey()
			if(isobserver(mob))
				mob.invisibility = INVISIBILITY_MAXIMUM //JUST IN CASE
				mob.alpha = 0 //JUUUUST IN CASE
				mob.name = " "
				mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stealth Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_bomb_verb(turf/epicenter = null in world)
	set category = "Адм.Веселье"
	set name = "Here Drop Bomb"
	set desc = "Cause an explosion of varying strength at pointed location."

	if(epicenter)
		drop_bomb_proc(epicenter, src)

/client/proc/drop_bomb()
	set category = "Адм.Веселье"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	drop_bomb_proc(null, src)

/proc/drop_bomb_proc(twar, client/user)

	var/list/choices = list("Small Bomb (1, 2, 3, 3)", "Medium Bomb (2, 3, 4, 4)", "Big Bomb (3, 5, 7, 5)", "Maxcap", "Custom Bomb")
	var/choice = tgui_input_list(user, "What size explosion would you like to produce? NOTE: You can do all this rapidly and in an IC manner (using cruise missiles!) with the Config/Launch Supplypod verb. WARNING: These ignore the maxcap", "Drop Bomb", choices)

	var/turf/epicenter

	if(twar)
		epicenter = twar

	if(isnull(epicenter))
		epicenter = user.mob.loc

	switch(choice)
		if(null)
			return
		if("Small Bomb (1, 2, 3, 3)")
			explosion(epicenter, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 3, flash_range = 3, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user)
		if("Medium Bomb (2, 3, 4, 4)")
			explosion(epicenter, devastation_range = 2, heavy_impact_range = 3, light_impact_range = 4, flash_range = 4, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user)
		if("Big Bomb (3, 5, 7, 5)")
			explosion(epicenter, devastation_range = 3, heavy_impact_range = 5, light_impact_range = 7, flash_range = 5, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user)
		if("Maxcap")
			explosion(epicenter, devastation_range = GLOB.MAX_EX_DEVESTATION_RANGE, heavy_impact_range = GLOB.MAX_EX_HEAVY_RANGE, light_impact_range = GLOB.MAX_EX_LIGHT_RANGE, flash_range = GLOB.MAX_EX_FLASH_RANGE, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user)
		if("Custom Bomb")
			var/range_devastation = input("Devastation range (in tiles):") as null|num
			if(range_devastation == null)
				return
			var/range_heavy = input("Heavy impact range (in tiles):") as null|num
			if(range_heavy == null)
				return
			var/range_light = input("Light impact range (in tiles):") as null|num
			if(range_light == null)
				return
			var/range_flash = input("Flash range (in tiles):") as null|num
			if(range_flash == null)
				return
			if(range_devastation > GLOB.MAX_EX_DEVESTATION_RANGE || range_heavy > GLOB.MAX_EX_HEAVY_RANGE || range_light > GLOB.MAX_EX_LIGHT_RANGE || range_flash > GLOB.MAX_EX_FLASH_RANGE)
				if(tgui_alert(usr, "Bomb is bigger than the maxcap. Continue?",,list("Yes","No")) != "Yes")
					return
			epicenter = get_turf(user) //We need to reupdate as they may have moved again
			explosion(epicenter, devastation_range = range_devastation, heavy_impact_range = range_heavy, light_impact_range = range_light, flash_range = range_flash, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user)
	message_admins("[ADMIN_LOOKUPFLW(usr)] creating an admin explosion at [epicenter.loc].")
	log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/enforce_containment_procedures()
	set category = "Адм.Веселье"
	set name = "Enforce Containment Procedures"
	set desc = "Panik bunker 2.0."
	var/rtime = input("лучайное время (от 0 до x секунд) между помещениями людей под стражу. Не больше 6.9 секунд.","",0) as num|null
	if(isnull(rtime))
		rtime = 0
	rtime = clamp(rtime,0,6.9)
	var/ass = tgui_alert(usr, "Ты уверен?","SECURE. CONTAIN. PROTECT.", list("Да.","Нет."))
	if(ass=="Нет.")
		return

	log_admin("[usr.ckey] enforced containment protocols.")
	to_chat(usr, span_notice("Preparing containment protocols..."))
	spawn(1.5 SECONDS)
		to_chat(usr, span_alert("Enforcing containment protocols..."))
		for(var/Ct in GLOB.clients)
			var/client/C = Ct
			if(check_for_assblast(C.ckey, ASSBLAST_CUMJAR)) // ASSBLAST_CUMJAR define can't be resolved here by compiler for some ungodly reason. i fucking hate byond
				if(!isliving(C.mob))
					continue
				if(istype(C.mob.loc, /obj/item/cum_jar))
					continue
				new /obj/item/cum_jar(C.mob)
				if(rtime != 0)
					sleep(rand(0,rtime) SECONDS)
		to_chat(usr, span_alert("Containment protocols enforced."))

/client/proc/drop_dynex_bomb()
	set category = "Адм.Веселье"
	set name = "Drop DynEx Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/ex_power = input("Explosive Power:") as null|num
	var/turf/epicenter = mob.loc
	if(ex_power && epicenter)
		dyn_explosion(epicenter, ex_power)
		message_admins("[ADMIN_LOOKUPFLW(usr)] creating an admin explosion at [epicenter.loc].")
		log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Dynamic Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_dynex_range()
	set category = "Дбг.Бомбы"
	set name = "Get DynEx Range"
	set desc = "Get the estimated range of a bomb, using explosive power."

	var/ex_power = input("Explosive Power:") as null|num
	if (isnull(ex_power))
		return
	var/range = round((2 * ex_power)**GLOB.DYN_EX_SCALE)
	to_chat(usr, "Estimated Explosive Range: (Devastation: [round(range*0.25)], Heavy: [round(range*0.5)], Light: [round(range)])")

/client/proc/get_dynex_power()
	set category = "Дбг.Бомбы"
	set name = "Get DynEx Power"
	set desc = "Get the estimated required power of a bomb, to reach a specific range."

	var/ex_range = input("Light Explosion Range:") as null|num
	if (isnull(ex_range))
		return
	var/power = (0.5 * ex_range)**(1/GLOB.DYN_EX_SCALE)
	to_chat(usr, "Estimated Explosive Power: [power]")

/client/proc/set_dynex_scale()
	set category = "Дбг.Бомбы"
	set name = "Set DynEx Scale"
	set desc = "Set the scale multiplier of dynex explosions. The default is 0.5."

	var/ex_scale = input("New DynEx Scale:") as null|num
	if(!ex_scale)
		return
	GLOB.DYN_EX_SCALE = ex_scale
	log_admin("[key_name(usr)] has modified Dynamic Explosion Scale: [ex_scale]")
	message_admins("[key_name_admin(usr)] has  modified Dynamic Explosion Scale: [ex_scale]")

/client/proc/atmos_control()
	set name = "Atmos Control Panel"
	set category = "Дбг.Атмос"
	if(!check_rights(R_DEBUG))
		return
	SSair.ui_interact(mob)

/client/proc/reload_cards()
	set name = "Reload Cards"
	set category = "Дбг.ТЦГ"
	if(!check_rights(R_DEBUG))
		return
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	reloadAllCardFiles(SStrading_card_game.card_files, SStrading_card_game.card_directory)

/client/proc/validate_cards()
	set name = "Validate Cards"
	set category = "Дбг.ТЦГ"
	if(!check_rights(R_DEBUG))
		return
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	var/message = checkCardpacks(SStrading_card_game.card_packs)
	message += checkCardDatums()
	if(message)
		message_admins(message)

/client/proc/test_cardpack_distribution()
	set name = "Test Cardpack Distribution"
	set category = "Дбг.ТЦГ"
	if(!check_rights(R_DEBUG))
		return
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	var/pack = tgui_input_list(usr, "Which pack should we test?", "You fucked it didn't you", sort_list(SStrading_card_game.card_packs))
	var/batchCount = input("How many times should we open it?", "Don't worry, I understand") as null|num
	var/batchSize = input("How many cards per batch?", "I hope you remember to check the validation") as null|num
	var/guar = input("Should we use the pack's guaranteed rarity? If so, how many?", "We've all been there. Man you should have seen the old system") as null|num
	checkCardDistribution(pack, batchSize, batchCount, guar)

/client/proc/print_cards()
	set name = "Print Cards"
	set category = "Дбг.ТЦГ"
	printAllCards()

/client/proc/give_spell(mob/spell_recipient in GLOB.mob_list)
	set category = "Адм.Веселье"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."

	var/which = tgui_alert(usr, "Chose by name or by type path?", "Chose option", list("Name", "Typepath"))
	if(!which)
		return
	if(QDELETED(spell_recipient))
		to_chat(usr, span_warning("The intended spell recipient no longer exists."))
		return

	var/list/spell_list = list()
	for(var/datum/action/cooldown/spell/to_add as anything in subtypesof(/datum/action/cooldown/spell))
		var/spell_name = initial(to_add.name)
		if(spell_name == "Spell") // abstract or un-named spells should be skipped.
			continue

		if(which == "Name")
			spell_list[spell_name] = to_add
		else
			spell_list += to_add

	var/chosen_spell = tgui_input_list(usr, "Choose the spell to give to [spell_recipient]", "ABRAKADABRA", sort_list(spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/spell_path = which == "Typepath" ? chosen_spell : spell_list[chosen_spell]
	if(!ispath(spell_path))
		return

	var/robeless = (tgui_alert(usr, "Would you like to force this spell to be robeless?", "Robeless Casting?", list("Force Robeless", "Use Spell Setting")) == "Force Robeless")

	if(QDELETED(spell_recipient))
		to_chat(usr, span_warning("The intended spell recipient no longer exists."))
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(spell_recipient)] the spell [chosen_spell][robeless ? " (Forced robeless)" : ""].")
	message_admins("[key_name_admin(usr)] gave [key_name_admin(spell_recipient)] the spell [chosen_spell][robeless ? " (Forced robeless)" : ""].")

	var/datum/action/cooldown/spell/new_spell = new spell_path(spell_recipient.mind || spell_recipient)

	if(robeless)
		new_spell.spell_requirements &= ~SPELL_REQUIRES_WIZARD_GARB

	new_spell.Grant(spell_recipient)

	if(!spell_recipient.mind)
		to_chat(usr, span_userdanger("Spells given to mindless mobs will belong to the mob and not their mind, \
			and as such will not be transferred if their mind changes body (Such as from Mindswap)."))

/client/proc/remove_spell(mob/removal_target in GLOB.mob_list)
	set category = "Адм.Веселье"
	set name = "Remove Spell"
	set desc = "Remove a spell from the selected mob."

	var/list/target_spell_list = list()
	for(var/datum/action/cooldown/spell/spell in removal_target.actions)
		target_spell_list[spell.name] = spell

	if(!length(target_spell_list))
		return

	var/chosen_spell = tgui_input_list(usr, "Choose the spell to remove from [removal_target]", "ABRAKADABRA", sort_list(target_spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/to_remove = target_spell_list[chosen_spell]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(usr)] removed the spell [chosen_spell] from [key_name(removal_target)].")
	message_admins("[key_name_admin(usr)] removed the spell [chosen_spell] from [key_name_admin(removal_target)].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Remove Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/give_disease(mob/living/T in GLOB.mob_living_list)
	set category = "Адм.Веселье"
	set name = "Give Disease"
	set desc = "Gives a Disease to a mob."
	if(!istype(T))
		to_chat(src, span_notice("You can only give a disease to a mob of type /mob/living."))
		return
	var/datum/disease/D = tgui_input_list(usr, "Choose the disease to give to that guy", "ACHOO", sort_list(SSdisease.diseases, GLOBAL_PROC_REF(cmp_typepaths_asc)))
	if(!D)
		return
	T.ForceContractDisease(new D, FALSE, TRUE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Disease") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the disease [D].")
	message_admins(span_adminnotice("[key_name_admin(usr)] gave [key_name_admin(T)] the disease [D]."))

/client/proc/object_say(obj/O in world)
	set category = "Адм.События"
	set name = "OSay"
	set desc = "Makes an object say something."
	var/message = tgui_input_text(usr, "What do you want the message to be?", "Make Sound")
	if(!message)
		return
	O.say(message, sanitize = FALSE)
	message = sanitize(message)
	log_admin("[key_name(usr)] made [O] at [AREACOORD(O)] say \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(usr)] made [O] at [AREACOORD(O)]. say \"[message]\""))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Object Say") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/force_say(mob/M in world)
	set category = "Адм.Веселье"
	set name = "Force say"
	set desc = "Makes a mob say something. Bypasses sanitization, be careful with that."
	var/speech = tgui_input_text(usr, "What will [key_name(M)] say?", "Force speech (WARNING, UNSANITIZED)", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
	if(!speech)
		return
	M.say(speech, forced = "admin speech", sanitize = FALSE)
	speech = sanitize(speech)
	log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
	message_admins(span_adminnotice("[key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]"))



/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Адм.События"
	if (!(holder.rank.rights & R_BUILD))
		return
	if(src.mob)
		togglebuildmode(src.mob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Build Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Адм.Игра"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/deadmin()
	set name = "Deadmin"
	set category = "Адм"
	set desc = "Shed your admin powers."

	if(!holder)
		return

	holder.deactivate()

	to_chat(src, span_interface("DEADMINED"))
	log_admin("[src] deadminned themselves.")
	message_admins("[src] deadminned themselves.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Deadmin")

/client/proc/readmin()
	set name = "Readmin"
	set category = "Адм"
	set desc = "Regain your admin powers."

	if(src.ckey in GLOB.de_admined)
		to_chat(src, span_interface("Тебе отрезали кнопки до конца раунда. Praise the Lord!"))
		return

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if (!A)
			var/msg = " пытается readmin but they have no deadmin entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return
	A.associate(src)

	if (!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, span_interface("ADMINED"))
	message_admins("[src] re-adminned themselves.")
	log_admin("[src] re-adminned themselves.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Readmin")

/client/proc/populate_world(amount = 50 as num)
	set name = "Populate World"
	set category = "Дбг.Маппинг"
	set desc = "(\"Amount of mobs to create\") Populate the world with test mobs."

	if (amount > 0)
		var/area/area
		var/list/candidates
		var/turf/open/floor/tile
		var/j,k

		for (var/i = 1 to amount)
			j = 100

			do
				area = pick(GLOB.the_station_areas)

				if (area)

					candidates = get_area_turfs(area)

					if (candidates.len)
						k = 100

						do
							tile = pick(candidates)
						while ((!tile || !istype(tile)) && --k > 0)

						if (tile)
							var/mob/living/carbon/human/hooman = new(tile)
							hooman.equipOutfit(pick(subtypesof(/datum/outfit)))
							testing("Spawned test mob at [COORD(tile)]")
			while (!area && --j > 0)

/client/proc/toggle_AI_interact()
	set name = "Toggle Admin AI Interact"
	set category = "Адм.Игра"
	set desc = "Allows you to interact with most machines as an AI would as a ghost"

	AI_Interact = !AI_Interact
	if(mob && isAdminGhostAI(mob))
		mob.has_unlimited_silicon_privilege = AI_Interact

	log_admin("[key_name(usr)] has [AI_Interact ? "activated" : "deactivated"] Admin AI Interact")
	message_admins("[key_name_admin(usr)] has [AI_Interact ? "activated" : "deactivated"] their AI interaction")

/client/proc/debugstatpanel()
	set name = "Debug Stat Panel"
	set category = "Дбг.Интерфейс"

	src.stat_panel.send_message("create_debug")

/client/proc/display_sendmaps()
	set name = "Send Maps Profile"
	set category = "Дбг"

	src << link("?debug=profile&type=sendmaps&window=test")

/client/proc/add_mob_ability()
	set category = "Адм.События"
	set name = "Add Mob Ability"
	set desc = "Adds an ability to a marked mob."

	if(!holder)
		return

	if(!holder.marked_datum || !istype(holder.marked_datum, /mob/living))
		return

	var/mob/living/marked_mob = holder.marked_datum

	var/ability_type = tgui_input_list(usr, "Choose an ability", "Ability", sort_list(subtypesof(/datum/action/cooldown/mob_cooldown), GLOBAL_PROC_REF(cmp_typepaths_asc)))
	if(!ability_type)
		return

	var/datum/action/cooldown/mob_cooldown/add_ability = new ability_type()
	add_ability.Grant(marked_mob)

	message_admins("[key_name_admin(usr)] added mob ability [ability_type] to mob [marked_mob].")
	log_admin("[key_name(usr)] added mob ability [ability_type] to mob [marked_mob].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Add Mob Ability") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/show_all_verbs()
	set category = "Адм"
	set name = "Администрирование"
	set desc = "Большие яйца?"

	if(!holder)
		return

	admin_menu = new(usr)
	admin_menu.ui_interact(usr)

/datum/admin_menu
	var/client/holder
	var/compact_mode = FALSE

/datum/admin_menu/New(user)
	if (istype(user, /client))
		var/client/user_client = user
		holder = user_client
	else
		var/mob/user_mob = user
		holder = user_mob.client

/datum/admin_menu/ui_state(mob/user)
	return GLOB.admin_state

/datum/admin_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AdminVerbs")
		ui.open()

/datum/admin_menu/ui_data(mob/user)
	var/list/data = list()
	data["compactMode"] = compact_mode
	return data

/datum/admin_menu/ui_static_data(mob/user)
	var/list/temp_data = list()
	for(var/procpath/cur_verb as anything in holder.verbs)
		if(!cur_verb.category)
			continue
		if(!temp_data[cur_verb.category])
			temp_data[cur_verb.category] = list()
		temp_data[cur_verb.category] += list(list("verb" = "[cur_verb]", "name" = cur_verb.name, "desc" = cur_verb.desc))

	var/list/tgui_data = list()
	for(var/category in temp_data)
		var/list/cat = list(
			"name" = category,
			"items" = temp_data[category])
		tgui_data["categories"] += list(cat)

	LAZYADDASSOCLIST(tgui_data, "categories", list("name" = "История", "items" = reverseList(holder.last_verbs_used)))
	return tgui_data

/datum/admin_menu/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("compact_toggle")
			compact_mode = !compact_mode
			return TRUE

	if(!check_rights(R_ADMIN) || action != "run")
		return

	INVOKE_ASYNC(holder, text2path(params["verb"]))

	LAZYADD(holder.last_verbs_used, list(list("verb" = params["verb"], "name" = params["name"], "desc" = params["desc"])))

	SStgui.close_uis(usr)

/client/proc/list_law_changes()
	set name = "List Law Changes"
	set category = "Дбг"
	if(!holder)
		return
	holder.list_law_changes()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "List Law Changes") // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

/datum/admins/proc/list_law_changes() // поебать
	if(!SSticker.HasRoundStarted())
		tgui_alert(usr, "The game hasn't started yet!")
		return
	var/data = "<b>Showing last [length(GLOB.lawchanges)] law changes.</b><hr>"
	for(var/entry in GLOB.lawchanges)
		data += "[entry]<BR>"
	usr << browse(data, "window=lawchanges;size=800x500")

