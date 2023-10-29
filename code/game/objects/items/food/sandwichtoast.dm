/obj/item/food/sandwich
	name = "сэндвич"
	desc = "Грандиозное творение из мяса, сыра, хлеба и нескольких листьев салата! Артуру Денту бы понравилось это."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "sandwich"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("мясо" = 2, "сыр" = 1, "хлеб" = 2, "салат" = 1)
	foodtypes = GRAIN | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/grilled_cheese_sandwich
	name = "сэндвич с жареным сыром"
	desc = "Теплый сэндвич, который идеально сочетается с томатным супом."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "toastedsandwich"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/carbon = 4)
	tastes = list("тост" = 2, "сыр" = 3, "масло" = 1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/cheese_sandwich
	name = "сырный сэндвич"
	desc = "Легкая закуска ...но что если приготовить его на гриле?"
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "sandwich"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("хлеб" = 1, "сыр" = 1)
	foodtypes = GRAIN | DAIRY
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheese_sandwich/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_cheese_sandwich, rand(30 SECONDS, 60 SECONDS), TRUE)

/obj/item/food/jellysandwich
	name = "желейный сэндвич"
	desc = "Немного арахисового масла было бы кстати..."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellysandwich"
	trash_type = /obj/item/trash/plate
	bite_consumption = 3
	tastes = list("хлеб" = 1, "желе" =1)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/jellysandwich/slime
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/slimejelly = 10, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes  = GRAIN | TOXIC

/obj/item/food/jellysandwich/cherry
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/cherryjelly = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/notasandwich
	name = "не-сэндвич"
	desc = "Кажется, что-то здесь не так, но вы не можете понять, что именно. Может быть, дело в его усах."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "notasandwich"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("ничего подозрительного" = 1)
	foodtypes = GRAIN | GROSS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/griddle_toast
	name = "Поджаренный тост"
	desc = "Толстый кусок хлеба, обжаренный на гриле до золотистой корочки."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "griddle_toast"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("тост" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE
	slot_flags = ITEM_SLOT_MASK






