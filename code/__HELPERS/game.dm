
#define CULT_POLL_WAIT 2400

/proc/get_area_name(atom/X, format_text = FALSE)
	var/area/A = isarea(X) ? X : get_area(X)
	if(!A)
		return null
	return format_text ? format_text(A.name) : A.name

//We used to use linear regression to approximate the answer, but Mloc realized this was actually faster.
//And lo and behold, it is, and it's more accurate to boot.
/proc/cheap_hypotenuse(Ax,Ay,Bx,By)
	return sqrt(abs(Ax - Bx)**2 + abs(Ay - By)**2) //A squared + B squared = C squared

/** recursive_organ_check
 * inputs: O (object to start with)
 * outputs:
 * description: A pseudo-recursive loop based off of the recursive mob check, this check looks for any organs held
 *				 within 'O', toggling their frozen flag. This check excludes items held within other safe organ
 *				 storage units, so that only the lowest level of container dictates whether we do or don't decompose
 */
/proc/recursive_organ_check(atom/O)

	var/list/processing_list = list(O)
	var/list/processed_list = list()
	var/index = 1
	var/obj/item/organ/found_organ

	while(index <= length(processing_list))

		var/atom/A = processing_list[index]

		if(istype(A, /obj/item/organ))
			found_organ = A
			found_organ.organ_flags ^= ORGAN_FROZEN

		else if(istype(A, /mob/living/carbon))
			var/mob/living/carbon/Q = A
			for(var/organ in Q.internal_organs)
				found_organ = organ
				found_organ.organ_flags ^= ORGAN_FROZEN

		for(var/atom/B in A)	//objects held within other objects are added to the processing list, unless that object is something that can hold organs safely
			if(!processed_list[B] && !istype(B, /obj/structure/closet/crate/freezer) && !istype(B, /obj/structure/closet/secure_closet/freezer))
				processing_list+= B

		index++
		processed_list[A] = A

	return

/proc/try_move_adjacent(atom/movable/AM, trydir)
	var/turf/T = get_turf(AM)
	if(trydir)
		if(AM.Move(get_step(T, trydir)))
			return TRUE
	for(var/direction in (GLOB.cardinals-trydir))
		if(AM.Move(get_step(T, direction)))
			return TRUE
	return FALSE

/proc/get_mob_by_key(key)
	var/ckey = ckey(key)
	for(var/i in GLOB.player_list)
		var/mob/M = i
		if(M.ckey == ckey)
			return M
	return null

/proc/considered_alive(datum/mind/M, enforce_human = TRUE)
	if(M?.current)
		if(enforce_human)
			return M.current.stat != DEAD && !HAS_TRAIT(M, MIND_TRAIT_OBJECTIVE_DEAD) && !issilicon(M.current) && !isbrain(M.current)
		else if(isliving(M.current))
			return M.current.stat != DEAD && !HAS_TRAIT(M, MIND_TRAIT_OBJECTIVE_DEAD)
	return FALSE

/**
 * Exiled check
 *
 * Checks if the current body of the mind has an exile implant and is currently in
 * an away mission. Returns FALSE if any of those conditions aren't met.
 */
/proc/considered_exiled(datum/mind/M)
	if(!ishuman(M?.current))
		return FALSE
	for(var/obj/item/implant/I in M.current.implants)
		if(istype(I, /obj/item/implant/exile && M.current.onAwayMission()))
			return TRUE

/proc/considered_afk(datum/mind/M)
	return !M || !M.current || !M.current.client || M.current.client.is_afk()

/proc/ScreenText(obj/O, maptext="", screen_loc="CENTER-7,CENTER-7", maptext_height=480, maptext_width=480)
	if(!isobj(O))
		O = new /atom/movable/screen/text()
	O.maptext = MAPTEXT(maptext)
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/// Removes an image from a client's `.images`. Useful as a callback.
/proc/remove_image_from_client(image/image_to_remove, client/remove_from)
	remove_from?.images -= image_to_remove

///Like remove_image_from_client, but will remove the image from a list of clients
/proc/remove_images_from_clients(image/image_to_remove, list/show_to)
	for(var/client/remove_from in show_to)
		remove_from.images -= image_to_remove

