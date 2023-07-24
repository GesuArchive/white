/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"
	beauty = -50

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	mergeable_decal = FALSE
	beauty = -50

/obj/effect/decal/cleanable/ash/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/ash, 30)
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/effect/decal/cleanable/ash/crematorium
//crematoriums need their own ash cause default ash deletes itself if created in an obj
	turf_loc_check = FALSE

/obj/effect/decal/cleanable/ash/large
	name = "large pile of ashes"
	icon_state = "big_ash"
	beauty = -100

/obj/effect/decal/cleanable/ash/large/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/ash, 30) //double the amount of ash.

/obj/effect/decal/cleanable/glass
	name = "tiny shards"
	desc = "Back to sand."
	icon = 'icons/obj/shards.dmi'
	icon_state = "tiny"
	beauty = -100

/obj/effect/decal/cleanable/glass/Initialize(mapload)
	. = ..()
	setDir(pick(GLOB.cardinals))

/obj/effect/decal/cleanable/glass/ex_act()
	qdel(src)

/obj/effect/decal/cleanable/glass/plasma
	icon_state = "plasmatiny"

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "dirt"
	base_icon_state = "dirt"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLEANABLE_DIRT)
	canSmoothWith = list(SMOOTH_GROUP_CLEANABLE_DIRT, SMOOTH_GROUP_WALLS)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -75

/obj/effect/decal/cleanable/dirt/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(!T.tiled_dirt)
		icon_state = pick("dirt-flat-0","dirt-flat-1","dirt-flat-2","dirt-flat-3")
		smoothing_flags = NONE
	else
		QUEUE_SMOOTH(src)

/obj/effect/decal/cleanable/dirt/Destroy()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/decal/cleanable/dirt/dust
	name = "dust"
	desc = "A thin layer of dust coating the floor."

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	icon_state = "greenglow"
	light_power = 3
	light_range = 2
	light_color = LIGHT_COLOR_GREEN
	beauty = -300

/obj/effect/decal/cleanable/greenglow/ex_act()
	return

/obj/effect/decal/cleanable/greenglow/filled/Initialize(mapload)
	. = ..()
	reagents.add_reagent(pick(/datum/reagent/uranium, /datum/reagent/uranium/radium), 5)

/obj/effect/decal/cleanable/greenglow/ecto
	name = "ectoplasmic puddle"
	desc = "You know who to call."
	light_power = 2

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	gender = NEUTER
	layer = WALL_OBJ_LAYER
	plane = GAME_PLANE_UPPER
	icon_state = "cobweb1"
	resistance_flags = FLAMMABLE
	beauty = -100
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/cobweb/cobweb2
	icon_state = "cobweb2"

/obj/effect/decal/cleanable/molten_object
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	gender = NEUTER
	icon = 'icons/effects/effects.dmi'
	icon_state = "molten"
	mergeable_decal = FALSE
	beauty = -150
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/molten_object/large
	name = "big gooey grey mass"
	icon_state = "big_molten"
	beauty = -300

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	beauty = -150

/obj/effect/decal/cleanable/vomit/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isflyperson(H))
			playsound(get_turf(src), 'sound/items/drink.ogg', 50, TRUE) //slurp
			H.visible_message(span_alert("[H] extends a small proboscis into the vomit pool, sucking it with a slurping sound."))
			if(reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					if (istype(R, /datum/reagent/consumable))
						var/datum/reagent/consumable/nutri_check = R
						if(nutri_check.nutriment_factor >0)
							H.adjust_nutrition(nutri_check.nutriment_factor * nutri_check.volume)
							reagents.remove_reagent(nutri_check.type,nutri_check.volume)
			reagents.trans_to(H, reagents.total_volume, transfered_by = user)
			qdel(src)

/obj/effect/decal/cleanable/vomit/old
	name = "crusty dried vomit"
	desc = "You try not to look at the chunks, and fail."

/obj/effect/decal/cleanable/vomit/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	icon_state += "-old"
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 10)


/obj/effect/decal/cleanable/chem_pile
	name = "chemical pile"
	desc = "A pile of chemicals. You can't quite tell what's inside it."
	gender = NEUTER
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"

/obj/effect/decal/cleanable/shreds
	name = "shreds"
	desc = "The shredded remains of what appears to be clothing."
	icon_state = "shreds"
	gender = PLURAL
	mergeable_decal = FALSE

/obj/effect/decal/cleanable/shreds/ex_act(severity, target)
	if(severity >= EXPLODE_DEVASTATE) //so shreds created during an explosion aren't deleted by the explosion.
		qdel(src)

/obj/effect/decal/cleanable/shreds/Initialize(mapload, oldname)
	if(loc)
		pixel_x = rand(-10, 10)
		pixel_y = rand(-10, 10)
	if(!isnull(oldname))
		desc = "The sad remains of what used to be [oldname]"
	. = ..()

/obj/effect/decal/cleanable/glitter
	name = "generic glitter pile"
	desc = "The herpes of arts and crafts."
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "plasma_old"
	gender = NEUTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cleanable/glitter/pink
	name = "pink glitter"
	icon_state = "plasma"

/obj/effect/decal/cleanable/glitter/white
	name = "белый glitter"
	icon_state = "nitrous_oxide"

/obj/effect/decal/cleanable/glitter/blue
	name = "синий glitter"
	icon_state = "freon"

