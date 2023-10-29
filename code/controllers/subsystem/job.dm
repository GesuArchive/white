SUBSYSTEM_DEF(job)
	name = "Jobs"
	init_order = INIT_ORDER_JOBS
	flags = SS_NO_FIRE

	var/list/occupations = list()		//List of all jobs
	var/list/datum/job/name_occupations = list()	//Dict of all jobs, keys are titles
	var/list/type_occupations = list()	//Dict of all jobs, keys are types
	var/list/unassigned = list()		//Players who need jobs
	var/initial_players_to_assign = 0 	//used for checking against population caps

	var/list/prioritized_jobs = list()
	var/list/latejoin_trackers = list()	//Don't read this list, use GetLateJoinTurfs() instead

	var/overflow_role = JOB_ASSISTANT

	var/list/level_order = list(JP_HIGH,JP_MEDIUM,JP_LOW)

	/// Lazylist of mob:occupation_string pairs.
	var/list/dynamic_forced_occupations

	/// List of all joinable departments indexed by their typepath, sorted by their own display order.
	var/list/datum/job_department/joinable_departments_by_type = list()

	/// A list of all jobs associated with the station. These jobs also have various icons associated with them including sechud and card trims.
	var/list/station_jobs
	/// A list of additional jobs that have various icons associated with them including sechud and card trims.
	var/list/additional_jobs_with_icons
	/// A list of jobs associed with Centcom and should use the standard NT Centcom icons.
	var/list/centcom_jobs

	/**
	 * Keys should be assigned job roles. Values should be >= 1.
	 * Represents the chain of command on the station. Lower numbers mean higher priority.
	 * Used to give the Cap's Spare safe code to a an appropriate player.
	 * Assumed Captain is always the highest in the chain of command.
	 * See [/datum/controller/subsystem/ticker/proc/equip_characters]
	 */
	var/list/chain_of_command = list(
		JOB_CAPTAIN = 1,
		JOB_HEAD_OF_PERSONNEL = 2,
		JOB_HEAD_OF_SECURITY = 3,
		JOB_RESEARCH_DIRECTOR = 4,
		JOB_CHIEF_ENGINEER = 5,
		JOB_CHIEF_MEDICAL_OFFICER = 6)

	/// If TRUE, some player has been assigned Captaincy or Acting Captaincy at some point during the shift and has been given the spare ID safe code.
	var/assigned_captain = FALSE
	/// If TRUE, the JOB_CAPTAIN job will always be given the code to the spare ID safe and always have a "Captain on deck!" announcement.
	var/always_promote_captain_job = TRUE
	// :^)
	var/forced_name = null
	var/forced_num = 1

/datum/controller/subsystem/job/Initialize()
	SSmapping.HACK_LoadMapConfig()
	setup_job_lists()
	if(!occupations.len)
		SetupOccupations()
	if(CONFIG_GET(flag/load_jobs_from_txt))
		LoadJobs()
	generate_selectable_species()
	set_overflow_role(CONFIG_GET(string/overflow_job))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/job/proc/set_overflow_role(new_overflow_role)
	var/datum/job/new_overflow = GetJob(new_overflow_role)
	var/cap = CONFIG_GET(number/overflow_cap)

	if(!new_overflow)
		return

	new_overflow.allow_bureaucratic_error = FALSE
	new_overflow.spawn_positions = cap
	new_overflow.total_positions = cap

	if(new_overflow_role != overflow_role)
		var/datum/job/old_overflow = GetJob(overflow_role)
		old_overflow.allow_bureaucratic_error = initial(old_overflow.allow_bureaucratic_error)
		old_overflow.spawn_positions = initial(old_overflow.spawn_positions)
		old_overflow.total_positions = initial(old_overflow.total_positions)
		overflow_role = new_overflow_role
		JobDebug("Overflow role set to : [new_overflow_role]")

/datum/controller/subsystem/job/proc/SetupOccupations(faction = "Station")
	occupations = list()
	var/list/all_jobs = subtypesof(/datum/job)
	if(!all_jobs.len)
		to_chat(world, span_boldannounce("Error setting up jobs, no job datums found"))
		return FALSE

	var/list/new_joinable_departments_by_type = list()

	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job)
			continue
		if(job.faction != faction)
			continue
		if(!job.config_check())
			continue
		if(!job.map_check())	//Even though we initialize before mapping, this is fine because the config is loaded at new
			testing("Removed [job.type] due to map config")
			continue
		occupations += job
		name_occupations[job.title] = job
		type_occupations[J] = job
		joinable_departments_by_type[J] = job.departments_list

		if(!LAZYLEN(job.departments_list))
			var/datum/job_department/department = joinable_departments_by_type[/datum/job_department/undefined]
			if(!department)
				department = new
				new_joinable_departments_by_type[/datum/job_department/undefined] = department
			department.add_job(job)
			continue
		for(var/department_type in job.departments_list)
			var/datum/job_department/department = new_joinable_departments_by_type[department_type]
			if(!department)
				department = new department_type()
				new_joinable_departments_by_type[department_type] = department
			department.add_job(job)

	sortTim(new_joinable_departments_by_type, GLOBAL_PROC_REF(cmp_department_display_asc), associative = TRUE)

	joinable_departments_by_type = new_joinable_departments_by_type

	return TRUE


