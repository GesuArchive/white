
// see code/module/crafting/table.dm

////////////////////////////////////////////////EGG RECIPE's////////////////////////////////////////////////

/datum/crafting_recipe/food/friedegg
	name = "Яичница"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/food/egg = 1
	)
	result = /obj/item/food/friedegg
	category = CAT_EGG

/datum/crafting_recipe/food/omelette
	name = "Омлет с сыром"
	reqs = list(
		/obj/item/food/egg = 2,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/omelette
	category = CAT_EGG

/datum/crafting_recipe/food/chocolateegg
	name = "Шоколадное яйцо"
	reqs = list(
		/obj/item/food/boiledegg = 1,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chocolateegg
	category = CAT_EGG

/datum/crafting_recipe/food/eggsbenedict
	name = "Яйца Бенедикт"
	reqs = list(
		/obj/item/food/friedegg = 1,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/breadslice/plain = 1,
	)
	result = /obj/item/food/benedict
	category = CAT_EGG

/datum/crafting_recipe/food/eggbowl
	name = "Яичная миска"
	reqs = list(
		/obj/item/food/salad/boiledrice = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/corn = 1
	)
	result = /obj/item/food/salad/eggbowl
	category = CAT_EGG
