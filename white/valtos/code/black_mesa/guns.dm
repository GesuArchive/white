/obj/item/gun/ballistic/automatic/laser/marksman // Cheap replacement for a gauss rifle.
	name = "designated marksman rifle"
	desc = "A special laser beam sniper rifle designed by a certain now defunct research facility."
	icon_state = "ctfmarksman"
	inhand_icon_state = "ctfmarksman"
	auto_fire = FALSE
	mag_type = /obj/item/ammo_box/magazine/recharge/marksman
	force = 15
	weapon_weight = WEAPON_HEAVY
	fire_delay = 4 SECONDS
	fire_sound = 'white/valtos/sounds/black_mesa/guns/chaingun_fire.ogg'

/obj/item/gun/ballistic/automatic/laser/marksman/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

/obj/item/ammo_box/magazine/recharge/marksman
	ammo_type = /obj/item/ammo_casing/caseless/laser/marksman
	max_ammo = 5

/obj/item/ammo_casing/caseless/laser/marksman
	projectile_type = /obj/projectile/beam/marksman

/obj/item/ammo_casing/caseless/laser/marksman/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/delete_on_drop)

/obj/projectile/beam/marksman
	name = "laser beam"
	damage = 70
	armour_penetration = 30
	hitscan = TRUE
	icon_state = "gaussstrong"

/obj/item/gun/ballistic/automatic/mp5
	name = "\improper MP5"
	desc = "An old SMG, this one is chambered in 9mm, a very common and powerful cartridge. It has Heckler & Koch etched above the magazine well."
	icon = 'white/valtos/icons/black_mesa/gunsgalore_guns40x32.dmi'
	lefthand_file = 'white/valtos/icons/black_mesa/gunsgalore_lefthand.dmi'
	righthand_file ='white/valtos/icons/black_mesa/gunsgalore_righthand.dmi'
	icon_state = "mp5"
	inhand_icon_state = "mp5"
	selector_switch_icon = TRUE
	mag_type = /obj/item/ammo_box/magazine/mp5
	bolt_type = BOLT_TYPE_LOCKING
	can_suppress = TRUE
	burst_size = 3
	fire_delay = 1.25
	spread = 2.5
	mag_display = TRUE
	load_sound = 'white/valtos/sounds/black_mesa/guns/mp5_magin.ogg'
	load_empty_sound = 'white/valtos/sounds/black_mesa/guns/mp5_magin.ogg'
	rack_sound = 'white/valtos/sounds/black_mesa/guns/mp5_cock.ogg'
	lock_back_sound = 'white/valtos/sounds/black_mesa/guns/mp5_boltback.ogg'
	eject_sound = 'white/valtos/sounds/black_mesa/guns/mp5_magout.ogg'
	eject_empty_sound = 'white/valtos/sounds/black_mesa/guns/mp5_magout.ogg'
	bolt_drop_sound = 'white/valtos/sounds/black_mesa/guns/mp5_boltforward.ogg'
	fire_sound = 'white/valtos/sounds/black_mesa/guns/mp5_fire.ogg'
	suppressed_sound = 'white/valtos/sounds/black_mesa/guns/mp5_fire_suppressed.ogg'
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/mp5
	name = "MP5 magazine (9mm)"
	desc = "Magazines taking 9mm ammunition; it fits in the MP5."
	icon = 'white/valtos/icons/black_mesa/gunsgalore_items.dmi'
	icon_state = "mp5"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 30
	multiple_sprites = 3
