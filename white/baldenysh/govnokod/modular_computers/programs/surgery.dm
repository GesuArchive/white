/datum/computer_file/program/surgmaster
	filename = "SurgMaster"
	filedesc = "Склифосовский"
	extended_desc = "Эта программа позволяет проводить комплексные операции в полевых условиях. Для загрузки операционных программ надо синхронизировать устройство с операционным компьютером через ПКМ интерфейс."
	transfer_access = ACCESS_MEDICAL
	category = PROGRAM_CATEGORY_MED
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_LAPTOP
	program_icon = "stethoscope"
	size = 12
	tgui_id = "NtosOperating"
	var/list/advanced_surgeries = list()
	var/mob/living/carbon/patient

/datum/computer_file/program/surgmaster/tap(atom/A, mob/living/user)
	if(iscarbon(A))
		patient = A
		to_chat(user, span_notice("Обнаружен пациент: [A]."))
		return TRUE
	if(istype(A, /obj/item/disk/surgery))
		to_chat(user, span_notice("Загружаю хирургические протоколы из [A] в [filename]."))
		var/obj/item/disk/surgery/D = A
		if(do_after(user, 10, target = A))
			advanced_surgeries |= D.surgeries
			return TRUE
	if(istype(A, /obj/machinery/computer/operating))
		to_chat(user, span_notice("Копирую хирургические протоколы из [A] в [filename]."))
		var/obj/machinery/computer/operating/OC = A
		if(do_after(user, 10, target = A))
			advanced_surgeries |= OC.advanced_surgeries
			return TRUE

/datum/computer_file/program/surgmaster/proc/can_start_surgery(mob/living/target, surgtype, replacedby) //мб приколы с дисками впилить потом
	patient = target
	if(replacedby in advanced_surgeries)
		return FALSE
	if(surgtype in advanced_surgeries)
		return TRUE

/datum/computer_file/program/surgmaster/clone()
	var/datum/computer_file/program/surgmaster/temp = ..()
	temp.advanced_surgeries = advanced_surgeries
	return temp
/*
/datum/computer_file/program/surgmaster/ui_act(action, params)
	. = ..()
	if(.)
		return
*/

/datum/computer_file/program/surgmaster/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/datum/computer_file/program/surgmaster/ui_data(mob/user)
	if(patient)
		if(get_dist_euclidian(get_turf(computer), get_turf(patient)) > 3)
			patient = null
	var/list/data = get_header_data()
	var/list/surgeries = list()
	for(var/X in advanced_surgeries)
		var/datum/surgery/S = X
		var/list/surgery = list()
		surgery["name"] = initial(S.name)
		surgery["desc"] = initial(S.desc)
		surgeries += list(surgery)
	data["surgeries"] = surgeries
	if(!patient)
		data["patient"] = null
	else
		data["patient"] = list()
		switch(patient.stat)
			if(CONSCIOUS)
				data["patient"]["stat"] = "В сознании"
				data["patient"]["statstate"] = "good"
			if(SOFT_CRIT)
				data["patient"]["stat"] = "В сознании"
				data["patient"]["statstate"] = "average"
			if(UNCONSCIOUS, HARD_CRIT)
				data["patient"]["stat"] = "Без сознания"
				data["patient"]["statstate"] = "average"
			if(DEAD)
				data["patient"]["stat"] = "Мёртв"
				data["patient"]["statstate"] = "bad"
		data["patient"]["health"] = patient.health
		if(patient.dna)
			data["patient"]["blood_type"] = patient.dna.blood_type
		data["patient"]["maxHealth"] = patient.maxHealth
		data["patient"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["patient"]["bruteLoss"] = patient.getBruteLoss()
		data["patient"]["fireLoss"] = patient.getFireLoss()
		data["patient"]["toxLoss"] = patient.getToxLoss()
		data["patient"]["oxyLoss"] = patient.getOxyLoss()
		data["procedures"] = list()
		if(patient.surgeries.len)
			for(var/datum/surgery/procedure in patient.surgeries)
				var/datum/surgery_step/surgery_step = procedure.get_surgery_step()
				var/chems_needed = surgery_step.get_chem_list()
				var/alternative_step
				var/alt_chems_needed = ""
				if(surgery_step.repeatable)
					var/datum/surgery_step/next_step = procedure.get_surgery_next_step()
					if(next_step)
						alternative_step = capitalize(next_step.name)
						alt_chems_needed = next_step.get_chem_list()
					else
						alternative_step = "Завершить операцию"
				data["procedures"] += list(list(
					"name" = capitalize("[parse_zone(procedure.location)] [procedure.name]"),
					"next_step" = capitalize(surgery_step.name),
					"chems_needed" = chems_needed,
					"alternative_step" = alternative_step,
					"alt_chems_needed" = alt_chems_needed
				))
	return data
