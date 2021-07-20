/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/toggle_hardsuit_mode(mob/user) //Helmet Toggles Suit Mode
	if(linkedsuit)
		if(on)
			linkedsuit.name = initial(linkedsuit.name)
			linkedsuit.desc = initial(linkedsuit.desc)
			linkedsuit.slowdown = 1
			linkedsuit.clothing_flags |= STOPSPRESSUREDAMAGE
			linkedsuit.cold_protection |= CHEST | GROIN | LEGS | FEET | ARMS | HANDS
		else
			linkedsuit.name += " (боевой)"
			linkedsuit.desc = linkedsuit.alt_desc
			linkedsuit.slowdown = 0
			linkedsuit.clothing_flags &= ~STOPSPRESSUREDAMAGE
			linkedsuit.cold_protection &= ~(CHEST | GROIN | LEGS | FEET | ARMS | HANDS)

		linkedsuit.update_icon()
		user.update_inv_wear_suit()
		user.update_inv_w_uniform()
		user.update_equipment_speed_mods()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/asset_protection
	name = "asset protection hardsuit helmet"
	desc = "Helmet for special asset-protection hardsuit."
	alt_desc = "Helmet for special asset-protection hardsuit."
	icon_state = "asset_protection"
	inhand_icon_state = "asset_protection"
	hardsuit_type = "asset_protection"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 35, "bio" = 100, "rad" = 0, "fire" = 55, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.8
	light_on = FALSE
	slowdown = 0
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/asset_protection
	name = "asset protection hardsuit"
	desc = "Probably for protection."
	alt_desc = "Probably for protection."
	icon_state = "hardsuit0-asset_protection"
	inhand_icon_state = "hardsuit0-asset_protection"
	hardsuit_type = "asset_protection"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 35, "bio" = 100, "rad" = 0, "fire" = 55, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/asset_protection
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/eng
	name = "engineer hardsuit helmet"
	desc = "For engineers."
	alt_desc = "For engineers."
	icon_state = "rig0-engineeringalt"
	inhand_icon_state = "rig0-engineeringalt"
	hardsuit_type = "engineeringalt"
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 75, "fire" = 50, "acid" = 75)

