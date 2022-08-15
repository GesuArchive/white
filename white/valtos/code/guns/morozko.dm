/obj/item/morozko
	name = "генератор \"Морозко\""
	desc = "Модифицированный бак с фреоном, который был снят с древнего хладогенного устройства. Позволяет замораживать что угодно и где угодно."
	icon = 'white/valtos/icons/objects.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	icon_state = "morozko"
	inhand_icon_state = "morozko"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	actions_types = list(/datum/action/item_action/toggle_morozko)
	max_integrity = 200
	var/obj/item/noz

/datum/action/item_action/toggle_morozko
	name = "Переключить"

/obj/item/morozko/Initialize(mapload)
	. = ..()
	noz = make_noz()

/obj/item/morozko/Destroy()
	QDEL_NULL(noz)
	return ..()

/obj/item/morozko/ui_action_click(mob/user)
	toggle_morozko(user)

/obj/item/morozko/item_action_slot_check(slot, mob/user)
	if(slot == user.getBackSlot())
		return TRUE

/obj/item/morozko/proc/toggle_morozko(mob/living/user)
	if(!istype(user))
		return
	if(user.get_item_by_slot(user.getBackSlot()) != src)
		to_chat(user, span_warning("Нужно носить это на спине для использования!"))
		return
	if(user.incapacitated())
		return

	if(QDELETED(noz))
		noz = make_noz()
	if(noz in src)
		//Detach the nuzzle into the user's hands
		if(!user.put_in_hands(noz))
			to_chat(user, span_warning("Нужны свободные руки!"))
			return
	else
		//Remove from their hands and put back "into" the tank
		remove_noz()

/obj/item/morozko/verb/toggle_morozko_verb()
	set name = "Распылитель"
	set category = "Объект"
	toggle_morozko(usr)

/obj/item/morozko/proc/make_noz()
	return new /obj/item/morozko_nuzzle(src)

/obj/item/morozko/equipped(mob/user, slot)
	..()
	if(slot != ITEM_SLOT_BACK)
		remove_noz()

/obj/item/morozko/proc/remove_noz()
	if(!QDELETED(noz))
		if(ismob(noz.loc))
			var/mob/M = noz.loc
			M.temporarilyRemoveItemFromInventory(noz, TRUE)
		noz.forceMove(src)

/obj/item/morozko/attack_hand(mob/user)
	if (user.get_item_by_slot(user.getBackSlot()) == src)
		toggle_morozko(user)
	else
		return ..()

/obj/item/morozko/MouseDrop(obj/over_object)
	var/mob/M = loc
	if(istype(M) && istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over_object
		M.putItemFromInventoryInHandIfPossible(src, H.held_index)
	return ..()

/obj/item/morozko/attackby(obj/item/W, mob/user, params)
	if(W == noz)
		remove_noz()
		return TRUE
	else
		return ..()

/obj/item/morozko/dropped(mob/user)
	..()
	remove_noz()

/obj/item/morozko_nuzzle
	name = "распылитель"
	desc = "Подключён к устройству на спине. Твоей."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "morozko_nuzzle"
	inhand_icon_state = "morozko_nuzzle"
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	item_flags = NOBLUDGEON | ABSTRACT
	slot_flags = NONE

	var/obj/item/morozko/tank

/obj/item/morozko_nuzzle/Initialize(mapload)
	. = ..()
	tank = loc
	if(!istype(tank))
		return INITIALIZE_HINT_QDEL

/obj/item/morozko_nuzzle/attack_self()
	return

/obj/item/morozko_nuzzle/doMove(atom/destination)
	if(destination && (destination != tank.loc || !ismob(destination)))
		if (loc != tank)
			to_chat(tank.loc, span_notice("Распылитель прыгает обратно к баку."))
		destination = tank
	..()

///This proc creates a list of turfs that are hit by the cone
/obj/item/morozko_nuzzle/proc/cone_helper(turf/starter_turf, dir_to_use, cone_levels = 7)
	var/list/turfs_to_return = list()
	var/turf/turf_to_use = starter_turf
	var/turf/left_turf
	var/turf/right_turf
	var/right_dir
	var/left_dir
	switch(dir_to_use)
		if(NORTH)
			left_dir = WEST
			right_dir = EAST
		if(SOUTH)
			left_dir = EAST
			right_dir = WEST
		if(EAST)
			left_dir = NORTH
			right_dir = SOUTH
		if(WEST)
			left_dir = SOUTH
			right_dir = NORTH


	for(var/i in 1 to cone_levels)
		var/list/level_turfs = list()
		turf_to_use = get_step(turf_to_use, dir_to_use)
		level_turfs += turf_to_use
		if(i != 1)
			left_turf = get_step(turf_to_use, left_dir)
			level_turfs += left_turf
			right_turf = get_step(turf_to_use, right_dir)
			level_turfs += right_turf
			for(var/left_i in 1 to i -calculate_cone_shape(i))
				if(left_turf.density)
					break
				left_turf = get_step(left_turf, left_dir)
				level_turfs += left_turf
			for(var/right_i in 1 to i -calculate_cone_shape(i))
				if(right_turf.density)
					break
				right_turf = get_step(right_turf, right_dir)
				level_turfs += right_turf
		turfs_to_return += list(level_turfs)
		if(i == cone_levels)
			continue
		if(turf_to_use.density)
			break
	return turfs_to_return

/obj/item/morozko_nuzzle/proc/calculate_cone_shape(current_level)
	var/end_taper_start = 6
	if(current_level > end_taper_start)
		return (current_level % end_taper_start) * 2 //someone more talented and probably come up with a better formula.
	else
		return 2

/obj/item/morozko_nuzzle/afterattack(atom/A, mob/user, proximity)
	if(A.loc == loc)
		return

	. = ..()

	var/list/turfs = cone_helper(get_turf(src), user.dir)

	for(var/turf/T in turfs)
		if(istype(T, /turf/closed))
			break
		var/turf/open/OT = T
		OT.MakeSlippery(TURF_WET_PERMAFROST, 50)
		for(var/mob/living/L in T.contents)
			L.adjust_bodytemperature(-300)
			L.apply_status_effect(/datum/status_effect/freon)
			to_chat(L, span_userdanger("ХОЛОДНО!!!"))

		for(var/obj/I in T.contents)
			if(I.resistance_flags & FREEZE_PROOF)
				continue
			if(!(I.obj_flags & FROZEN))
				I.make_frozen_visual()

		for(var/obj/vehicle/sealed/mecha/M in T.contents)
			M.take_damage(45, BRUTE, MELEE, 1)

	playsound(src.loc, 'sound/effects/spray3.ogg', 50, TRUE, -6)

	user.changeNext_move(15 SECONDS) // fucking refrigerator dude
	user.newtonian_move(get_dir(A, user))

	var/turf/T = get_turf(src)

	log_combat(user, T, "frosted", src)
	log_game("[key_name(user)] fired <b>[src.name]</b> at [AREACOORD(T)].") //copypasta falling out of my pockets
	return
