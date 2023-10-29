/datum/surgery/healing
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/incise,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/heal,
				/datum/surgery_step/close)

	target_mobtypes = list(/mob/living)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = FALSE
	replaced_by = /datum/surgery
	ignore_clothes = TRUE
	var/healing_step_type
	var/antispam = FALSE

/datum/surgery/healing/can_start(mob/user, mob/living/patient)
	. = ..()
	if(isanimal(patient))
		var/mob/living/simple_animal/critter = patient
		if(!critter.healable)
			return FALSE
	if(!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE

/datum/surgery/healing/New(surgery_target, surgery_location, surgery_bodypart)
	..()
	if(healing_step_type)
		steps = list(/datum/surgery_step/incise/nobleed,
					healing_step_type, //hehe cheeky
					/datum/surgery_step/close)

/datum/surgery_step/heal
	name = "восстановить тело"
	implements = list(TOOL_HEMOSTAT = 100, TOOL_SCREWDRIVER = 65, /obj/item/pen = 55)
	repeatable = TRUE
	time = 25
	var/brutehealing = 0
	var/burnhealing = 0
	var/missinghpbonus = 0 //heals an extra point of damager per X missing damage of type (burn damage for burn healing, brute for brute). Smaller Number = More Healing!

/datum/surgery_step/heal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/woundtype
	if(brutehealing && burnhealing)
		woundtype = "раны"
	else if(brutehealing)
		woundtype = "синяки"
	else //why are you trying to 0,0...?
		woundtype = "ожоги"
	if(istype(surgery,/datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		if(!the_surgery.antispam)
			display_results(user, target, span_notice("Пытаюсь залатать [woundtype] [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] пытается залатать [woundtype] [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] пытается залатать [woundtype] [skloname(target.name, RODITELNI, target.gender)].") ,
		playsound(get_turf(target), 'sound/surgery/retractor2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))

/datum/surgery_step/heal/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	while((brutehealing && target.getBruteLoss()) || (burnhealing && target.getFireLoss()))
		if(!..())
			break

/datum/surgery_step/heal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/umsg = "Успешно залатываю некоторые раны [skloname(target.name, RODITELNI, target.gender)]" //no period, add initial space to "addons"
	var/tmsg = "[user] залатывает некоторые раны [skloname(target.name, RODITELNI, target.gender)]" //see above
	var/urhealedamt_brute = brutehealing
	var/urhealedamt_burn = burnhealing
	if(missinghpbonus)
		if(target.stat != DEAD)
			urhealedamt_brute += round((target.getBruteLoss()/ missinghpbonus),0.1)
			urhealedamt_burn += round((target.getFireLoss()/ missinghpbonus),0.1)
		else //less healing bonus for the dead since they're expected to have lots of damage to begin with (to make TW into defib not TOO simple)
			urhealedamt_brute += round((target.getBruteLoss()/ (missinghpbonus*5)),0.1)
			urhealedamt_burn += round((target.getFireLoss()/ (missinghpbonus*5)),0.1)
	if(!get_location_accessible(target, target_zone))
		urhealedamt_brute *= 0.55
		urhealedamt_burn *= 0.55
		umsg += " настолько хорошо, насколько смог из-за мешающейся одежды."
		tmsg += " настолько хорошо, насколько смог из-за мешающейся одежды."
	target.heal_bodypart_damage(urhealedamt_brute,urhealedamt_burn)
	display_results(user, target, span_notice("[umsg].") ,
		span_notice("[tmsg]."),
		span_notice("[tmsg]."),
		playsound(get_turf(target), 'sound/surgery/retractor2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	if(istype(surgery, /datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		the_surgery.antispam = TRUE
	return ..()

/datum/surgery_step/heal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался!") ,
		span_warning("[user] облажался!") ,
		span_notice("[user] залатывает некоторые раны [skloname(target.name, RODITELNI, target.gender)].") , TRUE,
		playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1),)
	var/urdamageamt_burn = brutehealing * 0.8
	var/urdamageamt_brute = burnhealing * 0.8
	if(missinghpbonus)
		urdamageamt_brute += round((target.getBruteLoss()/ (missinghpbonus*2)),0.1)
		urdamageamt_burn += round((target.getFireLoss()/ (missinghpbonus*2)),0.1)

	target.take_bodypart_damage(urdamageamt_brute, urdamageamt_burn, wound_bonus=CANT_WOUND)
	return FALSE

/datum/surgery/healing/proc/overwrite(mob/user, mob/living/patient)
	. = TRUE	// Если есть чип - ДА
	if(isanimal(patient))	// Отбраковка по условиям
		var/mob/living/simple_animal/critter = patient
		if(!critter.healable)
			return FALSE
	if(!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE
	// Перезапись от операционного компьютера
	var/turf/T = get_turf(patient)
	var/obj/machinery/computer/operating/opcomputer
	var/obj/structure/table/optable/table = locate(/obj/structure/table/optable, T)
	if(table?.computer)
		opcomputer = table.computer
	else
		var/obj/machinery/stasis/the_stasis_bed = locate(/obj/machinery/stasis, T)
		if(the_stasis_bed?.op_computer)
			opcomputer = the_stasis_bed.op_computer
	if(opcomputer)
		if(opcomputer.machine_stat & (NOPOWER|BROKEN))
			return FALSE
		if(replaced_by in opcomputer.advanced_surgeries)
			return FALSE
		if(type in opcomputer.advanced_surgeries)
			return TRUE

/***************************BRUTE***************************/
/datum/surgery/healing/brute
	name = "Лечение Ран (Ушибов)"

/datum/surgery/healing/brute/basic
	name = "Лечение Ран (Ушибов, Базовое)"
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при физических ранах. Лечение немного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/brute/upgraded
	healing_step_type = /datum/surgery_step/heal/brute/basic

/datum/surgery/healing/brute/basic/can_start(mob/user, mob/living/carbon/target)
	// Не показывать если есть скилчип хирурга Т1,Т2,Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user, TRAIT_KNOW_VIR_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_VIR_SURGERY_T1) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return FALSE
	else
		return ..()

/datum/surgery/healing/brute/upgraded
	name = "Лечение Ран (Ушибов, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при физических ранах. Лечение более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/brute/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded

/datum/surgery/healing/brute/upgraded/can_start(mob/user, mob/living/patient)
	// Не показывать если есть скилчип хирурга Т2,Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return FALSE
	// Скилчип хирурга Т1
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user, TRAIT_KNOW_VIR_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_VIR_SURGERY_T1))
		return overwrite(user, patient)
	else
		. = ..()

/datum/surgery/healing/brute/femto
	name = "Лечение Ран (Ушибов, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при физических ранах. Лечение намного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/combo/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded/femto

/datum/surgery/healing/brute/femto/can_start(mob/user, mob/living/patient)
	// Скилчип хирурга Т2 Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return overwrite(user, patient)
	else
		. = ..()

/********************BRUTE STEPS********************/
/datum/surgery_step/heal/brute/basic
	name = "лечение ран"
	brutehealing = 5
	missinghpbonus = 15

/datum/surgery_step/heal/brute/upgraded
	brutehealing = 5
	missinghpbonus = 10

/datum/surgery_step/heal/brute/upgraded/femto
	brutehealing = 5
	missinghpbonus = 5

/***************************BURN***************************/
/datum/surgery/healing/burn
	name = "Лечение Ран (Ожогов)"

/datum/surgery/healing/burn/basic
	name = "Лечение Ран (Ожогов, Базовое)"
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при ожоговых ранах. Лечение немного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/burn/upgraded
	healing_step_type = /datum/surgery_step/heal/burn/basic

/datum/surgery/healing/burn/basic/can_start(mob/user, mob/living/carbon/target)
	// Не показывать если есть скилчип хирурга Т1,Т2,Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user, TRAIT_KNOW_VIR_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_VIR_SURGERY_T1) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return FALSE
	else
		return ..()

/datum/surgery/healing/burn/upgraded
	name = "Лечение Ран (Ожогов, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при ожоговых ранах. Лечение более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/burn/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded

/datum/surgery/healing/burn/upgraded/can_start(mob/user, mob/living/patient)
	// Не показывать если есть скилчип хирурга Т2,Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return FALSE
	// Скилчип хирурга Т1
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user, TRAIT_KNOW_VIR_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_VIR_SURGERY_T1))
		return overwrite(user, patient)
	else
		. = ..()

/datum/surgery/healing/burn/femto
	name = "Лечение Ран (Ожогов, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при ожоговых ранах. Лечение намного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/combo/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded/femto

/datum/surgery/healing/burn/femto/can_start(mob/user, mob/living/patient)
	// Скилчип хирурга Т2 Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return overwrite(user, patient)
	else
		. = ..()

/********************BURN STEPS********************/
/datum/surgery_step/heal/burn/basic
	name = "лечение ожогов"
	burnhealing = 5
	missinghpbonus = 15

/datum/surgery_step/heal/burn/upgraded
	burnhealing = 5
	missinghpbonus = 10

/datum/surgery_step/heal/burn/upgraded/femto
	burnhealing = 5
	missinghpbonus = 5

/***************************COMBO***************************/
/datum/surgery/healing/combo


/datum/surgery/healing/combo/basic
	name = "Лечение Ран (Смешанных, Основное)"
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение немного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/combo/upgraded
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo

/datum/surgery/healing/combo/basic/can_start(mob/user, mob/living/patient)
	// Не показывать если есть скилчип хирурга Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return FALSE
	// Скилчип хирурга Т2
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2))
		return overwrite(user, patient)
	else
		. = ..()

