
// see code/module/crafting/table.dm

// MISC

/datum/crafting_recipe/food/candiedapple
	name = "Карамелезированное яблоко"
	reqs = list(
		/datum/reagent/consumable/caramel = 5,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/candiedapple
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/spiderlollipop
	name = "Паучий леденец"
	reqs = list(/obj/item/stack/rods = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/water = 5,
		/obj/item/food/spiderling = 1
	)
	result = /obj/item/food/chewable/spiderlollipop
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/chococoin
	name = "Шоколадная монетка"
	reqs = list(
		/obj/item/coin = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/chococoin
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/fudgedice
	name = "Помадные кубики"
	reqs = list(
		/obj/item/dice = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/fudgedice
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/chocoorange
	name = "Шоколадный апельсин"
	reqs = list(
		/obj/item/food/grown/citrus/orange = 1,
		/obj/item/food/chocolatebar = 1,
	)
	result = /obj/item/food/chocoorange
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/loadedbakedpotato
	name = "Печеный картофель с начинкой"
	time = 40
	reqs = list(
		/obj/item/food/grown/potato = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/loadedbakedpotato
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/cheesyfries
	name = "Сырное фри"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/cheesyfries
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/wrap
	name = "Яичная обертка"
	reqs = list(/datum/reagent/consumable/soysauce = 10,
		/obj/item/food/friedegg = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/eggwrap
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/beans
	name = "Баночка фасоли"
	time = 40
	reqs = list(/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/grown/soybeans = 2
	)
	result = /obj/item/food/canned/beans
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/eggplantparm
	name ="Баклажанная пармиджана"
	reqs = list(
		/obj/item/food/cheesewedge = 2,
		/obj/item/food/grown/eggplant = 1
	)
	result = /obj/item/food/eggplantparm
	category = CAT_MISCFOOD


////////////////////////////////////////////////БУРРИТО////////////////////////////////////////////////

/datum/crafting_recipe/food/burrito
	name ="Буррито"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/soybeans = 2
	)
	result = /obj/item/food/burrito
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/cheesyburrito
	name ="Сырное буррито"
	reqs = list(
		/obj/item/food/cheesewedge = 2,
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/cheesyburrito
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/carneburrito
	name ="Буррито Карне Асада"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/carneburrito
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/fuegoburrito
	name ="Огненно-плазменный буррито"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/grown/ghost_chili = 2,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/fuegoburrito
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/nachos
	name ="Начос"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/tortilla = 1
	)
	result = /obj/item/food/nachos
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/cheesynachos
	name ="Сырные начос"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/tortilla = 1
	)
	result = /obj/item/food/cheesynachos
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/cubannachos
	name ="Кубинские начос"
	reqs = list(
		/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/tortilla = 1
	)
	result = /obj/item/food/cubannachos
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/melonkeg
	name ="Бочонок из дыни"
	reqs = list(
		/datum/reagent/consumable/ethanol/vodka = 25,
		/obj/item/food/grown/holymelon = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 1
	)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle/vodka = 1)
	result = /obj/item/food/melonkeg
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/honeybar
	name = "Медово-ореховый батончик"
	reqs = list(
		/obj/item/food/grown/oat = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/honeybar
	category = CAT_MISCFOOD


/datum/crafting_recipe/food/stuffedlegion
	name = "Фаршированный Легион"
	time = 40
	reqs = list(
		/obj/item/food/meat/steak/goliath = 1,
		/obj/item/organ/regenerative_core/legion = 1,
		/datum/reagent/consumable/ketchup = 2,
		/datum/reagent/consumable/capsaicin = 2
	)
	result = /obj/item/food/stuffedlegion
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/powercrepe
	name = "Боевой блин"
	time = 40
	reqs = list(
		/obj/item/food/flatdough = 1,
		/datum/reagent/consumable/milk = 1,
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/stock_parts/cell/super =1,
		/obj/item/melee/sabre = 1
	)
	result = /obj/item/food/powercrepe
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/taco
	name ="Классическое тако"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/taco
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/tacoplain
	name ="Тако"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/taco/plain
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/branrequests
	name = "Сухой завтрак с отрубями"
	reqs = list(
		/obj/item/food/grown/wheat = 1,
		/obj/item/food/no_raisin = 1,
	)
	result = /obj/item/food/branrequests
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/ricepudding
	name = "Рисовый пудинг"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/salad/boiledrice = 1
	)
	result = /obj/item/food/salad/ricepudding
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/risotto
	name = "Ризотто"
	reqs = list(
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/salad/boiledrice = 1,
		/obj/item/food/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/food/salad/risotto
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/butterbear //ITS ALIVEEEEEE!
	name = "Живое масло"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/organ/heart = 1,
		/obj/item/food/butter = 10,
		/obj/item/food/meat/slab = 5,
		/datum/reagent/blood = 50,
		/datum/reagent/teslium = 1 //To shock the whole thing into life
	)
	result = /mob/living/simple_animal/hostile/bear/butter
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/crab_rangoon
	name = "Крабовый рангун"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/meat/rawcrab = 1
	)
	result = /obj/item/food/crab_rangoon
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/royalcheese
	name = "Королевский сыр"
	reqs = list(
		/obj/item/food/cheesewheel = 1,
		/obj/item/clothing/head/crown = 1,
		/datum/reagent/medicine/strange_reagent = 5,
		/datum/reagent/toxin/mutagen = 5
	)
	result = /obj/item/food/royalcheese
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/ant_candy
	name = "Муравьиная конфета"
	reqs = list(/obj/item/stack/rods = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/water = 5,
		/datum/reagent/ants = 10
	)
	result = /obj/item/food/ant_candy
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/pesto
	name = "Песто"
	reqs = list(
		/obj/item/food/firm_cheese_slice = 1,
		/datum/reagent/consumable/salt = 5,
		/obj/item/food/grown/herbs = 2,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/quality_oil = 5,
		/obj/item/food/canned/pine_nuts = 1
	)
	result = /obj/item/food/pesto
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/tomato_sauce
	name = "Томатный соус"
	reqs = list(
		/obj/item/food/canned/tomatoes = 1,
		/datum/reagent/consumable/salt = 2,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/quality_oil = 5
	)
	result = /obj/item/food/tomato_sauce
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/bechamel_sauce
	name = "Соус Бешамель"
	reqs = list(
		/datum/reagent/consumable/milk = 10,
		/datum/reagent/consumable/flour = 5,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/bechamel_sauce
	category = CAT_MISCFOOD
