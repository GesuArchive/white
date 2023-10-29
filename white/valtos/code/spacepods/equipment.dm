/obj/item/spacepod_equipment
	var/obj/spacepod/spacepod
	icon = 'white/valtos/icons/spacepods/parts.dmi'
	var/slot = SPACEPOD_SLOT_MISC
	var/slot_space = 1

/obj/item/spacepod_equipment/proc/on_install(obj/spacepod/SP)
	spacepod = SP
	SP.equipment |= src
	forceMove(SP)

/obj/item/spacepod_equipment/proc/on_uninstall()
	spacepod.equipment -= src

/obj/item/spacepod_equipment/proc/can_install(obj/spacepod/SP, mob/user)
	var/room = SP.equipment_slot_limits[slot] || 0
	for(var/obj/item/spacepod_equipment/EQ in SP.equipment)
		if(EQ.slot == slot)
			room -= EQ.slot_space
	if(room < slot_space)
		to_chat(user, span_warning("There's no room for another [slot] system!"))
		return FALSE
	return TRUE

/obj/item/spacepod_equipment/proc/can_uninstall(mob/user)
	return TRUE

/obj/item/spacepod_equipment/weaponry
	slot = SPACEPOD_SLOT_WEAPON
	var/projectile_type
	var/shot_cost = 0
	var/shots_per = 1
	var/fire_sound
	var/fire_delay = 15
	var/overlay_icon
	var/overlay_icon_state

/obj/item/spacepod_equipment/weaponry/on_install(obj/spacepod/SP)
	. = ..()
	SP.weapon = src
	SP.update_icon()

/obj/item/spacepod_equipment/weaponry/on_uninstall()
	. = ..()
	if(spacepod.weapon == src)
		spacepod.weapon = null

/obj/item/spacepod_equipment/weaponry/proc/fire_weapons(target)
	if(spacepod.next_firetime > world.time)
		to_chat(usr, span_warning("Your weapons are recharging."))
		playsound(src, 'sound/weapons/gun/general/dry_fire.ogg', 30, TRUE)
		return
	if(!spacepod.cell || !spacepod.cell.use(shot_cost))
		to_chat(usr, span_warning("Insufficient charge to fire the weapons"))
		playsound(src, 'sound/weapons/gun/general/dry_fire.ogg', 30, TRUE)
		return
	spacepod.next_firetime = world.time + fire_delay
	for(var/I in 1 to shots_per)
		spacepod.fire_projectiles(projectile_type, target)
		playsound(src, fire_sound, 50, TRUE)
		sleep(2)

/*
///////////////////////////////////////
/////////Cargo System//////////////////
///////////////////////////////////////
*/

/obj/item/spacepod_equipment/cargo // this one holds large crates and shit
	name = "pod cargo"
	desc = "You shouldn't be seeing this"
	icon_state = "cargo_blank"
	slot = SPACEPOD_SLOT_CARGO

/obj/item/spacepod_equipment/cargo/large
	name = "Трюм спейспода"
	desc = "Небольшой отсек вмещающий один стандартный грузовой ящик. Ящик в комплект не входит."
	icon_state = "cargo_crate"
	var/obj/storage = null
	var/storage_type = /obj/structure/closet/crate

/obj/item/spacepod_equipment/cargo/large/on_install(obj/spacepod/SP)
	..()
	// COMSIG - a way to make component signals sound more important than they actually are.
	// it's not even limited to components. Does this look like a component to you?
	// Okay here's a better name: It's a fucking *event handler*. Like the ones in javascript.
	// a much more descriptive and less scary name than fucking "COMSIG". But noooooooooo
	// the TG coders were too self important to pick a descriptive name and wanted to sound all scientific
	RegisterSignal(SP, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(spacepod_mousedrop))
	SP.verbs |= /obj/spacepod/proc/unload_cargo

/obj/item/spacepod_equipment/cargo/large/on_uninstall()
	UnregisterSignal(spacepod, COMSIG_MOUSEDROPPED_ONTO)
	..()
	if(!(locate(/obj/item/spacepod_equipment/cargo/large) in spacepod.equipment))
		spacepod.verbs -= /obj/spacepod/proc/unload_cargo

/obj/item/spacepod_equipment/cargo/large/can_uninstall(mob/user)
	if(storage)
		to_chat(user, span_warning("Unload the cargo first!"))
		return FALSE
	return ..()

