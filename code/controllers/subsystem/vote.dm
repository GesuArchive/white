SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

	flags = SS_KEEP_TIMING|SS_NO_INIT
	init_order = INIT_ORDER_VOTE

	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/choices = list()
	var/list/choice_by_ckey = list()
	var/list/generated_actions = list()
	var/initiator
	var/mode
	var/question
	var/started_time
	var/time_remaining
	var/list/voted = list()
	var/list/voting = list()

// Called by master_controller
/datum/controller/subsystem/vote/fire()
	if(!mode)
		return
	time_remaining = round((started_time + CONFIG_GET(number/vote_period) - world.time)/10)
	if(time_remaining < 0)
		result()
		SStgui.close_uis(src)
		reset()

/datum/controller/subsystem/vote/proc/reset()
	choices.Cut()
	choice_by_ckey.Cut()
	initiator = null
	mode = null
	question = null
	time_remaining = 0
	voted.Cut()
	voting.Cut()

	remove_action_buttons()

/datum/controller/subsystem/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!CONFIG_GET(flag/default_no_vote) && choices.len)
		var/list/non_voters = GLOB.directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if (!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(non_voters.len > 0)
			if(mode == "перезапуск")
				choices["Продолжаем"] += non_voters.len
				if(choices["Продолжаем"] >= greatest_votes)
					greatest_votes = choices["Продолжаем"]
			else if(mode == "режим")
				if(GLOB.master_mode in choices)
					choices[GLOB.master_mode] += non_voters.len
					if(choices[GLOB.master_mode] >= greatest_votes)
						greatest_votes = choices[GLOB.master_mode]
			else if(mode == "карту")
				for (var/non_voter_ckey in non_voters)
					var/client/C = non_voters[non_voter_ckey]
					var/preferred_map = C.prefs.preferred_map
					if(isnull(global.config.defaultmap))
						continue
					if(!preferred_map)
						preferred_map = global.config.defaultmap.map_name
					choices[preferred_map] += 1
					greatest_votes = max(greatest_votes, choices[preferred_map])
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(winners.len > 0)
		if(question)
			text += "<b>[question]</b>"
		else
			text += "<b>Голосование за [mode]</b>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			text += "\n<b>[choices[i]]:</b> [votes]"
		if(mode != "что-то")
			if(winners.len > 1)
				text = "\n<b>Голоса разделились между:</b>"
				for(var/option in winners)
					text += "\n\t[option]"
			. = pick(winners)
			text += "\n<b>Результат: [.]</b>"
		else
			text += "\n<b>Не голосовало:</b> [GLOB.clients.len-voted.len]"
	else
		text += "<b>Результат: ЕДИНАЯ РОССИЯ!</b>"
	log_vote(text)
	remove_action_buttons()
	to_chat(world, span_purple("\n[text]"))
	return .

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = FALSE
	if(.)
		switch(mode)
			if("перезапуск")
				if(. == "Заканчиваем")
					restart = TRUE
			if("режим")
				if(GLOB.master_mode != .)
					SSticker.save_mode(.)
					if(SSticker.HasRoundStarted())
						restart = TRUE
					else
						GLOB.master_mode = .
			if("карту")
				SSmapping.changemap(global.config.maplist[.])
				SSmapping.map_voted = TRUE
	if(restart)
		var/active_admins = FALSE
		for(var/client/C in GLOB.admins + GLOB.deadmins)
			if(!C.is_afk() && check_rights_for(C, R_SERVER))
				active_admins = TRUE
				break
		if(!active_admins)
			// No delay in case the restart is due to lag
			SSticker.Reboot("Голосвание за перезапуск успешно!", "restart vote", 1)
		else
			to_chat(world, "<span style='green'>Кто-то из педалей может перезапустить раунд. Пните их.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +server, so it has been canceled. If you wish, you may restart the server.")

	return .

/datum/controller/subsystem/vote/proc/submit_vote(vote)
	if(!mode)
		return FALSE
	if(CONFIG_GET(flag/no_dead_vote) && usr.stat == DEAD && !usr.client.holder)
		return FALSE
	if(!vote || vote < 1 || vote > choices.len)
		return FALSE
	// If user has already voted, remove their specific vote
	if(usr.ckey in voted)
		choices[choices[choice_by_ckey[usr.ckey]]]--
	else
		voted += usr.ckey
	choice_by_ckey[usr.ckey] = vote
	choices[choices[vote]]++
	return vote

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key)
	//Server is still intializing.
	if(!MC_RUNNING(init_stage))
		to_chat(usr, span_warning("Cannot start vote, server is not done initializing."))
		return FALSE
	var/lower_admin = FALSE
	var/ckey = ckey(initiator_key)
	if(GLOB.admin_datums[ckey])
		lower_admin = TRUE

	if(!mode)
		if(started_time)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, span_warning("There is already a vote in progress! please wait for it to finish."))
				return FALSE
			if(next_allowed_time > world.time && !lower_admin)
				to_chat(usr, span_warning("A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!"))
				return FALSE

		reset()
		switch(vote_type)
			if("перезапуск")
				choices.Add("Заканчиваем","Продолжаем")
			if("режим")
				choices.Add(config.votable_modes)
			if("карту")
				if(!lower_admin && SSmapping.map_voted)
					to_chat(usr, span_warning("Следующая карта уже была выбрана."))
					return FALSE
				// Randomizes the list so it isn't always METASTATION
				var/list/maps = list()
				for(var/map in global.config.maplist)
					var/datum/map_config/VM = config.maplist[map]
					if(!VM.votable || (VM.map_name in SSpersistence.blocked_maps))
						continue
					maps += VM.map_name
					shuffle_inplace(maps)
				for(var/valid_map in maps)
					choices.Add(valid_map)
			if("что-то")
				question = stripped_input(usr, "Что же мы спросим?")
				if(!question)
					return FALSE
				for(var/i=1,i<=10,i++)
					var/option = capitalize(stripped_input(usr, "Пиши вариант ответа или жми отмену для начала"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			else
				return FALSE
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "Голосование за [mode] начато [initiator || "CentCom"]."
		if(mode == "что-то")
			text += "\n[question]"
		log_vote(text)
		var/vp = CONFIG_GET(number/vote_period)
		to_chat(world, "\n<font color='purple'><b>[text]</b>\nЖми на большую кнопку <b>Голосуй!</b> или кликни <a href='byond://winset?command=vote'>сюда</a>, чтобы разместить свой голос.\nУ тебя есть [DisplayTimeText(vp)].</font>")
		time_remaining = round(vp/10)
		for(var/c in GLOB.clients)
			var/client/C = c
			var/datum/action/vote/V = new
			if(question)
				V.name = "Голос: [question]"
			C.player_details.player_actions += V
			V.Grant(C.mob)
			generated_actions += V
			if(C.prefs.toggles & SOUND_ANNOUNCEMENTS)
				SEND_SOUND(C, sound('sound/misc/bloop.ogg'))
		return TRUE
	return FALSE

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"
	SSvote.ui_interact(usr)

/datum/controller/subsystem/vote/ui_state()
	return GLOB.always_state

/datum/controller/subsystem/vote/ui_interact(mob/user, datum/tgui/ui)
	// Tracks who is voting
	if(!(user.client?.ckey in voting))
		voting += user.client?.ckey
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vote")
		ui.open()

/datum/controller/subsystem/vote/ui_data(mob/user)
	var/list/data = list(
		"allow_vote_map" = CONFIG_GET(flag/allow_vote_map),
		"allow_vote_mode" = CONFIG_GET(flag/allow_vote_mode),
		"allow_vote_restart" = CONFIG_GET(flag/allow_vote_restart),
		"choices" = list(),
		"lower_admin" = !!user.client?.holder,
		"mode" = mode,
		"question" = question,
		"selected_choice" = choice_by_ckey[user.client?.ckey],
		"time_remaining" = time_remaining,
		"upper_admin" = check_rights_for(user.client, R_ADMIN),
		"voting" = list(),
	)

	if(!!user.client?.holder)
		data["voting"] = voting

	for(var/key in choices)
		data["choices"] += list(list(
			"name" = key,
			"votes" = choices[key] || 0
		))

	return data

/datum/controller/subsystem/vote/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/upper_admin = FALSE
	if(usr.client.holder)
		if(check_rights_for(usr.client, R_ADMIN))
			upper_admin = TRUE

	switch(action)
		if("cancel")
			if(usr.client.holder)
				usr.log_message("[key_name_admin(usr)] cancelled a vote.", LOG_ADMIN)
				message_admins("[key_name_admin(usr)] has cancelled the current vote.")
				reset()
		if("toggle_restart")
			if(usr.client.holder && upper_admin)
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
		if("toggle_gamemode")
			if(usr.client.holder && upper_admin)
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))
		if("toggle_map")
			if(usr.client.holder && upper_admin)
				CONFIG_SET(flag/allow_vote_map, !CONFIG_GET(flag/allow_vote_map))
		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || usr.client.holder)
				initiate_vote("перезапуск",usr.key)
		if("gamemode")
			if(CONFIG_GET(flag/allow_vote_mode) || usr.client.holder)
				initiate_vote("режим",usr.key)
		if("map")
			if(CONFIG_GET(flag/allow_vote_map) || usr.client.holder)
				initiate_vote("карту",usr.key)
		if("custom")
			if(usr.client.holder)
				initiate_vote("что-то",usr.key)
		if("vote")
			submit_vote(round(text2num(params["index"])))
	return TRUE

/datum/controller/subsystem/vote/proc/remove_action_buttons()
	for(var/v in generated_actions)
		var/datum/action/vote/V = v
		if(!QDELETED(V))
			V.remove_from_client()
			V.Remove(V.owner)
	generated_actions = list()

/datum/controller/subsystem/vote/ui_close(mob/user, datum/tgui/tgui)
	voting -= user.client?.ckey

/datum/action/vote
	name = "Голосуй!"
	button_icon_state = "vote"
	show_to_observers = FALSE

/datum/action/vote/Trigger(trigger_flags)
	if(owner)
		owner.vote()
		remove_from_client()
		Remove(owner)

/datum/action/vote/IsAvailable(feedback = FALSE)
	return TRUE

/datum/action/vote/proc/remove_from_client()
	if(!owner)
		return
	if(owner.client)
		owner.client.player_details.player_actions -= src
	else if(owner.ckey)
		var/datum/player_details/P = GLOB.player_details[owner.ckey]
		if(P)
			P.player_actions -= src
