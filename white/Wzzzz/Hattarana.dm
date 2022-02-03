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
/*

/obj/item/clothing/neck/stripedgreenscarf/black
	name = "striped black scarf"
	icon_state = "stripedblackscarf"
	inhand_icon_state = "stripedblackscarf"
	custom_price = 25
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon = 'white/Wzzzz/clothing/ties.dmi'
*/
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

/*
/obj/item/clothing/neck/stripedgreenscarf/grey
	name = "striped grey scarf"
	icon_state = "stripedgreyscarf"
	inhand_icon_state = "stripedgreyscarf"
	custom_price = 25
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon = 'white/Wzzzz/clothing/ties.dmi'
*/
/obj/item/clothing/suit/armor/vest/leather/tailcoat
	name = "tail coat"
	desc = "Stylish armored coat."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "tailcoat"
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 15)
	inhand_icon_state = "tailcoat"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets

/datum/component/storage/concrete/pockets/tailcoat/Initialize()
	. = ..()
	max_items = 2
	max_combined_w_class = 5
	max_w_class = WEIGHT_CLASS_NORMAL

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

/obj/item/storage/belt/machete/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 4
	STR.set_holdable(list(/obj/item/kitchen/knife/butcher/machete))

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






//зерги верги идет на хуй
/*
/obj/structure/chair/wood
	icon = 'white/Wzzzz/clothing/head.dmi'

/obj/structure/chair/wood/red
	icon_state = "wooden_chair_red"


*/



// get rekt drop dead pop a knot fuck off

