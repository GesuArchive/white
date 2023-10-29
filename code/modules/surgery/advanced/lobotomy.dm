/datum/surgery/advanced/lobotomy
	name = "Операция на Мозге: Лоботомия"
	desc = "Инвазивная хирургическая процедура, которая гарантированно устраняет большинство травм мозга, но может привести к другому постоянному повреждению."
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/saw,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/lobotomize,
	/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = 0

/datum/surgery/advanced/lobotomy/can_start(mob/user, mob/living/carbon/target)

	// Скилчип хирурга Т2 Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
		if(!B)
			return FALSE
		return TRUE
	else
		if(!..())
			return FALSE
	var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return TRUE

/datum/surgery_step/lobotomize
	name = "выполнить лоботомию"
	implements = list(TOOL_SCALPEL = 85, /obj/item/melee/energy/sword = 55, /obj/item/kitchen/knife = 35,
		/obj/item/shard = 25, /obj/item = 20)
	time = 100

/datum/surgery_step/lobotomize/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	return TRUE

/datum/surgery_step/lobotomize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю проведение лоботомии на мозге [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает проведение лоботомии на мозге [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/lobotomize/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Успешно выполнил лоботомию [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно выполнил лоботомию [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] завершает операцию [skloname(target.name, RODITELNI, target.gender)]."))
	target.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	switch(rand(1,3))//Now let's see what hopefully-not-important part of the brain we cut off
		if(1)
			target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
		if(2)
			if(HAS_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
			else
				target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
		if(3)
			target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	return ..()

/datum/surgery_step/lobotomize/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(B)
		display_results(user, target, span_warning("Извлек неверную часть, что привело к большим повреждениям!") ,
			span_notice("[user] успешно выполнил лоботомию [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] завершает операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
		B.applyOrganDamage(80)
		switch(rand(1,3))
			if(1)
				target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
			if(2)
				if(HAS_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
					target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
				else
					target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
			if(3)
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
	else
		user.visible_message(span_warning("[user] внезапно замечает что мозг [user.ru_who()] над которым работал [user.p_were()] исчез.") , span_warning("Внезапно обнаруживаю что мозг, над которым я работал, исчез."))
	return FALSE
