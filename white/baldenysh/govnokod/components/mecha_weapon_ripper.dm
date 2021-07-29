/datum/component/mecha_weapon_ripper //позволяет вырывать оружие из турелей и мехов, добавлю спейсподы если они вдруг станут релевантны
	var/ripping_time = 0

/datum/component/mecha_weapon_ripper/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/mecha_weapon_ripper/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_CLICKON, .proc/checkRip)

/datum/component/mecha_weapon_ripper/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_CLICKON)

/datum/component/mecha_weapon_ripper/proc/checkRip(mob/living/user, atom/A, params)
	SIGNAL_HANDLER
	if(user.incapacitated() || user.get_active_held_item())
		return
	if(!A || !(ismecha(A) || istype(A, /obj/machinery/porta_turret)))
		return
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	user.face_atom(A)

	var/obj/item/ripping_target
	if(ismecha(A))
		var/obj/vehicle/sealed/mecha/mech = A
		ripping_target = mech.selected
	else if(istype(A, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/turret = A
		ripping_target = turret.stored_gun

	if(!ripping_target)
		to_chat(user, "<span class='warning'>Да тут отрывать-то и нечего!</span>")
		return

	if(ripping_time > 0)
		user.visible_message("<span class='warning'>[user] пытается оторвать [ripping_target] от [A]!</span>", \
			 "<span class='danger'>Я начинаю отрывать [ripping_target] от [A]!</span>")
		if(!do_after(user, ripping_time, A))
			to_chat(user, "<span class='warning'>Что-то помешало мне оторвать [ripping_target]!</span>")
			return

	if(ismecha(A))
		var/obj/vehicle/sealed/mecha/mech = A
		mech.selected = null
		mech.equipment -= ripping_target
		mech.spark_system.start()
	else if(istype(A, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/turret = A
		turret.stored_gun = null
		turret.spark_system.start()

	ripping_target.forceMove(get_turf(A))

	if(iscarbon(user))
		ripping_target.attack_hand(user)

	user.visible_message("<span class='warning'>[user] отрывает [ripping_target] от [A]!</span>", \
		 "<span class='danger'>Я отрываю [ripping_target] от [A]!</span>")

	return (COMSIG_MOB_CANCEL_CLICKON)
