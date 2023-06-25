/datum/surgery/revival
	name = "Нейронная Реанимация"
	desc = "Экспериментальная хирургическая операция, которая позволяет вернуть пациента к жизни, даже спустя продолжительное время, главное чтобы тело было в относительно целом состоянии."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/saw,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/revive,
				/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = 0

/datum/surgery/revival/can_start(mob/user, mob/living/carbon/target)
	if(!..())
		return FALSE
	if(target.stat != DEAD)
		return FALSE
	if(target.suiciding || target.hellbound || HAS_TRAIT(target, TRAIT_HUSK))
		return FALSE
	var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return TRUE

/datum/surgery_step/revive
	name = "разряд"
	implements = list(/obj/item/shockpaddles = 100, /obj/item/melee/baton = 75, /obj/item/gun/energy = 60)
	repeatable = TRUE
	time = 5 SECONDS

/datum/surgery_step/revive/tool_check(mob/user, obj/item/tool)
	. = TRUE
	if(istype(tool, /obj/item/shockpaddles))
		var/obj/item/shockpaddles/S = tool
		if((S.req_defib && !S.defib.powered) || !S.wielded || S.cooldown || S.busy)
			to_chat(user, span_warning("Вам необходимо держать электроды в обеих руках, а [S.defib] должен быть заряжен!"))
			return FALSE
	if(istype(tool, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = tool
		if(!B.turned_on)
			to_chat(user, span_warning("[B] должен быть активирован!"))
			return FALSE
	if(istype(tool, /obj/item/gun/energy))
		var/obj/item/gun/energy/E = tool
		if(E.chambered && istype(E.chambered, /obj/item/ammo_casing/energy/electrode))
			return TRUE
		else
			to_chat(user, span_warning("Неоткуда взять разряд!"))
			return FALSE

/datum/surgery_step/revive/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Готовлюсь послать разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
		span_notice("[user] готовится послать разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
		span_notice("[user] готовится послать разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]."))
	target.notify_ghost_cloning("Кто-то пытается послать разряд в мой мозг.", source = target)

/datum/surgery_step/revive/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(user, target, span_notice("Успешно послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]...") ,
		span_notice("[user] успешно послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]...") ,
		span_notice("[user] успешно послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]..."))
	playsound(get_turf(target), 'sound/magic/lightningbolt.ogg', 50, TRUE)
	if(!(target.grab_ghost())) //sosanie
		target.ice_cream_mob = TRUE
		target.ice_cream_check()
	target.adjustOxyLoss(-50, 0)
	target.updatehealth()
	if(target.revive(full_heal = FALSE, admin_revive = FALSE))
		target.visible_message(span_notice("...[target] проснись и пой!"))
		target.emote("gasp")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 50, 199) //MAD SCIENCE
		return TRUE
	else
		target.visible_message(span_warning("...[target.ru_who()] содрогается и замирает."))
		return FALSE

/datum/surgery_step/revive/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool], но [target.ru_who()] не реагирует.") ,
		span_notice("[user] послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool], но [target.ru_who()] не реагирует.") ,
		span_notice("[user] послал разряд в мозг [skloname(target.name, RODITELNI, target.gender)] при помощи [tool], но [target.ru_who()] не реагирует."))
	playsound(get_turf(target), 'sound/magic/lightningbolt.ogg', 50, TRUE)
	target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 15, 180)
	return FALSE
