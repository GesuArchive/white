/datum/surgery/cavity_implant
	name = "Имплантирование Предмета в Полость"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/incise, /datum/surgery_step/handle_cavity, /datum/surgery_step/close)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)


//handle cavity
/datum/surgery_step/handle_cavity
	name = "поместить или извлечь предмет"
	accept_hand = 1
	implements = list(/obj/item = 100)
	repeatable = TRUE
	time = 32
	var/obj/item/IC = null

/datum/surgery_step/handle_cavity/tool_check(mob/user, obj/item/tool)
	if(tool.tool_behaviour == TOOL_CAUTERY || istype(tool, /obj/item/gun/energy/laser))
		return FALSE
	return !tool.get_temperature()

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/CH = target.get_bodypart(BODY_ZONE_CHEST)
	IC = CH.cavity_item
	if(tool)
		display_results(user, target, span_notice("Начинаю помещать [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает помещать [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает помещать что-то в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "В мою [ru_parse_zone(parse_zone(target_zone))] что-то поместили! Больно!")
	else
		display_results(user, target, span_notice("Начинаю искать инородные объекты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает искать инородные объекты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает искать инородные объекты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery = FALSE)
	var/obj/item/bodypart/chest/CH = target.get_bodypart(BODY_ZONE_CHEST)
	if(tool)
		if(IC || tool.w_class > WEIGHT_CLASS_NORMAL || HAS_TRAIT(tool, TRAIT_NODROP) || istype(tool, /obj/item/organ))
			to_chat(user, span_warning("Кажется [tool] не поместиться в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] из-за слишком крупных размеров!"))
			return FALSE
		else
			display_results(user, target, span_notice("Я успешно поместил [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
				span_notice("[user] поместил [tool] в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_notice("[user] поместил что-то в [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
				playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
			user.transferItemToLoc(tool, target, TRUE)
			CH.cavity_item = tool
			return ..()
	else
		if(IC)
			display_results(user, target, span_notice("Извлекаю [IC] из [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
				span_notice("[user] извлек [IC] из [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_notice("[user] извлек что-то из [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
				playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
			display_pain(target, "Из моей [ru_otkuda_zone(parse_zone(target_zone))] что-то вытаскивают! Это весьма неприятно!")
			user.put_in_hands(IC)
			CH.cavity_item = null
			return ..()
		else
			to_chat(user, span_warning("Я ничего не нашел в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."))
			return FALSE
