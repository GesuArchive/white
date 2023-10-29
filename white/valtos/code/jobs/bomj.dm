/datum/job/bomj
	title = JOB_BOMJ
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
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

/datum/job/bomj/override_latejoin_spawn(mob/living/carbon/human/H)
	H.forceMove(pick(GLOB.disposal_bins))
	return TRUE
