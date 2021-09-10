GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)

/atom/movable/openspace_backdrop
	name			= "openspace_backdrop"

	anchored		= TRUE

	icon = 'icons/turf/floors.dmi'
	icon_state = "black"
	plane = OPENSPACE_BACKDROP_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_ID
	alpha = 160

/turf/open/openspace
	name = "открытое пространство"
	desc = "Смотри под ноги!"
	icon_state = "invisible"
	baseturfs = /turf/open/openspace
	CanAtmosPassVertical = ATMOS_PASS_YES
	baseturfs = /turf/open/openspace
	intact = FALSE //this means wires go on top
	//mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/can_cover_up = TRUE
	var/can_build_on = TRUE

/turf/open/openspace/airless/proc/update_starlight()
	if(CONFIG_GET(flag/starlight))
		for(var/t in RANGE_TURFS(1,src))
			if(isopenspace(t) || isspaceturf(t))
				continue
			set_light(2)
			return
		set_light(0)

/turf/open/openspace/airless
	initial_gas_mix = AIRLESS_ATMOS
	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/open/openspace/airless/GetHeatCapacity()
	. = 7000

/turf/open/openspace/airless/GetTemperature()
	. = 2.7

/turf/open/openspace/fastload
	plane = OPENSPACE_PLANE
	layer = OPENSPACE_LAYER

/turf/open/openspace/fastload/New()
	return

/turf/open/openspace/fastload/Initialize()
	air = new
	air.copy_from_turf(src)
	update_air_ref()
	var/turf/T = locate(x, y, z - 1)
	if(T)
		vis_contents += T
	flags_1 |= INITIALIZED_1
	directional_opacity = ALL_CARDINALS
	vis_contents += GLOB.openspace_backdrop_one_for_all
	return INITIALIZE_HINT_NORMAL

/turf/open/openspace/fastload/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/openspace/fastload/planetmos
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/openspace/fastload/LateInitialize()
	return

/turf/open/openspace/airless/planetary
	planetary_atmos = TRUE

/turf/open/openspace/Initialize() // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	vis_contents += GLOB.openspace_backdrop_one_for_all //Special grey square for projecting backdrop darkness filter on it.
	return INITIALIZE_HINT_LATELOAD

/turf/open/openspace/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, FALSE)

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
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/openspace/zPassOut(atom/movable/A, direction, turf/destination)
	if(A.anchored)
		return FALSE
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_UP)
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

/turf/open/openspace/icemoon
	name = "ice chasm"
	baseturfs = /turf/open/openspace/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	planetary_atmos = TRUE
	var/replacement_turf = /turf/open/floor/plating/asteroid/snow/icemoon

/turf/open/openspace/icemoon/Initialize()
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

/turf/open/openspace/fakez
	planetary_atmos = TRUE
	var/dir_to = SOUTH
	var/offset_to = 10

/turf/open/openspace/fakez/LateInitialize()
	switch(dir_to)
		if(WEST)
			below_override = locate(x - offset_to, y, z)
		if(EAST)
			below_override = locate(x + offset_to, y, z)
		if(NORTH)
			below_override = locate(x, y + offset_to, z)
		if(SOUTH)
			below_override = locate(x, y - offset_to, z)
	if(below_override)
		below_override.above_override = src
	. = ..()

/turf/open/openspace/fakez/west
	dir_to = WEST

/turf/open/openspace/fakez/east
	dir_to = EAST

/turf/open/openspace/fakez/north
	dir_to = NORTH

/turf/open/openspace/fakez/south
	dir_to = SOUTH
