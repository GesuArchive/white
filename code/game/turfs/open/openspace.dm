/turf/open/openspace
	name = "открытое пространство"
	desc = "Смотри под ноги!"
	icon = 'white/valtos/icons/openspace.dmi'
	icon_state = "hule"
	//base_icon_state = "openspace"
	//smoothing_flags = SMOOTH_BITMASK
	//canSmoothWith = list(SMOOTH_GROUP_OPENSPACE)
	//smoothing_groups = list(SMOOTH_GROUP_OPENSPACE)
	baseturfs = /turf/open/openspace
	intact = FALSE //this means wires go on top
	pathing_pass_method = TURF_PATHING_PASS_PROC
	//mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/can_cover_up = TRUE
	var/can_build_on = TRUE

/turf/open/openspace/Initialize(mapload) // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_CREATED, PROC_REF(on_atom_created))
	var/area/our_area = loc
	if(istype(our_area, /area/space))
		force_no_gravity = TRUE
	return INITIALIZE_HINT_LATELOAD

/turf/open/openspace/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency)

/turf/open/openspace/ChangeTurf(path, list/new_baseturfs, flags)
	UnregisterSignal(src, COMSIG_ATOM_CREATED)
	return ..()

/**
 * Prepares a moving movable to be precipitated if Move() is successful.
 * This is done in Enter() and not Entered() because there's no easy way to tell
 * if the latter was called by Move() or forceMove() while the former is only called by Move().
 */
/turf/open/openspace/Enter(atom/movable/movable, atom/oldloc)
	. = ..()
	if(.)
		//higher priority than CURRENTLY_Z_FALLING so the movable doesn't fall on Entered()
		movable.set_currently_z_moving(CURRENTLY_Z_FALLING_FROM_MOVE)

///Makes movables fall when forceMove()'d to this turf.
/turf/open/openspace/Entered(atom/movable/movable)
	. = ..()
	if(movable.set_currently_z_moving(CURRENTLY_Z_FALLING))
		zFall(movable, falling_from_move = TRUE)
/**
 * Drops movables spawned on this turf only after they are successfully initialized.
 * so flying mobs, qdeleted movables and things that were moved somewhere else during
 * Initialize() won't fall by accident.
 */
/turf/open/openspace/proc/on_atom_created(datum/source, atom/created_atom)
	SIGNAL_HANDLER
	if(ismovable(created_atom))
		//Drop it only when it's finished initializing, not before.
		addtimer(CALLBACK(src, PROC_REF(zfall_if_on_turf), created_atom), 0 SECONDS)

/turf/open/openspace/proc/zfall_if_on_turf(atom/movable/movable)
	if(QDELETED(movable) || movable.loc != src)
		return
	zFall(movable)

/turf/open/openspace/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return TRUE
	return FALSE

/turf/open/openspace/zAirIn()
	return TRUE

/turf/open/openspace/zAirOut()
	return TRUE

/turf/open/openspace/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/openspace/zPassOut(atom/movable/A, direction, turf/destination)
	if(A.anchored)
		return FALSE
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/openspace/proc/CanCoverUp()
	return can_cover_up

/turf/open/openspace/proc/CanBuildHere()
	return can_build_on

/turf/open/openspace/attack_tk(mob/user)
	return

/turf/open/openspace/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(locate(/obj/structure/lattice) in src)
		return
	var/turf/turf_below = SSmapping.get_turf_below(src)
	if(isopenturf(turf_below))
		if(do_after(user, 3 SECONDS, target = src))
			user.forceMove(turf_below)
			to_chat(user, span_notice("Аккуратно спускаюсь вниз..."))
			if(!HAS_TRAIT(user, TRAIT_FREERUNNING))
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					H.adjustStaminaLoss(60)

/turf/open/openspace/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return
	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			to_chat(user, span_warning("Здесь уже есть мостик!"))
			return
		if(L)
			if(R.use(1))
				qdel(L)
				to_chat(user, span_notice("Строю мостик."))
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				new/obj/structure/lattice/catwalk(src)
			else
				to_chat(user, span_warning("Нужно чуть больше прутьев для постройки мостика!"))
			return
		if(R.use(1))
			to_chat(user, span_notice("Устанавливаю подпорку."))
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
			ReplaceWithLattice()
		else
			to_chat(user, span_warning("Нужно чуть больше прутьев для постройки подпорки."))
		return
	if(istype(C, /obj/item/stack/tile/plasteel))
		if(!CanCoverUp())
			return
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				to_chat(user, span_notice("Строю пол."))
				PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			else
				to_chat(user, span_warning("Нужна плитка для постройки пола!"))
		else
			to_chat(user, span_warning("Обшивке нужна подпорка для удержания её на месте."))

/turf/open/openspace/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!CanBuildHere())
		return FALSE

	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 1)
			else
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 3)
	return FALSE

/turf/open/openspace/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span_notice("Строю пол."))
			PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
	return FALSE

/turf/open/openspace/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id)
	if(caller && !caller.can_z_move(DOWN, src, null , ZMOVE_FALL_FLAGS)) //If we can't fall here (flying/lattice), it's fine to path through
		return TRUE
	return FALSE

/turf/open/openspace/icemoon
	name = "ice chasm"
	baseturfs = /turf/open/openspace/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	planetary_atmos = TRUE
	var/replacement_turf = /turf/open/floor/plating/asteroid/snow/icemoon

/turf/open/openspace/icemoon/Initialize(mapload)
	. = ..()
	var/turf/T = below()
	if(T.turf_flags & NO_RUINS)
		ChangeTurf(replacement_turf, null, CHANGETURF_IGNORE_AIR)
		return
	if(!ismineralturf(T))
		return
	var/turf/closed/mineral/M = T
	M.mineralAmt = 0
	M.gets_drilled()
	baseturfs = /turf/open/openspace/icemoon //This is to ensure that IF random turf generation produces a openturf, there won't be other turfs assigned other than openspace.
