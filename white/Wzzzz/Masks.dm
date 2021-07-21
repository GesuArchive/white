//obj/item/clothing/mask



/obj/item/clothing/mask/gas/stealth_rig
	name = "stealth mask"
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

/obj/item/clothing/mask/gas/alt
	icon_state = "gasmask_alt"
	inhand_icon_state = "gasmask_alt"
	icon = 'white/Wzzzz/clothing/masks.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)

/obj/item/clothing/mask/shemagh
	name = "shemagh"
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
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

/obj/item/clothing/mask/gas/full
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "fullgas"
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	icon = 'white/Wzzzz/clothing/masks.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	visor_flags_inv = HIDEEARS|HIDEFACE|HIDEFACIALHAIR
	dynamic_fhair_suffix = ""
	clothing_flags = STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	inhand_icon_state = "fullgas"
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 0, bomb = 0, bio = 75, rad = 0)

/obj/item/clothing/mask/breath/half
	name = "face mask"
	desc = "A compact, durable gas mask that can be connected to an air supply."
	icon_state = "halfgas"
	inhand_icon_state = "halfgas"
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	icon = 'white/Wzzzz/clothing/masks.dmi'
	dynamic_fhair_suffix = ""
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 55, rad = 0)

/obj/item/clothing/mask/balaclava/swatclava
	name = "балаклава"
	desc = "Легко скроет вашу улыбку на лице."
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon = 'white/Wzzzz/pirha.dmi'
	icon_state = "swatclava"
	inhand_icon_state = "swatclava"

/obj/item/clothing/mask/balaclava/swatclava/grey
	icon_state = "swatclavag"
	inhand_icon_state = "swatclavag"

/obj/item/clothing/mask/balaclava/swatclava/black
	icon_state = "swatclavab"
	inhand_icon_state = "swatclavab"

/obj/item/clothing/mask/balaclava/balaclavager
	name = "balaclava"
	desc = "German balaclava."
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon = 'white/Wzzzz/pirha.dmi'
	icon_state = "balaclava"


/obj/item/clothing/mask/balaclava/balaclavager
	name = "balaclava"
	desc = "German balaclava."
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon = 'white/Wzzzz/pirha.dmi'
	icon_state = "balaclava"

/obj/item/clothing/mask/balaclava/balaclavager/grey
	icon_state = "balaclavag"

/obj/item/clothing/mask/balaclava/balaclavager/black
	icon_state = "balaclavagb"

/obj/item/clothing/mask/gas/germanfull
	name = "old style gas mask"
	desc = "С›РјРј. вЂ™Р°Р№Р»СЊ В¬Р°Р№С‚."
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEEYES
	visor_flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEEYES
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	icon = 'white/Wzzzz/clothing/masks.dmi'
	icon_state = "fullgas"

/obj/item/clothing/mask/gas/german
	name = "german gas mask"
	icon_state = "german_gasmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	icon = 'white/Wzzzz/clothing/masks.dmi'
	dynamic_fhair_suffix = ""

/obj/item/clothing/mask/gas/germanalt
	name = "gas mask"
	icon_state = "gas_alt"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR
	dynamic_fhair_suffix = ""
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	icon = 'white/Wzzzz/clothing/masks.dmi'

/obj/item/clothing/mask/gas/respirator
	name = "respirator mask"
	icon_state = "respirator"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	icon = 'white/Wzzzz/clothing/masks.dmi'
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR
	dynamic_fhair_suffix = ""

/obj/item/clothing/mask/balaclavager
	name = "balaclava"
	desc = "German balaclava."
	dynamic_fhair_suffix = ""
	dynamic_hair_suffix = ""
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	worn_icon = 'white/Wzzzz/clothing/mob/mask.dmi'
	icon = 'white/Wzzzz/clothing/masks.dmi'
	icon_state = "balaclava"
	flags_inv = HIDEHAIR|HIDEEARS
	visor_flags_inv = HIDEHAIR|HIDEEARS