/datum/component/armor_plate
	var/amount = 0
	var/maxamount = 3
	var/upgrade_item = /obj/item/stack/sheet/animalhide/goliath_hide
	var/datum/armor/added_armor = list(MELEE = 10)
	var/upgrade_name

/datum/component/armor_plate/Initialize(_maxamount,obj/item/_upgrade_item,datum/armor/_added_armor)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(examine))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(applyplate))
	RegisterSignal(parent, COMSIG_PARENT_PREQDELETED, PROC_REF(dropplates))
	if(istype(parent, /obj/vehicle/sealed/mecha/working/ripley))
		RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(apply_mech_overlays))

	if(_maxamount)
		maxamount = _maxamount
	if(_upgrade_item)
		upgrade_item = _upgrade_item
	if(_added_armor)
		if(islist(_added_armor))
			added_armor = getArmor(arglist(_added_armor))
		else if (istype(_added_armor, /datum/armor))
			added_armor = _added_armor
		else
			stack_trace("Invalid type [_added_armor.type] passed as _armor_item argument to armorplate component")
	else
		added_armor = getArmor(arglist(added_armor))
	var/obj/item/typecast = upgrade_item
	upgrade_name = initial(typecast.name)

/datum/component/armor_plate/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	//upgrade_item could also be typecast here instead
	if(ismecha(parent))
		if(amount)
			if(amount < maxamount)
				examine_list += span_notice("\nБроня увеличена на [amount] [upgrade_name].")
			else
				examine_list += span_notice("\nВсе броневые пластины укреплены [upgrade_name] - должно быть его пилот знаменитый охотник на монстров.")
		else
			examine_list += span_notice("\nНа корпусе заметны точки крепления для дополнительной брони. Может, удастся усилить ее шкурой какой-нибудь твари?")
	else
		if(amount)
			examine_list += span_notice("\nЗдесь есть крепления для дополнительных броневых пластин, кажется сюда подойдет [upgrade_name]. На текущий момент закреплено [amount]/[maxamount] бронепластин.")
		else
			examine_list += span_notice("\nЗдесь есть [maxamount] крепления для дополнительных броневых пластин, кажется сюда подойдет [upgrade_name].")

/datum/component/armor_plate/proc/applyplate(datum/source, obj/item/I, mob/user, params)
	SIGNAL_HANDLER

	if(!istype(I,upgrade_item))
		return
	if(amount >= maxamount)
		to_chat(user, span_warning("Дальнейшее улучшение брони [parent] невозможно!"))
		return

	if(istype(I,/obj/item/stack))
		I.use(1)
	else
		if(length(I.contents))
			to_chat(user, span_warning("[I] не может быть улучшен пока внутри что-то есть!"))
			return
		qdel(I)

	var/obj/O = parent
	amount++
	O.armor = O.armor.attachArmor(added_armor)

	if(ismecha(O))
		var/obj/vehicle/sealed/mecha/R = O
		R.update_icon()
		to_chat(user, span_info("Закрепляю дополнительные бронепластины на [R]."))
	else
		SEND_SIGNAL(O, COMSIG_ARMOR_PLATED, amount, maxamount)
		to_chat(user, span_info("Закрепляю дополнительные бронепластины на [O]."))


/datum/component/armor_plate/proc/dropplates(datum/source, force)
	SIGNAL_HANDLER

	if(ismecha(parent)) //items didn't drop the plates before and it causes erroneous behavior for the time being with collapsible helmets
		for(var/i in 1 to amount)
			new upgrade_item(get_turf(parent))

/datum/component/armor_plate/proc/apply_mech_overlays(obj/vehicle/sealed/mecha/mech, list/overlays)
	SIGNAL_HANDLER

	if(amount)
		var/overlay_string = "ripley-g"
		if(amount >= 3)
			overlay_string += "-full"
		if(!LAZYLEN(mech.occupants))
			overlay_string += "-open"
		overlays += overlay_string

/datum/component/armor_plate/plasteel
	upgrade_item = /obj/item/stack/sheet/armor_plate/plasteel
	added_armor = list(MELEE = 10, WOUND = 5)
