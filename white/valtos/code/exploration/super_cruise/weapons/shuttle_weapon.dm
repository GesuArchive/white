#define WEAPON_SIDE_LEFT -1
#define WEAPON_SIDE_RIGHT 1
#define WEAPON_SIDE_NONE 0

/obj/machinery/shuttle_weapon
	name = "Mounted Emplacement"
	desc = "Система вооружения, установленная на шаттле. Поворот осуществляется гаечным ключом."
	icon = 'icons/obj/supercruise/supercruise_weapons_long.dmi'
	icon_state = "railgun_off"
	base_icon_state = "railgun"
	anchored = TRUE
	var/projectile_type = /obj/projectile/bullet/shuttle/beam/laser
	var/flight_time = 10

	var/shots = 1
	var/simultaneous_shots = 1
	var/shot_time = 2
	var/cooldown = 150

	var/fire_sound = 'sound/weapons/lasercannonfire.ogg'

	var/hit_chance = 60		//The chance that it will hit
	var/miss_chance = 40	//The chance it will miss completely instead of hit nearby (60% hit | 24% hit nearby (inaccuracy) | 16% miss)
	var/innaccuracy = 1		//The range that things will hit, if it doesn't get a perfect hit

	var/turf/target_turf
	COOLDOWN_DECLARE(next_shot_world_time)

	//For weapons that are side mounted (None after new sprites, but support is still here.)
	var/side = WEAPON_SIDE_NONE
	var/fire_from_source = TRUE
	var/directional_offset = 0
	var/offset_turf_x = 0
	var/offset_turf_y = 0

	//weapon ID
	var/weapon_id

	//The weapon strength factor
	//Lower numbers indicate that its weaker, higher are stronger.
	//Shuttle strength ranges from 0 to 100, the closer this value is to the shuttle strength, the more likely it will be picked
	var/strength_rating = 0

	//The angle offset to fire projectiles from
	var/angle_offset = 180

/obj/machinery/shuttle_weapon/Initialize(mapload, ndir = 0)
	. = ..()
	weapon_id = "[LAZYLEN(SSorbits.shuttle_weapons)]"
	SSorbits.shuttle_weapons[weapon_id] = src
	set_directional_offset(ndir || dir)
	//Check our area
	var/area/shuttle/current_area = get_area(src)
	if(istype(current_area) && current_area.mobile_port)
		var/datum/shuttle_data/shuttle_data = SSorbits.get_shuttle_data(current_area.mobile_port.id)
		shuttle_data?.register_weapon_system(src)

/obj/machinery/shuttle_weapon/Destroy()
	SSorbits.shuttle_weapons.Remove(weapon_id)
	. = ..()

/obj/machinery/shuttle_weapon/setDir(newdir)
	. = ..()
	//Shuttle rotations handle the pixel_x changes, and this shouldn't be rotatable, unless rotated from a shuttle
	set_directional_offset(newdir)

/obj/machinery/shuttle_weapon/obj_break(damage_flag)
	. = ..()
	qdel(src)

/obj/machinery/shuttle_weapon/proc/set_directional_offset(newdir)
	offset_turf_x = 0
	offset_turf_y = 0
	if(!fire_from_source)
		return
	switch(newdir)
		if(NORTH)
			if(side == WEAPON_SIDE_LEFT)
				pixel_x = -25
				pixel_y = 0
				var/matrix/M = matrix()
				M.Scale(-1, 1)
				transform = M
			else if (side == WEAPON_SIDE_RIGHT)
				pixel_x = 25
				pixel_y = 0
				transform = initial(transform)
			else
				pixel_x = 0
				pixel_y = 0
				transform = initial(transform)
		if(SOUTH)
			if(side == WEAPON_SIDE_LEFT)
				pixel_x = 25
				pixel_y = -40
				var/matrix/M = matrix()
				M.Turn(180)
				M.Scale(-1, 1)
				transform = M
			else if (side == WEAPON_SIDE_RIGHT)
				pixel_x = -25
				pixel_y = -40
				var/matrix/M = matrix()
				M.Turn(180)
				M.Scale(-1, -1)
				transform = M
			else
				pixel_x = 0
				pixel_y = -40
				var/matrix/M = matrix()
				M.Turn(180)
				transform = M
		if(EAST)
			if(side == WEAPON_SIDE_LEFT) // +
				pixel_x = 20
				pixel_y = 5
				var/matrix/M = matrix()
				M.Turn(-90)
				M.Scale(-1, 1)
				transform = M
			else if (side == WEAPON_SIDE_RIGHT) // +
				pixel_x = 20
				pixel_y = -44
				var/matrix/M = matrix()
				M.Turn(-90)
				M.Scale(-1, -1)
				transform = M
			else
				pixel_x = -16
				pixel_y = -20
				var/matrix/M = matrix()
				M.Turn(-90)
				transform = M
		if(WEST)
			if(side == WEAPON_SIDE_LEFT)
				pixel_x = -22
				pixel_y = -44
				var/matrix/M = matrix()
				M.Turn(-90)
				M.Scale(1, -1)
				transform = M
			else if (side == WEAPON_SIDE_RIGHT)
				pixel_x = -22
				pixel_y = 5
				var/matrix/M = matrix()
				M.Turn(-90)
				transform = M
			else
				pixel_x = 20
				pixel_y = -16
				var/matrix/M = matrix()
				M.Turn(90)
				transform = M

/obj/machinery/shuttle_weapon/proc/fire(atom/target, shots_left = shots, forced = FALSE)
	if(!target)
		if(!target_turf)
			return
		target = target_turf
	if(!COOLDOWN_FINISHED(src, next_shot_world_time) && !forced)
		update_appearance()
		return FALSE
	if(!forced)
		COOLDOWN_START(src, next_shot_world_time, cooldown)
	var/turf/current_target_turf = get_turf(target)
	var/missed = FALSE
	if(!prob(hit_chance))
		current_target_turf = locate(target.x + rand(-innaccuracy, innaccuracy), target.y + rand(-innaccuracy, innaccuracy), target.z)
		if(prob(miss_chance))
			missed = TRUE
	playsound(loc, fire_sound, 75, 1)
	for(var/i in 1 to simultaneous_shots)
		//Spawn the projectile to make it look like its firing from your end
		var/obj/projectile/bullet/shuttle/P = new projectile_type(get_offset_target_turf(get_turf(src), offset_turf_x, offset_turf_y))
		//Outgoing shots shouldn't hit our own ship because its easier
		P.force_miss = TRUE
		P.fire(dir2angle(dir) + angle_offset)
		addtimer(CALLBACK(src, PROC_REF(spawn_incoming_fire), P, current_target_turf, missed), flight_time)
	//Multishot cannons
	if(shots_left > 1)
		addtimer(CALLBACK(src, PROC_REF(fire), target, shots_left - 1, TRUE), shot_time)

/obj/machinery/shuttle_weapon/proc/spawn_incoming_fire(obj/projectile/P, atom/target, missed = FALSE)
	if(QDELETED(P))
		return
	qdel(P)
	//Spawn the projectile to come in FTL style
	fire_projectile_towards(target, projectile_type = projectile_type, missed = missed)
	update_appearance()

/obj/machinery/shuttle_weapon/wrench_act(mob/living/user, obj/item/I)
	setDir(turn(dir, 90))

/obj/machinery/shuttle_weapon/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[COOLDOWN_FINISHED(src, next_shot_world_time) ? "on" : "off"]"
