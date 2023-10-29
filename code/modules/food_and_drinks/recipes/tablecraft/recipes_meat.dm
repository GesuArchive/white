// see code/module/crafting/table.dm

////////////////////////////////////////////////КЕБАБЫ////////////////////////////////////////////////

/datum/crafting_recipe/food/humankebab
	name = "Кебаб из человечины"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/meat/steak/plain/human = 2
	)
	result = /obj/item/food/kebab/human
	category = CAT_MEAT

/datum/crafting_recipe/food/kebab
	name = "Кебаб"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/meat/steak = 2
	)
	result = /obj/item/food/kebab/monkey
	category = CAT_MEAT

/datum/crafting_recipe/food/tofukebab
	name = "Кебаб с тофу"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/tofu = 2
	)
	result = /obj/item/food/kebab/tofu
	category = CAT_MEAT

/datum/crafting_recipe/food/tailkebab
	name = "Кебаб из хвоста ящерицы"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/organ/tail/lizard = 1
	)
	result = /obj/item/food/kebab/tail
	category = CAT_MEAT

/datum/crafting_recipe/food/fiestaskewer
	name = "Шпажка \"Фиеста\""
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/corn = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/kebab/fiesta
	category = CAT_MEAT

////////////////////////////////////////////////МОРЕПРОДУКТЫ////////////////////////////////////////////////

/datum/crafting_recipe/food/cubancarp
	name = "Кубинский карп"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/fishmeat = 1
	)
	result = /obj/item/food/cubancarp
	category = CAT_MEAT

/datum/crafting_recipe/food/fishandchips
	name = "Рыба и картофель фри"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/fishmeat = 1
	)
	result = /obj/item/food/fishandchips
	category = CAT_MEAT

/datum/crafting_recipe/food/fishfingers
	name = "Рыбные палочки"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/obj/item/food/bun = 1,
		/obj/item/food/fishmeat = 1
	)
	result = /obj/item/food/fishfingers
	category = CAT_MEAT

/datum/crafting_recipe/food/fishfry
	name = "Жаркое из рыбы"
	reqs = list(
		/obj/item/food/grown/corn = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/fishmeat = 1
	)
	result = /obj/item/food/fishfry
	category = CAT_MEAT

/datum/crafting_recipe/food/sashimi
	name = "Сашими"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/food/spidereggs = 1,
		/obj/item/food/fishmeat = 1
	)
	result = /obj/item/food/sashimi
	category = CAT_MEAT

////////////////////////////////////////////////MR SPIDER////////////////////////////////////////////////

/datum/crafting_recipe/food/spidereggsham
	name = "Ветчина из паучих яиц"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/spidereggs = 1,
		/obj/item/food/meat/cutlet/spider = 2
	)
	result = /obj/item/food/spidereggsham
	category = CAT_MEAT

////////////////////////////////////////////////MISC RECIPE's////////////////////////////////////////////////

/datum/crafting_recipe/food/cornedbeef
	name = "Солонина с капустой"
	reqs = list(
		/datum/reagent/consumable/salt = 5,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/grown/cabbage = 2
	)
	result = /obj/item/food/cornedbeef
	category = CAT_MEAT

/datum/crafting_recipe/food/bearsteak
	name = "Филе Мигравр"
	reqs = list(
		/datum/reagent/consumable/ethanol/manly_dorf = 5,
		/obj/item/food/meat/steak/bear = 1,
	)
	tool_paths = list(/obj/item/lighter)
	result = /obj/item/food/bearsteak
	category = CAT_MEAT

/datum/crafting_recipe/food/enchiladas
	name = "Энчилада"
	reqs = list(
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/tortilla = 2
	)
	result = /obj/item/food/enchiladas
	category = CAT_MEAT

/datum/crafting_recipe/food/stewedsoymeat
	name = "Тушеное соевое мясо"
	reqs = list(
		/obj/item/food/soydope = 2,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/stewedsoymeat
	category = CAT_MEAT

/datum/crafting_recipe/food/sausage
	name = "Сырая сосиска"
	reqs = list(
		/obj/item/food/raw_meatball = 1,
		/obj/item/food/meat/rawcutlet = 2
	)
	result = /obj/item/food/raw_sausage
	category = CAT_MEAT

/datum/crafting_recipe/food/nugget
	name = "Куриные наггетсы"
	reqs = list(
		/obj/item/food/meat/cutlet = 1
	)
	result = /obj/item/food/nugget
	category = CAT_MEAT

/datum/crafting_recipe/food/rawkhinkali
	name = "Сырое хинкали"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/meatball = 1
	)
	result =  /obj/item/food/rawkhinkali
	category = CAT_MEAT

/datum/crafting_recipe/food/pigblanket
	name = "Сосиска в тесте"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 1,
		/obj/item/food/meat/cutlet = 1
	)
	result = /obj/item/food/pigblanket
	category = CAT_MEAT

/datum/crafting_recipe/food/ratkebab
	name = "Мышиный кебаб"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/deadmouse = 1
	)
	result = /obj/item/food/kebab/rat
	category = CAT_MEAT

/datum/crafting_recipe/food/doubleratkebab
	name = "Двойной мышиный кебаб"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/deadmouse = 2
	)
	result = /obj/item/food/kebab/rat/double
	category = CAT_MEAT

/datum/crafting_recipe/food/ricepork
	name = "Рис и свинина"
	reqs = list(
		/obj/item/food/salad/boiledrice = 1,
		/obj/item/food/meat/cutlet = 2
	)
	result = /obj/item/food/salad/ricepork
	category = CAT_MEAT

/datum/crafting_recipe/food/ribs
	name = "Ребрышки барбекю"
	reqs = list(
		/datum/reagent/consumable/bbqsauce = 5,
		/obj/item/food/meat/steak/plain = 2,
		/obj/item/stack/rods = 2
	)
	result = /obj/item/food/bbqribs
	category = CAT_MEAT

/datum/crafting_recipe/food/meatclown
	name = "Мясной клоун"
	reqs = list(
		/obj/item/food/meat/steak/plain = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/meatclown
	category = CAT_MEAT

/datum/crafting_recipe/food/fried_chicken
	name = "Жареная курица"
	reqs = list(
		/obj/item/food/meat/slab/chicken = 1,
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/corn_starch = 5,
	)
	result = /obj/item/food/fried_chicken
	category = CAT_MEAT

/datum/crafting_recipe/food/beef_stroganoff
	name = "Бефстроганов"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/salt = 5,
		/datum/reagent/consumable/blackpepper = 5,
		/obj/item/food/grown/mushroom = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/meat/steak = 1,
	)
	result = /obj/item/food/beef_stroganoff
	category = CAT_MEAT
