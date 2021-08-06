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

	var/obj/structure/wall_stuck_thing/ST = new(get_turf(C))
	ST.dir = get_dir(impaled_to, C)
	ST.name = impaled_by.name
	impaled_by.forceMove(ST)
	ST.impaler = impaled_by

	if(ST.dir  & NORTH)
		ST.pixel_y += 16
	if(ST.dir  & SOUTH)
		ST.pixel_y -= 16
	if(ST.dir  & EAST)
		ST.pixel_x += 16
	if(ST.dir  & WEST)
		ST.pixel_x -= 16

	ST.buckle_mob(C, force=1)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_moved)

/datum/component/impaled/UnregisterFromParent()
	var/mob/living/carbon/C = parent
	C.base_pixel_x = initial(C.base_pixel_x)
	C.base_pixel_y = initial(C.base_pixel_y)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/impaled/proc/on_moved(atom/movable/mover, atom/oldloc, direction)
	if(oldloc == mover.loc)
		return

	qdel(src)



///////////////////////////////////////////////////////

/obj/structure/wall_stuck_thing
	name = "что-то"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "В стене!"
	density = FALSE
	anchored = TRUE
	buckle_lying = 0
	can_buckle = 1
	max_integrity = 50
	var/obj/impaler

/obj/structure/wall_stuck_thing/proc/release_mob(mob/living/M)
	M.pixel_y = M.base_pixel_y + PIXEL_Y_OFFSET_LYING
	M.adjustBruteLoss(30)
	M.visible_message("<span class='danger'>[M] falls free of [src]!</span>")
	unbuckle_mob(M,force=1)
	M.emote("scream")
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
