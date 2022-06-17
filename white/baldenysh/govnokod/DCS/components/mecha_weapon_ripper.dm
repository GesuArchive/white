/datum/component/mecha_weapon_ripper //позволяет вырывать оружие из турелей и мехов, добавлю спейсподы если они вдруг станут релевантны
	var/ripping_time = 0
	var/ripping = FALSE

/datum/component/mecha_weapon_ripper/Initialize(mapload)
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

	var/list/modifiers = params2list(params)
	if(modifiers["alt"] || modifiers["shift"] || modifiers["ctrl"] || modifiers["middle"])
		return

	var/obj/item/ripping_target
	if(ismecha(A))
		var/obj/vehicle/sealed/mecha/mech = A
		ripping_target = mech.selected
	else if(istype(A, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/turret = A
		ripping_target = turret.stored_gun

	if(!ripping_target)
		to_chat(user, span_warning("Да тут отрывать-то и нечего!"))
		return

	if(ripping)
		return (COMSIG_MOB_CANCEL_CLICKON)

	INVOKE_ASYNC(src, .proc/doRip, user, A, ripping_target)

	return (COMSIG_MOB_CANCEL_CLICKON)

/datum/component/mecha_weapon_ripper/proc/doRip(mob/living/ripper, atom/target_holder, obj/item/ripping_target)
	if(ripping_time > 0)
		ripper.visible_message(span_warning("[ripper] пытается оторвать [ripping_target] от [target_holder]!") , \
			 span_danger("Начинаю отрывать [ripping_target] от [target_holder]!"))
		ripping = TRUE
		if(!do_after(ripper, ripping_time, target_holder))
			to_chat(ripper, span_warning("Что-то помешало мне оторвать [ripping_target]!"))
			ripping = FALSE
			return
		ripping = FALSE

	if(ismecha(target_holder))
		var/obj/vehicle/sealed/mecha/mech = target_holder
		mech.selected = null
		mech.equipment -= ripping_target
		mech.spark_system.start()
	else if(istype(target_holder, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/turret = target_holder
		turret.stored_gun = null
		turret.spark_system.start()

	ripping_target.forceMove(get_turf(target_holder))

	if(iscarbon(ripper))
		ripper.put_in_active_hand(ripping_target, FALSE, FALSE)

	if(istype(ripping_target, /obj/item/gun/energy/e_gun/turret))
		var/obj/item/gun/energy/e_gun/turret/funny = ripping_target
		funny.trigger_guard = TRIGGER_GUARD_NORMAL

	ripper.visible_message(span_warning("[ripper] отрывает [ripping_target] от [target_holder]!") , \
		 span_danger("Отрываю [ripping_target] от [target_holder]!"))