/obj/item/clothing/suit/space/hardsuit/syndi/elite/eng
	icon_state = "hardsuit0-engineeringalt_rig"
	name = "engineer hardsuit"
	desc = "For engineers."
	alt_desc = "For engineers."
	inhand_icon_state = "hardsuit0-engineeringalt_rig"
	jetpack = null
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	hardsuit_type = "engineeringalt"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 25, "laser" = 30, "energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 75, "fire" = 50, "acid" = 75)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/t_scanner, /obj/item/construction/rcd, /obj/item/pipe_dispenser)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/eng

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/breacher_cheap
	name = "breacher cheap hardsuit helmet"
	desc = "Not enough good like usual breacher suit, but too good."
	alt_desc = "Not enough good like usual breacher suit, but too good."
	icon_state = "breacher_rig_cheap"
	inhand_icon_state = "breacher_rig_cheap"
	hardsuit_type = "breacher_rig_cheap"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF| 52
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	var/obj/item/clothing/head/helmet/space/hardsuit/breacher_cheap = null
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.8
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/breacher_cheap
	name = "breacher cheap hardsuit"
	desc = "Not enough good like usual breacher suit, but too good."
	alt_desc = "Not enough good like usual breacher suit, but too good."
	icon_state = "hardsuit0-breacher_rig_cheap"
	inhand_icon_state = "hardsuit0-breacher_rig_cheap"
	hardsuit_type = "breacher_rig_cheap"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30, "energy" = 20, "bomb" = 55, "bio" = 50, "rad" = 40, "fire" = 50, "acid" = 50)
	allowed = list(/obj/item/gun, /obj/item/ammo_box,/obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/breacher_cheap

/obj/item/clothing/suit/space/hardsuit/syndi/elite/breacher
	name = "breacher hardsuit"
	desc = "Good style, good protection, but heavy."
	alt_desc = "Good style, good protection, but heavy."
	icon_state = "hardsuit0-breacher_rig"
	inhand_icon_state = "hardsuit0-breacher_rig"
	hardsuit_type = "breacher_rig"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 60, "bullet" = 75, "laser" = 50, "energy" = 40, "bomb" = 70, "bio" = 80, "rad" = 50, "fire" = 100, "acid" = 100)
	allowed = list(/obj/item/gun, /obj/item/ammo_box,/obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/breacher
	resistance_flags = NONE|ACID_PROOF|FIRE_PROOF|FREEZE_PROOF|LAVA_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/breacher
	name = "breacher hardsuit helmet"
	desc = "Good style, good protection, but heavy."
	alt_desc = "Good style, good protection, but heavy."
	icon_state = "breacher_rig"
	inhand_icon_state = "breacher_rig"
	hardsuit_type = "breacher_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40, "energy" = 35, "bomb" = 65, "bio" = 40, "rad" = 0, "fire" = 70, "acid" = 70)
	flash_protect = 5
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF | 52
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	clothing_flags = STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT
	flags_inv = HIDEEARS|HIDEFACE|HIDEMASK
	var/obj/item/clothing/head/helmet/space/hardsuit/breacher = null
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE
	resistance_flags = NONE|ACID_PROOF|FIRE_PROOF|FREEZE_PROOF|LAVA_PROOF
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE





/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/military_rig
	name = "military hardsuit helmet"
	desc = "A dual-mode advanced helmet designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced helmet designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit0-military_rig"
	inhand_icon_state = "hardsuit0-military_rig"
	hardsuit_type = "military_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	armor = list("melee" = 65, "bullet" = 65, "laser" = 55, "energy" = 30, "bomb" = 60, "bio" = 100, "rad" = 70, "fire" = 100, "acid" = 100)
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/military_rig
	name = "military hardsuit"
	desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit0-military_rig"
	inhand_icon_state = "hardsuit0-military_rig"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	hardsuit_type = "military_rig"
	armor = list("melee" = 65, "bullet" = 65, "laser" = 55, "energy" = 30, "bomb" = 60, "bio" = 100, "rad" = 70, "fire" = 100, "acid" = 100)
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/military_rig





/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/hazard_rig
	name = "hazard hardsuit helmet"
	desc = "Heavy protection for hazard situations."
	alt_desc = "Heavy protection for hazard situations."
	icon_state = "hardsuit0-hazard_rig"
	inhand_icon_state = "hardsuit0-hazard_rig"
	hardsuit_type = "hazard_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 40, "bullet" = 40, "laser" = 60,"energy" = 60, "bomb" = 50, "bio" = 100, "rad" = 60, "fire" = 100, "acid" = 100)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.8
	light_on = FALSE
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/hazard_rig
	name = "hazard hardsuit"
	desc = "Heavy protection for hazard situations."
	alt_desc = "Heavy protection for hazard situations."
	icon_state = "hardsuit0-hazard_rig"
	inhand_icon_state = "hardsuit0-hazard_rig"
	hardsuit_type = "hazard_rig"
	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 40, "bullet" = 40, "laser" = 60,"energy" = 60, "bomb" = 50, "bio" = 100, "rad" = 60, "fire" = 100, "acid" = 100)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/hazard_rig

/obj/item/clothing/head/helmet/space/hardsuit/merc_rig
	name = "advanced blood-red hardsuit helmet"
	desc = "Advanced Syndicate red hardsuit helmet."
	alt_desc = "Advanced Syndicate red hardsuit helmet."
	icon_state = "hardsuit0-merc_rig"
	inhand_icon_state = "hardsuit0-merc_rig"
	hardsuit_type = "merc_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 60, "laser" = 45, "energy" = 40, "bomb" = 60, "bio" = 100, "rad" = 50, "fire" = 80, "acid" = 90)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/merc_rig
	name = "advanced blood-red hardsuit"
	desc = "Advanced Syndicate red hardsuit."
	alt_desc = "Advanced Syndicate red hardsuit."
	icon_state = "hardsuit0-merc_rig"
	inhand_icon_state = "hardsuit0-merc_rig"
	hardsuit_type = "hazard_rig"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 60, "bullet" = 60, "laser" = 45, "energy" = 40, "bomb" = 60, "bio" = 100, "rad" = 50, "fire" = 80, "acid" = 90)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/merc_rig

