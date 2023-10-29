/datum/surgery/coronary_bypass
	name = "Реконструкция: Коронарное Шунтирование"
	steps = list(
		/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise_heart, /datum/surgery_step/coronary_bypass, /datum/surgery_step/close,
	)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery/coronary_bypass/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/heart/H = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(H)
		if(H.damage > 60 && !H.operated)
			return TRUE
	return FALSE


//an incision but with greater bleed, and a 90% base success chance
/datum/surgery_step/incise_heart
	name = "надрезать сердце"
	implements = list(TOOL_SCALPEL = 90, /obj/item/melee/energy/sword = 45, /obj/item/kitchen/knife = 45,
		/obj/item/shard = 25)
	time = 16

/datum/surgery_step/incise_heart/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю делать надрез в сердце [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает делать надрез в [target.ru_who()] сердце.") ,
		span_notice("[user] начинает делать надрез в [target.ru_who()] сердце.") ,
		playsound(get_turf(target), 'sound/surgery/scalpel1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Мое сердце! Почему так больно? Эй! А можно наркоз?!")

/datum/surgery_step/incise_heart/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if (!(NOBLOOD in H.dna.species.species_traits))
			display_results(user, target, span_notice("Кровь брызгает вокруг надреза в сердце [H].") ,
				span_notice("Кровь брызгает вокруг надреза в сердце [H]") ,
				playsound(get_turf(target), 'sound/surgery/scalpel2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1),
				"")
			var/obj/item/bodypart/BP = H.get_bodypart(target_zone)
			BP.generic_bleedstacks += 10
			H.adjustBruteLoss(10)
	return ..()

/datum/surgery_step/incise_heart/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался, сделав слишком глубокий надрез в сердце!") ,
			span_warning("[user] облажался, из-за чего из груди [H] брызгает кровь!") ,
			span_warning("[user] облажался, из-за чего из груди [H] брызгает кровь!") ,
			playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		var/obj/item/bodypart/BP = H.get_bodypart(target_zone)
		BP.generic_bleedstacks += 10
		H.adjustOrganLoss(ORGAN_SLOT_HEART, 10)
		H.adjustBruteLoss(10)

//grafts a coronary bypass onto the individual's heart, success chance is 90% base again
/datum/surgery_step/coronary_bypass
	name = "выполнить аортокоронарное штунирование"
	implements = list(TOOL_HEMOSTAT = 90, TOOL_WIRECUTTER = 35, /obj/item/stack/package_wrap = 15, /obj/item/stack/cable_coil = 5)
	time = 90

/datum/surgery_step/coronary_bypass/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю делать обходное штунирование сердца [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает делать обходное штунирование [target.ru_who()] сердца!") ,
		span_notice("[user] начинает делать обходное штунирование [target.ru_who()] сердца!") ,
		playsound(get_turf(target), 'sound/surgery/hemostat1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	display_pain(target, "Дьявол! Боль в груди невыносима! Я едва могу терпеть её!")

/datum/surgery_step/coronary_bypass/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	target.setOrganLoss(ORGAN_SLOT_HEART, 60)
	var/obj/item/organ/heart/heart = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(heart)	//slightly worrying if we lost our heart mid-operation, but that's life
		heart.operated = TRUE
		display_results(user, target, span_notice("Успешно выполняю обходное штунирование на сердце [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно выполняет обходное штунирование на [target.ru_who()] сердце.") ,
			span_notice("[user] успешно выполняет обходное штунирование на [target.ru_who()] сердце.") ,
			playsound(get_turf(target), 'sound/surgery/hemostat1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "Господи! Наконец то это закончилось...")
	return ..()

/datum/surgery_step/coronary_bypass/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался, выполняя штунирование, разорвав часть сердца!") ,
			span_warning("[user] облажался, из-за чего из груди [H] обильно льётся кровь!") ,
			span_warning("[user] облажался, из-за чего из груди [H] обильно льётся кровь!") ,
			playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "Грудь буквально горит болью! Кажется, будто я схожу с ума!")
		H.adjustOrganLoss(ORGAN_SLOT_HEART, 20)
		var/obj/item/bodypart/BP = H.get_bodypart(target_zone)
		BP.generic_bleedstacks += 30
	return FALSE
