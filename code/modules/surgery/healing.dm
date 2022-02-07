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
		display_pain(target, "Your [woundtype] sting like hell!")

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

/***************************BRUTE***************************/
/datum/surgery/healing/brute
	name = "Лечение Ран (Ушибов)"

/datum/surgery/healing/brute/basic
	name = "Лечение Ран (Ушибов, Базовое)"
	replaced_by = /datum/surgery/healing/brute/upgraded
	healing_step_type = /datum/surgery_step/heal/brute/basic
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при физических ранах. Лечение немного более эффективно при серьезных травмах."

/datum/surgery/healing/brute/upgraded
	name = "Лечение Ран (Ушибов, Продвинутое)"
	replaced_by = /datum/surgery/healing/brute/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при физических ранах. Лечение более эффективно при серьезных травмах."

/datum/surgery/healing/brute/upgraded/femto
	name = "Лечение Ран (Ушибов, Экспертное)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded/femto
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при физических ранах. Лечение намного более эффективно при серьезных травмах."

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
	replaced_by = /datum/surgery/healing/burn/upgraded
	healing_step_type = /datum/surgery_step/heal/burn/basic
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при ожоговых ранах. Лечение немного более эффективно при серьезных травмах."

/datum/surgery/healing/burn/upgraded
	name = "Лечение Ран (Ожогов, Продвинутое)"
	replaced_by = /datum/surgery/healing/burn/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при ожоговых ранах. Лечение более эффективно при серьезных травмах."

/datum/surgery/healing/burn/upgraded/femto
	name = "Лечение Ран (Ожогов, Экспертное)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded/femto
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при ожоговых ранах. Лечение намного более эффективно при серьезных травмах."

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


/datum/surgery/healing/combo
	name = "Лечение Ран (Смешанных, Основное)"
	replaced_by = /datum/surgery/healing/combo/upgraded
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение немного более эффективно при серьезных травмах."

/datum/surgery/healing/combo/upgraded
	name = "Лечение Ран (Смешанных, Продвинутое)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	healing_step_type = /datum/surgery_step/heal/combo/upgraded
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение более эффективно при серьезных травмах."


/datum/surgery/healing/combo/upgraded/femto //no real reason to type it like this except consistency, don't worry you're not missing anything
	name = "Лечение Ран (Смешанных, Экспертное)"
	replaced_by = null
	healing_step_type = /datum/surgery_step/heal/combo/upgraded/femto
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при смешанных физических и ожоговых ранах. Лечение намного более эффективно при серьезных травмах."

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