/obj/item/clothing/head/helmet/space/hardsuit/rig_miningalt
	name = "advanced miner hardsuit helmet"
	desc = "For miners, isn't it?"
	alt_desc = "For miners, isn't it?"
	icon_state = "rig_miningalt"
	inhand_icon_state = "rig_miningalt"
	hardsuit_type = "rig_miningalt"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	flash_protect = 1
	actions_types = null
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30, "energy" = 30, "bomb" = 60, "bio" = 100, "rad" = 50, "fire" = 60, "acid" = 75)
	light_system = MOVABLE_LIGHT
	light_range = 5
	light_power = 1
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/rig_miningalt
	name = "advanced miner hardsuit"
	desc = "For miners, isn't it?"
	alt_desc = "For miners, isn't it?"
	icon_state = "rig_miningalt"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	inhand_icon_state = "rig_miningalt"
	slowdown = 0.7
	hardsuit_type = "rig_miningalt"
	w_class = WEIGHT_CLASS_NORMAL
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30, "energy" = 30, "bomb" = 60, "bio" = 100, "rad" = 50, "fire" = 60, "acid" = 75)
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_miningalt











/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/merc_rig_heavy
	name = "heavy blood-red hardsuit helmet"
	desc = "Very heavy, but nice protection."
	alt_desc = "Very heavy, but nice protection."
	icon_state = "hardsuit0-merc_rig_heavy"
	inhand_icon_state = "hardsuit0-merc_rig_heavy"
	hardsuit_type = "merc_rig_heavy"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 90, "bullet" = 85, "laser" = 80,"energy" = 85, "bomb" = 90, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	slowdown = 0.5
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE

	resistance_flags = NONE|FREEZE_PROOF|FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/merc_rig_heavy
	name = "heavy blood-red hardsuit"
	desc = "Very heavy, but nice protection."
	alt_desc = "Very heavy, but nice protection."
	icon_state = "hardsuit0-merc_rig_heavy"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	inhand_icon_state = "hardsuit0-merc_rig_heavy"
	hardsuit_type = "merc_rig_heavy"
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 2
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 90, "bullet" = 85, "laser" = 80,"energy" = 85, "bomb" = 90, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/merc_rig_heavy






/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/security_rig
	name = "security hardsuit helmet"
	desc = "New model of security hardsuit for station."
	alt_desc = "New model of security hardsuit for station."
	icon_state = "hardsuit0-security_rig"
	inhand_icon_state = "hardsuit0-security_rig"
	hardsuit_type = "security_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 50, "bio" = 50, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/security_rig
	name = "security hardsuit"
	desc = "New model of security hardsuit for station."
	alt_desc = "New model of security hardsuit for station."
	icon_state = "hardsuit0-security_rig"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	inhand_icon_state = "hardsuit0-security_rig"
	hardsuit_type = "security_rig"
	w_class = WEIGHT_CLASS_NORMAL
	armor = list("melee" = 50, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 50, "bio" = 50, "rad" = 0, "fire" = 60, "acid" = 50)
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/security_rig






/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/medical_rig
	name = "medical hardsuit helmet"
	desc = "New model of medical hardsuit for station."
	alt_desc = "New model of medical hardsuit for station."
	icon_state = "hardsuit0-medical_rig"
	inhand_icon_state = "hardsuit0-medical_rig"
	hardsuit_type = "medical_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 70, "fire" = 60, "acid" = 70)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/medical_rig
	name = "medical hardsuit"
	desc = "New model of medical hardsuit for station."
	alt_desc = "New model of medical hardsuit for station."
	icon_state = "hardsuit0-medical_rig"
	slowdown = 0.5
	inhand_icon_state = "hardsuit0-medical_rig"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	hardsuit_type = "medical_rig"
	w_class = WEIGHT_CLASS_NORMAL
	flags_inv = NONE
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 100, "rad" = 70, "fire" = 60, "acid" = 70)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/medical_rig

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_engineer_rig
	name = "ert engineer hardsuit helmet"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_engineer_rig"
	inhand_icon_state = "hardsuit0-ert_engineer_rig"
	hardsuit_type = "ert_engineer_rig"
	slowdown = 0
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/ert_engineer_rig
	name = "ert engineer hardsuit"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_engineer_rig"
	inhand_icon_state = "hardsuit0-ert_engineer_rig"
	hardsuit_type = "ert_engineer_rig"
	slowdown = 0
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 45, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_engineer_rig



