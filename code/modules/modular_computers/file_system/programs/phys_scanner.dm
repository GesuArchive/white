#define TABLET_MEDICAL_MODE (1<<0)
#define TABLET_CHEMISTRY_MODE (1<<1)

/datum/computer_file/program/phys_scanner
	filename = "phys_scanner"
	filedesc = "Анализатор здоровья"
	category = PROGRAM_CATEGORY_MED
	extended_desc = "Эта программа позволяет сканировать физическое состояние обьекта и выводит его на экран."
	size = 8
	usage_flags = PROGRAM_TABLET
	available_on_ntnet = FALSE
	tgui_id = "NtosPhysScanner"
	program_icon = "barcode"

	var/current_mode = 0
	var/available_modes = NONE

	var/last_record = ""

/datum/computer_file/program/phys_scanner/proc/ReadModes()
	var/reads = list()

	if(available_modes & TABLET_CHEMISTRY_MODE)
		reads += "Reagent"

	if(available_modes & TABLET_MEDICAL_MODE)
		reads += "Health"

	return reads

/datum/computer_file/program/phys_scanner/proc/ReadCurrent()
	if(current_mode & TABLET_CHEMISTRY_MODE)
		return "Reagent"
	if(current_mode & TABLET_MEDICAL_MODE)
		return "Health"

/datum/computer_file/program/phys_scanner/tap(atom/A, mob/living/user, params)
	. = ..()

	switch(current_mode)
		if(TABLET_CHEMISTRY_MODE)
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					last_record = "Химический анализ выявил [reagents_length] [reagents_length > 1 ? "реагента" : "реагент"]"
					for (var/re in A.reagents.reagent_list)
						last_record += "\t [re]"
				else
					last_record = "В [A] не найдено химических веществ."
			else
				last_record = "В [A] не найдено никаких химических веществ."
		if(TABLET_MEDICAL_MODE)
			var/mob/living/carbon/carbon = A
			if(istype(carbon))
				carbon.visible_message(span_notice("[user] анализирует показатели [A]."))
				last_record = healthscan(user, carbon, 1, tochat = FALSE)

/datum/computer_file/program/phys_scanner/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("selectMode")
			switch(params["newMode"])
				if("Reagent")
					current_mode = TABLET_CHEMISTRY_MODE
				if("Health")
					current_mode = TABLET_MEDICAL_MODE

	return UI_UPDATE


/datum/computer_file/program/phys_scanner/ui_data(mob/user)
	var/list/data = get_header_data()

	data["set_mode"] = ReadCurrent()
	data["last_record"] = last_record
	data["available_modes"] = ReadModes()

	return data

/datum/computer_file/program/phys_scanner/medical
	available_modes = TABLET_MEDICAL_MODE

/datum/computer_file/program/phys_scanner/chemistry
	available_modes = TABLET_CHEMISTRY_MODE

/datum/computer_file/program/phys_scanner/all
	available_modes = TABLET_MEDICAL_MODE | TABLET_CHEMISTRY_MODE

#undef TABLET_MEDICAL_MODE
#undef TABLET_CHEMISTRY_MODE
