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
	priority_announce(get_text(), "Центральное командование", SSstation.announcer.get_rand_report_sound())

/datum/orbital_objective/proc/generate_payout()
	payout = rand(min_payout, max_payout)

/datum/orbital_objective/proc/generate_attached_beacon()
	linked_beacon = new
	linked_beacon.name = "(ЗАДАНИЕ) [linked_beacon.name]"
	linked_beacon.linked_objective = src

/datum/orbital_objective/proc/complete_objective()
	if(completed)
		//Delete
		QDEL_NULL(SSorbits.current_objective)
		return
	completed = TRUE
	//Handle payout
	var/delitme = round(payout / SSeconomy.generated_accounts.len)
	for(var/datum/bank_account/B in SSeconomy.generated_accounts)
		B.adjust_money(delitme)
	//SSeconomy.adjust_cargo_money(payout, "ЦК", "*ЗАСЕКРЕЧЕНО*", "Выполнение задания")
	//Announcement
	priority_announce("Задание выполнено. [payout] кредитов было выдано на счёт снабжения.", "Центральное Командование", SSstation.announcer.get_rand_report_sound())
	//Delete
	QDEL_NULL(SSorbits.current_objective)