///Add an image to a list of clients and calls a proc to remove it after a duration
/proc/flick_overlay(image/image_to_show, list/show_to, duration)
	for(var/client/add_to in show_to)
		add_to.images += image_to_show
	addtimer(CALLBACK(GLOBAL_PROC, /proc/remove_images_from_clients, image_to_show, show_to), duration, TIMER_CLIENT_TIME)

///wrapper for flick_overlay(), flicks to everyone who can see the target atom
/proc/flick_overlay_view(image/image_to_show, atom/target, duration)
	var/list/viewing = list()
	for(var/mob/viewer as anything in viewers(target))
		if(viewer.client)
			viewing += viewer.client
	flick_overlay(image_to_show, viewing, duration)

/proc/get_active_player_count(alive_check = 0, afk_check = 0, human_check = 0)
	// Get active players who are playing in the round
	var/active_players = 0
	for(var/i = 1; i <= GLOB.player_list.len; i++)
		var/mob/M = GLOB.player_list[i]
		if(M?.client)
			if(alive_check && M.stat)
				continue
			else if(afk_check && M.client.is_afk())
				continue
			else if(human_check && !ishuman(M))
				continue
			else if(isnewplayer(M)) // exclude people in the lobby
				continue
			else if(isobserver(M)) // Ghosts are fine if they were playing once (didn't start as observers)
				var/mob/dead/observer/O = M
				if(O.started_as_observer) // Exclude people who started as observers
					continue
			active_players++
	return active_players

///Show the poll window to the candidate mobs
/proc/show_candidate_poll_window(mob/candidate_mob, poll_time, question, list/candidates, ignore_category, time_passed, flashwindow = TRUE)
	set waitfor = 0

	SEND_SOUND(candidate_mob, 'sound/misc/notice2.ogg') //Alerting them to their consideration
	if(flashwindow)
		window_flash(candidate_mob.client)
	var/list/answers = ignore_category ? list("Да", "Нет", "Никогда") : list("Да", "Нет")
	switch(tgui_alert(candidate_mob, question, "Предложение получить новое тело!", answers, poll_time))
		if("Да")
			to_chat(candidate_mob, span_notice("Выбираем: Да."))
			if(time_passed + poll_time <= world.time)
				to_chat(candidate_mob, span_danger("СЛИШКОМ ПОЗДНО!"))
				SEND_SOUND(candidate_mob, 'white/valtos/sounds/error1.ogg')
				candidates -= candidate_mob
			else
				candidates += candidate_mob
		if("Нет")
			to_chat(candidate_mob, span_danger("Выбираем: Нет."))
			candidates -= candidate_mob
		if("Никогда")
			var/list/ignore_list = GLOB.poll_ignore[ignore_category]
			if(!ignore_list)
				GLOB.poll_ignore[ignore_category] = list()
			GLOB.poll_ignore[ignore_category] += candidate_mob.ckey
			to_chat(candidate_mob, span_danger("Выбираем: Не спрашиваем до конца раунда."))
			candidates -= candidate_mob
		else
			candidates -= candidate_mob

///Wrapper to send all ghosts the poll to ask them if they want to be considered for a mob.
/proc/poll_ghost_candidates(question, jobban_type, be_special_flag = 0, poll_time = 300, ignore_category = null, flashwindow = TRUE)
	var/list/candidates = list()
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		return candidates

	for(var/mob/dead/observer/ghost_player in GLOB.player_list)
		candidates += ghost_player

	return poll_candidates(question, jobban_type, be_special_flag, poll_time, ignore_category, flashwindow, candidates)