/datum/controller/subsystem/job/proc/GetJob(rank)
	if(!occupations.len)
		SetupOccupations()
	return name_occupations[rank]

/datum/controller/subsystem/job/proc/GetJobType(jobtype)
	if(!occupations.len)
		SetupOccupations()
	return type_occupations[jobtype]

/datum/controller/subsystem/job/proc/get_department_type(department_type)
	if(!occupations.len)
		SetupOccupations()
	return joinable_departments_by_type[department_type]

/datum/controller/subsystem/job/proc/AssignRole(mob/dead/new_player/player, rank, latejoin = FALSE)
	JobDebug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	if(player?.mind && rank)
		var/datum/job/job = GetJob(rank)
		if(!job)
			return FALSE
		if(is_banned_from(player.ckey, rank) || QDELETED(player))
			return FALSE
		if(!job.player_old_enough(player.client))
			return FALSE
//		if(!job.not_available_in_days(player.client))
//			return FALSE
		if(job.required_playtime_remaining(player.client))
			return FALSE
		if(job.metalocked && !(job.type in player.client.prefs.jobs_buyed))
			return FALSE
		if(LAZYLEN(job.whitelisted) && !(player.ckey in job.whitelisted))
			return FALSE
		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		JobDebug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
		player.mind.assigned_role = rank
		unassigned -= player
		job.current_positions++
		return TRUE
	JobDebug("AR has failed, Player: [player], Rank: [rank]")
	return FALSE

/datum/controller/subsystem/job/proc/FreeRole(rank)
	if(!rank)
		return
	JobDebug("Freeing role: [rank]")
	var/datum/job/job = GetJob(rank)
	if(!job)
		return FALSE
	job.current_positions = max(0, job.current_positions - 1)

/datum/controller/subsystem/job/proc/FindOccupationCandidates(datum/job/job, level, flag)
	JobDebug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	var/list/candidates = list()
	for(var/mob/dead/new_player/player in unassigned)
		if(is_banned_from(player.ckey, job.title) || QDELETED(player))
			JobDebug("FOC isbanned failed, Player: [player]")
			continue
		if(!job.player_old_enough(player.client))
			JobDebug("FOC player not old enough, Player: [player]")
			continue
