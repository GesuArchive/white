#define WAND_OPEN "open"
#define WAND_BOLT "bolt"
#define WAND_EMERGENCY "emergency"
#define WAND_SHOCK "shock"

/obj/item/door_remote
	icon_state = "gangtool-white"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	icon = 'icons/obj/device.dmi'
	name = "пульт управления"
	desc = "Устройство для удаленного управления шлюзами."
	w_class = WEIGHT_CLASS_TINY
	var/mode = WAND_OPEN
	var/region_access = REGION_GENERAL
	var/list/access_list

/obj/item/door_remote/Initialize(mapload)
	. = ..()
	access_list = SSid_access.get_region_access_list(list(region_access))

/obj/item/door_remote/attack_self(mob/user)
	var/static/list/desc = list(WAND_OPEN = "Открыть шлюз", WAND_BOLT = "Переключить болты", WAND_EMERGENCY = "Переключить экстренный доступ", WAND_SHOCK = "Медиум-рейр")
	switch(mode)
		if(WAND_OPEN)
			mode = WAND_BOLT
		if(WAND_BOLT)
			mode = WAND_EMERGENCY
		if(WAND_EMERGENCY)
			if(obj_flags & EMAGGED)
				mode = WAND_SHOCK
			else
				mode = WAND_OPEN
		if(WAND_SHOCK)
			mode = WAND_OPEN
	to_chat(user, span_notice("Режим: [desc[mode]]."))

/obj/item/door_remote/emag_act(mob/user, obj/item/card/emag/E)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, span_warning("Шокирующий режим разблокирован."))

// Airlock remote works by sending NTNet packets to whatever it's pointed at.
/obj/item/door_remote/afterattack(atom/target, mob/user)
	. = ..()

	var/obj/machinery/door/door

	if (istype(target, /obj/machinery/door))
		door = target

		if (!door.opens_with_door_remote)
			return
	else
		for (var/obj/machinery/door/door_on_turf in get_turf(target))
			if (door_on_turf.opens_with_door_remote)
				door = door_on_turf
				break

		if (isnull(door))
			return

	if (!door.check_access_list(access_list) || !door.requiresID())
		target.balloon_alert(user, "нет доступа!")
		return

	var/obj/machinery/door/airlock/airlock = door

	if (!door.hasPower() || (istype(airlock) && !airlock.canAIControl()))
		target.balloon_alert(user, mode == WAND_OPEN ? "не открывается!" : "ничего не происходит!")
		return

	switch (mode)
		if (WAND_OPEN)
			if (door.density)
				door.open()
			else
				door.close()
		if (WAND_BOLT)
			if (!istype(airlock))
				target.balloon_alert(user, "только шлюзы!")
				return

			if (airlock.locked)
				airlock.unbolt()
			else
				airlock.bolt()
		if (WAND_EMERGENCY)
			if (!istype(airlock))
				target.balloon_alert(user, "только шлюзы!")
				return

			airlock.emergency = !airlock.emergency
			airlock.update_appearance(UPDATE_ICON)

/obj/item/door_remote/omni
	name = "всешлюзник"
	desc = "Имеет доступ ко всем шлюзам на этой деревне."
	icon_state = "gangtool-yellow"
	region_access = REGION_ALL_STATION

/obj/item/door_remote/captain
	name = "пульт управления командования"
	icon_state = "gangtool-yellow"
	region_access = REGION_COMMAND

/obj/item/door_remote/chief_engineer
	name = "инженерный пульт управления"
	icon_state = "gangtool-orange"
	region_access = REGION_ENGINEERING

/obj/item/door_remote/research_director
	name = "научный пульт управления"
	icon_state = "gangtool-purple"
	region_access = REGION_RESEARCH

/obj/item/door_remote/head_of_security
	name = "пульт управления безопасности"
	icon_state = "gangtool-red"
	region_access = REGION_SECURITY

/obj/item/door_remote/quartermaster
	name = "пульт управления снабжения"
	desc = "Устройство удаленного доступа к шлюзам. Этот имеет доступ к хранилищу."
	icon_state = "gangtool-green"
	region_access = REGION_SUPPLY

/obj/item/door_remote/chief_medical_officer
	name = "медицинский пульт управления"
	icon_state = "gangtool-blue"
	region_access = REGION_MEDBAY

/obj/item/door_remote/civilian
	name = "гражданский пульт управления"
	icon_state = "gangtool-white"
	region_access = REGION_GENERAL

#undef WAND_OPEN
#undef WAND_BOLT
#undef WAND_EMERGENCY