/proc/poll_candidates(question, jobban_type, be_special_flag = 0, poll_time = 300, ignore_category = null, flashwindow = TRUE, list/group = null)
	var/time_passed = world.time
	if (!question)
		question = "Хочешь получить специальную роль?"
	var/list/result = list()
	for(var/candidate in group)
		var/mob/candidate_mob = candidate
		if(!candidate_mob.key || !candidate_mob.client || (ignore_category && GLOB.poll_ignore[ignore_category] && (candidate_mob.ckey in GLOB.poll_ignore[ignore_category])))
			continue
		if(be_special_flag)
			if(!(candidate_mob.client.prefs) || !(be_special_flag in candidate_mob.client.prefs.be_special))
				continue

			var/required_time = GLOB.special_roles[be_special_flag] || 0
			if (candidate_mob.client && candidate_mob.client.get_remaining_days(required_time) > 0)
				continue
		if(jobban_type)
			if(is_banned_from(candidate_mob.ckey, list(jobban_type, ROLE_SYNDICATE)) || QDELETED(candidate_mob))
				continue

		show_candidate_poll_window(candidate_mob, poll_time, question, result, ignore_category, time_passed, flashwindow)
	sleep(poll_time)

	//Check all our candidates, to make sure they didn't log off or get deleted during the wait period.
	for(var/mob/asking_mob in result)
		if(!asking_mob.key || !asking_mob.client)
			result -= asking_mob

	list_clear_nulls(result)

	return result

/**
 * Returns a list of ghosts that are eligible to take over and wish to be considered for a mob.
 *
 * Arguments:
 * * question - Question to show players as part of poll
 * * jobban_type - Type of jobban to use to filter out potential candidates.
 * * be_special_flag - Unknown/needs further documentation.
 * * poll_time - Length of time in deciseconds that the poll input box exists before closing.
 * * target_mob - The mob that is being polled for.
 * * ignore_category - Unknown/needs further documentation.
 */
/proc/poll_candidates_for_mob(question, jobban_type, be_special_flag = 0, poll_time = 30 SECONDS, mob/target_mob, ignore_category = null)
	var/static/list/mob/currently_polling_mobs = list()

	if(currently_polling_mobs.Find(target_mob))
		return list()

	currently_polling_mobs += target_mob

	var/list/possible_candidates = poll_ghost_candidates(question, jobban_type, be_special_flag, poll_time, ignore_category)

	currently_polling_mobs -= target_mob
	if(!target_mob || QDELETED(target_mob) || !target_mob.loc)
		return list()

	return possible_candidates

/**
 * Returns a list of ghosts that are eligible to take over and wish to be considered for a mob.
 *
 * Arguments:
 * * question - Question to show players as part of poll
 * * jobban_type - Type of jobban to use to filter out potential candidates.
 * * be_special_flag - Unknown/needs further documentation.
 * * poll_time - Length of time in deciseconds that the poll input box exists before closing.
 * * mobs - The list of mobs being polled for. This list is mutated and invalid mobs are removed from it before the proc returns.
 * * ignore_category - Unknown/needs further documentation.
 */
/proc/poll_candidates_for_mobs(question, jobban_type, be_special_flag = 0, poll_time = 30 SECONDS, list/mobs, ignore_category = null)
	var/list/candidate_list = poll_ghost_candidates(question, jobban_type, be_special_flag, poll_time, ignore_category)

	for(var/mob/potential_mob as anything in mobs)
		if(QDELETED(potential_mob) || !potential_mob.loc)
			mobs -= potential_mob

	if(!length(mobs))
		return list()

	return candidate_list

/proc/make_body(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)
		return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new//The mob being spawned.
	SSjob.SendToLateJoin(new_character)

	G_found.client.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	new_character.key = G_found.key

	return new_character

/proc/send_to_playing_players(thing) //sends a whatever to all playing players; use instead of to_chat(world, where needed)
	for(var/M in GLOB.player_list)
		if(M && !isnewplayer(M))
			to_chat(M, thing)

/proc/window_flash(client/C, ignorepref = FALSE)
	if(ismob(C))
		var/mob/M = C
		if(M.client)
			C = M.client
	if(!C || (!C.prefs.windowflashing && !ignorepref))
		return
	winset(C, "mainwindow", "flash=5")

//Recursively checks if an item is inside a given type, even through layers of storage. Returns the atom if it finds it.
/proc/recursive_loc_check(atom/movable/target, type)
	var/atom/A = target
	if(istype(A, type))
		return A

	while(!istype(A.loc, type))
		if(!A.loc)
			return
		A = A.loc

	return A.loc

