/datum/job/bomj
	title = "Bomj"
	ru_title = "Бомж"
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "никому"
	selection_color = "#dddd00"
	outfit = /datum/outfit/job/bomj
	antag_rep = 3
	paycheck = PAYCHECK_PRISONER

	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SCUM

	liver_traits = list(TRAIT_BOMJ_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	metalocked = TRUE

/datum/job/bomj/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	if(latejoin)
		H.forceMove(pick(GLOB.disposal_bins))
