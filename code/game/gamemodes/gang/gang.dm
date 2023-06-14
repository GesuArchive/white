/datum/game_mode/gang
	name = "Families"
	config_tag = "families"
	antag_flag = ROLE_FAMILIES
	false_report_weight = 5
	required_players = 25
	required_enemies = 6
	recommended_enemies = 6
	announce_span = "danger"
	announce_text = "Grove For Lyfe!"
	reroll_friendly = FALSE
	restricted_jobs = list(JOB_CYBORG, JOB_AI, JOB_PRISONER, JOB_SECURITY_OFFICER, JOB_RUSSIAN_OFFICER, JOB_HACKER, JOB_VETERAN, JOB_WARDEN, JOB_DETECTIVE, JOB_HEAD_OF_SECURITY, JOB_CAPTAIN, JOB_HEAD_OF_PERSONNEL, JOB_FIELD_MEDIC, JOB_SPECIALIST, JOB_RANGER, JOB_INTERN)//N O
	protected_jobs = list(JOB_RANGER, JOB_SHAFT_MINER, JOB_FREELANCER)

	/// A reference to the handler that is used to run pre_setup(), post_setup(), etc..
	var/datum/gang_handler/handler

/datum/game_mode/gang/warriors
	name = "Warriors"
	config_tag = "warriors"
	announce_text = "Can you survive this onslaught?"

/datum/game_mode/gang/warriors/pre_setup()
	handler = new /datum/gang_handler(antag_candidates,restricted_jobs)
	var/list/datum/antagonist/gang/gangs_to_generate = subtypesof(/datum/antagonist/gang)
	handler.gangs_to_generate = gangs_to_generate.len
	handler.gang_balance_cap = 3
	return handler.pre_setup_analogue()

/datum/game_mode/gang/pre_setup()
	handler = new /datum/gang_handler(antag_candidates,restricted_jobs)
	return handler.pre_setup_analogue()

/datum/game_mode/gang/Destroy()
	QDEL_NULL(handler)
	return ..()

/datum/game_mode/gang/post_setup()
	handler.post_setup_analogue(FALSE)
	gamemode_ready = TRUE
	return ..()

/datum/game_mode/gang/process()
	handler.process_analogue()

/datum/game_mode/gang/set_round_result()
	return handler.set_round_result_analogue()

/datum/game_mode/gang/generate_report()
	return "На борту вашей станции была обнаружена потенциальная насильственная преступная деятельность, и мы полагаем, что Spinward Stellar Coalition может проводить нашу проверку. Следите за пометкой дерна, цветовой координацией и подозрительными людьми, которые просят вас сказать что-то чуть ближе к их груди."
