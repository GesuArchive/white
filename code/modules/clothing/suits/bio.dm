//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "капюшон биологической защиты"
	icon_state = "bio"
	desc = "Капюшон, защищающий голову и лицо от биологических загрязнений."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	clothing_flags = THICKMATERIAL | BLOCK_GAS_SMOKE_EFFECT | SNUG_FIT | HEADINTERNALS
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 80, FIRE = 30, ACID = 100)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT
	resistance_flags = ACID_PROOF
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF

/obj/item/clothing/suit/bio_suit
	name = "костюм биологической защиты"
	desc = "Костюм, который защищает от биологического загрязнения."
	icon_state = "bio"
	worn_icon = 'icons/mob/clothing/suits/bio.dmi'
	inhand_icon_state = "bio_suit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.01
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 0.25
	allowed = list(/obj/item/tank/internals, /obj/item/reagent_containers/dropper, /obj/item/flashlight/pen, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/glass/beaker, /obj/item/gun/syringe)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 100, RAD = 80, FIRE = 30, ACID = 100)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	strip_delay = 70
	equip_delay_other = 70
	resistance_flags = ACID_PROOF

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio"

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio"


//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"


//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 100, RAD = 80, FIRE = 30, ACID = 100)
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security
	armor = list(MELEE = 25, BULLET = 15, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 100, RAD = 80, FIRE = 30, ACID = 100)
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/storage/bag/trash, /obj/item/reagent_containers/spray)

//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"

//CMO's biosuit, blue stripe
/obj/item/clothing/head/bio_hood/cmo
	icon_state = "bio_cmo"

/obj/item/clothing/suit/bio_suit/cmo
	icon_state = "bio_cmo"

/obj/item/clothing/suit/bio_suit/cmo/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/melee/classic_baton/telescopic)

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "костюм чумного доктора"
	desc = "Тогда он защищал врачей от Черной смерти. Вы держите пари, что это поможет вам против вирусов."
	icon_state = "plaguedoctor"
	inhand_icon_state = "bio_suit"
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/suit/bio_suit/plaguedoctorsuit/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/storage/book/bible, /obj/item/nullrod, /obj/item/cane)