/proc/AnnounceArrival(mob/living/carbon/human/character, rank)
	if(!SSticker.IsRoundInProgress() || QDELETED(character))
		return
	var/area/A = get_area(character)
	deadchat_broadcast(span_game(" прибывает на станцию в <span class='name'>[A.name]</span>.") , span_game("<span class='name'>[character.real_name]</span> ([ru_job_parse(rank)])") , follow_target = character, message_type=DEADCHAT_ARRIVALRATTLE)
	if(!character.mind)
		return
	if(!GLOB.announcement_systems.len)
		return
	if((character.mind.assigned_role == JOB_CYBORG) || (character.mind.assigned_role == JOB_BOMJ) || (character.mind.assigned_role == character.mind.special_role))
		return

	var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
	announcer.announce("ARRIVAL", character.real_name, rank, list()) //make the list empty to make it announce it in common

/proc/lavaland_equipment_pressure_check(turf/T)
	. = FALSE
	if(!istype(T))
		return
	var/datum/gas_mixture/environment = T.return_air()
	if(!istype(environment))
		return
	var/pressure = environment.return_pressure()
	if(pressure <= LAVALAND_EQUIPMENT_EFFECT_PRESSURE)
		. = TRUE

/proc/ispipewire(item)
	var/static/list/pire_wire = list(
		/obj/machinery/atmospherics,
		/obj/structure/disposalpipe,
		/obj/structure/cable
	)
	return (is_type_in_list(item, pire_wire))

// Find an obstruction free turf that's within the range of the center. Can also condition on if it is of a certain area type.
/proc/find_obstruction_free_location(range, atom/center, area/specific_area)
	var/list/turfs = RANGE_TURFS(range, center)
	var/list/possible_loc = list()

	for(var/turf/found_turf as anything in turfs)
		var/area/turf_area = get_area(found_turf)

		// We check if both the turf is a floor, and that it's actually in the area.
		// We also want a location that's clear of any obstructions.
		if (specific_area)
			if (!istype(turf_area, specific_area))
				continue

		if (!isspaceturf(found_turf))
			if (!found_turf.is_blocked_turf())
				possible_loc.Add(found_turf)

	// Need at least one free location.
	if (possible_loc.len < 1)
		return FALSE

	return pick(possible_loc)

/proc/power_fail(duration_min, duration_max)
	for(var/P in GLOB.apcs_list)
		var/obj/machinery/power/apc/C = P
		if(C.cell && SSmapping.level_trait(C.z, ZTRAIT_STATION))
			var/area/A = C.area
			if(GLOB.typecache_powerfailure_safe_areas[A.type])
				continue

			C.energy_fail(rand(duration_min,duration_max))

/**
 * Poll all mentor ghosts for looking for a candidate
 *
 * Poll all mentor ghosts a question
 * returns people who voted yes in a list
 * Arguments:
 * * question: String, what do you want to ask them
 * * jobbanType: List, Which roles/jobs to exclude from being asked
 * * be_special_flag: Bool, Only notify ghosts with special antag on
 * * poll_time: Integer, How long to poll for in deciseconds(0.1s)
 * * ignore_category: Define, ignore_category: People with this category(defined in poll_ignore.dm) turned off dont get the message
 * * flashwindow: Bool, Flash their window to grab their attention
 */
/proc/poll_mentor_ghost_candidates(question, jobbanType, be_special_flag = 0, poll_time = 300, ignore_category = null, flashwindow = TRUE)
	var/list/candidates = list()
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		return candidates

	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.client.is_mentor())
			candidates += G

	return poll_candidates(question, jobbanType, be_special_flag, poll_time, ignore_category, flashwindow, candidates)

/**
 * Poll mentor ghosts to take control of a mob
 *
 * Poll mentor ghosts for mob control
 * returns people who voted yes in a list
 * Arguments:
 * * question: String, what do you want to ask them
 * * jobbanType: List, Which roles/jobs to exclude from being asked
 * * be_special_flag: Bool, Only notify ghosts with special antag on
 * * poll_time: Integer, How long to poll for in deciseconds(0.1s)
 * * M: Mob, /mob to offer
 * * ignore_category: Unknown
 */
/proc/poll_mentor_candidates_for_mob(question, jobbanType, be_special_flag = 0, poll_time = 300, mob/M, ignore_category = null)
	var/list/L = poll_mentor_ghost_candidates(question, jobbanType, be_special_flag, poll_time, ignore_category)
	if(!M || QDELETED(M) || !M.loc)
		return list()
	return L
