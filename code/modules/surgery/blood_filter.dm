/datum/surgery/blood_filter
	name = "Фильтрация крови"
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
	implements = list(/obj/item/blood_filter = 95)
	repeatable = TRUE
	time = 2.5 SECONDS

/datum/surgery_step/filter_blood/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю фильтрацию крови [target]...</span>",
		"<span class='notice'>[user] использует [tool] для фильтрации моей крови.</span>",
		"<span class='notice'>[user] использует [tool] на груди [target].</span>")

/datum/surgery_step/filter_blood/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target.reagents?.total_volume)
		for(var/blood_chem in target.reagents.reagent_list)
			var/datum/reagent/chem = blood_chem
			target.reagents.remove_reagent(chem.type, min(chem.volume * 0.22, 10))
	display_results(user, target, "<span class='notice'>Закончив фильтрацию крови [target] [tool] издает короткий звон.</span>",
		"<span class='notice'>Закончив качать мою кровь [tool] издает короткий звон.</span>",
		"Закончив качать [tool] издает короткий звон.")
	return ..()

/datum/surgery_step/filter_blood/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='warning'>Я облажался, оставив синяк на груди [target]!</span>",
		"<span class='warning'>[user] облажался, оставив синяк на груди [target]!</span>",
		"<span class='warning'>[user] облажался!</span>")
	target.adjustBruteLoss(5)