/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_commander_rig
	name = "ert commander hardsuit helmet"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_commander_rig"
	slowdown = 0
	inhand_icon_state = "hardsuit0-ert_commander_rig"
	hardsuit_type = "ert_commander_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/ert_commander_rig
	name = "ert commander hardsuit"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_commander_rig"
	inhand_icon_state = "hardsuit0-ert_commander_rig"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	slowdown = 0
	hardsuit_type = "ert_commander_rig"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 45, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_commander_rig


/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_security_rig
	name = "ert security hardsuit helmet"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_security_rig"
	inhand_icon_state = "hardsuit0-ert_security_rig"
	slowdown = 0
	hardsuit_type = "ert_security_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/ert_security_rig
	name = "ert security hardsuit"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_security_rig"
	inhand_icon_state = "hardsuit0-ert_security_rig"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	slowdown = 0
	hardsuit_type = "ert_security_rig"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 45, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_security_rig




/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_medical_rig
	name = "ert medical hardsuit helmet"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_medical_rig"
	inhand_icon_state = "hardsuit0-ert_medical_rig"
	hardsuit_type = "ert_medical_rig"
	slowdown = 0
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	slowdown = 0
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/ert_medical_rig
	name = "ert medical hardsuit"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	icon_state = "hardsuit0-ert_medical_rig"
	inhand_icon_state = "hardsuit0-ert_medical_rig"
	slowdown = 0
	hardsuit_type = "ert_medical_rig"
	slowdown = 0
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 45, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/ert_medical_rig



/obj/item/clothing/head/helmet/space/hardsuit/ert_janitor_rig
	name = "ert janitor hardsuit helmet"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_janitor_rig"
	slowdown = 0
	inhand_icon_state = "hardsuit0-ert_janitor_rig"
	hardsuit_type = "ert_janitor_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/ert_janitor_rig
	name = "ert janitor hardsuit"
	desc = "Old style of ert hardsuit."
	alt_desc = "Old style of ert hardsuit."
	icon_state = "hardsuit0-ert_janitor_rig"
	inhand_icon_state = "hardsuit0-ert_janitor_rig"
	slowdown = 0
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	hardsuit_type = "ert_janitor_rig"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 45, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert_janitor_rig



/obj/item/clothing/head/helmet/space/hardsuit/skrell_helmet_white
	name = "screll hardsuit helmet"
	desc = "For skrells, for space"
	alt_desc = "For skrells, for space"
	icon_state = "skrell_helmet_white"
	inhand_icon_state = "skrell_suit_white"
	hardsuit_type = "skrell_helmet_white"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/skrell_suit_white
	name = "screll hardsuit"
	desc = "For skrells, for space"
	alt_desc = "For skrells, for space"
	icon_state = "skrell_suit_white"
	inhand_icon_state = "skrell_suit_white"
	slowdown = 0.5
	hardsuit_type = "skrell_suit_white"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 50, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 45, "bio" = 50, "rad" = 50, "fire" = 50, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/skrell_helmet_white









/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/eva_rig
	name = "eva hardsuit helmet"
	desc = "New style of EVA hardsuit, more warm and comfortable."
	alt_desc = "New style of EVA hardsuit, more warm and comfortable."
	icon_state = "hardsuit0-eva_rig"
	inhand_icon_state = "hardsuit0-eva_rig"
	hardsuit_type = "eva_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 60, "rad" = 0, "fire" = 40, "acid" = 50)
	flash_protect = 1
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	slowdown = 0.6
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/eva_rig
	name = "eva hardsuit"
	desc = "New style of EVA hardsuit, more warm and comfortable."
	resistance_flags = NONE|FREEZE_PROOF
	alt_desc = "New style of EVA hardsuit, more warm and comfortable."
	icon_state = "hardsuit0-eva_rig"
	inhand_icon_state = "hardsuit0-eva_rig"
	hardsuit_type = "eva_rig"
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 0.6
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30,"energy" = 30, "bomb" = 40, "bio" = 60, "rad" = 0, "fire" = 40, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/eva_rig
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS






