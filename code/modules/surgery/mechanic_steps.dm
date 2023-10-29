//open shell
/datum/surgery_step/mechanic_open
	name = "Открутить винты (отвертка)"
	implements = list(
		TOOL_SCREWDRIVER		= 100,
		TOOL_SCALPEL 			= 75, // med borgs could try to unskrew shell with scalpel
		/obj/item/kitchen/knife	= 50,
		/obj/item				= 10) // 10% success with any sharp item.
	time = 24

/datum/surgery_step/mechanic_open/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю откручивать винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает откручивать винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает откручивать винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/items/screwdriver.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Регистрирую инициацию протоколов техобслуживания в [ru_gde_zone(parse_zone(target_zone))].", TRUE)

/datum/surgery_step/mechanic_open/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Успешно откручиваю винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		span_notice("[user] откручивает винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		span_notice("[user] откручивает винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		playsound(get_turf(target), 'sound/items/screwdriver2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	return TRUE

/datum/surgery_step/mechanic_open/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE

	return TRUE

//close shell
/datum/surgery_step/mechanic_close
	name = "Закрутить винты (отвертка)"
	implements = list(
		TOOL_SCREWDRIVER		= 100,
		TOOL_SCALPEL 			= 75,
		/obj/item/kitchen/knife	= 50,
		/obj/item				= 10) // 10% success with any sharp item.
	time = 24

/datum/surgery_step/mechanic_close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю закручивать винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает закручивать винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает закручивать винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/items/screwdriver.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))

/datum/surgery_step/mechanic_close/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Успешно закручиваю винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		span_notice("[user] закручивает винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		span_notice("[user] закручивает винты на [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		playsound(get_turf(target), 'sound/items/screwdriver2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Регистрирую завершение протоколов техобслуживания в [ru_gde_zone(parse_zone(target_zone))].", TRUE)
	return TRUE

/datum/surgery_step/mechanic_close/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE

	return TRUE

//prepare electronics
/datum/surgery_step/prepare_electronics
	name = "Подготовьте электронику (мультитул)"
	implements = list(
		TOOL_MULTITOOL = 100,
		TOOL_HEMOSTAT = 10) // try to reboot internal controllers via short circuit with some conductor
	time = 24

/datum/surgery_step/prepare_electronics/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю подготавливать электронику в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает подготавливать электронику в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает подготавливать электронику в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/items/taperecorder/tape_flip.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Регистрирую инициацию перезапуска центрального контролера в [ru_gde_zone(parse_zone(target_zone))].", TRUE)

/datum/surgery_step/prepare_electronics/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Успешно подготавливаю электронику в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		span_notice("[user] подготавливает электронику в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		span_notice("[user] подготавливает электронику в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."),
		playsound(get_turf(target), 'sound/items/taperecorder/taperecorder_close.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Перезапуск успешен.", TRUE)
	return TRUE

//unwrench
/datum/surgery_step/mechanic_unwrench
	name = "Отвинтите болты (гаечный ключ)"
	implements = list(
		TOOL_WRENCH = 100,
		TOOL_RETRACTOR = 10)
	time = 24

/datum/surgery_step/mechanic_unwrench/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю отвинчивать болты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает отвинчивать болты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает отвинчивать болты в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/items/ratchet.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Крепежные болты [ru_otkuda_zone(parse_zone(target_zone))] расслаблены.", TRUE)

//wrench
/datum/surgery_step/mechanic_wrench
	name = "Завинтите болты (гаечный ключ)"
	implements = list(
		TOOL_WRENCH = 100,
		TOOL_RETRACTOR = 10)
	time = 24

/datum/surgery_step/mechanic_wrench/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Вы начинаете завинчивать болты в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает завинчивать болты в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает завинчивать болты в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/items/ratchet.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Крепежные болты [ru_otkuda_zone(parse_zone(target_zone))] затянуты.", TRUE)

//open hatch
/datum/surgery_step/open_hatch
	name = "Откройте люк (мануальное действие)"
	accept_hand = 1
	time = 10

/datum/surgery_step/open_hatch/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Открываю люк технического обслуживания в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает открывать люк технического обслуживания в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает открывать люк технического обслуживания в [ru_gde_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
		playsound(get_turf(target), 'sound/items/crowbar.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Регистрирую открытие люка технического обслуживания в [ru_gde_zone(parse_zone(target_zone))].", TRUE)
