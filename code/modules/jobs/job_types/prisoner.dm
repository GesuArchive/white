/datum/job/prisoner
	title = "Prisoner"
	ru_title = "Заключённый"
	department_head = list("The Security Team")
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the security team"
	selection_color = "#ffe1c3"
	paycheck = PAYCHECK_PRISONER
	outfit = /datum/outfit/job/prisoner

	display_order = JOB_DISPLAY_ORDER_PRISONER

	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SCUM

	exclusive_mail_goodies = TRUE
	mail_goodies = list (
		/obj/effect/spawner/lootdrop/prison_contraband = 1
	)

	rpg_title = "Побежденный минибосс"

/datum/job/prisoner/override_latejoin_spawn(mob/living/carbon/human/H)
	for(var/_sloc in GLOB.start_landmarks_list)
		var/obj/effect/landmark/start/sloc = _sloc
		if(sloc.name != title)
			continue
		if(locate(/mob/living) in sloc.loc)
			continue
		H.forceMove(get_turf(sloc))
		return TRUE
	return FALSE

/datum/outfit/job/prisoner
	name = "Prisoner"
	jobtype = /datum/job/prisoner

	uniform = /obj/item/clothing/under/rank/prisoner
	shoes = /obj/item/clothing/shoes/sneakers/orange
	id = /obj/item/card/id/advanced/prisoner
	ears = null
	belt = null

	id_trim = /datum/id_trim/job/prisoner
