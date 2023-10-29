/obj/item/clothing/under/dress
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE
	body_parts_covered = CHEST|GROIN
	icon = 'icons/obj/clothing/under/dress.dmi'
	worn_icon = 'icons/mob/clothing/under/dress.dmi'

/obj/item/clothing/under/dress/sundress
	name = "сарафан"
	desc = "Заставляет вас резвиться в поле ромашек."
	icon_state = "sundress"
	inhand_icon_state = "sundress"
	greyscale_colors = "#FFE60F#9194A5#1F243C"
	greyscale_config = /datum/greyscale_config/sundress
	greyscale_config_worn = /datum/greyscale_config/sundress_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/blacktango
	name = "платье"
	desc = "Для зажигательных танцев."
	icon_state = "black_tango"
	inhand_icon_state = "wcoat"

/obj/item/clothing/under/dress/striped
	name = "платье"
	desc = "Полосатое платье."
	icon_state = "striped_dress"
	inhand_icon_state = "striped_dress"
	fitted = FEMALE_UNIFORM_FULL

/obj/item/clothing/under/dress/sailor
	name = "платье"
	desc = "Платье для морячки."
	icon_state = "sailor_dress"
	inhand_icon_state = "sailor_dress"

/obj/item/clothing/under/dress/wedding_dress
	name = "свадебное платье"
	desc = "Роскошное платье для случаев, которые бывают раз в жизни."
	icon_state = "wedding_dress"
	inhand_icon_state = "wedding_dress"
	body_parts_covered = CHEST|GROIN|LEGS
	flags_cover = HIDESHOES

/obj/item/clothing/under/dress/redeveninggown
	name = "платье"
	desc = "Прекрасное платье для барной певицы."
	icon_state = "red_evening_gown"
	inhand_icon_state = "red_evening_gown"

/obj/item/clothing/under/dress/skirt
	name = "юбка"
	desc = "Черная юбка, замечательно!"
	icon_state = "blackskirt"

/obj/item/clothing/under/dress/skirt/blue
	name = "юбка"
	desc = "Синяя повседневная юбка."
	icon_state = "blueskirt"
	inhand_icon_state = "b_suit"
	custom_price = PAYCHECK_EASY

/obj/item/clothing/under/dress/skirt/red
	name = "юбка"
	desc = "Красная повседневная юбка."
	icon_state = "redskirt"
	inhand_icon_state = "r_suit"
	custom_price = PAYCHECK_EASY

/obj/item/clothing/under/dress/skirt/purple
	name = "юбка"
	desc = "Фиолетовая повседневная юбка."
	icon_state = "purpleskirt"
	inhand_icon_state = "p_suit"
	custom_price = PAYCHECK_EASY

/obj/item/clothing/under/dress/skirt/plaid
	name = "юбка"
	desc = "Красная юбка с белой блузкой."
	icon_state = "plaidskirt"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	custom_price = PAYCHECK_EASY
	greyscale_colors = "#CC2102"
	greyscale_config = /datum/greyscale_config/plaidskirt
	greyscale_config_worn = /datum/greyscale_config/plaidskirt_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/skirt/plaid/blue
	name = "юбка"
	desc = "Синяя юбка с белой блузкой"
	greyscale_colors = "#2f44cb"

/obj/item/clothing/under/dress/skirt/plaid/purple
	name = "юбка"
	desc = "Фиолетовая юбка с белой блузкой."
	greyscale_colors = "#b41cc2"

/obj/item/clothing/under/dress/skirt/plaid/green
	name = "юбка"
	desc = "Зеленая юбка с белой блузкой."
	greyscale_colors = "#44e81b"

/obj/item/clothing/under/dress/skirt/turtleskirt
	name = "юбка-водолазка с высоким воротом"
	desc = "Повседневная юбка-водолазка с высоким воротом."
	icon_state = "turtleskirt"
	custom_price = PAYCHECK_EASY
	greyscale_colors = "#cc0000#5f5f5f"
	greyscale_config = /datum/greyscale_config/turtleskirt
	greyscale_config_worn = /datum/greyscale_config/turtleskirt_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/dress/tango
	name = "платье для танго"
	desc = "Наполненна латинским огнем."
	icon_state = "tango"
	custom_price = PAYCHECK_EASY
	greyscale_colors = "#ff0000#1c1c1c"
	greyscale_config = /datum/greyscale_config/tango
	greyscale_config_worn = /datum/greyscale_config/tango_worn
	flags_1 = IS_PLAYER_COLORABLE_1
