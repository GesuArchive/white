/obj/item/clothing/under/rank/captain
	desc = "Это синий комбинезон с золотыми знаками, обозначающими звание \"Капитан\"."
	name = "комбинезон капитана"
	icon_state = "captain"
	inhand_icon_state = "b_suit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	icon = 'icons/obj/clothing/under/captain.dmi'
	worn_icon = 'icons/mob/clothing/under/captain.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 15)

/obj/item/clothing/under/rank/captain/skirt
	name = "юбкомбез капитана"
	desc = "Это синий юбкомбез с золотыми знаками, обозначающими звание \"Капитан\"."
	icon_state = "captain_skirt"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/captain/suit
	name = "костюм капитана"
	desc = "Зеленый костюм и желтый галстук. Пример авторитета."
	icon_state = "green_suit"
	inhand_icon_state = "dg_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/captain/suit/skirt
	name = "зелёный костюм капитана с юбкой"
	desc = "Зеленая костюмная юбка и желтый галстук. Пример авторитета."
	icon_state = "green_suit_skirt"
	inhand_icon_state = "dg_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/captain/parade
	name = "парадный костюм капитана"
	desc = "Капитанская роскошная одежда, для особых случаев."
	icon_state = "captain_parade"
	inhand_icon_state = "by_suit"
	can_adjust = FALSE
