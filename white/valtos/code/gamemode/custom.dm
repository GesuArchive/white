/turf/open/floor/partyhard
	name = "древний пол"
	icon = 'white/valtos/icons/turfs.dmi'
	baseturfs = /turf/open/openspace
	icon_state = "p-1"
	floor_tile = null

/turf/open/floor/resin
	name = "резиновый пол"
	desc = "Мягкий, но в то же время весьма крепкий."
	icon = 'white/valtos/icons/resin.dmi'
	icon_state = "resin-255"
	base_icon_state = "resin"
	floor_tile = /obj/item/stack/tile/resin
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_RESIN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_RESIN_FLOOR)
	flags_1 = NONE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/obj/item/stack/tile/resin
	name = "резиновый пол"
	singular_name = "резиновый пол"
	desc = "Мягкий, но в то же время весьма крепкий."
	icon_state = "tile_resin"
	inhand_icon_state = "tile-resin"
	turf_type = /turf/open/floor/resin
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/tile/resin

/turf/open/floor/resin/setup_broken_states()
	return list("damaged")

/turf/open/floor/resin/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Здесь есть <b>небольшая щель</b> с краю.</span>"

/turf/open/floor/resin/Initialize(mapload)
	. = ..()
	update_icon()

/turf/open/floor/resin/update_icon()
	. = ..()
	if(!.)
		return
	if(!broken && !burnt)
		if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
			QUEUE_SMOOTH(src)
	else
		make_plating()
		if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
			QUEUE_SMOOTH_NEIGHBORS(src)

/turf/open/floor/resin/crypto
	name = "криптопол"
	desc = "Очень странный пол."
	icon = 'white/valtos/icons/crypto.dmi'
	icon_state = "crypto-255"
	base_icon_state = "crypto"
	floor_tile = /obj/item/stack/tile/crypto
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CRYPTO_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_CRYPTO_FLOOR)
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/obj/item/stack/tile/crypto
	name = "криптопол"
	singular_name = "криптопол"
	desc = "Очень странный пол."
	icon_state = "tile_crypto"
	inhand_icon_state = "tile-crypto"
	turf_type = /turf/open/floor/resin/crypto
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/tile/crypto

/turf/open/floor/plasteel/durasteel
	name = "дюрасталевый пол"
	icon = 'white/valtos/icons/turfs.dmi'
	icon_state = "mm-1"
	base_icon_state = "mm"
	floor_tile = /obj/item/stack/tile/durasteel

/turf/open/floor/plasteel/durasteel/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[rand(1, 5)]"

/obj/item/stack/tile/durasteel
	name = "дюрасталевый пол"
	singular_name = "дюрасталевый пол"
	desc = "Крепкий пол."
	icon_state = "tile_durasteel"
	inhand_icon_state = "tile-durasteel"
	turf_type = /turf/open/floor/plasteel/durasteel
	merge_type = /obj/item/stack/tile/durasteel

/turf/open/floor/partyhard/steel
	icon_state = "p-1"
	base_icon_state = "p"
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	var/max_random_states = 4

/turf/open/floor/partyhard/steel/Initialize(mapload)
	. = ..()
	if(max_random_states)
		icon_state = "[base_icon_state]-[rand(1, max_random_states)]"

/turf/open/floor/partyhard/steel/cross
	icon_state = "x-1"
	base_icon_state = "x"

/turf/open/floor/partyhard/steel/vertical
	icon_state = "g-1"
	base_icon_state = "g"

/turf/open/floor/partyhard/steel/horizontal
	icon_state = "rg-1"
	base_icon_state = "rg"

/turf/open/floor/partyhard/steel/dotted
	icon_state = "d-1"
	base_icon_state = "d"

/turf/open/floor/partyhard/steel/reinforced // actually not
	icon_state = "r-1"
	base_icon_state = "r"

/turf/open/floor/partyhard/steel/shaped
	icon_state = "f-1"
	base_icon_state = "f"

/turf/open/floor/partyhard/steel/linear
	icon_state = "fl-1"
	max_random_states = 0

/turf/open/floor/partyhard/steel/strange
	icon_state = "st-4"
	max_random_states = 0

/turf/open/floor/partyhard/steel/strange/another
	icon_state = "st-5"

