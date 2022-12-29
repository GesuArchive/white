/obj/vehicle/sealed/car/fucking_tank
	name = "ТАНК"
	desc = "<big>БЛЯТЬ!</big>"
	icon = 'icons/obj/car.dmi'
	icon_state = "tank"
	engine_sound = 'white/valtos/sounds/tonkloop.ogg'
	engine_sound_length = 5 SECONDS
	max_buckled_mobs = 1
	pixel_y = -48
	pixel_x = -48
	max_integrity = 2000
	var/cannon_last_fire_time = 0
	var/cannon_cd = 3 SECONDS
	var/cannon_projectile_type = /obj/projectile/bullet/cannonball/explosive

/obj/vehicle/sealed/car/fucking_tank/Initialize(mapload)
	. = ..()
	//AddElement(/datum/element/ridable, /datum/component/riding/vehicle/tank)
	vehicle_move_delay = 10
	glide_size = 1.5

/obj/vehicle/sealed/car/fucking_tank/Bump(atom/A)
	. = ..()
	if(A == src || (A in occupants))
		return ..()

	if(ishuman(A))
		var/mob/living/carbon/human/rammed = A
		visible_message(span_danger("<b>[capitalize(src)]</b> давит <b>[A]</b>!"))
		rammed.gib()
		return ..()

	if(isclosedturf(A))
		SSexplosions.lowturf += A
		return ..()

	if(isobj(A))
		var/obj/dead_obj = A
		dead_obj.take_damage(INFINITY, BRUTE, NONE, TRUE, dir, INFINITY)
		return ..()

/obj/vehicle/sealed/car/fucking_tank/auto_assign_occupant_flags(mob/M)
	. = ..()
	RegisterSignal(M, COMSIG_MOB_CLICKON, PROC_REF(fire_cannon_at))

// ЧЕ ЭТО БЛЯ
/obj/vehicle/sealed/car/fucking_tank/vehicle_move(direction)
	. = ..()
	var/turf/lt
	var/turf/mt
	var/turf/rt
	switch(direction)
		if(WEST)
			lt = locate( x - 2, y - 1, z )
			mt = locate( x - 2, y, 	   z )
			rt = locate( x - 2, y + 1, z )
		if(EAST)
			lt = locate( x + 2, y + 1, z )
			mt = locate( x + 2, y, 	   z )
			rt = locate( x + 2, y - 1, z )
		if(NORTH)
			lt = locate( x - 1, y + 2, z )
			mt = locate( x,     y + 2, z )
			rt = locate( x + 1, y + 2, z )
		if(SOUTH)
			lt = locate( x + 1, y - 2, z )
			mt = locate( x,     y - 2, z )
			rt = locate( x - 1, y - 2, z )
	for(var/atom/A in lt)
		Bump(A)
	for(var/atom/A in mt)
		Bump(A)
	for(var/atom/A in rt)
		Bump(A)
	for(var/atom/A in range(1, src))
		Bump(A)
	Bump(lt)
	Bump(mt)
	Bump(rt)

/* это тебе нахуй ненужн это блин для хуйни где моб вне нее сидит типа всяких скейтов
/datum/component/riding/vehicle/tank
	vehicle_move_delay = 10

/datum/component/riding/vehicle/tank/handle_specials()
	. = ..()
	set_riding_offsets(1, list(TEXT_NORTH = list(-10, -4), TEXT_SOUTH = list(16, 3), TEXT_EAST = list(-4, 30), TEXT_WEST = list(4, -3)))
	set_riding_offsets(2, list(TEXT_NORTH = list(19, -5, 4), TEXT_SOUTH = list(-13, 3, 4), TEXT_EAST = list(-4, -3, 4.1), TEXT_WEST = list(4, 28, 3.9)))
	set_riding_offsets(3, list(TEXT_NORTH = list(-10, -18, 4.2), TEXT_SOUTH = list(16, 25, 3.9), TEXT_EAST = list(-22, 30), TEXT_WEST = list(22, -3, 4.1)))
	set_riding_offsets(4, list(TEXT_NORTH = list(19, -18, 4.2), TEXT_SOUTH = list(-13, 25, 3.9), TEXT_EAST = list(-22, 3, 3.9), TEXT_WEST = list(22, 28)))
	set_vehicle_dir_offsets(NORTH, -48, -48)
	set_vehicle_dir_offsets(SOUTH, -48, -48)
	set_vehicle_dir_offsets(EAST, -48, -48)
	set_vehicle_dir_offsets(WEST, -48, -48)
*/

/////////////////////////////////////////////стреляет карочи

/obj/vehicle/sealed/car/fucking_tank/proc/fire_cannon_at(mob/user, atom/A, params)
	if(world.time < cannon_last_fire_time + cannon_cd)
		to_chat(user, "Рано еще!")
		return NONE
	var/turf/firing_turf = get_turf(src) //поправишь если захочш ебнешь оффсеты там ченить такое придумаешь карочи
	var/firing_angle = get_angle(firing_turf, A)
	if(angle_diff(dir2angle(dir), firing_angle) > 45)
		to_chat(user, "Надо бы повернуться!")
		return NONE

	cannon_last_fire_time = world.time
	if(cannon_projectile_type)
		visible_message(span_danger("[src] производит стрельбу пушечными ядрами XVIII века!"))
		for(var/mob/shaken_mob in urange(10, src))
			if(shaken_mob.stat == CONSCIOUS)
				shake_camera(shaken_mob, 3, 1)
		playsound(src, 'sound/weapons/gun/general/cannon.ogg', 150, TRUE)
		var/obj/projectile/fired_projectile = new cannon_projectile_type(firing_turf)
		fired_projectile.firer = user
		fired_projectile.fired_from = src
		fired_projectile.fire(firing_angle, A)
	return COMSIG_MOB_CANCEL_CLICKON
