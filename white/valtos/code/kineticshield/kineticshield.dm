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

/obj/item/kinetic_shield/examine(mob/user)
	. = ..()
	if(our_powercell)
		. += "<hr>"
		. += span_notice("<b>ЗАРЯД:</b> [our_powercell.percent()]%")

/obj/item/kinetic_shield/proc/update_charges(mob/user)
	if(ison && FLOOR(our_powercell?.charge/250, 1))
		if(!our_shield_component)
			our_shield_component = AddComponent(/datum/component/shielded, max_charges = FLOOR(our_powercell.charge/250, 1), recharge_start_delay = 0, lose_multiple_charges = TRUE, shield_inhand = TRUE)
			RegisterSignal(user, COMSIG_MOB_FIRED_GUN, .proc/check_genius)
			RegisterSignal(user, COMSIG_HUMAN_CHECK_SHIELDS, .proc/shield_reaction)
		else
			our_shield_component?.current_charges = FLOOR(our_powercell.charge/250, 1)
	else
		SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, user)
		ison = FALSE
		icon_state = "[base_icon_state][ison]"
		qdel(our_shield_component)
		our_shield_component = null
		UnregisterSignal(user, COMSIG_MOB_FIRED_GUN)
		UnregisterSignal(user, COMSIG_HUMAN_CHECK_SHIELDS)
		user.update_appearance()

/obj/item/kinetic_shield/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/stock_parts/cell))
		if(our_powercell)
			var/turf/T = get_turf(src)
			our_powercell.forceMove(T)
		attacking_item.forceMove(src)
		our_powercell = attacking_item
		update_charges(user)
		to_chat(user, span_notice("Тактически заменяю батарею."))
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		if(our_powercell)
			var/turf/T = get_turf(src)
			our_powercell.forceMove(T)
			to_chat(user, span_notice("Достаю батарею."))
			update_charges(user)

/obj/item/kinetic_shield/attack_hand(mob/user)
	if(loc == user)
		toggle(user)
		return
	. = ..()

/obj/item/kinetic_shield/MouseDrop(atom/over_object)
	. = ..()
	var/mob/M = usr

	if(ismecha(M.loc))
		return

	if(!M.incapacitated() && loc == M && istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over_object
		if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
			add_fingerprint(usr)

// this is fucking dumb
/obj/item/kinetic_shield/proc/check_genius(mob/user, obj/item/gun/gun_fired, target, params, zone_override)
	SIGNAL_HANDLER
	if(!ison || our_powercell?.charge < 250 || target == user)
		return
	INVOKE_ASYNC(gun_fired, /obj/item/gun.proc/process_fire, user, user, TRUE, params, zone_override)
	return COMSIG_GUN_FIRED_CANCEL

/obj/item/kinetic_shield/dropped(mob/user, silent)
	. = ..()
	ison = FALSE
	update_charges(user)

/obj/item/kinetic_shield/proc/toggle(mob/user)
	ison = !ison
	icon_state = "[base_icon_state][ison]"
	update_charges(user)
	if(ison && user)
		SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, ITEM_SLOT_BELT)

/obj/item/kinetic_shield/proc/shield_reaction(mob/living/carbon/human/owner, atom/movable/hitby, damage = 0, attack_text = "атаку", attack_type = MELEE_ATTACK, armour_penetration = 0)
	if(SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, owner, hitby, attack_text, 0, damage, attack_type) & COMPONENT_HIT_REACTION_BLOCK)
		our_powercell?.use(damage * 250)
		update_charges(owner)
		if(isprojectile(hitby))
			var/obj/projectile/P = hitby
			P.firer = A
			P.set_angle(rand(0, 360))
		return SHIELD_BLOCK
	return NONE

/obj/item/kinetic_shield/get_cell()
	return our_powercell
