
// see code/datums/recipe.dm


// see code/module/crafting/table.dm

////////////////////////////////////////////////SANDWICHES////////////////////////////////////////////////

/datum/crafting_recipe/food/sandwich
	name = "Сэндвич"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/sandwich
	category = CAT_SANDWICH

/datum/crafting_recipe/food/cheese_sandwich
	name = "Сырный сэндвич"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/cheese_sandwich
	category = CAT_SANDWICH

/datum/crafting_recipe/food/slimesandwich
	name = "Желейный сэндвич (слаймовый)"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/breadslice/plain = 2,
	)
	result = /obj/item/food/jellysandwich/slime
	category = CAT_SANDWICH

/datum/crafting_recipe/food/cherrysandwich
	name = "Желейный сэндвич"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/food/breadslice/plain = 2,
	)
	result = /obj/item/food/jellysandwich/cherry
	category = CAT_SANDWICH

/datum/crafting_recipe/food/notasandwich
	name = "Не-сэндвич"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/clothing/mask/fakemoustache = 1
	)
	result = /obj/item/food/notasandwich
	category = CAT_SANDWICH



