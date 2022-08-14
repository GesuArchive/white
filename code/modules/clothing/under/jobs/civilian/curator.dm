/obj/item/clothing/under/rank/civilian/curator
	name = "вразумительный костюм"
	desc = "Он очень... вразумительный."
	icon = 'icons/obj/clothing/under/suits.dmi'
	icon_state = "red_suit"
	inhand_icon_state = "red_suit"
	worn_icon = 'icons/mob/clothing/under/suits.dmi'
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/curator/skirt
	name = "вразумительный костюм с юбкой"
	desc = "Он очень... вразумительный."
	icon = 'icons/obj/clothing/under/suits.dmi'
	icon_state = "red_suit_skirt"
	inhand_icon_state = "red_suit"
	worn_icon = 'icons/mob/clothing/under/suits.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/civilian/curator/treasure_hunter
	name = "униформа охотника за сокровищами"
	desc = "Прочная униформа, подходящая для охоты за сокровищами."
	icon = 'icons/obj/clothing/under/civilian.dmi'
	icon_state = "curator"
	inhand_icon_state = "curator"
	worn_icon = 'icons/mob/clothing/under/civilian.dmi'

/obj/item/clothing/under/rank/civilian/curator/nasa
	name = "Комбинезон NASA"
	desc = "На нем есть логотип NASA и он сделан из космоустойчивых материалов."
	icon_state = "jumpsuit"
	greyscale_colors = "#3f3f3f"
	greyscale_config = /datum/greyscale_config/jumpsuit
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_worn
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.01
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 95, FIRE = 0, ACID = 0)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST | GROIN | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	can_adjust = FALSE
	resistance_flags = NONE
