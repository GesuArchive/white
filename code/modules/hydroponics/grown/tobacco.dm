// Tobacco
/obj/item/seeds/tobacco
	name = "Пачка семян табака"
	desc = "Эти семена вырастают в табак."
	icon_state = "seed-tobacco"
	species = "tobacco"
	plantname = "Tobacco Plant"
	product = /obj/item/food/grown/tobacco
	lifespan = 20
	maturation = 5
	production = 5
	yield = 10
	growthstages = 3
	icon_dead = "tobacco-dead"
	mutatelist = list(/obj/item/seeds/tobacco/space)
	reagents_add = list(/datum/reagent/drug/nicotine = 0.03, /datum/reagent/consumable/nutriment = 0.03)

/obj/item/food/grown/tobacco
	seed = /obj/item/seeds/tobacco
	name = "Листья табака"
	desc = "Просуши их, чтобы немного подымить."
	icon_state = "tobacco_leaves"
	distill_reagent = /datum/reagent/consumable/ethanol/creme_de_menthe //Menthol, I guess.

// Space Tobacco
/obj/item/seeds/tobacco/space
	name = "Пачка семян космотабака"
	desc = "Эти семена вырастают в космотабак."
	icon_state = "seed-stobacco"
	species = "stobacco"
	plantname = "Space Tobacco Plant"
	product = /obj/item/food/grown/tobacco/space
	mutatelist = list()
	reagents_add = list(/datum/reagent/medicine/salbutamol = 0.05, /datum/reagent/drug/nicotine = 0.08, /datum/reagent/consumable/nutriment = 0.03)
	rarity = 20

/obj/item/food/grown/tobacco/space
	seed = /obj/item/seeds/tobacco/space
	name = "Листья космотабака"
	desc = "Просуши их, чтобы космодымить."
	icon_state = "stobacco_leaves"
	distill_reagent = null
	wine_power = 50
