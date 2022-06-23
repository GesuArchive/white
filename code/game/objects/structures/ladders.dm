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
	/// Optional travel time for ladder in deciseconds
	var/travel_time = 1.5 SECONDS

/obj/structure/ladder/Initialize(mapload, obj/structure/ladder/up, obj/structure/ladder/down)
	..()
	if (up)
		src.up = up
		up.down = src
		up.update_icon()
	if (down)
		src.down = down
		down.up = src
		down.update_icon()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/ladder/Destroy(force)
	if ((resistance_flags & INDESTRUCTIBLE) && !force)
		return QDEL_HINT_LETMELIVE
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
				L.update_icon()
	if (!up)
		L = locate() in SSmapping.get_turf_above(T)
		if (L)
			if(crafted == L.crafted)
				up = L
				L.down = src  // Don't waste effort looping the other way
				L.update_icon()

	update_icon()

/obj/structure/ladder/proc/disconnect()
	if(up && up.down == src)
		up.down = null
		up.update_icon()
	if(down && down.up == src)
		down.up = null
		down.update_icon()
	up = down = null

/obj/structure/ladder/update_icon_state()
	if(up && down)
		icon_state = "ladder11"
	else if(up)
		icon_state = "ladder10"
	else if(down)
		icon_state = "ladder01"
	else	//wtf make your ladders properly assholes
		icon_state = "ladder00"

/obj/structure/ladder/singularity_pull()
	if (!(resistance_flags & INDESTRUCTIBLE))
		visible_message(span_danger("[capitalize(src.name)] разлетается на куски под силой гравитации!"))
		qdel(src)

/obj/structure/ladder/proc/travel(going_up, mob/user, is_ghost, obj/structure/ladder/ladder)
	var/response = SEND_SIGNAL(user, COMSIG_LADDER_TRAVEL, src, ladder, going_up)
	if(response & LADDER_TRAVEL_BLOCK)
		return

	if(!is_ghost)
		ladder.add_fingerprint(user)
		if(!do_after(user, travel_time, target = src))
			return
		show_fluff_message(going_up, user)

	if(!HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES) && !HAS_TRAIT(user, TRAIT_FREERUNNING))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.adjustStaminaLoss(5)

	if(isliving(user))
		playsound(get_turf(user), "ladder", 55, TRUE)

	var/turf/target = get_turf(ladder)
	user.zMove(target = target, z_move_flags = ZMOVE_CHECK_PULLEDBY|ZMOVE_ALLOW_BUCKLED|ZMOVE_INCLUDE_PULLED)
	ladder.use(user) //reopening ladder radial menu ahead

/obj/structure/ladder/proc/use(mob/user, is_ghost=FALSE)
	if (!is_ghost && !in_range(src, user))
		return

	var/list/tool_list = list()
	if (up)
		tool_list["Up"] = image(icon = 'icons/testing/turf_analysis.dmi', icon_state = "red_arrow", dir = NORTH)
	if (down)
		tool_list["Down"] = image(icon = 'icons/testing/turf_analysis.dmi', icon_state = "red_arrow", dir = SOUTH)
	if (!length(tool_list))
		to_chat(user, span_warning("[capitalize(src.name)] никуда не ведёт!"))
		return

	var/result = show_radial_menu(user, src, tool_list, custom_check = CALLBACK(src, .proc/check_menu, user, is_ghost), require_near = !is_ghost, tooltips = TRUE)
	if (!is_ghost && !in_range(src, user))
		return  // nice try
	switch(result)
		if("Up")
			travel(TRUE, user, is_ghost, up)
		if("Down")
			travel(FALSE, user, is_ghost, down)
		if("Cancel")
			return

	if(!is_ghost)
		add_fingerprint(user)

/obj/structure/ladder/proc/check_menu(mob/user, is_ghost)
	if(user.incapacitated() || (!user.Adjacent(src) && !is_ghost))
		return FALSE
	return TRUE

/obj/structure/ladder/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/ladder/attack_animal(mob/user)
	return use(user)

/obj/structure/ladder/attack_slime(mob/user)
	return use(user)

/obj/structure/ladder/attack_paw(mob/user)
	return use(user)

/obj/structure/ladder/attack_alien(mob/user)
	return use(user)

/obj/structure/ladder/attackby(obj/item/W, mob/user, params)
	return use(user)

/obj/structure/ladder/attack_robot(mob/living/silicon/robot/R)
	if(R.Adjacent(src))
		return use(R)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/structure/ladder/attack_ghost(mob/dead/observer/user)
	use(user, TRUE)
	return ..()

/obj/structure/ladder/proc/show_fluff_message(going_up, mob/user)
	if(going_up)
		user.visible_message(span_notice("[user] поднимается наверх по лестнице.") , span_notice("Поднимаюсь наверх по лестнице."))
	else
		user.visible_message(span_notice("[user] спускается вниз по лестнице.") , span_notice("Спускаюсь вниз по лестнице."))


// Indestructible away mission ladders which link based on a mapped ID and height value rather than X/Y/Z.
/obj/structure/ladder/unbreakable
	name = "прочная лестница"
	desc = "Невероятно крепкая лестница."
	resistance_flags = INDESTRUCTIBLE
	var/id
	var/height = 0  // higher numbers are considered physically higher

/obj/structure/ladder/unbreakable/Initialize(mapload)
	GLOB.ladders += src
	return ..()

/obj/structure/ladder/unbreakable/Destroy()
	. = ..()
	if (. != QDEL_HINT_LETMELIVE)
		GLOB.ladders -= src

/obj/structure/ladder/unbreakable/LateInitialize()
	// Override the parent to find ladders based on being height-linked
	if (!id || (up && down))
		update_icon()
		return

	for (var/O in GLOB.ladders)
		var/obj/structure/ladder/unbreakable/L = O
		if (L.id != id)
			continue  // not one of our pals
		if (!down && L.height == height - 1)
			down = L
			L.up = src
			L.update_icon()
			if (up)
				break  // break if both our connections are filled
		else if (!up && L.height == height + 1)
			up = L
			L.down = src
			L.update_icon()
			if (down)
				break  // break if both our connections are filled

	update_icon()

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
