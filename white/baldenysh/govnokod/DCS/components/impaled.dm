/datum/component/impaled
	var/obj/impaled_by
	var/impaling_dir

/datum/component/impaled/Initialize(obj/imp_by, atom/imp_to)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	impaled_by = imp_by
	impaling_dir = get_dir(imp_to, parent)

/datum/component/impaled/RegisterWithParent()
	var/mob/living/carbon/C = parent
	C.Paralyze(10 SECONDS)
	var/obj/structure/wall_stuck_thing/ST = new(get_turf(C))
	ST.dir = impaling_dir
	if(impaling_dir & SOUTH)
		ST.layer = ABOVE_ALL_MOB_LAYER
	ST.name = impaled_by.name
	impaled_by.forceMove(ST)
	ST.impaler = impaled_by
	ST.buckle_mob(C, force=1)
	set_offsets(impaling_dir)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(on_unbuckle))

/datum/component/impaled/UnregisterFromParent()
	var/mob/living/carbon/C = parent
	C.base_pixel_x = initial(C.base_pixel_x)
	C.base_pixel_y = initial(C.base_pixel_y)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/impaled/proc/on_moved(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	if(oldloc == mover.loc)
		return
	reset_offsets()
	qdel(src)

/datum/component/impaled/proc/on_unbuckle()
	SIGNAL_HANDLER
	reset_offsets()
	qdel(src)

/datum/component/impaled/proc/set_offsets(offset_dir)
	var/mob/living/carbon/C = parent
	var/offset_x = 0
	var/offset_y = 0
	if(offset_dir  & NORTH)
		offset_y -= 0
	if(offset_dir  & SOUTH)
		offset_y += 24
	if(offset_dir  & EAST)
		offset_x -= 16
	if(offset_dir  & WEST)
		offset_x += 16
	animate(C, pixel_x = C.base_pixel_x + offset_x, pixel_y = C.base_pixel_y + offset_y, 3)

/datum/component/impaled/proc/reset_offsets()
	var/mob/living/carbon/C = parent
	animate(C, pixel_x = C.base_pixel_x, pixel_y = C.base_pixel_y, 1)

///////////////////////////////////////////////////////

/obj/structure/wall_stuck_thing
	name = "что-то"
	icon = 'white/valtos/icons/effects.dmi'
	icon_state = "pinned"
	desc = "В стене!"
	density = FALSE
	anchored = TRUE
	buckle_lying = 0
	can_buckle = 1
	max_integrity = 25
	var/obj/impaler

/obj/structure/wall_stuck_thing/proc/release_mob(mob/living/M)
	M.pixel_y = M.base_pixel_y + PIXEL_Y_OFFSET_LYING
	M.adjustBruteLoss(30)
	M.visible_message(span_danger("[M] falls free of [src]!"))
	unbuckle_mob(M,force=1)
	INVOKE_ASYNC(M, TYPE_PROC_REF(/mob, emote), "agony")
	M.AdjustParalyzed(20)

/obj/structure/wall_stuck_thing/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	if(impaler)
		impaler.forceMove(get_turf(src))
	return ..()

/obj/structure/wall_stuck_thing/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message(span_notice("[user] tries to pull [M] free of [src]!") ,\
				span_notice("[user] пытается pull you off [src], opening up fresh wounds!") ,\
				span_hear("You hear a squishy wet noise."))
			if(!do_after(user, 300, target = src))
				if(M?.buckled)
					M.visible_message(span_notice("[user] fails to free [M]!") ,\
					span_notice("[user] fails to pull you off of [src]."))
				return

		else
			M.visible_message(span_warning("[M] struggles to break free from [src]!") ,\
			span_notice("You struggle to break free from [src], exacerbating your wounds! (Stay still for two minutes.)") ,\
			span_hear("You hear a wet squishing noise.."))
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M?.buckled)
					to_chat(M, span_warning("You fail to free yourself!"))
				return
		if(!M.buckled)
			return
		release_mob(M)

/obj/structure/wall_stuck_thing/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return
