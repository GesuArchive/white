/datum/blackmarket_item/misc
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Прочее"

/datum/blackmarket_item/misc/allresources
	name = "Шкаф со всеми ресурсами"
	desc = "Все возможные ресурсы только для вас!"
	item = /obj/structure/closet/syndicate/resources/everything

	price_min = 5000
	price_max = 20000
	stock_min = 3
	stock_max = 1
	availability_prob = 100

/datum/blackmarket_item/misc/holywater
	name = "Склянка священной воды"
	desc = "Собственная марка отца Лотия."
	item = /obj/item/reagent_containers/food/drinks/bottle/holywater

	price_min = 40
	price_max = 60
	stock_max = 3
	availability_prob = 40

/datum/blackmarket_item/misc/holywater/spawn_item(loc)
	if (prob(6.66))
		return new /obj/item/reagent_containers/glass/beaker/unholywater(loc)
	return ..()

/datum/blackmarket_item/misc/strange_seed
	name = "Странные семена"
	desc = "An Exotic Variety of seed that can contain anything from glow to acid."
	item = /obj/item/seeds/random

	price_min = 10
	price_max = 1000
	stock_min = 1
	stock_max = 10
	availability_prob = 70

/datum/blackmarket_item/misc/smugglers_satchel
	name = "Ранец контрабандиста"
	desc = "Легко спрятать"
	item = /obj/item/storage/backpack/satchel/flat/empty

	price_min = 75
	price_max = 100
	stock_max = 2
	availability_prob = 30

/datum/blackmarket_item/misc/emag
	name = "карта с проводами"
	desc = "Какая-то карта с микросхемами, подсоединенные проводами."
	item = /obj/item/card/emag

	price_min = 1000
	price_max = 2500
	stock_max = 1
	availability_prob = 10

/datum/blackmarket_item/misc/amude
	name = "видеокарта"
	desc = "Случайная видеокарта со склада NTS."
	item = /obj/item/mining_thing/amd

	price_min = 200
	price_max = 300
	stock_max = 5
	availability_prob = 25

/datum/blackmarket_item/misc/amude/spawn_item(loc)
	var/obj/item/mining_thing/amd/A = pick(subtypesof(/obj/item/mining_thing/amd))
	return new A(loc)

/datum/blackmarket_item/misc/rjaca
	name = "Е-МАГ"
	desc = "Е-маг"
	item = /obj/structure/closet/crate/critter/xenoqueen

	price_min = 228
	price_max = 1337
	stock_min = 0
	stock_max = 1
	availability_prob = 100

/datum/blackmarket_item/misc/rjaca/spawn_item(loc)
	if (prob(50))
		var/obj/structure/closet/crate/critter/xenoqueen/RJACA1 = ..()
		RJACA1.name = "Коробка с РЖАКОЙ"
		RJACA1.desc = "ТЫ ПОПАЛСЯ НА КЛИКБЕЙТ"
		new /mob/living/simple_animal/hostile/alien/queen/large(RJACA1)
		new /mob/living/simple_animal/hostile/alien/queen(RJACA1)
		new /mob/living/simple_animal/hostile/alien/queen(RJACA1)
		new /mob/living/simple_animal/hostile/alien/drone(RJACA1)
		new /mob/living/simple_animal/hostile/alien/drone(RJACA1)
		new /mob/living/simple_animal/hostile/alien/drone(RJACA1)
		new /mob/living/simple_animal/hostile/alien/drone(RJACA1)
		new /mob/living/simple_animal/hostile/alien(RJACA1)
		new /mob/living/simple_animal/hostile/alien(RJACA1)
		new /mob/living/simple_animal/hostile/alien(RJACA1)
		new /mob/living/simple_animal/hostile/alien(RJACA1)
		new /mob/living/simple_animal/hostile/alien/sentinel(RJACA1)
		new /mob/living/simple_animal/hostile/alien/sentinel(RJACA1)
		new /mob/living/simple_animal/hostile/alien/sentinel(RJACA1)
		new /mob/living/simple_animal/hostile/alien/sentinel(RJACA1)
		return (RJACA1)
	else
		var/obj/structure/closet/crate/critter/RJACA2 = ..()
		RJACA2.name = "Коробка с РЖАКОЙ"
		RJACA2.desc = "ТЫ ПОПАЛСЯ НА КЛИКБЕЙТ"
		new /mob/living/simple_animal/hostile/syndicate/melee/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/smg/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/shotgun/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/melee/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/smg/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/shotgun/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/smg/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/shotgun/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/melee/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/smg/space/stormtrooper(RJACA2)
		new /mob/living/simple_animal/hostile/syndicate/ranged/shotgun/space/stormtrooper(RJACA2)
		return (RJACA2)
