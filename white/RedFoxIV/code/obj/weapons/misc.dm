/obj/item/gun/breakopen/detonator
	name = "Детонатор"
	desc = "Гарантированный мини-крит по горящим врагам. Погодите-ка..."
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "detonator"
	max_ammo = 1

/obj/item/ammo_casing/caseless/detflare
	name = "Заряд для сигнальной ракетницы"
	desc = "\"Слегка\" модифицирован для более \"зрелищного\" результата."
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "detonator_casing"
	projectile_type = /obj/projectile/detflare
	caliber = "flare"
/obj/projectile/detflare
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "detonator_projectile"
	damage = 0
	var/firedamage = 10
	var/turf/prev_loc

/obj/projectile/detflare/Move(atom/newloc, direct, glide_size_override)
	//If it works...
	prev_loc = get_turf(src)
	. = ..()
	

/obj/projectile/detflare/on_hit(atom/target, blocked, pierce_hit)
	var/turf/tloc
	//i don't think this works like it should, but i'm actually content with how it works currently.
	//...it ain't stupid.
	if(isclosedturf(target))
		tloc = prev_loc
	else
		tloc = get_turf(src)


	for(var/dir in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, 0))
		var/turf/T = get_step(tloc, dir)
		if(isclosedturf(T))
			continue
		new /obj/effect/hotspot(T)
		T.hotspot_expose(600, 50, 1)
		for(var/mob/living/L in T)
			if(L.on_fire)
				L.adjustFireLoss(firedamage*1.5 ) //minicritical shit
			else
				L.adjustFireLoss(firedamage)
			L.adjust_fire_stacks(max(0, 2 - L.fire_stacks)) //sets L.fire_stacks to 2 if it's less than 2, doesn't do anything if L.fire_stacks is 3 or more.
			L.IgniteMob()

	. = ..()

/obj/item/gun/energy/nlaw
	name = "N-LAW"
	desc = "Basically, a big subwoofer with a trigger. Can incapacitate people by throwing into walls, windows, other people, open airlocks, supermatter, disposals, banana peels, AIDS-infected monkeys, lavaland megafauna, lavaland lava, permabrig and, if you're not careful enough, yourself."
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "sonic_gun"
	inhand_icon_state = "sonic_gun"
	lefthand_file = 'white/RedFoxIV/icons/obj/weapons/guns_lefthand.dmi'
	righthand_file =  'white/RedFoxIV/icons/obj/weapons/guns_righthand.dmi'
	cell_type = /obj/item/stock_parts/cell/high
	charge_sections = 5
	shaded_charge = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/acoustic)
	modifystate = TRUE

/*
/obj/item/gun/energy/nlaw/garbage
	desc = "A prototype energy weapon. Most people throw it in the trash bin and bug R&D for a better one. Does not support cell changing, overcharged mode, sustained fire, windows 10."
	name = "LAW"
	cell_type = /obj/item/stock_parts/cell/nlaw
	ammo_type = list(/obj/item/ammo_casing/energy/acoustic)
*/

/obj/item/stock_parts/cell/nlaw
	name = "LAW battery"
	desc = "Good job jackass, now try to put it back in without admemes."
	charge = 4000

/obj/item/ammo_casing/energy/acoustic
	projectile_type = /obj/projectile/acoustic_wave
	e_cost = 2000
	select_name = "normal"
	pellets = 3
	caliber = "acoustic"
	variance = 60

/obj/projectile/acoustic_wave
	name = "Acoustic wave"
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "sonic_projectile"
	damage = 0
	range = 4
	speed = 1.6
	buckle_lying = 90
	max_buckled_mobs = 10
	projectile_phasing = PASSMOB
	var/prev_loc

/obj/projectile/acoustic_wave/Move(atom/newloc, direct, glide_size_override)
	prev_loc = get_turf(src)
	/*
	for(var/obj/O in prev_loc)
		if(!O.anchored)
			O.forceMove(get_step(O, angle2dir()))
	*/
	for(var/mob/living/L in prev_loc)
		if(!L.buckled && L != firer)
			//L.forceMove(get_step(L, angle2dir()))
			buckle_mob(L, force = TRUE)
	
	for(var/obj/O in newloc)
		if(istype(O, /obj/structure/table))
			for(var/mob/living/L in buckled_mobs)
				L.Paralyze(25)
			qdel(src)
			return
	. = ..()
	
