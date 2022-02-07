/datum/surgery/blood_filter
	name = "Фильтрация Крови (Химикаты)"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/incise,
				/datum/surgery_step/filter_blood,
				/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = TRUE
	ignore_clothes = FALSE

/datum/surgery/blood_filter/can_start(mob/user, mob/living/carbon/target)
	if(HAS_TRAIT(target, TRAIT_HUSK)) //You can filter the blood of a dead person just not husked
		return FALSE
	return ..()

/datum/surgery_step/filter_blood
	name = "Фильтрация крови"
	implements = list(TOOL_BLOODFILTER = 95)
	repeatable = TRUE
	time = 2.5 SECONDS

/datum/surgery_step/filter_blood/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю фильтрацию крови [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] использует [tool] для фильтрации моей крови.") ,
		span_notice("[user] использует [tool] на груди [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "You feel a throbbing pain in your chest!")

/datum/surgery_step/filter_blood/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target.reagents?.total_volume)
		for(var/blood_chem in target.reagents.reagent_list)
			var/datum/reagent/chem = blood_chem
			target.reagents.remove_reagent(chem.type, min(chem.volume * 0.22 + 2, 10))
	display_results(user, target, span_notice("Закончив фильтрацию крови [skloname(target.name, RODITELNI, target.gender)] [tool] издает короткий звон.") ,
		span_notice("Закончив качать мою кровь [tool] издает короткий звон.") ,
		span_notice("Закончив качать [tool] издает короткий звон.") ,
		playsound(get_turf(target), 'sound/machines/ping.ogg', 25, TRUE, falloff_exponent = 12, falloff_distance = 1))
	return ..()

/datum/surgery_step/filter_blood/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("[gvorno(TRUE)], но [gvorno(TRUE)], но я облажался, оставив синяк на груди [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] облажался, оставив синяк на груди [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] облажался!"))
	target.adjustBruteLoss(5)

//Зацикленность фильтрации
/datum/surgery_step/filter_blood/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	while(target.reagents?.total_volume > 0.25)
		if(!..())
			break

