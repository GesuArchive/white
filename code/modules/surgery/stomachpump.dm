/datum/surgery/stomach_pump
	name = "Фильтрация Желудка (Химикаты)"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/incise,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/stomach_pump,
				/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = TRUE
	ignore_clothes = FALSE
	var/accumulated_experience = 0

/datum/surgery/stomach_pump/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/stomach/S = target.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(HAS_TRAIT(target, TRAIT_HUSK))
		return FALSE
	if(!S)
		return FALSE
	return ..()

//Working the stomach by hand in such a way that you induce vomiting.
/datum/surgery_step/stomach_pump
	name = "надавить на живот"
	accept_hand = TRUE
	repeatable = TRUE
	time = 20

/datum/surgery_step/stomach_pump/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Вы начинаете надавливать на живот [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает надавливать на живот [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает надавливать на живот [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Живот болит!")

/datum/surgery_step/stomach_pump/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		display_results(user, target, span_notice("[user] принуждает [skloname(target.name, RODITELNI, target.gender)] блевать, тем самым очищая желудок от химикатов!") ,
				span_notice("[user] принуждает [skloname(target.name, RODITELNI, target.gender)] блевать, тем самым очищая желудок от химикатов!") ,
				"[user] принуждает [skloname(target.name, RODITELNI, target.gender)] блевать, тем самым очищая желудок от химикатов!")
		H.vomit(20, FALSE, TRUE, 1, TRUE, FALSE, purge_ratio = 0.67) //higher purge ratio than regular vomiting
	return ..()

/datum/surgery_step/stomach_pump/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		display_results(user, target, span_warning("Вы надавили слишком сильно на живот [skloname(target.name, RODITELNI, target.gender)] и оставили синяк!") ,
			span_warning("[user] надавил слишком сильно на живот [skloname(target.name, RODITELNI, target.gender)] и оставил синяк!") ,
			span_warning("[user] ошибся!"))
		H.adjustOrganLoss(ORGAN_SLOT_STOMACH, 5)
		H.adjustBruteLoss(5)
