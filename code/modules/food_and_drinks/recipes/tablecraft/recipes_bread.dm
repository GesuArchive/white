
// see code/module/crafting/table.dm

////////////////////////////////////////////////BREAD////////////////////////////////////////////////

/datum/crafting_recipe/food/baguette
	name = "Багет"
	time = 40
	reqs = list(/datum/reagent/consumable/salt = 1,
				/datum/reagent/consumable/blackpepper = 1,
				/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/baguette
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/slimetoast
	name = "Слаймовый тост"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/breadslice/plain = 1
	)
	result = /obj/item/food/bread/jelliedtoast/slime
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/jelliedyoast
	name = "Желейный тост"
	reqs = list(
		/datum/reagent/consumable/cherryjelly = 5,
		/obj/item/food/breadslice/plain = 1
	)
	result = /obj/item/food/bread/jelliedtoast/cherry
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butteredtoast
	name = "Тост с маслом"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/bread/butteredtoast
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/twobread
	name = "Два хлеба"
	reqs = list(
		/datum/reagent/consumable/ethanol/wine = 5,
		/obj/item/food/breadslice/plain = 2
	)
	result = /obj/item/food/bread/twobread
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/meatbread
	name = "Мясной рулет"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/plain = 3,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/bread/meat
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/xenomeatbread
	name = "Хлеб с мясом чужого"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/xeno = 3,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/bread/xenomeat
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/spidermeatbread
	name = "Хлеб с паучьим мясом"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/spider = 3,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/bread/spidermeat
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/banananutbread
	name = "Банановый хлеб"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/boiledegg = 3,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/bread/banana
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/tofubread
	name = "Хлеб тофу"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/tofu = 3,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/bread/tofu
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/creamcheesebread
	name = "Хлеб со сливочным сыром"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/bread/creamcheese
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/mimanabread
	name = "Мимановский хлеб"
	reqs = list(
		/datum/reagent/consumable/soymilk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/tofu = 3,
		/obj/item/food/grown/banana/mime = 1
	)
	result = /obj/item/food/bread/mimana
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/garlicbread
	name = "Чесночный хлеб"
	time = 40
	reqs = list(/obj/item/food/grown/garlic = 1,
				/obj/item/food/breadslice/plain = 1,
				/obj/item/food/butter = 1
	)
	result = /obj/item/food/garlicbread
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butterbiscuit
	name = "Бисквит с маслом"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/butterbiscuit
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butterdog
	name = "Масло-дог"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 3,
		)
	result = /obj/item/food/butterdog
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/moldybread // why would you make this?
	name = "Заплесневелый хлеб"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/obj/item/food/grown/mushroom/amanita = 1
		)
	result = /obj/item/food/breadslice/moldy
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/breadcat
	name = "Хлебокот"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/organ/ears/cat = 1,
		/obj/item/organ/tail/cat = 1,
		/obj/item/food/meat/slab = 3,
		/datum/reagent/blood = 50,
		/datum/reagent/medicine/strange_reagent = 5
	)
	result = /mob/living/simple_animal/pet/cat/breadcat
	subcategory = CAT_BREAD
