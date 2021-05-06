/**
 * # Ninja Hood
 *
 * Space ninja's hood.  Provides armor and blocks AI tracking.
 *
 * A hood that only exists as a part of space ninja's starting kit.  Provides armor equal of space ninja's suit and disallows an AI to track the wearer.
 *
 */
/obj/item/clothing/head/helmet/space/space_ninja
	desc = "То, что может показаться простым чёрным предметом одежды, на самом деле является очень сложным шлемом из наноплетения. Стандартное снаряжение ниндзя."
	name = "Капюшон ниндзя"
	icon_state = "s-ninja"
	inhand_icon_state = "s-ninja_mask"
	armor = list(MELEE = 40, BULLET = 30, LASER = 20,ENERGY = 15, BOMB = 30, BIO = 30, RAD = 25, FIRE = 100, ACID = 100)
	strip_delay = 12
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	blockTracking = TRUE//Roughly the only unique thing about this helmet.
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
