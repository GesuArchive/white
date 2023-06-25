/datum/surgery/gastrectomy
	name = "Реконструкция: Гастрэктомия"
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_real_bodypart = TRUE
	steps = list(/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/gastrectomy,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/close
		)
/*
/datum/surgery/gastrectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/stomach/L = target.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(L?.damage > 50 && !(L.organ_flags & ORGAN_FAILING))
		return TRUE
*/

/datum/surgery/gastrectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/stomach/L = target.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(L)
		if(L.damage > 60 && !L.operated)
			return TRUE
	return FALSE

////Gastrectomy, because we truly needed a way to repair stomachs.
//95% chance of success to be consistent with most organ-repairing surgeries.
/datum/surgery_step/gastrectomy
	name = "удалить нижнюю часть двенадцатиперстной кишки"
	implements = list(TOOL_SCALPEL = 95, /obj/item/melee/energy/sword = 65, /obj/item/kitchen/knife = 45,
		/obj/item/shard = 35)
	time = 52

/datum/surgery_step/gastrectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю вырезать часть поврежденного желудка [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] делает надрез желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] делает надрез желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		playsound(get_turf(target), 'sound/surgery/scalpel1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Чувствую резкую боль в животе!")

/datum/surgery_step/gastrectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/H = target
	var/obj/item/organ/stomach/L = H.get_organ_slot(ORGAN_SLOT_STOMACH)
	L.operated = TRUE
	H.setOrganLoss(ORGAN_SLOT_STOMACH, 60) // Stomachs have a threshold for being able to even digest food, so I might tweak this number
	display_results(user, target, span_notice("Успешно извлек поврежденную часть желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно извлек поврежденную часть желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно извлек поврежденную часть желудка [skloname(target.name, RODITELNI, target.gender)].") ,
		playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Боль в животе ослабевает и немного утихает.")
	return ..()

/datum/surgery_step/hepatectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery)
	var/mob/living/carbon/human/H = target
	H.adjustOrganLoss(ORGAN_SLOT_STOMACH, 15)
	display_results(user, target, span_warning("Вырезал неверную часть желудка [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] вырезал неверную часть желудка [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] вырезал неверную часть желудка [skloname(target.name, RODITELNI, target.gender)]!") ,
		playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Больно! Дьявол, это очень больно!")