/*
/obj/item/clothing/head/helmet/siegehelmet
	name = "siege helmet"
	desc = "Stylish deutch helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "siege_helmet"
	inhand_icon_state = "siege_helmet"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR
	resistance_flags = NONE
	armor = list("melee" = 60, "bullet" = 35, "laser" = 25,"energy" = 20, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20)


/obj/item/clothing/head/helmet/rig0sec
	name = "heavy security helmet"
	desc = "Stylish deutch helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "rig0sec"
	inhand_icon_state = "rig0sec"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	resistance_flags = NONE|ACID_PROOF
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT
	armor = list("melee" = 60, "bullet" = 70, "laser" = 50,"energy" = 50, "bomb" = 60, "bio" = 50, "rad" = 50, "fire" = 60, "acid" = 50)
	flash_protect = 2

/obj/item/clothing/head/helmet/emergencyhelmet
	name = "emergency Helmet"
	desc = "Not ugly, just unusual."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "emergencyhelm"
	inhand_icon_state = "emergencyhelm"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	clothing_flags = STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	armor = list("melee" = 40, "bullet" = 25, "laser" = 20,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)

/obj/item/clothing/head/helmet/voxstealth
	name = "Скрытность helmet"
	desc = "Not for humans, but looks great"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "voxstealth"
	inhand_icon_state = "voxstealth"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE|ACID_PROOF
	armor = list("melee" = 30, "bullet" = 20, "laser" = 40,"energy" = 30, "bomb" = 20, "bio" = 50, "rad" = 20, "fire" = 20, "acid" = 80)
	flash_protect = 1

/obj/item/clothing/head/helmet/rig0syndieskrell
	name = "syndicate helmet skrell"
	desc = "Not for humans, but looks great"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "rig0syndieskrell"
	inhand_icon_state = "rig0syndieskrell"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	armor = list("melee" = 45, "bullet" = 60, "laser" = 30,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 50)

/obj/item/clothing/head/helmet/rig0syndieunathi
	name = "syndicate helmet unathi"
	desc = "Not for humans, but looks great"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "rig0syndieunathi"
	inhand_icon_state = "rig0syndieunathi"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	armor = list("melee" = 45, "bullet" = 60, "laser" = 30,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 50)

/obj/item/clothing/head/helmet/rig0syndietaj
	name = "syndicate helmet tajare"
	desc = "Not for humans, but looks great"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "rig0syndietaj"
	inhand_icon_state = "rig0syndietaj"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	armor = list("melee" = 45, "bullet" = 60, "laser" = 30,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 50)

/obj/item/clothing/head/helmet/swathelm
	name = "swat helmet"
	desc = "Helmet for SWAT"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "swathelm"
	inhand_icon_state = "swathelm"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)

/obj/item/clothing/head/wizard/amp
	name = "amp"
	desc = "Something strange"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "amp"
	inhand_icon_state = "amp"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT|STOPSPRESSUREDAMAGE
	resistance_flags = NONE|ACID_PROOF|INDESTRUCTIBLE|UNACIDABLE
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 0, "acid" = 100)

/obj/item/clothing/head/helmet/helmetold1
	name = "old helmet"
	desc = "Nostalgy"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	lefthand_file = 'white/Wzzzz/clothing/inhand/lefthand_hats.dmi'
	righthand_file = 'white/Wzzzz/clothing/inhand/righthand_hats.dmi'
	icon_state = "helmetold1"
	inhand_icon_state = "helmetold1"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/mask/gas/stealth_rig
	name = "Скрытность mask"
	body_parts_covered = HEAD
	var/lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	var/darkness_view = 10
	desc = "Looks like something for shadow stealth"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "stealth_rig"
	flash_protect = 2
	slot_flags = ITEM_SLOT_MASK
	resistance_flags = NONE
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	var/invis_view = 25
	var/invis_override = 0
	var/list/icon/current = list()
	var/vision_correction = 0
	var/glass_colour_type
	inhand_icon_state = "stealth_rig"
	flags_cover = HEADCOVERSMOUTH | PEPPERPROOF | HEADCOVERSEYES | GLASSESCOVERSEYES | MASKCOVERSEYES | MASKCOVERSMOUTH
	visor_flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	flags_inv = HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEHAIR
	visor_flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDEHAIR|HIDEEARS
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	dynamic_hair_suffix = ""
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_fhair_suffix = ""
	armor = list("melee" = 10, "bullet" = 20, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 5, "rad" = 0, "fire" = 10, "acid" = 5)

/obj/item/clothing/head/helmet/breacher_rig_cheap
	name = "breacher helmet cheap"
	desc = "Looks good for dark persons"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "breacher_rig_cheap"
	inhand_icon_state = "breacher_rig_cheap"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	resistance_flags = NONE|ACID_PROOF
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1

/obj/item/clothing/head/helmet/breacher_rig
	name = "breacher helmet"
	desc = "Looks good for dark persons"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "breacher_rig"
	inhand_icon_state = "breacher_rig"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = NONE|ACID_PROOF|FREEZE_PROOF|LAVA_PROOF
	armor = list("melee" = 80, "bullet" = 65, "laser" = 55,"energy" = 35, "bomb" = 75, "bio" = 25, "rad" = 10, "fire" = 75, "acid" = 100)
	flash_protect = 3

/obj/item/clothing/head/helmet/asset_protection_rig
	name = "protection helmet"
	desc = "Yes, that protect you"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "asset_protection_rig"
	inhand_icon_state = "asset_protection_rig"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR
	resistance_flags = NONE
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	armor = list("melee" = 60, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 35, "bio" = 10, "rad" = 0, "fire" = 55, "acid" = 50)

/obj/item/clothing/head/helmet/hazard_rig
	name = "hazard helmet"
	desc = "For...maybe, for hazard"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "hazard_rig"
	inhand_icon_state = "hazard_rig"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEHAIR|HIDEEYES|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEHAIR|HIDEEYES|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = NONE|ACID_PROOF|FREEZE_PROOF
	armor = list("melee" = 60, "bullet" = 50, "laser" = 45,"energy" = 20, "bomb" = 65, "bio" = 25, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 2

/obj/item/clothing/head/helmet/helmetoldup
	name = "old helmet black"
	desc = "Black helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmetoldup1"
	inhand_icon_state = "helmetoldup1"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	clothing_flags = STOPSPRESSUREDAMAGE
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/swatoldup
	name = "old SWAT helmet"
	desc = "Old black SWAT helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "swatoldup"
	inhand_icon_state = "swatoldup"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/medicalalt_helm
	name = "medical helmet"
	desc = "Helmet for medics"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "medicalalt_helm"
	inhand_icon_state = "medicalalt_helm"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK|HIDEGLOVES|HIDESHOES
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEGLOVES|HIDESHOES
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	clothing_flags = STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/secalt_helm
	name = "hard security helmet"
	desc = "Harder, Better, Faster, Stronger"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "secalt_helm"
	inhand_icon_state = "secalt_helm"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	armor = list("melee" = 55, "bullet" = 45, "laser" = 30,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	flash_protect = 1

/obj/item/clothing/head/helmet/helmet_reflect
	name = "hard security helmet"
	desc = "Harder, Better, Faster, Stronger"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_reflect"
	inhand_icon_state = "helmet_reflect"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	armor = list("melee" = 30, "bullet" = 20, "laser" = 90,"energy" = 70, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/salvage_helm
	name = "salvage helmet"
	desc = "Salvage helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "salvage_helm"
	inhand_icon_state = "salvage_helm"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = NONE
	armor = list("melee" = 60, "bullet" = 50, "laser" = 30,"energy" = 5, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)

/obj/item/clothing/head/welding/knightwelding
	name = "welding mask knight"
	desc = "Here was artist"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "knightwelding"
	inhand_icon_state = "knightwelding"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEEARS|HIDEFACE
	visor_flags_inv = HIDEEARS|HIDEFACE
	armor = list("melee" = 40, "bullet" = 20, "laser" = 10,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	flash_protect = 2
	tint = 2

/obj/item/clothing/head/welding/engiewelding
	name = "welding mask engie"
	desc = "Here was artist"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "engiewelding"
	inhand_icon_state = "engiewelding"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEEARS|HIDEFACE
	visor_flags_inv = HIDEEARS|HIDEFACE
	armor = list("melee" = 40, "bullet" = 20, "laser" = 10,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	flash_protect = 2
	tint = 2

/obj/item/clothing/head/welding/demonwelding
	name = "welding mask demon"
	desc = "Here was artist"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "demonwelding"
	inhand_icon_state = "demonwelding"
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEEARS|HIDEFACE
	visor_flags_inv = HIDEEARS|HIDEFACE
	armor = list("melee" = 40, "bullet" = 20, "laser" = 10,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	flash_protect = 2
	tint = 2

/obj/item/clothing/head/welding/fancywelding
	name = "welding mask fancy"
	desc = "Here was artist"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "fancywelding"
	inhand_icon_state = "fancywelding"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEEARS|HIDEFACE
	visor_flags_inv = HIDEEARS|HIDEFACE
	armor = list("melee" = 40, "bullet" = 20, "laser" = 10,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	flash_protect = 2
	tint = 2

/obj/item/clothing/head/helmet/helmet_ntguard
	name = "NT helmet"
	desc = "Unusual white color"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_ntguard"
	inhand_icon_state = "helmet_ntguard"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	armor = list("melee" = 40, "bullet" = 30, "laser" = 35,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/welding/carpwelding
	name = "welding mask carp"
	desc = "Here was artist"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "carpwelding"
	inhand_icon_state = "carpwelding"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEEARS|HIDEFACE
	visor_flags_inv = HIDEEARS|HIDEFACE
	armor = list("melee" = 40, "bullet" = 20, "laser" = 10,"energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	flash_protect = 2
	tint = 2

/obj/item/clothing/head/helmet/merc_rig_heavy
	name = "heavy Syndicate helmet"
	desc = "Really heavy"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "merc_rig_heavy"
	inhand_icon_state = "merc_rig_heavy"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE
	resistance_flags = NONE|ACID_PROOF|FREEZE_PROOF
	armor = list("melee" = 70, "bullet" = 60, "laser" = 50,"energy" = 10, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 60)
	flash_protect = 1

/obj/item/clothing/head/helmet/facecover
	name = "facecover"
	desc = "Looks unusually"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "facecover"
	inhand_icon_state = "facecover"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/helmet_sol
	name = "soldier helmet"
	desc = "Looks strange for soldier, but that for soldiers"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_sol"
	inhand_icon_state = "helmet_sol"
	flags_inv = HIDEEARS
	visor_flags_inv = HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 40, "bullet" = 35, "laser" = 40,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 20)

/obj/item/clothing/head/helmet/helmet_tac
	name = "tactical helmet"
	desc = "Looks unusual for helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_tac"
	inhand_icon_state = "helmet_tac"
	flags_inv = HIDEEARS
	visor_flags_inv = HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 45, "bullet" = 50, "laser" = 35,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 25)

/obj/item/clothing/gloves/combat/evening_gloves
	name = "evening gloves"
	desc = "Evening gloves."
	worn_icon = 'white/Wzzzz/clothing/mob/hands.dmi'
	icon = 'white/Wzzzz/clothing/gloves.dmi'
	icon_state = "evening_gloves"
	inhand_icon_state = "evening_gloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 100
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 0, "fire" = 50, "acid" = 75)

/obj/item/clothing/head/helmet/bio_anom
	name = "Anomaly hood"
	desc = "A hood that protects the head and face from exotic alien energies and biological contamination."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "bio_anom"
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	inhand_icon_state = "bio_anom"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT|STOPSPRESSUREDAMAGE|SNUG_FIT
	resistance_flags = NONE|ACID_PROOF
	armor = list("melee" = 40, "bullet" = 20, "laser" = 30,"energy" = 30, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 75, "acid" = 70)


/obj/item/clothing/suit/space/anomaly
	name = "Anomaly suit"
	desc = "A suit that protects against exotic alien energies and biological contamination."
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "bio_anom"
	inhand_icon_state = "bio_anom"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	w_class = WEIGHT_CLASS_HUGE
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20,"energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 85)

/obj/item/clothing/suit/space/secger
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "rig_sec"
	inhand_icon_state = "rig_sec"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	name = "security german hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	armor = list(melee = 80, bullet = 65, laser = 55, energy = 15, bomb = 80, bio = 100, rad = 60)

//helmettype = /obj/item/clothing/head/helmet/rig0sec

/obj/item/clothing/suit/space/secalt
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "rig_secalt"
	inhand_icon_state = "rig_secalt"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	name = "security german hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	armor = list(melee = 80, bullet = 65, laser = 55, energy = 15, bomb = 80, bio = 100, rad = 60)

//helmettype = /obj/item/clothing/head/helmet/secalt_helm

/obj/item/clothing/suit/armor/vest/bulletproofsuit
	name = "bulletproof armour"
	desc = "Better bulletproof suit."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "bulletproof"
	siemens_coefficient = 0.7
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "bulletproof"
	armor = list("melee" = 42, "bullet" = 75, "laser" = 42,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 30)

/obj/item/clothing/suit/toggle/labcoat
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/rd
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_rd"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_rd"

/obj/item/clothing/under/syndicate/sweater
	name = "sweater turtleneck"
	desc = "Comfortable and warm"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "sweater"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	inhand_icon_state = "sweater"
	cold_protection = 200
	min_cold_protection_temperature = 60
	has_sensor = NO_SENSORS


/obj/item/clothing/suit/space/excavation
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	inhand_icon_state = "rig_excavation"
	icon_state = "rig_excavation"
	name = "excavation voidsuit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	desc = "A specially shielded voidsuit that insulates against some exotic alien energies, as well as the more mundane dangers of excavation."
	armor = list(melee = 30, bullet = 0, laser = 5,energy = 40, bomb = 35, bio = 100, rad = 100)

/obj/item/clothing/head/helmet/space/excavation
	name = "excavation voidsuit helmet"
	desc = "A sophisticated voidsuit helmet, capable of protecting the wearer from many exotic alien energies."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "rig0_excavation"
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	inhand_icon_state = "rig0_excavation"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = NONE
	armor = list(melee = 30, bullet = 0, laser = 5 ,energy = 40, bomb = 35, bio = 100, rad = 100)


/obj/item/clothing/suit/armor/vest/bulletproofsuit/vest
	name = "bulletproof vest"
	desc = "A suit of armor with heavy plates to protect against ballistic projectiles. Looks like it might impair movement."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "bulletproofvest"
	inhand_icon_state = "bulletproofvest"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 40, "bullet" = 80, "laser" = 20,"energy" = 0, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 30)

/obj/item/clothing/suit/space/salvage
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	inhand_icon_state = "rig_salvage"
	icon_state = "rig_salvage"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	name = "salvage suit"
	desc = "Salvaged"
	armor = list(melee = 50, bullet = 40, laser = 20 ,energy = 10, bomb = 45, bio = 90, rad = 70)

/obj/item/clothing/suit/bomb_suit/german
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "bombsuitsec"
	inhand_icon_state = "bombsuitsec"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 50, "bullet" = 50, "laser" = 20,"energy" = 10, "bomb" = 100, "bio" = 40, "rad" = 0, "fire" = 80, "acid" = 50)

/obj/item/clothing/suit/bomb_suit/german/bombsuitsecold
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "bombsuitsecold"
	inhand_icon_state = "bombsuitsecold"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 50, "bullet" = 50, "laser" = 20,"energy" = 10, "bomb" = 100, "bio" = 40, "rad" = 0, "fire" = 80, "acid" = 50)

/obj/item/clothing/head/bomb_hood/german
	name = "bomb helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "bombsuitsec"
	inhand_icon_state = "bombsuitsec"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR|HIDEMASK|HIDEMASK
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACIALHAIR|HIDEMASK
	armor = list("melee" = 70, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 100, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 50)

/obj/item/clothing/suit/armor/hos/german
	icon_state = "hosg"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "hosg"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/imperium_monk/german
	icon_state = "imperium_monk"
	inhand_icon_state = "imperium_monk"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	flags_inv = HIDEHAIR|HIDEEARS|256
	visor_flags_inv = HIDEHAIR|HIDEEARS|256
	armor = list("melee" = 30, "bullet" = 10, "laser" = 20,"energy" = 30, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 10)

/obj/item/clothing/suit/wizrobe/psyamp
	icon_state = "psyamp"
	actions_types = list(/obj/effect/proc_holder/spell/targeted/projectile/magic_missile)
	flags_inv = NONE
	inhand_icon_state = "psyamp"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	resistance_flags = NONE|ACID_PROOF|INDESTRUCTIBLE|UNACIDABLE
	armor = list("melee" = 500, "bullet" = 500, "laser" = 500,"energy" = 500, "bomb" = 500, "bio" = 500, "rad" = 500, "fire" = 0, "acid" = 500)

/obj/item/clothing/suit/radiation/german
	icon_state = "rad"
	inhand_icon_state = "rad"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/radiation/germanold
	icon_state = "rad_old"
	inhand_icon_state = "rad_old"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/armor/vest/swat_german
	name = "swat suit"
	desc = "Good suit for battles versus revolution or criminals."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "swatold"
	siemens_coefficient = 0.6
	inhand_icon_state = "swatold"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40,"energy" = 10, "bomb" = 70, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50)

/obj/item/clothing/suit/armor/vest/riot_german
	name = "swat suit"
	desc = "Good suit for battles versus revolution or criminals."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "riotold"
	siemens_coefficient = 0.7
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "riotold"
	armor = list("melee" = 75, "bullet" = 33, "laser" = 50,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 40)

/obj/item/clothing/suit/armor/vest/swatarmor_german
	name = "swat armor"
	desc = "Armor for swat and swat operations."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "swatarmor"
	siemens_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "swatarmor"
	armor = list("melee" = 60, "bullet" = 60, "laser" = 60,"energy" = 40, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 40)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/swatarmor

/obj/item/clothing/suit/hazardvest/green
	icon_state = "hazard_g"
	inhand_icon_state = "hazard_g"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/hazardvest/white
	icon_state = "hazard_w"
	inhand_icon_state = "hazard_w"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/hazardvest/blue
	icon_state = "hazard_b"
	inhand_icon_state = "hazard_b"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/space/sec
	name = "security space suit"
	desc = "A common suit what protects against pressure."
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "cespace_suit"
	inhand_icon_state = "cespace_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	w_class = WEIGHT_CLASS_HUGE
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 40, "bullet" = 40, "laser" = 30,"energy" = 40, "bomb" = 40, "bio" = 100, "rad" = 10, "fire" = 80, "acid" = 50)

/obj/item/clothing/suit/space/eng
	name = "engineer space suit"
	desc = "A common suit what protects against pressure."
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "engspace_suit"
	inhand_icon_state = "engspace_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	w_class = WEIGHT_CLASS_HUGE
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 50)

/obj/item/clothing/head/helmet/space/sec
	name = "security space helmet"
	desc = "A common space for space travels."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "cespace_helmet"
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	inhand_icon_state = "cespace_helmet"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = NONE
	armor = list("melee" = 40, "bullet" = 40, "laser" = 30,"energy" = 40, "bomb" = 40, "bio" = 100, "rad" = 10, "fire" = 80, "acid" = 50)

/obj/item/clothing/head/helmet/space/eng
	name = "engineer space helmet"
	desc = "A common space for space travels."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "engspace_helmet"
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	inhand_icon_state = "engspace_helmet"
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = NONE
	armor = list(melee = 30, bullet = 10, laser = 15, energy =10, bomb = 35, bio = 100, rad = 100)

/obj/item/clothing/suit/armor/hos/trenchcoat/jensen
	name = "jensen trenchcoat"
	desc = "You never asked for anything that stylish."
	icon_state = "jensencoat"
	inhand_icon_state = "jensencoat"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/space/syndicate/german
	name = "orange space suit"
	icon_state = "syndicate_orange_ger"
	inhand_icon_state = "syndicate_orange_ger"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/sweater
	name = "sweater"
	desc = "Comfortable and warm"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon_state = "sweater"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	heat_protection = CHEST|GROIN
	cold_protection = 200
	min_cold_protection_temperature = 60
	inhand_icon_state = "sweater"

/obj/item/clothing/suit/nttunic
	name = "NT tunic"
	desc = "Do you weared tunic early?"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon_state = "nttunic"
	inhand_icon_state = "nttunic"

/obj/item/clothing/suit/nttunic/black
	icon_state = "nttunicblack"
	inhand_icon_state = "nttunicblack"

/obj/item/clothing/suit
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'

/obj/item/clothing/suit/thawb
	desc = "What is thawb?"
	name = "thawb"
	icon_state = "thawb"
	inhand_icon_state = "thawb"

/obj/item/clothing/suit/sherwani
	desc = "Sherwani"
	name = "sherwani"
	icon_state = "sherwani"
	inhand_icon_state = "sherwani"

/obj/item/clothing/suit/qipao
	desc = "Qipao"
	name = "qipao"
	icon_state = "qipao"
	inhand_icon_state = "qipao"

/obj/item/clothing/suit/ubacblack
	desc = "Ubac"
	name = "ubac"
	icon_state = "ubacblack"
	inhand_icon_state = "ubacblack"
	body_parts_covered = CHEST|GROIN
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/ubactan
	desc = "Ubac"
	name = "ubac"
	icon_state = "ubactan"
	inhand_icon_state = "ubactan"
	body_parts_covered = CHEST|GROIN
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/ubacgreen
	desc = "ubacgreen"
	name = "ubacgreen"
	body_parts_covered = CHEST|GROIN
	icon_state = "ubacgreen"
	inhand_icon_state = "ubacgreen"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/dashiki
	desc = "What is dashiki?"
	name = "dashiki"
	icon_state = "dashiki"
	inhand_icon_state = "dashiki"

/obj/item/clothing/suit/dashiki/red
	icon_state = "dashikired"
	inhand_icon_state = "dashikired"

/obj/item/clothing/suit/dashiki/blue
	icon_state = "dashikiblue"
	inhand_icon_state = "dashikiblue"

/obj/item/clothing/suit/toggle
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'


/obj/item/clothing/suit/toggle/nt_jacket
	name = "NT jacket"
	desc = "Just jacket from NT"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon_state = "nt_jacket"
	body_parts_covered = CHEST|GROIN
	inhand_icon_state = "nt_jacket"

/obj/item/clothing/suit/toggle/
	name = "NT jacket"
	desc = "Just jacket from NT"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon_state = "nt_jacket"
	body_parts_covered = CHEST|GROIN
	inhand_icon_state = "nt_jacket"

/obj/item/clothing/suit/toggle/zhongshan
	name = "zhongshan"
	desc = "Zhongshan"
	icon_state = "zhongshan"
	inhand_icon_state = "zhongshan"

/obj/item/clothing/suit/toggle/tangzhuang
	name = "tangzhuang"
	desc = "Tangzhuang"
	icon_state = "tangzhuang"
	inhand_icon_state = "tangzhuang"



/obj/item/clothing/suit/toggle/hawaii2
	icon_state = "hawaii2"
	inhand_icon_state = "hawaii2"

/obj/item/clothing/suit/toggle/det_vest
	name = "detective vest"
	desc = "Little armor for detectives, what don't like their coat"
	armor = list("melee" = 20, "bullet" = 20, "laser" = 15,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	icon_state = "det_vest"
	inhand_icon_state = "det_vest"

/obj/item/clothing/suit/toggle/jacket
	name = "jacket"
	desc = "Common jacket"

/obj/item/clothing/suit/toggle/jacket/tan
	name = "tan jacket"
	icon_state = "tan_jacket"
	inhand_icon_state = "tan_jacket"

/obj/item/clothing/suit/toggle/jacket/charcoal
	name = "charcoal jacket"
	icon_state = "charcoal_jacket"
	inhand_icon_state = "charcoal_jacket"

/obj/item/clothing/suit/toggle/jacket/checkered
	name = "checkered jacket"
	icon_state = "checkered_jacket"
	inhand_icon_state = "checkered_jacket"

/obj/item/clothing/suit/toggle/jacket/burgundy
	name = "burgundy jacket"
	icon_state = "burgundy_jacket"
	inhand_icon_state = "burgundy_jacket"

/obj/item/clothing/suit/toggle/jacket/navy
	name = "navy jacket"
	icon_state = "navy_jacket"
	inhand_icon_state = "navy_jacket"

/obj/item/storage/belt/military/vest
	name = "german black vest"
	desc = "Armor, storage, stilysh"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10,"energy" = 10, "bomb" = 25, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	icon_state = "vest_black"
	inhand_icon_state = "vest_black"

/obj/item/storage/belt/military/vest/brown
	name = "german brown vest"
	icon_state = "vest_brown"
	inhand_icon_state = "vest_brown"

/obj/item/storage/belt/military/vest/white
	name = "german white vest"
	icon_state = "vest_white"
	inhand_icon_state = "vest_white"

/obj/item/storage/belt/mining/large
	icon_state = "webbing_large"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	inhand_icon_state = "webbing_large"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/mining/large/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 20
	STR.set_holdable(list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/analyzer,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/resonator,
		/obj/item/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/stack/sheet/animalhide,
		/obj/item/stack/sheet/sinew,
		/obj/item/stack/sheet/bone,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/reagent_containers/food/drinks/bottle,
		/obj/item/stack/medical,
		/obj/item/kitchen/knife,
		/obj/item/reagent_containers/hypospray,
		/obj/item/gps,
		/obj/item/storage/bag/ore,
		/obj/item/survivalcapsule,
		/obj/item/t_scanner/adv_mining_scanner,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/ore,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/organ/regenerative_core,
		/obj/item/wormhole_jaunter,
		/obj/item/storage/bag/plants,
		/obj/item/stack/marker_beacon
		))

/obj/item/storage/belt/mining/alt
	icon_state = "webbing"
	icon = 'white/Wzzzz/clothing/ties.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/ties.dmi'
	inhand_icon_state = "webbing"



/obj/item/clothing/suit/toggle/trackjacketred
	name = "track jacket red"
	desc = "Track jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "trackjacketred"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "trackjacketred"

/obj/item/clothing/suit/toggle/trackjacket
	name = "track jacket"
	desc = "Track jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "trackjacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "trackjacket"

/obj/item/clothing/suit/toggle/trackjacketblue
	name = "track jacket blue"
	desc = "Track jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "trackjacketblue"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "trackjacketblue"

/obj/item/clothing/suit/toggle/trackjacketwhite
	name = "track jacket white"
	desc = "Track jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "trackjacketwhite"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "trackjacketwhite"

/obj/item/clothing/suit/toggle/trackjacketgreen
	name = "track jacket green"
	desc = "Track jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "trackjacketgreen"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "trackjacketgreen"

/obj/item/clothing/suit/toggle/ia_jacket
	name = "track jacket"
	desc = "Track jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ia_jacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "ia_jacket"

/obj/item/clothing/suit/gentlecoat
	icon_state = "gentlecoat"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "gentlecoat"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/suit/toggle/labcoat/labcoat_cmoalt
	name = "cmo labcoat"
	desc = "Another version of CMO labcoat"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_cmoalt"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "labcoat_cmoalt"


/obj/item/clothing/suit/toggle/suitjacket_blue
	name = "blue jacket"
	desc = "Blue jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "suitjacket_blue"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "suitjacket_blue"

/obj/item/clothing/suit/toggle/bomber
	name = "bomber jacket"
	desc = "Oldstyle"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 5,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "bomber"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "bomber"

/obj/item/clothing/suit/leather_jacket
	name = "leather jacket"
	desc = "Leather jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "leather_jacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "leather_jacket"

/obj/item/clothing/suit/mbill
	name = "jacket"
	desc = "Jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "mbill"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "mbill"

/obj/item/clothing/suit/towel
	name = "towel"
	desc = "Space, war and you with towel"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "towel"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "towel"

/obj/item/clothing/suit/suitjacket_purp
	name = "jacket purple"
	desc = "Like Gulman?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "suitjacket_purp"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "suitjacket_purp"

/obj/item/clothing/suit/surgical
	name = "surgical vest"
	desc = "For true surgery"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "surgical"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "surgical"

/obj/item/clothing/suit/toggle/ems_jacket
	name = "emergensy jacket"
	desc = "If you wear it, then not time to read description"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ems_jacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "ems_jacket"

/obj/item/clothing/suit/toggle/whitedress
	name = "white dress"
	desc = "For important persons"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "whitedress"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "whitedress"

/obj/item/clothing/suit/toggle/whitedress_com
	name = "white dress"
	desc = "For important persons"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "whitedress_com"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "whitedress_com"

/obj/item/clothing/suit/toggle/marshal_jacket
	name = "marshal jacket"
	desc = "Wow, jackets special for marshals"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "marshal_jacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "marshal_jacket"

/obj/item/clothing/suit/toggle/labcoat/blue_edge_labcoat
	name = "blue edge labcoat"
	desc = "Blue edge...sounds cool"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "blue_edge_labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "blue_edge_labcoat"

/obj/item/clothing/suit/toggle/labcoat/labgreen
	name = "labcoat green"
	desc = "You really want to wear it?"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labgreen"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "labgreen"


/obj/item/clothing/suit/toggle/smw_hoodie
	name = "smw hoodie"
	desc = "Who is SMW?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "smw_hoodie"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "smw_hoodie"

/obj/item/clothing/suit/toggle/nt_hoodie
	name = "NT hoodie"
	desc = "Looks good"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "nt_hoodie"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "nt_hoodie"

/obj/item/clothing/suit/toggle/mu_hoodie
	name = "mu hoodie"
	desc = "Mu"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "mu_hoodie"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "mu_hoodie"

/obj/item/clothing/suit/toggle/cti_hoodie
	name = "cti hoodie"
	desc = "CTI?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "mu_hoodie"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "mu_hoodie"

/obj/item/clothing/suit/toggle/cti_hoodie
	name = "cti hoodie"
	desc = "CTI?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "cti_hoodie"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "cti_hoodie"

/obj/item/clothing/suit/toggle/hoodie
	name = "hoodie"
	desc = "Hoodie for hoodies"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "hoodie"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "hoodie"

/obj/item/clothing/suit/toggle/fr_jacket
	name = "forensics jacket"
	desc = "You really want wear it?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "fr_jacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "fr_jacket"

/obj/item/clothing/suit/mantle_unathi
	name = "mantle"
	desc = "Something old or wild"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "mantle_unathi"
	body_parts_covered = CHEST
	inhand_icon_state = "mantle_unathi"

/obj/item/clothing/suit/robe_unathi
	name = "robe"
	desc = "Low technologies"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "robe_unathi"
	body_parts_covered = CHEST|GROIN
	inhand_icon_state = "robe_unathi"

/obj/item/clothing/suit/space/skrell_suit_black
	name = "black space suit"
	desc = "For skrells, but we anyway too use it"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "skrell_suit_black"
	inhand_icon_state = "skrell_suit_black"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	w_class = WEIGHT_CLASS_HUGE
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 0, "fire" = 60, "acid" = 60)

/obj/item/clothing/suit/space/skrell_suit_white
	name = "white space suit"
	desc = "For skrells, but we anyway too use it"
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "skrell_suit_white"
	inhand_icon_state = "skrell_suit_white"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	w_class = WEIGHT_CLASS_HUGE
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 0, "fire" = 60, "acid" = 60)

/obj/item/clothing/suit/forensics_blue
	name = "forensics jacket"
	desc = "Wow, real forensics?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "forensics_blue"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "forensics_blue"

/obj/item/clothing/suit/forensics_red
	name = "forensics jacket"
	desc = "Wow, real forensics?"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "forensics_red"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "forensics_red"

/obj/item/clothing/suit/armor/vest/armorsec
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "armorsec"
	inhand_icon_state = "armorsec"

/obj/item/clothing/suit/space/zhan_furs
	name = "zhan suit"
	desc = "Space suit. Yes."
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	icon_state = "zhan_furs"
	inhand_icon_state = "zhan_furs"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	clothing_flags = STOPSPRESSUREDAMAGE
	w_class = WEIGHT_CLASS_HUGE
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 0, "fire" = 60, "acid" = 60)

/obj/item/clothing/suit/blueponcho
	desc = "Blue poncho"
	name = "blue poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blueponcho"
	inhand_icon_state = "blueponcho"

/obj/item/clothing/suit/purpleponcho
	desc = "Purple poncho"
	name = "purple poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "purpleponcho"
	inhand_icon_state = "purpleponcho"

/obj/item/clothing/suit/secponcho
	desc = "Security poncho"
	name = "secutiry poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "secponcho"
	inhand_icon_state = "secponcho"

/obj/item/clothing/suit/medponcho
	desc = "Medical poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	name = "medical poncho"
	icon_state = "medponcho"
	inhand_icon_state = "medponcho"

/obj/item/clothing/suit/engiponcho
	desc = "Engineer poncho"
	name = "engineer poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "engiponcho"
	inhand_icon_state = "engiponcho"

/obj/item/clothing/suit/cargoponcho
	desc = "Cargo poncho"
	name = "cargo poncho"
	icon_state = "cargoponcho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	inhand_icon_state = "cargoponcho"

/obj/item/clothing/suit/sciponcho
	desc = "Science poncho"
	name = "science poncho"
	icon_state = "sciponcho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	inhand_icon_state = "sciponcho"

/obj/item/clothing/suit/pvest
	desc = "Vest"
	name = "vest"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "pvest"
	inhand_icon_state = "pvest"

/obj/item/clothing/suit/blackservice
	name = "blackservice jacket"
	desc = "Blackservice"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blackservice"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "blackservice"

/obj/item/clothing/suit/blackservice/crew
	icon_state = "blackservice_crew"
	inhand_icon_state = "blackservice_crew"

/obj/item/clothing/suit/blackservice/med
	icon_state = "blackservice_med"
	inhand_icon_state = "blackservice_med"

/obj/item/clothing/suit/blackservice/medcom
	icon_state = "blackservice_medcom"
	inhand_icon_state = "blackservice_medcom"

/obj/item/clothing/suit/blackservice/eng
	icon_state = "blackservice_eng"
	inhand_icon_state = "blackservice_eng"

/obj/item/clothing/suit/blackservice/engcom
	icon_state = "pvest_engcom"
	inhand_icon_state = "pvest_engcom"

/obj/item/clothing/suit/blackservice/sup
	icon_state = "blackservice_sup"
	inhand_icon_state = "blackservice_sup"

/obj/item/clothing/suit/blackservice/sec
	icon_state = "blackservice_sec"
	inhand_icon_state = "blackservice_sec"

/obj/item/clothing/suit/blackservice/seccom
	icon_state = "blackservice_seccom"
	inhand_icon_state = "blackservice_seccom"

/obj/item/clothing/suit/blackservice/com
	icon_state = "blackservice_com"
	inhand_icon_state = "blackservice_com"

/obj/item/clothing/suit/greenservice
	name = "greenservice jacket"
	desc = "Greenservice"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 20)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "greenservice"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "greenservice"

/obj/item/clothing/suit/greenservice/med
	icon_state = "greenservice_med"
	inhand_icon_state = "greenservice_med"

/obj/item/clothing/suit/greenservice/medcom
	icon_state = "greenservice_medcom"
	inhand_icon_state = "greenservice_medcom"

/obj/item/clothing/suit/greenservice/eng
	icon_state = "greenservice_eng"
	inhand_icon_state = "greenservice_eng"

/obj/item/clothing/suit/greenservice/engcom
	icon_state = "greenservice_engcom"
	inhand_icon_state = "greenservice_engcom"

/obj/item/clothing/suit/greenservice/sup
	icon_state = "greenservice_sup"
	inhand_icon_state = "greenservice_sup"

/obj/item/clothing/suit/greenservice/sec
	icon_state = "greenservice_sec"
	inhand_icon_state = "greenservice_sec"

/obj/item/clothing/suit/greenservice/seccom
	icon_state = "greenservice_seccom"
	inhand_icon_state = "greenservice_seccom"

/obj/item/clothing/suit/greenservice/com
	icon_state = "greenservice_com"
	inhand_icon_state = "greenservice_com"

/obj/item/clothing/suit/greydress
	name = "greydress jacket"
	desc = "Greydress"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "greydress"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "greydress"

/obj/item/clothing/suit/greydress/com
	icon_state = "greydress_com"
	inhand_icon_state = "greydress_com"

/obj/item/clothing/suit/blackdress
	name = "blackdress jacket"
	desc = "Blackdress"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blackdress"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "blackdress"

/obj/item/clothing/suit/doctor_vest
	name = "doctor vest"
	desc = "For doctor"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "doctor_vest"
	body_parts_covered = CHEST
	inhand_icon_state = "doctor_vest"


/obj/item/clothing/suit/blackdress/com
	icon_state = "blackdress_com"
	inhand_icon_state = "blackdress_com"

/obj/item/clothing/suit/armor/vest/german
	name = "armored vest"
	desc = "Protection."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 35, "bullet" = 35, "laser" = 30, "energy" = 40, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	icon_state = "kvest"
	inhand_icon_state = "kvest"
	body_parts_covered = CHEST

/obj/item/clothing/suit/armor/vest/german/mercwebvest
	icon_state = "mercwebvest"
	armor = list("melee" = 50, "bullet" = 40, "laser" = 35, "energy" = 50, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 60)
	inhand_icon_state = "mercwebvest"
	body_parts_covered = CHEST|LEGS
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/webvest

/obj/item/clothing/suit/armor/vest/german/webvest
	armor = list("melee" = 40, "bullet" = 40, "laser" = 35, "energy" = 40, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	icon_state = "webvest"
	inhand_icon_state = "webvest"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/webvest

/obj/item/storage/belt/military/swat/alt
	name = "swat webbing"
	desc = "Portable storage."
	armor = list("melee" = 5, "bullet" = 0, "laser" = 5, "energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)
	icon_state = "swatbelt"
	inhand_icon_state = "swatbelt"

/obj/item/storage/belt/military/swat/alt/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 8

/obj/item/storage/belt/military/swat
	name = "swat belt"
	desc = "Belt for special forces."
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'
	icon_state = "swatbeltc"
	inhand_icon_state = "swatbeltc"

/obj/item/storage/belt/military/swat/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 6



/obj/item/clothing/suit/armor/vest/german/ntvest
	icon_state = "ntvest"
	inhand_icon_state = "ntvest"

/obj/item/clothing/suit/armor/vest/german/detvest
	icon_state = "detvest"
	inhand_icon_state = "detvest"

/obj/item/clothing/suit/armor/vest/german/solvest
	icon_state = "solvest"
	inhand_icon_state = "solvest"

/obj/item/clothing/suit/armor/vest/german/pcrcvest
	icon_state = "pcrcvest"
	inhand_icon_state = "pcrcvest"

/obj/item/clothing/suit/armor/vest/german/webvest/secwebvest
	icon_state = "secwebvest"
	inhand_icon_state = "secwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/comwebvest
	icon_state = "comwebvest"
	inhand_icon_state = "comwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/ntwebvest
	icon_state = "ntwebvest"
	inhand_icon_state = "ntwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/solwebvest
	icon_state = "solwebvest"
	inhand_icon_state = "solwebvest"

/obj/item/clothing/suit/armor/vest/german/webvest/pcrcwebvest
	icon_state = "pcrcwebvest"
	inhand_icon_state = "pcrcwebvest"

/obj/item/clothing/suit/armor/vest/german/ertarmor
	name = "ert armor"
	desc = "Usually ert use another protection, but that too exist."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40, "energy" = 30, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 75, "acid" = 75)
	body_parts_covered = CHEST

/obj/item/clothing/suit/armor/vest/german/ertarmor/cmd
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_cmd"
	inhand_icon_state = "ertarmor_cmd"

/obj/item/clothing/suit/armor/vest/german/ertarmor/med
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_med"
	inhand_icon_state = "ertarmor_med"

/obj/item/clothing/suit/armor/vest/german/ertarmor/sec
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_sec"
	inhand_icon_state = "ertarmor_esc"

/obj/item/clothing/suit/armor/vest/german/ertarmor/eng
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ertarmor_eng"
	inhand_icon_state = "ertarmor_eng"

/obj/item/clothing/under/syndicate/combat/german
	name = "tactical turtleneck"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "A non-descript and slightly suspicious looking turtleneck with digital camouflage cargo pants."
	icon_state = "combat"
	inhand_icon_state = "combat"
	can_adjust = FALSE
	has_sensor = NO_SENSORS
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20,"energy" = 20, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	alt_covers_chest = FALSE

/obj/item/clothing/under/mbill
	name = "mbill uniform"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Looks commons, feel legendary."
	icon_state = "mbill"
	inhand_icon_state = "mbill"
	has_sensor = NO_SENSORS
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/cargo/tech/ntwork
	name = "NT worker uniform"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Work, work and work"
	icon_state = "ntwork"
	inhand_icon_state = "ntwork"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/ntpilot
	name = "NT pilot uniform"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Work, work and work"
	icon_state = "ntpilot"
	can_adjust = FALSE
	inhand_icon_state = "ntpilot"
	alt_covers_chest = FALSE

/obj/item/clothing/under/abaya
	name = "abaya dress"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "unusual style"
	icon_state = "abaya"
	can_adjust = FALSE
	inhand_icon_state = "abaya"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/security/officer/ntguard
	name = "NT guard uniform"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "You need to guard, not look at your clothes"
	icon_state = "ntguard"
	inhand_icon_state = "ntguard"
	alt_covers_chest = FALSE
	can_adjust = FALSE
	armor = list("melee" = 20, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 35)

/obj/item/clothing/under/confed
	name = "confed jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Confed"
	can_adjust = FALSE
	icon_state = "confed"
	inhand_icon_state = "confed"
	alt_covers_chest = FALSE

/obj/item/clothing/under/focal
	name = "focal jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Looks like for workers"
	icon_state = "focal"
	can_adjust = FALSE
	inhand_icon_state = "focal"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/engineering/engineer/mechanic
	name = "комбинезон механика"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Дешёвый комбинезон для дешёвой рабочей силы."
	icon_state = "grayson"
	can_adjust = FALSE
	inhand_icon_state = "grayson"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/wardt
	name = "ward jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Ward"
	icon_state = "wardt"
	can_adjust = FALSE
	inhand_icon_state = "wardt"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/engineering/atmospheric_technician/aether
	name = "aether jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "For aether"
	icon_state = "aether"
	inhand_icon_state = "aether"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/frontier
	name = "frontier jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "For frontier"
	icon_state = "frontier"
	can_adjust = FALSE
	inhand_icon_state = "frontier"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/saare
	name = "saare jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "For non-hand work"
	icon_state = "saare"
	inhand_icon_state = "saare"
	alt_covers_chest = FALSE
	can_adjust = FALSE

/obj/item/clothing/under/heph
	name = "heph jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "For non-hand work"
	can_adjust = FALSE
	icon_state = "heph"
	inhand_icon_state = "heph"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/pcrc
	name = "pcrc jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Something not for low rank"
	icon_state = "pcrc"
	can_adjust = FALSE
	inhand_icon_state = "pcrc"
	alt_covers_chest = FALSE

/obj/item/clothing/under/greydress
	name = "greydress jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Grey thing"
	icon_state = "greydress"
	inhand_icon_state = "greydress"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/greydress_com
	name = "greydress jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Grey thing"
	icon_state = "greydress_com"
	inhand_icon_state = "greydress_com"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/greydressfem
	name = "greydress female jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Grey thing"
	icon_state = "greydressfem"
	inhand_icon_state = "greydressfem"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/greydressfem_com
	name = "greydress female jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Grey thing"
	icon_state = "greydressfem_com"
	inhand_icon_state = "greydressfem_com"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackdress
	name = "Blackdress jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Black thing"
	icon_state = "blackdress"
	inhand_icon_state = "blackdress"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackdress_com
	name = "blackdress jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Black thing"
	icon_state = "blackdress_com"
	can_adjust = FALSE
	inhand_icon_state = "blackdress_com"
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackdressfem
	name = "blackdress female jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Black thing"
	icon_state = "blackdressfem"
	inhand_icon_state = "blackdressfem"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackdressfem_com
	name = "blackdress female jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Black thing"
	icon_state = "blackdressfem_com"
	can_adjust = FALSE
	inhand_icon_state = "blackdressfem_com"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/medical/doctor/sterile
	name = "sterile jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Sterile"
	icon_state = "sterile"
	can_adjust = FALSE
	inhand_icon_state = "sterile"
	alt_covers_chest = FALSE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 30, "rad" = 0, "fire" = 0, "acid" = 10)

/obj/item/clothing/under/rank/security/officer/marinept
	name = "marine jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Marine uniform"
	icon_state = "marinept"
	inhand_icon_state = "marinept"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/fleetpt
	name = "fleet jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Fleet uniform"
	icon_state = "fleetpt"
	inhand_icon_state = "fleetpt"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/expeditionpt
	name = "expedition jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Expedition uniform"
	can_adjust = FALSE
	icon_state = "expeditionpt"
	inhand_icon_state = "expeditionpt"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/miami
	name = "miami shirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Miami!"
	icon_state = "miami"
	can_adjust = FALSE
	inhand_icon_state = "miami"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/dress_fire
	name = "dress fire"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Blue fire"
	icon_state = "dress_fire"
	inhand_icon_state = "dress_fire"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/greenservice
	name = "greenservice jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Green uniform"
	icon_state = "greenservice"
	inhand_icon_state = "greenservice"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/greenservice_com
	name = "greenservice jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Green uniform"
	icon_state = "greenservice_com"
	can_adjust = FALSE
	inhand_icon_state = "greenservice_com"
	alt_covers_chest = FALSE

/obj/item/clothing/under/whiteservice
	name = "whiteservice jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "White uniform"
	icon_state = "whiteservice"
	can_adjust = FALSE
	inhand_icon_state = "whiteservice"
	alt_covers_chest = FALSE

/obj/item/clothing/under/whiteservicefem
	name = "whiteservice female jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "White uniform"
	icon_state = "whiteservicefem"
	inhand_icon_state = "whiteservicefem"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/head_of_security/hosred
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "hosred"
	inhand_icon_state = "hosred"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/secred
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "secred_s"
	inhand_icon_state = "secred_s"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/cargo/tech/german
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "cargo"
	inhand_icon_state = "cargo"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/cargo/qm/german
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "qm"
	can_adjust = FALSE
	inhand_icon_state = "qm"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/medical/doctor/medical_short
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "medical_short"
	inhand_icon_state = "medical_short"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/centcom/officer
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "officer"
	inhand_icon_state = "officer"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/centcom/officer/centcom
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "centcom"
	inhand_icon_state = "centcom"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/medical/doctor/white
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "white"
	can_adjust = FALSE
	inhand_icon_state = "white"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/medical/doctor/medical
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "medical"
	inhand_icon_state = "medical"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/johnny
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "johnny"
	inhand_icon_state = "johnny"
	can_adjust = FALSE
	name = "johnny uniform"
	desc = "Johnny, from Johnny, for Johnny"
	alt_covers_chest = FALSE

/obj/item/clothing/under/orang
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "orang"
	name = "orange uniform"
	can_adjust = FALSE
	desc = "If you like orange"
	inhand_icon_state = "orang"
	alt_covers_chest = FALSE

/obj/item/clothing/under/color
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Simple, but classic"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/color/blue
	icon_state = "blu"
	inhand_icon_state = "blu"
	name = "blue uniform"

/obj/item/clothing/under/color/purple
	icon_state = "purpl"
	inhand_icon_state = "purpl"
	name = "purpel uniform"

/obj/item/clothing/under/color/green
	icon_state = "gree"
	inhand_icon_state = "gree"
	name = "green"

/obj/item/clothing/under/mai_yang
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "mai_yang"
	inhand_icon_state = "mai_yang"
	name = "yang uniform"
	can_adjust = FALSE
	desc = "Dirt or art?"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/psysuit
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "psysuit"
	name = "psy uniform"
	desc = "From somewhere for someone"
	inhand_icon_state = "psysuit"
	alt_covers_chest = FALSE
	can_adjust = FALSE
	resistance_flags = NONE|ACID_PROOF|INDESTRUCTIBLE|UNACIDABLE
	clothing_flags = STOPSPRESSUREDAMAGE
	armor = list("melee" = 500, "bullet" = 500, "laser" = 500,"energy" = 500, "bomb" = 500, "bio" = 500, "rad" = 500, "fire" = 0, "acid" = 500)

/obj/item/clothing/under/redcoat
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "redcoat"
	name = "redcoat uniform"
	desc = "Like pirate, but no"
	inhand_icon_state = "redcoat"
	alt_covers_chest = FALSE
	can_adjust = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/nursesuit
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "nursesuit"
	inhand_icon_state = "nursesuit"
	can_adjust = FALSE
	name = "nurse uniform"
	desc = "Why you read it, you want be fired?"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/lawyer_purp
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "lawyer_purp"
	inhand_icon_state = "lawyer_purp"
	alt_covers_chest = FALSE
	name = "lawyer uniform"
	can_adjust = FALSE
	desc = "Looks stylish"

/obj/item/clothing/under/greyutility
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "greyutility"
	inhand_icon_state = "greyutility"
	name = "grey utility jumpsuit"
	can_adjust = FALSE
	desc = "Grey"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/greyutility_eng
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "greyutility_eng"
	name = "grey utility jumpsuit"
	can_adjust = FALSE
	desc = "Grey"
	inhand_icon_state = "greyutility_eng"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/greyutility_med
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "greyutility_med"
	name = "grey utility jumpsuit"
	desc = "Grey"
	can_adjust = FALSE
	inhand_icon_state = "greyutility_med"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/greyutility_sup
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "greyutility_sup"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	inhand_icon_state = "greyutility_sup"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	name = "grey utility jumpsuit"
	desc = "Grey"

/obj/item/clothing/under/greyutility_sec
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "greyutility_sec"
	inhand_icon_state = "greyutility_sec"
	name = "grey utility jumpsuit"
	can_adjust = FALSE
	desc = "Grey"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/greyutility_com
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "greyutility_com"
	inhand_icon_state = "greyutility_com"
	name = "grey utility jumpsuit"
	can_adjust = FALSE
	desc = "Grey"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/navyutility
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "navyutility"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	inhand_icon_state = "navyutility"
	alt_covers_chest = FALSE
	name = "navy jumpsuit"
	can_adjust = FALSE
	desc = "For space navi"

/obj/item/clothing/under/navyutility_eng
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "navyutility_eng"
	inhand_icon_state = "navyutility_eng"
	can_adjust = FALSE
	name = "navy jumpsuit"
	desc = "For space navi"
	alt_covers_chest = FALSE
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)

/obj/item/clothing/under/navyutility_med
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "navyutility_med"
	name = "navy jumpsuit"
	can_adjust = FALSE
	desc = "For space navi"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	inhand_icon_state = "navyutility_med"
	alt_covers_chest = FALSE

/obj/item/clothing/under/navyutility_sup
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "navyutility_sup"
	name = "navy jumpsuit"
	can_adjust = FALSE
	desc = "For space navi"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	inhand_icon_state = "navyutility_sup"
	alt_covers_chest = FALSE

/obj/item/clothing/under/navyutility_sec
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "navyutility_sec"
	can_adjust = FALSE
	name = "navy jumpsuit"
	desc = "For space navi"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	inhand_icon_state = "navyutility_sec"
	alt_covers_chest = FALSE

/obj/item/clothing/under/navyutility_com
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "navyutility_com"
	can_adjust = FALSE
	name = "navy jumpsuit"
	desc = "For space navi"
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)
	inhand_icon_state = "navyutility_com"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/greenutility
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "greenutility"
	inhand_icon_state = "greenutility"
	can_adjust = FALSE
	name = "green utility jumpsuit"
	desc = "Russian style"
	alt_covers_chest = FALSE
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)

/obj/item/clothing/under/rank/security/officer/tanutility
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "tanutility"
	inhand_icon_state = "tanutility"
	name = "tan utility jumpsuit"
	desc = "Desert style"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	armor = list("melee" = 15, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 45, "acid" = 40)

/obj/item/clothing/under/blackutility
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility"
	inhand_icon_state = "blackutility"
	alt_covers_chest = FALSE
	can_adjust = FALSE
	name = "black utility jumpsuit"
	desc = "Stylish black color"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)

/obj/item/clothing/under/blackutility_crew
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_crew"
	inhand_icon_state = "blackutility_crew"
	name = "black utility jumpsuit"
	can_adjust = FALSE
	desc = "Stylish black color"
	alt_covers_chest = FALSE
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)

/obj/item/clothing/under/blackutility_med
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_med"
	inhand_icon_state = "blackutility_med"
	name = "black utility jumpsuit"
	can_adjust = FALSE
	desc = "Stylish black color"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackutility_medcom
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_medcom"
	name = "black utility jumpsuit"
	desc = "Stylish black color"
	can_adjust = FALSE
	inhand_icon_state = "blackutility_medcom"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackutility_eng
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_eng"
	inhand_icon_state = "blackutility_eng"
	name = "black utility jumpsuit"
	can_adjust = FALSE
	desc = "Stylish black color"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackutility_engcom
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_engcom"
	inhand_icon_state = "blackutility_engcom"
	name = "black utility jumpsuit"
	desc = "Stylish black color"
	can_adjust = FALSE
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackutility_sup
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_sup"
	name = "black utility jumpsuit"
	can_adjust = FALSE
	desc = "Stylish black color"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	inhand_icon_state = "blackutility_sup"
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackutility_sec
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_sec"
	inhand_icon_state = "blackutility_sec"
	name = "black utility jumpsuit"
	can_adjust = FALSE
	desc = "Stylish black color"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackutility_seccom
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_seccom"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	inhand_icon_state = "blackutility_seccom"
	name = "black utility jumpsuit"
	desc = "Stylish black color"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/blackutility_com
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blackutility_com"
	name = "black utility jumpsuit"
	desc = "Stylish black color"
	can_adjust = FALSE
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 55, "acid" = 40)
	inhand_icon_state = "blackutility_com"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/detective/detective2
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "detective2"
	can_adjust = FALSE
	inhand_icon_state = "detective2"
	alt_covers_chest = FALSE




/obj/item/clothing/under/blue_blazer
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "blue_blazer"
	inhand_icon_state = "blue_blazer"
	name = "blazer"
	can_adjust = FALSE
	desc = "Blue blazer..."
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/gentlesuit
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "gentlesuit"
	inhand_icon_state = "gentlesuit"
	name = "gentelman jumpsuit"
	desc = "Black, white, gentle"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/rnd/research_director/rdalt
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "rdalt"
	inhand_icon_state = "rdalt"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/swatunder
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "swatunder"
	inhand_icon_state = "swatunder"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/civilian/head_of_personnel/hopwhimsy
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "hopwhimsy"
	inhand_icon_state = "hopwhimsy"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/warden/wardendnavyclothes
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "wardendnavyclothes"
	inhand_icon_state = "wardendnavyclothes"
	alt_covers_chest = FALSE
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/officer/officerdnavyclothes
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "officerdnavyclothes"
	inhand_icon_state = "officerdnavyclothes"
	can_adjust = FALSE
	alt_covers_chest = FALSE



/obj/item/clothing/under/rank/security/head_of_security/hos_corporate
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "hos_corporate"
	inhand_icon_state = "hos_corporate"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/dispatch
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "dispatch"
	inhand_icon_state = "dispatch"
	name = "dispatch"
	desc = "Not patch"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/head_of_security/hosdnavyclothes
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "hosdnavyclothes"
	inhand_icon_state = "hosdnavyclothes"
	alt_covers_chest = FALSE
	can_adjust = FALSE

/obj/item/clothing/under/captain_fly
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "captain_fly"
	inhand_icon_state = "captain_fly"
	name = "captain's fly"
	desc = "Unusual for captain"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/internalaffairs
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "internalaffairs"
	inhand_icon_state = "internalaffairs"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/bride
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	alt_covers_chest = FALSE
	can_adjust = FALSE
	name = "bridge dress"
	desc = "Princess"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/bride/blue
	icon_state = "bride_blue"
	inhand_icon_state = "bride_blue"

/obj/item/clothing/under/bride/red
	icon_state = "bride_red"
	inhand_icon_state = "bride_red"

/obj/item/clothing/under/bride/white
	icon_state = "bride_white"
	inhand_icon_state = "bride_white"

/obj/item/clothing/under/bride/orange
	icon_state = "bride_orange"
	inhand_icon_state = "bride_orange"

/obj/item/clothing/under/bride/purple
	icon_state = "bride_purple"
	inhand_icon_state = "bride_purple"

/obj/item/clothing/under/dress_orange
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "dress_orange"
	name = "dress"
	can_adjust = FALSE
	desc = "True girl"
	inhand_icon_state = "dress_orange"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/dress_saloon
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "dress_saloon"
	inhand_icon_state = "dress_saloon"
	alt_covers_chest = FALSE
	name = "dress"
	can_adjust = FALSE
	desc = "Sexy?"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/orderly
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "orderly"
	inhand_icon_state = "orderly"
	alt_covers_chest = FALSE
	can_adjust = FALSE
	name = "orderly"
	has_sensor = NO_SENSORS
	desc = "Very simple, but classic"

/obj/item/clothing/under/nurse
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "nurse"
	inhand_icon_state = "nurse"
	can_adjust = FALSE
	name = "nurse dress"
	desc = "True nurse don't uses her dress for looking at that"
	alt_covers_chest = FALSE

/obj/item/clothing/under/oldman
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "oldman"
	inhand_icon_state = "oldman"
	name = "oldman suit"
	can_adjust = FALSE
	desc = "Hope, what young people don't kill you"
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/security/officer/sec_corporate
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "sec_corporate"
	inhand_icon_state = "sec_corporate"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 10, "rad" = 0, "fire" = 40, "acid" = 40)

/obj/item/clothing/under/psychturtle
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "psychturtle"
	cold_protection = 200
	can_adjust = FALSE
	min_cold_protection_temperature = 60
	inhand_icon_state = "psychturtle"
	alt_covers_chest = FALSE
	name = "sweater turtleneck"
	desc = "This sweater looks unusual"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/security/head_of_security/hos_corporate1
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "hos_corporate1"
	inhand_icon_state = "hos_corporate1"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/warden/warden_corporate
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "warden_corporate"
	inhand_icon_state = "warden_corporate"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/undertaker
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "undertaker"
	inhand_icon_state = "undertaker"
	can_adjust = FALSE
	name = "undertaker suit"
	desc = "For true undertakers"
	alt_covers_chest = FALSE

/obj/item/clothing/under/stripper
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	name = "stripper clothing"
	desc = "To seduce someone?"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/stripper/g
	icon_state = "stripper_g"
	inhand_icon_state = "stripper_g"

/obj/item/clothing/under/stripper/p
	icon_state = "stripper_p"
	inhand_icon_state = "stripper_p"

/obj/item/clothing/under/swim
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	name = "swim suit"
	desc = "Good dive in space"
	alt_covers_chest = FALSE
	can_adjust = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/swim/blue
	icon_state = "swim_blue"
	inhand_icon_state = "swim_blue"

/obj/item/clothing/under/swim/red
	icon_state = "swim_red"
	inhand_icon_state = "swim_red"

/obj/item/clothing/under/swim/purp
	icon_state = "swim_purp"
	inhand_icon_state = "swim_purp"

/obj/item/clothing/under/swim/green
	icon_state = "swim_green"
	inhand_icon_state = "swim_green"



/obj/item/melee/cultblade
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_BACK

/obj/item/melee/cultblade/great
	force = 75
	throwforce = 40
	block_chance = 70

/obj/item/clothing/suit/armor/plate/crusader
	armor = list("melee" = 80, "bullet" = 65, "laser" = 100,"energy" = 100, "bomb" = 75, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)

/obj/item/shield/riot/roman
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	block_chance = 100
	explosion_block = 0
	max_integrity = 1.#INF
	obj_integrity = 1.#INF
	force = 30
	throwforce = 20

/obj/item/clothing/suit/space/syndicate/black/engie
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF

/obj/item/clothing/under/syndicate/combat
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF

/obj/item/clothing/head/helmet/space/syndicate/black/engie
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF

/obj/item/clothing/head/helmet/helmet_command
	name = "command helmet"
	desc = "Helmet with special line at back side like symbol of command?"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_command"
	inhand_icon_state = "helmet_command"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/helmet_security
	name = "security helmet"
	desc = "Helmet with special line at back side like symbol of security."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_security"
	inhand_icon_state = "helmet_security"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/helmet_pcrc
	name = "pcrc helmet"
	desc = "Helmet with special line at back side like symbol of pcrc."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_pcrc"
	inhand_icon_state = "helmet_pcrc"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/head/helmet/helmet_nt
	name = "nt helmet"
	desc = "Helmet for NT conscripts?"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "helmet_nt"
	inhand_icon_state = "helmet_nt"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

/obj/item/clothing/suit/toggle/trackjackettcc
	name = "track jacket TTC"
	desc = "Track jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "trackjackettcc"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "trackjackettcc"

/obj/item/clothing/under/rank/security/officer/ert_uniform
	name = "ert jumpskirt"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Marine uniform"
	icon_state = "ert_uniform"
	inhand_icon_state = "ert_uniform"
	alt_covers_chest = FALSE

/obj/item/clothing/suit/toggle/labcoat/rdzeng
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_rd_zeng"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_rd_zeng"

/obj/item/clothing/suit/toggle/labcoat/rdheph
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_rd_heph"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_rd_heph"

/obj/item/clothing/suit/toggle/labcoat/rd1
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_rd1"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_rd1"

/obj/item/clothing/suit/toggle/labcoat/rd2
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_rd2"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_rd2"

/obj/item/clothing/suit/sciponcho_heph
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho_heph"
	inhand_icon_state = "sciponcho_heph"

/obj/item/clothing/suit/sciponcho_zeng
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho_zeng"
	inhand_icon_state = "sciponcho_zeng"

/obj/item/clothing/suit/sciponcho
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho"
	inhand_icon_state = "sciponcho"

/obj/item/clothing/suit/sciponcho_nt
	desc = "Poncho for area of knowledge"
	name = "scientist poncho"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "sciponcho_nt"
	inhand_icon_state = "sciponcho_nt"

/obj/item/clothing/suit/toggle/labcoat/zeng
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_zeng"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "labcoat_zeng"


/obj/item/clothing/suit/toggle/labcoat/heph
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_rd_heph"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "labcoat_rd_heph"

/obj/item/clothing/suit/toggle/labcoat/sci
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_1"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "labcoat_1"

/obj/item/clothing/suit/toggle/labcoat/dais
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_dais"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "labcoat_dais"

/obj/item/clothing/suit/toggle/labcoat/xy
	name = "scientist labcoat"
	desc = "Advanced large labcoat for more risk science"
	armor = list("melee" = 30, "bullet" = 0, "laser" = 20,"energy" = 20, "bomb" = 20, "bio" = 100, "rad" = 20, "fire" = 75, "acid" = 90)
	icon_state = "labcoat_xy"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_xy"

/obj/item/clothing/under/maid
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "maid"
	inhand_icon_state = "maid"
	body_parts_covered = CHEST|GROIN
	name = "maid uniform"
	can_adjust = FALSE
	desc = "For oldstyle maids"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/medical/doctor/brig_phys
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "brig_phys"
	inhand_icon_state = "brig_phys"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	name = "psychologist uniform"
	desc = "Little useful work"

/obj/item/clothing/under/rank/security/officer/altsecurity
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "altsecurity"
	inhand_icon_state = "altsecurity"




/obj/item/clothing/under/victorian/vest/grey
	icon_state = "victorianvestg"
	inhand_icon_state = "victorianvestg"

/obj/item/clothing/under/victorian/vest/black
	icon_state = "victorianvestb"
	inhand_icon_state = "victorianvestb"





/obj/item/clothing/suit/militaryjacket
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 15, "bullet" = 15, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 20)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/service_co_coat
	name = "service jacket"
	desc = "Jacket for scientists."
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 50, "rad" = 10, "fire" = 30, "acid" = 40)
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/militaryjacket/desert
	name = "desert jacket"
	desc = "Desert military jacket"
	icon_state = "desertmiljacket"
	inhand_icon_state = "desertmiljacket"

/obj/item/clothing/suit/militaryjacket/sec
	name = "security jacket"
	desc = "Security military jacket"
	icon_state = "secmiljacket"
	inhand_icon_state = "secmiljacket"

/obj/item/clothing/suit/militaryjacket/navy
	name = "navy jacket"
	desc = "Navy military jacket"
	icon_state = "navymiljacket"
	inhand_icon_state = "navymiljacket"

/obj/item/clothing/suit/toggle/labcoat/labcoat_sec
	name = "security labcoat"
	desc = "A labcoat that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 5,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 40, "acid" = 75)
	icon_state = "labcoat_sec"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "labcoat_sec"

/obj/item/clothing/suit/armor/vest/brig_phys_vest
	name = "psychologist vest"
	desc = "Looks like for security, but not fully, perhabs."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "brig_phys_vest"
	inhand_icon_state = "brig_phys_vest"
	body_parts_covered = CHEST
	armor = list("melee" = 15, "bullet" = 15, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/suit/armor/vest/paramedic_vest
	name = "paramedic vest"
	desc = "Special vest for paramedics."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "paramedic_vest"
	inhand_icon_state = "paramedic_vest"
	body_parts_covered = CHEST
	armor = list("melee" = 15, "bullet" = 15, "laser" = 10,"energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/suit/armor/riot/knight/heavy
	name = "heavy knight suit"
	desc = "A suit of semi-flexible polycarbonate body armor with heavy padding to protect against melee attacks. Helps the wearer resist shoving in close quarters."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "knight_grey"
	inhand_icon_state = "knight_grey"
	armor = list("melee" = 80, "bullet" = 75, "laser" = 40, "energy" = 25, "bomb" = 60, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 80)
	slowdown = 0.7

/obj/item/clothing/suit/armor/changeling
	icon = 'white/Wzzzz/clothing/suits.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list("melee" = 50, "bullet" = 60, "laser" = 20, "energy" = 15, "bomb" = 60, "bio" = 100, "rad" = 0, "fire" = 50, "acid" = 70)

/obj/item/clothing/suit/space/hardsuit/deathsquad/ueg
	armor = list("melee" = 70, "bullet" = 70, "laser" = 40, "energy" = 40, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 90)
	actions = null
	actions_types = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "uegarmor"
	inhand_icon_state = "uegarmor"
	name = "ueg armor"
	desc = "Special armor for special forces."

/obj/item/clothing/suit/space/ashwalker
	armor = list("melee" = 40, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 60, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 80)
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ashwalker"
	inhand_icon_state = "ashwalker"
	clothing_flags = STOPSPRESSUREDAMAGE|LAVAPROTECT
	resistance_flags = FIRE_PROOF|LAVA_PROOF|FREEZE_PROOF
	name = "ashwalker armor"
	desc = "Good armor for adventures in lava areas."

/obj/item/clothing/suit/armor/vest/alt/blueshield
	name = "blueshield armor vest"
	desc = "Armor vest for forces of Blushield."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blueshield_old"
	armor = list("melee" = 35, "bullet" = 35, "laser" = 35, "energy" = 15, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50)
	inhand_icon_state = "blueshield_old"

/obj/item/clothing/suit/armor/vest/blueshield
	name = "blueshield armor vest"
	desc = "Armor vest for forces of Blushield."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "blueshield"
	armor = list("melee" = 35, "bullet" = 35, "laser" = 35, "energy" = 15, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50)
	inhand_icon_state = "blueshield"



/obj/item/clothing/suit/armor/vest/leather/ladiesvictoriancoat
	name = "victorian coat"
	desc = "Stylish victorian coat."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ladiesvictoriancoat"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 5, "energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 5)
	inhand_icon_state = "ladiesvictoriancoat"

/obj/item/clothing/suit/armor/vest/leather/ladiesredvictoriancoat
	name = "victorian coat"
	desc = "Stylish victorian coat."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "ladiesredvictoriancoat"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 5, "energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 5)
	inhand_icon_state = "ladiesredvictoriancoat"

/obj/item/clothing/suit/greymiljacket
	name = "grey jacket"
	desc = "Grey military jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	armor = list("melee" = 25, "bullet" = 15, "laser" = 10,"energy" = 10, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 20)
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "greymiljacket"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "greymiljacket"

/obj/item/clothing/suit/hooded/wintercoat/science/zeng
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_zeng"
	inhand_icon_state = "coatscience_zeng"

/obj/item/clothing/suit/hooded/wintercoat/science/heph
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_heph"
	inhand_icon_state = "coatscience_heph"

/obj/item/clothing/suit/hooded/wintercoat/science/dais
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_dais"
	inhand_icon_state = "coatscience_dais"

/obj/item/clothing/suit/hooded/wintercoat/science/alt
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience1"
	inhand_icon_state = "coatscience1"

/obj/item/clothing/suit/hooded/wintercoat/science/nt
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "coatscience_nt"
	inhand_icon_state = "coatscience_nt"

/obj/item/clothing/suit/m_dress
	name = "jacket"
	desc = "Just jacket"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "m_dress"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_dress"

/obj/item/clothing/suit/m_dress_int
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "m_dress_int"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_dress_int"

/obj/item/clothing/suit/m_service
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "m_service"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_service"

/obj/item/clothing/suit/m_service_int
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "m_service_int"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "m_service_int"

/obj/item/clothing/suit/infsuit
	name = "jacket"
	desc = "Just jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 10, "bio" = 10, "rad" = 0, "fire" = 10, "acid" = 15)
	icon_state = "infsuit"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "infsuit"

/obj/item/clothing/suit/toggle/suitjacket
	name = "suit jacket"
	desc = "Just suit jacket"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "suitjacket"
	body_parts_covered = CHEST|GROIN
	inhand_icon_state = "suitjacket"

/obj/item/clothing/suit/armor/vest/german/webvest/m_vest
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "m_vest"
	inhand_icon_state = "m_vest"
	name = "medical vest"
	desc = "Special vest for medics"

/obj/item/clothing/head/helmet/space/eva
	name = "Pirate"
	desc = "Pirate technologies"
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "pirha"
	inhand_icon_state = "pirha"

/obj/item/clothing/head/helmet/space/eva/grey
	icon_state = "pirhag"
	inhand_icon_state = "pirhag"

/obj/item/clothing/head/helmet/space/eva/black
	icon_state = "pirhab"
	inhand_icon_state = "pirhab"

/obj/item/clothing/head/helmet/space/syndicate
	name = "Pirate space helmet"
	desc = "Pirate technologies"
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "pirhald"
	inhand_icon_state = "pirhald"

/obj/item/clothing/head/helmet/space/syndicate/grey
	icon_state = "pirhaldg"
	inhand_icon_state = "pirhaldg"

/obj/item/clothing/head/helmet/space/syndicate/black
	icon_state = "pirhaldb"
	inhand_icon_state = "pirhaldb"

/obj/item/gun/energy/decloner
	burst_size = 3
	pin = /obj/item/firing_pin/dna
	cell = /obj/item/stock_parts/cell/high/plus
	selfcharge = 10


/obj/item/clothing/head/helmet/helmet_tac/helmet_allya1
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon = 'white/Wzzzz/pirha.dmi'
	icon_state = "helmet_allya1"
	inhand_icon_state = "helmet_allya1"

/obj/item/clothing/head/helmet/helmet_tac/helmet_allya0
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon = 'white/Wzzzz/pirha.dmi'
	icon_state = "helmet_allya0"
	inhand_icon_state = "helmet_allya0"

/obj/item/clothing/suit/toggle/labcoat/sco
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_cso"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_cso"

/obj/item/clothing/suit/toggle/labcoat/aptare
	name = "aptare labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_aptare"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "labcoat_aptare"

/obj/item/clothing/suit/toggle/labcoat/flip
	name = "flip labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "flip_labcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "flip_labcoat"

/obj/item/clothing/suit/toggle/labcoat/poehl
	name = "poehl labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "poehl_labcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	inhand_icon_state = "poehl_labcoat"

/obj/item/clothing/under/chickensuit
	name = "chicken suit"
	desc = "For future petuch."
	can_adjust = FALSE
	icon_state = "chickensuit"
	inhand_icon_state = "chickensuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET
	icon = 'icons/obj/clothing/suits.dmi'
	worn_icon = 'icons/mob/clothing/suit.dmi'
	has_sensor = NO_SENSORS



/obj/item/clothing/suit/toggle/labcoat/labcoat_black
	name = "scientist labcoat"
	desc = "A suit that make some protection against some accidents at work"
	armor = list("melee" = 15, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 75, "rad" = 0, "fire" = 50, "acid" = 75)
	icon_state = "labcoat_black"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = "labcoat_black"

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/blackgrey
	icon = 'white/Wzzzz/pirha.dmi'
	inhand_icon_state = "syndievestbg"
	icon_state = "syndievestbg"
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/black
	icon = 'white/Wzzzz/pirha.dmi'
	inhand_icon_state = "syndievestg"
	icon_state = "syndievestg"
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/dark
	icon = 'white/Wzzzz/pirha.dmi'
	inhand_icon_state = "syndievestb"
	icon_state = "syndievestb"
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/head/wizard/battlemage
	name = "battle wizard helmet"
	desc = "Shield magic."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	resistance_flags = NONE|ACID_PROOF|INDESTRUCTIBLE|UNACIDABLE|FIRE_PROOF|FREEZE_PROOF|LAVA_PROOF
	armor = list("melee" = 80, "bullet" = 60, "laser" = 70,"energy" = 80, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 75)
	inhand_icon_state = "battlemage"
	icon_state = "battlemage"

/obj/item/clothing/head/helmet/swat
	inhand_icon_state = "sind"
	icon_state = "sind"
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/head/helmet/m_helmet
	name = "helmet"
	desc = "Helmet."
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "m_helmet"
	inhand_icon_state = "m_helmet"
	flags_inv = HIDEEARS
	visor_flags_inv = HIDEEARS
	resistance_flags = NONE
	armor = list("melee" = 40, "bullet" = 35, "laser" = 40,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 20)

/obj/item/clothing/under/syndicate/green
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "syndicate"
	inhand_icon_state = "syndicate"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/syndicate/tacticool
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "tactifool"
	inhand_icon_state = "tactifool"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/syndicate/tacticool/green
	icon_state = "tactifoolg"
	inhand_icon_state = "tactifoolg"

/obj/item/clothing/under/syndicate/tacticool/black
	icon_state = "tactifoolb"
	inhand_icon_state = "tactifoolb"

/obj/item/clothing/suit/hooded/chaplainsuit/fiendcowl
	name = "fiend cowl"
	desc = "Darkness inside."
	icon_state = "fiendcowl"
	inhand_icon_state = "fiendcowl"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/fiend
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 50,"energy" = 30, "bomb" = 10, "bio" = 30, "rad" = 0, "fire" = 30, "acid" = 10, "magic" = 25)
	icon = 'white/Wzzzz/clothing/suits.dmi'
	allowed = list (/obj/item/storage/book, /obj/item/nullrod, /obj/item/reagent_containers/food/drinks, /obj/item/storage/fancy, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/gun/ballistic/automatic/pistol, /obj/item/ammo_box/magazine, /obj/item/gun/energy/pulse/pistol, /obj/item/kitchen/knife)

/obj/item/clothing/head/hooded/fiend
	name = "fiend hood"
	desc = "Darkness inside."
	icon_state = "fiendhood"
	inhand_icon_state = "fiendhood"
	body_parts_covered = HEAD
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	flags_inv = HIDEHAIR|HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	armor = list("melee" = 30, "bullet" = 20, "laser" = 50,"energy" = 30, "bomb" = 10, "bio" = 30, "rad" = 0, "fire" = 30, "acid" = 10, "magic" = 25)

/obj/item/clothing/suit/hooded/chaplainsuit/fiendcowl/robe
	name = "fiend robe"
	icon_state = "fiendrobe"
	inhand_icon_state = "fiendrobe"
	hoodtype = /obj/item/clothing/head/hooded/fiend/robe
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/head/hooded/fiend/robe
	icon_state = "fiendvisage"
	inhand_icon_state = "fiendvisage"
	name = "fiend visage"
	armor = list("melee" = 35, "bullet" = 25, "laser" = 50,"energy" = 30, "bomb" = 30, "bio" = 30, "rad" = 0, "fire" = 40, "acid" = 10, "magic" = 25)

/obj/item/clothing/suit/fire/atmos/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "atmos_firesuitg"
	inhand_icon_state = "atmos_firesuitg"

/obj/item/clothing/suit/fire/atmos/black
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "atmos_firesuitb"
	inhand_icon_state = "atmos_firesuitb"

/obj/item/clothing/suit/armor/vest/warden/alt/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_jacketg"
	inhand_icon_state = "warden_jacketg"

/obj/item/clothing/suit/armor/vest/warden/alt/black
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_jacketb"
	inhand_icon_state = "warden_jacketb"

/obj/item/clothing/suit/armor/vest/warden/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_altg"
	inhand_icon_state = "warden_altg"

/obj/item/clothing/suit/armor/vest/warden/black
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "warden_altb"
	inhand_icon_state = "warden_altb"

/obj/item/clothing/head/hardhat/atmos
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	hat_type = "atmos"

/obj/item/clothing/head/hardhat/atmos/grey
	icon_state = "hardhat0_atmosg"
	inhand_icon_state = "hardhat0_atmosg"
	hat_type = "atmosg"

/obj/item/clothing/head/hardhat/atmos/black
	icon_state = "hardhat0_atmosb"
	inhand_icon_state = "hardhat0_atmosb"
	hat_type = "atmosb"


/obj/item/clothing/head/hardhat/grey
	icon_state = "hardhat0g"
	inhand_icon_state = "hardhat0g"
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/head/hardhat/red/black
	icon_state = "hardhat0b"
	inhand_icon_state = "hardhat0b"
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/fire/firefighter
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/suit/fire/firefighter/grey
	icon_state = "firesuitg"
	inhand_icon_state = "firesuitg"

/obj/item/clothing/suit/fire/firefighter/black
	icon_state = "firesuitb"
	inhand_icon_state = "firesuitb"



/obj/item/clothing/suit/armor/vest/leather/ladiesvictoriancoat/grey
	icon_state = "ladiesvictoriancoatg"
	inhand_icon_state = "ladiesvictoriancoatg"

/obj/item/clothing/suit/armor/vest/leather/ladiesvictoriancoat/black
	icon_state = "ladiesvictoriancoatb"
	inhand_icon_state = "ladiesvictoriancoatb"

/obj/item/clothing/under/syndicate/fiendsuit
	name = "fiend suit"
	desc = "Darkness inside"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "fiendsuit"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "fiendsuit"
	cold_protection = 50
	min_cold_protection_temperature = 50
	armor = list("melee" = 10, "bullet" = 10, "laser" = 5,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "magic" = 25)

/obj/item/clothing/under/syndicate/fienddress
	name = "fiend dress"
	desc = "Darkness inside"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "fienddress"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	body_parts_covered = CHEST|GROIN|LEGS
	cold_protection = CHEST|GROIN|LEGS
	inhand_icon_state = "fienddress"
	armor = list("melee" = 10, "bullet" = 10, "laser" = 5,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "magic" = 25)

/obj/item/clothing/under/syndicate/huntress
	name = "huntress outfit"
	desc = "Leather, light and open"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "huntress"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	body_parts_covered = CHEST|GROIN|LEGS
	cold_protection = CHEST|GROIN|LEGS
	inhand_icon_state = "huntress"
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 0)

/obj/item/clothing/under/syndicate/hunter
	name = "hunter outfit"
	desc = "Leather, light and open"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "hunter"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	body_parts_covered = CHEST|GROIN|LEGS
	cold_protection = CHEST|GROIN|LEGS
	inhand_icon_state = "hunter"
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 0)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/hunter

/obj/item/clothing/under/rank/security/officer/pcrcsuit
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "pcrcsuit"
	inhand_icon_state = "pcrcsuit"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/syndicate/familiartunic
	name = "familiar tunic"
	desc = "So familiar..."
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "familiartunic"
	inhand_icon_state = "familiartunic"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 5)

/obj/item/clothing/under/rank/engineering/engineer/morpheus
	name = "комбинезон рабочего"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Для тяжёлой работы."
	icon_state = "morpheus"
	can_adjust = FALSE
	inhand_icon_state = "morpheus"
	alt_covers_chest = FALSE
	armor = list("melee" = 20, "bullet" = 15, "laser" = 10,"energy" = 5, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 15)

/obj/item/clothing/under/syndicate/grimhoodie
	name = "grim hoodie"
	desc = "Grim hooodiiiee"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "grimhoodie"
	inhand_icon_state = "grimhoodie"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 5)

/obj/item/clothing/under/syndicate/skrell_suit
	name = "skrell jumpsuit"
	desc = "For skrells, but for humans"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "skrell_suit"
	inhand_icon_state = "skrell_suit"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10,"energy" = 0, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 10)

/obj/item/clothing/suit/hooded/chaplainsuit/caretakercloak
	name = "caretaker cloak"
	desc = "To take care."
	icon_state = "caretakercloak"
	inhand_icon_state = "caretakercloak"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/caretakercloak
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "magic" = 10)
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/head/hooded/caretakercloak
	name = "caretaker hood"
	desc = "To take care."
	icon_state = "caretakerhood"
	inhand_icon_state = "caretakerhood"
	body_parts_covered = HEAD
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	flags_inv = HIDEHAIR|HIDEEARS|HIDEEYES|HIDEFACE
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "magic" = 10)

/obj/item/clothing/suit/hooded/chaplainsuit/overseercloak
	name = "overseer cloak"
	desc = "See everything."
	icon_state = "overseercloak"
	inhand_icon_state = "overseercloak"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/overseercloak
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20,"energy" = 20, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50, "magic" = 30)
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/head/hooded/overseercloak
	name = "overseer hood"
	desc = "See everything."
	icon_state = "necromancer"
	inhand_icon_state = "necromancer"
	body_parts_covered = HEAD
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	flags_inv = HIDEHAIR|HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEFACIALHAIR
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20,"energy" = 20, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50, "magic" = 30)

/obj/item/clothing/suit/hooded/chaplainsuit/star_traitor
	name = "star traitor cloak"
	desc = "Dark trait."
	icon_state = "star_traitor"
	inhand_icon_state = "star_traitor"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/star_traitor
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 20, "bullet" = 10, "laser" = 20,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 20)
	icon = 'white/Wzzzz/clothing/suits.dmi'

/obj/item/clothing/head/hooded/star_traitor
	name = "star traitor hood"
	desc = "Dark trait."
	icon_state = "star_traitor"
	inhand_icon_state = "star_traitor"
	body_parts_covered = HEAD
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	flags_inv = HIDEHAIR|HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDEMASK
	armor = list("melee" = 20, "bullet" = 10, "laser" = 20,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 20)

/obj/item/clothing/suit/hospitalgown
	name = "hospital vest"
	desc = "Hospital going down..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "hospitalgown"
	inhand_icon_state = "hospitalgown"
	body_parts_covered = CHEST

/obj/item/clothing/suit/infdress
	name = "dress"
	desc = "infdress.png"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "infdress"
	inhand_icon_state = "infdress"
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/under/rank/security/officer/guard
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	name = "guard jumpsuit"
	desc = "Not usual security, that's guard"
	icon_state = "guard"
	inhand_icon_state = "guard"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/guard/nt
	icon_state = "guard_nt"
	inhand_icon_state = "guard_nt"

/obj/item/clothing/under/rank/security/officer/guard/heph
	icon_state = "guard_heph"
	inhand_icon_state = "guard_heph"

/obj/item/clothing/under/syndicate/kimono
	name = "kimono"
	desc = "Kimono!"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "kimono"
	inhand_icon_state = "kimono"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	armor = list("melee" = 5, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = 5, "acid" = 5)

/obj/item/clothing/under/dais
	name = "dais suit"
	desc = "Dais..."
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "dais"
	inhand_icon_state = "dais"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/skinner
	name = "skinner suit"
	desc = "Someone can get heart attack..."
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "skinner"
	inhand_icon_state = "skinner"
	can_adjust = FALSE
	has_sensor = NO_SENSORS
	alt_covers_chest = FALSE

/obj/item/clothing/under/confed
	name = "confed suit"
	desc = "Some looks like navy suit."
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "confed"
	inhand_icon_state = "confed"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/wetsuit
	name = "wetsuit"
	desc = "For swimming?"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "wetsuit"
	inhand_icon_state = "wetsuit"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/m_utility
	name = "utility jumpsuit"
	desc = "Unusual style"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "m_utility"
	inhand_icon_state = "m_utility"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/m_service
	name = "service jumpsuit"
	desc = "Unusual style"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "m_service"
	inhand_icon_state = "m_service"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/bluetunic
	name = "blue tunic"
	desc = "Some pretty."
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "bluetunic"
	inhand_icon_state = "bluetunic"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/caretaker
	name = "caretaker outfit"
	desc = "To take care."
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "caretaker"
	inhand_icon_state = "caretaker"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/inf_mob
	name = "mob outfit"
	desc = "Now you're mob..."
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "inf_mob"
	inhand_icon_state = "inf_mob"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	has_sensor = NO_SENSORS

/obj/item/clothing/under/scrubs
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "scrubs"
	inhand_icon_state = "scrubs"
	alt_covers_chest = FALSE
	can_adjust = FALSE
	name = "scrubs"
	desc = "For sanitation"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/scrubs/white
	icon_state = "scrubs"
	inhand_icon_state = "scrubs"

/obj/item/clothing/under/scrubs/black
	icon_state = "scrubsblack"
	inhand_icon_state = "scrubsblack"

/obj/item/clothing/under/scrubs/purple
	icon_state = "scrubspurple"
	inhand_icon_state = "scrubspurple"

/obj/item/clothing/under/scrubs/green
	icon_state = "scrubsgreen"
	inhand_icon_state = "scrubsgreen"

/obj/item/clothing/under/scrubs/blue
	icon_state = "scrubsblue"
	inhand_icon_state = "scrubsblue"

/obj/item/clothing/under/rank/security/officer/pilot_heph
	name = "NT pilot uniform"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "For pilots"
	icon_state = "pilot_heph"
	can_adjust = FALSE
	inhand_icon_state = "pilot_heph"
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/security/officer/pilot
	name = "pilot uniform"
	icon = 'white/Wzzzz/clothing/uniforms.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "For pilots"
	icon_state = "pilot"
	can_adjust = FALSE
	inhand_icon_state = "pilot"
	alt_covers_chest = FALSE

/obj/item/clothing/suit/space/fragile
	name = "emergency spacesuit"
	desc = "For emergency, but not only"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "space_emergency"
	inhand_icon_state = "space_emergency"
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 0, "fire" = 40, "acid" = 30)

/obj/item/clothing/suit/space/eva
	name = "spacesuit"
	desc = "Classic..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "space"
	inhand_icon_state = "space"
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20, "energy" = 10, "bomb" = 40, "bio" = 100, "rad" = 30, "fire" = 70, "acid" = 50)

/obj/item/clothing/suit/armor/riot
	name = "champion armor"
	desc = "You're champion..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "champarmor"
	inhand_icon_state = "champarmor"
	armor = list("melee" = 50, "bullet" = 50, "laser" = 20, "energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 0, "fire" = 70, "acid" = 60)

/obj/item/clothing/suit/armor/riot/knight/champion
	name = "champion armor"
	desc = "You're space champion..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "star_champion"
	inhand_icon_state = "star_champion"
	armor = list("melee" = 60, "bullet" = 40, "laser" = 10, "energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 0, "fire" = 70, "acid" = 60)

/obj/item/clothing/suit/chaplainsuit/holidaypriest
	name = "oracle suit"
	desc = "You're space oracle..."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "star_oracle"
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF|UNACIDABLE|LAVA_PROOF|INDESTRUCTIBLE
	inhand_icon_state = "star_oracle"
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40, "energy" = 40, "bomb" = 40, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 50, "magic" = 100)

/obj/item/clothing/shoes/sneakers
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'

/obj/item/clothing/shoes/sneakers/white
	icon_state = "white"
	inhand_icon_state = "white"

/obj/item/clothing/shoes/sneakers/red
	icon_state = "red"
	inhand_icon_state = "red"

/obj/item/clothing/shoes/sneakers/black
	icon_state = "black"
	inhand_icon_state = "black"

/obj/item/clothing/shoes/sneakers/brown
	icon_state = "brown"
	inhand_icon_state = "brown"

/obj/item/clothing/shoes/sneakers/orange
	icon_state = "orange"
	inhand_icon_state = "orange"

/obj/item/clothing/shoes/sneakers/blue
	icon_state = "blue"
	inhand_icon_state = "blue"

/obj/item/clothing/shoes/sneakers/green
	icon_state = "green"
	inhand_icon_state = "green"

/obj/item/clothing/shoes/sneakers/purple
	icon_state = "purple"
	inhand_icon_state = "purple"

/obj/item/clothing/shoes/sneakers/yellow
	icon_state = "yellow"
	inhand_icon_state = "yellow"

/obj/item/clothing/shoes/jackboots
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'

/obj/item/clothing/shoes/jackboots/dutylong
	icon_state = "dutylong"
	inhand_icon_state = "dutylong"
	name = "long duty boots"
	desc = "Duty with style."

/obj/item/clothing/shoes/jackboots/medievalboots
	icon_state = "medievalboots"
	inhand_icon_state = "medievalboots"
	name = "medieval boots"
	desc = "Long ago, but so near."

/obj/item/clothing/shoes/jackboots/desert
	icon_state = "desert"
	inhand_icon_state = "desert"
	name = "desert boots"
	desc = "For sand adventures."

/obj/item/clothing/shoes/jackboots/jungle
	icon_state = "jungle"
	inhand_icon_state = "jungle"
	name = "jungle boots"
	desc = "For jungle adventures."

/obj/item/clothing/shoes/jackboots/fiendshoes
	icon_state = "fiendshoes"
	inhand_icon_state = "fiendshoes"
	name = "fiend shoes"
	desc = "Darkness inside."

/obj/item/clothing/shoes/jackboots/grimboots
	icon_state = "grimboots"
	inhand_icon_state = "grimboots"
	name = "grim boots"
	desc = "Grim boots."

/obj/item/clothing/shoes/jackboots/infshoes
	icon_state = "infshoes"
	inhand_icon_state = "infshoes"
	name = "shoes"
	desc = "Infshoes..."

/obj/item/clothing/under/m_utility_i
	name = "utility jumpsuit"
	desc = "Unusual style"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "m_utility_i"
	inhand_icon_state = "m_utility_i"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/m_service_i
	name = "service jumpsuit"
	desc = "Unusual style"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "m_service_i"
	inhand_icon_state = "m_service_i"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/cargo/tech/work
	name = "worker uniform"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Work, work and work"
	icon_state = "work"
	inhand_icon_state = "work"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/rank/cargo/tech/work/zeng
	icon_state = "work_zeng"
	inhand_icon_state = "work_zeng"

/obj/item/clothing/under/rank/cargo/tech/work/heph
	icon_state = "work_heph"
	inhand_icon_state = "work_heph"

/obj/item/clothing/under/rank/cargo/tech/work/nt
	icon_state = "work_nt"
	inhand_icon_state = "work_nt"

/obj/item/clothing/under/smock
	name = "smock uniform"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Classic style"
	icon_state = "smock"
	inhand_icon_state = "smock"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/smock/smockexec
	icon_state = "smockexec"
	inhand_icon_state = "smockexec"

/obj/item/clothing/under/smock/nt
	icon_state = "smock_nt"
	inhand_icon_state = "smock_nt"

/obj/item/clothing/under/smock/smockexec_nt
	icon_state = "smockexec_nt"
	inhand_icon_state = "smockexec_nt"

/obj/item/clothing/under/smock/zeng
	icon_state = "smock_zeng"
	inhand_icon_state = "smock_zeng"

/obj/item/clothing/under/smock/smockexec_zeng
	icon_state = "smockexec_zeng"
	inhand_icon_state = "smockexec_zeng"

/obj/item/clothing/under/smock/heph
	icon_state = "smock_heph"
	inhand_icon_state = "smock_heph"

/obj/item/clothing/under/smock/smockexec_heph
	icon_state = "smockexec_heph"
	inhand_icon_state = "smockexec_heph"

/obj/item/clothing/under/suit
	name = "suit uniform"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	desc = "Classic style"
	icon_state = "suit"
	inhand_icon_state = "suit"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/suit/nt
	icon_state = "suit_nt"
	inhand_icon_state = "suit_nt"

/obj/item/clothing/under/suit/heph
	icon_state = "suit_heph"
	inhand_icon_state = "suit_heph"

/obj/item/clothing/under/suit/zeng
	icon_state = "suit_zeng"
	inhand_icon_state = "suit_zeng"

/obj/item/clothing/under/dress
	name = "dress uniform"
	desc = "Stylish dress"
	icon_state = "m_dress"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	inhand_icon_state = "m_dress"
	has_sensor = NO_SENSORS

/obj/item/clothing/under/dress_i
	name = "dress uniform"
	desc = "Stylish dress"
	icon_state = "m_dress_i"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	inhand_icon_state = "m_dress_i"
	has_sensor = NO_SENSORS


/obj/item/storage/toolbox/ammo/Kar98

/obj/item/storage/toolbox/ammo/Kar98/PopulateContents()
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)
	new /obj/item/ammo_box/magazine/a792x57(src)

/obj/item/storage/toolbox/ammo/STG

/obj/item/storage/toolbox/ammo/STG/PopulateContents()
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)
	new /obj/item/ammo_box/magazine/stg(src)

/obj/item/storage/toolbox/ammo/MP40

/obj/item/storage/toolbox/ammo/MP40/PopulateContents()
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)
	new /obj/item/ammo_box/magazine/mp40(src)

/obj/item/storage/toolbox/ammo/G43

/obj/item/storage/toolbox/ammo/G43/PopulateContents()
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)
	new /obj/item/ammo_box/magazine/g43(src)

/obj/item/storage/toolbox/ammo/FG42

/obj/item/storage/toolbox/ammo/FG42/PopulateContents()
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)
	new /obj/item/ammo_box/magazine/fg42(src)

/obj/item/storage/toolbox/ammo/AK47

/obj/item/storage/toolbox/ammo/AK47/PopulateContents()
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
	new /obj/item/ammo_box/magazine/ak47mag(src)
*/
/obj/item/storage/toolbox/ammo/wt550