/obj/item/clothing/head/helmet/space/hardsuit/rig_atmosalt
	name = "atmospherical hardsuit helmet"
	desc = "New style of atmospherical hardsuit."
	alt_desc = "New style of atmospherical hardsuit."
	icon_state = "rig_atmosalt"
	inhand_icon_state = "rig_atmosalt"
	hardsuit_type = "rig_atmosalt"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 25, "fire" = 100, "acid" = 75)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/rig_atmosalt
	name = "atmospherical hardsuit"
	desc = "New style of atmospherical hardsuit."
	alt_desc = "New style of atmospherical hardsuit."
	icon_state = "rig_atmosalt"
	inhand_icon_state = "rig_atmosalt"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	hardsuit_type = "rig_atmosalt"
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 25, "fire" = 100, "acid" = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_atmosalt





/obj/item/clothing/head/helmet/space/hardsuit/rig_secalt
	name = "security hardsuit helmet"
	desc = "New style of security hardsuit."
	alt_desc = "New style of security hardsuit."
	icon_state = "rig_secalt"
	inhand_icon_state = "rig_secalt"
	hardsuit_type = "rig_secalt"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 45, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/rig_secalt
	name = "security hardsuit"
	desc = "New style of security hardsuit."
	alt_desc = "New style of security hardsuit."
	icon_state = "rig_secalt"
	inhand_icon_state = "rig_secalt"
	slowdown = 0.7
	hardsuit_type = "rig_secalt"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 45, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_secalt





/obj/item/clothing/head/helmet/space/hardsuit/rig_sec
	name = "security hardsuit helmet"
	desc = "New style of security hardsuit."
	alt_desc = "New style of security hardsuit."
	icon_state = "rig_sec"
	inhand_icon_state = "rig_sec"
	hardsuit_type = "rig_sec"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 70, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 60, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/rig_sec
	name = "security hardsuit"
	desc = "New style of security hardsuit."
	alt_desc = "New style of security hardsuit."
	icon_state = "rig_sec"
	inhand_icon_state = "rig_sec"
	hardsuit_type = "rig_sec"
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 70, "bullet" = 50, "laser" = 30, "energy" = 20, "bomb" = 60, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_sec
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF





/obj/item/clothing/head/helmet/space/hardsuit/rig_medicalalt
	name = "medical hardsuit helmet"
	desc = "New style of medical hardsuit."
	alt_desc = "New style of medical hardsuit."
	icon_state = "rig_medicalalt"
	inhand_icon_state = "rig_medicalalt"
	slowdown = 0.5
	hardsuit_type = "rig_medicalalt"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 75)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF


/obj/item/clothing/suit/space/hardsuit/rig_medicalalt
	name = "medical hardsuit"
	desc = "New style of medical hardsuit."
	alt_desc = "New style of medical hardsuit."
	icon_state = "rig_medicalalt"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	inhand_icon_state = "rig_medicalalt"
	slowdown = 0.5
	hardsuit_type = "rig_medicalalt"
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 20, "laser" = 10, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_medicalalt





/obj/item/clothing/head/helmet/space/hardsuit/rig_salvage
	name = "salvage hardsuit helmet"
	desc = "Salvaged hardsuit."
	alt_desc = "Salvaged hardsuit."
	icon_state = "rig_salvage"
	inhand_icon_state = "rig_salvage"
	hardsuit_type = "rig_salvage"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20,"energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 20, "fire" = 70, "acid" = 30)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/rig_salvage
	name = "salvaged hardsuit"
	desc = "Salvaged hardsuit."
	alt_desc = "Salvaged hardsuit."
	icon_state = "rig_salvage"
	inhand_icon_state = "rig_salvage"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	hardsuit_type = "rig_salvage"
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 2
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20,"energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 20, "fire" = 70, "acid" = 30)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_salvage




