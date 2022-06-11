/datum/crew_manifest

/datum/crew_manifest/ui_state(mob/user)
	return GLOB.always_state

/datum/crew_manifest/ui_status(mob/user, datum/ui_state/state)
	return (isnewplayer(user) || isobserver(user) || isAI(user) || ispAI(user)) ? UI_INTERACTIVE : UI_CLOSE

/datum/crew_manifest/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewManifest")
		ui.open()

/datum/crew_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if (..())
		return

/datum/crew_manifest/ui_data(mob/user)
	var/list/positions = list(
		"Командование" = 0,
		"Охрана" = 0,
		"Инженерный" = 0,
		"Медицинский" = 0,
		"Научный" = 0,
		"Снабжение" = 0,
		"Обслуга" = 0,
		"Синтетики" = 0,
		"Гости" = 0
	)
	var/list/departments = list(
		list("flag" = DEPARTMENT_COMMAND, "name" = "Командование"),
		list("flag" = DEPARTMENT_SECURITY, "name" = "Охрана"),
		list("flag" = DEPARTMENT_ENGINEERING, "name" = "Инженерный"),
		list("flag" = DEPARTMENT_MEDICAL, "name" = "Медицинский"),
		list("flag" = DEPARTMENT_SCIENCE, "name" = "Научный"),
		list("flag" = DEPARTMENT_CARGO, "name" = "Снабжение"),
		list("flag" = DEPARTMENT_SERVICE, "name" = "Обслуга"),
		list("flag" = DEPARTMENT_SILICON, "name" = "Синтетики"),
		list("flag" = DEPARTMENT_UNASSIGNED, "name" = "Гости")
	)

	for(var/job in SSjob.occupations)
		for(var/department in departments)
			// Check if the job is part of a department using its flag
			// Will return true for Research Director if the department is Science or Command, for example
			if(job["departments"] & department["flag"])
				// Add open positions to current department
				positions[department["name"]] += (job["total_positions"] - job["current_positions"])

	return list(
		"manifest" = GLOB.data_core.get_manifest(),
		"positions" = positions
	)
