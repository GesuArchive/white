//obj/item/clothing/gloves



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

/obj/item/clothing/gloves/combat/evening_gloves/rubber_gloves
	icon_state = "rubber_gloves"
	inhand_icon_state = "rubber_gloves"
	worn_icon = 'white/Wzzzz/clothing/mob/hands.dmi'
	icon = 'white/Wzzzz/clothing/gloves.dmi'
	armor = list("melee" = 10, "bullet" = 5, "laser" = 0,"energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)

/obj/item/clothing/gloves/combat/co
	icon_state = "co_gloves"
	inhand_icon_state = "co_gloves"
	worn_icon = 'white/Wzzzz/clothing/mob/hands.dmi'
	icon = 'white/Wzzzz/clothing/gloves.dmi'

/obj/item/clothing/gloves/combat/arbiter
	name = "arbiter gloves"
	worn_icon = 'white/Wzzzz/clothing/mob/hands.dmi'
	icon = 'white/Wzzzz/clothing/gloves.dmi'
	icon_state = "arbiter"

/obj/item/clothing/gloves/combat/arbiter/undertaker
	name = "undertaker gloves"
	icon_state = "undertaker"