/obj/spacepod/proc/unload_cargo() // if I could i'd put this on spacepod_equipment but unfortunately BYOND is stupid
	set name = "Unload Cargo"
	set category = "Спейспод"
	set src = usr.loc

	if(!verb_check())
		return

	var/used_key_list = list()
	var/cargo_map = list()
	for(var/obj/item/spacepod_equipment/cargo/large/E in equipment)
		if(!E.storage)
			continue
		cargo_map[avoid_assoc_duplicate_keys("[E.name] ([E.storage.name])", used_key_list)] = E
	var/selection = tgui_input_list(usr, "Unload which cargo?", null, cargo_map)
	var/obj/item/spacepod_equipment/cargo/large/E = cargo_map[selection]
	if(!selection || !verb_check() || !E || !(E in equipment) || !E.storage)
		return
	E.storage.forceMove(loc)
	E.storage = null

/obj/item/spacepod_equipment/cargo/large/proc/spacepod_mousedrop(obj/spacepod/SP, obj/A, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(spacepod_mousedrop_async), SP, A, user)

/obj/item/spacepod_equipment/cargo/large/proc/spacepod_mousedrop_async(obj/spacepod/SP, obj/A, mob/user)
	if(user == SP.pilot || (user in SP.passengers))
		return FALSE
	if(istype(A, storage_type) && SP.Adjacent(A)) // For loading ore boxes
		if(!storage)
			to_chat(user, span_notice("You begin loading [A] into [SP]'s [src]"))
			if(do_after_mob(user, list(A, SP), 40))
				storage = A
				A.forceMove(src)
				to_chat(user, span_notice("You load [A] into [SP]'s [src]!"))
			else
				to_chat(user, span_warning("You fail to load [A] into [SP]'s [src]"))
		else
			to_chat(user, span_warning("[SP] already has \an [storage]"))
		return TRUE
	return FALSE

/obj/item/spacepod_equipment/cargo/large/ore
	name = "Рудный танк спейспода"
	desc = "Система хранения руды для спейсподов. Автоматически собирает ближайшую руду, рядом с кораблем. Для работы необходимо загрузить ящик для руды."
	icon_state = "cargo_ore"
	storage_type = /obj/structure/ore_box

/obj/item/spacepod_equipment/cargo/large/ore/on_install(obj/spacepod/SP)
	..()
	RegisterSignal(SP, COMSIG_MOVABLE_MOVED, PROC_REF(spacepod_moved))

/obj/item/spacepod_equipment/cargo/large/ore/on_uninstall()
	UnregisterSignal(spacepod, COMSIG_MOVABLE_MOVED)
	..()

/obj/item/spacepod_equipment/cargo/large/ore/proc/spacepod_moved(obj/spacepod/SP)
	SIGNAL_HANDLER
	if(storage)
		for(var/turf/T in SP.locs)
			for(var/obj/item/stack/ore in T)
				ore.forceMove(storage)

/obj/item/spacepod_equipment/cargo/chair
	name = "Пассажирское кресло спейспода"
	desc = "Второе посадочное место для перевозки пасажиров."
	icon_state = "sec_cargo_chair"
	var/occupant_mod = 1

/obj/item/spacepod_equipment/cargo/chair/on_install(obj/spacepod/SP)
	..()
	SP.max_passengers += occupant_mod

/obj/item/spacepod_equipment/cargo/chair/on_uninstall()
	spacepod.max_passengers -= occupant_mod
	..()

/obj/item/spacepod_equipment/cargo/chair/can_uninstall(mob/user)
	if(spacepod.passengers.len > (spacepod.max_passengers - occupant_mod))
		to_chat(user, span_warning("You can't remove an occupied seat! Remove the occupant first."))
		return FALSE
	return ..()

/*
///////////////////////////////////////
/////////Weapon System///////////////////
///////////////////////////////////////
*/

/obj/item/spacepod_equipment/weaponry/disabler
	name = "Усмиритель спейспода"
	desc = "Ведет огонь маломощными лазерами которые изматывают цель, не нанося ей вреда."
	icon_state = "weapon_taser"
	projectile_type = /obj/projectile/beam/disabler
	shot_cost = 400
	fire_sound = 'sound/weapons/taser2.ogg'
	overlay_icon = 'white/valtos/icons/spacepods/2x2.dmi'
	overlay_icon_state = "pod_weapon_disabler"

