//masks

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

/obj/item/clothing/shoes/combat/blackger
	name = "black Boots"
	desc = "Looks stylish"
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	icon_state = "black_boots"
	inhand_icon_state = "black_boots"

/obj/item/clothing/shoes/slippers
	name = "slippers"
	desc = "I think you understand all yourself"
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	icon_state = "slippers"
	inhand_icon_state = "slippers"

/obj/item/clothing/shoes/digiboots
	name = "dig boots"
	desc = "I hope you understand all yourself"
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	icon_state = "digiboots"
	inhand_icon_state = "digiboots"

/obj/item/clothing/shoes/flippers
	name = "flippers"
	desc = "I think you understand all yourself"
	worn_icon = 'white/Wzzzz/clothing/mob/feet.dmi'
	icon = 'white/Wzzzz/clothing/shoes.dmi'
	icon_state = "flippers"
	inhand_icon_state = "flippers"

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

/obj/item/clothing/gloves/combat/black_gloves
	name = "long black gloves"
	desc = "black, but not too long."
	worn_icon = 'white/Wzzzz/clothing/mob/hands.dmi'
	icon = 'white/Wzzzz/clothing/gloves.dmi'
	icon_state = "longblack"
	inhand_icon_state = "longblack"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = 10)

/obj/item/clothing/gloves/combat/evening_gloves/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "evening_glovesg"
	inhand_icon_state = "evening_glovesg"

/obj/item/clothing/gloves/combat/evening_gloves/black
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "evening_glovesb"
	inhand_icon_state = "evening_glovesb"

/obj/item/clothing/gloves/combat/evening_gloves/dark
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "evening_glovesd"
	inhand_icon_state = "evening_glovesd"