/obj/projectile/acoustic_wave/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	
	if(isclosedturf(target))
		for(var/mob/living/L in buckled_mobs)
			L.Paralyze(rand(30,60))
			L.adjustBruteLoss(rand(10,20))	
	/*
	var/atom/movable/throwdir = angle2dir(Angle)
	var/atom/movable/throwtarget = get_edge_target_turf(target, throwdir)
	if(istype(target, /mob/living) && !target.anchored)
		target.throw_at(throwtarget, knock_dist+1, 4, src.firer, 1, 0, null, move_force)
		return
	if(istype(target,/obj/structure) && !target.anchored)
		target.throw_at(throwtarget, knock_dist/2, 4, src.firer, 1, 0, null, move_force)
		return
	*/

/obj/projectile/acoustic_wave/vol_by_damage()
	return 1


/*
/datum/design/nlaw
	name = "N-LAW"
	desc = "A prototype energy weapon which utilizes powerful acoustic waves to knock people around."
	id = "nlaw"
	build_type = PROTOLATHE
	materials = list(/datum/material/titanium = 14000, /datum/material/plasma = 6000, /datum/material/glass = 10000, /datum/material/gold = 6000 , /datum/material/iron = 25000)
	build_path = /obj/item/gun/energy/nlaw
	category = list("Вооружение")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_SCIENCE //убрать флаг РнД если чрезмерно охуеют
*/

/obj/item/gun/breakopen/doublebarrel
	name = "двухствольный дробовик"
	desc = "Настоящая классика."
	can_be_sawn_off = TRUE
	can_fire_all_rounds_at_once = TRUE

/obj/item/gun/ballistic/stabba_taser
	name = "Стабба тазер"
	desc = "Двухзарядный тазер, стреляющий застревающими в теле электродами."
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "ballistic_taser"
	inhand_icon_state = "stabba_taser"
	lefthand_file = 'white/qwaszx000/sprites/stabba_taser_left.dmi'
	righthand_file = 'white/qwaszx000/sprites/stabba_taser_right.dmi'
	pin = /obj/item/firing_pin
	bolt_type = BOLT_TYPE_NO_BOLT
	casing_ejector = FALSE
	mag_type = /obj/item/ammo_box/magazine/internal/stabba_taser_magazine
	fire_delay = 5
	internal_magazine = TRUE

/obj/item/ammo_box/magazine/internal/stabba_taser_magazine
	name = "Магазин стабба тазера. Если вы видите это, сообщите администратору."
	icon = null
	icon_state = null
	ammo_type = /obj/item/ammo_casing/stabba
	caliber = "stabba"
	max_ammo = 2
	start_empty = FALSE

/obj/item/ammo_box/magazine/internal/stabba_taser_magazine/give_round(obj/item/ammo_casing/R, replace_spent = 1)
	return ..(R,1)

/obj/item/ammo_casing/stabba
	name = "картридж стабба тазера"
	desc = "Одноразовый картридж."
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "ballistic_taser_casing"
	throwforce = 1
	projectile_type = /obj/projectile/bullet/stabba
	firing_effect_type = null
	caliber = "stabba"
	harmful = FALSE
/obj/item/trash/stabba_casing_cover
	name = "Пластиковая оболочка картриджа тазера"
	icon = 'white/RedFoxIV/icons/obj/weapons/misc.dmi'
	icon_state = "bt_trash1"

/obj/item/trash/stabba_casing_cover/Initialize(mapload, cover)
	. = ..()
	icon_state = "bt_trash[cover]"
	pixel_x = base_pixel_x + rand(-6,6)
	pixel_y = base_pixel_y + rand(-6,6)
	transform = matrix().Turn(rand(0,360))
	SpinAnimation(loops = 1)

/obj/item/ammo_casing/stabba/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, extra_damage, extra_penetration)
	. = ..()
	new /obj/item/trash/stabba_casing_cover(get_turf(src), 1)
	new /obj/item/trash/stabba_casing_cover(get_turf(src), 2)
	

/obj/projectile/bullet/stabba
	name = "Электродик Стаббы"
	desc = "Выглядит остро"
	icon = 'white/qwaszx000/sprites/stabba_taser.dmi'
	icon_state = "taser_projectile"
	damage = 0
	nodamage = TRUE
	stamina = 8
	speed = 2
	range = 12
	embedding = list(embed_chance=100, fall_chance=0, pain_stam_pct=8, pain_mult=1, pain_chance=75)