/obj/item/clothing/head/helmet/space/hardsuit/rig_excavation
	name = "excavation hardsuit helmet"
	desc = "Hardsuit for exploring."
	alt_desc = "Hardsuit for exploring."
	icon_state = "rig_excavation"
	inhand_icon_state = "rig_excavation"
	hardsuit_type = "rig_excavation"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 60, "bullet" = 50, "laser" = 40,"energy" = 30, "bomb" = 60, "bio" = 10, "rad" = 0, "fire" = 60, "acid" = 50)
	flash_protect = 1
	armor = list(melee = 30, bullet = 20, laser = 35,energy = 20, bomb = 30, bio = 100, rad = 100, fire = 50, acid = 40)
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	slowdown = 0.5
	resistance_flags = NONE|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/rig_excavation
	name = "excavation hardsuit"
	desc = "Hardsuit for exploring."
	alt_desc = "Hardsuit for exploring."
	icon_state = "rig_excavation"
	inhand_icon_state = "rig_excavation"
	hardsuit_type = "rig_excavation"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE|FREEZE_PROOF
	jetpack = null
	slowdown = 0.5
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list(melee = 30, bullet = 20, laser = 35,energy = 20, bomb = 30, bio = 100, rad = 100, fire = 50, acid = 40)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_excavation





/obj/item/clothing/head/helmet/space/hardsuit/rig_engineeringalt
	name = "engineer hardsuit helmet"
	desc = "New style of engineer hardsuit."
	alt_desc = "New style of engineer hardsuit."
	slowdown = 0.7
	icon_state = "rig_engineeringalt"
	inhand_icon_state = "rig_engineeringalt"
	hardsuit_type = "rig_engineeringalt"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 40, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 40, "bio" = 100, "rad" = 50, "fire" = 60, "acid" = 50)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/rig_engineeringalt
	name = "engineer hardsuit"
	desc = "New style of engineer hardsuit."
	alt_desc = "New style of engineer hardsuit."
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	icon_state = "rig_engineeringalt"
	inhand_icon_state = "rig_engineeringalt"
	hardsuit_type = "rig_engineeringalt"
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	slowdown = 0.7
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 40, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 40, "bio" = 100, "rad" = 50, "fire" = 60, "acid" = 50)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_engineeringalt



/obj/item/clothing/head/helmet/space/hardsuit/skrell_helmet_black
	name = "screll hardsuit helmet"
	desc = "For skrells, for space"
	alt_desc = "For skrells, for space"
	icon_state = "skrell_helmet_black"
	inhand_icon_state = "skrell_suit_black"
	hardsuit_type = "skrell_helmet_black"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 40, "bullet" = 40, "laser" = 30, "energy" = 20, "bomb" = 40, "bio" = 100, "rad" = 0, "fire" = 50, "acid" = 40)
	flash_protect = 1
	actions_types = null
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/skrell_suit_black
	name = "screll hardsuit"
	desc = "For skrells, for space"
	alt_desc = "For skrells, for space"
	icon_state = "skrell_suit_black"
	inhand_icon_state = "skrell_suit_black"
	hardsuit_type = "skrell_suit_black"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	slowdown = 0.5
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 40, "bullet" = 40, "laser" = 30, "energy" = 20, "bomb" = 40, "bio" = 100, "rad" = 0, "fire" = 50, "acid" = 40)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/skrell_helmet_black

/obj/item/clothing/suit/space/hardsuit/rig_secalt_sec
	name = "security hardsuit"
	desc = "New style of security hardsuit."
	alt_desc = "New style of security hardsuit."
	icon_state = "rig_secalt_sec"
	inhand_icon_state = "rig_secalt_sec"
	slowdown = 0.7
	hardsuit_type = "rig_secalt"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 45, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_secalt



