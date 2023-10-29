/datum/surgery/hepatectomy
	name = "Реконструкция: Гепатэктомия"
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_real_bodypart = TRUE
	steps = list(/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/hepatectomy,
		/datum/surgery_step/close
		)
/*
/datum/surgery/hepatectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/liver/L = target.get_organ_slot(ORGAN_SLOT_LIVER)
	if(L?.damage > 50 && !(L.organ_flags & ORGAN_FAILING))
		return TRUE
*/
/datum/surgery/hepatectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/liver/L = target.get_organ_slot(ORGAN_SLOT_LIVER)
	if(L)
		if(L.damage > 60 && !L.operated)
			return TRUE
	return FALSE

////hepatectomy, removes damaged parts of the liver so that the liver may regenerate properly
//95% chance of success, not 100 because organs are delicate
/datum/surgery_step/hepatectomy
	name = "Удалить поврежденную долю печени"
	implements = list(TOOL_SCALPEL = 95, /obj/item/melee/energy/sword = 65, /obj/item/kitchen/knife = 45,
		/obj/item/shard = 35)
	time = 52

/datum/surgery_step/hepatectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Вы начинаете удалять поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает удалять поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает удалять поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		playsound(get_turf(target), 'sound/surgery/scalpel1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Моя печень горит ужасной, колющей болью!")

/datum/surgery_step/hepatectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/H = target
	var/obj/item/organ/liver/L = H.get_organ_slot(ORGAN_SLOT_LIVER)
	L.operated = TRUE
	H.setOrganLoss(ORGAN_SLOT_LIVER, 60) //not bad, not great
	display_results(user, target, span_notice("Вы успешно удалили поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно удалил поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно удалил поврежденную долю печени [skloname(target.name, RODITELNI, target.gender)].") ,
		playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Боль медленно утихает.")
	return ..()

/datum/surgery_step/hepatectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery)
	var/mob/living/carbon/human/H = target
	H.adjustOrganLoss(ORGAN_SLOT_LIVER, 15)
	display_results(user, target, span_warning("Вы случайно удалили здоровую часть печени [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] случайно удалил здоровую часть печени [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] случайно удалил здоровую часть печени [skloname(target.name, RODITELNI, target.gender)]!") ,
		playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Чувствую острую боль от надреза в своей печени!")
