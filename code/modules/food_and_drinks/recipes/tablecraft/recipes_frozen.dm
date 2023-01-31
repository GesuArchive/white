
/////////////////
//Misc. Frozen.//
/////////////////

/datum/crafting_recipe/food/icecreamsandwich
	name = "Мороженое-сэндвич"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/ice = 5,
		/obj/item/food = 1
	)
	result = /obj/item/food/icecreamsandwich
	category = CAT_ICE

/datum/crafting_recipe/food/strawberryicecreamsandwich
	name = "Клубничное мороженое-сэндвич"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/ice = 5,
		/obj/item/food/grown/berries = 2,
	)
	result = /obj/item/food/strawberryicecreamsandwich
	category = CAT_ICE

/datum/crafting_recipe/food/spacefreezy
	name ="Космическая Замерзайка"
	reqs = list(
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/consumable/spacemountainwind = 15,
		/obj/item/food = 1
	)
	result = /obj/item/food/spacefreezy
	category = CAT_ICE

/datum/crafting_recipe/food/sundae
	name ="Сандей"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/grown/cherries = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/food = 1
	)
	result = /obj/item/food/sundae
	category = CAT_ICE

/datum/crafting_recipe/food/honkdae
	name ="Хонкдей"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/clothing/mask/gas/clown_hat = 1,
		/obj/item/food/grown/cherries = 1,
		/obj/item/food/grown/banana = 2,
		/obj/item/food = 1
	)
	result = /obj/item/food/honkdae
	category = CAT_ICE

/datum/crafting_recipe/food/cornuto
	name = "Рожок"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/cream = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/sugar = 4
	)
	result = /obj/item/food/cornuto
	category = CAT_ICE

//////////////////////////SNOW CONES///////////////////////

/datum/crafting_recipe/food/flavorless_sc
	name = "Безвкусное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15
	)
	result = /obj/item/food/snowcones
	category = CAT_ICE

/datum/crafting_recipe/food/pineapple_sc
	name = "Ананасовое гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/pineapplejuice = 5
	)
	result = /obj/item/food/snowcones/pineapple
	category = CAT_ICE

/datum/crafting_recipe/food/lime_sc
	name = "Лаймовое гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/limejuice = 5
	)
	result = /obj/item/food/snowcones/lime
	category = CAT_ICE

/datum/crafting_recipe/food/lemon_sc
	name = "Лимонное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/lemonjuice = 5
	)
	result = /obj/item/food/snowcones/lemon
	category = CAT_ICE

/datum/crafting_recipe/food/apple_sc
	name = "Яблочное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/applejuice = 5
	)
	result = /obj/item/food/snowcones/apple
	category = CAT_ICE

/datum/crafting_recipe/food/grape_sc
	name = "Виноградное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/grapejuice = 5
	)
	result = /obj/item/food/snowcones/grape
	category = CAT_ICE

/datum/crafting_recipe/food/orange_sc
	name = "Апельсиновое гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/orangejuice = 5
	)
	result = /obj/item/food/snowcones/orange
	category = CAT_ICE

/datum/crafting_recipe/food/blue_sc
	name = "Синевишневое гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/bluecherryjelly= 5
	)
	result = /obj/item/food/snowcones/blue
	category = CAT_ICE

/datum/crafting_recipe/food/red_sc
	name = "Вишневое гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/cherryjelly= 5
	)
	result = /obj/item/food/snowcones/red
	category = CAT_ICE

/datum/crafting_recipe/food/berry_sc
	name = "Ягодное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/berryjuice = 5
	)
	result = /obj/item/food/snowcones/berry
	category = CAT_ICE

/datum/crafting_recipe/food/fruitsalad_sc
	name = "Мультифруктовое гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/water  = 5,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/consumable/limejuice = 5,
		/datum/reagent/consumable/lemonjuice = 5
	)
	result = /obj/item/food/snowcones/fruitsalad
	category = CAT_ICE

/datum/crafting_recipe/food/mime_sc
	name = "Гранисадо мима"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/nothing = 5
	)
	result = /obj/item/food/snowcones/mime
	category = CAT_ICE

/datum/crafting_recipe/food/clown_sc
	name = "Клоунское гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/laughter = 5
	)
	result = /obj/item/food/snowcones/clown
	category = CAT_ICE

/datum/crafting_recipe/food/soda_sc
	name = "Космокольное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/space_cola = 5
	)
	result = /obj/item/food/snowcones/soda
	category = CAT_ICE

/datum/crafting_recipe/food/spacemountainwind_sc
	name = "Солнечно-ветрянное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/spacemountainwind = 5
	)
	result = /obj/item/food/snowcones/spacemountainwind
	category = CAT_ICE

/datum/crafting_recipe/food/pwrgame_sc
	name = "PWR Game гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/pwr_game = 15
	)
	result = /obj/item/food/snowcones/pwrgame
	category = CAT_ICE

/datum/crafting_recipe/food/honey_sc
	name = "Медовое гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/snowcones/honey
	category = CAT_ICE

/datum/crafting_recipe/food/rainbow_sc
	name = "Радужное гранисадо"
	reqs = list(
		/obj/item/reagent_containers/food/drinks/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/colorful_reagent = 1 //Harder to make
	)
	result = /obj/item/food/snowcones/rainbow
	category = CAT_ICE

//////////////////////////ФРУКТОВЫЙ ЛЁД И МОРОЖЕНОЕ///////////////////////

// This section includes any frozen treat served on a stick.
////////////////////////////////////////////////////////////

/datum/crafting_recipe/food/orange_popsicle
	name = "Апельсиновцы фруктовый лед"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/orangejuice = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/creamsicle_orange
	category = CAT_ICE

/datum/crafting_recipe/food/berry_popsicle
	name = "Ягодный фруктовый лед"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/berryjuice = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/creamsicle_berry
	category = CAT_ICE

/datum/crafting_recipe/food/jumbo
	name = "Мороженое Джамбо"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 3,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/jumbo
	category = CAT_ICE

/datum/crafting_recipe/food/nogga_black
	name = "Ноггер Черный"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/blumpkinjuice = 4, //natural source of ammonium chloride
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/nogga_black
	category = CAT_ICE
