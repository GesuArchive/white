/obj/item/seeds/garlic
	name = "Пачка семян чеснока"
	desc = "Пакеты очень острых семян."
	icon_state = "seed-garlic"
	species = "garlic"
	plantname = "Garlic Sprouts"
	product = /obj/item/food/grown/garlic
	yield = 6
	potency = 25
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	reagents_add = list(/datum/reagent/consumable/garlic = 0.15, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/garlic
	seed = /obj/item/seeds/garlic
	name = "Чеснок"
	desc = "Вкуснятина, но с очень вонючим запахом."
	icon_state = "garlic"
	bite_consumption_mod = 2
	tastes = list("чеснок" = 1)
	wine_power = 10
