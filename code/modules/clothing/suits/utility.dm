/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */

/obj/item/clothing/suit/fire
	name = "аварийный пожарный костюм"
	desc = "Костюм, который помогает защитить от огня и тепла."
	icon_state = "fire"
	inhand_icon_state = "ro_suit"
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/extinguisher, /obj/item/crowbar)
	slowdown = 1
	armor = list(MELEE = 15, BULLET = 5, LASER = 20, ENERGY = 20, BOMB = 20, BIO = 50, RAD = 20, FIRE = 100, ACID = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 60
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/fire/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)

/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"
	inhand_icon_state = "firefighter"

/obj/item/clothing/suit/fire/heavy
	name = "тяжелый пожарный костюм"
	desc = "Старый, громоздкий теплозащитный костюм."
	icon_state = "thermal"
	inhand_icon_state = "ro_suit"
	slowdown = 1.5

/obj/item/clothing/suit/fire/atmos
	name = "пожарный костюм"
	desc = "Дорогой пожарный костюм, который защищает даже от самых смертельных пожаров на станции и при этом не замедляет владельца. Предназначен для защиты, даже если пользователь подожжен."
	icon_state = "atmos_firesuit"
	inhand_icon_state = "firesuit_atmos"
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "шлем сапёра"
	desc = "Используйте в случае взрыва."
	icon_state = "bombsuit"
	clothing_flags = THICKMATERIAL | SNUG_FIT
	armor = list(MELEE = 20, BULLET = 0, LASER = 20,ENERGY = 30, BOMB = 100, BIO = 0, RAD = 0, FIRE = 80, ACID = 50)
	flags_inv = HIDEFACE|HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 70
	equip_delay_other = 70
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE


/obj/item/clothing/suit/bomb_suit
	name = "костюм сапера"
	desc = "Костюм, разработанный для безопасности при обращении со взрывчаткой."
	icon_state = "bombsuit"
	inhand_icon_state = "bombsuit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.01
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	armor = list(MELEE = 20, BULLET = 0, LASER = 20,ENERGY = 30, BOMB = 100, BIO = 0, RAD = 0, FIRE = 80, ACID = 50)
	flags_inv = HIDEJUMPSUIT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	strip_delay = 70
	equip_delay_other = 70
	resistance_flags = NONE


/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuit_sec"
	inhand_icon_state = "bombsuit_sec"
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 100, BIO = 0, RAD = 0, FIRE = 80, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/bomb_suit/security
	name = "костюм военного сапера"
	desc = "Дорогой костюм, разработанный для безопасности при обращении со взрывчаткой. Хорошо бронирован и не замедляет владельца."
	icon_state = "bombsuit_sec"
	inhand_icon_state = "bombsuit_sec"
	slowdown = 0
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 100, BIO = 0, RAD = 0, FIRE = 80, ACID = 50, WOUND = 10)
	allowed = list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/flashlight,
		/obj/item/gun/ballistic,
		/obj/item/gun/energy,
		/obj/item/gun/grenadelauncher,
		/obj/item/kitchen/knife/combat,
		/obj/item/melee/baton,
		/obj/item/melee/classic_baton,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/tank/internals/tactical,
		/obj/item/storage/belt/holster/detective,
		/obj/item/storage/belt/holster/thermal,
		/obj/item/storage/belt/holster/nukie,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/storage/belt/specialist,
		/obj/item/tactical_recharger,
	)

/obj/item/clothing/head/bomb_hood/white
	icon_state = "bombsuit_white"
	inhand_icon_state = "bombsuit_white"

/obj/item/clothing/suit/bomb_suit/white
	icon_state = "bombsuit_white"
	inhand_icon_state = "bombsuit_white"

/*
* Radiation protection
*/

/obj/item/clothing/head/radiation
	name = "капюшон радиационный защиты"
	icon_state = "rad"
	desc = "Капюшон с радиационно-защитными свойствами. На этикетке написано: «Сделано из свинца. Пожалуйста, не потребляйте изоляцию.»"
	clothing_flags = THICKMATERIAL | SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEFACE|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 60, RAD = 100, FIRE = 30, ACID = 30)
	strip_delay = 60
	equip_delay_other = 60
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	flags_1 = RAD_PROTECT_CONTENTS_1

/obj/item/clothing/suit/radiation
	name = "костюм радиационный защиты"
	desc = "Костюм с радиационно-защитными свойствами. На этикетке написано: «Сделано из свинца. Пожалуйста, не потребляйте изоляцию.»"
	icon_state = "rad"
	inhand_icon_state = "rad_suit"
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/tank/jetpack, /obj/item/geiger_counter)
	slowdown = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 50, RAD = 100, FIRE = 30, ACID = 30)
	strip_delay = 60
	equip_delay_other = 60
	flags_inv = HIDEJUMPSUIT
	resistance_flags = NONE
	flags_1 = RAD_PROTECT_CONTENTS_1

/obj/item/clothing/suit/radiation/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)