/obj/effect/decal/cleanable/plasma
	name = "stabilized plasma"
	desc = "A puddle of stabilized plasma."
	icon_state = "flour"
	icon = 'icons/effects/tomatodecal.dmi'
	color = "#2D2D2D"

/obj/effect/decal/cleanable/insectguts
	name = "insect guts"
	desc = "One bug squashed. Four more will rise in its place."
	icon = 'icons/effects/blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")

/obj/effect/decal/cleanable/confetti
	name = "confetti"
	desc = "Tiny bits of colored paper thrown about for the janitor to enjoy!"
	icon = 'icons/effects/confetti_and_decor.dmi'
	icon_state = "confetti"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //the confetti itself might be annoying enough

/obj/effect/decal/cleanable/plastic
	name = "plastic shreds"
	desc = "Bits of torn, broken, worthless plastic."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"
	color = "#c6f4ff"

/obj/effect/decal/cleanable/wrapping
	name = "куча бумаги"
	desc = "Куча бесполезных клочков бумаги. Кто-то намусорил!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "paper_shreds"

/obj/effect/decal/cleanable/garbage
	name = "разлагающийся мусор"
	desc = "Что-то гниющее лежит на полу. Из этой кучи что-то вытекает..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "garbage"
	layer = OBJ_LAYER //To display the decal over wires.
	beauty = -150
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/garbage/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 15)

/obj/effect/decal/cleanable/ants
	name = "космические муравьи"
	desc = "Небольшая колония космических муравьёв. Обычно они находятся в космосе без гравитации, поэтому не могут передвигаться далеко."
	icon = 'icons/obj/objects.dmi'
	icon_state = "spaceants"
	beauty = -150

/obj/effect/decal/cleanable/ants/Initialize(mapload)
	. = ..()
	var/scale = (rand(6, 8) / 10) + (rand(2, 5) / 50)
	transform = matrix(transform, scale, scale, MATRIX_SCALE)
	setDir(pick(GLOB.cardinals))
	reagents.add_reagent(/datum/reagent/ants, rand(2, 5))
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	var/memes = 1
	if(prob(1))
		name = "легендарные муравьи"
		desc = "Небольшая колония космических муравьёв. Эти похоже были созданы из пластитана?"
		memes = 25
	AddComponent(/datum/component/caltrop, min_damage = 0.2, max_damage = memes, flags = (CALTROP_NOCRAWL | CALTROP_NOSTUN | CALTROP_BYPASS_SHOES), soundfile = 'sound/weapons/bite.ogg')

/obj/effect/decal/cleanable/fuel_pool
	name = "топливная лужа"
	desc = "Горючая. Надо бы убрать это всё вот это..."
	icon_state = "fuel_pool"
	layer = LOW_OBJ_LAYER
	beauty = -50
	clean_type = CLEAN_TYPE_BLOOD
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	/// Maximum amount of hotspots this pool can create before deleting itself
	var/burn_amount = 3
	/// Is this fuel pool currently burning?
	var/burning = FALSE
	/// Type of hotspot fuel pool spawns upon being ignited
	var/hotspot_type = /obj/effect/hotspot

/obj/effect/decal/cleanable/fuel_pool/Initialize(mapload, burn_stacks)
	. = ..()
	for(var/obj/effect/decal/cleanable/fuel_pool/pool in get_turf(src)) //Can't use locate because we also belong to that turf
		if(pool == src)
			continue
		pool.burn_amount =  max(min(pool.burn_amount + burn_stacks, 10), 1)
		return INITIALIZE_HINT_QDEL

	if(burn_stacks)
		burn_amount = max(min(burn_stacks, 10), 1)

/obj/effect/decal/cleanable/fuel_pool/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	ignite()

/**
 * Ignites the fuel pool. This should be the only way to ignite fuel pools.
 */
/obj/effect/decal/cleanable/fuel_pool/proc/ignite()
	if(burning)
		return
	burning = TRUE
	burn_process()

/**
 * Spends 1 burn_amount and spawns a hotspot. If burn_amount is equal to 0, deletes the fuel pool.
 * Else, queues another call of this proc upon hotspot getting deleted and ignites other fuel pools around itself after 0.5 seconds.
 * THIS SHOULD NOT BE CALLED DIRECTLY.
 */
/obj/effect/decal/cleanable/fuel_pool/proc/burn_process()
	SIGNAL_HANDLER

	burn_amount -= 1
	var/obj/effect/hotspot/hotspot = new hotspot_type(get_turf(src))
	addtimer(CALLBACK(src, PROC_REF(ignite_others)), 0.5 SECONDS)

	if(!burn_amount)
		qdel(src)
		return

	RegisterSignal(hotspot, COMSIG_PARENT_QDELETING, PROC_REF(burn_process))

/**
 * Ignites other oil pools around itself.
 */
/obj/effect/decal/cleanable/fuel_pool/proc/ignite_others()
	for(var/obj/effect/decal/cleanable/fuel_pool/oil in range(1, get_turf(src)))
		oil.ignite()

/obj/effect/decal/cleanable/fuel_pool/bullet_act(obj/projectile/hit_proj)
	. = ..()
	ignite()

/obj/effect/decal/cleanable/fuel_pool/attackby(obj/item/item, mob/user, params)
	if(item.ignition_effect(src, user))
		ignite()
	return ..()
