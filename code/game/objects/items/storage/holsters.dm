
/obj/item/storage/belt/holster
	name = "пистолетная кобура"
	desc = "Довольно простая, но все равно классно выглядящая кобура, в которую можно поместить пистолет."
	icon_state = "holster"
	inhand_icon_state = "holster"
	worn_icon_state = "holster"
	alternate_worn_layer = UNDER_SUIT_LAYER
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/holster/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_BELT || ITEM_SLOT_SUITSTORE)
		ADD_TRAIT(user, TRAIT_GUNFLIP, CLOTHING_TRAIT)

/obj/item/storage/belt/holster/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_GUNFLIP, CLOTHING_TRAIT)

/obj/item/storage/belt/holster/Initialize()
	. = ..()
	atom_storage.max_slots = 2
	atom_storage.max_total_storage = 16
	atom_storage.set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/dueling,
		/obj/item/food/grown/banana,
		/obj/item/gun/energy/laser/thermal
		))

/obj/item/storage/belt/holster/thermal
	name = "кобура парных нанопистолетов"
	desc = "Специальная двойная кобура для дуальных термальных нанопистолетов. Здесь есть специальные ремни для крепления на бронежилетах."
	icon = 'white/Feline/icons/blaster_belt.dmi'
	icon_state = "belt"

/obj/item/storage/belt/holster/thermal/attack_hand(mob/user, list/modifiers)

	if(loc == user)
		if(user.get_item_by_slot(ITEM_SLOT_BELT) == src || user.get_item_by_slot(ITEM_SLOT_SUITSTORE) == src)
			if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE, FLOOR_OKAY))
				return
			if(length(contents))
				var/obj/item/I = contents[1]
				user.visible_message(span_notice("[user] достаёт из кобуры [I]."), span_notice("Достаю из кобуры [I]."))
				user.put_in_hands(I)
				update_appearance()
//				playsound(user, 'white/valtos/sounds/lasercock.wav', 80, TRUE)
				return
			else
				to_chat(user, span_warning("Кобура пуста!"))
	else ..()
	return

/obj/item/storage/belt/holster/thermal/update_icon_state()
	cut_overlays()
	if(locate(/obj/item/gun/energy/laser/thermal/inferno) in contents)
		add_overlay("red")
	if(locate(/obj/item/gun/energy/laser/thermal/cryo) in contents)
		add_overlay("blue")
	return ..()

/obj/item/storage/belt/holster/thermal/Initialize()
	. = ..()
	atom_storage.max_slots = 2
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.set_holdable(list(
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/dueling,
		/obj/item/food/grown/banana,
		/obj/item/gun/energy/laser/thermal
		))

/obj/item/storage/belt/holster/thermal/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/energy/laser/thermal/inferno = 1,
		/obj/item/gun/energy/laser/thermal/cryo = 1,
	),src)


/obj/item/storage/belt/holster/detective
	name = "пистолетная кобура"
	desc = "Качественная кобура, в которую можно поместить пистолет и пару скорозарядников."
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/holster/detective/Initialize()
	. = ..()
	atom_storage.max_slots = 3
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/ammo_box/magazine/m9mm, // Pistol magazines.
		/obj/item/ammo_box/magazine/m9mm_aps,
		/obj/item/ammo_box/magazine/m45,
		/obj/item/ammo_box/magazine/m50,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box/c38, // Revolver speedloaders.
		/obj/item/ammo_box/a357,
		/obj/item/ammo_box/a762,
		/obj/item/ammo_box/magazine/toy/pistol,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/dueling,
		/obj/item/gun/energy/laser/thermal
		))

/obj/item/storage/belt/holster/detective/full/PopulateContents()
	var/static/items_inside = list(
		/obj/item/gun/ballistic/revolver/detective = 1,
		/obj/item/ammo_box/c38 = 2)
	generate_items_inside(items_inside,src)

/obj/item/storage/belt/holster/detective/full/ert
	name = "кобура СОБРа"
	desc = "Надев это, вы чувствуете себя крутым, но подозреваете, что это всего лишь перекрашенная кобура детектива со складов NT."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/belt/holster/detective/full/ert/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
		/obj/item/ammo_box/magazine/m45 = 2,
	),src)

/obj/item/storage/belt/holster/chameleon
	name = "кобура синдиката"
	desc = "Набедренная кобура, использующая технологию \"хамелеон\" для маскировки, в ней могут храниться пистолеты и патроны к ним."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/storage/belt/holster/chameleon/Initialize(mapload)
	. = ..()

	chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/storage/belt
	chameleon_action.chameleon_name = "Belt"
	chameleon_action.initialize_disguises()

/obj/item/storage/belt/holster/chameleon/Initialize()
	. = ..()
	atom_storage.silent = TRUE

/obj/item/storage/belt/holster/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/storage/belt/holster/chameleon/broken/Initialize(mapload)
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/storage/belt/holster/chameleon/Initialize()
	. = ..()
	atom_storage.max_slots = 3
	atom_storage.max_total_storage = WEIGHT_CLASS_NORMAL
	atom_storage.set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/ammo_box/magazine/m9mm,
		/obj/item/ammo_box/magazine/m9mm_aps,
		/obj/item/ammo_box/magazine/m45,
		/obj/item/ammo_box/magazine/m50,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box/c38,
		/obj/item/ammo_box/a357,
		/obj/item/ammo_box/a762,
		/obj/item/ammo_box/magazine/toy/pistol,
		/obj/item/gun/energy/kinetic_accelerator/crossbow,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/dueling
		))

/obj/item/storage/belt/holster/nukie
	name = "оперативная кобура"
	desc = "Наплечная кобура, способная вместить практически любой вид огнестрельного оружия и патроны к нему."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/holster/nukie/Initialize()
	. = ..()
	atom_storage.max_slots = 3
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.set_holdable(list(
		/obj/item/gun, // ALL guns.
		/obj/item/ammo_box/magazine, // ALL magazines.
		/obj/item/ammo_box/c38, //There isn't a speedloader parent type, so I just put these three here by hand.
		/obj/item/ammo_box/a357, //I didn't want to just use /obj/item/ammo_box, because then this could hold huge boxes of ammo.
		/obj/item/ammo_box/a762,
		/obj/item/ammo_casing, // For shotgun shells, rockets, launcher grenades, and a few other things.
		/obj/item/grenade, // All regular grenades, the big grenade launcher fires these.
		))
