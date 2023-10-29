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
		"Командование" = GLOB.command_positions,
		"Охрана" = GLOB.security_positions,
		"Инженерный" = GLOB.engineering_positions,
		"Медицинский" = GLOB.medical_positions,
		"Научный" = GLOB.science_positions,
		"Снабжение" = GLOB.supply_positions,
		"Обслуга" = GLOB.service_positions,
		"Синтетики" = GLOB.nonhuman_positions,
		"Гости" = GLOB.scum_positions
	)

	for(var/job in SSjob.name_occupations)
		for(var/department in departments)
			// Check if the job is part of a department using its flag
			// Will return true for Research Director if the department is Science or Command, for example
			if(job in departments[department])
				var/datum/job/job_datum = SSjob.name_occupations[job]
				// Add open positions to current department
				positions[department] += (job_datum["total_positions"] - job_datum["current_positions"])

	return list(
		"manifest" = GLOB.data_core.get_manifest(),
		"positions" = positions
	)
