
// see code/module/crafting/table.dm

////////////////////////////////////////////////PIZZA!!!////////////////////////////////////////////////

/datum/crafting_recipe/food/margheritapizza
	name = "Пицца Маргарита"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/cheesewedge = 4,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/margherita/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/meatpizza
	name = "Мясная пицца"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/meat/rawcutlet = 4,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/meat/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/arnold
	name = "Пицца Арнольд"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/meat/rawcutlet = 3,
		/obj/item/ammo_casing/c9mm = 8,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/arnold/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/mushroompizza
	name = "Грибная пицца"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/grown/mushroom = 5
	)
	result = /obj/item/food/pizza/mushroom/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/vegetablepizza
	name = "Овощная пицца"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/corn = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/vegetable/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/donkpocketpizza
	name = "Пицца \"Донк-покет\""
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/donkpocket = 3,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/donkpocket/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/dankpizza
	name = "Шняжная пицца"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/grown/ambrosia/vulgaris = 3,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/dank/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/sassysagepizza
	name = "Колбасная пицца"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/raw_meatball = 3,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/sassysage/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/pineapplepizza
	name = "Гавайская пицца"
	reqs = list(
		/obj/item/food/flatdough = 1,
		/obj/item/food/meat/rawcutlet = 2,
		/obj/item/food/pineappleslice = 3,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/pizza/pineapple/raw
	category = CAT_PIZZA

/datum/crafting_recipe/food/antspizza
	name = "Пицца для муравьиной вечеринки"
	reqs = list(
		/obj/item/food/pizzabread = 1,
		/obj/item/food/cheesewedge = 2,
		/obj/item/food/grown/tomato = 1,
		/datum/reagent/ants = 20
	)
	result = /obj/item/food/pizza/ants
	category = CAT_PIZZA
