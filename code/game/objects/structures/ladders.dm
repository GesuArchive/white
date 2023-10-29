// Basic ladder. By default links to the z-level above/below.
/obj/structure/ladder
	name = "лестница"
	desc = "Крепкая металлическая лестница."
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"
	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	var/obj/structure/ladder/down   //the ladder below this one
	var/obj/structure/ladder/up     //the ladder above this one
	var/crafted = FALSE
	/// travel time for ladder in deciseconds
	var/travel_time = 1 SECONDS

/obj/structure/ladder/Initialize(mapload, obj/structure/ladder/up, obj/structure/ladder/down)
	..()
	GLOB.ladders += src
	if (up)
		src.up = up
		up.down = src
		up.update_appearance()
	if (down)
		src.down = down
		down.up = src
		down.update_appearance()

	register_context()

	return INITIALIZE_HINT_LATELOAD

/obj/structure/ladder/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(up)
		context[SCREENTIP_CONTEXT_LMB] = "Подняться"
	if(down)
		context[SCREENTIP_CONTEXT_RMB] = "Опуститься"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/ladder/Destroy(force)
	GLOB.ladders -= src
	disconnect()
	return ..()

/obj/structure/ladder/LateInitialize()
	// By default, discover ladders above and below us vertically
	var/turf/T = get_turf(src)
	var/obj/structure/ladder/L

	if (!down)
		L = locate() in SSmapping.get_turf_below(T)
		if (L)
			if(crafted == L.crafted)
				down = L
				L.up = src  // Don't waste effort looping the other way
				L.update_appearance()
	if (!up)
		L = locate() in SSmapping.get_turf_above(T)
		if (L)
			if(crafted == L.crafted)
				up = L
				L.down = src  // Don't waste effort looping the other way
				L.update_appearance()

	update_appearance()

/obj/structure/ladder/proc/disconnect()
	if(up && up.down == src)
		up.down = null
		up.update_appearance()
	if(down && down.up == src)
		down.up = null
		down.update_appearance()
	up = down = null

/obj/structure/ladder/update_icon_state()
	icon_state = "ladder[up ? 1 : 0][down ? 1 : 0]"
	return ..()

/obj/structure/ladder/singularity_pull()
	if (!(resistance_flags & INDESTRUCTIBLE))
		visible_message(span_danger("[capitalize(src.name)] разлетается на куски под силой гравитации!"))
		qdel(src)

/obj/structure/ladder/proc/use(mob/user, going_up = TRUE)
	if(!in_range(src, user) || DOING_INTERACTION(user, DOAFTER_SOURCE_CLIMBING_LADDER))
		return

	if(!up && !down)
		balloon_alert(user, "никуда не ведёт!")
		return
	if(going_up ? !up : !down)
		balloon_alert(user, "некуда больше [going_up ? "подниматься" : "опускаться"]")
		return
	if(travel_time)
		INVOKE_ASYNC(src, PROC_REF(start_travelling), user, going_up)
	else
		travel(user, going_up)
	add_fingerprint(user)

/obj/structure/ladder/proc/start_travelling(mob/user, going_up)
	show_initial_fluff_message(user, going_up)
	if(do_after(user, travel_time, target = src, interaction_key = DOAFTER_SOURCE_CLIMBING_LADDER))
		travel(user, going_up)

/// The message shown when the player starts climbing the ladder
/obj/structure/ladder/proc/show_initial_fluff_message(mob/user, going_up)
	var/up_down = going_up ? "поднимается" : "опускается"
	user.balloon_alert_to_viewers("[up_down]...")

/obj/structure/ladder/proc/travel(mob/user, going_up = TRUE, is_ghost = FALSE)
	var/obj/structure/ladder/ladder = going_up ? up : down
	if(!ladder)
		balloon_alert(user, "там нет ничего!")
		return
	var/response = SEND_SIGNAL(user, COMSIG_LADDER_TRAVEL, src, ladder, going_up)
	if(response & LADDER_TRAVEL_BLOCK)
		return

	if(!HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES) && !HAS_TRAIT(user, TRAIT_FREERUNNING))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.adjustStaminaLoss(5)

	if(isliving(user))
		playsound(get_turf(user), "ladder", 55, TRUE)

	var/turf/target = get_turf(ladder)
	user.zMove(target = target, z_move_flags = ZMOVE_CHECK_PULLEDBY|ZMOVE_ALLOW_BUCKLED|ZMOVE_INCLUDE_PULLED)

	if(!is_ghost)
		show_final_fluff_message(user, ladder, going_up)

	// to avoid having players hunt for the pixels of a ladder that goes through several stories and is
	// partially covered by the sprites of their mobs, a radial menu will be displayed over them.
	// this way players can keep climbing up or down with ease until they reach an end.
	if(ladder.up && ladder.down)
		ladder.show_options(user, is_ghost)

/// The messages shown after the player has finished climbing. Players can see this happen from either src or the destination so we've 2 POVs here
/obj/structure/ladder/proc/show_final_fluff_message(mob/user, obj/structure/ladder/destination, going_up)
	var/up_down = going_up ? "поднимается" : "опускается"

	//POV of players around the source
	visible_message(span_notice("[user] [up_down] по лестнице."))
	//POV of players around the destination
	user.balloon_alert_to_viewers("[up_down]")

