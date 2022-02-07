/datum/surgery/dental_implant
	name = "Зубной имплант"
	steps = list(/datum/surgery_step/drill, /datum/surgery_step/insert_pill)
	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)

/datum/surgery_step/insert_pill
	name = "вставь пилюлю"
	implements = list(/obj/item/reagent_containers/pill = 100)
	time = 16

/datum/surgery_step/insert_pill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю вводить [tool] в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинет вводить [tool] в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинат вводить что-то в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)] ."))
	display_pain(target, "Something's being jammed into your [parse_zone(target_zone)]!")

/datum/surgery_step/insert_pill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/reagent_containers/pill/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(!istype(tool))
		return 0

	user.transferItemToLoc(tool, target, TRUE)

	var/datum/action/item_action/hands_free/activate_pill/P = new(tool)
	P.button.name = "Активировать [tool.name]"
	P.target = tool
	P.Grant(target)	//The pill never actually goes in an inventory slot, so the owner doesn't inherit actions from it

	display_results(user, target, span_notice("Ввёл [tool] в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)] .") ,
			span_notice("[user] ввёл [tool] в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] ввёл что-то в [parse_zone(target_zone)] [skloname(target.name, RODITELNI, target.gender)] !"))
	return ..()

/datum/action/item_action/hands_free/activate_pill
	name = "Активировать пилюлю"

/datum/action/item_action/hands_free/activate_pill/Trigger()
	if(!..())
		return FALSE
	to_chat(owner, span_notice("Сжимаю зубы и разжёвываю имплант [target.name]!"))
	log_combat(owner, null, "проглотил имплантированную пилюлю", target)
	if(target.reagents.total_volume)
		target.reagents.trans_to(owner, target.reagents.total_volume, transfered_by = owner, methods = INGEST)
	qdel(target)
	return TRUE
