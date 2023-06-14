/datum/game_mode/heretics
	name = "heresy"
	config_tag = "heresy"
	report_type = "heresy"
	antag_flag = ROLE_HERETIC
	false_report_weight = 5
	protected_jobs = list(JOB_PRISONER,JOB_SECURITY_OFFICER, JOB_RUSSIAN_OFFICER, JOB_HACKER, JOB_VETERAN, JOB_WARDEN, JOB_DETECTIVE, JOB_HEAD_OF_SECURITY, JOB_CAPTAIN, JOB_FIELD_MEDIC, JOB_SPECIALIST, JOB_RANGER, JOB_SHAFT_MINER, JOB_HUNTER, JOB_FREELANCER, JOB_INTERN)
	restricted_jobs = list(JOB_AI, JOB_CYBORG)
	required_players = 0
	required_enemies = 1
	recommended_enemies = 4
	reroll_friendly = 1
	enemy_minimum_age = 0

	announce_span = "danger"
	announce_text = "Heretics have been spotted on the station!\n\
	<span class='danger'>Heretics</span>: Accomplish your objectives.\n\
	<span class='notice'>Crew</span>: Do not let the madman succeed!"

	var/ecult_possible = 4 //hard limit on culties if scaling is turned off
	var/num_ecult = 1
	var/list/culties = list()

/datum/game_mode/heretics/pre_setup()

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += JOB_ASSISTANT


	var/esc = CONFIG_GET(number/ecult_scaling_coeff)
	if(esc)
		num_ecult = min(max(1, min(round(num_players() / (esc * 2)) + 2, round(num_players() / esc))),4)
	else
		num_ecult = max(1, min(num_players(), ecult_possible))

	for(var/i in 1 to num_ecult)
		if(!antag_candidates.len)
			break
		var/datum/mind/cultie = antag_pick(antag_candidates)
		antag_candidates -= cultie
		cultie.special_role = ROLE_HERETIC
		cultie.restricted_roles = restricted_jobs
		culties += cultie

	var/enough_heretics = culties.len > 0

	if(!enough_heretics)
		setup_error = "Not enough heretic candidates"
		return FALSE
	else
		for(var/antag in culties)
			GLOB.pre_setup_antags += antag
		return TRUE

/datum/game_mode/heretics/post_setup()
	for(var/c in culties)
		var/datum/mind/cultie = c
		log_game("[key_name(cultie)] has been selected as a heretic!")
		var/datum/antagonist/heretic/new_antag = new()
		cultie.add_antag_datum(new_antag)
		GLOB.pre_setup_antags -= cultie
	return ..()

/datum/game_mode/heretics/generate_report()
	return "Cybersun Industries объявила, что они успешно совершили набег на библиотеку с высоким уровнем безопасности. \
	В библиотеке была очень опасная книга, обладающая аномальными свойствами. Мы подозреваем, что книга переписана. Будьте бдительны!"