/// Shows a radial menu that players can use to climb up and down a stair.
/obj/structure/ladder/proc/show_options(mob/user, is_ghost = FALSE)
	var/list/tool_list = list()
	tool_list["Вверх"] = image(icon = 'icons/testing/turf_analysis.dmi', icon_state = "red_arrow", dir = NORTH)
	tool_list["Вниз"] = image(icon = 'icons/testing/turf_analysis.dmi', icon_state = "red_arrow", dir = SOUTH)

	var/datum/callback/check_menu
	if(!is_ghost)
		check_menu = CALLBACK(src, PROC_REF(check_menu), user)
	var/result = show_radial_menu(user, src, tool_list, custom_check = check_menu, require_near = !is_ghost, tooltips = TRUE)

	var/going_up
	switch(result)
		if("Вверх")
			going_up = TRUE
		if("Вниз")
			going_up = FALSE
		if("Отмена")
			return

	if(is_ghost || !travel_time)
		travel(user, going_up, is_ghost)
	else
		INVOKE_ASYNC(src, PROC_REF(start_travelling), user, going_up)

/obj/structure/ladder/proc/check_menu(mob/user, is_ghost)
	if(user.incapacitated() || (!user.Adjacent(src)))
		return FALSE
	return TRUE

/obj/structure/ladder/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/ladder/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	use(user, going_up = FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

//Not be called when right clicking as a monkey. attack_hand_secondary() handles that.
/obj/structure/ladder/attack_paw(mob/user, list/modifiers)
	use(user)
	return TRUE

/obj/structure/ladder/attack_alien(mob/user, list/modifiers)
	use(user)
	return TRUE
/*
/obj/structure/ladder/attack_alien_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	use(user, going_up = FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
*/
/obj/structure/ladder/attack_larva(mob/user, list/modifiers)
	use(user)
	return TRUE
/*
/obj/structure/ladder/attack_larva_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	use(user, going_up = FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
*/
/obj/structure/ladder/attack_animal(mob/user, list/modifiers)
	use(user)
	return TRUE
/*
/obj/structure/ladder/attack_animal_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	use(user, going_up = FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
*/
/obj/structure/ladder/attack_slime(mob/user, list/modifiers)
	use(user)
	return TRUE
/*
/obj/structure/ladder/attack_slime_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	use(user, going_up = FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
*/
/obj/structure/ladder/attackby(obj/item/item, mob/user, params)
	use(user)
	return TRUE

/obj/structure/ladder/attackby_secondary(obj/item/item, mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	use(user, going_up = FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/ladder/attack_robot(mob/living/silicon/robot/user)
	if(user.Adjacent(src))
		use(user)
	return TRUE

/obj/structure/ladder/attack_robot_secondary(mob/living/silicon/robot/user)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !user.Adjacent(src))
		return SECONDARY_ATTACK_CONTINUE_CHAIN
	use(user, going_up = FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/structure/ladder/attack_ghost(mob/dead/observer/user)
	ghost_use(user)
	return ..()

///Ghosts use the byond default popup menu function on right click, so this is going to work a little differently for them.
/obj/structure/ladder/proc/ghost_use(mob/user)
	if (!up && !down)
		balloon_alert(user, "никуда не ведёт!")
		return
	if(!up) //only goes down
		travel(user, going_up = FALSE, is_ghost = TRUE)
	else if(!down) //only goes up
		travel(user, going_up = TRUE, is_ghost = TRUE)
	else //goes both ways
		show_options(user, is_ghost = TRUE)

// Indestructible away mission ladders which link based on a mapped ID and height value rather than X/Y/Z.
/obj/structure/ladder/unbreakable
	name = "прочная лестница"
	desc = "Невероятно крепкая лестница."
	resistance_flags = INDESTRUCTIBLE
	var/id
	var/height = 0  // higher numbers are considered physically higher

/obj/structure/ladder/unbreakable/LateInitialize()
	// Override the parent to find ladders based on being height-linked
	if (!id || (up && down))
		update_appearance()
		return

	for(var/obj/structure/ladder/unbreakable/unbreakable_ladder in GLOB.ladders)
		if (unbreakable_ladder.id != id)
			continue  // not one of our pals
		if (!down && unbreakable_ladder.height == height - 1)
			down = unbreakable_ladder
			unbreakable_ladder.up = src
			unbreakable_ladder.update_appearance()
			if (up)
				break  // break if both our connections are filled
		else if (!up && unbreakable_ladder.height == height + 1)
			up = unbreakable_ladder
			unbreakable_ladder.down = src
			unbreakable_ladder.update_appearance()
			if (down)
				break  // break if both our connections are filled

	update_appearance()

/obj/structure/ladder/crafted
	crafted = TRUE

//should be called on turf above player
/turf/proc/canlookthroughladderup(mob/M)
	if(locate(/obj/structure/ladder) in src)
		var/obj/structure/ladder/L = locate(/obj/structure/ladder) in src
		if(M.z == L.down?.z)
			return TRUE
	return FALSE

//should be called on turf where is player
/turf/proc/canlookthroughladderdown(mob/M)
	if(locate(/obj/structure/ladder) in src)
		var/obj/structure/ladder/L = locate(/obj/structure/ladder) in src
		if(L.down)
			return TRUE
	return FALSE
