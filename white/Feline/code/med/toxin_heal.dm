/datum/surgery/toxin_healing
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/toxin_heal,
		/datum/surgery_step/close
	)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = TRUE
	replaced_by = /datum/surgery
	ignore_clothes = TRUE
	var/toxin_healing_step_type

/datum/surgery/toxin_healing/can_start(mob/user, mob/living/carbon/target)
	if(HAS_TRAIT(target, TRAIT_HUSK)) //не работает на хасков
		return FALSE
	return ..()

/datum/surgery/toxin_healing/New(surgery_target, surgery_location, surgery_bodypart)
	..()
	if(toxin_healing_step_type)
		steps = list(/datum/surgery_step/incise/nobleed,
					/datum/surgery_step/retract_skin,
					/datum/surgery_step/incise,
					toxin_healing_step_type,
					/datum/surgery_step/close)

/datum/surgery_step/toxin_heal
	name = "Фильтрация лимфы"
	implements = list(TOOL_BLOODFILTER = 100)
	repeatable = TRUE
	time = 2.5 SECONDS
	var/toxinstat = 0
	var/toxincap = 0

/datum/surgery_step/toxin_heal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Произвожу фильтрацию лимфы у [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] производит фильтрацию лимфы у [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] производит фильтрацию лимфы у [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/toxin_heal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	target.adjustToxLoss(-1 * min(target.getToxLoss() * 0.5 + toxinstat, toxincap))
	display_results(user, target, span_notice("Закончив фильтрацию лимфы [skloname(target.name, RODITELNI, target.gender)], [tool] издает короткий звон.") ,
		span_notice("[tool] заканчивает работы и издает короткий звон.") ,
		"Закончив работу [tool] издает короткий звон.")
	return ..()

/datum/surgery_step/toxin_heal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("[gvorno(TRUE)], но [gvorno(TRUE)], но я делал что-то не так и оставил синяк на груди [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] ошибся, оставив синяк на груди [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_warning("[user] ошибся!"))
	target.adjustBruteLoss(5)

//Зацикленность фильтрации
/datum/surgery_step/toxin_heal/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	while(target.getToxLoss() > 0)
		if(!..())
			break

//Операция
/datum/surgery/toxin_healing/toxin
	name = "Фильтрация Лимфы (Токсины)"

/datum/surgery/toxin_healing/toxin/basic
	name = "Фильтрация Лимфы (Токсины, Базовое)"
	replaced_by = /datum/surgery/toxin_healing/toxin/upgraded
	toxin_healing_step_type = /datum/surgery_step/toxin_heal/toxin/basic
	desc = "Позволяет поверхностно промыть лимфатическую систему, что скажется на снижении уровня токсинов в организме. Эффект более заметен при высоких уровнях отравления."

/datum/surgery/toxin_healing/toxin/upgraded
	name = "Фильтрация Лимфы (Токсины, Продвинутое)"
	replaced_by = /datum/surgery/toxin_healing/toxin/upgraded/femto
	requires_tech = TRUE
	toxin_healing_step_type = /datum/surgery_step/toxin_heal/toxin/upgraded
	desc = "Позволяет хорошо промыть лимфатическую систему, что скажется на снижении уровня токсинов в организме. Эффект намного более заметен при высоких уровнях отравления."

/datum/surgery/toxin_healing/toxin/upgraded/femto
	name = "Фильтрация Лимфы (Токсины, Экспертное)"
//	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	replaced_by = null
	requires_tech = TRUE
	toxin_healing_step_type = /datum/surgery_step/toxin_heal/toxin/upgraded/femto
	desc = "Позволяет профессионально промыть лимфатическую систему, что скажется на снижении уровня токсинов в организме. Эффект максимально заметен при высоких уровнях отравления."

//Шаги
/datum/surgery_step/toxin_heal/toxin/basic
	name = "Фильтрация лимфы"
	toxinstat = 0.5
	toxincap = 3

/datum/surgery_step/toxin_heal/toxin/upgraded
	toxinstat = 1
	toxincap = 6

/datum/surgery_step/toxin_heal/toxin/upgraded/femto
	toxinstat = 2
	toxincap = 9
