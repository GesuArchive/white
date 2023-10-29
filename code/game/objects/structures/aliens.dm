/* Alien shit!
 * Contains:
 *		structure/alien
 *		Resin
 *		Weeds
 *		Egg
 */


/obj/structure/alien
	icon = 'icons/mob/alien.dmi'
	max_integrity = 100

/obj/structure/alien/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == MELEE)
		switch(damage_type)
			if(BRUTE)
				damage_amount *= 0.25
			if(BURN)
				damage_amount *= 2
	. = ..()

/obj/structure/alien/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			if(damage_amount)
				playsound(loc, 'sound/items/welder.ogg', 100, TRUE)

/*
 * Generic alien stuff, not related to the purple lizards but still alien-like
 */

/obj/structure/alien/gelpod
	name = "смоляной кокон"
	desc = "Застывшая смола сформированная в виде огромного кокона, кажется внутри кто-то есть..."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "gelmound"

/obj/structure/alien/gelpod/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new/obj/effect/mob_spawn/human/corpse/damaged(get_turf(src))
	qdel(src)

/*
 * Resin
 */
/obj/structure/alien/resin
	name = "смола"
	desc = "Черная, липкая, но в то же время весьма прочная субстанция."
	icon = 'icons/obj/smooth_structures/alien/resin_wall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_RESIN)
	max_integrity = 200
	var/resintype = null
	can_atmos_pass = ATMOS_PASS_DENSITY


/obj/structure/alien/resin/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE)

/obj/structure/alien/resin/Destroy()
	air_update_turf(TRUE)
	. = ..()

/obj/structure/alien/resin/Move()
	var/turf/T = loc
	. = ..()
	move_update_air(T)

/obj/structure/alien/resin/wall
	name = "смоляная стена"
	desc = "Черная, липкая, но в то же время весьма прочная субстанция, перегораживающая проход."
	icon = 'icons/obj/smooth_structures/alien/resin_wall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	resintype = "wall"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)

/obj/structure/alien/resin/wall/block_superconductivity()
	return TRUE

/obj/structure/alien/resin/wall/creature
	name = "студенистая стена"
	desc = "Прочная субстанция, перегораживающая проход."
	color = "#8EC127"

/obj/structure/alien/resin/membrane
	name = "смоляная мембрана"
	desc = "Биполяризованная смола достаточно тонкая и прозрачная для того, чтобы сквозь нее можно было различить силуэты по ту сторону пленки."
	icon = 'icons/obj/smooth_structures/alien/resin_membrane.dmi'
	icon_state = "resin_membrane-0"
	base_icon_state = "resin_membrane"
	opacity = FALSE
	pass_flags_self = PASSGLASS
	max_integrity = 160
	resintype = "membrane"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)

/obj/structure/alien/resin/attack_paw(mob/user)
	return attack_hand(user)

///Used in the big derelict ruin exclusively.
/obj/structure/alien/resin/membrane/creature
	name = "студенистая мембрана"
	desc = "Странный прозрачный материал похожий на древесную смолу."
	color = "#4BAE56"

/*
 * Weeds
 */

#define NODERANGE 3

/obj/structure/alien/weeds
	gender = PLURAL
	name = "смола"
	desc = "Черный, пружинистый наст, покрывающий пол тонким слоем."
	anchored = TRUE
	density = FALSE
	layer = MID_TURF_LAYER
	plane = FLOOR_PLANE
	icon = 'icons/obj/smooth_structures/alien/weeds1.dmi'
	icon_state = "weeds1-0"
	base_icon_state = "weeds1"
	max_integrity = 15
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WEEDS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WEEDS, SMOOTH_GROUP_WALLS)
	var/last_expand = 0 //last world.time this weed expanded
	var/growth_cooldown_low = 150
	var/growth_cooldown_high = 200
	var/static/list/blacklisted_turfs


/obj/structure/alien/weeds/Initialize(mapload)
	pixel_x = -4
	pixel_y = -4 //so the sprites line up right in the map editor

	. = ..()

	if(!blacklisted_turfs)
		blacklisted_turfs = typecacheof(list(
			/turf/open/space,
			/turf/open/chasm,
			/turf/open/lava,
			/turf/open/openspace))

	set_base_icon()

	last_expand = world.time + rand(growth_cooldown_low, growth_cooldown_high)


///Randomizes the weeds' starting icon, gets redefined by children for them not to share the behavior.
/obj/structure/alien/weeds/proc/set_base_icon()
	. = base_icon_state
	switch(rand(1,3))
		if(1)
			icon = 'icons/obj/smooth_structures/alien/weeds1.dmi'
			base_icon_state = "weeds1"
		if(2)
			icon = 'icons/obj/smooth_structures/alien/weeds2.dmi'
			base_icon_state = "weeds2"
		if(3)
			icon = 'icons/obj/smooth_structures/alien/weeds3.dmi'
			base_icon_state = "weeds3"
	set_smoothed_icon_state(smoothing_junction)


/obj/structure/alien/weeds/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/atmos_sensitive)

/obj/structure/alien/weeds/proc/expand()
	var/turf/U = get_turf(src)
	if(is_type_in_typecache(U, blacklisted_turfs))
		qdel(src)
		return FALSE

	for(var/turf/T in U.get_atmos_adjacent_turfs())
		if(locate(/obj/structure/alien/weeds) in T)
			continue

		if(is_type_in_typecache(T, blacklisted_turfs))
			continue

		new /obj/structure/alien/weeds(T)
	return TRUE

