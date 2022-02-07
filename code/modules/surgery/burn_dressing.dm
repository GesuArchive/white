
/////BURN FIXING SURGERIES//////

///// Debride burnt flesh
/datum/surgery/debride
	name = "Травматология: Удаление Инфекции"
	steps = list(/datum/surgery_step/debride, /datum/surgery_step/dress)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_R_LEG,BODY_ZONE_L_LEG,BODY_ZONE_CHEST,BODY_ZONE_HEAD)
	requires_real_bodypart = TRUE
	targetable_wound = /datum/wound/burn

/datum/surgery/debride/can_start(mob/living/user, mob/living/carbon/target)
	if(!istype(target))
		return FALSE
	if(..())
		var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
		var/datum/wound/burn/burn_wound = targeted_bodypart.get_wound_type(targetable_wound)
		return(burn_wound && burn_wound.infestation > 0)

//SURGERY STEPS

///// Debride
/datum/surgery_step/debride
	name = "удалить инфекцию"
	implements = list(TOOL_HEMOSTAT = 100, TOOL_SCALPEL = 85, TOOL_SAW = 60, TOOL_WIRECUTTER = 40)
	time = 30
	repeatable = TRUE

/datum/surgery_step/debride/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		var/datum/wound/burn/burn_wound = surgery.operated_wound
		if(burn_wound.infestation <= 0)
			to_chat(user, span_notice(" На [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] нет инфицированной плоти, которую можно удалить!"))
			surgery.status++
			repeatable = FALSE
			return
		display_results(user, target, span_notice("Начинаю удалять инфицированную плоть с [ru_otkuda_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] ...") ,
			span_notice("[user] начинает удалять инфицированную плоть с [ru_otkuda_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
			span_notice("[user] начинает удалять инфицированную плоть с [ru_otkuda_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)].") ,
			playsound(get_turf(target), 'sound/surgery/scalpel1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "The infection in your [parse_zone(user.zone_selected)] stings like hell! It feels like you're being stabbed!")
	else
		user.visible_message(span_notice("[user] ищет [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Ищу [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)]..."))

/datum/surgery_step/debride/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/burn/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(user, target, span_notice("Успешно удалил некоторую инфицированную плоть с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] .") ,
			span_notice("[user] успешно удалил некоторую инфицированную плоть с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]!") ,
			span_notice("[user] успешно удалил некоторую инфицированную плоть с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
			playsound(get_turf(target), 'sound/surgery/retractor2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		log_combat(user, target, "excised infected flesh in", addition="INTENT: [uppertext(user.a_intent)]")
		surgery.operated_bodypart.receive_damage(brute=3, wound_bonus=CANT_WOUND)
		burn_wound.infestation -= 0.5
		burn_wound.sanitization += 0.5
		if(burn_wound.infestation <= 0)
			repeatable = FALSE
	else
		to_chat(user, span_warning("У [skloname(target.name, RODITELNI, target.gender)] тут нет инфицированной плоти!"))
	return ..()

/datum/surgery_step/debride/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	display_results(user, target, span_notice("Отрезал немного здоровой плоти с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] отрезал немного здоровой плоти с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]!") ,
		span_notice("[user] отрезал немного здоровой плоти с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
		playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
	surgery.operated_bodypart.receive_damage(brute=rand(4,8), sharpness=TRUE)

/datum/surgery_step/debride/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	var/datum/wound/burn/burn_wound = surgery.operated_wound
	while(burn_wound && burn_wound.infestation > 0.25)
		if(!..())
			break

///// Dressing burns
/datum/surgery_step/dress
	name = "bandage burns"
	implements = list(/obj/item/stack/medical/gauze = 100, /obj/item/stack/sticky_tape/surgical = 100)
	time = 40

/datum/surgery_step/dress/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/burn/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(user, target, span_notice("Начинаю перевязку ожогов на [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает перевязку ожогов на [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
			span_notice("[user] начинает перевязку ожогов на [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "The burns on your [parse_zone(user.zone_selected)] sting like hell!")
	else
		user.visible_message(span_notice("[user] ищет [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Ищу [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)]..."))

/datum/surgery_step/dress/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/burn/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(user, target, span_notice("Успешно обернул [ru_parse_zone(parse_zone(target_zone))] при помощи [tool].") ,
			span_notice("[user] успешно обернул [ru_parse_zone(parse_zone(target_zone))] при помощи [tool]!") ,
			span_notice("[user] спешно обернул [ru_parse_zone(parse_zone(target_zone))]!"))
		log_combat(user, target, "dressed burns in", addition="INTENT: [uppertext(user.a_intent)]")
		burn_wound.sanitization += 3
		burn_wound.flesh_healing += 5
		var/obj/item/bodypart/the_part = target.get_bodypart(target_zone)
		the_part.apply_gauze(tool)
	else
		to_chat(user, span_warning("У [skloname(target.name, RODITELNI, target.gender)] тут нет ожогов!"))
	return ..()

/datum/surgery_step/dress/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(istype(tool, /obj/item/stack))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)
