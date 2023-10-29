/obj/item/clothing/under/color
	desc = "Стандартный цветной комбинезон. Разнообразие - это часть жизни!"
	dying_key = DYE_REGISTRY_UNDER
	greyscale_colors = "#3f3f3f"
	greyscale_config = /datum/greyscale_config/jumpsuit
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_worn
	icon = 'icons/obj/clothing/under/color.dmi'
	icon_state = "jumpsuit"
	inhand_icon_state = "jumpsuit"
	worn_icon = 'icons/mob/clothing/under/color.dmi'
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/color/jumpskirt
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP
	icon_state = "jumpskirt"

/obj/item/clothing/under/color/random
	icon_state = "random_jumpsuit"

/obj/item/clothing/under/color/random/Initialize(mapload)
	..()
	var/obj/item/clothing/under/color/C = pick(subtypesof(/obj/item/clothing/under/color) - typesof(/obj/item/clothing/under/color/jumpskirt) - /obj/item/clothing/under/color/random - /obj/item/clothing/under/color/grey/ancient - /obj/item/clothing/under/color/black/ghost - /obj/item/clothing/under/rank/prisoner)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.equip_to_slot_or_del(new C(H), ITEM_SLOT_ICLOTHING, initial=TRUE) //or else you end up with naked assistants running around everywhere...
	else
		new C(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/clothing/under/color/jumpskirt/random
	icon_state = "random_jumpsuit"		//Skirt variant needed

/obj/item/clothing/under/color/jumpskirt/random/Initialize(mapload)
	..()
	var/obj/item/clothing/under/color/jumpskirt/C = pick(subtypesof(/obj/item/clothing/under/color/jumpskirt) - /obj/item/clothing/under/color/jumpskirt/random - /obj/item/clothing/under/rank/prisoner/skirt)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.equip_to_slot_or_del(new C(H), ITEM_SLOT_ICLOTHING, initial=TRUE)
	else
		new C(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/clothing/under/color/black
	name = "чёрный комбинезон"
	resistance_flags = NONE

/obj/item/clothing/under/color/jumpskirt/black
	name = "чёрный юбкомбезон"

/obj/item/clothing/under/color/black/ghost
	item_flags = DROPDEL

/obj/item/clothing/under/color/black/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/clothing/under/color/grey
	name = "серый комбинезон"
	desc = "Изящный серый комбинезон, напоминающий вам о старых добрых временах."
	greyscale_colors = "#b3b3b3"

/obj/item/clothing/under/color/jumpskirt/grey
	name = "серый юбкомбезон"
	desc = "Изящный серый юбкомбезон, напоминающий вам о старых добрых временах."
	greyscale_colors = "#b3b3b3"

/obj/item/clothing/under/color/grey/ancient
	name = "древний комбинезон"
	desc = "Ужасно оборванный и потрепанный серый комбинезон. Похоже, его не стирали уже больше десяти лет."
	icon_state = "grey_ancient"
	inhand_icon_state = "gy_suit"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	can_adjust = TRUE

/obj/item/clothing/under/color/blue
	name = "синий комбинезон"
	greyscale_colors = "#52aecc"

/obj/item/clothing/under/color/jumpskirt/blue
	name = "синий юбкомбезон"
	greyscale_colors = "#52aecc"

/obj/item/clothing/under/color/green
	name = "зелёный комбинезон"
	greyscale_colors = "#9ed63a"

/obj/item/clothing/under/color/jumpskirt/green
	name = "зелёный юбкомбезон"
	greyscale_colors = "#9ed63a"

/obj/item/clothing/under/color/orange
	name = "оранжевый комбинезон"
	desc = "Не носите это рядом с параноидальными офицерами."
	greyscale_colors = "#ff8c19"

/obj/item/clothing/under/color/jumpskirt/orange
	name = "оранжевый юбкомбезон"
	greyscale_colors = "#ff8c19"

/obj/item/clothing/under/color/pink
	name = "розовый комбинезон"
	desc = "Достаточно посмотреть на этот костюм и почувствовать себя <i>неповторимым</i> парнем на деревне."
	greyscale_colors = "#ffa69b"

/obj/item/clothing/under/color/jumpskirt/pink
	name = "розовый юбкомбезон"
	greyscale_colors = "#ffa69b"

/obj/item/clothing/under/color/red
	name = "красный комбинезон"
	greyscale_colors = "#eb0c07"

/obj/item/clothing/under/color/jumpskirt/red
	name = "красный юбкомбезон"
	greyscale_colors = "#eb0c07"

/obj/item/clothing/under/color/white
	name = "белый комбинезон"
	greyscale_colors = "#ffffff"

/obj/item/clothing/under/color/jumpskirt/white
	name = "белый юбкомбезон"
	greyscale_colors = "#ffffff"

/obj/item/clothing/under/color/yellow
	name = "желтый комбинезон"
	greyscale_colors = "#ffe14d"

/obj/item/clothing/under/color/jumpskirt/yellow
	name = "желтый юбкомбезон"
	greyscale_colors = "#ffe14d"

/obj/item/clothing/under/color/darkblue
	name = "тёмно-синий комбинезон"
	greyscale_colors = "#3285ba"

/obj/item/clothing/under/color/jumpskirt/darkblue
	name = "тёмно-синий юбкомбезон"
	greyscale_colors = "#3285ba"

/obj/item/clothing/under/color/teal
	name = "сине-зеленый комбинезон"
	greyscale_colors = "#77f3b7"

/obj/item/clothing/under/color/jumpskirt/teal
	name = "сине-зеленый юбкомбезон"
	greyscale_colors = "#77f3b7"

/obj/item/clothing/under/color/lightpurple
	name = "светло-фиолетовый комбинезон"
	greyscale_colors = "#9f70cc"

/obj/item/clothing/under/color/jumpskirt/lightpurple
	name = "светло-фиолетовый юбкомбезон"
	greyscale_colors = "#9f70cc"

/obj/item/clothing/under/color/darkgreen
	name = "тёмно-зелёный комбинезон"
	greyscale_colors = "#6fbc22"

/obj/item/clothing/under/color/jumpskirt/darkgreen
	name = "тёмно-зелёный юбкомбезон"
	greyscale_colors = "#6fbc22"

/obj/item/clothing/under/color/lightbrown
	name = "светло-коричневый комбинезон"
	greyscale_colors = "#c59431"

/obj/item/clothing/under/color/jumpskirt/lightbrown
	name = "светло-коричневый юбкомбезон"
	greyscale_colors = "#c59431"

/obj/item/clothing/under/color/brown
	name = "коричневый комбинезон"
	greyscale_colors = "#a17229"

/obj/item/clothing/under/color/jumpskirt/brown
	name = "коричневый юбкомбезон"
	greyscale_colors = "#a17229"

/obj/item/clothing/under/color/maroon
	name = "бордовый комбинезон"
	greyscale_colors = "#cc295f"

/obj/item/clothing/under/color/jumpskirt/maroon
	name = "бордовый юбкомбезон"
	greyscale_colors = "#cc295f"

/obj/item/clothing/under/color/rainbow
	name = "радужный комбинезон"
	desc = "Многоцветный комбинезон!"
	icon_state = "rainbow"
	inhand_icon_state = "rainbow"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	can_adjust = FALSE
	flags_1 = NONE

/obj/item/clothing/under/color/jumpskirt/rainbow
	name = "радужный юбкомбезон"
	desc = "Многоцветный комбинезон!"
	icon_state = "rainbow_skirt"
	inhand_icon_state = "rainbow"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	can_adjust = FALSE
	flags_1 = NONE
