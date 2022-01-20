/**
 * # Ninja Mask
 *
 * Space ninja's mask.  Other than looking cool, doesn't do anything.
 *
 * A mask which only spawns as a part of space ninja's starting kit.  Functions as a gas mask.
 *
 */
/obj/item/clothing/mask/gas/space_ninja
	name = "Маска ниндзя"
	desc = "Плотно прилегающая маска, которая действует как воздушный фильтр и является образцом постмодернистской моды."
	icon_state = "s-ninja"
	inhand_icon_state = "s-ninja_mask"
	strip_delay = 120
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	has_fov = FALSE
