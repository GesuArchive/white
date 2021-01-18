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
	desc = "Удалённый доступ к шлюзам."
	w_class = WEIGHT_CLASS_TINY
	var/mode = WAND_OPEN
	var/region_access = 1 //See access.dm
	var/list/access_list
	network_id = NETWORK_DOOR_REMOTES

/obj/item/door_remote/Initialize()
	. = ..()
	access_list = get_region_accesses(region_access)
	RegisterSignal(src, COMSIG_COMPONENT_NTNET_NAK, .proc/bad_signal)
	RegisterSignal(src, COMSIG_COMPONENT_NTNET_ACK, .proc/good_signal)

/obj/item/door_remote/proc/bad_signal(datum/source, datum/netdata/data, error_code)
	if(QDELETED(data.user))
		return // can't send a message to a missing user
	if(error_code == NETWORK_ERROR_UNAUTHORIZED)
		to_chat(data.user, "<span class='notice'>Этот пульт управления не хочет работать с этим шлюзом.</span>")
	else
		to_chat(data.user, "<span class='notice'>Ошибка: [error_code]</span>")


/obj/item/door_remote/proc/good_signal(datum/source, datum/netdata/data, error_code)
	if(QDELETED(data.user))
		return
	var/toggled = data.data["data"]
	to_chat(data.user, "<span class='notice'>Шлюз [toggled] переключен.</span>")

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
	to_chat(user, "<span class='notice'>Теперь в режиме: <b>[desc[mode]]</b>.</span>")

/obj/item/door_remote/emag_act(mob/user, obj/item/card/emag/E)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='warning'>Шокирующий режим разблокирован.</span>")

// Airlock remote works by sending NTNet packets to whatever it's pointed at.
/obj/item/door_remote/afterattack(atom/A, mob/user)
	. = ..()
	var/datum/component/ntnet_interface/target_interface = A.GetComponent(/datum/component/ntnet_interface)

	if(!target_interface)
		return

	if(obj_flags & EMAGGED)
		playsound(get_turf(src), 'sound/machines/ping.ogg', 25, TRUE)

	user.set_machine(src)
	// Generate a control packet.
	var/datum/netdata/data = new(list("data" = mode,"data_secondary" = "toggle"))
	data.receiver_id = target_interface.hardware_id
	data.passkey = access_list
	data.user = user	// for responce message

	ntnet_send(data)


/obj/item/door_remote/omni
	name = "всешлюзник"
	desc = "Имеет доступ ко всем шлюзам на этой деревне."
	icon_state = "gangtool-yellow"
	region_access = 0

/obj/item/door_remote/captain
	name = "пульт управления командования"
	icon_state = "gangtool-yellow"
	region_access = 7

/obj/item/door_remote/chief_engineer
	name = "инженерный пульт управления"
	icon_state = "gangtool-orange"
	region_access = 5

/obj/item/door_remote/research_director
	name = "научный пульт управления"
	icon_state = "gangtool-purple"
	region_access = 4

/obj/item/door_remote/head_of_security
	name = "пульт управления безопасности"
	icon_state = "gangtool-red"
	region_access = 2

/obj/item/door_remote/quartermaster
	name = "пульт управления снабжения"
	desc = "Удалённый доступ к шлюзам. Этот имеет доступ к хранилищу."
	icon_state = "gangtool-green"
	region_access = 6

/obj/item/door_remote/chief_medical_officer
	name = "медицинский пульт управления"
	icon_state = "gangtool-blue"
	region_access = 3

/obj/item/door_remote/civilian
	name = "гражданский пульт управления"
	icon_state = "gangtool-white"
	region_access = 1

#undef WAND_OPEN
#undef WAND_BOLT
#undef WAND_EMERGENCY
#undef WAND_SHOCK
