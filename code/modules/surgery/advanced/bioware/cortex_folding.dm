/datum/surgery/advanced/bioware/cortex_folding
	name = "Модифицирование: Сгибание Коры"
	desc = "Хирургическая процедура, при которой кора сгибается в сложную извилину, что открывает возможность образования нестандартных нейронных паттернов."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/fold_cortex,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	bioware_target = BIOWARE_CORTEX

/datum/surgery/advanced/bioware/cortex_folding/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return ..()

/datum/surgery_step/fold_cortex
	name = "сгибание коры"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/fold_cortex/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начал сгибать внешнюю кору большого мозга [skloname(target.name, RODITELNI, target.gender)] в фрактальный паттерн.") ,
		span_notice("[user] начал сгибать внешнюю кору большого мозга [skloname(target.name, RODITELNI, target.gender)] в фрактальный паттерн.") ,
		span_notice("[user] начинает операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/fold_cortex/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Согнул внешнюю кору большого мозга [skloname(target.name, RODITELNI, target.gender)] в фрактальный паттерн!") ,
		span_notice("[user] согнул внешнюю кору большого мозга [skloname(target.name, RODITELNI, target.gender)] в фрактальный паттерн!") ,
		span_notice("[user] завершил операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
	new /datum/bioware/cortex_fold(target)
	return ..()

/datum/surgery_step/fold_cortex/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался, повредив мозг!") ,
			span_warning("[user] облажался, повредив мозг!") ,
			span_notice("[user] завершил операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user] внезапно замечает что мозг [user.ru_who()] над которым работал [user.p_were()] исчез.") , span_warning("Внезапно обнаруживаю что мозг, над которым я работал, исчез."))
	return FALSE

/datum/bioware/cortex_fold
	name = "Согнутая кора"
	desc = "Кора большого мозга была согнута в сложный фрактальный паттерн и может поддерживать нестандарнтные нейронные паттерны."
	mod_type = BIOWARE_CORTEX

/datum/bioware/cortex_fold/on_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SPECIAL_TRAUMA_BOOST, "cortex_fold")

/datum/bioware/cortex_fold/on_lose()
	REMOVE_TRAIT(owner, TRAIT_SPECIAL_TRAUMA_BOOST, "cortex_fold")
	return ..()
