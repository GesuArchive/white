/datum/surgery/dissection
	name = "Вскрытие"
	requires_op = TRUE
	target_mobtypes = list(
		/mob/living/carbon/human,
		/mob/living/carbon/alien,
	)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_real_bodypart = TRUE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/dissection,
		/datum/surgery_step/close,
	)

/datum/surgery/dissection/can_start(mob/user, mob/living/patient)
	. = ..()

	// This isn't a real advanced tech, but it doesn't make sense using it without an operating computer
	if (isnull(locate_operating_computer(get_turf(patient))))
		return FALSE

	if (HAS_TRAIT(patient, TRAIT_DISSECTED))
		return FALSE

	if (patient.stat != DEAD)
		return FALSE

	return TRUE

/datum/surgery_step/dissection
	name = "Исследовать"
	time = 16 SECONDS
	implements = list(
		TOOL_SCALPEL = 100,
		/obj/item/melee/energy/sword = 75,
		/obj/item/kitchen/knife = 65,
		/obj/item/shard = 45,
		/obj/item = 30,
	)

/datum/surgery_step/dissection/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/ending = "..."
	if (isnull(surgery.locate_operating_computer(get_turf(target))))
		ending = "<b>, однако без операционного компьютера у меня не выйдет интерпретировать данные полученные при вскрытии!</b>"

	display_results(
		user,
		target,
		span_notice("Начинаю патологоанатомическое вскрытие [target][ending]"),
		span_notice("[user] начинает патологоанатомическое вскрытие [target]..."),
		span_notice("[user] начинает патологоанатомическое вскрытие!"),
	)

/datum/surgery_step/dissection/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	ADD_TRAIT(target, TRAIT_DISSECTED, REF(src))

	var/obj/machinery/computer/operating/operating_computer = surgery.locate_operating_computer(get_turf(target))
	if (!isnull(operating_computer))
		SEND_SIGNAL(operating_computer, COMSIG_OPERATING_COMPUTER_DISSECTION_COMPLETE, target)

	return TRUE

/datum/surgery_step/dissection/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob)
	display_results(
		user,
		target,
		span_notice("Кажется я это был не очень аккуратный разрез! Впрочем пациенту кажется уже все равно..."),
		span_notice("[user] действует очень неаккуратно! Впрочем пациенту кажется уже все равно..."),
		span_notice("[user] действует очень неаккуратно! Впрочем пациенту кажется уже все равно...!")
	)

	target.adjustOrganLoss(pick(
		ORGAN_SLOT_APPENDIX,
		ORGAN_SLOT_BRAIN,
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_STOMACH,
	), 20)

	return FALSE

/datum/surgery_step/dissection/tool_check(mob/user, obj/item/tool)
	return implement_type != /obj/item || tool.get_sharpness() > 0
