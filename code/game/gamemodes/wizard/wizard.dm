/datum/game_mode
	var/list/datum/mind/wizards = list()
	var/list/datum/mind/apprentices = list()

/datum/game_mode/wizard
	name = "маг"
	config_tag = "wizard"
	report_type = "wizard"
	antag_flag = ROLE_WIZARD
	false_report_weight = 10
	required_players = 30
	required_enemies = 1
	recommended_enemies = 1
	enemy_minimum_age = 30
	round_ends_with_antag_death = 1
	announce_span = "danger"
	announce_text = "There is a space wizard attacking the station!\n\
	<span class='danger'>Wizard</span>: Accomplish your objectives and cause mayhem on the station.\n\
	<span class='notice'>Crew</span>: Eliminate the wizard before they can succeed!"
	var/finished = 0

/datum/game_mode/wizard/pre_setup()
	var/datum/mind/wizard = antag_pick(antag_candidates)
	wizards += wizard
	wizard.assigned_role = ROLE_WIZARD
	wizard.special_role = ROLE_WIZARD
	log_game("[key_name(wizard)] has been selected as a Wizard") //TODO: Move these to base antag datum
	if(GLOB.wizardstart.len == 0)
		setup_error = "No wizard starting location found"
		return FALSE
	for(var/datum/mind/wiz in wizards)
		wiz.current.forceMove(pick(GLOB.wizardstart))
	return TRUE


/datum/game_mode/wizard/post_setup()
	for(var/datum/mind/wizard in wizards)
		wizard.add_antag_datum(/datum/antagonist/wizard)
	return ..()

/datum/game_mode/wizard/generate_report()
	return "Опасный человек из Федерации Волшебников по имени [pick(GLOB.wizard_first)] [pick(GLOB.wizard_second)] недавно сбежал из секретного тюремного учреждения. Этот \
		человек - опасный мутант со способностью изменять себя и мир вокруг себя тем, что он и его лидеры считают магией. Если этот человек попытается атаковать вашу станцию, \
		его казнь очень приветствуется, как и сохранение его тела для последующего изучения."


/datum/game_mode/wizard/are_special_antags_dead()
	for(var/datum/mind/wizard in wizards | apprentices)
		if(isliving(wizard.current) && wizard.current.stat!=DEAD)
			return FALSE

	if(SSevents.wizardmode) //If summon events was active, turn it off
		SSevents.toggleWizardmode()
		SSevents.resetFrequency()

	return TRUE

/datum/game_mode/wizard/check_finished()
	. = ..()
	if(.)
		finished = TRUE
	else if(gamemode_ready && are_special_antags_dead() && !CONFIG_GET(keyed_list/continuous)[config_tag])
		finished = TRUE
		. = TRUE

/datum/game_mode/wizard/set_round_result()
	..()
	if(finished)
		SSticker.mode_result = "loss - wizard killed"
		SSticker.news_report = WIZARD_KILLED

/datum/game_mode/wizard/special_report()
	if(finished)
		return "<div class='panel redborder'><span class='redtext big'>The wizard[(wizards.len>1)?"s":""] has been killed by the crew! The Space Wizards Federation has been taught a lesson they will not soon forget!</span></div>"

//returns whether the mob is a wizard (or apprentice)
/proc/iswizard(mob/living/M)
	return M.mind && M.mind.has_antag_datum(/datum/antagonist/wizard,TRUE)
