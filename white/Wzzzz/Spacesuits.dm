//obj/item/clothing/suit/space



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
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
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
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
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
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 50)

/obj/item/clothing/suit/space/syndicate/german
	name = "orange space suit"
	icon_state = "syndicate_orange_ger"
	inhand_icon_state = "syndicate_orange_ger"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	icon = 'white/Wzzzz/clothing/suits.dmi'

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
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
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
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 0, "fire" = 60, "acid" = 60)

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
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 0, "fire" = 60, "acid" = 60)
	
/obj/item/clothing/suit/space/syndicate/black/engie
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF

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
	icon_state = "civrig"
	inhand_icon_state = "civrig"
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20, "energy" = 10, "bomb" = 40, "bio" = 100, "rad" = 30, "fire" = 70, "acid" = 50)

/obj/item/clothing/suit/space/anomaly/grey
	icon = 'white/Wzzzz/pirha.dmi'
	worn_icon = 'white/Wzzzz/pirha1.dmi'
	icon_state = "bio_anoms"
	inhand_icon_state = "bio_anoms"

/obj/item/clothing/suit/space/anomaly/grey/syn
	icon_state = "bio_anomalt"
	inhand_icon_state = "bio_anomalt"