/obj/item/gun/ballistic/automatic/HK416
	name = "Heckler & Koch HK416"
	desc = "Пост-бундесверовский автомат под калибр 5.56"
	icon = 'white/fogmann/sprites/hk416.dmi'
	icon_state = "hk416"
	inhand_icon_state = "hk416"
	selector_switch_icon = FALSE
	lefthand_file = 'white/fogmann/sprites/inhand_l.dmi'
	righthand_file = 'white/fogmann/sprites/inhand_r.dmi'
	worn_icon = 'white/fogmann/sprites/back.dmi'
	worn_icon_state = "416_back"
	mag_type = /obj/item/ammo_box/magazine/HK416
	pin = /obj/item/firing_pin
	fire_delay = 1
	auto_fire = FALSE
	slot_flags = ITEM_SLOT_BACK
	burst_size = 3
	empty_indicator = FALSE
	mag_display = TRUE
	spread = 1
	weapon_weight = WEAPON_HEAVY
	flags_1 = CONDUCT_1
	fire_sound = 'white/fogmann/Audio/HK416shot.ogg'
	rack_sound = 'white/fogmann/Audio/Chamberhk416.ogg'
	eject_sound = 'white/fogmann/Audio/mag_remove_hk.ogg'
	eject_empty_sound = 'white/fogmann/Audio/mag_remove_hk.ogg'
	load_sound = 'white/fogmann/Audio/mag_remove_hk.ogg'
	load_empty_sound = 'white/fogmann/Audio/mag_in_hk.ogg'
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/HK416/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/ballistic/automatic/HK416/update_icon_state()
	. = ..()
	inhand_icon_state = "[initial(icon_state)][magazine ? "":"_e"]"

//hk416
/obj/item/ammo_box/magazine/HK416
	name = "stanag магазин с патронами M856"
	icon = 'white/fogmann/sprites/hk416.dmi'
	icon_state = "stanag"
	ammo_type = /obj/item/ammo_casing/m856x556
	caliber = "5.56"
	max_ammo = 30

/obj/item/ammo_box/magazine/HK416/ap
	name = "stanag магазин с патронами M995"
	icon = 'white/fogmann/sprites/hk416.dmi'
	icon_state = "stanag"
	ammo_type = /obj/item/ammo_casing/m995x556
	caliber = "5.56"
	max_ammo = 30

//5.56
/obj/item/ammo_casing/m856x556
	name = "гильза 5.56 m856"
	caliber = "5.56"
	projectile_type = /obj/projectile/bullet/m856x556

/obj/item/ammo_casing/m995x556
	name = "гильза 5.56 m995"
	caliber = "5.56"
	projectile_type = /obj/projectile/bullet/m995x556


/obj/projectile/bullet/m856x556
	name = "пуля"
	damage = 23
	armour_penetration = 20
	wound_bonus = 4

/obj/projectile/bullet/m995x556
	name = "пуля"
	damage = 20
	armour_penetration = 60
	wound_bonus = -5

