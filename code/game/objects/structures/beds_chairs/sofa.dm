/obj/structure/chair/sofa
	name = "старый диван"
	icon_state = "sofamiddle"
	icon = 'icons/obj/sofa.dmi'
	buildstackamount = 1
	item_chair = null
	color = rgb(141,70,0)
	var/mutable_appearance/armrest

/obj/structure/chair/sofa/Initialize(mapload)
	. = ..()
	armrest = mutable_appearance(icon, "[icon_state]_armrest", ABOVE_MOB_LAYER)
	armrest.plane = GAME_PLANE_UPPER
	AddElement(/datum/element/soft_landing)

/obj/structure/chair/sofa/electrify_self(obj/item/assembly/shock_kit/input_shock_kit, mob/user, list/overlays_from_child_procs)
	if(!overlays_from_child_procs)
		overlays_from_child_procs = list(image('icons/obj/chairs.dmi', loc, "echair_over", pixel_x = -1))
	. = ..()

/obj/structure/chair/sofa/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()

/obj/structure/chair/sofa/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/chair/sofa/post_unbuckle_mob()
	. = ..()
	update_armrest()

/obj/structure/chair/sofa/corner/handle_layer() //only the armrest/back of this chair should cover the mob.
	return

/obj/structure/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/chair/sofa/corner
	icon_state = "sofacorner"

// Original icon ported from Eris(?) and updated to work here.
/obj/structure/chair/sofa/corp
	name = "диван"
	desc = "Мягкий и удобный."
	color = null
	icon_state = "corp_sofamiddle"

/obj/structure/chair/sofa/corp/left
	icon_state = "corp_sofaend_left"

/obj/structure/chair/sofa/corp/right
	icon_state = "corp_sofaend_right"

/obj/structure/chair/sofa/corp/corner
	icon_state = "corp_sofacorner"


// Benches
/obj/structure/chair/sofa/bench
	name = "скамейка"
	desc = "Идеальная конструкция, на которой удобно сидеть и чертовски неудобно спать."
	color = null
	icon_state = "bench_middle"
	greyscale_config = /datum/greyscale_config/bench_middle
	greyscale_colors = "#00B7EF"

/obj/structure/chair/sofa/bench/left
	icon_state = "bench_left"
	greyscale_config = /datum/greyscale_config/bench_left
	greyscale_colors = "#00B7EF"

/obj/structure/chair/sofa/bench/right
	icon_state = "bench_right"
	greyscale_config = /datum/greyscale_config/bench_right
	greyscale_colors = "#00B7EF"

/obj/structure/chair/sofa/bench/corner
	icon_state = "bench_corner"
	greyscale_config = /datum/greyscale_config/bench_corner
	greyscale_colors = "#00B7EF"

// Bamboo benches
/obj/structure/chair/sofa/bamboo
	name = "бамбуковая скамья"
	desc = "Самодельная, хы."
	color = null
	icon_state = "bamboo_sofamiddle"
	resistance_flags = FLAMMABLE
	max_integrity = 60
	buildstacktype = /obj/item/stack/sheet/mineral/bamboo
	buildstackamount = 3

/obj/structure/chair/sofa/bamboo/left
	icon_state = "bamboo_sofaend_left"

/obj/structure/chair/sofa/bamboo/right
	icon_state = "bamboo_sofaend_right"

/obj/structure/chair/iron_bench
	name = "скамейка"
	desc = "На этом можно сидеть, но не долго."
	icon = 'icons/obj/sofa.dmi'
	max_integrity = 250
	integrity_failure = 0.1
	icon_state = "iron_bench_center"

/obj/structure/chair/iron_bench/left
	icon_state = "iron_bench_left"

/obj/structure/chair/iron_bench/right
	icon_state = "iron_bench_right"
