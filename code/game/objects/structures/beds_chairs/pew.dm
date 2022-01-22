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

/obj/structure/chair/pew/Initialize()
	. = ..()
	if(density && flags_1 & ON_BORDER_1) // blocks normal movement from and to the direction it's facing.
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = .proc/on_exit,
		)
		AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/chair/pew/left
	name = "левый край деревянной скамьи"
	icon_state = "pewend_left"
	var/mutable_appearance/leftpewarmrest

/obj/structure/chair/pew/left/Initialize()
	leftpewarmrest = GetLeftPewArmrest()
	leftpewarmrest.layer = ABOVE_MOB_LAYER
	leftpewarmrest.plane = ABOVE_GAME_PLANE
	return ..()

/obj/structure/chair/pew/left/proc/GetLeftPewArmrest()
	return mutable_appearance('icons/obj/sofa.dmi', "pewend_left_armrest", plane = ABOVE_GAME_PLANE)

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

/obj/structure/chair/pew/right/Initialize()
	rightpewarmrest = GetRightPewArmrest()
	rightpewarmrest.layer = ABOVE_MOB_LAYER
	rightpewarmrest.plane = ABOVE_GAME_PLANE
	return ..()

/obj/structure/chair/pew/right/proc/GetRightPewArmrest()
	return mutable_appearance('icons/obj/sofa.dmi', "pewend_right_armrest", plane = ABOVE_GAME_PLANE)

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
	if(border_dir & invertDir(dir))
		return . || mover.throwing || mover.movement_type & (FLYING | FLOATING)
	return TRUE

/obj/structure/chair/pew/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return // Let's not block ourselves.

	if(!(direction & invertDir(dir)))
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
