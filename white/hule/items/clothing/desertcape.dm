
//////////////////////////////////////Cape//////////////////////////////////////////////////

/obj/item/storage/desertcape
	name = "desert cape"
	desc = "No, it's not a raincoat"
	icon = 'white/hule/clothing/capes.dmi'
	alternate_worn_icon = 'white/hule/clothing/capes.dmi'
	icon_state = "desertcape"
	inhand_icon_state = "desertcape"
	slot_flags = SLOT_NECK
	w_class = WEIGHT_CLASS_BULKY
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|NECK|HANDS

	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	resistance_flags = FIRE_PROOF

	max_integrity = 500

	actions_types = list(/datum/action/item_action/dash)
	var/staminarequired = 10
	var/distance = 8
	var/speed = 1
	var/active = FALSE
	var/list/stored_items = list()

/obj/item/storage/desertcape/ComponentInitialize()
	. = ..()
	GET_COMPONENT(STR, /datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 21

/obj/item/storage/desertcape/ui_action_click(mob/living/carbon/user, action)
	if(!isliving(user))
		return
	if(user.staminaloss > 80)
		to_chat(user, span_warning("You are too tierd!"))
		return

	var/atom/target = get_edge_target_turf(user, user.dir)

	if(user.throw_at(target, distance, speed, spin = FALSE, diagonals_first = TRUE))
		active = TRUE
		if(active)
			for(var/obj/item/I in user.held_items)
				if(!(I.has_trait(TRAIT_NODROP)))
					stored_items += I
		var/list/L = user.get_empty_held_indexes()
		if(LAZYLEN(L) == user.held_items.len)
			stored_items = list()
		else
			for(var/obj/item/I in stored_items)
				I.add_trait(TRAIT_NODROP)
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, 1)
		user.visible_message(span_warning("[usr] dashes forward!"))
		user.throw_at(target, distance, speed, spin = FALSE, diagonals_first = TRUE)
		user.Knockdown(10)
		user.spin(10,1)
		addtimer(CALLBACK(src, .proc/dash_end), 11)
		user.adjustStaminaLoss(staminarequired)


/obj/item/storage/desertcape/proc/dash_end()
	active = FALSE

	if(!active)
		for(var/obj/item/I in stored_items)
			I.remove_trait(TRAIT_NODROP)
		stored_items = list()

/datum/action/item_action/dash
	name = "Dash!"
	icon_icon = 'icons/mob/actions/actions_flightsuit.dmi'
	button_icon_state = "flightpack_boost"


/obj/item/storage/desertcape/full/PopulateContents()
	new /obj/item/kitchen/knife/combat(src)

	for(var/i in 1 to 8)
		new /obj/item/ammo_casing/shotgun/buckshot(src)
	for(var/i in 1 to 4)
		new /obj/item/ammo_casing/shotgun/frag12(src)


