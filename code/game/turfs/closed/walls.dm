#define MAX_DENT_DECALS 15
#define LEANING_OFFSET 11

/turf/closed/wall
	name = "стена"
	desc = "Здоровенный кусок металла, который служит для разделения помещений."
	icon = DEFAULT_WALL_ICON
	icon_state = "wall-0"
	base_icon_state = "wall"
	explosion_block = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	baseturfs = /turf/open/floor/plating

	flags_ricochet = RICOCHET_HARD

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE)

	rcd_memory = RCD_MEMORY_WALL

	///lower numbers are harder. Used to determine the probability of a hulk smashing through.
	var/hardness = 40
	var/slicing_duration = 100  //default time taken to slice the wall
	var/sheet_type = /obj/item/stack/sheet/iron
	var/sheet_amount = 2
	var/girder_type = /obj/structure/girder

	var/list/dent_decals

/turf/closed/wall/MouseDrop_T(mob/living/carbon/carbon_mob, mob/user)
	..()
	if(carbon_mob != user)
		return
	if(carbon_mob.is_leaning == TRUE)
		return
	if(carbon_mob.pulledby)
		return
	if(!carbon_mob.density)
		return
	var/turf/checked_turf = get_step(carbon_mob, REVERSE_DIR(carbon_mob.dir))
	if(checked_turf == src)
		carbon_mob.start_leaning(src)

/mob/living/carbon/proc/start_leaning(obj/wall)

	switch(dir)
		if(SOUTH)
			pixel_y += LEANING_OFFSET
		if(NORTH)
			pixel_y += -LEANING_OFFSET
		if(WEST)
			pixel_x += LEANING_OFFSET
		if(EAST)
			pixel_x += -LEANING_OFFSET

	ADD_TRAIT(src, TRAIT_UNDENSE, LEANING_TRAIT)
	ADD_TRAIT(src, TRAIT_EXPANDED_FOV, LEANING_TRAIT)
	visible_message(span_notice("[src] облокачивается о [wall]!"), \
						span_notice("Облокачиваюсь о [wall]!"))
	RegisterSignals(src, list(COMSIG_MOB_CLIENT_PRE_MOVE, COMSIG_HUMAN_DISARM_HIT, COMSIG_LIVING_GET_PULLED, COMSIG_MOVABLE_TELEPORTING, COMSIG_ATOM_DIR_CHANGE), PROC_REF(stop_leaning))
	update_fov()
	is_leaning = TRUE

/mob/living/carbon/proc/stop_leaning()
	SIGNAL_HANDLER
	UnregisterSignal(src, list(COMSIG_MOB_CLIENT_PRE_MOVE, COMSIG_HUMAN_DISARM_HIT, COMSIG_LIVING_GET_PULLED, COMSIG_MOVABLE_TELEPORTING, COMSIG_ATOM_DIR_CHANGE))
	is_leaning = FALSE
	pixel_y = base_pixel_y + body_position_pixel_x_offset
	pixel_x = base_pixel_y + body_position_pixel_y_offset
	REMOVE_TRAIT(src, TRAIT_UNDENSE, LEANING_TRAIT)
	REMOVE_TRAIT(src, TRAIT_EXPANDED_FOV, LEANING_TRAIT)
	update_fov()

/turf/closed/wall/Initialize(mapload)
	. = ..()
	if(is_station_level(z))
		GLOB.station_turfs += src
	if(smoothing_flags & SMOOTH_DIAGONAL_CORNERS && fixed_underlay) //Set underlays for the diagonal walls.
		var/mutable_appearance/underlay_appearance = mutable_appearance(layer = TURF_LAYER, offset_spokesman = src, plane = FLOOR_PLANE)
		if(fixed_underlay["space"])
			generate_space_underlay(underlay_appearance, src)
		else
			underlay_appearance.icon = fixed_underlay["icon"]
			underlay_appearance.icon_state = fixed_underlay["icon_state"]
		fixed_underlay = string_assoc_list(fixed_underlay)
		underlays += underlay_appearance


/turf/closed/wall/Destroy()
	if(is_station_level(z))
		GLOB.station_turfs -= src
	return ..()


/turf/closed/wall/examine(mob/user)
	. += ..()
	. += "<hr>"
	. += deconstruction_hints(user)