/datum/surgery/healing/combo/upgraded
	name = "Лечение Ран (Смешанных, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/combo/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo/upgraded

/datum/surgery/healing/combo/upgraded/can_start(mob/user, mob/living/patient)
	// Скилчип хирурга Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		return overwrite(user, patient)
	else
		. = ..()

/datum/surgery/healing/combo/femto //no real reason to type it like this except consistency, don't worry you're not missing anything
	name = "Лечение Ран (Смешанных, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при смешанных физических и ожоговых ранах. Лечение намного более эффективно при серьезных травмах."
	replaced_by = null
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo/upgraded/femto

/datum/surgery/healing/combo/femto/can_start(mob/user, mob/living/patient) //FALSE to not show in list
	. = TRUE
	if(replaced_by == /datum/surgery)
		return FALSE

	// True surgeons (like abductor scientists) need no instructions
	if(HAS_TRAIT(user, TRAIT_SURGEON) || HAS_TRAIT(user.mind, TRAIT_SURGEON))
		if(replaced_by) // only show top-level surgeries
			return FALSE
		else
			return TRUE

	if(!requires_tech && !replaced_by)
		return TRUE

	if(requires_tech)
		. = FALSE

	if(iscyborg(user))
		var/mob/living/silicon/robot/R = user
		var/obj/item/surgical_processor/SP = locate() in R.module.modules
		if(SP) //no early return for !SP since we want to check optable should this not exist.
			if(replaced_by in SP.advanced_surgeries)
				return FALSE
			if(type in SP.advanced_surgeries)
				return TRUE

	for(var/obj/item/modular_computer/modcomp in user.held_items | range(1, patient))
		if(!modcomp.screen_on)
			continue
		var/datum/computer_file/program/surgmaster/SM = modcomp.active_program
		if(SM && istype(SM))
			return SM.can_start_surgery(patient, type, replaced_by)

	var/turf/T = get_turf(patient)

	//Get the relevant operating computer
	var/obj/machinery/computer/operating/opcomputer
	var/obj/structure/table/optable/table = locate(/obj/structure/table/optable, T)
	if(table?.computer)
		opcomputer = table.computer
	else
		var/obj/machinery/stasis/the_stasis_bed = locate(/obj/machinery/stasis, T)
		if(the_stasis_bed?.op_computer)
			opcomputer = the_stasis_bed.op_computer

	if(!opcomputer)
		if(requires_op)
			return FALSE
	if(opcomputer)
		if(opcomputer.machine_stat & (NOPOWER|BROKEN))
			return FALSE
		if(replaced_by in opcomputer.advanced_surgeries)
			return FALSE
		if(type in opcomputer.advanced_surgeries)
			return TRUE

	if(isanimal(patient))
		var/mob/living/simple_animal/critter = patient
		if(!critter.healable)
			return FALSE
	if(!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE

/********************COMBO STEPS********************/
/datum/surgery_step/heal/combo
	name = "лечение физических травм"
	brutehealing = 3
	burnhealing = 3
	missinghpbonus = 15
	time = 10

/datum/surgery_step/heal/combo/upgraded
	brutehealing = 3
	burnhealing = 3
	missinghpbonus = 10

/datum/surgery_step/heal/combo/upgraded/femto
	brutehealing = 1
	burnhealing = 1
	missinghpbonus = 2.5

/datum/surgery_step/heal/combo/upgraded/femto/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался!") ,
		span_warning("[user] облажался!") ,
		span_notice("[user] залатывает некоторые раны [skloname(target.name, RODITELNI, target.gender)].") , TRUE)
	target.take_bodypart_damage(5,5)
