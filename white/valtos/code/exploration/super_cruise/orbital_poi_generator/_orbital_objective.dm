/datum/orbital_objective
	var/name = "Null Objective"
	var/datum/orbital_object/z_linked/beacon/ruin/linked_beacon
	var/payout = 0
	var/completed = FALSE
	var/min_payout = 0
	var/max_payout = 0
	var/id = 0
	var/station_name
	var/static/objective_num = 0

/datum/orbital_objective/New()
	. = ..()
	id = objective_num ++
	station_name = new_station_name()

/datum/orbital_objective/proc/on_assign(obj/machinery/computer/objective/objective_computer)
	return

/datum/orbital_objective/proc/generate_objective_stuff(turf/chosen_turf)
	return

/datum/orbital_objective/proc/check_failed()
	return TRUE

/datum/orbital_objective/proc/get_text()
	return ""

/datum/orbital_objective/proc/announce()
	return

/datum/orbital_objective/proc/generate_payout()
	payout = rand(min_payout, max_payout)

/datum/orbital_objective/proc/generate_attached_beacon()
	linked_beacon = new
	linked_beacon.name = "(ЗАДАНИЕ) [linked_beacon.name]"
	linked_beacon.linked_objective = src

/datum/orbital_objective/proc/remove_objective()
	QDEL_NULL(SSorbits.current_objective)

/datum/orbital_objective/proc/complete_objective()
	if (SSorbits.current_objective == src)
		SSorbits.current_objective = null
	if(completed)
		//Delete
		QDEL_NULL(SSorbits.current_objective)
		return
	completed = TRUE
	//Handle payout
	var/rangers_count = 0
	for(var/I in SSjob.occupations)
		var/datum/job/J = I
		if(istype(J, /datum/job/exploration))
			rangers_count = J.current_positions

	var/israel = 0
	if(rangers_count)
		israel = round((payout / 2) / rangers_count)
	var/goyam  = round((payout / 2) / SSeconomy.generated_accounts.len)
	for(var/B in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/A = SSeconomy.bank_accounts_by_id[B]
		if(istype(A.account_job, /datum/job/exploration))
			A.bank_card_talk("Было получено [israel] кредитов за выполнение задания.")
			A.adjust_money(israel)
		else
			A.bank_card_talk("Было получено [goyam] кредитов за содействие выполнению поручений NanoTrasen.")
			A.adjust_money(goyam)
	GLOB.exploration_points += payout / 2
	//Delete
	QDEL_NULL(SSorbits.current_objective)
