
/////BURN FIXING SURGERIES//////

///// Debride burnt flesh
/datum/surgery/debride
	name = "Очистка инфицированной плоти"
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
			to_chat(user, "<span class='notice'> На [parse_zone(user.zone_selected)] [target] нет инфицированной плоти, которую можно удалить!</span>")
			surgery.status++
			repeatable = FALSE
			return
		display_results(user, target, "<span class='notice'>Начинаю удалять инфицированную плоть с [parse_zone(user.zone_selected)] [target] ...</span>",
			"<span class='notice'>[user] начинает удалять инфицированную плоть с [parse_zone(user.zone_selected)] [target] при помощи [tool].</span>",
			"<span class='notice'>[user] начинает удалять инфицированную плоть с [parse_zone(user.zone_selected)] [target].</span>")
	else
		user.visible_message("<span class='notice'>[user] ищет [parse_zone(user.zone_selected)] [target].</span>", "<span class='notice'>Ищу [parse_zone(user.zone_selected)] [target]...</span>")

/datum/surgery_step/debride/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/burn/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(user, target, "<span class='notice'>Успешно удалил некоторую инфицированную плоть с [parse_zone(target_zone)] [target] .</span>",
			"<span class='notice'>[user] успешно удалил некоторую инфицированную плоть с [parse_zone(target_zone)] [target] при помощи [tool]!</span>",
			"<span class='notice'>[user] успешно удалил некоторую инфицированную плоть с [parse_zone(target_zone)] [target]!</span>")
		log_combat(user, target, "excised infected flesh in", addition="INTENT: [uppertext(user.a_intent)]")
		surgery.operated_bodypart.receive_damage(brute=3, wound_bonus=CANT_WOUND)
		burn_wound.infestation -= 0.5
		burn_wound.sanitization += 0.5
		if(burn_wound.infestation <= 0)
			repeatable = FALSE
	else
		to_chat(user, "<span class='warning'>У [target] тут нет инфицированной плоти!</span>")
	return ..()

/datum/surgery_step/debride/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	display_results(user, target, "<span class='notice'>Я отрезал немного здоровой плоти с [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] отрезал немного здоровой плоти с [parse_zone(target_zone)] [target] при помощи [tool]!</span>",
		"<span class='notice'>[user] отрезал немного здоровой плоти с [parse_zone(target_zone)] [target]!</span>")
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
		display_results(user, target, "<span class='notice'>Начинаю перевязку ожогов на [parse_zone(user.zone_selected)] [target]...</span>",
			"<span class='notice'>[user] начинает перевязку ожогов на [parse_zone(user.zone_selected)] [target] при помощи [tool].</span>",
			"<span class='notice'>[user] начинает перевязку ожогов на [parse_zone(user.zone_selected)] [target].</span>")
	else
		user.visible_message("<span class='notice'>[user] ищет [parse_zone(user.zone_selected)] [target].</span>", "<span class='notice'>Ищу [parse_zone(user.zone_selected)] [target]...</span>")

/datum/surgery_step/dress/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/burn/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(user, target, "<span class='notice'>Успешно обернул [parse_zone(target_zone)] при помощи [tool].</span>",
			"<span class='notice'>[user] успешно обернул [parse_zone(target_zone)] при помощи [tool]!</span>",
			"<span class='notice'>[user] спешно обернул [parse_zone(target_zone)]!</span>")
		log_combat(user, target, "dressed burns in", addition="INTENT: [uppertext(user.a_intent)]")
		burn_wound.sanitization += 3
		burn_wound.flesh_healing += 5
		var/obj/item/bodypart/the_part = target.get_bodypart(target_zone)
		the_part.apply_gauze(tool)
	else
		to_chat(user, "<span class='warning'>У [target] тут нет ожогов!</span>")
	return ..()

/datum/surgery_step/dress/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(istype(tool, /obj/item/stack))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)
