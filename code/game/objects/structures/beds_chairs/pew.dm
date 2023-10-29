/obj/structure/chair/pew
	name = "деревянная скамья"
	desc = "На колени и молись."
	icon = 'icons/obj/sofa.dmi'
	icon_state = "pewmiddle"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 3
	item_chair = null
	layer = ABOVE_MOB_LAYER
	flags_1 = ON_BORDER_1
	density = TRUE

/obj/structure/chair/pew/Initialize(mapload)
	. = ..()
	if(density && flags_1 & ON_BORDER_1) // blocks normal movement from and to the direction it's facing.
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = PROC_REF(on_exit),
		)
		AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/chair/pew/left
	name = "левый край деревянной скамьи"
	icon_state = "pewend_left"
	var/mutable_appearance/leftpewarmrest

/obj/structure/chair/pew/left/Initialize(mapload)
	gen_armrest()
	return ..()

/obj/structure/chair/pew/left/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	if(same_z_layer)
		return ..()
	cut_overlay(leftpewarmrest)
	QDEL_NULL(leftpewarmrest)
	gen_armrest()
	return ..()

/obj/structure/chair/pew/left/proc/gen_armrest()
	leftpewarmrest = GetLeftPewArmrest()
	leftpewarmrest.layer = ABOVE_MOB_LAYER
	SET_PLANE_EXPLICIT(leftpewarmrest, GAME_PLANE_UPPER, src)
	update_leftpewarmrest()


/obj/structure/chair/pew/left/proc/GetLeftPewArmrest()
	return mutable_appearance('icons/obj/sofa.dmi', "pewend_left_armrest")

/obj/structure/chair/pew/left/Destroy()
	QDEL_NULL(leftpewarmrest)
	return ..()

/obj/structure/chair/pew/left/post_buckle_mob(mob/living/M)
	. = ..()
	update_leftpewarmrest()

/obj/structure/chair/pew/left/proc/update_leftpewarmrest()
	if(has_buckled_mobs())
		add_overlay(leftpewarmrest)
	else
		cut_overlay(leftpewarmrest)

/obj/structure/chair/pew/left/post_unbuckle_mob()
	. = ..()
	update_leftpewarmrest()

/obj/structure/chair/pew/right
	name = "правый край деревянной скамьи"
	icon_state = "pewend_right"
	var/mutable_appearance/rightpewarmrest

/obj/structure/chair/pew/right/Initialize(mapload)
	gen_armrest()
	return ..()

/obj/structure/chair/pew/right/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	cut_overlay(rightpewarmrest)
	QDEL_NULL(rightpewarmrest)
	gen_armrest()
	return ..()

/obj/structure/chair/pew/right/proc/gen_armrest()
	rightpewarmrest = GetRightPewArmrest()
	rightpewarmrest.layer = ABOVE_MOB_LAYER
	SET_PLANE_EXPLICIT(rightpewarmrest, GAME_PLANE_UPPER, src)
	update_rightpewarmrest()

/obj/structure/chair/pew/right/proc/GetRightPewArmrest()
	return mutable_appearance('icons/obj/sofa.dmi', "pewend_right_armrest")

/obj/structure/chair/pew/right/Destroy()
	QDEL_NULL(rightpewarmrest)
	return ..()

/obj/structure/chair/pew/right/post_buckle_mob(mob/living/M)
	. = ..()
	update_rightpewarmrest()

/obj/structure/chair/pew/right/proc/update_rightpewarmrest()
	if(has_buckled_mobs())
		add_overlay(rightpewarmrest)
	else
		cut_overlay(rightpewarmrest)

/obj/structure/chair/pew/right/post_unbuckle_mob()
	. = ..()
	update_rightpewarmrest()

/obj/structure/chair/pew/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(border_dir & REVERSE_DIR(dir))
		return . || mover.throwing || mover.movement_type & (FLYING | FLOATING)
	return TRUE

/obj/structure/chair/pew/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if(!(direction & REVERSE_DIR(dir)))
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
