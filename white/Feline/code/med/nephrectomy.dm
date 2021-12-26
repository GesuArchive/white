/datum/surgery/nephrectomy
	name = "Реконструкция: Нефрэктомия"
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_real_bodypart = TRUE
	steps = list(/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/nephrectomy,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/close
		)

/datum/surgery/nephrectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/kidneys/L = target.getorganslot(ORGAN_SLOT_KIDNEYS)
	if(L)
		if(L.damage > 60 && !L.operated)
			return TRUE
	return FALSE

/datum/surgery_step/nephrectomy
	name = "удалить поврежденную почку"
	implements = list(TOOL_HEMOSTAT = 90, TOOL_WIRECUTTER = 35)
	time = 52

/datum/surgery_step/nephrectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю удалять поврежденную почку [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает удалять поврежденную почку [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает удалять поврежденную почку [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/nephrectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/H = target
	var/obj/item/organ/kidneys/L = H.getorganslot(ORGAN_SLOT_KIDNEYS)
	L.operated = TRUE
	H.setOrganLoss(ORGAN_SLOT_KIDNEYS, 60) // Stomachs have a threshold for being able to even digest food, so I might tweak this number
	display_results(user, target, span_notice("Успешно удалил поврежденную почку [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно удалил поврежденную почку [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно удалил поврежденную почку [skloname(target.name, RODITELNI, target.gender)]."))
	return ..()

/datum/surgery_step/nephrectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery)
	var/mob/living/carbon/human/H = target
	H.adjustOrganLoss(ORGAN_SLOT_LIVER, 15)
	display_results(user, target, span_warning("Я был неаккуратен и своими действиями случайно повредил располагающуюся рядом печень [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] действует неаккуратно и задевает располагающуюся рядом печень [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] действует неаккуратно и задевает располагающуюся рядом печень [skloname(target.name, RODITELNI, target.gender)]!"))