//		if(!job.not_available_in_days(player.client))
//			JobDebug("FOC player too old, Player: [player]")
//			continue
		if(job.required_playtime_remaining(player.client))
			JobDebug("FOC player not enough xp, Player: [player]")
			continue
		if(flag && (!(flag in player.client.prefs.be_special)))
			JobDebug("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.mind && (job.title in player.mind.restricted_roles))
			JobDebug("FOC incompatible with antagonist role, Player: [player]")
			continue
		if(job.metalocked && !(job.type in player.client.prefs.jobs_buyed))
			JobDebug("FOC role not buyed, Player: [player], Job:[job.title]")
			continue
		if(LAZYLEN(job.whitelisted) && !(player.ckey in job.whitelisted))
			JobDebug("FOC role not cash buyed, Player: [player], Job:[job.title]")
			continue
		if(player.client.prefs.job_preferences[job.title] == level)
			JobDebug("FOC pass, Player: [player], Level:[level]")
			candidates += player
	return candidates

/datum/controller/subsystem/job/proc/GiveRandomJob(mob/dead/new_player/player)
	JobDebug("GRJ Giving random job, Player: [player]")
	. = FALSE
	for(var/datum/job/job in shuffle(occupations))
		if(!job)
			continue

		if(istype(job, GetJob(SSjob.overflow_role))) // We don't want to give him assistant, that's boring!
			continue

		if(job.title in GLOB.command_positions) //If you want a command position, select it!
			continue

		if(is_banned_from(player.ckey, job.title) || QDELETED(player))
			if(QDELETED(player))
				JobDebug("GRJ isbanned failed, Player deleted")
				break
			JobDebug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue

		if(!job.player_old_enough(player.client))
			JobDebug("GRJ player not old enough, Player: [player]")
			continue
//		if(!job.not_available_in_days(player.client))
//			JobDebug("GRJ player too old, Player: [player]")
//			continue

		if(job.required_playtime_remaining(player.client))
			JobDebug("GRJ player not enough xp, Player: [player]")
			continue

		if(job.metalocked && !(job.type in player.client.prefs.jobs_buyed))
			JobDebug("GRJ role not buyed, Player: [player], Job:[job.title]")
			continue

		if(LAZYLEN(job.whitelisted) && !(player.ckey in job.whitelisted))
			JobDebug("FOC role not cash buyed, Player: [player], Job:[job.title]")
			continue

		if(player.mind && (job.title in player.mind.restricted_roles))
			JobDebug("GRJ incompatible with antagonist role, Player: [player], Job: [job.title]")
			continue

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			JobDebug("GRJ Random job given, Player: [player], Job: [job]")
			if(AssignRole(player, job.title))
				return TRUE

/datum/controller/subsystem/job/proc/ResetOccupations(faction = "Station")
	JobDebug("Occupations reset.")
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if((player) && (player.mind))
			player.mind.assigned_role = null
			player.mind.special_role = null
			SSpersistence.antag_rep_change[player.ckey] = 0
	SetupOccupations(faction)
	unassigned = list()
	return


//This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until
//it locates a head or runs out of levels to check
//This is basically to ensure that there's atleast a few heads in the round
/datum/controller/subsystem/job/proc/FillHeadPosition()
	for(var/level in level_order)
		for(var/command_position in GLOB.command_positions)
			var/datum/job/job = GetJob(command_position)
			if(!job)
				continue
			if((job.current_positions >= job.total_positions) && job.total_positions != -1)
				continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)
				continue
			var/mob/dead/new_player/candidate = pick(candidates)
			if(AssignRole(candidate, command_position))
				return TRUE
	return FALSE


//This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
//This is also to ensure we get as many heads as possible
/datum/controller/subsystem/job/proc/CheckHeadPositions(level)
	for(var/command_position in GLOB.command_positions)
		var/datum/job/job = GetJob(command_position)
		if(!job)
			continue
		if((job.current_positions >= job.total_positions) && job.total_positions != -1)
			continue
		var/list/candidates = FindOccupationCandidates(job, level)
		if(!candidates.len)
			continue
		var/mob/dead/new_player/candidate = pick(candidates)
		AssignRole(candidate, command_position)

/datum/controller/subsystem/job/proc/FillAIPosition()
	var/ai_selected = FALSE
	var/datum/job/job = GetJob(JOB_AI)
	if(!job)
		return FALSE
	for(var/i = job.total_positions, i > 0, i--)
		for(var/level in level_order)
			var/list/candidates = list()
			candidates = FindOccupationCandidates(job, level)
			if(candidates.len)
				var/mob/dead/new_player/candidate = pick(candidates)
				if(AssignRole(candidate, JOB_AI))
					ai_selected++
					break
	if(ai_selected)
		return TRUE
	return FALSE


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/job/proc/DivideOccupations(list/required_jobs)
	//Setup new player list and get the jobs list
	JobDebug("Running DO")

	//Holder for Triumvirate is stored in the SSticker, this just processes it
	if(SSticker.triai)
		for(var/datum/job/ai/A in occupations)
			A.spawn_positions = 3
		for(var/obj/effect/landmark/start/ai/secondary/S in GLOB.start_landmarks_list)
			S.latejoin_active = TRUE

	//Get the players who are ready
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY && player.check_preferences() && player.mind && !player.mind.assigned_role)
			unassigned += player

	initial_players_to_assign = unassigned.len

	JobDebug("DO, Len: [unassigned.len]")
	if(unassigned.len == 0)
		return validate_required_jobs(required_jobs)

	//Scale number of open security officer slots to population
	setup_officer_positions()

	//Jobs will have fewer access permissions if the number of players exceeds the threshold defined in game_options.txt
	var/mat = CONFIG_GET(number/minimal_access_threshold)
	if(mat)
		if(mat > unassigned.len)
			CONFIG_SET(flag/jobs_have_minimal_access, FALSE)
		else
			CONFIG_SET(flag/jobs_have_minimal_access, TRUE)

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	HandleFeedbackGathering()

	//People who wants to be the overflow role, sure, go on.
	JobDebug("DO, Running Overflow Check 1")
	var/datum/job/overflow = GetJob(SSjob.overflow_role)
	var/list/overflow_candidates = FindOccupationCandidates(overflow, JP_LOW)
	JobDebug("AC1, Candidates: [overflow_candidates.len]")
	for(var/mob/dead/new_player/player in overflow_candidates)
		JobDebug("AC1 pass, Player: [player]")
		AssignRole(player, SSjob.overflow_role)
		overflow_candidates -= player
	JobDebug("DO, AC1 end")

	//Select one head
	JobDebug("DO, Running Head Check")
	FillHeadPosition()
	JobDebug("DO, Head Check end")

	//Check for an AI
	JobDebug("DO, Running AI Check")
	FillAIPosition()
	JobDebug("DO, AI Check end")

	//Other jobs are now checked
	JobDebug("DO, Running Standard Check")


	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(occupations)
	for(var/level in level_order)
		//Check the head jobs first each level
		CheckHeadPositions(level)

		// Loop through all unassigned players
		for(var/mob/dead/new_player/player in unassigned)
			if(PopcapReached())
				RejectPlayer(player)

			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(!job)
					continue

				if(is_banned_from(player.ckey, job.title))
					JobDebug("DO isbanned failed, Player: [player], Job:[job.title]")
					continue

				if(QDELETED(player))
					JobDebug("DO player deleted during job ban check")
					break

				if(!job.player_old_enough(player.client))
					JobDebug("DO player not old enough, Player: [player], Job:[job.title]")
					continue
