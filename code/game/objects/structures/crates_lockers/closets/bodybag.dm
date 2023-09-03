
/obj/structure/closet/body_bag
	name = "мешок для трупов"
	desc = "Полиэтиленовый пакет, предназначенный для хранения и транспортировки трупов."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag"
	density = FALSE
	mob_storage_capacity = 2
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	open_sound_volume = 15
	close_sound_volume = 15
	integrity_failure = 0
	material_drop = /obj/item/stack/sheet/cloth
	delivery_icon = null //unwrappable
	anchorable = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	drag_slowdown = 0
	has_closed_overlay = FALSE
	door_anim_time = 0 // no animation
	var/foldedbag_path = /obj/item/bodybag
	var/obj/item/bodybag/foldedbag_instance = null
	var/tagged = FALSE // so closet code knows to put the tag overlay back

/obj/structure/closet/body_bag/Initialize(mapload)
	. = ..()
	var/static/list/tool_behaviors = list(
		TOOL_WIRECUTTER = list(
			SCREENTIP_CONTEXT_RMB = "Убрать бирку",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)
	AddElement( \
		/datum/element/contextual_screentip_bare_hands, \
		rmb_text = "сложить", \
	)
	AddElement(/datum/element/contextual_screentip_sharpness, lmb_text = "Убрать бирку")

/obj/structure/closet/body_bag/Destroy()
	// If we have a stored bag, and it's in nullspace (not in someone's hand), delete it.
	if (foldedbag_instance && !foldedbag_instance.loc)
		QDEL_NULL(foldedbag_instance)
	return ..()

/obj/structure/closet/body_bag/attackby(obj/item/interact_tool, mob/user, params)
	if (istype(interact_tool, /obj/item/pen) || istype(interact_tool, /obj/item/toy/crayon))
		if(!user.is_literate())
			to_chat(user, span_notice("Неразборчиво черкаю на [src]!"))
			return
		var/t = stripped_input(user, "What would you like the label to be?", name, null, 53)
		if(user.get_active_held_item() != interact_tool)
			return
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(t)
			name = "[initial(name)] - [t]"
			tagged = TRUE
			update_icon()
		else
			name = initial(name)
		return
	else if((interact_tool.tool_behaviour == TOOL_WIRECUTTER) && tagged)
		to_chat(user, span_notice("Отрезаю бирку [src]."))
		name = "мешок для трупов"
		tagged = FALSE
		update_icon()

/obj/structure/closet/body_bag/update_overlays()
	. = ..()
	if(tagged)
		. += "bodybag_label"

/obj/structure/closet/body_bag/open(mob/living/user, force = FALSE)
	. = ..()
	if(.)
		mouse_drag_pointer = MOUSE_INACTIVE_POINTER

/obj/structure/closet/body_bag/close()
	. = ..()
	if(.)
		set_density(FALSE)
		mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/structure/closet/body_bag/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!attempt_fold(user))
		return SECONDARY_ATTACK_CONTINUE_CHAIN
	perform_fold(user)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!attempt_fold(usr))
			return
		perform_fold(usr)
		qdel(src)

		/**
		  * Checks to see if we can fold. Return TRUE to actually perform the fold and delete.
			*
		  * Arguments:
		  * * the_folder - over_object of MouseDrop aka usr
		  */
/obj/structure/closet/body_bag/proc/attempt_fold(mob/living/carbon/human/the_folder)
	. = FALSE
	if(!istype(the_folder))
		return
	if(opened)
		to_chat(the_folder, span_warning("Вы боретесь с [src], но он не хочет складываться пока открыт."))
		return
	for(var/content_thing in contents)
		if(istype(content_thing, /mob) || istype(content_thing, /obj))
			to_chat(the_folder, span_warning("Внутри [src] слишком много вещей, чтобы сложить его!"))
			return
	// toto we made it!
	return TRUE

	/**
		* Performs the actual folding. Deleting is automatic, please do not include.
		*
		* Arguments:
		* * the_folder - over_object of MouseDrop aka usr
		*/
/obj/structure/closet/body_bag/proc/perform_fold(mob/living/carbon/human/the_folder)
	visible_message(span_notice("[usr] складывает [src]."))
	var/obj/item/bodybag/B = foldedbag_instance || new foldedbag_path
	the_folder.put_in_hands(B)

/obj/structure/closet/body_bag/bluespace
	name = "блюспейс мешок для трупов"
	desc = "Блюспейс мешок для трупов, предназначенный для хранения и транспортировки трупов. Поразительно."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bluebodybag"
	foldedbag_path = /obj/item/bodybag/bluespace
	mob_storage_capacity = 15
	max_mob_size = MOB_SIZE_LARGE

