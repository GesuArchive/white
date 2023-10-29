/**
 * # Ninja Shoes
 *
 * Space ninja's shoes.  Gives him armor on his feet.
 *
 * Space ninja's ninja shoes.  How mousey.  Gives him slip protection and protection against attacks.
 * Also are temperature resistant.
 *
 */
/obj/item/clothing/shoes/space_ninja
	name = "ботинки нинздя"
	desc = "Идеальна для разбивания чужих черепов на бегу."
	icon_state = "s-ninja"
	inhand_icon_state = "secshoes"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	clothing_flags = NOSLIP
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor = list(MELEE = 40, BULLET = 30, LASER = 20,ENERGY = 15, BOMB = 30, BIO = 30, RAD = 30, FIRE = 100, ACID = 100)
	strip_delay = 120
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	slowdown = -1
