
// see code/module/crafting/table.dm

////////////////////////////////////////////////PIES////////////////////////////////////////////////

/datum/crafting_recipe/food/bananacreampie
	name = "Банановый пирог со сливками"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/pie/cream
	subcategory = CAT_PIE

/datum/crafting_recipe/food/meatpie
	name = "Мясной пирог"
	reqs = list(
		/datum/reagent/consumable/blackpepper = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/steak/plain = 1
	)
	result = /obj/item/food/pie/meatpie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/tofupie
	name = "Пирог с тофу"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/tofu = 1
	)
	result = /obj/item/food/pie/tofupie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/xenopie
	name = "Ксено пирог"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/cutlet/xeno = 1
	)
	result = /obj/item/food/pie/xemeatpie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/cherrypie
	name = "Вишневый пирог"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/cherries = 1
	)
	result = /obj/item/food/pie/cherrypie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/berryclafoutis
	name = "Ягодный клафути"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/pie/berryclafoutis
	subcategory = CAT_PIE

/datum/crafting_recipe/food/bearypie
	name = "Медвежий пирог"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 1,
		/obj/item/food/meat/steak/bear = 1
	)
	result = /obj/item/food/pie/bearypie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/amanitapie
	name = "Пирог с мухоморами"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/amanita = 1
	)
	result = /obj/item/food/pie/amanita_pie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/plumppie
	name = "Пирог с толстошлемником"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1
	)
	result = /obj/item/food/pie/plump_pie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/applepie
	name = "Яблочный пирог"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/pie/applepie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/pumpkinpie
	name = "Тыквенный пирог"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/pumpkin = 1
	)
	result = /obj/item/food/pie/pumpkinpie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/goldenappletart
	name = "Торт со стружкой из золотого яблока"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple/gold = 1
	)
	result = /obj/item/food/pie/appletart
	subcategory = CAT_PIE

/datum/crafting_recipe/food/grapetart
	name = "Виноградный торт"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/grapes = 3
	)
	result = /obj/item/food/pie/grapetart
	subcategory = CAT_PIE

/datum/crafting_recipe/food/mimetart
	name = "Мимовый торт"
	always_available = FALSE
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/datum/reagent/consumable/nothing = 5
	)
	result = /obj/item/food/pie/mimetart
	subcategory = CAT_PIE

/datum/crafting_recipe/food/berrytart
	name = "Ягодный торт"
	always_available = FALSE
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 3
	)
	result = /obj/item/food/pie/berrytart
	subcategory = CAT_PIE

/datum/crafting_recipe/food/cocolavatart
	name = "Шоколадный лавовый торт"
	always_available = FALSE
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/chocolatebar = 3,
		/obj/item/slime_extract = 1
	)
	result = /obj/item/food/pie/cocolavatart
	subcategory = CAT_PIE

/datum/crafting_recipe/food/blumpkinpie
	name = "Синетыквенный пирог"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/blumpkin = 1
	)
	result = /obj/item/food/pie/blumpkinpie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/dulcedebatata
	name = "Дульсе де батата"
	reqs = list(
		/datum/reagent/consumable/vanilla = 5,
		/datum/reagent/water = 5,
		/obj/item/food/grown/potato/sweet = 2
	)
	result = /obj/item/food/pie/dulcedebatata
	subcategory = CAT_PIE

/datum/crafting_recipe/food/frostypie
	name = "Ледяной пирог"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/bluecherries = 1
	)
	result = /obj/item/food/pie/frostypie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/baklava
	name = "Пахлава"
	reqs = list(
		/obj/item/food/butter = 2,
		/obj/item/food/tortilla = 4,
		/obj/item/seeds/wheat/oat = 4
	)
	result = /obj/item/food/pie/baklava
	subcategory = CAT_PIE
