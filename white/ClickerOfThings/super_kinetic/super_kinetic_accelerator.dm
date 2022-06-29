/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator
	name = "супер протокинетический ускоритель"
	desc = "Самозарядный, дальнобойный инструмент. Обладает увеличенным местом для модификаций, но не наносит урона."
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/decent_damage)
	max_mod_capacity = 250 //250 Ибо этим ТОЛЬКО копать. Сюда не поставить моды на урон и прочее (Я пофиксил, честна!)


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


/obj/item/gun/energy/kinetic_accelerator/super_kinetic_accelerator/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/borg/upgrade/modkit))
		var/list/mods_can_be_added = src.accept_mods
		for(var/counter = 1; counter <= mods_can_be_added.len; counter++)
			if(istype(I, mods_can_be_added[counter]) && ispath(mods_can_be_added[counter], I))
				var/obj/item/borg/upgrade/modkit/MK = I
				MK.install(src, user)
				return
		to_chat(user, span_warning("Не могу установить [I], она несовместима!"))
		return
	else
		..()


/obj/projectile/kinetic/decent_damage
	damage = 1

/obj/item/ammo_casing/energy/kinetic/decent_damage
	projectile_type = /obj/projectile/kinetic/decent_damage
