/mob/dead/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.

	flags_1 = NONE

	invisibility = INVISIBILITY_ABSTRACT

	see_invisible = 26

	density = FALSE
	stat = DEAD
	hud_type = /datum/hud/new_player
	hud_possible = list()

	var/mob/living/new_character	//for instant transfer once the round is set up

	//Used to make sure someone doesn't get spammed with messages if they're ineligible for roles
	var/ineligible_for_roles = FALSE

/mob/dead/new_player/Initialize(mapload)
	if(client && SSticker.state == GAME_STATE_STARTUP)
		var/atom/movable/screen/splash/S = new(client, TRUE, TRUE)
		S.Fade(TRUE)

	if(length(GLOB.newplayer_start))
		forceMove(pick(GLOB.newplayer_start))
	else
		forceMove(locate(1,1,1))

	ComponentInitialize()

	. = ..()

	GLOB.new_player_list += src

/mob/dead/new_player/Destroy()
	GLOB.new_player_list -= src
	return ..()

/mob/dead/new_player/prepare_huds()
	return

/mob/dead/new_player/Topic(href, href_list[])
	if(src != usr)
		return

	if(!client)
		return

	if(!client.prefs.iconsent)
		src << browse(file2text('html/newcomer.html'), "window=newcomer;size=665x525;border=0;can_minimize=0;can_close=0;can_resize=0")
		to_chat(src, span_notice("Необходимо дать согласие, перед тем как вступить в игру."))
		return FALSE

	if(href_list["violence"] && SSviolence.active)
		if(href_list["violence"] == "joinmefucker")
			var/datum/violence_player/VP = SSviolence.players?[ckey]
			if(VP?.role_name && SSviolence.playmode != VIOLENCE_PLAYMODE_TAG)
				usr << browse(null, "window=violence")
				AttemptLateSpawn(VP.role_name)
			else
				usr << browse(null, "window=violence")
				var/suggested_team = pick(list(JOB_COMBATANT_RED, JOB_COMBATANT_BLUE))
				if(LAZYLEN(SSviolence.blue_team) > LAZYLEN(SSviolence.red_team))
					suggested_team = JOB_COMBATANT_RED
				if(LAZYLEN(SSviolence.red_team) > LAZYLEN(SSviolence.blue_team))
					suggested_team = JOB_COMBATANT_BLUE
				VP.role_name = suggested_team
				AttemptLateSpawn(suggested_team)
			return
		if(GLOB.violence_gear_datums[href_list["violence"]])
			var/datum/violence_gear/VG = GLOB.violence_gear_datums[href_list["violence"]]
			var/datum/violence_player/VP = SSviolence.players[ckey]
			if(VP.money >= VG.cost)
				VP.money -= VG.cost
				VP.loadout_items += VG
				SEND_SOUND(usr, pick(list('white/valtos/sounds/coin1.ogg', 'white/valtos/sounds/coin2.ogg', 'white/valtos/sounds/coin3.ogg')))
				to_chat(usr, span_notice("Куплено <b>[VG.name]</b> за [VG.cost]₽!"))
			else
				to_chat(usr, span_boldwarning("Недостаточно средств."))
			violence_choices()
		return

	if(href_list["late_join"]) //This still exists for queue messages in chat
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, span_boldwarning("Раунд ещё не начался или уже завершился..."))
			return
		LateChoices()

	if(href_list["SelectedJob"])
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, span_danger("Раунд ещё не начался или уже завершился..."))
			return

		if(SSlag_switch.measures[DISABLE_NON_OBSJOBS])
			to_chat(usr, span_notice("Нельзя!"))
			return

		//Determines Relevent Population Cap
		var/relevant_cap
		var/hpc = CONFIG_GET(number/hard_popcap)
		var/epc = CONFIG_GET(number/extreme_popcap)
		if(hpc && epc)
			relevant_cap = min(hpc, epc)
		else
			relevant_cap = max(hpc, epc)

		if(SSticker.queued_players.len && !(ckey(key) in GLOB.admin_datums))
			if((living_player_count() >= relevant_cap) || (src != SSticker.queued_players[1]))
				to_chat(usr, span_warning("Полновато здесь."))
				return

		AttemptLateSpawn(href_list["SelectedJob"])
		return

	if(href_list["viewpoll"])
		var/datum/poll_question/poll = locate(href_list["viewpoll"]) in GLOB.polls
		poll_player(poll)

	if(href_list["votepollref"])
		var/datum/poll_question/poll = locate(href_list["votepollref"]) in GLOB.polls
		vote_on_poll_handler(poll, href_list)

