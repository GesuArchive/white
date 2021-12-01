/datum/surgery/advanced/bioware/ligament_hook
	name = "Модифицирование: Крючкообразные Связки"
	desc = "Хирургическая процедура, которая изменяет форму соединения между конечностями и туловищем, благодаря чему конечности можно будет прикрепить вручную, если они оторвутся. \
	Однако, это ослабляет соединение, в результате чего конечности легче отрываются."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/reshape_ligaments,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	bioware_target = BIOWARE_LIGAMENTS

/datum/surgery_step/reshape_ligaments
	name = "изменение связок"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/reshape_ligaments/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю менять форму связок [skloname(target.name, RODITELNI, target.gender)] на крючкообразную.") ,
		span_notice("[user] начал менять форму связок [skloname(target.name, RODITELNI, target.gender)] на крючкообразную.") ,
		span_notice("[user] начал работать над связками [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/reshape_ligaments/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Изменил форму связок [skloname(target.name, RODITELNI, target.gender)] на соединяющий крючок!") ,
		span_notice("[user] сформировал из связок [skloname(target.name, RODITELNI, target.gender)] соединяющий крючок!") ,
		span_notice("[user] закончил работу над связками [skloname(target.name, RODITELNI, target.gender)]."))
	new /datum/bioware/hooked_ligaments(target)
	return ..()

/datum/bioware/hooked_ligaments
	name = "Крючкообразные связки"
	desc = "Связки и нервные окончания, соединяющие туловище с конечностями, переделаны в крючкообразную форму, что позволяет прикреплять конечности без операции, однако, повышает вероятность их отсоединения."
	mod_type = BIOWARE_LIGAMENTS

/datum/bioware/hooked_ligaments/on_gain()
	..()
	ADD_TRAIT(owner, TRAIT_LIMBATTACHMENT, "ligament_hook")
	ADD_TRAIT(owner, TRAIT_EASYDISMEMBER, "ligament_hook")

/datum/bioware/hooked_ligaments/on_lose()
	..()
	REMOVE_TRAIT(owner, TRAIT_LIMBATTACHMENT, "ligament_hook")
	REMOVE_TRAIT(owner, TRAIT_EASYDISMEMBER, "ligament_hook")
