/datum/surgery/brain_surgery
	name = "Операция на мозге"
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/saw,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/fix_brain,
	/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = 0

/datum/surgery_step/fix_brain
	name = "исправить мозг"
	implements = list(TOOL_HEMOSTAT = 85, TOOL_SCREWDRIVER = 35, /obj/item/pen = 15) //don't worry, pouring some alcohol on their open brain will get that chance to 100
	repeatable = TRUE
	time = 100 //long and complicated

/datum/surgery/brain_surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/brain/B = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return TRUE

/datum/surgery_step/fix_brain/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю исправлять мозг [target]...</span>",
		"<span class='notice'>[user] начинает исправлять мозг [target].</span>",
		"<span class='notice'>[user] начинает операцию на мозге [target].</span>")

/datum/surgery_step/fix_brain/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>Успешно исправил мозг [target].</span>",
		"<span class='notice'>[user] успешно исправил мозг [target]!</span>",
		"<span class='notice'>[user] завершил операцию на мозге [target].</span>")
	if(target.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.setOrganLoss(ORGAN_SLOT_BRAIN, target.getOrganLoss(ORGAN_SLOT_BRAIN) - 50)	//we set damage in this case in order to clear the "failing" flag
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	if(target.getOrganLoss(ORGAN_SLOT_BRAIN) > 0)
		to_chat(user, "Похоже, что в мозгу [target] всё еще можно что-то исправить.")
	return ..()

/datum/surgery_step/fix_brain/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorganslot(ORGAN_SLOT_BRAIN))
		display_results(user, target, "<span class='warning'>Я облажался, нанеся еще больший ущерб!</span>",
			"<span class='warning'>[user] облажался, нанеся урон мозгу!</span>",
			"<span class='notice'>[user] завершил операцию на мозге [target].</span>")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message("<span class='warning'>[user] внезапно замечает что мозг [user.p_they()] над которым работал [user.p_were()] пропал.</span>", "<span class='warning'>Я неожиданно обнаруживаю что мозг, над которым я работал, исчез.</span>")
	return FALSE
