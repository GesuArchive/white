/obj/structure/fleshbuilding
	name = "абстрактная мясная постройка, которая ничего не делает потому что ее не должно существовать"
	desc = "да."
	icon_state = "clownbuilder"
	icon = 'icons/obj/device.dmi'
	var/cost = 0
	max_integrity = 200
	anchored = TRUE

/obj/structure/fleshbuilding/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			if(damage_amount)
				playsound(loc, 'sound/items/welder.ogg', 100, TRUE)


/obj/structure/fleshbuilding/clownatmos
	name = "Дышалка"
	desc = "Легкие планеты клоунов. Ничего не вдыхают и создают веселящий газ из пустоты."
	icon_state = "clownatmos"
	cost = 120
	icon = 'icons/obj/device.dmi'
	resistance_flags = ACID_PROOF|FIRE_PROOF
	var/spawn_temp = T20C
	var/spawn_id = GAS_N2O
	var/spawn_mol = MOLES_CELLSTANDARD * 0.005

/obj/structure/fleshbuilding/clownatmos/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/fleshbuilding/clownatmos/process()
	var/turf/open/O = get_turf(src)
	if(!isopenturf(O))
		return FALSE
	var/datum/gas_mixture/merger = new
	merger.set_moles(spawn_id, spawn_mol)
	merger.set_temperature(spawn_temp)
	O.assume_air(merger)
	O.air_update_turf(TRUE)





// Кожистый пол
#define NODERANGE 6
/obj/structure/fleshbuilding/clownweeds
	gender = PLURAL
	name = "кожистый пол"
	desc = "Толстый слой кожи и мяса, покрывающий пол."
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

/obj/structure/fleshbuilding/clownweeds/Initialize(mapload)
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
/obj/structure/fleshbuilding/clownweeds/proc/set_base_icon()
	. = base_icon_state
	icon = 'icons/obj/smooth_structures/alien/clownweeds1.dmi'
	base_icon_state = "weeds1"
	set_smoothed_icon_state(smoothing_junction)


/obj/structure/fleshbuilding/clownweeds/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/atmos_sensitive)

/obj/structure/fleshbuilding/clownweeds/proc/expand()
	var/turf/U = get_turf(src)
	if(is_type_in_typecache(U, blacklisted_turfs))
		qdel(src)
		return FALSE
	for(var/turf/T in U.get_atmos_adjacent_turfs())
		if(locate(/obj/structure/fleshbuilding/clownweeds/) in T)
			continue

		if(is_type_in_typecache(T, blacklisted_turfs))
			continue

		new /obj/structure/fleshbuilding/clownweeds/(T)
		for (var/turf/V in range(1,T))
			if(istype(V, /turf/closed/wall))
				V.ChangeTurf(/turf/closed/wall/clown)
				if(prob(1))
					new /obj/structure/spawner/clown/clownworm(V)

	return TRUE

/obj/structure/fleshbuilding/clownweeds/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 300

/obj/structure/fleshbuilding/clownweeds/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(5, BURN, 0, 0)

//Weed nodes
/obj/structure/fleshbuilding/clownweeds/node
	name = "рассадник кожи"
	desc = "На этом участке кожи много странных розовых прыщей."
	icon = 'icons/obj/smooth_structures/alien/clownnode.dmi'
	icon_state = "weednode-0"
	base_icon_state = "weednode"
	var/lon_range = 4
	var/node_range = NODERANGE


/obj/structure/fleshbuilding/clownweeds/node/Initialize(mapload)
	. = ..()
	var/obj/structure/fleshbuilding/clownweeds/W = locate(/obj/structure/fleshbuilding/clownweeds/) in loc
	if(W && W != src)
		qdel(W)
	START_PROCESSING(SSobj, src)


/obj/structure/fleshbuilding/clownweeds/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/structure/fleshbuilding/clownweeds/node/process()
	for(var/obj/structure/fleshbuilding/clownweeds/W in range(node_range, src))
		if(W.last_expand <= world.time)
			if(W.expand())
				W.last_expand = world.time + rand(growth_cooldown_low, growth_cooldown_high)


/obj/structure/fleshbuilding/clownweeds/node/set_base_icon()
	return //No icon randomization at init. The node's icon is already well defined.



/turf/closed/wall/clown
	name = "Кожистая стена"
	desc = "Эта стена покрыта кожей."
	icon = 'icons/obj/smooth_structures/alien/clownwall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	smoothing_groups = list(SMOOTH_GROUP_ALIEN_RESIN, SMOOTH_GROUP_ALIEN_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ALIEN_WALLS)
	girder_type = null
	sheet_type = /mob/living/simple_animal/hostile/clown/worm
	var/cost = 50






