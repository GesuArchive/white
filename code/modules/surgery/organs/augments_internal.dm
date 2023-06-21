/obj/item/organ/cyberimp
	name = "кибернетический имплант"
	desc = "Ультрасовременный имплант, улучшающий функциональность базовой линии."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
	var/implant_color = "#FFFFFF"
	var/implant_overlay
	var/syndicate_implant = FALSE //Makes the implant invisible to health analyzers and medical HUDs.

/obj/item/organ/cyberimp/New(mob/M = null)
	if(iscarbon(M))
		src.Insert(M)
	if(implant_overlay)
		var/mutable_appearance/overlay = mutable_appearance(icon, implant_overlay)
		overlay.color = implant_color
		add_overlay(overlay)
	return ..()

//[[[[BRAIN]]]]

/obj/item/organ/cyberimp/brain
	name = "кибернетический мозговой имплант"
	desc = "Инжекторы дополнительных подпрограмм для мозга."
	icon_state = "brain_implant"
	implant_overlay = "brain_implant_overlay"
	zone = BODY_ZONE_HEAD
	w_class = WEIGHT_CLASS_TINY

/obj/item/organ/cyberimp/brain/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	var/stun_amount = 200/severity
	owner.Stun(stun_amount)
	to_chat(owner, span_warning("Моё тело обездвижено!"))


/obj/item/organ/cyberimp/brain/anti_drop
	name = "имплант крепкого хвата"
	desc = "Этот кибернетический мозговой имплант заставит мышцы ваших рук сократиться, предотвращая падение предметов. Подергайте ухом, чтобы переключиться."
	var/active = 0
	var/list/stored_items = list()
	implant_color = "#DE7E00"
	slot = ORGAN_SLOT_BRAIN_ANTIDROP
	actions_types = list(/datum/action/item_action/organ_action/toggle)

/obj/item/organ/cyberimp/brain/anti_drop/ui_action_click()
	active = !active
	if(active)
		for(var/obj/item/I in owner.held_items)
			stored_items += I

		var/list/L = owner.get_empty_held_indexes()
		if(LAZYLEN(L) == owner.held_items.len)
			to_chat(owner, span_notice("Ничего не держу, руки расслаблены..."))
			active = 0
			stored_items = list()
		else
			for(var/obj/item/I in stored_items)
				to_chat(owner, span_notice("Моя [owner.get_held_index_name(owner.get_held_index_of_item(I))] усиливает захват."))
				ADD_TRAIT(I, TRAIT_NODROP, ANTI_DROP_IMPLANT_TRAIT)

	else
		release_items()
		to_chat(owner, span_notice("Руки расслабляются..."))


/obj/item/organ/cyberimp/brain/anti_drop/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	var/range = severity ? 10 : 5
	var/atom/A
	if(active)
		release_items()
	for(var/obj/item/I in stored_items)
		A = pick(oview(range))
		I.throw_at(A, range, 2)
		to_chat(owner, span_warning("Моя [owner.get_held_index_name(owner.get_held_index_of_item(I))] спазмирует и [I.name] вылетает из неё!"))
	stored_items = list()


/obj/item/organ/cyberimp/brain/anti_drop/proc/release_items()
	for(var/obj/item/I in stored_items)
		REMOVE_TRAIT(I, TRAIT_NODROP, ANTI_DROP_IMPLANT_TRAIT)
	stored_items = list()


/obj/item/organ/cyberimp/brain/anti_drop/Remove(mob/living/carbon/M, special = 0)
	if(active)
		ui_action_click()
	..()

/obj/item/organ/cyberimp/brain/anti_stun
	name = "имплант перезагрузки ЦНС"
	desc = "Этот имплант автоматически вернет вам контроль над центральной нервной системой, сократив время паралича при оглушении."
	implant_color = "#FFFF00"
	slot = ORGAN_SLOT_BRAIN_ANTISTUN

	var/static/list/signalCache = list(
		COMSIG_LIVING_STATUS_STUN,
		COMSIG_LIVING_STATUS_KNOCKDOWN,
		COMSIG_LIVING_STATUS_IMMOBILIZE,
		COMSIG_LIVING_STATUS_PARALYZE,
	)

	var/stun_cap_amount = 40

/obj/item/organ/cyberimp/brain/anti_stun/Remove(mob/living/carbon/M, special = FALSE)
	. = ..()
	UnregisterSignal(M, signalCache)

/obj/item/organ/cyberimp/brain/anti_stun/Insert()
	. = ..()
	RegisterSignals(owner, signalCache, PROC_REF(on_signal))

/obj/item/organ/cyberimp/brain/anti_stun/proc/on_signal(datum/source, amount)
	if(!(organ_flags & ORGAN_FAILING) && amount > 0)
		addtimer(CALLBACK(src, PROC_REF(clear_stuns)), stun_cap_amount, TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/item/organ/cyberimp/brain/anti_stun/proc/clear_stuns()
	if(owner || !(organ_flags & ORGAN_FAILING))
		owner.SetStun(0)
		owner.SetKnockdown(0)
		owner.SetImmobilized(0)
		owner.SetParalyzed(0)

/obj/item/organ/cyberimp/brain/anti_stun/emp_act(severity)
	. = ..()
	if((organ_flags & ORGAN_FAILING) || . & EMP_PROTECT_SELF)
		return
	organ_flags |= ORGAN_FAILING
	addtimer(CALLBACK(src, PROC_REF(reboot)), 90 / severity)

/obj/item/organ/cyberimp/brain/anti_stun/proc/reboot()
	organ_flags &= ~ORGAN_FAILING

//[[[[MOUTH]]]]
/obj/item/organ/cyberimp/mouth
	zone = BODY_ZONE_PRECISE_MOUTH

/obj/item/organ/cyberimp/mouth/breathing_tube
	name = "имплант дыхательной трубки"
	desc = "Этот простой имплант добавляет к вашей спине внутренний соединитель, позволяющий использовать внутренние компоненты без маски и защищающий вас от удушья."
	icon_state = "implant_mask"
	slot = ORGAN_SLOT_BREATHING_TUBE
	w_class = WEIGHT_CLASS_TINY

/obj/item/organ/cyberimp/mouth/breathing_tube/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	if(prob(60/severity))
		to_chat(owner, span_warning("НЕ МОГУ ДЫШАТЬ!"))
		owner.losebreath += 2

//BOX O' IMPLANTS

/obj/item/storage/box/cyber_implants
	name = "кибернетические импланты"
	desc = "Элегантная и прочная коробка."
	icon_state = "cyber_implants"
	var/list/boxed = list(
		/obj/item/autosurgeon/organ/syndicate/thermal_eyes,
		/obj/item/autosurgeon/organ/syndicate/xray_eyes,
		/obj/item/autosurgeon/organ/syndicate/anti_stun,
		/obj/item/autosurgeon/organ/syndicate/reviver,
		/obj/item/autosurgeon/organ/syndicate/esword,
		)
	var/amount = 5

/obj/item/storage/box/cyber_implants/PopulateContents()
	var/implant
	while(contents.len <= amount)
		implant = pick(boxed)
		new implant(src)