/obj/item/clothing/head/helmet/space/hardsuit/medical
	name = "paramedical hardsuit helmet"
	icon_state = "hardsuit0-paramedic"
	inhand_icon_state = "hardsuit0_paramedic"
	hardsuit_type = "paramedic"
	icon = 'white/Wzzzz/clothing/head.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	armor = list("melee" = 35, "bullet" = 15, "laser" = 15, "energy" = 10, "bomb" = 20, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 75)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SCAN_REAGENTS | SNUG_FIT

/obj/item/clothing/suit/space/hardsuit/medical
	name = "paramedical hardsuit"
	icon_state = "hardsuit_paramedic"
	inhand_icon_state = "hardsuit_paramedic"
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 35, "bullet" = 15, "laser" = 15, "energy" = 10, "bomb" = 20, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical
	slowdown = 0.5

/obj/item/clothing/head/helmet/space/hardsuit/pilot_helm
	name = "pilot hardsuit helmet"
	desc = "For space pilots."
	alt_desc = "For space pilots."
	icon_state = "pilot_helm"
	inhand_icon_state = "pilot_helm"
	hardsuit_type = "pilot"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 10, "fire" = 70, "acid" = 60)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/pilot
	name = "pilot hardsuit"
	desc = "For space pilots."
	alt_desc = "For space pilots."
	icon_state = "pilot"
	inhand_icon_state = "pilot"
	slowdown = 0.7
	hardsuit_type = "pilot"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30, "energy" = 20, "bomb" = 30, "bio" = 100, "rad" = 10, "fire" = 70, "acid" = 60)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/pilot_helm

/obj/item/clothing/head/helmet/space/hardsuit/helm_explorer
	name = "explorer void suit helmet"
	desc = "For space explorers."
	alt_desc = "For space explorers."
	icon_state = "helm_explorer"
	inhand_icon_state = "helm_explorer"
	hardsuit_type = "pilot"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 35, "bio" = 100, "rad" = 90, "fire" = 80, "acid" = 80)
	flash_protect = 2
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF

/obj/item/clothing/suit/space/hardsuit/void_explorer
	name = "explorer void suit"
	desc = "For space explorers."
	alt_desc = "For space explorers."
	icon_state = "void_explorer"
	inhand_icon_state = "void_explorer"
	slowdown = 0.8
	hardsuit_type = "void_explorer"
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 35, "bio" = 100, "rad" = 90, "fire" = 80, "acid" = 80)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/helm_explorer

// no
/obj/item/clothing/head/helmet/space/hardsuit/rig_secb
	name = "security hardsuit helmet"
	desc = "For space security."
	alt_desc = "For space security."
	icon_state = "sec_helm1"
	inhand_icon_state = "sec_helm1"
	hardsuit_type = "rig_sec1"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 45, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	flash_protect = 1
	actions_types = null
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 0.6
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/rig_secb
	name = "security hardsuit"
	desc = "For space security."
	alt_desc = "For space security."
	icon_state = "rig_sec1"
	inhand_icon_state = "rig_sec1"
	slowdown = 0.7
	hardsuit_type = "pilot"
	resistance_flags = NONE|FIRE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 45, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/rig_secb

/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/null
	name = "hardsuit helmet"
	desc = "Just hardsuit helmet."
	alt_desc = "Just hardsuit helmet."
	icon_state = "hardsuit0-null_rig"
	inhand_icon_state = "hardsuit0-null_rig"
	hardsuit_type = "null_rig"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	armor = list("melee" = 45, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	flash_protect = 1
	light_system = MOVABLE_LIGHT
	light_range = 4
	light_power = 1
	light_on = FALSE
	resistance_flags = NONE|FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite/null
	name = "hardsuit"
	desc = "Just hardsuit."
	alt_desc = "Just hardsuit."
	slowdown = 0.7
	hardsuit_type = "null_rig"
	resistance_flags = NONE|FIRE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "hardsuit0-null_rig"
	inhand_icon_state = "hardsuit0-null_rig"
	jetpack = null
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 45, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 30, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 85)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite/null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|FULL_BODY
	flags_inv = HIDEJUMPSUIT
	visor_flags_inv = HIDEJUMPSUIT|HIDENECK|FULL_BODY