/obj/item/storage/toolbox/ammo/wt550/PopulateContents()
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
/*
/datum/component/storage/concrete/pockets/hunter/Initialize()
	. = ..()
	max_items = 3
	max_combined_w_class = 5
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/webvest/Initialize()
	. = ..()
	max_items = 5
	max_combined_w_class = 10
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/swatarmor/Initialize()
	. = ..()
	max_items = 3
	max_combined_w_class = 6
	max_w_class = WEIGHT_CLASS_NORMAL

/obj/item/clothing/mask/gas/stealth_rig/alt
	icon_state = "stealth_rig1"
	inhand_icon_state = "stealth_rig1"
	flags_cover = NONE
	visor_flags_cover = HEADCOVERSMOUTH
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR
	clothing_flags = MASKINTERNALS
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/hardhat/atmos/helmet
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	name = "firefighter helmet"
	desc = "Effectively than usual helmet"
	icon_state = "hardhat0_firefighter"
	inhand_icon_state = "hardhat0_firefighter"
	flags_cover = HEADCOVERSMOUTH | PEPPERPROOF | HEADCOVERSEYES
	visor_flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	flags_inv = HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEHAIR
	visor_flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDEHAIR|HIDEEARS
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT
	dynamic_hair_suffix = ""
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_fhair_suffix = ""
	hat_type = "firefighter"

/obj/item/clothing/head/hardhat/atmos/helmet/chief
	name = "firefighter chief helmet"
	desc = "Effectively than usual helmet"
	icon_state = "hardhat0_firefighterc"
	inhand_icon_state = "hardhat0_firefighterc"
	hat_type = "firefighterc"

/obj/item/clothing/glasses/hud/health/night
	icon_state = "securityhudnight"

/obj/item/clothing/head/helmet/siegehelmet/black
	color = "#505050"



/datum/supply_pack/security/armory/carbine_single
	name = "Assault Carbine Single-Pack"
	desc = "Contains one Assault Carbine. Requires Armory access to open."
	cost = 650
	contains = list(/obj/item/gun/ballistic/automatic/carbine)
	goody = TRUE

/datum/supply_pack/security/armory/carbine
	name = "Assault Carbine Crate"
	desc = "Contains two Assault Carbines. Requires Armory access to open."
	cost = 1210
	contains = list(/obj/item/gun/ballistic/automatic/carbine,
					/obj/item/gun/ballistic/automatic/carbine)
	crate_name = "auto rifle crate"

/datum/supply_pack/security/armory/carbineammo
	name = "Assault Carbine Ammo Crate"
	desc = "Contains four 25-round magazine for the Assault Carbine. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 400
	contains = list(/obj/item/ammo_box/magazine/carbine,
					/obj/item/ammo_box/magazine/carbine,
					/obj/item/ammo_box/magazine/carbine,
					/obj/item/ammo_box/magazine/carbine)

/datum/supply_pack/security/armory/carbineammo_single
	name = "Assault Carbine Ammo Single-Pack"
	desc = "Contains a 25-round magazine for the Assault Carbine. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 125
	contains = list(/obj/item/ammo_box/magazine/carbine)
	goody = TRUE

/datum/supply_pack/security/armory/secalthard
	name = "Adv. Security Hardsuit Crate"
	desc = "Contains a Advanced Security Hardsuit. Requires Armory access to open."
	cost = 750
	contains = list(/obj/item/clothing/suit/space/hardsuit/rig_secb)

/datum/supply_pack/security/trau_s
	name = "Traumatic Pistol Single-Pack"
	desc = "Contains a single traumatic pistol. Requires Armory access to open."
	cost = 90
	contains = list(/obj/item/gun/ballistic/automatic/pistol/traumatic)

/datum/supply_pack/security/trau
	name = "Traumatic Pistol Crate"
	desc = "Contains a two traumatic pistols. Requires Armory access to open."
	cost = 150
	contains = list(/obj/item/gun/ballistic/automatic/pistol/traumatic,
					/obj/item/gun/ballistic/automatic/pistol/traumatic)
*/