/turf/closed/wall/proc/deconstruction_hints(mob/user)
	return span_notice("Внешняя обшивка крепко <b>приварена</b>.")

/turf/closed/wall/attack_tk()
	return

/turf/closed/wall/proc/dismantle_wall(devastated=0, explode=0)
	if(devastated)
		devastate_wall()
	else
		playsound(src, 'sound/items/welder.ogg', 100, TRUE)
		var/newgirder = break_wall()
		if(newgirder) //maybe we don't /want/ a girder!
			transfer_fingerprints_to(newgirder)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)

	var/turf/new_floor = ScrapeAway()
	new_floor.air_update_turf()
	QUEUE_SMOOTH_NEIGHBORS(src)

/turf/closed/wall/proc/break_wall()
	new sheet_type(src, sheet_amount)
	return new girder_type(src)

/turf/closed/wall/proc/devastate_wall()
	new sheet_type(src, sheet_amount)
	if(girder_type)
		new /obj/item/stack/sheet/iron(src)

/turf/closed/wall/ex_act(severity, target, prikolist)
	if(target == src)
		dismantle_wall(1,1)
		return

	switch(severity)
		if(EXPLODE_DEVASTATE)
			//SN src = null
			var/turf/NT = ScrapeAway()
			NT.contents_explosion(severity, target)
			return
		if(EXPLODE_HEAVY)
			dismantle_wall(prob(50), TRUE)
		if(EXPLODE_LIGHT)
			if (prob(hardness))
				dismantle_wall(0,1)
	if(!density)
		..()


/turf/closed/wall/blob_act(obj/structure/blob/B)
	playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	if(prob(50))
		dismantle_wall()
	else
		add_dent(WALL_DENT_HIT)

