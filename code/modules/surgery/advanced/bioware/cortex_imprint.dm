/datum/surgery/advanced/bioware/cortex_imprint
	name = "Модифицирование: Импринтинг Мозга"
	desc = "Хирургическая процедура, которая модифицирует кору большого мозга в повторяющийся нейронный паттерн, позволяющая могзу справляться с трудностями, вызванными небольшими повреждениями мозга."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/imprint_cortex,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	bioware_target = BIOWARE_CORTEX

/datum/surgery/advanced/bioware/cortex_imprint/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/brain/B = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return ..()

/datum/surgery_step/imprint_cortex
	name = "распрямление коры"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/imprint_cortex/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю вырезать на коре большого мозга [skloname(target.name, RODITELNI, target.gender)] само-импринтирующий паттерн.") ,
		span_notice("[user] начинает вырезать на коре большого мозга [skloname(target.name, RODITELNI, target.gender)] само-импринтирующий паттерн.") ,
		span_notice("[user] начинает проводить операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/imprint_cortex/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Изменил форму коры большого мозга [skloname(target.name, RODITELNI, target.gender)] на само-импринтирующий паттерн!") ,
		span_notice("[user] изменил форму коры большого мозга [skloname(target.name, RODITELNI, target.gender)] на само-импринтирующий паттерн!") ,
		span_notice("[user] завершил операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
	new /datum/bioware/cortex_imprint(target)
	return ..()

/datum/surgery_step/imprint_cortex/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался, повредив мозг!") ,
			span_warning("[user] облажался, повредив мозг!") ,
			span_notice("[user] завершил операцию на мозге [skloname(target.name, RODITELNI, target.gender)]"))
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user] внезапно замечает что мозг [user.ru_who()] над которым работал [user.p_were()] исчез.") , span_warning("Внезапно обнаруживаю что мозг, над которым работал, исчез."))
	return FALSE

/datum/bioware/cortex_imprint
	name = "Распрямленная кора"
	desc = "Кора большого мозга была переделана в повторяющийся нейронный паттерн, позволяющая могзу справляться с трудностями, вызванными небольшими повреждениями мозга.."
	mod_type = BIOWARE_CORTEX
	can_process = TRUE

/datum/bioware/cortex_imprint/process()
	owner.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)
