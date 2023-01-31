/obj/item/food/shaurma
	name = "шаурма"
	desc = "Популярное блюдо средней азии. Очень вкусная."
	icon = 'white/ClickerOfThings/shitFood/shaurma.dmi'
	icon_state = "shaurma"
	foodtypes = GRAIN
	lefthand_file = 'white/ClickerOfThings/shitFood/shaurma_left.dmi'
	righthand_file = 'white/ClickerOfThings/shitFood/shaurma_right.dmi'

/obj/item/food/shaurma/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, null, CUSTOM_INGREDIENT_ICON_FILL, max_ingredients = 8)

/datum/crafting_recipe/food/shaurma
	name = "Лаваш шаурмы"
	reqs = list(
		/obj/item/food/flatdough = 3,
	)
	result = /obj/item/food/shaurma
	category = CAT_MISCFOOD
