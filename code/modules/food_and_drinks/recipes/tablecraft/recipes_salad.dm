
// see code/module/crafting/table.dm

////////////////////////////////////////////////SALADS////////////////////////////////////////////////

/datum/crafting_recipe/food/herbsalad
	name = "Травяной салат"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/ambrosia/vulgaris = 3,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/salad/herbsalad
	category = CAT_SALAD

/datum/crafting_recipe/food/aesirsalad
	name = "Салат Асов"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/ambrosia/deus = 3,
		/obj/item/food/grown/apple/gold = 1
	)
	result = /obj/item/food/salad/aesirsalad
	category = CAT_SALAD

/datum/crafting_recipe/food/validsalad
	name = "Валидный салат"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/ambrosia/vulgaris = 3,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/salad/validsalad
	category = CAT_SALAD

/datum/crafting_recipe/food/monkeysdelight
	name = "Обезьяний восторг"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/monkeycube = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/soup/monkeysdelight
	category = CAT_SALAD


/datum/crafting_recipe/food/fruitsalad
	name = "Фруктовый салат"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/grown/grapes = 1,
		/obj/item/food/grown/citrus/orange = 1,
		/obj/item/food/watermelonslice = 2

	)
	result = /obj/item/food/salad/fruit
	category = CAT_SALAD

/datum/crafting_recipe/food/junglesalad
	name = "Салат \"Джунгли\""
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/grown/grapes = 1,
		/obj/item/food/grown/banana = 2,
		/obj/item/food/watermelonslice = 2

	)
	result = /obj/item/food/salad/jungle
	category = CAT_SALAD

/datum/crafting_recipe/food/citrusdelight
	name = "Цитрусовый восторг"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/citrus/lime = 1,
		/obj/item/food/grown/citrus/lemon = 1,
		/obj/item/food/grown/citrus/orange = 1

	)
	result = /obj/item/food/salad/citrusdelight
	category = CAT_SALAD

/datum/crafting_recipe/food/edensalad
	name = "Салат Эдема"
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/food/grown/ambrosia/vulgaris = 1,
		/obj/item/food/grown/ambrosia/deus = 1,
		/obj/item/food/grown/ambrosia/gaia = 1,
		/obj/item/food/grown/peace = 1
	)
	result = /obj/item/food/salad/edensalad
	category = CAT_SALAD

/datum/crafting_recipe/food/melonfruitbowl
	name ="Фруктовая арбузная миска"
	reqs = list(
		/obj/item/food/grown/watermelon = 1,
		/obj/item/food/grown/apple = 1,
		/obj/item/food/grown/citrus/orange = 1,
		/obj/item/food/grown/citrus/lemon = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/food/grown/ambrosia = 1
	)
	result = /obj/item/food/salad/melonfruitbowl
	category = CAT_SALAD

/datum/crafting_recipe/food/gumbo
	name = "Черноглазое гамбо"
	reqs = list(
		/obj/item/food/salad/boiledrice = 1,
		/obj/item/food/grown/peas = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/meat/cutlet = 1
	)
	result = /obj/item/food/salad/gumbo
	category = CAT_SALAD

