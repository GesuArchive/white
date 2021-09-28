/datum/surgery/advanced/viral_bonding
	name = "Вирусный Симбиоз"
	desc = "Хирургическая процедура которая устанавливает симбиотические отношения между вирусом и носителем. Пациенту должен быть введен Космоцелин, пища для вирусов и формальдегид."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/viral_bond,
				/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/advanced/viral_bonding/can_start(mob/user, mob/living/carbon/target)
	if(!..())
		return FALSE
	if(!LAZYLEN(target.diseases))
		return FALSE
	return TRUE

/datum/surgery_step/viral_bond
	name = "вирусное сплетение"
	implements = list(TOOL_CAUTERY = 100, TOOL_WELDER = 50, /obj/item = 30) // 30% success with any hot item.
	time = 100
	chems_needed = list(/datum/reagent/medicine/spaceacillin,/datum/reagent/consumable/virus_food,/datum/reagent/toxin/formaldehyde)

/datum/surgery_step/viral_bond/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/viral_bond/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю нагревать спинной мозг [target] используя [tool]...") ,
		span_notice("[user] начинает нагревать спинной мозг [target] используя [tool]...") ,
		span_notice("[user] начинает нагревать что-то в туловище [target] используя [tool]..."))

/datum/surgery_step/viral_bond/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(user, target, span_notice("Костный мозг [target] начинает медленно пульсировать. Вирусный симбиоз установлен.") ,
		span_notice("Костный мозг [target] начинает медленно пульсировать.") ,
		span_notice("[user] завершает операцию."))
	for(var/X in target.diseases)
		var/datum/disease/D = X
		D.carrier = TRUE
	return TRUE