//				if(!job.not_available_in_days(player.client))
//					JobDebug("DO player too old, Player: [player], Job:[job.title]")
//					continue

				if(job.required_playtime_remaining(player.client))
					JobDebug("DO player not enough xp, Player: [player], Job:[job.title]")
					continue

				if(player.mind && (job.title in player.mind.restricted_roles))
					JobDebug("DO incompatible with antagonist role, Player: [player], Job:[job.title]")
					continue

				if(job.metalocked && !(job.type in player.client.prefs.jobs_buyed))
					JobDebug("DO role not buyed, Player: [player], Job:[job.title]")
					continue

				if(LAZYLEN(job.whitelisted) && !(player.ckey in job.whitelisted))
					JobDebug("FOC role not cash buyed, Player: [player], Job:[job.title]")
					continue

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.job_preferences[job.title] == level)
					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						JobDebug("DO pass, Player: [player], Level:[level], Job:[job.title]")
						AssignRole(player, job.title)
						unassigned -= player
						break


	JobDebug("DO, Handling unassigned.")
	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/dead/new_player/player in unassigned)
		HandleUnassigned(player)

	JobDebug("DO, Handling unrejectable unassigned")
	//Mop up people who can't leave.
	for(var/mob/dead/new_player/player in unassigned) //Players that wanted to back out but couldn't because they're antags (can you feel the edge case?)
		if(!GiveRandomJob(player))
			if(!AssignRole(player, SSjob.overflow_role)) //If everything is already filled, make them an assistant
				return FALSE //Living on the edge, the forced antagonist couldn't be assigned to overflow role (bans, client age) - just reroll

	return validate_required_jobs(required_jobs)

/datum/controller/subsystem/job/proc/validate_required_jobs(list/required_jobs)
	if(!required_jobs.len)
		return TRUE
	for(var/required_group in required_jobs)
		var/group_ok = TRUE
		for(var/rank in required_group)
			var/datum/job/J = GetJob(rank)
			if(!J)
				SSticker.mode.setup_error = "Invalid job [rank] in gamemode required jobs."
				return FALSE
			if(J.current_positions < required_group[rank])
				group_ok = FALSE
				break
		if(group_ok)
			return TRUE
	SSticker.mode.setup_error = "Required jobs not present."
	return FALSE

//We couldn't find a job from prefs for this guy.
/datum/controller/subsystem/job/proc/HandleUnassigned(mob/dead/new_player/player)
	if(PopcapReached())
		RejectPlayer(player)
	else if(player.client.prefs.joblessrole == BEOVERFLOW)
		var/allowed_to_be_a_loser = !is_banned_from(player.ckey, SSjob.overflow_role)
		if(QDELETED(player) || !allowed_to_be_a_loser)
			RejectPlayer(player)
		else
			if(!AssignRole(player, SSjob.overflow_role))
				RejectPlayer(player)
	else if(player.client.prefs.joblessrole == BERANDOMJOB)
		if(!GiveRandomJob(player))
			RejectPlayer(player)
	else if(player.client.prefs.joblessrole == RETURNTOLOBBY)
		RejectPlayer(player)
	else //Something gone wrong if we got here.
		var/message = "DO: [player] fell through handling unassigned"
		JobDebug(message)
		log_game(message)
		message_admins(message)
		RejectPlayer(player)

