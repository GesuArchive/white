/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator
	name = "super proto-kinetic accelerator"
	desc = "A self recharging, ranged mining tool that does increased damage in low pressure, now with more mod capacity! But without damage..."
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/no_damage)
	max_mod_capacity = 250

	// add here mods that CAN be attached
	var/accept_mods = list(/obj/item/borg/upgrade/modkit/aoe/turfs,
	/obj/item/borg/upgrade/modkit/cooldown,
	/obj/item/borg/upgrade/modkit/range,
	/obj/item/borg/upgrade/modkit/minebot_passthrough,
	/obj/item/borg/upgrade/modkit/trigger_guard,
	/obj/item/borg/upgrade/modkit/chassis_mod,
	/obj/item/borg/upgrade/modkit/chassis_mod/orange,
	/obj/item/borg/upgrade/modkit/tracer,
	/obj/item/borg/upgrade/modkit/tracer/adjustable)

/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator/attack_obj(obj/I, mob/user)
	if(istype(I, /obj/item/borg/upgrade/modkit))
		var/list/mods_can_be_added = src.accept_mods
		for(var/counter = 1; counter <= mods_can_be_added.len; counter++)
			if(istype(I, mods_can_be_added[counter]) && ispath(mods_can_be_added[counter], I))
				var/obj/item/borg/upgrade/modkit/MK = I
				MK.install(src, user)
				return
		to_chat(user, span_warning("Nigger?!"))
		return
	else
		..()

/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/borg/upgrade/modkit))
		var/list/mods_can_be_added = src.accept_mods
		for(var/counter = 1; counter <= mods_can_be_added.len; counter++)
			if(istype(I, mods_can_be_added[counter]) && ispath(mods_can_be_added[counter], I))
				var/obj/item/borg/upgrade/modkit/MK = I
				MK.install(src, user)
				return
		to_chat(user, span_warning("You can't install that mod!"))
		return
	else
		..()


/obj/projectile/kinetic/no_damage
	damage = 0
/obj/item/ammo_casing/energy/kinetic/no_damage
	projectile_type = /obj/projectile/kinetic/no_damage


/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	var/lmao = 0
	for(var/m in modkits)
		if(istype(m,/obj/item/borg/upgrade/modkit/damage))
			lmao += 25
		if(istype(m,/obj/item/borg/upgrade/modkit/lifesteal))
			lmao += 15
		if(istype(m,/obj/item/borg/upgrade/modkit/indoors)) //fuck off
			lmao += 50


	if(prob(min(lmao,100)))
		attempt_reload(21474836) //we do a little trolling
	. = ..() // как бе вызывает attempt_reload дважды, но второй вызов нихуя не делает, так что похуй.
