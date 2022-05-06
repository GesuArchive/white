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

/obj/item/kinetic_shield/Initialize()
	. = ..()
	our_powercell = new /obj/item/stock_parts/cell/high(src)

/obj/item/kinetic_shield/examine(mob/user)
	. = ..()
	if(our_powercell)
		. += "<hr>"
		. += span_notice("<b>ЗАРЯД:</b> [our_powercell.percent()]%")

/obj/item/kinetic_shield/equipped(mob/user, slot, initial)
	. = ..()
	RegisterSignal(user, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/on_update_overlays)
	RegisterSignal(user, COMSIG_HUMAN_CHECK_SHIELDS,  .proc/on_shields)
	RegisterSignal(user, COMSIG_MOB_FIRED_GUN, 		  .proc/on_gun_fired)

	update_appearance(UPDATE_ICON)
	user.update_appearance(UPDATE_ICON)

/obj/item/kinetic_shield/dropped(mob/user, silent)
	. = ..()
	ison = FALSE

	update_appearance(UPDATE_ICON)
	user.update_appearance(UPDATE_ICON)

	UnregisterSignal(user, list(COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_HUMAN_CHECK_SHIELDS, COMSIG_MOB_FIRED_GUN))

/obj/item/kinetic_shield/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][ison]"

/obj/item/kinetic_shield/proc/on_update_overlays(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER
	if(ison)
		overlays += mutable_appearance('icons/effects/effects.dmi', "shield-old", MOB_SHIELD_LAYER)

/obj/item/kinetic_shield/proc/on_gun_fired(mob/user, obj/item/gun/gun_fired, target, params, zone_override)
	SIGNAL_HANDLER
	if(!ison || our_powercell?.charge < 250 || target == user)
		return
	INVOKE_ASYNC(gun_fired, /obj/item/gun.proc/process_fire, user, user, TRUE, params, zone_override)
	return COMSIG_GUN_FIRED_CANCEL

/obj/item/kinetic_shield/attack_hand(mob/user)
	if(loc == user)
		playsound(src, 'sound/magic/charge.ogg', 50, TRUE)
		ison = !ison
		update_appearance(UPDATE_ICON)
		user.update_appearance(UPDATE_ICON)
		if(ison)
			START_PROCESSING(SSobj, src)
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

/obj/item/kinetic_shield/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/stock_parts/cell))
		if(our_powercell)
			var/turf/T = get_turf(src)
			our_powercell.forceMove(T)
		attacking_item.forceMove(src)
		our_powercell = attacking_item
		to_chat(user, span_notice("Тактически заменяю батарею."))
		check_charge()
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		if(our_powercell)
			var/turf/T = get_turf(src)
			our_powercell.forceMove(T)
			to_chat(user, span_notice("Достаю батарею."))
			check_charge()

/obj/item/kinetic_shield/process(delta_time)
	if(!ison)
		return PROCESS_KILL
	our_powercell?.use(10)
	check_charge()

/obj/item/kinetic_shield/proc/on_shields(atom/movable/A, damage)
	SIGNAL_HANDLER
	if(ison && isprojectile(A) && our_powercell?.charge >= 250)
		var/obj/projectile/P = A
		A.visible_message(span_danger("Щит <b>[loc]</b> отражает [A.name]!"), span_userdanger("Щит отражает [A.name]!"))
		P.firer = A
		P.set_angle(P.Angle + rand(120, 240))
		our_powercell?.use(damage * 250)
		check_charge()

/obj/item/kinetic_shield/proc/check_charge()
	if(ison && our_powercell?.charge <= 50)
		ison = FALSE
		update_appearance(UPDATE_ICON)
		if(loc && ismob(loc))
			var/mob/M = loc
			M.update_appearance(UPDATE_ICON)

/obj/item/kinetic_shield/get_cell()
	return our_powercell