/obj/structure/alien/weeds/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 300

/obj/structure/alien/weeds/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(5, BURN, 0, 0)

//Weed nodes
/obj/structure/alien/weeds/node
	name = "смоляная колония"
	desc = "Чужеродная колония-опухоль населенная микроксеноорганизмами, терраформирующими окружающую территорию при помощи биполярной смолы."
	icon = 'icons/obj/smooth_structures/alien/weednode.dmi'
	icon_state = "weednode-0"
	base_icon_state = "weednode"
	light_color = LIGHT_COLOR_BLUE
	light_power = 0.5
	var/lon_range = 4
	var/node_range = NODERANGE


/obj/structure/alien/weeds/node/Initialize(mapload)
	. = ..()
	set_light(lon_range)
	var/obj/structure/alien/weeds/W = locate(/obj/structure/alien/weeds) in loc
	if(W && W != src)
		qdel(W)
	START_PROCESSING(SSobj, src)


/obj/structure/alien/weeds/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/structure/alien/weeds/node/process()
	for(var/obj/structure/alien/weeds/W in range(node_range, src))
		if(W.last_expand <= world.time)
			if(W.expand())
				W.last_expand = world.time + rand(growth_cooldown_low, growth_cooldown_high)


/obj/structure/alien/weeds/node/set_base_icon()
	return //No icon randomization at init. The node's icon is already well defined.

/obj/structure/alien/weeds/creature
	name = "студенистый наст"
	desc = "Странная, зеленая масса, покрывающая пол тонким слоем."
	color = "#4BAE56"


#undef NODERANGE


/*
 * Egg
 */

//for the status var
#define BURST "burst"
#define GROWING "growing"
#define GROWN "grown"
#define MIN_GROWTH_TIME 900	//time it takes to grow a hugger
#define MAX_GROWTH_TIME 1500

/obj/structure/alien/egg
	name = "яйцо"
	desc = "Огромное, кожистое яйцо."
	var/base_icon = "egg"
	icon_state = "egg_growing"
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	integrity_failure = 0.05
	var/status = GROWING	//can be GROWING, GROWN or BURST; all mutually exclusive
	layer = MOB_LAYER
	plane = GAME_PLANE_FOV_HIDDEN
	var/obj/item/clothing/mask/facehugger/child

/obj/structure/alien/egg/Initialize(mapload)
	. = ..()
	update_icon()
	if(status == GROWING || status == GROWN)
		child = new(src)
	if(status == GROWING)
		addtimer(CALLBACK(src, PROC_REF(Grow)), rand(MIN_GROWTH_TIME, MAX_GROWTH_TIME))
	proximity_monitor = new(src, status == GROWN ? 1 : 0)
	if(status == BURST)
		obj_integrity = integrity_failure * max_integrity

/obj/structure/alien/egg/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/atmos_sensitive)

/obj/structure/alien/egg/update_icon_state()
	. = ..()
	switch(status)
		if(GROWING)
			icon_state = "[base_icon]_growing"
		if(GROWN)
			icon_state = "[base_icon]"
		if(BURST)
			icon_state = "[base_icon]_hatched"

/obj/structure/alien/egg/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/alien/egg/attack_alien(mob/living/carbon/alien/user)
	return attack_hand(user)

/obj/structure/alien/egg/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(user.getorgan(/obj/item/organ/alien/plasmavessel))
		switch(status)
			if(BURST)
				to_chat(user, span_notice("Убираю вылупившееся яйцо."))
				playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
				qdel(src)
				return
			if(GROWING)
				to_chat(user, span_notice("Этот детеныш еще не готов к вылуплению."))
				return
			if(GROWN)
				to_chat(user, span_notice("Пробуждаю детеныша."))
				Burst(kill=FALSE)
				return
	else
		to_chat(user, span_notice("Оно склизкое на ощупь."))
		user.changeNext_move(CLICK_CD_MELEE)


/obj/structure/alien/egg/proc/Grow()
	status = GROWN
	update_icon()
	proximity_monitor.set_range(1)

//drops and kills the hugger if any is remaining
/obj/structure/alien/egg/proc/Burst(kill = TRUE)
	if(status == GROWN || status == GROWING)
		proximity_monitor.set_range(0)
		status = BURST
		update_icon()
		flick("egg_opening", src)
		addtimer(CALLBACK(src, PROC_REF(finish_bursting), kill), 15)

/obj/structure/alien/egg/proc/finish_bursting(kill = TRUE)
	if(child)
		child.forceMove(get_turf(src))
		// TECHNICALLY you could put non-facehuggers in the child var
		if(istype(child))
			if(kill)
				child.Die()
			else
				for(var/mob/M in range(1,src))
					if(CanHug(M))
						child.Leap(M)
						break

/obj/structure/alien/egg/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 500

/obj/structure/alien/egg/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(5, BURN, 0, 0)

/obj/structure/alien/egg/obj_break(damage_flag)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(status != BURST)
			Burst(kill=TRUE)

/obj/structure/alien/egg/HasProximity(atom/movable/AM)
	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.getorgan(/obj/item/organ/body_egg/alien_embryo))
			return

		Burst(kill=FALSE)

/obj/structure/alien/egg/grown
	status = GROWN
	icon_state = "egg"

/obj/structure/alien/egg/burst
	status = BURST
	icon_state = "egg_hatched"

#undef BURST
#undef GROWING
#undef GROWN
#undef MIN_GROWTH_TIME
#undef MAX_GROWTH_TIME
