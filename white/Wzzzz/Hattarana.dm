/obj/item/clothing/under/jensen
	name = "jensen jumpsuit"
	desc = "I asked for this."
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "jensen"
	inhand_icon_state = "jensen"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20,"energy" = 20, "bomb" = 20, "bio" = 20, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/suit/toggle/hawaii
	name = "hawai skirt"
	desc = "Shorts! Shirt! Miami! Sexy!"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "hawaii"
	inhand_icon_state = "hawaii"

/obj/item/gun/ballistic/automatic/assault_rifle
	name = "assault rifle"
	desc = "Standart assault rifle."
	icon = 'white/Wzzzz/icons/Weea.dmi'
	icon_state = "arifle"
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_guns.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_guns.dmi'
	burst_size = 3
	inhand_icon_state = "arifle"
	w_class = 4
	force = 10
	fire_delay = 2
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/assault_rifle
	can_suppress = FALSE
	can_bayonet = FALSE
	fire_sound = 'white/Wzzzz/gunshot3z.ogg'

/obj/item/ammo_box/magazine/assault_rifle
	name = "assault rifle magazine"
	icon_state = "assault_rifle"
	caliber = "asr"
	ammo_type = /obj/item/ammo_casing/assault_rifle
	icon = 'white/Wzzzz/icons/ammo.dmi'
	max_ammo = 25
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_casing/assault_rifle
	desc = "Assault rifle bullet casing."
	caliber = "asr"
	projectile_type = /obj/projectile/bullet/assault_rifle

/obj/projectile/bullet/assault_rifle
	damage = 30
	armour_penetration = 25

/obj/item/clothing/suit/toggle/brown_jacket
	name = "brown jacket"
	desc = "Brown jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "brown_jacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "brown_jacket"

/obj/item/clothing/mask/skull
	name = "skull mask"
	desc = "Life is full of cruel. That's one of examples."
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "skull_mask"
	inhand_icon_state = "skull_mask"
	armor = list("melee" = 35, "bullet" = 25, "laser" = 25,"energy" = 35, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	flags_inv = HIDEFACE
	visor_flags_inv = HIDEFACE
	force = 5
	throwforce = 3

/obj/item/clothing/suit/armor/vest/leather/tailcoat
	name = "tail coat"
	desc = "Stylish armored coat."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "tailcoat"
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 15)
	inhand_icon_state = "tailcoat"

/obj/item/clothing/suit/armor/vest/leather/tailcoat/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 2
	atom_storage.max_total_storage = 5
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL

/obj/item/clothing/suit/armor/vest/leather/tailcoat/black
	icon_state = "tailcoatb"
	inhand_icon_state = "tailcoatb"

/obj/item/storage/belt/machete
	name = "machete belt"
	desc = "Belt for machete."
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 5, "energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	icon_state = "machetebelt"
	inhand_icon_state = "machetebelt"

/obj/item/storage/belt/machete/Initialize()
	. = ..()
	atom_storage.max_slots = 1
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 4
	atom_storage.set_holdable(list(/obj/item/kitchen/knife/butcher/machete))

/obj/item/clothing/under/victorian
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	name = "victorian uniform"
	can_adjust = FALSE
	desc = "From old times."
	has_sensor = NO_SENSORS

/obj/item/clothing/under/victorian/blred
	icon_state = "victorianblred"
	inhand_icon_state = "victorianblred"


/obj/item/clothing/under/victorian/vest
	icon_state = "victorianvest"
	inhand_icon_state = "victorianvest"

/obj/item/clothing/under/victorian/redvest
	icon_state = "victorianredvest"
	inhand_icon_state = "victorianredvest"

/obj/item/clothing/under/victorian/blackdress
	icon_state = "victorianblackdress"
	inhand_icon_state = "victorianblackdress"
	body_parts_covered = CHEST|GROIN
	name = "victorian dress"
	desc = "Like true lady"

/obj/item/clothing/under/victorian/reddress
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "victorianreddress"
	inhand_icon_state = "victorianreddress"
	body_parts_covered = CHEST|GROIN
	name = "victorian dress"
	can_adjust = FALSE
	desc = "Like true lady"

/obj/item/storage/toolbox/ammo/wt550

/obj/item/storage/toolbox/ammo/wt550/PopulateContents()
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)

/datum/supply_pack/security/trau_a
	name = "Traumatic Pistol Ammo Crate"
	desc = "Contains a four 8-round magazines for \"Enforcer\" traumatic pistol. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic)