/obj/structure/closet/body_bag/bluespace/attempt_fold(mob/living/carbon/human/the_folder)
	. = FALSE
	//copypaste zone, we do not want the content check so we don't want inheritance
	if(!istype(the_folder))
		return
	if(opened)
		to_chat(the_folder, span_warning("Вы боретесь с [src], но он не хочет складываться пока открыт."))
		return
	//end copypaste zone
	if(contents.len >= mob_storage_capacity / 2)
		to_chat(usr, span_warning("Внутри [src] слишком много вещей, чтобы сложить его!"))
		return
	if(the_folder in src)
		to_chat(usr, span_warning("А как?")  )
		return
	for(var/obj/item/bodybag/bluespace/B in src)
		to_chat(usr, span_warning("Вы не можете складывать блюспейс мешки для трупов друг в друга")  )
		return
	return TRUE

/obj/structure/closet/body_bag/bluespace/perform_fold(mob/living/carbon/human/the_folder)
	visible_message(span_notice("[usr] складывает [src]."))
	var/obj/item/bodybag/folding_bodybag = foldedbag_instance || new foldedbag_path
	var/max_weight_of_contents = initial(folding_bodybag.w_class)
	for(var/am in contents)
		var/atom/movable/content = am
		content.forceMove(folding_bodybag)
		if(isliving(content))
			to_chat(content, span_userdanger("Внезапно оказались в крошечном, сжатом пространстве!"))
		if(iscarbon(content))
			var/mob/living/carbon/mob = content
			if (mob.dna.get_mutation(/datum/mutation/human/dwarfism))
				max_weight_of_contents = max(WEIGHT_CLASS_NORMAL, max_weight_of_contents)
				continue
		if(!isitem(content))
			max_weight_of_contents = max(WEIGHT_CLASS_BULKY, max_weight_of_contents)
			continue
		var/obj/item/A_is_item = content
		if(A_is_item.w_class < max_weight_of_contents)
			continue
		max_weight_of_contents = A_is_item.w_class
	folding_bodybag.w_class = max_weight_of_contents
	the_folder.put_in_hands(folding_bodybag)

/// Environmental bags

/obj/structure/closet/body_bag/environmental
	name = "environmental protection bag"
	desc = "An insulated, reinforced bag designed to protect against exoplanetary storms and other environmental factors."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "envirobag"
	mob_storage_capacity = 1
	contents_pressure_protection = 0.8
	contents_thermal_insulation = 0.5
	foldedbag_path = /obj/item/bodybag/environmental/
	weather_protection = list(WEATHER_ACID, WEATHER_ASH, WEATHER_RAD, WEATHER_SNOW, WEATHER_VOID) // Does not protect against lava or the The Floor Is Lava spell.

/obj/structure/closet/body_bag/environmental/nanotrasen
	name = "elite environmental protection bag"
	desc = "A heavily reinforced and insulated bag, capable of fully isolating its contents from external factors."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "ntenvirobag"
	contents_pressure_protection = 1
	contents_thermal_insulation = 1
	foldedbag_path = /obj/item/bodybag/environmental/nanotrasen/
	weather_protection = list(WEATHER_ALL)

/// Securable enviro. bags

/obj/structure/closet/body_bag/environmental/prisoner
	name = "prisoner transport bag"
	desc = "Intended for transport of prisoners through hazardous environments, this environmental protection bag comes with straps to keep an occupant secure."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "prisonerenvirobag"
	foldedbag_path = /obj/item/bodybag/environmental/prisoner/
	breakout_time = 4 MINUTES // because it's probably about as hard to get out of this as it is to get out of a straightjacket.
	/// How long it takes to sinch the bag.
	var/sinch_time = 10 SECONDS
	/// Whether or not the bag is sinched. Starts unsinched.
	var/sinched = FALSE
	/// The sound that plays when the bag is done sinching.
	var/sinch_sound = 'sound/items/equip/toolbelt_equip.ogg'

/obj/structure/closet/body_bag/environmental/prisoner/attempt_fold(mob/living/carbon/human/the_folder)
	if(sinched)
		to_chat(the_folder, span_warning("You wrestle with [src], but it won't fold while its straps are fastened."))
	return ..()

/obj/structure/closet/body_bag/environmental/prisoner/update_icon()
	. = ..()
	if(sinched)
		icon_state = initial(icon_state) + "_sinched"
	else
		icon_state = initial(icon_state)

/obj/structure/closet/body_bag/environmental/prisoner/can_open(mob/living/user, force = FALSE)
	if(force)
		return TRUE
	if(sinched)
		to_chat(user, span_danger("The buckles on [src] are sinched down, preventing it from opening."))
		return FALSE
	. = ..()

/obj/structure/closet/body_bag/environmental/prisoner/open(mob/living/user, force = FALSE)
	if(!can_open(user, force))
		return
	if(opened)
		return
	sinched = FALSE
	playsound(loc, open_sound, open_sound_volume, TRUE, -3)
	opened = TRUE
	if(!dense_when_open)
		density = FALSE
	dump_contents()
	update_icon()
	after_open(user, force)
	return TRUE

