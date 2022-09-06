/datum/surgery/implant_removal
	name = "Извлечение Микроимпланта"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/extract_implant, /datum/surgery_step/close)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)


//extract implant
/datum/surgery_step/extract_implant
	name = "извлеките микроимплант"
	implements = list(TOOL_HEMOSTAT = 100, TOOL_CROWBAR = 65, /obj/item/kitchen/fork = 35)
	time = 64
	var/obj/item/implant/I = null

/datum/surgery_step/extract_implant/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/obj/item/O in target.implants)
		I = O
		break
	if(I)
		display_results(user, target, span_notice("Начинаю извлекать [I] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает извлекать [I] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает извлекать что-то из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Чувствую сильную боль в [ru_gde_zone(target_zone)]!")
	else
		display_results(user, target, span_notice("Начинаю искать микроимпланты в [ru_gde_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает искать микроимпланты в [ru_gde_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает искать что-то в [ru_gde_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/extract_implant/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(I)
		display_results(user, target, span_notice("Извлекаю [I] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно извлек [I] из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] успешно извлек что-то из [ru_otkuda_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!") ,
			playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "Ауч! Кажется из меня что-то вытащили!")
		I.removed(target)

		var/obj/item/implantcase/case
		for(var/obj/item/implantcase/ic in user.held_items)
			case = ic
			break
		if(!case)
			case = locate(/obj/item/implantcase) in get_turf(target)
		if(case && !case.imp)
			case.imp = I
			I.forceMove(case)
			case.update_icon()
			display_results(user, target, span_notice("Помещаю [I] в [case].") ,
				span_notice("[user] помещает [I] в [case]!") ,
				span_notice("[user] помещает что-то в [case]!"))
		else
			qdel(I)

	else
		to_chat(user, span_warning("Я ничего не нашел в [target_zone] [skloname(target.name, RODITELNI, target.gender)]!"))
	return ..()

/datum/surgery/implant_removal/mechanic
	name = "Извлечение Микроимпланта (кибер)"
	requires_bodypart_type = BODYPART_ROBOTIC
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close)
