/datum/surgery/brain_surgery
	name = "Операция на Мозге: Нейрохирургия"
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/saw,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/fix_brain,
	/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = 0

/datum/surgery_step/fix_brain
	name = "исправить мозг"
	implements = list(TOOL_HEMOSTAT = 85, TOOL_SCREWDRIVER = 35, /obj/item/pen = 15) //don't worry, pouring some alcohol on their open brain will get that chance to 100
	repeatable = TRUE
	time = 100 //long and complicated

/datum/surgery/brain_surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return TRUE

/datum/surgery_step/fix_brain/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю исправлять мозг [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает исправлять мозг [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Моя голова отдает невообразимой болью!")

/datum/surgery_step/fix_brain/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Успешно исправил мозг [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно исправил мозг [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] завершил операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Боль в голове утихает, думать становится немного проще!")
	if(target.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.setOrganLoss(ORGAN_SLOT_BRAIN, target.getOrganLoss(ORGAN_SLOT_BRAIN) - 50)	//we set damage in this case in order to clear the "failing" flag
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	target.cure_all_traumas(TRAUMA_RESILIENCE_WOUND)
	if(target.getOrganLoss(ORGAN_SLOT_BRAIN) > 0)
		to_chat(user, "Похоже, что в мозгу [skloname(target.name, RODITELNI, target.gender)] всё еще можно что-то исправить.")
	return ..()

/datum/surgery_step/fix_brain/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался, нанеся еще больший ущерб!") ,
			span_warning("[user] облажался, повредив мозг!") ,
			span_notice("[user] завершил операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Голова пульсирует с ужасной болью, я едва могу соображать!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user] внезапно замечает что мозг [user.ru_who()] над которым работал [user.p_were()] пропал.") , span_warning("Неожиданно обнаруживаю что мозг, над которым я работал, исчез."))
	return FALSE
