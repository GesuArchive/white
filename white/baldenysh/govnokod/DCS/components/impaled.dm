/datum/component/impaled
	var/obj/impaled_by
	var/atom/impaled_to

/datum/component/impaled/Initialize(obj/imp_by, atom/imp_to)
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	impaled_by = imp_by
	impaled_to = imp_to

/datum/component/impaled/RegisterWithParent()
	var/mob/living/carbon/C = parent
	C.Paralyze(10 SECONDS)
	var/obj/structure/wall_stuck_thing/ST = new(get_turf(C))
	ST.dir = get_dir(impaled_to, C)
	if(ST.dir & SOUTH)
		ST.layer = ABOVE_ALL_MOB_LAYER
	ST.name = impaled_by.name
	impaled_by.forceMove(ST)
	ST.impaler = impaled_by
	ST.buckle_mob(C, force=1)
	set_offsets(ST.dir)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_moved)
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, .proc/on_unbuckle)

/datum/component/impaled/UnregisterFromParent()
	var/mob/living/carbon/C = parent
	C.base_pixel_x = initial(C.base_pixel_x)
	C.base_pixel_y = initial(C.base_pixel_y)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/impaled/proc/on_moved(atom/movable/mover, atom/oldloc, direction)
	if(oldloc == mover.loc)
		return
	reset_offsets()
	qdel(src)

/datum/component/impaled/proc/on_unbuckle()
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
	M.visible_message("<span class='danger'>[M] falls free of [src]!</span>")
	unbuckle_mob(M,force=1)
	M.emote("agony")
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
			M.visible_message("<span class='notice'>[user] tries to pull [M] free of [src]!</span>",\
				"<span class='notice'>[user] пытается pull you off [src], opening up fresh wounds!</span>",\
				"<span class='hear'>You hear a squishy wet noise.</span>")
			if(!do_after(user, 300, target = src))
				if(M?.buckled)
					M.visible_message("<span class='notice'>[user] fails to free [M]!</span>",\
					"<span class='notice'>[user] fails to pull you off of [src].</span>")
				return

		else
			M.visible_message("<span class='warning'>[M] struggles to break free from [src]!</span>",\
			"<span class='notice'>You struggle to break free from [src], exacerbating your wounds! (Stay still for two minutes.)</span>",\
			"<span class='hear'>You hear a wet squishing noise..</span>")
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M?.buckled)
					to_chat(M, "<span class='warning'>You fail to free yourself!</span>")
				return
		if(!M.buckled)
			return
		release_mob(M)

/obj/structure/wall_stuck_thing/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return
