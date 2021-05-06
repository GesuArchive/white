// Eggplant
/obj/item/seeds/eggplant
	name = "Пачка семян баклажана"
	desc = "Эти семена вырастают в фиолетовые плоды, не перепутайте с кабачками."
	icon_state = "seed-eggplant"
	species = "eggplant"
	plantname = "Eggplants"
	product = /obj/item/food/grown/eggplant
	yield = 2
	potency = 20
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "eggplant-grow"
	icon_dead = "eggplant-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/eggplant/eggy)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/eggplant
	seed = /obj/item/seeds/eggplant
	name = "Баклажан"
	desc = "Нихуя ты баклажан блять!"
	icon_state = "eggplant"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	wine_power = 20

// Egg-Plant
/obj/item/seeds/eggplant/eggy
	name = "Пачка семян яйцеплода"
	desc = "Эти семена вырастают в плоды, которые очень похожи на яйца."
	icon_state = "seed-eggy"
	species = "eggy"
	plantname = "Egg-Plants"
	product = /obj/item/food/grown/shell/eggy
	lifespan = 75
	production = 12
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/shell/eggy
	seed = /obj/item/seeds/eggplant/eggy
	name = "Яйцеплод"
	desc = "Внутри ДОЛЖНА быть курица."
	icon_state = "eggyplant"
	trash_type = /obj/item/food/egg
	bite_consumption_mod = 2
	foodtypes = MEAT
	distill_reagent = /datum/reagent/consumable/ethanol/eggnog
