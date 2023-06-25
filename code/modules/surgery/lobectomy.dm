/datum/surgery/lobectomy
	name = "Реконструкция: Лобэктомия"	//not to be confused with lobotomy
	steps = list(
		/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/lobectomy, /datum/surgery_step/close,
	)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/lobectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/lungs/L = target.get_organ_slot(ORGAN_SLOT_LUNGS)
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
	display_results(user, target, span_notice("Начинаю делать надрез в легких [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает делать надрез в легких [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает делать надрез в легких [skloname(target.name, RODITELNI, target.gender)].") ,
		playsound(get_turf(target), 'sound/surgery/scalpel1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Чувствую колющую боль в груди!")

/datum/surgery_step/lobectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/lungs/L = H.get_organ_slot(ORGAN_SLOT_LUNGS)
		L.operated = TRUE
		H.setOrganLoss(ORGAN_SLOT_LUNGS, 60)
		display_results(user, target, span_notice("Успешно удаляю наиболее поврежденный сегмент легких [H].") ,
			span_notice("Поврежденный сегмент легких [H] был успешно удален.") ,
			playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1),
			"")
		display_pain(target, "Грудь адски болит, но дышать стало немного проще.")
	return ..()

/datum/surgery_step/lobectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		display_results(user, target, span_warning("Я ошибся и повредил здоровую часть легкого [H]!") ,
			span_warning("[user] ошибся!") ,
			span_warning("[user] ошибся!") ,
			playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "Чувствую колющую боль в груди. У меня сбилось дыхание и теперь мне больно дышать!")
		H.losebreath += 4
		H.adjustOrganLoss(ORGAN_SLOT_LUNGS, 10)
	return FALSE
