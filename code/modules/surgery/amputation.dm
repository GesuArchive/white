
/datum/surgery/amputation
	name = "Ампутация"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/sever_limb)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD)
	requires_bodypart_type = 0


/datum/surgery_step/sever_limb
	name = "отрезать конечность"
	implements = list(/obj/item/shears = 300, TOOL_SCALPEL = 100, TOOL_SAW = 100, /obj/item/melee/arm_blade = 80, /obj/item/fireaxe = 50, /obj/item/hatchet = 40, /obj/item/kitchen/knife/butcher = 25)
	time = 64

/datum/surgery_step/sever_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю отрезать [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает отрезать [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] начинает отрезать [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
		playsound(get_turf(target), 'sound/surgery/scalpel1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Чувствую ужасную боль в [ru_gde_zone(parse_zone(target_zone))]!")


/datum/surgery_step/sever_limb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
//	var/mob/living/carbon/human/L = target
	display_results(user, target, span_notice("Отрезал [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] отрезал [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] отрезал [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
		playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Я больше не чувствую свою [ru_parse_zone(parse_zone(target_zone))]!")
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
	return ..()
