/datum/surgery/advanced/bioware/ligament_hook
	name = "Крючкообразное изменение связок"
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
	display_results(user, target, "<span class='notice'>Начинаю менять форму связок [target] на крючкообразную.</span>",
		"<span class='notice'>[user] начал менять форму связок[target] на крючкообразную.</span>",
		"<span class='notice'>[user] начал работать над связками [target].</span>")

/datum/surgery_step/reshape_ligaments/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>Изменил форму связок [target] на соединяющий крючок!</span>",
		"<span class='notice'>[user] сформировал из связок [target] соединяющий крючок!</span>",
		"<span class='notice'>[user] закончил работу над связками [target].</span>")
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
