//Note for this file: All the raw pastries should not have microwave results, use baking instead. All cooked products can use baking, but should also support a microwave.

/obj/item/food/dough
	name = "тесто"
	desc = "Кусок теста."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "dough"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6)
	tastes = list("тесто" = 1)
	foodtypes = GRAIN

/obj/item/food/dough/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/bread/plain, rand(30 SECONDS, 45 SECONDS), TRUE, TRUE)

// Dough + rolling pin = flat dough
/obj/item/food/dough/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, /obj/item/food/flatdough, 1, 30)

/obj/item/food/flatdough
	name = "плоское тесто"
	desc = "Раскатанное тесто."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "flat dough"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6)
	tastes = list("тесто" = 1)
	foodtypes = GRAIN

/obj/item/food/flatdough/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizzabread, rand(30 SECONDS, 45 SECONDS), TRUE, TRUE)

// sliceable into 3xdoughslices
/obj/item/food/flatdough/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/doughslice, 3, 30)

/obj/item/food/pizzabread
	name = "тесто для пиццы"
	desc = "Добавь ингридиентов для приготовления пиццы."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "pizzabread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 7)
	tastes = list("хлеб" = 1)
	foodtypes = GRAIN
	burns_in_oven = TRUE

/obj/item/food/pizzabread/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/pizza/margherita, CUSTOM_INGREDIENT_ICON_SCATTER, max_ingredients = 12)

/obj/item/food/doughslice
	name = "кусочек теста"
	desc = "Кусочек теста. Можно приготовить булку."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "doughslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("тесто" = 1)
	foodtypes = GRAIN

/obj/item/food/doughslice/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/bun, rand(20 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/doughslice/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/bait/doughball, 5, 30)
/obj/item/food/bun
	name = "булочка"
	desc = "Основа для любого уважающего себя бургера"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "bun"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("булочка" = 1) // the bun tastes of bun.
	foodtypes = GRAIN
	burns_in_oven = TRUE

/obj/item/food/bun/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/customizable_reagent_holder, /obj/item/food/burger/empty, CUSTOM_INGREDIENT_ICON_STACKPLUSTOP)

/obj/item/food/cakebatter
	name = "тесто для торта"
	desc = "Приготовьте, чтобы получить торт."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "cakebatter"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9)
	tastes = list("кляр" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/cakebatter/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/cake/plain, rand(70 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/cakebatter/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, /obj/item/food/piedough, 1, 30)

/obj/item/food/piedough
	name = "тесто для пирога"
	desc = "Приготовьте, чтобы получить пирог."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "piedough"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9)
	tastes = list("тесто" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/piedough/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pie/plain, rand(30 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/piedough/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/rawpastrybase, 3, 30)

/obj/item/food/rawpastrybase
	name = "сырое сладкое тесто"
	desc = "Необходимо приготовить перед использованием."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawpastrybase"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("сырое тесто" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/rawpastrybase/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pastrybase, rand(20 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/pastrybase
	name = "сладкое тесто"
	desc = "Основа для любого уважающего себя кондитерского изделия."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "pastrybase"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("тесто" = 1)
	foodtypes = GRAIN | DAIRY
	burns_in_oven = TRUE
