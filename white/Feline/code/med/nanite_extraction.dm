/datum/surgery/nanite_extraction
	name = "Удаление нанитов"
	desc = "Фильтрация крови пациента для механического извлечения нанитов из организма носителя."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/nanite_extraction,
		/datum/surgery_step/close
	)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = TRUE
	ignore_clothes = TRUE
	requires_tech = TRUE

/datum/surgery/nanite_extraction/can_start(mob/user, mob/living/carbon/target)
	// Скилчип хирурга Т1 Т2 Т3
	if(HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T1) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T2) || HAS_TRAIT(user, TRAIT_KNOW_MED_SURGERY_T3) || HAS_TRAIT(user.mind, TRAIT_KNOW_MED_SURGERY_T3))
		if(HAS_TRAIT(target, TRAIT_HUSK))
			return FALSE
		return TRUE
	else
		return ..()

/datum/surgery_step/nanite_extraction
	name = "Фильтрация нанитов в крови"
	implements = list(TOOL_BLOODFILTER = 95)
	repeatable = FALSE
	time = 5 SECONDS

/datum/surgery_step/nanite_extraction/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю фильтрацию крови [skloname(target.name, RODITELNI, target.gender)] от нанитов...") ,
		span_notice("[user] использует [tool] для фильтрации моей крови.") ,
		span_notice("[user] использует [tool] на груди [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/nanite_extraction/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(SEND_SIGNAL(target, COMSIG_HAS_NANITES))
		SEND_SIGNAL(target, COMSIG_NANITE_DELETE)
		display_results(user, target, span_notice("[tool] сигнализирует о завершении фильтрации крови [skloname(target.name, RODITELNI, target.gender)] от нанитов.") ,
			span_notice("Закончив фильтрацию, [tool] издает короткий звон.") ,
			span_notice("Закончив работу, [tool] издает короткий звон.") ,
			playsound(get_turf(target), 'sound/machines/ping.ogg', 25, TRUE, falloff_exponent = 12, falloff_distance = 1))
	else
		display_results(user, target, span_notice("[tool] сигнализирует о отсутствии нанитов у [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("Закончив фильтрацию, [tool] издает недовольный двойной пилик.") ,
			span_notice("Закончив работу, [tool] издает недовольный двойной пилик.") ,
			playsound(get_turf(target), 'sound/machines/twobeep.ogg', 25, TRUE, falloff_exponent = 12, falloff_distance = 1))


	return ..()

/datum/surgery_step/nanite_extraction/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("[gvorno(TRUE)], но [gvorno(TRUE)], но я облажался, оставив синяк на груди [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] облажался, оставив синяк на груди [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] облажался!"))
	target.adjustBruteLoss(5)

