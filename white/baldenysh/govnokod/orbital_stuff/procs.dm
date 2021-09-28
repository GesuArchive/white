/datum/controller/subsystem/processing/orbits/proc/add_objective(datum/orbital_objective/objective)
	objective.generate_payout()
	possible_objectives += objective
	update_objective_computers()

/client/proc/create_orbital_objective()
	set category = "Дбг"
	set name = "Create Orbital Objective"

	if(!check_rights())
		return

	var/objective_path = text2path(input("Enter orbital objective type path", "A.M.O.G.U.S.") as null|text)
	if(!objective_path || !ispath(objective_path, /datum/orbital_objective))
		to_chat(usr,span_warning("debil"))
		return

	SSorbits.add_objective(new objective_path())
	to_chat(usr,span_notice("Objective created: [objective_path]"))

