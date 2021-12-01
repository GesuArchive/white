/datum/surgery/lobectomy
	name = "Реконструкция: Лобэктомия"	//not to be confused with lobotomy
	steps = list(
		/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/lobectomy, /datum/surgery_step/close,
	)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/lobectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/lungs/L = target.getorganslot(ORGAN_SLOT_LUNGS)
	if(L)
		if(L.damage > 60 && !L.operated)
			return TRUE
	return FALSE


//lobectomy, removes the most damaged lung lobe with a 95% base success chance
/datum/surgery_step/lobectomy
	name = "отсечь поврежденный сегмент легкого"
	implements = list(TOOL_SCALPEL = 95, /obj/item/melee/energy/sword = 65, /obj/item/kitchen/knife = 45,
		/obj/item/shard = 35)
	time = 42

/datum/surgery_step/lobectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Вы начинаете делать надрез в легких [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает делать надрез в легких [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает делать надрез в легких [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/lobectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/lungs/L = H.getorganslot(ORGAN_SLOT_LUNGS)
		L.operated = TRUE
		H.setOrganLoss(ORGAN_SLOT_LUNGS, 60)
		display_results(user, target, span_notice("Вы успешно удалили наиболее поврежденный сегмент легких [H].") ,
			span_notice("Поврежденный сегмент легких [H] был успешно удален.") ,
			"")
	return ..()

/datum/surgery_step/lobectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		display_results(user, target, span_warning("Вы ошиблись и повредили здоровую часть легкого [H]!") ,
			span_warning("[user] ошибся!") ,
			span_warning("[user] ошибся!"))
		H.losebreath += 4
		H.adjustOrganLoss(ORGAN_SLOT_LUNGS, 10)
	return FALSE
