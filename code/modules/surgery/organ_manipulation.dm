/datum/surgery/organ_manipulation
	name = "Манипуляции с органами"
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	requires_real_bodypart = 1
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs,
		//there should be bone fixing
		/datum/surgery_step/close
		)

/datum/surgery/organ_manipulation/soft
	possible_locs = list(BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs,
		/datum/surgery_step/close
		)

/datum/surgery/organ_manipulation/alien
	name = "Манипуляции с органами пришельцев"
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	target_mobtypes = list(/mob/living/carbon/alien/humanoid)
	steps = list(
		/datum/surgery_step/saw,
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/manipulate_organs,
		/datum/surgery_step/close
		)

/datum/surgery/organ_manipulation/mechanic
	name = "Манипуляции по протезированию органов"
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	requires_bodypart_type = BODYPART_ROBOTIC
	lying_required = FALSE
	self_operable = TRUE
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/manipulate_organs,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close
		)

/datum/surgery/organ_manipulation/mechanic/soft
	possible_locs = list(BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/manipulate_organs,
		/datum/surgery_step/mechanic_close
		)

/datum/surgery_step/manipulate_organs
	time = 64
	name = "манипуляции с органами"
	repeatable = TRUE
	implements = list(/obj/item/organ = 100, /obj/item/organ_storage = 100)
	var/implements_extract = list(TOOL_HEMOSTAT = 100, TOOL_CROWBAR = 55, /obj/item/kitchen/fork = 35)
	var/current_type
	var/obj/item/organ/I = null

/datum/surgery_step/manipulate_organs/New()
	..()
	implements = implements + implements_extract

/datum/surgery_step/manipulate_organs/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	I = null
	if(istype(tool, /obj/item/organ_storage))
		if(!tool.contents.len)
			to_chat(user, span_warning("[tool] пуст!"))
			return -1
		I = tool.contents[1]
		if(!isorgan(I))
			to_chat(user, span_warning("Не могу поместить [I] в [parse_zone(target_zone)] [target]!"))
			return -1
		tool = I
	if(isorgan(tool))
		current_type = "insert"
		I = tool
		if(target_zone != I.zone || target.get_organ_slot(I.slot))
			to_chat(user, span_warning("В [parse_zone(target_zone)] [target] нет места под [I]!"))
			return -1
		var/obj/item/organ/meatslab = tool
		if(!meatslab.useable)
			to_chat(user, span_warning("Судя по всему [I] пожеван, так что я не могу его использовать!"))
			return -1
		display_results(user, target, span_notice("Начинаю помещать [tool] в [parse_zone(target_zone)] [target]...") ,
			span_notice("[user] начинает помещать [tool] в [parse_zone(target_zone)] [target].") ,
			span_notice("[user] начинает засовывать что-то в [parse_zone(target_zone)] [target].") ,
			playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))

	else if(implement_type in implements_extract)
		current_type = "extract"
		var/list/organs = target.getorganszone(target_zone)
		if(!organs.len)
			to_chat(user, span_warning("Внутри [parse_zone(target_zone)] [target] нет извлекаемых органов!"))
			return -1
		else
			for(var/obj/item/organ/O in organs)
				O.on_find(user)
				organs -= O
				organs[O.name] = O

			I = tgui_input_list(user, "Remove which organ?", "Surgery", sort_list(organs))
			if(I && user && target && user.Adjacent(target) && user.get_active_held_item() == tool)
				I = organs[I]
				if(!I)
					return -1
				if(I.organ_flags & ORGAN_UNREMOVABLE)
					to_chat(user, span_warning("[I] is too well connected to take out!"))
					return -1
				display_results(user, target, span_notice("Начинаю извлекать [I] из [parse_zone(target_zone)] [target]...") ,
					span_notice("[user] начинает извлекать [I] из [parse_zone(target_zone)] [target].") ,
					span_notice("[user] начинает что-то извлекать из [parse_zone(target_zone)] [target].") ,
					playsound(get_turf(target), 'sound/surgery/hemostat1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
				display_pain(target, "Я чувствую боль в [ru_gde_zone(parse_zone(target_zone))]!")
			else
				return -1


/datum/surgery_step/manipulate_organs/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(current_type == "insert")
		if(istype(tool, /obj/item/organ_storage))
			I = tool.contents[1]
			tool.icon_state = initial(tool.icon_state)
			tool.desc = initial(tool.desc)
			tool.cut_overlays()
			tool = I
		else
			I = tool
		user.temporarilyRemoveItemFromInventory(I, TRUE)
		I.Insert(target)
		display_results(user, target, span_notice("Поместил [tool] в [parse_zone(target_zone)] [target].") ,
			span_notice("[user] поместил [tool] в [parse_zone(target_zone)] [target]!") ,
			span_notice("[user] поместил что-то в [parse_zone(target_zone)] [target]!") ,
			playsound(get_turf(target), 'sound/surgery/organ1.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
		display_pain(target, "Моя [parse_zone(target_zone)] болезненно пульсирует! Кажется в меня что-то запихали!")

	else if(current_type == "extract")
		if(I && I.owner == target)
			display_results(user, target, span_notice("Успешно извлек [I] из [parse_zone(target_zone)] [target].") ,
				span_notice("[user] успешно извлек [I] из [parse_zone(target_zone)] [target]!") ,
				span_notice("[user] успешно что-то извлек из [parse_zone(target_zone)] [target]!") ,
				playsound(get_turf(target), 'sound/surgery/organ2.ogg', 75, TRUE, falloff_exponent = 12, falloff_distance = 1))
			display_pain(target, "Моя [parse_zone(target_zone)] болит! Кажется из меня что-то извлекли!")
			log_combat(user, target, "хирургически извлек [I.name] из", addition="INTENT: [uppertext(user.a_intent)]")
			I.Remove(target)
			I.forceMove(get_turf(target))
		else
			display_results(user, target, span_warning("Не могу ничего извлечь из [parse_zone(target_zone)] [target]!") ,
				span_notice("[user] не может ничего извлечь из [parse_zone(target_zone)] [target]!") ,
				span_notice("[user] не может ничего извлечь из [parse_zone(target_zone)] [target]!"))
	return FALSE