/turf/open/floor/partyhard/steel/strange/fucky
	icon_state = "st-6"

/turf/open/floor/partyhard/steel/strange/shitty
	icon_state = "st-7"

/turf/open/floor/partyhard/steel/strange/holy
	icon_state = "st-8"

/turf/open/floor/partyhard/steel/strange/cyber
	icon_state = "st-9"

/turf/open/floor/partyhard/steel/strange/cyber/some
	icon_state = "st-10"

/turf/open/floor/partyhard/steel/strange/cyber/fart
	icon_state = "st-11"

/turf/open/floor/partyhard/steel/strange/grid
	icon_state = "z-1"

/turf/open/floor/partyhard/steel/strange/grid/another
	icon_state = "z-2"

/turf/open/floor/partyhard/wood
	icon_state = "w-1"
	base_icon_state = "w"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/partyhard/wood/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state]-[rand(1, 3)]"

/turf/open/floor/partyhard/wood/long
	icon_state = "s-1"
	base_icon_state = "s"

/turf/open/floor/partyhard/wood_cross
	icon_state = "bw-1"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/partyhard/wood_cross/another
	icon_state = "aw-1"

/turf/open/floor/partyhard/stone
	icon_state = "st-1"

/turf/open/floor/partyhard/stone/mini
	icon_state = "st-2"

/turf/open/floor/partyhard/stone/normal
	icon_state = "st-12"

/turf/open/floor/partyhard/stone/tiled
	icon_state = "a-1"

/turf/open/floor/partyhard/stone/tiled/Initialize(mapload)
	. = ..()
	icon_state = "a-[rand(1, 3)]"

/turf/open/floor/partyhard/stone/big
	icon_state = "st-13"

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
	icon_state = "wall"
	smoothing_flags = SMOOTH_CORNERS
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/turf/closed/wall/r_wall/partyhard
	name = "армированная стена из дюрастали"
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
	icon_state = "pod_window-0"
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
	ambientsounds = RUINS

/area/partyhard/outdoors
	icon_state = "1f"
	name = "пустоши"
	static_lighting = TRUE
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	outdoors = TRUE
	base_lighting_color = "#ffd1b3"
	base_lighting_alpha = 0
	luminosity = 1
	sound_environment = SOUND_ENVIRONMENT_PLAIN
	env_temp_relative = -10

/area/partyhard/Entered(atom/movable/AM, oldloc)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
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
	base_lighting_color = "#ffd1b3"
	base_lighting_alpha = 3

/area/partyhard/outdoors/unexplored
	icon_state = "2f"
	name = "где-то далеко"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	base_lighting_alpha = 3
	requires_power = TRUE
	ambientsounds = MINING
	outdoors = TRUE

/area/partyhard/odin
	icon_state = "1f"
	name = "первый этаж"

/area/partyhard/dva
	icon_state = "2f"
	name = "второй этаж"

/area/partyhard/tri
	icon_state = "3f"
	name = "третий этаж"

/area/partyhard/chetyre
	icon_state = "4f"
	name = "четвёртый этаж"

/area/partyhard/pyat
	icon_state = "5f"
	name = "пятый этаж"

/area/partyhard/surface
	icon_state = "4f"
	name = "поверхность"
	base_icon_state = "snow_storm"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambientsounds = RUINS
	outdoors = TRUE
	base_lighting_alpha = 0
	static_lighting = TRUE
	env_temp_relative = -25
	luminosity = 1
	map_generator = /datum/map_generator/snowy_generator

/area/partyhard/surface/Initialize(mapload)
	. = ..()
	spawn(2 MINUTES)
		icon = 'white/valtos/icons/cliffs.dmi'
		icon_state = "snow_storm"
		layer = OPENSPACE_LAYER
		luminosity = 1

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

/turf/open/floor/plating/partyhard/Initialize(mapload)
	. = ..()
	if(smoothing_flags & SMOOTH_BITMASK)
		var/matrix/M = new
		M.Translate(-4, -4)
		transform = M
		icon = smooth_icon
		icon_state = "[icon_state]-[smoothing_junction]"

/********************** New mining areas **************************/

/area/thetaMining
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

/area/thetaMining/surface
	name = "Mining Theta"
	icon_state = "purple"
	always_unpowered = TRUE
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
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = MINING
	static_lighting = FALSE