//When you cop out of the round (NB: this HAS A SLEEP FOR PLAYER INPUT IN IT)
/mob/dead/new_player/proc/make_me_an_observer(force_observe=FALSE)
	if(QDELETED(src) || !src.client)
		ready = PLAYER_NOT_READY
		return FALSE

	if(!client.prefs.iconsent)
		src << browse(file2text('html/newcomer.html'), "window=newcomer;size=665x525;border=0;can_minimize=0;can_close=0;can_resize=0")
		to_chat(src, span_notice("Необходимо дать согласие, перед тем как вступить в игру."))
		return FALSE

	var/less_input_message
	if(SSlag_switch.measures[DISABLE_DEAD_KEYLOOP])
		less_input_message = " - Заметка: Призраки на данный момент ограничены."

	if(QDELETED(src) || !src.client || !force_observe && tgui_alert(usr, "Действительно хочешь следить? У меня не будет возможности зайти в этот раунд (исключая частые ивенты и спаунеры)![less_input_message]","Странный господин",list("Да","Нет")) != "Да")
		ready = PLAYER_NOT_READY
		src << browse(null, "window=playersetup") //closes the player setup window
		return FALSE

	var/mob/dead/observer/observer = new()
	spawning = TRUE

	client.kill_lobby()

	observer.started_as_observer = TRUE
	close_spawn_windows()
	var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	to_chat(src, span_notice("Телепортируемся! Аспект: [SSaspects.ca_desc]"))
	if (O)
		observer.forceMove(O.loc)
	else
		to_chat(src, span_notice("Что-то сломалось и тебя забросило немного не там, где нужно. Ничего страшного."))
		stack_trace("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")
	observer.key = key
	observer.client = client
	observer.set_ghost_appearance()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.real_name
		observer.name = observer.real_name
		observer.client.init_verbs()
	observer.update_icon()
	observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	deadchat_broadcast(" становится призраком.", "<b>[observer.real_name]</b>", follow_target = observer, turf_target = get_turf(observer), message_type = DEADCHAT_DEATHRATTLE)
	QDEL_NULL(mind)
	qdel(src)

	SStitle.update_lobby()

	return TRUE

/proc/get_job_unavailable_error_message(retval, jobtitle)
	switch(retval)
		if(JOB_AVAILABLE)
			return "[jobtitle] доступен."
		if(JOB_UNAVAILABLE_GENERIC)
			return "[jobtitle] недоступен."
		if(JOB_UNAVAILABLE_BANNED)
			return "Тебе нельзя быть [jobtitle]."
		if(JOB_UNAVAILABLE_UNBUYED)
			return "Роль [jobtitle] сначала нужно купить."
		if(JOB_UNAVAILABLE_WHITELIST)
			return "Для доступа к роли нужна запись в вайтлисте."
		if(JOB_UNAVAILABLE_PLAYTIME)
			return "Ты не наиграл достаточно времени для [jobtitle]."
		if(JOB_UNAVAILABLE_ACCOUNTAGE)
			return "Твой аккаунт слишком молодой для [jobtitle]."
//		if(JOB_UNAVAILABLE_ACCOUNT_OLD)
//			return "Твой аккаунт слишком стар для [jobtitle]."
		if(JOB_UNAVAILABLE_SLOTFULL)
			return "[jobtitle] уже достаточно на станции."
		if(JOB_UNAVAILABLE_LOCKED)
			return "Нельзя менять команду."
	return "Error: Unknown job availability."

/mob/dead/new_player/proc/IsJobUnavailable(rank, latejoin = FALSE)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return JOB_UNAVAILABLE_GENERIC
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		if(job.title == JOB_ASSISTANT && !SSviolence.active)
			if(isnum(client.player_age) && client.player_age <= 14) //Newbies can always be assistants
				return JOB_AVAILABLE
			for(var/datum/job/J in SSjob.occupations)
				if(J && J.current_positions < J.total_positions && J.title != job.title)
					return JOB_UNAVAILABLE_SLOTFULL
		else
			return JOB_UNAVAILABLE_SLOTFULL
	if(is_banned_from(ckey, rank))
		return JOB_UNAVAILABLE_BANNED
	if(QDELETED(src))
		return JOB_UNAVAILABLE_GENERIC
	if(!job.player_old_enough(client))
		return JOB_UNAVAILABLE_ACCOUNTAGE
