//Бронелисты из Плистали

/datum/component/armor_plate_plasteel
	var/amount = 0
	var/maxamount = 3
	var/upgrade_item = /obj/item/stack/sheet/plasteel_armor_plate
	var/datum/armor/added_armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 13, BOMB = 10)
	var/upgrade_name

/datum/component/armor_plate_plasteel/Initialize(_maxamount,obj/item/_upgrade_item,datum/armor/_added_armor)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/examine)
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/applyplate)
//	RegisterSignal(parent, COMSIG_PARENT_PREQDELETED, .proc/dropplates)
//	if(istype(parent, /obj/vehicle/sealed/mecha/working/ripley))
//		RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/apply_mech_overlays)

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


//Осмотр
/datum/component/armor_plate_plasteel/proc/examine(datum/source, mob/user, list/examine_list)
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

//Усиление
/datum/component/armor_plate_plasteel/proc/applyplate(datum/source, obj/item/I, mob/user, params)
	SIGNAL_HANDLER

	if(!istype(I,upgrade_item))
		return
	if(amount >= maxamount)
		to_chat(user, span_warning("Дальнейшее улучшение [parent] невозможно!"))
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
		to_chat(user, span_info("Вы усилили показатели защиты [R]."))
	else
		SEND_SIGNAL(O, COMSIG_ARMOR_PLATED, amount, maxamount)
		to_chat(user, span_info("Вы усилили показатели защиты [O] от основных типов урона."))

/datum/crafting_recipe/plasteel_armor_plate
	name = "бронепластина из пластали"
	result =  /obj/item/stack/sheet/plasteel_armor_plate
	time = 80
	reqs = list(/obj/item/stack/sheet/plasteel = 10)
	tool_behaviors = list(TOOL_WELDER)
	category = CAT_PRIMAL

/obj/item/stack/sheet/plasteel_armor_plate
	name = "бронепластина из пластали"
	singular_name = "бронепластина из пластали"
	desc = "Самодельный броневой лист грубо вырезанный из листа пластали, напоминает поделки рейнджеров НКР"
	icon = 'white/Feline/icons/armor_plate.dmi'
	icon_state = "plasteel_armor_plate"
	max_amount = 6
	merge_type = /obj/item/stack/sheet/plasteel_armor_plate



/*
/datum/component/armor_plate_plasteel/proc/dropplates(datum/source, force)
	SIGNAL_HANDLER

	if(ismecha(parent)) //items didn't drop the plates before and it causes erroneous behavior for the time being with collapsible helmets
		for(var/i in 1 to amount)
			new upgrade_item(get_turf(parent))

/datum/component/armor_plate_plasteel/proc/apply_mech_overlays(obj/vehicle/sealed/mecha/mech, list/overlays)
	SIGNAL_HANDLER

	if(amount)
		var/overlay_string = "ripley-g"
		if(amount >= 3)
			overlay_string += "-full"
		if(!LAZYLEN(mech.occupants))
			overlay_string += "-open"
		overlays += overlay_string
*/