/datum/supply_pack/security/trau_a
	name = "Traumatic Pistol Ammo Crate"
	desc = "Contains a four 8-round magazines for \"Enforcer\" traumatic pistol. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic,
					/obj/item/ammo_box/magazine/traumatic)
/*
/datum/supply_pack/security/armory/mak_s
	name = "Makarov Pistol Single-Pack"
	desc = "Contains a single makarov pistol. Requires Armory access to open."
	cost = 200
	contains = list(/obj/item/gun/ballistic/automatic/pistol/makarov)

/datum/supply_pack/security/armory/mak
	name = "Makarov Pistol Crate"
	desc = "Contains a two makarov pistols. Requires Armory access to open."
	cost = 350
	contains = list(/obj/item/gun/ballistic/automatic/pistol/makarov,
					/obj/item/gun/ballistic/automatic/pistol/makarov)

/datum/supply_pack/security/armory/mak_a_s
	name = "Pistol 9mm Ammo Single-Pack"
	desc = "Contains a 15-round magazine for 9mm pistol. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 70
	contains = list(/obj/item/ammo_box/magazine/m9mm)

/datum/supply_pack/security/armory/mak_a
	name = "Pistol 9mm Ammo Crate"
	desc = "Contains a 15-round magazine for 9mm pistols. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 160
	contains = list(/obj/item/ammo_box/magazine/m9mm,
					/obj/item/ammo_box/magazine/m9mm,
					/obj/item/ammo_box/magazine/m9mm,
					/obj/item/ammo_box/magazine/m9mm)

/datum/supply_pack/security/armory/webvests
	name = "Advanced Vest Crate"
	desc = "Contains a two vest with pockets and bit more protection than usual vests. Requires Armory access to open."
	cost = 150
	contains = list(/obj/item/clothing/suit/armor/opvest,
					/obj/item/clothing/suit/armor/opvest)

/datum/supply_pack/medical/hardsuit
	name = "Medical Hardsuit Crate"
	desc = "Contains a medical hardsuit. Requires CMO access to open."
	cost = 350
	contains = list(/obj/item/clothing/suit/space/hardsuit/syndi/elite/medical_rig)

/datum/supply_pack/medical/pills
	name = "Universal Pill Bottle Crate"
	desc = "Contains 3 pill bottles with 2 epinephrine pills and 5 instabitaluri patches each of pill bottles. Requires CMO access to open."
	cost = 55
	contains = list(/obj/item/storage/pill_bottle/soldier,
					/obj/item/storage/pill_bottle/soldier,
					/obj/item/storage/pill_bottle/soldier)

/obj/item/clothing/suit/armor/vest/german/mercwebvest/grey
	icon_state = "mercwebvestg"
	inhand_icon_state = "mercwebvestg"

/obj/item/clothing/suit/armor/vest/swatarmor_german/grey
	icon_state = "swatarmorg"
	inhand_icon_state = "swatarmorg"

/obj/item/clothing/suit/armor/vest/swatarmor_german/black
	icon_state = "swatarmorb"
	inhand_icon_state = "swatarmorb"

/obj/item/clothing/head/helmet/swathelm/grey
	icon_state = "swathelmg"
	inhand_icon_state = "swathelmg"

/obj/item/clothing/head/helmet/swathelm/black
	icon_state = "swathelmb"
	inhand_icon_state = "swathelmb"

/obj/item/soap/syndie
	cleanspeed = 100
	obj_integrity = 25000
	toolspeed = 10
	uses = 10000

/obj/item/clothing/suit/mob
	name = "mob suit"
	desc = "Looks like mob, feels like human."
	worn_icon = 'white/Wzzzz/Souls/souls.dmi'
	icon = 'white/Wzzzz/Souls/soultem.dmi'
	drop_sound = null
	pickup_sound =  null
	blood_overlay_type = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HEAD|FULL_BODY
	cold_protection = CHEST|GROIN|LEGS|ARMS|HEAD|FULL_BODY
	heat_protection = CHEST|GROIN|LEGS|ARMS|HEAD|FULL_BODY
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN|BLOCK_GAS_SMOKE_EFFECT
	resistance_flags = LAVA_PROOF|FIRE_PROOF|UNACIDABLE|FREEZE_PROOF
	w_class = 4
	flags_cover = HEADCOVERSMOUTH|PEPPERPROOF|HEADCOVERSEYES
	visor_flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	visor_flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDEHAIR|HIDEEARS|HIDEJUMPSUIT|HIDENECK|FULL_BODY
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEMASK|HIDEJUMPSUIT

/obj/item/clothing/suit/mob/faithless
	icon_state = "faithless"
	inhand_icon_state = "faithless"
	flags_1 = NONE

/obj/item/clothing/suit/mob/standing
	icon_state = "standing"
	inhand_icon_state = "standing"
	visor_flags_inv = NONE|HIDEHAIR
	flags_inv = NONE|HIDEHAIR
	flags_1 = NONE

/obj/item/clothing/suit/mob/ash_whelp
	icon_state = "ash_whelp"
	inhand_icon_state = "ash_whelp"
	flags_1 = NONE

/obj/item/clothing/under/syndicate/fiendsuit/watcher
	name = "fiend suit"
	desc = "Darkness inside"
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	icon_state = "watchsuit"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "fiendsuit"
	cold_protection = 50
	min_cold_protection_temperature = 50
	armor = list("melee" = 10, "bullet" = 10, "laser" = 5, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10, "magic" = 25)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/watcher

/datum/component/storage/concrete/pockets/watcher/Initialize()
	. = ..()
	max_items = 15
	max_combined_w_class = 100
	max_w_class = WEIGHT_CLASS_HUGE

/obj/item/clothing/suit/armor/tac_hazmat
	name = "tactical hazmat suit"
	desc = "Armor for battle in hazard ."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "tac_hazmat"
	siemens_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "tac_hazmat"
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDENECK|HIDEJUMPSUIT
	visor_flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDENECK|HIDEJUMPSUIT
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50, "energy" = 30, "bomb" = 45, "bio" = 100, "rad" = 0, "fire" = 75, "acid" = 60)
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/tac_hazmat

/datum/component/storage/concrete/pockets/tac_hazmat/Initialize()
	. = ..()
	max_items = 6
	max_combined_w_class = 10
	max_w_class = WEIGHT_CLASS_NORMAL

/obj/item/clothing/suit/hazmat
	name = "hazmat suit"
	desc = "Suit for hazard environments."
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon_state = "hazmat_yellow"
	siemens_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	inhand_icon_state = "hazmat_yellow"
	armor = list("melee" = 10, "bullet" = 5, "laser" = 10, "energy" = 10, "bomb" = 15, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 90)
	dynamic_hair_suffix = ""


/obj/item/clothing/suit/hazmat/yellow

/obj/item/clothing/suit/hazmat/white
	inhand_icon_state = "hazmat_white"
	icon_state = "hazmat_white"

/obj/item/clothing/suit/hazmat/cmo
	inhand_icon_state = "hazmat_cmo"
	icon_state = "hazmat_cmo"

/obj/item/clothing/suit/hazmat/cyan
	inhand_icon_state = "hazmat_cyan"
	icon_state = "hazmat_cyan"

/obj/item/clothing/head/helmet/riot
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	name = "riot helmet"
	desc = "Riot helmet..."
	icon_state = "helmet_riot2"
	inhand_icon_state = "helmet_riot2"
	armor = list("melee" = 50, "bullet" = 35, "laser" = 10, "energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)

/obj/item/clothing/head/helmet/tac_helmet
	name = "tactical hazmat helmet"
	desc = "Armor for battle in hazard."
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "tac_helmet"
	flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	inhand_icon_state = "tac_helmet"
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50, "energy" = 30, "bomb" = 45, "bio" = 100, "rad" = 0, "fire" = 75, "acid" = 60)
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	dynamic_fhair_suffix = ""
	dynamic_hair_suffix = ""

/obj/item/clothing/head/radiation/hazmat
	name = "hazmat helmet"
	desc = "Helmet for hazard environments."
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "hazmat_yellow_head"
	inhand_icon_state = "hazmat_yellow_head"

/obj/item/clothing/head/radiation/hazmat/yellow

/obj/item/clothing/head/radiation/hazmat/white
	icon_state = "hazmat_white_head"
	inhand_icon_state = "hazmat_white_head"

/obj/item/clothing/head/radiation/hazmat/cmo
	icon_state = "hazmat_cmo_head"
	inhand_icon_state = "hazmat_cmo_head"

/obj/item/clothing/head/radiation/hazmat/cyan
	icon_state = "hazmat_cyan_head"
	inhand_icon_state = "hazmat_cyan_head"

/obj/item/clothing/head/service_co_cap_om
	name = "service hat"
	desc = "For service."
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "service_co_cap_om"
	inhand_icon_state = "service_co_cap_om"

/obj/item/clothing/under
	icon = 'white/Wzzzz/clothing/mob/uniform.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/uniform.dmi'

/obj/item/clothing/under/white
	name = "white uniform"
	desc = "White like angel."
	icon_state = "white"
	inhand_icon_state = "white"

/obj/item/clothing/under/suit1
	name = "suit"
	desc = "For work."
	icon_state = "suit"
	inhand_icon_state = "suit"

/obj/item/clothing/under/grey
	name = "grey uniform"
	desc = "Grey style."
	icon_state = "grey"
	inhand_icon_state = "grey"

/obj/item/clothing/under/d
	name = "D uniform"
	desc = "D style."
	icon_state = "d"
	inhand_icon_state = "d"

/obj/item/clothing/under/tac
	name = "tactical uniform"
	desc = "Looks some chill for tactics."
	icon_state = "tac"
	inhand_icon_state = "tac"

/obj/item/clothing/under/service_co
	name = "service uniform"
	desc = "For service."
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	icon_state = "service_co"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "service_co"

/obj/item/clothing/under/fservice_co
	name = "service uniform"
	desc = "For service."
	armor = list("melee" = 15, "bullet" = 5, "laser" = 5,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 15)
	icon_state = "fservice_co"
	body_parts_covered = CHEST|ARMS
	inhand_icon_state = "fservice_co"

/obj/item/clothing/under/uniform
	name = "combat uniform"
	desc = "Comfortable and warm"
	armor = list("melee" = 25, "bullet" = 20, "laser" = 15,"energy" = 15, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)
	icon_state = "uniform"
	can_adjust = FALSE
	alt_covers_chest = FALSE
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	inhand_icon_state = "uniform"
	cold_protection = 200
	min_cold_protection_temperature = 60

/obj/item/clothing/under/uniform/s
	name = "S combat uniform"
	icon_state = "uniform_s"
	inhand_icon_state = "uniform_s"

/obj/item/clothing/under/uniform/m
	name = "M combat uniform"
	icon_state = "uniform_m"
	inhand_icon_state = "uniform_m"

/obj/item/clothing/under/uniform/e
	name = "E combat uniform"
	icon_state = "uniform_e"
	inhand_icon_state = "uniform_e"

/obj/item/clothing/under/uniform/zc
	name = "ZC combat uniform"
	icon_state = "uniform_zc"
	inhand_icon_state = "uniform_zc"

/obj/item/clothing/under/uniform/gc
	name = "GC combat uniform"
	icon_state = "uniform_gc"
	inhand_icon_state = "uniform_gc"

/obj/item/clothing/under/uniform/ls
	name = "LS combat uniform"
	icon_state = "uniform_ls"
	inhand_icon_state = "uniform_ls"

/obj/item/clothing/under/uniform/lo
	name = "LO combat uniform"
	icon_state = "uniform_lo"
	inhand_icon_state = "uniform_lo"
	armor = list("melee" = 30, "bullet" = 25, "laser" = 20,"energy" = 20, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 60)

/obj/item/clothing/under/uniform/ct
	name = "CT combat uniform"
	icon_state = "uniform_ct"
	inhand_icon_state = "uniform_ct"

/obj/item/clothing/gloves/combat/evening_gloves/rubber_gloves
	icon_state = "rubber_gloves"
	inhand_icon_state = "rubber_gloves"
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)

/obj/item/clothing/gloves/combat/co
	icon_state = "co_gloves"
	inhand_icon_state = "co_gloves"
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'

/obj/item/clothing/mask/gas/alt
	icon_state = "gasmask_alt"
	inhand_icon_state = "gasmask_alt"
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)

/obj/item/clothing/head/helmet/siegehelmet/black
	color = "#505050"
/obj/item/twohanded/required/chainsaw

/obj/item/storage/belt/utility
	icon_state = "utility"
	inhand_icon_state = "utility"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/security/holster
	name = "holster"
	desc = "One belt - one gun."
	icon_state = "holster"
	inhand_icon_state = "holster"

/obj/item/storage/belt/security/holster/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(/obj/item/gun/energy/pulse/pistol,/obj/item/gun/ballistic/revolver,/obj/item/gun/ballistic/automatic/pistol/toy,/obj/item/gun/ballistic/automatic/pistol))

/obj/item/storage/belt/medical
	icon_state = "medicalbelt"
	inhand_icon_state = "medicalbelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/medical/ems
	icon_state = "emsbelta"
	inhand_icon_state = "emsbelta"

/obj/item/storage/belt/military
	icon_state = "emsbelt"
	inhand_icon_state = "emsbelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/janitor
	icon_state = "janibelt"
	inhand_icon_state = "janibelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/security
	icon_state = "gearbelt"
	inhand_icon_state = "gearbelt"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/security/forensic
	icon_state = "forensic"
	inhand_icon_state = "forensic"

/obj/item/storage/belt/security/forensic/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 10

/obj/item/storage/belt/security/forensic/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 7

/obj/item/clothing/head/helmet/metallichelmet
	name = "metallic helmet"
	desc = "Stylish medieval helmet"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "metallichelmet"
	inhand_icon_state = "metallichelmet"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR
	resistance_flags = NONE
	armor = list("melee" = 50, "bullet" = 20, "laser" = 20,"energy" = 10, "bomb" = 40, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 50)

/obj/item/clothing/head/helmet
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'

/obj/item/clothing/head/helmet/coif
	name = "coif"
	desc = "Medieval balaclava"
	icon_state = "coif"
	inhand_icon_state = "coif"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR
	resistance_flags = NONE
	armor = list("melee" = 20, "bullet" = 10, "laser" = 5,"energy" = 5, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/head/helmet/coif/helmet
	name = "coif helmet"
	desc = "Medieval balaclava with helmet"
	icon_state = "coif_helmet"
	inhand_icon_state = "coif_helmet"
	armor = list("melee" = 50, "bullet" = 20, "laser" = 20,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 40)

/obj/item/clothing/head/helmet/skull
	name = "skull mask"
	desc = "Life is full of cruel. That's one of examples."
	slot_flags = ITEM_SLOT_MASK
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "skull_mask"
	inhand_icon_state = "skull_mask"



/obj/item/clothing/mask
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'

/obj/item/clothing/mask/shemagh
	name = "shemagh"
	icon_state = "shemagh0"
	inhand_icon_state = "shemagh0"
	desc = "Old leather balaclava."
	flags_cover = HEADCOVERSMOUTH
	flags_inv = HIDEFACE|HIDEEARS|HIDEHAIR|HIDEFACIALHAIR
	visor_flags_inv = HIDEFACE|HIDEEARS|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/mask/shemagh/alt
	icon_state = "shemagh1"
	inhand_icon_state = "shemagh1"
	flags_inv = HIDEFACE|HIDEEARS|HIDEFACIALHAIR
	visor_flags_inv = HIDEFACE|HIDEEARS|HIDEFACIALHAIR

/obj/item/storage/belt/hol
	name = "leather belt"
	desc = "Classic."
	icon_state = "belt_holster"
	inhand_icon_state = "belt_holster"
	icon = 'white/Wzzzz/be.dmi'
	worn_icon = 'white/Wzzzz/be1.dmi'

/obj/item/storage/belt/hol/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_combined_w_class = 9

/obj/item/storage/belt/hol/sa
	name = "satchel belt"
	icon_state = "belt_satchel"
	desc = "Little satchel."
	inhand_icon_state = "belt_satchel"

/obj/item/storage/belt/hol/sa/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 7

/obj/item/clothing/shoes
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'

/obj/item/clothing/shoes/arab
	name = "arab sshoes"
	desc = "Arabian style."
	icon_state = "arab"
	inhand_icon_state = "arab"

/obj/item/clothing/shoes/workboots/mining
	name = "medieval boots"
	desc = "Arabian style."
	icon_state = "medieval"
	inhand_icon_state = "medieval"
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'

/obj/item/clothing/shoes/jackboots/cavalier_boots
	name = "cavalier boots"
	desc = "Without horses, but with boots."
	icon_state = "cavalier_boots"
	inhand_icon_state = "cavalier_boots"
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'

/obj/item/clothing/shoes/jackboots/sailorboots
	name = "sailor boots"
	desc = "Without sea, but with boots."
	icon_state = "sailorboots"
	inhand_icon_state = "sailorboots"
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'

/obj/item/clothing/shoes/sandal
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	name = "tourist sandals"
	desc = "Minimalistic, but probably useless."
	icon_state = "tourist"
	inhand_icon_state = "tourist"

/obj/item/clothing/shoes/sneakers
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	name = "detective shoes"
	desc = "Special shoes for special proffesion."
	icon_state = "detective"
	inhand_icon_state = "detective"

/obj/item/clothing/shoes/roman
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	name = "roman shoes"
	desc = "New shoes from old times."
	icon_state = "roman"
	inhand_icon_state = "roman"

/obj/item/clothing/shoes/winterboots
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	name = "fur boots"
	desc = "Simple and warm."

/obj/item/clothing/shoes/winterboots/yellow
	icon_state = "fur1"
	inhand_icon_state = "fur1"

/obj/item/clothing/shoes/winterboots/grey
	icon_state = "fur2"
	inhand_icon_state = "fur2"

/obj/item/clothing/shoes/winterboots/black
	icon_state = "fur3"
	inhand_icon_state = "fur3"

/obj/item/clothing/shoes/laceup
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	name = "leather shoes"
	desc = "Someone's skin on your feet."
	icon_state = "leather"
	inhand_icon_state = "leather"

/obj/item/clothing/shoes/jackboots/knig
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	name = "knight boots"
	desc = "Heavy steps, heavy feets."
	icon_state = "knight"
	inhand_icon_state = "knight"
	armor = list("melee" = 50, "bullet" = 40, "laser" = 15,"energy" = 5, "bomb" = 40, "bio" = 50, "rad" = 0, "fire" = 40, "acid" = 40)

/obj/item/clothing/shoes/jackboots/wrapped
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	name = "wrapped boots"
	desc = "Makeshift cheap boots, but what big difference with usual boots?"
	icon_state = "wrappedboots"
	inhand_icon_state = "wrappedboots"
	permeability_coefficient = 0.5
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes

/obj/item/clothing/head/helmet/tac_helmet/grey
	icon_state = "tac_helmet"
	inhand_icon_state = "tac_helmet"
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'

/obj/item/clothing/head/helmet/tac_helmet/grey/syn
	icon_state = "tac_helmetalt"
	inhand_icon_state = "tac_helmetalt"

/obj/item/clothing/suit/armor/tac_hazmat/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'


/obj/item/clothing/suit/space/anomaly/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "bio_anoms"
	inhand_icon_state = "bio_anoms"

/obj/item/clothing/suit/space/anomaly/grey/syn
	icon_state = "bio_anomalt"
	inhand_icon_state = "bio_anomalt"

/obj/item/clothing/head/helmet/bio_anom/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "bio_anomhalt"
	inhand_icon_state = "bio_anomhalt"

/obj/item/clothing/head/helmet/bio_anom/grey/syn
	icon_state = "bio_anomh"
	inhand_icon_state = "bio_anomh"

/obj/structure/closet/crate/wooden
	max_integrity = 125
	obj_integrity = 125
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "wood_crate"

/obj/structure/closet/crate/wooden/alt
	icon_state = "wood_cratea"

/obj/structure/closet/crate/wooden/chest
	max_integrity = 350
	obj_integrity = 350
	icon_state = "wood_chest"

/obj/item/storage/backpack
	max_integrity = 325
	obj_integrity = 325
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'



/obj/structure/bed
	icon = 'white/Wzzzz/clothing/head.dmi'

/obj/item/clothing/head/helmet/greek
	name = "greek helmet"
	desc = null
	icon_state = "greek"
	inhand_icon_state = "greek"
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = null
	armor = list("melee" = 35, "bullet" = 25, "laser" = 15,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 30)

/obj/item/clothing/head/helmet/greek/c
	icon_state = "greek_c"
	inhand_icon_state = "greek_c"

/obj/item/clothing/head/helmet/greek/sl
	icon_state = "greek_sl"
	inhand_icon_state = "greek_sl"

/obj/item/clothing/head/helmet/knight
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "knight_simple"
	inhand_icon_state = "knight_simple"

/obj/item/clothing/head/helmet/goldenhelmet
	name = "golden helmet"
	desc = "Very expensive for old times."
	icon_state = "goldenhelmet"
	inhand_icon_state = "goldenhelmet"
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = null
	armor = list("melee" = 30, "bullet" = 25, "laser" = 15,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 35, "acid" = 30)

/obj/item/clothing/head/helmet/goldenhelmet
	name = "golden helmet"
	desc = "Very expensive for old times."
	icon_state = "goldenhelmet"
	inhand_icon_state = "goldenhelmet"
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = null
	armor = list("melee" = 30, "bullet" = 25, "laser" = 15,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 35, "acid" = 30)
	custom_materials = list(/datum/material/gold=50, /datum/material/iron=20)

/obj/item/clothing/head/helmet/medieval_helmet
	name = "medieval helmet"
	desc = "Iron protects your head."
	flags_inv = HIDEEARS|HIDEHAIR
	visor_flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/medieval_helmet/tier1
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10,"energy" = 8, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 10)
	icon_state = "medieval_helmet3"
	inhand_icon_state = "medieval_helmet3"
	dynamic_hair_suffix = null

/obj/item/clothing/head/helmet/medieval_helmet/tier2
	armor = list("melee" = 35, "bullet" = 25, "laser" = 15,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 15)
	icon_state = "medieval_helmet2"
	inhand_icon_state = "medieval_helmet2"

/obj/item/clothing/head/helmet/medieval_helmet/tier3
	armor = list("melee" = 40, "bullet" = 30, "laser" = 20,"energy" = 10, "bomb" = 35, "bio" = 0, "rad" = 0, "fire" = 40, "acid" = 27)
	icon_state = "medieval_helmet1"
	inhand_icon_state = "medieval_helmet1"
	dynamic_hair_suffix = null

/obj/item/clothing/suit/pirate
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "piratejacket1"
	inhand_icon_state = "piratejacket1"

/obj/item/clothing/suit/pirate/alt
	icon_state = "piratejacket5"
	inhand_icon_state = "piratejacket5"

/obj/item/clothing/suit/pirate/jacket
	icon_state = "piratejacket4"
	inhand_icon_state = "piratejacket4"

/obj/item/clothing/suit/pirate/jacket/alt
	icon_state = "piratejacket3"
	inhand_icon_state = "piratejacket3"

/obj/item/clothing/suit/pirate/officer
	desc = "Between soldier and captain."

/obj/item/clothing/suit/pirate/officer/british
	name = "british officer coat"
	icon_state = "british_officer"
	inhand_icon_state = "british_officer"

/obj/item/clothing/suit/pirate/officer/portuguese
	name = "portuguese officer coat"
	icon_state = "portuguese_officer"
	inhand_icon_state = "portuguese_officer"

/obj/item/clothing/suit/pirate/officer/dutch
	name = "dutch officer coat"
	icon_state = "dutch_officer"
	inhand_icon_state = "dutch_officer"

/obj/item/clothing/suit/pirate/officer/french
	name = "french officer coat"
	icon_state = "french_officer"
	inhand_icon_state = "french_officer"

/obj/item/clothing/suit/pirate/officer/spanish
	name = "british officer coat"
	icon_state = "spanish_officer"
	inhand_icon_state = "spanish_officer"

/obj/item/clothing/suit/pirate/captain
	desc = "Valuable like captain's skills."

/obj/item/clothing/suit/pirate/captain/british
	icon_state = "british_captain"
	inhand_icon_state = "british_captain"

/obj/item/clothing/suit/pirate/captain/portuguese
	icon_state = "portuguese_captain"
	inhand_icon_state = "portuguese_captain"

/obj/item/clothing/suit/pirate/captain/spanish
	icon_state = "spanish_captain"
	inhand_icon_state = "spanish_captain"

/obj/item/clothing/suit/pirate/captain/french
	icon_state = "french_captain"
	inhand_icon_state = "french_captain"

/obj/item/clothing/suit/pirate/captain/dutch
	icon_state = "dutch_captain"
	inhand_icon_state = "dutch_captain"

/obj/item/clothing/suit/pirate/army
	body_parts_covered = NONE|CHEST|ARMS
	name = "british army jacket"
	desc = "War with fashion instead protection."
	inhand_icon_state = "british_army"
	icon_state = "british_army"
	cold_protection = NONE|CHEST|ARMS
	heat_protection = NONE|CHEST|ARMS

/obj/item/clothing/suit/pirate/army/dutch
	name = "dutch army jacket"
	inhand_icon_state = "dutch_army"
	icon_state = "dutch_army"

/obj/item/clothing/suit/pirate/army/portuguese
	name = "portuguese army jacket"
	inhand_icon_state = "portuguese_army"
	icon_state = "portuguese_army"

/obj/item/clothing/suit/pirate/army/french
	name = "french army jacket"
	inhand_icon_state = "french_army"
	icon_state = "french_army"

/obj/item/clothing/suit/pirate/civ_jacket
	name = "jacket"
	desc = "Looks good, costs small."
	inhand_icon_state = "civ_jacket"
	icon_state = "civ_jacket"

/obj/item/clothing/suit/armor/bone
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "bonearmor"
	inhand_icon_state = "bonearmor"

/obj/item/clothing/suit/redcape
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "redcape"
	inhand_icon_state = "redcape"
	name = "red cloak"
	desc = "Red and cloak."

/obj/item/clothing/suit/bluecape
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "bluecape"
	inhand_icon_state = "bluecape"
	name = "blue cloak"
	desc = "Blue and cloak."

/obj/item/clothing/suit/armor
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'

/obj/item/clothing/suit/armor/hauberk
	icon_state = "hauberk"
	inhand_icon_state = "hauberk"
	name = "hauberk"
	desc = "Cover your body by steel."
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 15)
	body_parts_covered = NONE|CHEST|HANDS|LEGS|GROIN
	cold_protection = NONE|CHEST|HANDS|LEGS|GROIN
	heat_protection = NONE|CHEST|HANDS|LEGS|GROIN

/obj/item/clothing/suit/armor/riot/knight
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "knight_simple1"
	inhand_icon_state = "knight_simple1"

/obj/item/clothing/suit/armor/vest
	body_parts_covered = NONE|CHEST
	cold_protection = NONE|CHEST
	heat_protection = NONE|CHEST
	desc = "Chest protection."

/obj/item/clothing/suit/armor/vest/leather
	icon_state = "leather_chestplate"
	inhand_icon_state = "leather_chestplate"
	name = "leather chestplate"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 5,"energy" = 3, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 15)

/obj/item/clothing/suit/armor/vest/leather/alt
	icon_state = "leather_armor2"
	inhand_icon_state = "leather_armor2"
	name = "leather chestplate"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 5,"energy" = 3, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 15)

/obj/item/clothing/suit/armor/vest/bronze
	icon_state = "bronze_chestplate"
	inhand_icon_state = "bronze_chestplate"
	name = "bronze chestplate"
	armor = list("melee" = 25, "bullet" = 17, "laser" = 10,"energy" = 7, "bomb" = 23, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 20)

/obj/item/clothing/suit/armor/vest/iron
	icon_state = "iron_chestplate"
	inhand_icon_state = "iron_chestplate"
	name = "iron chestplate"
	armor = list("melee" = 27, "bullet" = 20, "laser" = 15,"energy" = 8, "bomb" = 27, "bio" = 0, "rad" = 0, "fire" = 23, "acid" = 22)

/obj/item/clothing/suit/armor/vest/chain
	icon_state = "chainmail"
	inhand_icon_state = "chainmail"
	name = "chainmail"
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20,"energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 15)


/obj/item/clothing/suit/armor/vest/iron/a
	icon_state = "iron_chestplater"
	inhand_icon_state = "iron_chestplater"

/obj/item/clothing/suit/armor/vest/iron/b
	icon_state = "iron_chestplateb"
	inhand_icon_state = "iron_chestplateb"

/obj/item/clothing/suit/armor/vest/iron/c
	icon_state = "iron_chestplatec"
	inhand_icon_state = "iron_chestplatec"

/obj/item/clothing/head/crown
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'

/obj/item/clothing/suit/hooded/fur
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	min_cold_protection_temperature = 2
	cold_protection = 1
	name = "fur suit"
	desc = "Warm and furry."
	icon_state = "fur_jacket1"
	inhand_icon_state = "fur_jacket1"
	hoodtype = /obj/item/clothing/head/hooded/fur
	armor = list("melee" = 10, "bullet" = 5, "laser" = 5,"energy" = 3, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/head/hooded/fur
	name = "fur hood"
	desc = "Just hood, isn't it?"
	icon_state = null
	inhand_icon_state = null
	body_parts_covered = HEAD
	worn_icon = null
	icon = null
	flags_inv = HIDEHAIR|HIDEEARS
	min_cold_protection_temperature = 2
	cold_protection = 1
	armor = list("melee" = 10, "bullet" = 5, "laser" = 5,"energy" = 3, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/hooded/fur/grey
	icon_state = "fur_jacket2"
	inhand_icon_state = "fur_jacket2"

/obj/item/clothing/suit/hooded/fur/black
	icon_state = "fur_jacket3"
	inhand_icon_state = "fur_jacket3"

/obj/item/clothing/suit/fur
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "fur_jacket1x"
	inhand_icon_state = "fur_jacket1x"
	min_cold_protection_temperature = 2
	cold_protection = 1
	name = "fur suit"
	desc = "Warm and furry."
	armor = list("melee" = 10, "bullet" = 5, "laser" = 5,"energy" = 3, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 10, "acid" = 10)

/obj/item/clothing/suit/fur/grey
	icon_state = "fur_jacket2x"
	inhand_icon_state = "fur_jacket2x"

/obj/item/clothing/suit/fur/black
	icon_state = "fur_jacket3x"
	inhand_icon_state = "fur_jacket3x"

/obj/item/clothing/under/indian
	name = "indian outfit"
	desc = "Leather, light and open"
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "indian1"
	inhand_icon_state = "indian1"
	can_adjust = FALSE
	alt_covers_chest = FALSE

/obj/item/clothing/under/indian/alt1
	icon_state = "indian2"
	inhand_icon_state = "indian2"

/obj/item/clothing/under/indian/alt2
	icon_state = "indian3"
	inhand_icon_state = "indian3"

/obj/item/clothing/under/indian/pelt
	name = "giant leopard pelt"
	desc = "Big and expensive."
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon_state = "giant_leopard_pelt"
	inhand_icon_state = "giant_leopard_pelt"

/obj/item/clothing/under/indian/shaman
	icon_state = "indianshaman"
	inhand_icon_state = "indianshaman"
	name = "indian shaman outfit"

/obj/item/clothing/under/indian/chef
	icon_state = "indianchef"
	inhand_icon_state = "indianchef"
	name = "indian chef outfit"

/obj/item/clothing/under/indian/spartan
	icon_state = "spartan"
	inhand_icon_state = "spartan"
	name = "spartan clothing"
	desc = "Nothing useless."

/obj/item/clothing/under/sailor
	name = "sailor uniform"
	desc = "Old clothing for new waves of sailors."
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	can_adjust = TRUE

/obj/item/clothing/under/sailor/british
	name = "british sailor uniform"
	icon_state = "british_sailor"
	inhand_icon_state = "british_sailor"

/obj/item/clothing/under/sailor/portuguese
	name = "portuguese sailor uniform"
	icon_state = "portuguese_sailor"
	inhand_icon_state = "portuguese_sailor"

/obj/item/clothing/under/sailor/portuguese/alt
	can_adjust = FALSE
	icon_state = "portuguese_sailor4"
	inhand_icon_state = "portuguese_sailor4"

/obj/item/clothing/under/sailor/port
	name = "port sailor uniform"
	icon_state = "sailor_port"
	inhand_icon_state = "sailor_port"

/obj/item/clothing/under/sailor/spanish
	name = "spanish sailor uniform"
	icon_state = "spanish_sailor"
	inhand_icon_state = "spanish_sailor"

/obj/item/clothing/under/sailor/french
	name = "french sailor uniform"
	icon_state = "french_sailor"
	inhand_icon_state = "french_sailor"

/obj/item/clothing/under/sailor/dutch
	name = "dutch sailor uniform"
	icon_state = "dutch_sailor"
	inhand_icon_state = "dutch_sailor"

/obj/item/clothing/under/costume/pirate
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'

/obj/item/clothing/under/costume/pirate/a
	icon_state = "pirate1"
	inhand_icon_state = "pirate1"

/obj/item/clothing/under/costume/pirate/b
	icon_state = "pirate2"
	inhand_icon_state = "pirate2"

/obj/item/clothing/under/costume/pirate/c
	icon_state = "pirate3"
	inhand_icon_state = "pirate3"

/obj/item/clothing/under/costume/pirate/d
	icon_state = "pirate4"
	inhand_icon_state = "pirate4"

/obj/item/clothing/under/costume/pirate/e
	icon_state = "pirate5"
	inhand_icon_state = "pirate5"

/obj/item/clothing/under/costume/roman
	armor = list("melee" = 20, "bullet" = 10, "laser" = 8,"energy" = 5, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 15)
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'

/obj/item/clothing/under/costume/roman/centurion
	icon_state = "roman_centurion"
	inhand_icon_state = "roman_centurion"
	name = "centurion armor"
	desc = "Best armor for best followers."
	armor = list("melee" = 35, "bullet" = 25, "laser" = 15,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 23)

/obj/item/clothing/under/costume/roman/athens
	name = "athens armor"
	desc = "Athens..."
	armor = list("melee" = 15, "bullet" = 10, "laser" = 7,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 15)
	icon_state = "athens"
	inhand_icon_state = "athens"

/obj/item/clothing/under/costume/roman/corinthia
	name = "corinthia armor"
	desc = "Corinthia..."
	icon_state = "corinthia"
	inhand_icon_state = "corinthia"

/obj/item/clothing/under/costume/roman/thebes
	name = "thebes armor"
	desc = "Thebes..."
	icon_state = "thebes"
	inhand_icon_state = "thebes"
	armor = list("melee" = 15, "bullet" = 10, "laser" = 7,"energy" = 5, "bomb" = 15, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 15)

/obj/item/clothing/under/costume/roman/greek
	name = "greek commander armor"
	desc = "Greek..."
	icon_state = "greek_commander"
	inhand_icon_state = "greek_commander"
	armor = list("melee" = 25, "bullet" = 15, "laser" = 13,"energy" = 10, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 25, "acid" = 20)

/obj/item/clothing/under/civilian
	name = "civilian uniform"
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	desc = "Classic, pleasantly."
	icon_state = "civuni"
	can_adjust = TRUE
	inhand_icon_state = "civuni"

/obj/item/clothing/under/civilian/officer
	icon_state = "officer"
	can_adjust = FALSE
	inhand_icon_state = "officer"
	name = "officer uniform"

/obj/item/clothing/under/civilian/officer/french
	icon_state = "french_officer"
	inhand_icon_state = "french_officer"
	name = "french officer uniform"

/obj/item/clothing/under/tunic
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'

/obj/item/clothing/under/tunic/toga
	icon_state = "toga"
	inhand_icon_state = "toga"
	name = "toga"
	desc = null
	can_adjust = TRUE

/obj/item/clothing/under/tunic/crusader
	icon_state = "crusader1"
	inhand_icon_state = "crusader1"
	name = "crusader tunic"
	desc = "You need not only armor."

/obj/item/clothing/under/tunic/crusader/alt
	icon_state = "crusader2"
	inhand_icon_state = "crusader2"
*/