//Gives the player the stuff he should have with his rank
/datum/controller/subsystem/job/proc/EquipRank(mob/M, rank, joined_late = FALSE, is_captain = FALSE)
	var/mob/dead/new_player/newplayer
	var/mob/living/living_mob
	if(!joined_late)
		newplayer = M
		living_mob = newplayer.new_character
	else
		living_mob = M

	var/datum/job/job = GetJob(rank)

	living_mob.job = rank

	SEND_SIGNAL(living_mob, COMSIG_JOB_RECEIVED, living_mob.job)

	//If we joined at roundstart we should be positioned at our workstation
	if(!joined_late)
		var/obj/S = null
		if(length(GLOB.jobspawn_overrides[rank]))
			S = pick(GLOB.jobspawn_overrides[rank])
		else
			for(var/_sloc in GLOB.start_landmarks_list)
				var/obj/effect/landmark/start/sloc = _sloc
				if(sloc.name != rank)
					continue
				S = sloc
				if(locate(/mob/living) in sloc.loc) //so we can revert to spawning them on top of eachother if something goes wrong
					continue
				sloc.used = TRUE
				break
		if(S)
			S.JoinPlayerHere(living_mob, FALSE)
		if(!S) //if there isn't a spawnpoint send them to latejoin, if there's no latejoin go yell at your mapper
			log_world("Couldn't find a round start spawn point for [rank]")
			if(!SendToLateJoin(living_mob))
				living_mob.move_to_error_room()

	if(living_mob.mind)
		living_mob.mind.assigned_role = rank

	to_chat(M, "\n<big><b>Я - [ru_job_parse(rank)], [gvorno()].</b></big>\n")
	if(job)
		var/new_mob = job.equip(living_mob, null, null, joined_late , null, M.client, is_captain)//silicons override this proc to return a mob
		if(ismob(new_mob))
			living_mob = new_mob
			if(!joined_late)
				newplayer.new_character = living_mob
			else
				M = living_mob

		SSpersistence.antag_rep_change[M.client.ckey] += job.GetAntagRep()

		if(M.client.holder)
			if(CONFIG_GET(flag/auto_deadmin_players) || (M.client.prefs?.toggles & DEADMIN_ALWAYS))
				M.client.holder.auto_deadmin()
			else
				handle_auto_deadmin_roles(M.client, rank)
		to_chat(M, span_notice("\nКак <b>[ru_job_parse(rank)]</b>, я подчиняюсь [job.supervisors]. Некоторые обстоятельства могут изменить это."))
		job.radio_help_message(M)
		if(job.req_admin_notify)
			to_chat(M, "\n<span class='revenbignotice'>Это ответственная должность. Перед уходом стоит найти себе замену.</spawn>")

	var/related_policy = get_policy(rank)
	if(related_policy)
		to_chat(M,"\n[related_policy]")
	if(ishuman(living_mob))
		var/mob/living/carbon/human/wageslave = living_mob
		living_mob.add_memory("Мой номер аккаунта: [wageslave.account_id].")
	if(job && living_mob)
		job.after_spawn(living_mob, M, joined_late) // note: this happens before the mob has a key! M will always have a client, H might not.

	return living_mob

/datum/controller/subsystem/job/proc/handle_auto_deadmin_roles(client/C, rank)
	if(!C?.holder)
		return TRUE
	var/datum/job/job = GetJob(rank)

	var/timegate_expired = FALSE
	// allow only forcing deadminning in the first X seconds of the round if auto_deadmin_timegate is set in config
	var/timegate = CONFIG_GET(number/auto_deadmin_timegate)
	if(timegate && (world.time - SSticker.round_start_time > timegate))
		timegate_expired = TRUE

	if(!job)
		return
	if((job.auto_deadmin_role_flags & DEADMIN_POSITION_HEAD) && ((CONFIG_GET(flag/auto_deadmin_heads) && !timegate_expired) || (C.prefs?.toggles & DEADMIN_POSITION_HEAD)))
		return C.holder.auto_deadmin()
	else if((job.auto_deadmin_role_flags & DEADMIN_POSITION_SECURITY) && ((CONFIG_GET(flag/auto_deadmin_security) && !timegate_expired) || (C.prefs?.toggles & DEADMIN_POSITION_SECURITY)))
		return C.holder.auto_deadmin()
	else if((job.auto_deadmin_role_flags & DEADMIN_POSITION_SILICON) && ((CONFIG_GET(flag/auto_deadmin_silicons) && !timegate_expired) || (C.prefs?.toggles & DEADMIN_POSITION_SILICON))) //in the event there's ever psuedo-silicon roles added, ie synths.
		return C.holder.auto_deadmin()