/obj/item/spacepod_equipment/weaponry/burst_disabler
	name = "Продвинутый усмиритель спейспода"
	desc = "Ведет огонь очередью маломощных лазеров которые изматывают цель, не нанося ей вреда."
	icon_state = "weapon_burst_taser"
	projectile_type = /obj/projectile/beam/disabler
	shot_cost = 1200
	shots_per = 3
	fire_sound = 'sound/weapons/taser2.ogg'
	fire_delay = 30
	overlay_icon = 'white/valtos/icons/spacepods/2x2.dmi'
	overlay_icon_state = "pod_weapon_disabler"

/obj/item/spacepod_equipment/weaponry/laser
	name = "Лазер спейспода"
	desc = "Ведет огонь лазером средней мощности."
	icon_state = "weapon_laser"
	projectile_type = /obj/projectile/beam/laser
	shot_cost = 600
	fire_sound = 'sound/weapons/Laser.ogg'
	overlay_icon = 'white/valtos/icons/spacepods/2x2.dmi'
	overlay_icon_state = "pod_weapon_laser"

/obj/item/spacepod_equipment/weaponry/laser_heavylaser
	name = "Продвинутый лазер спейспода"
	desc = "Ведет огонь лазером высокой мощности."
	icon_state = "weapon_laser"
	projectile_type = /obj/projectile/beam/laser/heavylaser
	shot_cost = 1200
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	overlay_icon = 'white/valtos/icons/spacepods/2x2.dmi'
	overlay_icon_state = "pod_weapon_laser"

// MINING LASERS
/obj/item/spacepod_equipment/weaponry/basic_pod_ka
	name = "Кинетический акселератор спейспода"
	desc = "Ведет огонь слабыми импульсами кинетической энергии."
	icon = 'white/valtos/icons/spacepods/goon/parts.dmi'
	icon_state = "pod_taser"
	projectile_type = /obj/projectile/kinetic/pod
	shot_cost = 300
	fire_delay = 14
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'

/obj/item/spacepod_equipment/weaponry/pod_ka
	name = "Продвинутый кинетический акселератор спейспода"
	desc = "Ведет огонь мощными импульсами кинетической энергии. Продвинутая версия обладает повышенной скорострельностью и более экономичным энергопотреблением."
	icon = 'white/valtos/icons/spacepods/goon/parts.dmi'
	icon_state = "pod_m_laser"
	projectile_type = /obj/projectile/kinetic/pod/regular
	shot_cost = 250
	fire_delay = 10
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'

/obj/projectile/kinetic/pod
	range = 4

/obj/projectile/kinetic/pod/regular
	damage = 50
	pressure_decrease = 0.5

/obj/item/spacepod_equipment/weaponry/plasma_cutter
	name = "Плазменный резак спейспода"
	desc = "Ведет огонь концентрированными сгустками плазмы, используется при добыче полезных ископаемых на астероидах."
	icon = 'white/valtos/icons/spacepods/goon/parts.dmi'
	icon_state = "pod_p_cutter"
	projectile_type = /obj/projectile/plasma
	shot_cost = 250
	fire_delay = 10
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	overlay_icon = 'white/valtos/icons/spacepods/2x2.dmi'
	overlay_icon_state = "pod_weapon_plasma"

/obj/item/spacepod_equipment/weaponry/plasma_cutter/adv
	name = "Продвинутый плазменный резак спейспода"
	desc = "Ведет огонь концентрированными сгустками плазмы, используется при добыче полезных ископаемых на астероидах. Продвинутая версия обладает повышенной скорострельностью и более экономичным энергопотреблением."
	icon_state = "pod_ap_cutter"
	projectile_type = /obj/projectile/plasma/adv
	shot_cost = 200
	fire_delay = 8

/*
///////////////////////////////////////
/////////Misc. System///////////////////
///////////////////////////////////////
*/

/obj/item/spacepod_equipment/tracker
	name = "Маяк спейспода"
	desc = "Следящее устройство для поиска корабля в бескрайнем космосе."
	icon = 'white/valtos/icons/spacepods/goon/parts.dmi'
	icon_state = "pod_locator"

/*
///////////////////////////////////////
/////////Lock System///////////////////
///////////////////////////////////////
*/

/obj/item/spacepod_equipment/lock
	name = "pod lock"
	desc = "You shouldn't be seeing this"
	icon_state = "blank"
	slot = SPACEPOD_SLOT_LOCK