/turf/closed/wall/attack_paw(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	return attack_hand(user)


/turf/closed/wall/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if((M.environment_smash & ENVIRONMENT_SMASH_WALLS) || (M.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		dismantle_wall(1)
		return

/turf/closed/wall/attack_hulk(mob/living/carbon/user)
	..()
	var/obj/item/bodypart/arm = user.hand_bodyparts[user.active_hand_index]
	if(!arm)
		return
	if(arm.bodypart_disabled)
		return
	if(prob(hardness))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		user.say(pick(";РАААААААААААРГХ!", ";ХАНННННННЕННГГГГГХ!", ";ГВААААААААААААААРРРРРРРРРРР!", "НННННННЕННГГГГГГХХХХХХ!", ";АААААААААРРРГХ!" ), forced = "hulk")
		hulk_recoil(arm, user)
		dismantle_wall(1)

	else
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		add_dent(WALL_DENT_HIT)
		user.visible_message(span_danger("[user] бьёт [src]!") , \
					span_danger("Бью [src]!") , \
					span_hear("Слышу громкий удар по стене!"))
	return TRUE

/**
 *Deals damage back to the hulk's arm.
 *
 *When a hulk manages to break a wall using their hulk smash, this deals back damage to the arm used.
 *This is in its own proc just to be easily overridden by other wall types. Default allows for three
 *smashed walls per arm. Also, we use CANT_WOUND here because wounds are random. Wounds are applied
 *by hulk code based on arm damage and checked when we call break_an_arm().
 *Arguments:
 **arg1 is the arm to deal damage to.
 **arg2 is the hulk
 */
/turf/closed/wall/proc/hulk_recoil(obj/item/bodypart/arm, mob/living/carbon/human/hulkman, damage = 20)
	arm.receive_damage(brute = damage, blocked = 0, wound_bonus = CANT_WOUND)
	var/datum/mutation/human/hulk/smasher = locate(/datum/mutation/human/hulk) in hulkman.dna.mutations
	if(!smasher || !damage) //sanity check but also snow and wood walls deal no recoil damage, so no arm breaky
		return
	smasher.break_an_arm(arm)

/turf/closed/wall/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(W,/obj/item/melee/baseball_bat/hos/hammer))
		smash_with_hammer(W, user)
		return

	if (!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("У меня не хватает ловкости, чтобы сделать это!"))
		return

	//get the user's location
	if(!isturf(user.loc))
		return	//can't do this stuff whilst inside objects and such

	add_fingerprint(user)

	var/turf/T = user.loc	//get user's location for delay checks

	//the istype cascade has been spread among various procs for easy overriding
	if(try_clean(W, user, T) || try_wallmount(W, user, T) || try_decon(W, user, T))
		return

	return ..()

/turf/closed/wall/proc/smash_with_hammer(obj/item/melee/baseball_bat/hos/hammer/W, mob/user)
	//unwielded - chance to breach a wall is  hardness / 10
	//wielded - chance to breach a wall is hardness / 4
	var/p = hardness*0.1
	if(W.wielded)
		p = p * 2.5
		user.changeNext_move(CLICK_CD_MELEE*2)


	if(prob(p))
		src.dismantle_wall(TRUE)
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	else
		add_dent(WALL_DENT_HIT)
		playsound(src, 'sound/effects/meteorimpact.ogg', 75, TRUE)
	user.do_attack_animation(W)

/turf/closed/wall/proc/try_clean(obj/item/W, mob/user, turf/T)
	if((user.a_intent != INTENT_HELP) || !LAZYLEN(dent_decals))
		return FALSE

	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, span_notice("Начинаю чинить стену..."))
		if(W.use_tool(src, user, 0, volume=100))
			if(iswallturf(src) && LAZYLEN(dent_decals))
				to_chat(user, span_notice("Стена починена."))
				cut_overlay(dent_decals)
				dent_decals.Cut()
			return TRUE

	return FALSE

/turf/closed/wall/proc/try_wallmount(obj/item/W, mob/user, turf/T)
	//check for wall mounted frames
	if(istype(W, /obj/item/wallframe))
		var/obj/item/wallframe/F = W
		if(F.try_build(src, user))
			F.attach(src, user)
		return TRUE
	//Poster stuff
	else if(istype(W, /obj/item/poster))
		place_poster(W,user)
		return TRUE
	return FALSE

/turf/closed/wall/proc/try_decon(obj/item/I, mob/user, turf/T)
	if(I.tool_behaviour == TOOL_WELDER)
		if(!I.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, span_notice("Начинаю разваривать стену..."))
		if(I.use_tool(src, user, slicing_duration, volume=100))
			if(iswallturf(src))
				to_chat(user, span_notice("После недолгого ожидания удалось снять верхнюю обшивку."))
				dismantle_wall()
			return TRUE

	return FALSE

/turf/closed/wall/singularity_pull(S, current_size)
	..()
	wall_singularity_pull(current_size)

/turf/closed/wall/proc/wall_singularity_pull(current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(50))
			dismantle_wall()
		return
	if(current_size == STAGE_FOUR)
		if(prob(30))
			dismantle_wall()

/turf/closed/wall/narsie_act(force, ignore_mobs, probability = 20)
	. = ..()
	if(.)
		ChangeTurf(/turf/closed/wall/mineral/cult)

/turf/closed/wall/get_dumping_location(obj/item/storage/source, mob/user)
	return null

/turf/closed/wall/acid_act(acidpwr, acid_volume)
	if(explosion_block >= 2)
		acidpwr = min(acidpwr, 50) //we reduce the power so strong walls never get melted.
	return ..()

/turf/closed/wall/acid_melt()
	dismantle_wall(1)

/turf/closed/wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 40, "cost" = 26)
	return FALSE

/turf/closed/wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("Разбираю стену."))
			ScrapeAway()
			return TRUE
	return FALSE

/turf/closed/wall/proc/add_dent(denttype, x=rand(-8, 8), y=rand(-8, 8))
	if(LAZYLEN(dent_decals) >= MAX_DENT_DECALS)
		return

	var/mutable_appearance/decal = mutable_appearance('icons/effects/effects.dmi', "", BULLET_HOLE_LAYER)
	switch(denttype)
		if(WALL_DENT_SHOT)
			decal.icon_state = "bullet_hole"
		if(WALL_DENT_HIT)
			decal.icon_state = "impact[rand(1, 3)]"

	decal.pixel_x = x
	decal.pixel_y = y

	if(LAZYLEN(dent_decals))
		cut_overlay(dent_decals)
		dent_decals += decal
	else
		dent_decals = list(decal)

	add_overlay(dent_decals)

/turf/closed/wall/rust_heretic_act()
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	ChangeTurf(/turf/closed/wall/rust)

/turf/closed/wall/metal_foam_base
	girder_type = /obj/structure/foamedmetal

#undef MAX_DENT_DECALS
#undef LEANING_OFFSET