/datum/controller/subsystem/job/proc/setup_officer_positions()
	var/datum/job/J = SSjob.GetJob(JOB_SECURITY_OFFICER)
	if(!J)
		CRASH("setup_officer_positions(): Security officer job is missing")

	var/ssc = CONFIG_GET(number/security_scaling_coeff)
	if(ssc > 0)
		if(J.spawn_positions > 0)
			var/officer_positions = min(12, max(J.spawn_positions, round(unassigned.len / ssc))) //Scale between configured minimum and 12 officers
			JobDebug("Setting open security officer positions to [officer_positions]")
			J.total_positions = officer_positions
			J.spawn_positions = officer_positions

	//Spawn some extra eqipment lockers if we have more than 5 officers
	var/equip_needed = J.total_positions
	if(equip_needed < 0) // -1: infinite available slots
		equip_needed = 12
	for(var/i=equip_needed-5, i>0, i--)
		if(GLOB.secequipment.len)
			var/spawnloc = GLOB.secequipment[1]
			new /obj/structure/closet/secure_closet/security/sec(spawnloc)
			GLOB.secequipment -= spawnloc
		else //We ran out of spare locker spawns!
			break


/datum/controller/subsystem/job/proc/LoadJobs()
	var/jobstext = file2text("[global.config.directory]/jobs.txt")
	for(var/datum/job/J in occupations)
		var/regex/jobs = new("[J.title]=(-1|\\d+),(-1|\\d+)")
		jobs.Find(jobstext)
		J.total_positions = text2num(jobs.group[1])
		J.spawn_positions = text2num(jobs.group[2])

/datum/controller/subsystem/job/proc/HandleFeedbackGathering()
	for(var/datum/job/job in occupations)
		var/high = 0 //high
		var/medium = 0 //medium
		var/low = 0 //low
		var/never = 0 //never
		var/banned = 0 //banned
		var/young = 0 //account too young