//	if(!job.not_available_in_days(client))
//		return JOB_UNAVAILABLE_ACCOUNT_OLD
	if(job.required_playtime_remaining(client))
		return JOB_UNAVAILABLE_PLAYTIME
	if(latejoin && !job.special_check_latejoin(client))
		return JOB_UNAVAILABLE_GENERIC
	if(job.metalocked && !(job.type in client.prefs.jobs_buyed))
		return JOB_UNAVAILABLE_UNBUYED
	if(LAZYLEN(job.whitelisted) && !(ckey in job.whitelisted))
		return JOB_UNAVAILABLE_UNBUYED
//	if(!job.allow_new_players && !check_whitelist(ckey))
//		return JOB_UNAVAILABLE_WHITELIST
	if(SSviolence.active)
		var/datum/violence_player/VP = SSviolence.players?[ckey]
		if(VP?.role_name != rank)
			return JOB_UNAVAILABLE_LOCKED
	return JOB_AVAILABLE

/mob/dead/new_player/proc/AttemptLateSpawn(rank)
	var/error = IsJobUnavailable(rank)
	if(error != JOB_AVAILABLE)
		tgui_alert(usr, get_job_unavailable_error_message(error, rank))
		return FALSE

	var/arrivals_docked = TRUE
	if(SSshuttle.arrivals)
		close_spawn_windows()	//In case we get held up
		if(SSshuttle.arrivals.damaged && CONFIG_GET(flag/arrivals_shuttle_require_safe_latejoin))
			src << tgui_alert(usr,"Шаттл прибытия сломан! Ожидай, когда его починят.")
			return FALSE

		if(CONFIG_GET(flag/arrivals_shuttle_require_undocked))
			SSshuttle.arrivals.RequireUndocked(src)
		arrivals_docked = SSshuttle.arrivals.mode != SHUTTLE_CALL

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	SSjob.AssignRole(src, rank, 1)

	var/mob/living/character = create_character(TRUE) //creates the human and transfers vars and mind

	var/is_captain = FALSE
	// If we don't have an assigned cap yet, check if this person qualifies for some from of captaincy.
	if(!SSjob.assigned_captain && ishuman(character) && SSjob.chain_of_command[rank] && !is_banned_from(ckey, list(JOB_CAPTAIN)))
		is_captain = TRUE
	// If we already have a captain, are they a JOB_CAPTAIN rank and are we allowing multiple of them to be assigned?
	else if(SSjob.always_promote_captain_job && (rank == JOB_CAPTAIN))
		is_captain = TRUE

	var/equip = SSjob.EquipRank(character, rank, TRUE, is_captain)
	if(isliving(equip)) //Borgs get borged in the equip, so we need to make sure we handle the new mob.
		character = equip

	var/datum/job/job = SSjob.GetJob(rank)

	if(job && !job.override_latejoin_spawn(character))
		SSjob.SendToLateJoin(character)
		if(!arrivals_docked && !SSviolence.active)
			var/atom/movable/screen/splash/Spl = new(character.client, TRUE)
			Spl.Fade(TRUE)
			character.playsound_local(get_turf(character), 'sound/ai/announcer/hello_crew.ogg', 25)

		character.update_parallax_teleport()

	SSticker.minds += character.mind
	character.client.init_verbs() // init verbs for the late join
	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character	//Let's retypecast the var to be human,

	if(humanc)	//These procs all expect humans
		GLOB.data_core.manifest_inject(humanc)
		if(SSshuttle.arrivals)
			SSshuttle.arrivals.QueueAnnounce(humanc, rank)
		else
			AnnounceArrival(humanc, rank)
		AddEmploymentContract(humanc)
		if(GLOB.highlander)
			to_chat(humanc, span_userdanger("<i>THERE CAN BE ONLY ONE!!!</i>"))
			humanc.make_scottish()

		humanc.increment_scar_slot()
		humanc.load_persistent_scars()

		if(GLOB.curse_of_madness_triggered)
			give_madness(humanc, GLOB.curse_of_madness_triggered)

	GLOB.joined_player_list += character.ckey

	if(CONFIG_GET(flag/allow_latejoin_antagonists) && humanc)	//Borgs aren't allowed to be antags. Will need to be tweaked if we get true latejoin ais.
		if(SSshuttle.emergency)
			switch(SSshuttle.emergency.mode)
				if(SHUTTLE_RECALL, SHUTTLE_IDLE)
					SSticker.mode.make_antag_chance(humanc)
				if(SHUTTLE_CALL)
					if(SSshuttle.emergency.timeLeft(1) > initial(SSshuttle.emergencyCallTime)*0.5)
						SSticker.mode.make_antag_chance(humanc)

	if(humanc && CONFIG_GET(flag/roundstart_traits))
		SSquirks.AssignQuirks(humanc, humanc.client, TRUE)

	if(humanc && SSaspects.current_aspect)
		to_chat(humanc, "\n<span class='notice'><B>[gvorno(TRUE)]:</B> [SSaspects.current_aspect.desc]</span><BR> ")

	SStitle.update_lobby()

	log_manifest(character.mind.key, character.mind, character, latejoin = TRUE)

	humanc?.client?.show_area_description(30)

