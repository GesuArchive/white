/turf/open/floor/partyhard
	name = "пол"
	icon = 'white/valtos/icons/turfs.dmi'
	baseturfs = /turf/open/openspace
	icon_state = "b-1"
	floor_tile = null

/turf/open/floor/partyhard/steel
	icon_state = "g-4"
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/partyhard/wood
	icon_state = "w-1"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/partyhard/break_tile()
	return //unbreakable

/turf/open/floor/partyhard/burn_tile()
	return //unburnable

/turf/open/floor/partyhard/make_plating(force = 0)
	if(force)
		..()
	return //unplateable

/turf/open/floor/partyhard/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/partyhard/crowbar_act(mob/living/user, obj/item/I)
	return

/turf/closed/wall/partyhard
	name = "стена"
	desc = "Очень крепкая."
	icon = 'white/valtos/icons/walls.dmi'
	smoothing_flags = SMOOTH_CORNERS
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/turf/closed/wall/r_wall/partyhard
	name = "durable reinforced wall"
	desc = "A huge chunk of durable reinforced metal."
	icon = 'white/valtos/icons/r_walls.dmi'
	smoothing_flags = SMOOTH_CORNERS
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/obj/structure/window/reinforced/fulltile/partyhard
	icon = 'white/valtos/icons/windows.dmi'
	icon_state = "windows-0"
	base_icon_state = "windows"
	max_integrity = 200
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/obj/effect/spawner/structure/window/reinforced/partyhard
	icon = 'icons/obj/smooth_structures/pod_window.dmi'
	icon_state = "smooth"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/fulltile/partyhard)

/turf/closed/mineral/partyhard
	name = "камень"
	icon = 'icons/turf/mining.dmi'
	smooth_icon = 'icons/turf/walls/rock_wall.dmi'
	icon_state = "rock2"
	base_icon_state = "rock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS)
	baseturfs = /turf/open/floor/plating/ashplanet/rocky
	environment_type = "waste"
	turf_type = /turf/open/floor/plating/ashplanet/rocky
	defer_change = 1

/turf/closed/indestructible/black
	name = "пустота"
	icon = 'white/valtos/icons/area.dmi'
	icon_state = "black"
	layer = FLY_LAYER
	bullet_bounce_sound = null
	baseturfs = /turf/closed/indestructible/black

/turf/closed/indestructible/black/New()
	return

/area/partyhard
	icon = 'white/valtos/icons/area.dmi'
	icon_state = "1f"
	name = "partyhard"
	has_gravity = STANDARD_GRAVITY

/area/partyhard/outdoors
	icon_state = "1f"
	name = "пустоши"
	static_lighting = TRUE
	always_unpowered = TRUE
//	//poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	outdoors = TRUE
	base_lighting_color = "#ffd1b3"
	base_lighting_alpha = 55
	luminosity = 1
	sound_environment = SOUND_ENVIRONMENT_PLAIN
	ambience_index = AMBIENCE_NONE
	ambientsounds = CITY_SOUNDS
	map_generator = /datum/map_generator/forest_generator
	env_temp_relative = -5

/area/partyhard/outdoors/Entered(atom/movable/AM)
	. = ..()
	if(ismob(AM))
		var/mob/M = AM
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.GetComponent(/datum/component/realtemp))
				H.AddComponent(/datum/component/realtemp)

/area/partyhard/indoors
	icon_state = "5f"
	name = "помещения"
	always_unpowered = FALSE
	requires_power = FALSE
	static_lighting = TRUE
	outdoors = FALSE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	ambience_index = AMBIENCE_NONE
	base_lighting_color = "#ffd1b3"
	base_lighting_alpha = 3

/area/partyhard/outdoors/unexplored
	icon_state = "2f"
	name = "far away"
	always_unpowered = TRUE
///	//poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambientsounds = MINING
	outdoors = TRUE

/area/partyhard/odin
	icon_state = "1f"
	name = "1st floor"

/area/partyhard/dva
	icon_state = "2f"
	name = "2nd floor"

/area/partyhard/tri
	icon_state = "3f"
	name = "3rd floor"

/area/partyhard/chetyre
	icon_state = "4f"
	name = "4th floor"

/area/partyhard/pyat
	icon_state = "5f"
	name = "5th floor"

/area/partyhard/surface
	icon_state = "4f"
	name = "surface"
	always_unpowered = TRUE
	//poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambientsounds = RUINS
	outdoors = TRUE
	static_lighting = TRUE

/area/shuttle/partyhard
	name = "Station Elevator"

/obj/machinery/computer/shuttle_flight/partyhard
	name = "elevator console"
	desc = "A elevator control computer."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	shuttleId = "partyhard_elevator"
	possible_destinations = "ph_station_bottom;ph_station_top"

/obj/effect/turf_decal/partyhard/lines
	icon = 'white/valtos/icons/decals.dmi'
	icon_state = "s-1"

/turf/open/floor/plating/partyhard
	name = "пепел"
	icon = 'icons/turf/mining.dmi'
	gender = PLURAL
	icon_state = "ash"
	base_icon_state = "ash"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	var/smooth_icon = 'icons/turf/floors/ash.dmi'
	desc = "Земля покрыта вулканическим пеплом."
	baseturfs = /turf/open/floor/plating/partyhard
	//initial_gas_mix = KITCHEN_COLDROOM_ATMOS
	planetary_atmos = TRUE
	attachment_holes = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/plating/partyhard/Initialize()
	. = ..()
	if(smoothing_flags & SMOOTH_BITMASK)
		var/matrix/M = new
		M.Translate(-4, -4)
		transform = M
		icon = smooth_icon
		icon_state = "[icon_state]-[smoothing_junction]"


/obj/structure/pillar
	name = "pillar"
	desc = "Заборчик. Круто."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "b-1"
	density = TRUE
	layer = BYOND_LIGHTING_LAYER
	plane = BYOND_LIGHTING_PLANE
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = TRUE
	flags_1 = ON_BORDER_1
	max_integrity = 250
	can_be_unanchored = FALSE
	resistance_flags = ACID_PROOF
	armor = list("melee" = 90, "bullet" = 90, "laser" = 100, "energy" = 100, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 100)
	CanAtmosPass = ATMOS_PASS_YES
	rad_insulation = RAD_NO_INSULATION
	var/real_explosion_block	//ignore this, just use explosion_block

/obj/structure/pillar/Initialize()
	. = ..()
	if(density && flags_1 & ON_BORDER_1) // blocks normal movement from and to the direction it's facing.
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = .proc/on_exit,
		)
		AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/pillar/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if(!(direction & dir))
		return

	if (!density)
		return

	if (leaving.throwing)
		return

	if (leaving.movement_type & (PHASING | FLYING | FLOATING))
		return

	if (leaving.move_force >= MOVE_FORCE_EXTREMELY_STRONG)
		return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/pillar/CanAtmosPass(turf/T)
	return TRUE

/********************** New mining areas **************************/

/area/thetaMining
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

/area/thetaMining/surface
	name = "Mining Theta"
	icon_state = "purple"
	always_unpowered = TRUE
	//poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = TRUE
	requires_power = TRUE
	ambientsounds = MINING
	static_lighting = TRUE
	outdoors = TRUE

/area/thetaMining/underground
	name = "Caves"
	icon_state = "red"
	always_unpowered = TRUE
	requires_power = TRUE
	//poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = MINING
	static_lighting = FALSE