//		var/old = 0 //account too old
		for(var/i in GLOB.new_player_list)
			var/mob/dead/new_player/player = i
			if(!(player.ready == PLAYER_READY_TO_PLAY && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(is_banned_from(player.ckey, job.title) || QDELETED(player))
				banned++
				continue
			if(!job.player_old_enough(player.client))
				young++
				continue
//			if(!job.not_available_in_days(player.client))
//				old++
//				continue
			if(job.required_playtime_remaining(player.client))
				young++
				continue
			switch(player.client.prefs.job_preferences[job.title])
				if(JP_HIGH)
					high++
				if(JP_MEDIUM)
					medium++
				if(JP_LOW)
					low++
				else
					never++
		SSblackbox.record_feedback("nested tally", "job_preferences", high, list("[job.title]", "high"))
		SSblackbox.record_feedback("nested tally", "job_preferences", medium, list("[job.title]", "medium"))
		SSblackbox.record_feedback("nested tally", "job_preferences", low, list("[job.title]", "low"))
		SSblackbox.record_feedback("nested tally", "job_preferences", never, list("[job.title]", "never"))
		SSblackbox.record_feedback("nested tally", "job_preferences", banned, list("[job.title]", "banned"))
		SSblackbox.record_feedback("nested tally", "job_preferences", young, list("[job.title]", "young"))
//		SSblackbox.record_feedback("nested tally", "job_preferences", old, list("[job.title]", "old"))

/datum/controller/subsystem/job/proc/PopcapReached()
	var/hpc = CONFIG_GET(number/hard_popcap)
	var/epc = CONFIG_GET(number/extreme_popcap)
	if(hpc || epc)
		var/relevent_cap = max(hpc, epc)
		if((initial_players_to_assign - unassigned.len) >= relevent_cap)
			return 1
	return 0

/datum/controller/subsystem/job/proc/RejectPlayer(mob/dead/new_player/player)
	if(player.mind && player.mind.special_role)
		return
	if(PopcapReached())
		JobDebug("Popcap overflow Check observer located, Player: [player]")
	JobDebug("Player rejected :[player]")
	to_chat(player, "<b>Вас не приняли ни на одну должность, которую вы хотели занять.</b>")
	unassigned -= player
	player.ready = PLAYER_NOT_READY


/datum/controller/subsystem/job/Recover()
	set waitfor = FALSE
	var/oldjobs = SSjob.occupations
	sleep(20)
	for (var/datum/job/J in oldjobs)
		INVOKE_ASYNC(src, PROC_REF(RecoverJob), J)

/datum/controller/subsystem/job/proc/RecoverJob(datum/job/J)
	var/datum/job/newjob = GetJob(J.title)
	if (!istype(newjob))
		return
	newjob.total_positions = J.total_positions
	newjob.spawn_positions = J.spawn_positions
	newjob.current_positions = J.current_positions

/atom/proc/JoinPlayerHere(mob/joining_mob, buckle)
	// By default, just place the mob on the same turf as the marker or whatever.
	joining_mob.forceMove(get_turf(src))

/obj/structure/chair/JoinPlayerHere(mob/joining_mob, buckle)
	. = ..()
	// Placing a mob in a chair will attempt to buckle it, or else fall back to default.
	if(buckle && isliving(joining_mob))
		buckle_mob(joining_mob, FALSE, FALSE)

/datum/controller/subsystem/job/proc/SendToLateJoin(mob/M, buckle = TRUE)
	var/atom/destination
	if(M.mind && M.mind.assigned_role && length(GLOB.jobspawn_overrides[M.mind.assigned_role])) //We're doing something special today.
		destination = pick(GLOB.jobspawn_overrides[M.mind.assigned_role])
		destination.JoinPlayerHere(M, FALSE)
		return TRUE

	if(latejoin_trackers.len)
		destination = pick(latejoin_trackers)
		destination.JoinPlayerHere(M, buckle)
		return TRUE

	//bad mojo
	var/area/shuttle/arrival/A = GLOB.areas_by_type[/area/shuttle/arrival]
	if(A)
		//first check if we can find a chair
		var/obj/structure/chair/C = locate() in A
		if(C)
			C.JoinPlayerHere(M, buckle)
			return TRUE

		//last hurrah
		var/list/avail = list()
		for(var/turf/T in A)
			if(!T.is_blocked_turf(TRUE))
				avail += T
		if(avail.len)
			destination = pick(avail)
			destination.JoinPlayerHere(M, FALSE)
			return TRUE

	//pick an open spot on arrivals and dump em
	var/list/arrivals_turfs = shuffle(get_area_turfs(/area/shuttle/arrival))
	if(arrivals_turfs.len)
		for(var/turf/T in arrivals_turfs)
			if(!T.is_blocked_turf(TRUE))
				T.JoinPlayerHere(M, FALSE)
				return TRUE
		//last chance, pick ANY spot on arrivals and dump em
		destination = arrivals_turfs[1]
		destination.JoinPlayerHere(M, FALSE)
		return TRUE

	for(var/_sloc in GLOB.start_landmarks_list)
		var/obj/effect/landmark/start/sloc = _sloc
		if(sloc.name != M.job)
			continue
		sloc.JoinPlayerHere(M, FALSE)
		message_admins("!! [M] входит в игру в зоне [get_area(M)].")
		return TRUE

	var/msg = "Unable to send mob [M] to late join!"
	message_admins(msg)
	CRASH(msg)


///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/controller/subsystem/job/proc/get_living_heads()
	. = list()
	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/player = i
		if(player.stat != DEAD && player.mind && (player.mind.assigned_role in GLOB.command_positions))
			. |= player.mind


////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/controller/subsystem/job/proc/get_all_heads()
	. = list()
	for(var/i in GLOB.mob_list)
		var/mob/player = i
		if(player.mind && (player.mind.assigned_role in GLOB.command_positions))
			. |= player.mind

//////////////////////////////////////////////
//Keeps track of all living security members//
//////////////////////////////////////////////
/datum/controller/subsystem/job/proc/get_living_sec()
	. = list()
	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/player = i
		if(player.stat != DEAD && player.mind && (player.mind.assigned_role in GLOB.security_positions))
			. |= player.mind

////////////////////////////////////////
//Keeps track of all  security members//
////////////////////////////////////////
/datum/controller/subsystem/job/proc/get_all_sec()
	. = list()
	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/player = i
		if(player.mind && (player.mind.assigned_role in GLOB.security_positions))
			. |= player.mind

/datum/controller/subsystem/job/proc/JobDebug(message)
	log_job_debug(message)

/// Builds various lists of jobs based on station, centcom and additional jobs with icons associated with them. // JOB_INTERN
/datum/controller/subsystem/job/proc/setup_job_lists()
	station_jobs = list(JOB_ASSISTANT, JOB_CAPTAIN, JOB_HEAD_OF_PERSONNEL, JOB_BARTENDER, JOB_COOK, JOB_BOTANIST, JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN, \
		JOB_SHAFT_MINER, JOB_HUNTER, JOB_FREELANCER, JOB_CLOWN, JOB_MIME, JOB_JANITOR, JOB_CURATOR, JOB_LAWYER, JOB_CHAPLAIN, JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, \
		JOB_ATMOSPHERIC_TECHNICIAN, JOB_CHIEF_MEDICAL_OFFICER, JOB_MEDICAL_DOCTOR, JOB_PARAMEDIC, JOB_CHEMIST, JOB_GENETICIST, JOB_VIROLOGIST, JOB_PSYCHOLOGIST, \
		JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST, JOB_ROBOTICIST, JOB_HEAD_OF_SECURITY, JOB_WARDEN, JOB_DETECTIVE, JOB_SECURITY_OFFICER, JOB_RUSSIAN_OFFICER, \
		JOB_VETERAN, JOB_FIELD_MEDIC, JOB_SPECIALIST, JOB_MECHANIC, JOB_BOMJ, JOB_PRISONER, JOB_RANGER)

	additional_jobs_with_icons = list(JOB_ERT_COMMANDER, JOB_ERT_OFFICER, JOB_ERT_ENGINEER, JOB_ERT_MEDICAL_DOCTOR, \
		JOB_ERT_CLOWN, JOB_ERT_CHAPLAIN, JOB_ERT_JANITOR, JOB_ERT_DEATHSQUAD, \
		"SOBR","SOBR Leader", JOB_SECURITY_OFFICER_SUPPLY, JOB_SECURITY_OFFICER_MEDICAL, JOB_SECURITY_OFFICER_SCIENCE, JOB_SECURITY_OFFICER_ENGINEERING, "Yohei", \
		"red", "blue", "yellow", "green", "white")

	centcom_jobs = list(JOB_CENTCOM,JOB_CENTCOM_VIP,JOB_CENTCOM_CUSTODIAN,JOB_CENTCOM_THUNDERDOME_OVERSEER,JOB_CENTCOM_OFFICIAL,JOB_CENTCOM_MEDICAL_DOCTOR,JOB_CENTCOM_RESEARCH_OFFICER, \
		JOB_CENTCOM_SPECIAL_OFFICER,JOB_CENTCOM_ADMIRAL,JOB_CENTCOM_COMMANDER,JOB_CENTCOM_BARTENDER,JOB_CENTCOM_PRIVATE_SECURITY)

/obj/item/paper/fluff/spare_id_safe_code
	name = "Запасные коды от сейфа"
	desc = "Доказательство того, что вы точно заслужили должность Капитана этой станции."

/obj/item/paper/fluff/spare_id_safe_code/Initialize(mapload)
	. = ..()
	var/safe_code = SSid_access.spare_id_safe_code

	info = "Комбинацией является: [safe_code ? safe_code : "\[REDACTED\]"]<br><br>Сейф может быть обнаружен на мостике, либо в каюте капитана.<br><br>Если работа не позволяет пройти туда, будет добавлен специальный доступ."

/datum/controller/subsystem/job/proc/promote_to_captain(mob/living/carbon/human/new_captain, acting_captain = FALSE)
	var/id_safe_code = SSid_access.spare_id_safe_code

	if(!id_safe_code)
		CRASH("Cannot promote [new_captain.real_name] to Captain, there is no id_safe_code.")

	var/paper = new /obj/item/paper/fluff/spare_id_safe_code()
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	var/where = new_captain.equip_in_one_of_slots(paper, slots, FALSE) || "мои ляшки"

	if(acting_captain)
		to_chat(new_captain, span_notice("Учитывая мою должность на станции, меня назначили её Капитаном. Важный документ подкинули в [ru_parse_zone(where)]."))
	else
		to_chat(new_captain, span_notice("Сейф можно найти в капитанской каюте, либо на мостике. Важный документ положили в [ru_parse_zone(where)]."))

	// Force-give their ID card bridge access.
	var/obj/item/id_slot = new_captain.get_item_by_slot(ITEM_SLOT_ID)
	if(id_slot)
		var/obj/item/card/id/id_card = id_slot.GetID()
		if(!(ACCESS_HEADS in id_card.access))
			id_card.add_wildcards(list(ACCESS_HEADS), mode=FORCE_ADD_ALL)
		if(!(ACCESS_CAPTAIN in id_card.access))
			id_card.add_wildcards(list(ACCESS_CAPTAIN), mode=FORCE_ADD_ALL)

	assigned_captain = TRUE

/datum/controller/subsystem/job/proc/SetJobPositions(job_path, total, spawn_pos, wipe_current = FALSE)
	for(var/I in occupations)
		var/datum/job/J = I
		if(istype(J, job_path))
			J.total_positions = total
			J.spawn_positions = spawn_pos
			if(wipe_current)
				J.current_positions = 0

/datum/controller/subsystem/job/proc/AddJobPositions(job_path, total, spawn_pos)
	for(var/I in occupations)
		var/datum/job/J = I
		if(istype(J, job_path))
			J.total_positions = total
			J.spawn_positions = spawn_pos

/datum/controller/subsystem/job/proc/GetJobPositions(job_path)
	for(var/I in occupations)
		var/datum/job/J = I
		if(istype(J, job_path))
			return J.spawn_positions
