/obj/item/kinetic_shield
	name = "кинетический щит"
	desc = "Отражает все попадающие в поле снаряды, однако имеет ограниченный заряд. Надпись на обороте гласит: <b>Внимание! Перед применением оружия дальнего боя щит необходимо отключить во избежание непредвиденных обстоятельств.</b>"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "kinetic0"
	base_icon_state = "kinetic"
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	worn_icon_state = "cloak"
	inhand_icon_state = "assaultbelt"
	slot_flags = ITEM_SLOT_BELT
	var/ison = FALSE
	var/obj/item/stock_parts/cell/our_powercell = null
	var/datum/component/shielded/our_shield_component = null

/obj/item/kinetic_shield/Initialize()
	. = ..()
	our_powercell = new /obj/item/stock_parts/cell/high(src)
	update_charges()

/obj/item/kinetic_shield/examine(mob/user)
	. = ..()
	if(our_powercell)
		. += "<hr>"
		. += span_notice("<b>ЗАРЯД:</b> [our_powercell.percent()]%")

/obj/item/kinetic_shield/proc/update_charges()
	if(ison && our_powercell)
		if(!our_shield_component)
			our_shield_component = AddComponent(/datum/component/shielded, max_charges = FLOOR(our_powercell.charge/250, 1), recharge_start_delay = 0, lose_multiple_charges = TRUE, run_hit_callback = CALLBACK(src, .proc/shield_damaged))
		else
			our_shield_component?.current_charges = FLOOR(our_powercell.charge/250, 1)
	else
		ison = FALSE
		qdel(our_shield_component)
		our_shield_component = null

/obj/item/kinetic_shield/proc/shield_damaged(mob/living/wearer, attack_text, new_current_charges)
	our_powercell.use(our_shield_component?.current_charges - new_current_charges)
	update_charges()
	wearer.visible_message(span_danger("Кинетический щит [wearer] отражает [attack_text]!"))
	if(new_current_charges <= 0)
		wearer.visible_message(span_danger("Кинетический щит [wearer] отключается!"))

/obj/item/kinetic_shield/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/stock_parts/cell))
		if(our_powercell)
			var/turf/T = get_turf(src)
			our_powercell.forceMove(T)
		attacking_item.forceMove(src)
		our_powercell = attacking_item
		update_charges()
		to_chat(user, span_notice("Тактически заменяю батарею."))
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		if(our_powercell)
			var/turf/T = get_turf(src)
			our_powercell.forceMove(T)
			to_chat(user, span_notice("Достаю батарею."))

/obj/item/kinetic_shield/attack_hand(mob/user)
	if(loc == user)
		toggle()
		return
	. = ..()

/obj/item/kinetic_shield/equipped(mob/user, slot, initial)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_FIRED_GUN, .proc/check_genius)

// this is fucking dumb
/obj/item/kinetic_shield/proc/check_genius(mob/user, obj/item/gun/gun_fired, target, params, zone_override)
	SIGNAL_HANDLER
	if(!ison)
		return
	if(target == user)
		return
	INVOKE_ASYNC(gun_fired, /obj/item/gun.proc/process_fire, user, user, TRUE, params, zone_override)
	return COMSIG_GUN_FIRED_CANCEL

/obj/item/kinetic_shield/dropped(mob/user, silent)
	if(ison)
		toggle()
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_FIRED_GUN)

/obj/item/kinetic_shield/proc/toggle()
	ison = !ison
	update_charges()

/obj/item/kinetic_shield/get_cell()
	return our_powercell
