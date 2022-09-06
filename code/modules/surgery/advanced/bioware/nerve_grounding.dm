/datum/surgery/advanced/bioware/nerve_grounding
	name = "Модифицирование: Заземление Нервов"
	desc = "Хирургическая процедура, позволяющая нервам пациента выступать в качестве заземляющих стержней, защищая их от поражения электрическим током."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/ground_nerves,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	bioware_target = BIOWARE_NERVES

/datum/surgery_step/ground_nerves
	name = "заземление нервов"
	accept_hand = TRUE
	time = 155

/datum/surgery_step/ground_nerves/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю перенаправлять нервы [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал перенаправлять нервы [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начал работать с нервной системой [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/ground_nerves/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Успешно перенаправил нервную систему [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] успешно перенаправил нервную систему [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] закончил работать с нервной системой [skloname(target.name, RODITELNI, target.gender)]."))
	new /datum/bioware/grounded_nerves(target)
	return ..()

/datum/bioware/grounded_nerves
	name = "Заземленные Нервы"
	desc = "Нервы образуют безопасный путь для прохождения электричества, защищая тело от поражения электрическим током."
	mod_type = BIOWARE_NERVES

/datum/bioware/grounded_nerves/on_gain()
	..()
	ADD_TRAIT(owner, TRAIT_SHOCKIMMUNE, "grounded_nerves")

/datum/bioware/grounded_nerves/on_lose()
	..()
	REMOVE_TRAIT(owner, TRAIT_SHOCKIMMUNE, "grounded_nerves")