/mob/dead/new_player/proc/AddEmploymentContract(mob/living/carbon/human/employee)
	//TODO:  figure out a way to exclude wizards/nukeops/demons from this.
	for(var/C in GLOB.employmentCabinets)
		var/obj/structure/filingcabinet/employment/employmentCabinet = C
		if(!employmentCabinet.virgin)
			employmentCabinet.addFile(employee)


/mob/dead/new_player/proc/LateChoices()
	var/list/dat = list()
	if(SSlag_switch.measures[DISABLE_NON_OBSJOBS])
		dat += "<div class='notice red' style='font-size: 125%'>Разрешено только следить на данный момент.</div><br>"
	dat += "<div class='notice'>Длительность раунда: [DisplayTimeText(world.time - SSticker.round_start_time)]</div>"
	if(SSshuttle.emergency)
		switch(SSshuttle.emergency.mode)
			if(SHUTTLE_ESCAPE)
				dat += "<div class='notice red'>Станция эвакуирована.</div><br>"
			if(SHUTTLE_CALL)
				if(!SSshuttle.canRecall())
					dat += "<div class='notice red'>Станция готовится к эвакуации.</div><br>"
	for(var/datum/job/prioritized_job in SSjob.prioritized_jobs)
		if(prioritized_job.current_positions >= prioritized_job.total_positions)
			SSjob.prioritized_jobs -= prioritized_job
	dat += "<table><tr><td valign='top'>"
	var/column_counter = 0
	// render each category's available jobs
	for(var/category in GLOB.position_categories)
		// position_categories contains category names mapped to available jobs and an appropriate color
		var/cat_color = GLOB.position_categories[category]["color"]
		dat += "<fieldset style='width: 252px; border: 2px solid [cat_color]; display: inline'>"
		dat += "<legend align='center' style='color: #ffffff;'>[GLOB.position_categories[category]["runame"]]</legend>"
		var/list/dept_dat = list()
		for(var/job in GLOB.position_categories[category]["jobs"])
			var/datum/job/job_datum = SSjob.name_occupations[job]
			if(job_datum && IsJobUnavailable(job_datum.title, TRUE) == JOB_AVAILABLE)
				var/command_bold = ""
				if(job in GLOB.command_positions)
					command_bold = " command"
				if(job_datum in SSjob.prioritized_jobs)
					dept_dat += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'><span class='priority'>[ru_job_parse(job_datum.title)] <span class='rightround'>[display_positions(job_datum)]</span></span></a>"
				else
					dept_dat += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'>[ru_job_parse(job_datum.title)] <span class='rightround'>[display_positions(job_datum)]</span></a>"
		if(!dept_dat.len)
			dept_dat += span_nopositions("Нет свободных позиций.")
		dat += jointext(dept_dat, "")
		dat += "</fieldset><br>"
		column_counter++
		if(column_counter > 0 && (column_counter % 3 == 0))
			dat += "</td><td valign='top'>"
	dat += "</td></tr></table></center>"
	dat += "</div></div>"
	var/ww = 880
	var/hh = 750
	if(SSviolence.active)
		ww = 289
		hh = 300
	var/datum/browser/popup = new(src, "latechoices", "Выбери профессию", ww, hh)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/dead/new_player/proc/display_positions(datum/job/job_datum)
	if(job_datum.total_positions == -1 || job_datum.total_positions > 8)
		return "[job_datum.current_positions]/∞"
	var/generated_text = ""
	var/open_positions = job_datum.total_positions - job_datum.current_positions
	if(open_positions)
		for(var/CP in 1 to open_positions)
			generated_text += " ⬜"
	for(var/OP in 1 to job_datum.current_positions)
		generated_text += " ⬛"
	return generated_text

