/obj/item/gun/energy/e_gun/mini/exploration
	name = "миниатюрный Е-Ган Рейнджера"
	desc = "Маленькая энергетическая пушка размером с пистолет со встроенным фонариком. У него есть два режима: убить и бурить."
	pin = /obj/item/firing_pin/off_station
	ammo_type = list(/obj/item/ammo_casing/energy/laser/anti_creature, /obj/item/ammo_casing/energy/laser/cutting)

/obj/item/gun/energy/e_gun/mini/exploration/emag_act(mob/user)
	. = ..()
	//Emag the pin too
	if(pin)
		pin.emag_act(user)
	if(obj_flags & EMAGGED)
		return
	to_chat(user, span_warning("Взламываю защиту, теперь он может стрелять ещё более мощнее, нежели раньше."))
	ammo_type = list(/obj/item/ammo_casing/energy/laser/exploration_kill, /obj/item/ammo_casing/energy/laser/exploration_destroy)
	update_ammo_types()
	obj_flags |= EMAGGED

//Anti-creature - Extra damage against simplemobs

/obj/item/ammo_casing/energy/laser/anti_creature
	projectile_type = /obj/projectile/beam/laser/anti_creature
	select_name = "убить"
	e_cost = 40

/obj/projectile/beam/laser/anti_creature
	damage = 15
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/laser/anti_creature/on_hit(atom/target, blocked)
	damage = initial(damage)
	if(!iscarbon(target) && !issilicon(target))
		damage = 30
	. = ..()

//Cutting projectile - Damage against objects

/obj/item/ammo_casing/energy/laser/cutting
	projectile_type = /obj/projectile/beam/laser/cutting
	select_name = "бурить"
	e_cost = 30

/obj/projectile/beam/laser/cutting
	damage = 5
	icon_state = "heavylaser"
	tracer_type = /obj/effect/projectile/tracer/heavy_laser
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/projectile/beam/laser/cutting/on_hit(atom/target, blocked)
	damage = initial(damage)
	if(isobj(target))
		damage = 70
	else if(istype(target, /turf/closed/mineral))
		var/turf/closed/mineral/T = target
		T.gets_drilled()
	. = ..()

//Emagged ammo types

/obj/item/ammo_casing/energy/laser/exploration_kill
	projectile_type = /obj/projectile/beam/laser/exploration_kill
	select_name = "УБИТЬ"
	e_cost = 80

/obj/projectile/beam/laser/exploration_kill
	damage = 30
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/laser/exploration_kill/on_hit(atom/target, blocked)
	damage = initial(damage)
	if(!iscarbon(target) && !issilicon(target))
		damage = 50
	//If you somehow hit yourself you get fried.
	if(target == firer)
		to_chat(firer, span_userdanger("Лазер внезапно притягивается к моей пушке и делает ОГРОМНУЮ ДЫРЕНЬ В МОЁМ ТЕЛЕ!"))
		damage = 200
	. = ..()

//destroy

/obj/item/ammo_casing/energy/laser/exploration_destroy
	projectile_type = /obj/projectile/beam/laser/exploration_destroy
	select_name = "УНИЧТОЖИТЬ"
	e_cost = 120

/obj/projectile/beam/laser/exploration_destroy
	damage = 20
	icon_state = "heavylaser"
	tracer_type = /obj/effect/projectile/tracer/heavy_laser
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/projectile/beam/laser/exploration_destroy/on_hit(atom/target, blocked)
	damage = initial(damage)
	if(isobj(target))
		damage = 150
	else if(istype(target, /turf/closed/mineral))
		var/turf/closed/mineral/T = target
		T.gets_drilled()
	else if(isturf(target))
		SSexplosions.medturf += target
	. = ..()
