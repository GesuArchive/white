/obj/item/clothing/under/rank/captain
	desc = "Это синий комбинезон с золотыми знаками, обозначающими звание \"Капитан\"."
	name = "комбинезон капитана"
	icon_state = "captain"
	item_state = "b_suit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	icon = 'icons/obj/clothing/under/captain.dmi'
	mob_overlay_icon = 'icons/mob/clothing/under/captain.dmi'

/obj/item/clothing/under/rank/captain/skirt
	name = "юбкомбез капитана"
	desc = "Это синий юбкомбез с золотыми знаками, обозначающими звание \"Капитан\"."
	icon_state = "captain_skirt"
	item_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/captain/suit
	name = "костюм капитана"
	desc = "Зеленый костюм и желтый галстук. Пример авторитета."
	icon_state = "green_suit"
	item_state = "dg_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/captain/suit/skirt
	name = "зелёный костюм капитана с юбкой"
	desc = "Зеленая костюмная юбка и желтый галстук. Пример авторитета."
	icon_state = "green_suit_skirt"
	item_state = "dg_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/captain/parade
	name = "парадный костюм капитана"
	desc = "Капитанская роскошная одежда, для особых случаев."
	icon_state = "captain_parade"
	item_state = "by_suit"
	can_adjust = FALSE