/mob/dead/new_player/proc/create_character(transfer_after)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/H = new(loc)

	var/frn = CONFIG_GET(flag/force_random_names)
	var/admin_anon_names = SSticker.anonymousnames
	if(!frn)
		frn = is_banned_from(ckey, "Appearance")
		if(QDELETED(src))
			return
	if(frn)
		client.prefs.random_character()
		client.prefs.real_name = client.prefs.pref_species.random_name(gender,1)

	if(admin_anon_names)//overrides random name because it achieves the same effect and is an admin enabled event tool
		client.prefs.random_character()
		client.prefs.real_name = anonymous_name(src)

	var/is_antag
	if(mind in GLOB.pre_setup_antags)
		is_antag = TRUE

	client.prefs.copy_to(H, antagonist = is_antag, is_latejoiner = transfer_after)

	client.kill_lobby()

	H.dna.update_dna_identity()
	if(mind)
		if(transfer_after)
			mind.late_joiner = TRUE
		mind.active = FALSE					//we wish to transfer the key manually
		mind.original_character_slot_index = client.prefs.default_slot
		mind.transfer_to(H) //won't transfer key since the mind is not active
		mind.set_original_character(H)

	H.name = real_name
	client.init_verbs()
	. = H
	new_character = .
	if(transfer_after)
		transfer_character()

/mob/dead/new_player/proc/transfer_character()
	. = new_character
	if(.)
		new_character.key = key		//Manually transfer the key to log them in,
		new_character.stop_sound_channel(CHANNEL_LOBBYMUSIC)
		new_character = null
		qdel(src)

/mob/dead/new_player/proc/ViewManifest()
	if(!client)
		return
	if(world.time < client.crew_manifest_delay)
		return
	client.crew_manifest_delay = world.time + (1 SECONDS)

	if(!GLOB.crew_manifest_tgui)
		GLOB.crew_manifest_tgui = new /datum/crew_manifest(src)

	GLOB.crew_manifest_tgui.ui_interact(src)

/mob/dead/new_player/Move()
	return 0


/mob/dead/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
	src << browse(null, "window=preferences") //closes job selection
	src << browse(null, "window=mob_occupation")
	src << browse(null, "window=pdec")
	src << browse(null, "window=latechoices") //closes late job selection

// Used to make sure that a player has a valid job preference setup, used to knock players out of eligibility for anything if their prefs don't make sense.
// A "valid job preference setup" in this situation means at least having one job set to low, or not having "return to lobby" enabled
// Prevents "antag rolling" by setting antag prefs on, all jobs to never, and "return to lobby if preferences not available"
// Doing so would previously allow you to roll for antag, then send you back to lobby if you didn't get an antag role
// This also does some admin notification and logging as well, as well as some extra logic to make sure things don't go wrong
/mob/dead/new_player/proc/check_preferences()
	if(!client)
		return FALSE //Not sure how this would get run without the mob having a client, but let's just be safe.
	if(client.prefs.joblessrole != RETURNTOLOBBY)
		return TRUE
	// If they have antags enabled, they're potentially doing this on purpose instead of by accident. Notify admins if so.
	var/has_antags = FALSE
	if(client.prefs.be_special.len > 0)
		has_antags = TRUE
	if(client.prefs.job_preferences.len == 0)
		if(!ineligible_for_roles)
			to_chat(src, span_danger("You have no jobs enabled, along with return to lobby if job is unavailable. This makes you ineligible for any round start role, please update your job preferences."))
		ineligible_for_roles = TRUE
		ready = PLAYER_NOT_READY
		if(has_antags)
			log_admin("[src.ckey] just got booted back to lobby with no jobs, but antags enabled.")
			message_admins("[src.ckey] just got booted back to lobby with no jobs enabled, but antag rolling enabled. Likely antag rolling abuse.")

		return FALSE //This is the only case someone should actually be completely blocked from antag rolling as well
	return TRUE

/mob/dead/new_player/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	client.ooc(message)

/mob/dead/new_player/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	// Create map text prior to modifying message for goonchat
	if (client?.prefs.chat_on_map && (client.prefs.see_chat_non_mob || ismob(speaker)))
		create_chat_message(speaker, message_language, raw_message, spans)