/obj/structure/closet/body_bag/environmental/prisoner/container_resist_act(mob/living/user)
	/// copy-pasted with changes because flavor text as well as some other misc stuff
	if(opened)
		return
	if(ismovable(loc))
		user.changeNext_move(CLICK_CD_BREAKOUT)
		user.last_special = world.time + CLICK_CD_BREAKOUT
		var/atom/movable/location = loc
		location.relay_container_resist_act(user, src)
		return
	if(!sinched)
		open()
		return

	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_warning("Someone in [src] begins to wriggle!") , \
		span_notice("You start wriggling, attempting to loosen [src]'s buckles... (this will take about [DisplayTimeText(breakout_time)].)") , \
		span_hear("You hear straining cloth from [src]."))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || opened || !sinched )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting
		user.visible_message(span_danger("[user] successfully broke out of [src]!") ,
							span_notice("You successfully break out of [src]!"))
		bust_open()
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, span_warning("You fail to break out of [src]!"))


/obj/structure/closet/body_bag/environmental/prisoner/bust_open()
	sinched = FALSE
	// We don't break the bag, because the buckles were backed out as opposed to fully broken.
	open()

/obj/structure/closet/body_bag/environmental/prisoner/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return
	if(!opened)
		togglelock(user)
	return TRUE

/obj/structure/closet/body_bag/environmental/prisoner/togglelock(mob/living/user, silent)
	if(user in contents)
		to_chat(user, span_warning("You can't reach the buckles from here!"))
		return
	if(iscarbon(user))
		add_fingerprint(user)
	if(!sinched)
		for(var/mob/living/target in contents)
			to_chat(target, span_userdanger("You feel the lining of [src] tighten around you! Soon, you won't be able to escape!"))
		user.visible_message(span_notice("You begin sinching down the buckles on [src]."))
		if(!(do_after(user,(sinch_time),target = src)))
			return
	sinched = !sinched
	if(sinched)
		playsound(loc, sinch_sound, 15, TRUE, -2)
	user.visible_message(span_notice("[user] [sinched ? null : "un"]sinches [src].") ,
							span_notice("You [sinched ? null : "un"]sinch [src].") ,
							span_hear("You hear stretching followed by metal clicking from [src]."))
	log_game("[key_name(user)] [sinched ? "sinched":"unsinched"] secure environmental bag [src] at [AREACOORD(src)]")
	update_icon()

/obj/structure/closet/body_bag/environmental/prisoner/pressurized
	name = "pressurized prisoner transport bag"
	foldedbag_path = /obj/item/bodybag/environmental/prisoner/pressurized

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/Initialize(mapload)
	. = ..()
	refresh_air()

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/proc/refresh_air()
	air_contents = null
	air_contents = new(50) //liters
	air_contents.set_temperature(T20C)

	air_contents.set_moles(GAS_O2, (ONE_ATMOSPHERE*50)/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD)
	air_contents.set_moles(GAS_N2O, (ONE_ATMOSPHERE*50)/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/Destroy()
	if(air_contents)
		QDEL_NULL(air_contents)
	return ..()

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/return_air()
	if(sinched)
		refresh_air()
		return air_contents
	return ..()

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/remove_air(amount)
	if(sinched)
		refresh_air()
		return air_contents.remove(amount) // The internals for this bag are bottomless.
	return ..(amount)

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/return_analyzable_air()
	if(sinched)
		refresh_air()
		return air_contents
	return ..()

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/togglelock(mob/living/user, silent)
	. = ..()
	if(sinched)
		for(var/mob/living/target in contents)
			to_chat(target, span_warning("You hear a faint hiss, and a white mist fills your vision..."))

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/syndicate
	name = "syndicate prisoner transport bag"
	desc = "An alteration of Nanotrasen's environmental protection bag which has been used in several high-profile kidnappings. Designed to keep a victim unconscious, alive, and secured during transport."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "syndieenvirobag"
	contents_pressure_protection = 1
	contents_thermal_insulation = 1
	foldedbag_path = /obj/item/bodybag/environmental/prisoner/syndicate
	weather_protection = list(TRAIT_WEATHER_IMMUNE)
	breakout_time = 8 MINUTES
	sinch_time = 20 SECONDS

/obj/structure/closet/body_bag/environmental/prisoner/pressurized/syndicate/refresh_air()
	air_contents = null
	air_contents = new(50) //liters
	air_contents.set_temperature(T20C)

	air_contents.set_moles(GAS_O2, (ONE_ATMOSPHERE*50)/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD)
	air_contents.set_moles(GAS_N2O, (ONE_ATMOSPHERE*50)/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)
