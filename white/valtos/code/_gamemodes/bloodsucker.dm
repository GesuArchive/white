/datum/game_mode/bloodsucker
	name = "bloodsucker"
	config_tag = "bloodsucker"
	report_type = "Bloodsucker"
	antag_flag = ROLE_BLOODSUCKER
	false_report_weight = 10
	restricted_jobs = list(JOB_AI, JOB_CYBORG)
	protected_jobs = list(
		JOB_CAPTAIN, JOB_HEAD_OF_PERSONNEL, JOB_HEAD_OF_SECURITY,
		JOB_RESEARCH_DIRECTOR, JOB_CHIEF_ENGINEER, JOB_CHIEF_MEDICAL_OFFICER, JOB_CURATOR,
		JOB_WARDEN, JOB_SECURITY_OFFICER, JOB_DETECTIVE, JOB_FIELD_MEDIC, JOB_SPECIALIST, JOB_RANGER, JOB_SHAFT_MINER, JOB_HUNTER, JOB_FREELANCER, JOB_INTERN
	)
	required_players = 25
	required_enemies = 2
	recommended_enemies = 4
	reroll_friendly = 1
	round_ends_with_antag_death = FALSE

	announce_span = "green"
	announce_text = "Filthy, bloodsucking vampires are crawling around disguised as crewmembers!\n\
	<span class='danger'>Bloodsuckers</span>: Claim a coffin and grow strength, turn the crew into your slaves.\n\
	<span class='notice'>Crew</span>: Put an end to the undead menace and resist their brainwashing!"

	///List of all Bloodsuckers, used for assigning
	var/list/bloodsuckers = list()

/datum/game_mode/bloodsucker/pre_setup()

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs
	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += JOB_ASSISTANT

	recommended_enemies = clamp(round(num_players()/10), 1, 6);

	for(var/i = 0, i < recommended_enemies, i++)
		if(!antag_candidates.len)
			break
		var/datum/mind/bloodsucker = pick(antag_candidates)
		bloodsuckers += bloodsucker
		bloodsucker.restricted_roles = restricted_jobs
		log_game("[bloodsucker.key] (ckey) has been selected as a Bloodsucker.")
		antag_candidates -= bloodsucker// Apparently you can also write antag_candidates -= bloodsucker

	// Do we have enough vamps to continue?
	return bloodsuckers.len >= required_enemies

/datum/game_mode/bloodsucker/post_setup()
	// Vamps
	for(var/datum/mind/bloodsucker in bloodsuckers)
		if(!bloodsucker.make_bloodsucker(bloodsucker))
			bloodsuckers -= bloodsucker
	..()

/datum/game_mode/bloodsucker/generate_report()
	return "There's been a report of the undead roaming around the sector, especially those that display Vampiric abilities.\
			They've displayed the ability to disguise themselves as anyone and brainwash the minds of people they capture alive.\
			Please take care of the crew and their health, as it is impossible to tell if one is lurking in the darkness behind."

/datum/game_mode/bloodsucker/make_antag_chance(mob/living/carbon/human/character)
	var/bloodsuckercap = min(round(GLOB.joined_player_list.len / (3 * 4)) + 2, round(GLOB.joined_player_list.len / 2))
	if(bloodsuckers.len >= bloodsuckercap) //Caps number of latejoin antagonists
		return
	if(bloodsuckers.len <= (bloodsuckercap - 2) || prob(100 - (3 * 2)))
		if(ROLE_BLOODSUCKER in character.client.prefs.be_special)
			if(!is_banned_from(character.ckey, list(ROLE_BLOODSUCKER, ROLE_SYNDICATE)) && !QDELETED(character))
				if(age_check(character.client))
					if(!(character.job in restricted_jobs))
						character.mind.make_bloodsucker()
						bloodsuckers += character.mind
