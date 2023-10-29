/datum/surgery/advanced/necrotic_revival
	name = "Некротическое воскрешение"
	desc = "Экспериментальная хирургическая процедура, которая стимулирует рост опухоли Ромерола внутри мозга пациента. Требует порошок зомби или Резадон."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/saw,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/bionecrosis,
				/datum/surgery_step/close)

	possible_locs = list(BODY_ZONE_HEAD)

/datum/surgery/advanced/necrotic_revival/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	var/obj/item/organ/zombie_infection/ZI = target.get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(ZI)
		return FALSE

/datum/surgery_step/bionecrosis
	name = "начать бионекроз"
	implements = list(/obj/item/reagent_containers/syringe = 100, /obj/item/pen = 30)
	time = 50
	chems_needed = list(/datum/reagent/toxin/zombiepowder, /datum/reagent/medicine/rezadone)
	require_all_chems = FALSE

/datum/surgery_step/bionecrosis/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Стимулирую рост опухоли Ромерола в мозгу [target]...") ,
		span_notice("[user] начинает возиться с мозгом [target]...") ,
		span_notice("[user] начинает операцию на мозге [target]."))

/datum/surgery_step/bionecrosis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Успешно стимулировал рост опухоли Ромерола в мозгу [target].") ,
		span_notice("[user] успешно вырастил опухоль Ромерола в мозгу [target]!") ,
		span_notice("[user] завершил операцию на мозге [target]."))
	if(!target.get_organ_slot(ORGAN_SLOT_ZOMBIE))
		var/obj/item/organ/zombie_infection/ZI = new()
		ZI.Insert(target)
	return ..()
