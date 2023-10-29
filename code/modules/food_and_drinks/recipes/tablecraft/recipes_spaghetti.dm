
// see code/module/crafting/table.dm

////////////////////////////////////////////////SPAGHETTI////////////////////////////////////////////////

/datum/crafting_recipe/food/tomatopasta
	name = "Паста с томатным соусом"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/grown/tomato = 2
	)
	result = /obj/item/food/spaghetti/pastatomato
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/copypasta
	name = "Копипаста"
	reqs = list(
		/obj/item/food/spaghetti/pastatomato = 2
	)
	result = /obj/item/food/spaghetti/copypasta
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/spaghettimeatball
	name = "Спагетти с фрикадельками"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meatball = 2
	)
	result = /obj/item/food/spaghetti/meatballspaghetti
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/spesslaw
	name = "Фрикадельки со спагетти"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meatball = 4
	)
	result = /obj/item/food/spaghetti/spesslaw
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/beefnoodle
	name = "Лапша с говядиной"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/cabbage = 1
	)
	result = /obj/item/food/spaghetti/beefnoodle
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/chowmein
	name = "Чау-мейн"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/cabbage = 2,
		/obj/item/food/grown/carrot = 1
	)
	result = /obj/item/food/spaghetti/chowmein
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/butternoodles
	name = "Лапша с маслом"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/spaghetti/butternoodles
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/mac_n_cheese
	name = "Макароны с сыром"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/bechamel_sauce = 1,
		/obj/item/food/cheesewedge = 2,
		/obj/item/food/breadslice = 1,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/spaghetti/mac_n_cheese
	category = CAT_SPAGHETTI

/datum/crafting_recipe/food/lasagna
	name = "Лазанья"
	reqs = list(
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/cheesewedge = 2,
		/obj/item/food/spaghetti = 1
	)
	result = /obj/item/food/spaghetti/lasagna
	category = CAT_SPAGHETTI
