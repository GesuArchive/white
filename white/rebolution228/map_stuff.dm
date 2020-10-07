
/* AREAS */

//Main
/area/awaymission/chilly
	name = "Surface"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "coutdoor"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	requires_power = TRUE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	poweralm = FALSE
	ambientsounds = list('sound/ambience/ambimine.ogg')


//Facilities
/area/awaymission/chilly/facility
	name = "Base I"
	icon_state = "base"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe1.ogg')

/area/awaymission/chilly/facility/croom
	name = "Base I Underground Control Room"
	icon_state = "base_eng"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	always_unpowered = FALSE

/area/awaymission/chilly/facility2
	name = "Base II"
	icon_state = "base2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = TRUE

/area/awaymission/chilly/facility3
	name = "Base III"
	icon_state = "base3"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe2.ogg')

/area/awaymission/chilly/facility4
	name = "Base IV House"
	icon_state = "base4"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambiruin4.ogg')

/area/awaymission/chilly/facility5
	name = "Base V"
	icon_state = "base5"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambitech.ogg')


//Underground something
/area/awaymission/chilly/cave
	name = "Underground Train Tracks"
	icon_state = "caverns"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	always_unpowered = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')

/area/awaymission/chilly/syndietrain
	name = "Syndicate Cargo Train"
	icon_state = "syndie_train"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = FALSE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = FALSE

/area/awaymission/chilly/ntcargotrain
	name = "NanoTrasen Cargo Train Wreckage"
	icon_state = "nt_train"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	requires_power = TRUE
	ambientsounds = list('sound/ambience/ambireebe3.ogg')
	always_unpowered = TRUE



//Misc
/area/awaymission/chilly/mountain
	name = "Mountain"
	icon_state = "mountain"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	always_unpowered = TRUE

/area/awaymission/chilly/gatewaystart
	name = "Gateway Entrance"
	icon_state = "gateways"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	always_unpowered = FALSE
	ambientsounds = list('sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg')

/* TURFS */


/turf/open/floor/plasteel/stairs/old/chilly
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs"

/turf/open/floor/plasteel/stairs/old/chilly/right
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs_right"

/turf/open/floor/plasteel/stairs/old/chilly/left
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs_left"

/turf/open/floor/plasteel/stairs/old/chilly/single
	name = "stairs"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "stairs_single"

/* MISC */


/obj/effect/turf_decal/weather/side
	name = "side"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "side"
	mouse_opacity = 0

/obj/effect/turf_decal/weather/side/corner
	icon_state = "sidecorn"

/obj/effect/turf_decal/dust
	name = "dust"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "dirty"
	mouse_opacity = 0

/turf/open/floor/grass/snow/safe/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/floor/plating/snowed/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/plating/asteroid/snow/ice/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/plating/snowed/smoothed/temperatre
	temperature = 255.37
	planetary_atmos = FALSE

/turf/open/floor/engine/hull/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	temperature = 255.37

/turf/open/floor/plating/ice/smooth/oxy
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE
	temperature = 250
	baseturfs = /turf/open/floor/grass/snow/safe/oxy

/turf/closed/mineral/snowmountain/cavern/oxy
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice/oxy
	environment_type = null
	turf_type = /turf/open/floor/plating/asteroid/snow/ice/oxy

/obj/machinery/porta_turret/armory/chilly
	name = "heavy laser turret"
	desc = "An energy blaster auto-turret."
	lethal_projectile = /obj/projectile/beam/laser/heavylaser
	turret_flags = TURRET_FLAG_SHOOT_ALL
	scan_range = 6
	armor = list(MELEE = 50, BULLET = 30, LASER = 30, ENERGY = 30, BOMB = 80, BIO = 0, RAD = 0, FIRE = 90, ACID = 90)

/obj/machinery/porta_turret/syndicate/shuttle/chilly
	shot_delay = 8
	armor = list(MELEE = 50, BULLET = 30, LASER = 30, ENERGY = 30, BOMB = 80, BIO = 0, RAD = 0, FIRE = 90, ACID = 90)

/obj/effect/mob_spawn/human/corpse/damaged/chilly
	burn_damage = 1000
	hairstyle = null
	facial_hairstyle = null
	husk = TRUE

/obj/structure/sign/warning/securearea/deck1
	name = "DECK I"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "deck1"

/obj/structure/sign/warning/securearea/ntsign
	name = "NanoTrasen sign"
	desc = "Logo of NanoTrasen megacorporation, signifying their property."
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "nt_sign"

/obj/machinery/doorpanel // just decor so it does nothing
	name = "screen"
	desc = "Some kind of machinery that opens some door."
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "screen"
	anchored = 1
	density = 0
	opacity = 0

/obj/machinery/doorpanel/broken
	desc = "Some kind of machinery that opens some door. Their screen appears to be broken."
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "screen_b"

/obj/machinery/doorpanel/attack_hand(mob/living/carbon/human/user)
    to_chat(user, "<span class='warning'>It has no power!</span>")

/obj/machinery/doorpanel/broken/attack_hand(mob/living/carbon/human/user)
    to_chat(user, "<span class='warning'>It's broken.</span>")

/obj/machinery/oldvents
	name = "ventilation"
	icon = 'white/rebolution228/map_sprites.dmi'
	icon_state = "vent1"
	anchored = 1
	density = 0
	opacity = 0

/obj/machinery/oldvents/variant1
	icon_state = "vent1_1"

/obj/machinery/oldvents/variant2
	icon_state = "vent1_2"

/obj/machinery/oldvents/variant3
	icon_state = "vent1_3"

/obj/machinery/oldvents/variant4
	icon_state = "vent1_4"

/obj/machinery/oldvents/scrubber
	name = "scrubber"
	icon_state = "vent2"

/*
	Changelog 02/10/2020
+This changelog
+Added road to Base I from Base III
+Mosin Nagant at Base III
+Old non-functional vents everywhere.
+Deck I sign in elevator
+Machinery (not working) in base's enter rooms
+Spades at camp III
=Gateway is now more colorful
=Base II Arsenal edited.
=Box with replacement bulbs at Base I is now full.
-Icemoon plating at house in Base III
-Removed snow rock from tracks
-Removed light emitters near shutters



	Changelog 07/10/2020
+Added hidden room with stuff at base IV
+Rusted platings at base I/II
+Forest is more dangerous
+Vehicle near house
=Base II is more abandoned.
=Equipment changes in Base II armory. Replaced military belt with security belt
=Added some stuff in da haus
-Removed one SMG from elevator


TODO:
1. papers
2. radiation
3. ice spiders somewhere, i still have no fucking clue where I can put these suckers, base II maybe?
*/