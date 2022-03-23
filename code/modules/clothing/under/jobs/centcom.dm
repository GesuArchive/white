/obj/item/clothing/under/rank/centcom
	icon = 'icons/obj/clothing/under/centcom.dmi'
	worn_icon = 'icons/mob/clothing/under/centcom.dmi'

/obj/item/clothing/under/rank/centcom/commander
	name = "костюм командующего ЦентКома"
	desc = "Эта одежда хороша на высших офицерах командования."
	icon_state = "centcom"
	inhand_icon_state = "dg_suit"

/obj/item/clothing/under/rank/centcom/commander/grand
	desc = "Комбинезон с золотыми знаками, который носит самый высокопоставленный офицер ЦК."
	name = "комбинезон гранд-адмирала ЦК"
	icon_state = "grand_admiral"
	can_adjust = FALSE

/obj/item/clothing/gloves/color/captain/centcom
	desc = "Царственные зеленые перчатки с красивой золотой отделкой, алмазным противоударным покрытием и встроенным тепловым барьером. Шикарно."
	name = "перчатки ЦентКома"
	icon_state = "centcom"

/obj/item/clothing/head/centhat/admiral/grand
	name = "фуражка гранд-адмирала"
	icon_state = "grand_admiral"
	desc = "It's good to be a Q."

/obj/item/clothing/gloves/color/captain/centcom/admiral
	desc = "Царственные черные перчатки с красивой золотой отделкой, алмазным противоударным покрытием и встроенным тепловым барьером. Шикарно."
	name = "перчатки гранд-адмирала ЦК"
	icon_state = "grand_admiral"

/obj/item/clothing/under/rank/centcom/intern
	name = "костюм интерна ЦентКома"
	desc = "Рубашечка для прощей идентификации. Сразу видно, новичок."
	icon_state = "intern"
	inhand_icon_state = "g_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/centcom/officer
	name = "водолазка офицера ЦентКома"
	desc = "Обыкновенная, но изящная водолазка, которую используют представители ЦК. Пахнет алоэ."
	icon_state = "officer"
	inhand_icon_state = "dg_suit"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/centcom/officer/replica
	name = "реплика водолазки офицера ЦентКома"
	desc = "Дешевая копия водолазки, которую носят представители ЦК. На шее можно увидеть лого Donk Co."

/obj/item/clothing/under/rank/centcom/officer_skirt
	name = "водоюбка офицера ЦентКома"
	desc = "Вариант водолазки представителей ЦК в виде юбки, более редкий и более востребованный, чем её оригинал."
	icon_state = "officer_skirt"
	inhand_icon_state = "dg_suit"
	alt_covers_chest = TRUE
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/centcom/officer_skirt/replica
	name = "реплика водоюбки офицера ЦентКома"
	desc = "Дешевая копия водолазки, которую носят представители ЦК. На шее можно увидеть лого Donk Co."

/obj/item/clothing/under/rank/centcom/centcom_skirt
	name = "юбкомбез офицера ЦентКома"
	desc = "Юбкомбез, который носят только высшие офицеры ЦентКома."
	icon_state = "centcom_skirt"
	inhand_icon_state = "dg_suit"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/rank/centcom/military
	name = "тактическая униформа"
	desc = "Униформа темного цвета, которую носят мобилизованные вооруженные силы ЦК."
	icon_state = "military"
	inhand_icon_state = "bl_suit"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 40)
	can_adjust = FALSE

/obj/item/clothing/under/rank/centcom/military/eng
	name = "тактическая униформа инженера"
	desc = "Униформа темного цвета, которую носят военные инженеры ЦК."
	icon_state = "military_eng"
