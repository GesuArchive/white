/datum/surgery/prosthetic_replacement
	name = "Травматология: Замена конечностей"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/add_prosthetic)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD)
	requires_bodypart = FALSE //need a missing limb
	requires_bodypart_type = 0

/datum/surgery/prosthetic_replacement/can_start(mob/user, mob/living/carbon/target)
	if(!iscarbon(target))
		return FALSE
	var/mob/living/carbon/C = target
	if(!C.get_bodypart(user.zone_selected)) //can only start if limb is missing
		return TRUE
	return FALSE



/datum/surgery_step/add_prosthetic
	name = "Добавить конечность"
	implements = list(/obj/item/bodypart = 100, /obj/item/organ_storage = 100, /obj/item/chainsaw = 100, /obj/item/melee/synthetic_arm_blade = 100)
	time = 32
	var/organ_rejection_dam = 0

/datum/surgery_step/add_prosthetic/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/organ_storage))
		if(!tool.contents.len)
			to_chat(user, span_warning("[tool] пуст!"))
			return -1
		var/obj/item/I = tool.contents[1]
		if(!isbodypart(I))
			to_chat(user, span_warning("Невозможно присоединить [I]!"))
			return -1
		tool = I
	if(istype(tool, /obj/item/bodypart))
		var/obj/item/bodypart/BP = tool
		if(ismonkey(target))// monkey patient only accept organic monkey limbs
			if(BP.status == BODYPART_ROBOTIC || BP.animal_origin != MONKEY_BODYPART)
				to_chat(user, span_warning("[BP] относится к другому селекционному виду."))
				return -1
		if(BP.status != BODYPART_ROBOTIC)
			organ_rejection_dam = 10
			if(ishuman(target))
				if(BP.animal_origin)
					to_chat(user, span_warning("[BP] относится к другому селекционному виду."))
					return -1
				var/mob/living/carbon/human/H = target
				if(H.dna.species.id != BP.species_id)
					organ_rejection_dam = 30

		if(target_zone == BP.body_zone) //so we can't replace a leg with an arm, or a human arm with a monkey arm.
			display_results(user, target, span_notice("Начинаю заменять [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] на [tool]...") ,
				span_notice("[user] начинает заменять [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] на [tool].") ,
				span_notice("[user] начинает заменять [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]."))
		else
			to_chat(user, span_warning("[tool] не подходит к [ru_gde_zone(parse_zone(target_zone))]."))
			return -1
	else if(target_zone == BODY_ZONE_L_ARM || target_zone == BODY_ZONE_R_ARM)
		display_results(user, target, span_notice("Начинаю присоединять [tool] к телу [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает присоединять [tool] к телу [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает присоединять [tool] к телу [skloname(target.name, RODITELNI, target.gender)]."))
	else
		to_chat(user, span_warning("[tool] должно быть установлено в руку."))
		return -1

/datum/surgery_step/add_prosthetic/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(istype(tool, /obj/item/organ_storage))
		tool.icon_state = initial(tool.icon_state)
		tool.desc = initial(tool.desc)
		tool.cut_overlays()
		tool = tool.contents[1]
	if(istype(tool, /obj/item/bodypart) && user.temporarilyRemoveItemFromInventory(tool))
		var/obj/item/bodypart/L = tool
		if(!L.attach_limb(target))
			display_results(user, target, span_warning("Не удалось заменить [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]! Тело отвергает [L]!") ,
				span_warning("[user] не удалось заменить [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_warning("[user] не удалось заменить [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!"))
			return
		if(organ_rejection_dam)
			target.adjustToxLoss(organ_rejection_dam)
		display_results(user, target, span_notice("Успешно заменяю [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] на [tool].") ,
			span_notice("[user] успешно заменил [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] на [tool]!") ,
			span_notice("[user] успешно заменил [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!"))
		display_pain(target, "Вновь чувствую свою [parse_zone(target_zone)]! Болит...", TRUE)
		return
	else
		var/obj/item/bodypart/L = target.newBodyPart(target_zone, FALSE, FALSE)
		L.is_pseudopart = TRUE
		if(!L.attach_limb(target))
			display_results(user, target, span_warning("Мне не удалось присоединить [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]! Тело отвергает [L]!") ,
				span_warning("[user] не удалось присоединить [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!") ,
				span_warning("[user] не удалось присоединить [ru_parse_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!"))
			L.forceMove(target.loc)
			return
		user.visible_message(span_notice("[user] успешно присоединяет [tool]!") , span_notice("Присоединяю [tool]."))
		display_results(user, target, span_notice("Присоединяю [tool].") ,
			span_notice("[user] успешно присоединяет [tool]!") ,
			span_notice("[user] успешно присоединяет [tool]!"))
		display_pain(target, "С моей [ru_chem_zone(parse_zone(target_zone))] что-то не так...", TRUE)
		qdel(tool)
		if(istype(tool, /obj/item/chainsaw))
			var/obj/item/mounted_chainsaw/new_arm = new(target)
			target_zone == BODY_ZONE_R_ARM ? target.put_in_r_hand(new_arm) : target.put_in_l_hand(new_arm)
			return
		else if(istype(tool, /obj/item/melee/synthetic_arm_blade))
			var/obj/item/melee/arm_blade/new_arm = new(target,TRUE,TRUE)
			target_zone == BODY_ZONE_R_ARM ? target.put_in_r_hand(new_arm) : target.put_in_l_hand(new_arm)
			return
	return ..() //if for some reason we fail everything we'll print out some text okay?