/obj/item/spacepod_equipment/lock/on_install(obj/spacepod/SP)
	..()
	RegisterSignal(SP, COMSIG_PARENT_ATTACKBY, PROC_REF(spacepod_attackby))
	SP.lock = src

/obj/item/spacepod_equipment/lock/on_uninstall()
	UnregisterSignal(spacepod, COMSIG_PARENT_ATTACKBY)
	if(spacepod.lock == src)
		spacepod.lock = null
	spacepod.locked = FALSE
	..()

/obj/item/spacepod_equipment/lock/proc/spacepod_attackby(obj/spacepod/SP, I, mob/user)
	SIGNAL_HANDLER
	return FALSE

// Key and Tumbler System
/obj/item/spacepod_equipment/lock/keyed
	name = "Центральный замок спейспода"
	desc = "Блокирует двери, полезно для защиты имущества. После изготовления необходимо синхронизировать с ключом."
	icon_state = "lock_tumbler"
	var/static/id_source = 0
	var/id = null

/obj/item/spacepod_equipment/lock/keyed/Initialize(mapload)
	. = ..()
	if(id == null)
		id = ++id_source


/obj/item/spacepod_equipment/lock/keyed/spacepod_attackby(obj/spacepod/SP, obj/item/I, mob/user)
	if(istype(I, /obj/item/spacepod_key))
		var/obj/item/spacepod_key/key = I
		if(key.id == id)
			SP.lock_pod()
			return
		else
			to_chat(user, span_warning("This is the wrong key!"))
		return TRUE
	return FALSE

/obj/item/spacepod_equipment/lock/keyed/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/spacepod_key))
		var/obj/item/spacepod_key/key = I
		if(key.id == null)
			key.id = id
			to_chat(user, span_notice("You grind the blank key to fit the lock."))
		else
			to_chat(user, span_warning("This key is already ground!"))
	else
		..()

/obj/item/spacepod_equipment/lock/keyed/sec
	id = "security spacepod"

/obj/item/spacepod_equipment/lock/keyed/yohei
	id = "yohei spacepod"

// The key
/obj/item/spacepod_key
	name = "Ключ от спейспода"
	desc = "Ключ от центрального замка спейспода. После изготовления необходимо синхронизировать с замком."
	icon = 'white/valtos/icons/spacepods/parts.dmi'
	icon_state = "podkey"
	w_class = WEIGHT_CLASS_TINY
	var/id = null

/obj/item/spacepod_key/sec
	name = "Ключ от спейспода СБ"
	desc = "Ключ от центрального замка спейспода."
	id = "security spacepod"

/obj/item/spacepod_key/yohei
	name = "Ключ от спейспода Йохеев"
	desc = "Ключ от центрального замка спейспода."
	id = "yohei spacepod"

/obj/item/device/lock_buster
	name = "Взломщик центрального замка спейспода"
	desc = "Уничтожает замок и разблокирует спейспод. Внимание: после использования гарантия обнуляется."
	icon = 'white/valtos/icons/spacepods/parts.dmi'
	icon_state = "lock_buster_off"
	var/on = FALSE

/obj/item/device/lock_buster/attack_self(mob/user)
	on = !on
	if(on)
		icon_state = "lock_buster_on"
	else
		icon_state = "lock_buster_off"
	to_chat(user, span_notice("You turn the [src] [on ? "on" : "off"]."))

// Teleportation
/obj/item/spacepod_equipment/teleport
	name = "телепортатор"
	desc = "Мгновенно возвращает корабль к маяку."
	icon_state = "cargo_blank"
	slot = SPACEPOD_SLOT_MISC

/obj/spacepod/verb/wayback_me()
	set name = "Вернуться к маяку"
	set category = "Спейспод"
	set src = usr.loc

	if(!(locate(/obj/item/spacepod_equipment/teleport) in equipment))
		to_chat(usr, span_warning("Нет телепортирующего устройства!"))
		return

	if(!verb_check())
		return

	if(do_after(usr, 5 SECONDS, src, timed_action_flags = IGNORE_INCAPACITATED))
		if(!cell || !cell.use(5000))
			to_chat(usr, span_warning("Недостаточно энергии!"))
			return

		for(var/atom/A in GLOB.yohei_beacons)
			var/turf/T = get_turf(A)
			if(locate(/obj/spacepod) in T.contents)
				continue
			else
				forceMove(T)
				return

		to_chat(usr, span_notice("ТЕЛЕПОРТИРУЕМСЯ!"))
