/obj/item/food/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "sandwich"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("мясо" = 2, "сыр" = 1, "хлеб" = 2, "салат" = 1)
	foodtypes = GRAIN | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/grilled_cheese_sandwich
	name = "grilled cheese sandwich"
	desc = "A warm, melty sandwich that goes perfectly with tomato soup."
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
	name = "cheese sandwich"
	desc = "A light snack for a warm day. ...but what if you grilled it?"
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
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
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
	name = "not-a-sandwich"
	desc = "Something seems to be wrong with this, you can't quite figure what. Maybe it's his moustache."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "notasandwich"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("ничего подозрительного" = 1)
	foodtypes = GRAIN | GROSS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/jelliedtoast
	name = "jellied toast"
	desc = "A slice of toast covered with delicious jam."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "jellytoast"
	trash_type = /obj/item/trash/plate
	bite_consumption = 3
	tastes = list("тост" = 1, "желе" =1)
	foodtypes = GRAIN | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/jelliedtoast/cherry
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/cherryjelly = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes = GRAIN | FRUIT | SUGAR | BREAKFAST

/obj/item/food/jelliedtoast/slime
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/slimejelly = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	foodtypes = GRAIN | TOXIC | SUGAR | BREAKFAST

/obj/item/food/butteredtoast
	name = "buttered toast"
	desc = "Butter lightly spread over a piece of toast."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "butteredtoast"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("масло" = 1, "тост" = 1)
	foodtypes = GRAIN | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/twobread
	name = "two bread"
	desc = "This seems awfully bitter."
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "twobread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("хлеб" = 2)
	foodtypes = GRAIN
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
