/obj/structure/railing
	name = "перила"
	desc = "Простые перила, предназначенные для защиты таких идиотов, как вы, от падения."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "railing"
	layer = ABOVE_MOB_LAYER
	flags_1 = ON_BORDER_1
	density = TRUE
	anchored = TRUE
	pass_flags_self = LETPASSTHROW|PASSSTRUCTURE
	/// armor more or less consistent with grille. max_integrity about one time and a half that of a grille.
	armor = list(MELEE = 50, BULLET = 70, LASER = 70, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 0, ACID = 0)
	max_integrity = 75

	var/climbable = TRUE
	///Initial direction of the railing.
	var/ini_dir

/obj/structure/railing/right
	icon_state = "railing_R"

/obj/structure/railing/left
	icon_state = "railing_L"

/obj/structure/railing/corner //aesthetic corner sharp edges hurt oof ouch
	icon_state = "railing_corner"
	density = FALSE
	climbable = FALSE

/obj/structure/railing/Initialize(mapload)
	. = ..()
	ini_dir = dir
	if(climbable)
		AddElement(/datum/element/climbable)

	if(density && flags_1 & ON_BORDER_1) // blocks normal movement from and to the direction it's facing.
		var/static/list/loc_connections = list(
			COMSIG_ATOM_EXIT = PROC_REF(on_exit),
		)
		AddComponent(/datum/component/connect_loc_behalf, src, loc_connections)

	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS ,null,CALLBACK(src, PROC_REF(can_be_rotated)),CALLBACK(src, PROC_REF(after_rotation)))

/obj/structure/railing/attackby(obj/item/I, mob/living/user, params)
	..()
	add_fingerprint(user)

	if(I.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, span_notice("Начинаю чинить [src]..."))
			if(I.use_tool(src, user, 40, volume=50))
				obj_integrity = max_integrity
				to_chat(user, span_notice("Чиню [src]."))
		else
			to_chat(user, span_warning("[src] и так в хорошем состоянии!"))
		return

/obj/structure/railing/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(!anchored)
		to_chat(user, span_warning("Разрезаю перила."))
		I.play_tool_sound(src, 100)
		deconstruct()
		return TRUE

/obj/structure/railing/deconstruct(disassembled)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/item/stack/rods/rod = new /obj/item/stack/rods(drop_location(), 3)
		transfer_fingerprints_to(rod)
	return ..()

///Implements behaviour that makes it possible to unanchor the railing.
/obj/structure/railing/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(flags_1&NODECONSTRUCT_1)
		return
	to_chat(user, span_notice("Начинаю [anchored ? "откреплять перила":"прикреплять перила"]..."))
	if(I.use_tool(src, user, volume = 75, extra_checks = CALLBACK(src, PROC_REF(check_anchored), anchored)))
		set_anchored(!anchored)
		to_chat(user, span_notice("[anchored ? "Прикручиваю перила к полу":"Откручиваю перила от пола"]."))
	return TRUE

/obj/structure/railing/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(border_dir & dir)
		return . || mover.throwing || mover.movement_type & (FLYING | FLOATING)
	return TRUE

/obj/structure/railing/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller, no_id = FALSE)
	if(!(to_dir & dir))
		return TRUE
	return ..()

/obj/structure/railing/corner/CanPass()
	..()
	return TRUE

/obj/structure/railing/proc/on_exit(datum/source, atom/movable/leaving, direction)
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

/obj/structure/railing/proc/can_be_rotated(mob/user,rotation_type)
	if(anchored)
		to_chat(user, span_warning("[src] нельзя поворачивать, пока он закреплен к полу!"))
		return FALSE

	var/target_dir = turn(dir, rotation_type == ROTATION_CLOCKWISE ? -90 : 90)

	if(!valid_window_location(loc, target_dir, is_fulltile = FALSE)) //Expanded to include rails, as well!
		to_chat(user, span_warning("[src] не может повернуться в этом направлении!"))
		return FALSE
	return TRUE

/obj/structure/railing/proc/check_anchored(checked_anchored)
	if(anchored == checked_anchored)
		return TRUE

/obj/structure/railing/proc/after_rotation(mob/user,rotation_type)
	add_fingerprint(user)
