/datum/surgery/advanced/pacify
	name = "Операция на Мозге: Усмирение"
	desc = "Хирургическая процедура которая навсегда подавляет центр агрессии мозга, делая пациента неспособным нанести прямой вред."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/saw,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/pacify,
				/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = 0

/datum/surgery/advanced/pacify/can_start(mob/user, mob/living/carbon/target)

	// Скилчип хирурга Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
		if(!B)
			return FALSE
		return TRUE
	else
		. = ..()

/datum/surgery_step/pacify
	name = "перепрограммировать мозг"
	implements = list(TOOL_HEMOSTAT = 100, TOOL_SCREWDRIVER = 35, /obj/item/pen = 15)
	time = 40

/datum/surgery_step/pacify/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю умиротворять [skloname(target.name, VINITELNI, target.gender)]...") ,
		span_notice("[user] начинает исправлять мозг [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "В мозгу что то кольнуло и мысли начинают путаться!")

/datum/surgery_step/pacify/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Мне удалось неврологически усмирить [skloname(target.name, VINITELNI, target.gender)].") ,
		span_notice("[user] успешно исправил мозг [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] завершает операцию на могзе [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Голова раскалывается... Но это не важно, ведь мне желают лишь добра...")
	target.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_LOBOTOMY)
	return ..()

/datum/surgery_step/pacify/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("[gvorno(TRUE)], но я облажался, перепутав часть мозга [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_warning("[user] облажался, повредив мозг!") ,
			span_notice("[user] завершает операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
	target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	return FALSE
