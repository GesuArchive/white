/datum/element/glitch
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2

/datum/element/glitch/Attach(datum/target, amount = 4, speed_min = 1, speed_max = 2, count = 1)
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	var/atom/master = target
	master.add_filter("glitch_shadow_1", 2, drop_shadow_filter(rand(-1, 1), color = "#ff0000"))
	master.add_filter("glitch_shadow_2", 2, drop_shadow_filter(rand(-1, 1), color = "#00ffff"))
	master.add_filter("glitch_displace", 2, displacement_map_filter(icon = 'white/valtos/icons/glitch_mask.png', size = amount))

	var/glitch_filter = master.get_filter("glitch_displace")

	animate(glitch_filter, size = rand(1, amount), x = rand(1, amount), y = rand(1, amount), time = rand(speed_min, speed_max), loop = count, easing = SINE_EASING)
	animate(size = 0, x = 0, y = 0, time = rand(speed_min, speed_max))

	. = ..()

	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(get_examine_name), TRUE)

/datum/element/glitch/Detach(atom/source)
	var/atom/master = source
	UnregisterSignal(source, COMSIG_ATOM_GET_EXAMINE_NAME)
	master.remove_filter("glitch_shadow_1")
	master.remove_filter("glitch_shadow_2")
	master.remove_filter("glitch_displace")
	return ..()

/datum/element/glitch/proc/get_examine_name(datum/source, mob/user, list/override)
	SIGNAL_HANDLER
	. = "<small class='hypnophrase'>[capitalize(source)]</small>"
	return COMPONENT_EXNAME_CHANGED

/obj/item/gun/magic/glitch
	name = "Глитч-ган"
	desc = "Вите надо выйти..."
	max_charges = 3
	can_charge = TRUE
	recharge_rate = 1
	fire_sound = 'white/valtos/sounds/mechanized/kr1.wav'
	ammo_type = /obj/item/ammo_casing/magic/glitch

/obj/item/gun/magic/glitch/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/glitch, count = -1)

/obj/item/ammo_casing/magic/glitch
	projectile_type = /obj/projectile/magic/glitch

/obj/projectile/magic/glitch
	name = "заряд глитчей"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = TRUE

/obj/projectile/magic/glitch/on_hit(atom/GA)
	. = ..()
	GA.AddElement(/datum/element/glitch, count = -1)
	qdel(src)