/obj/structure/spawner/clown
	name = "спавнер клоунов"
	desc = "такого не бывает."
	icon_state = "mindflash"
	icon = 'icons/obj/device.dmi'
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	density = TRUE
	max_integrity = 2777
	max_mobs = 3777
	spawn_time = 3007
	mob_types = list(/mob/living/simple_animal/hostile/clown, /mob/living/simple_animal/hostile/clown/longface, /mob/living/simple_animal/hostile/clown/honkling, /mob/living/simple_animal/hostile/clown/lube)
	spawn_text = "вылезает из"
	faction = list("clown")
	spawner_type = /datum/component/spawner
	var/cost = 0

/obj/structure/spawner/clown/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			if(damage_amount)
				playsound(loc, 'sound/items/welder.ogg', 100, TRUE)


/obj/structure/spawner/clown/clownsmall
	name = "клоунская дыра"
	desc = "Отсюда выползают клоуны."
	icon_state = "hole"
	icon = 'icons/mob/nest.dmi'
	max_integrity = 200
	max_mobs = 6
	spawn_time = 100
	mob_types = list(/mob/living/simple_animal/hostile/clown, /mob/living/simple_animal/hostile/clown/longface, /mob/living/simple_animal/hostile/clown/honkling, /mob/living/simple_animal/hostile/clown/lube)
	spawn_text = "вылезает из"
	faction = list("clown")
	cost = 100
	layer = MID_TURF_LAYER
	density = FALSE

/obj/structure/spawner/clown/clownbuilder
	name = "пульсирующее яйцо"
	desc = "Здесь вызревают умнейшие клоуны."
	icon_state = "clownbuilder"
	icon = 'icons/obj/device.dmi'
	max_integrity = 400
	max_mobs = 3
	spawn_time = 600
	mob_types = list(/mob/living/simple_animal/hostile/clown/fleshclown)
	spawn_text = "вылупляется из"
	faction = list("clown")
	cost = 200


/obj/structure/spawner/clown/clownspider
	name = "паучье нечто"
	desc = "Это... что-то... Каким-то образом производит клоунов-пауков."
	icon_state = "clownspider"
	icon = 'icons/obj/device.dmi'
	max_integrity = 600
	max_mobs = 2
	spawn_time = 800
	mob_types = list(/mob/living/simple_animal/hostile/clown/infestor)
	spawn_text = "жутким образом появляется из"
	faction = list("clown")
	cost = 300

/obj/structure/spawner/clown/clownana
	name = "гора бананов"
	desc = "Гора бананов. Приятно пахнет бананами."
	icon_state = "clownana"
	icon = 'icons/obj/device.dmi'
	max_integrity = 500
	max_mobs = 2
	spawn_time = 600
	mob_types = list(/mob/living/simple_animal/hostile/clown/banana)
	spawn_text = "вырастает из"
	faction = list("clown")
	cost = 250

/obj/structure/spawner/clown/clownworm
	name = "червивая стена"
	desc = "Эта не стена, а уютный дом для сотен клоунов-червей."
	icon_state = "clownworm"
	icon = 'icons/obj/device.dmi'
	max_integrity = 500
	max_mobs = 2
	spawn_time = 100
	mob_types = list(/mob/living/simple_animal/hostile/clown/worm)
	spawn_text = "выползает из"
	faction = list("clown")

/obj/structure/spawner/clown/clowncorpse
	name = "червивый труп"
	desc = "Под толстым слоем кожи в этом теле виднеется неприятное копошение."
	icon_state = "clowncorpse"
	icon = 'icons/obj/device.dmi'
	max_integrity = 150
	max_mobs = 2
	spawn_time = 100
	mob_types = list(/mob/living/simple_animal/hostile/clown/worm)
	spawn_text = "выползает из"
	faction = list("clown")
	density = FALSE

/obj/structure/spawner/clown/clownbig
	name = "смешной портал"
	desc = "Портал для прохода элитных клоунов в наш мир."
	icon_state = "clownbig"
	icon = 'icons/obj/device.dmi'
	max_integrity = 800
	max_mobs = 2
	spawn_time = 1000
	mob_types = list(/mob/living/simple_animal/hostile/clown/clownhulk, /mob/living/simple_animal/hostile/clown/clownhulk/chlown, /mob/living/simple_animal/hostile/clown/clownhulk/honcmunculus)
	spawn_text = "выходит из"
	faction = list("clown")
	cost = 400
