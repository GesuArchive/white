// Tea
/obj/item/seeds/tea
	name = "Пачка семян чая асперы"
	desc = "Эти семена вырастают в чай."
	icon_state = "seed-teaaspera"
	species = "teaaspera"
	plantname = "Tea Aspera Plant"
	product = /obj/item/food/grown/tea
	lifespan = 20
	maturation = 5
	production = 5
	yield = 5
	growthstages = 5
	icon_dead = "tea-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/tea/astra)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/teapowder = 0.1)

/obj/item/food/grown/tea
	seed = /obj/item/seeds/tea
	name = "Листочки чая асперы"
	desc = "Ароматные листочки чая могут быть высушены, чтобы заварить чай."
	icon_state = "tea_aspera_leaves"
	grind_results = list(/datum/reagent/toxin/teapowder = 0)
	dry_grind = TRUE
	can_distill = FALSE

// Tea Astra
/obj/item/seeds/tea/astra
	name = "Пачка семян чая астры"
	icon_state = "seed-teaastra"
	species = "teaastra"
	plantname = "Tea Astra Plant"
	product = /obj/item/food/grown/tea/astra
	mutatelist = list()
	reagents_add = list(/datum/reagent/medicine/synaptizine = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/teapowder = 0.1)
	rarity = 20

/obj/item/food/grown/tea/astra
	seed = /obj/item/seeds/tea/astra
	name = "Листочки чая астры"
	icon_state = "tea_astra_leaves"
	grind_results = list(/datum/reagent/toxin/teapowder = 0, /datum/reagent/medicine/salglu_solution = 0)


// Coffee
/obj/item/seeds/coffee
	name = "Пачка семян кофе арабики"
	desc = "Эти семена вырастают в кусты кофе арабики."
	icon_state = "seed-coffeea"
	species = "coffeea"
	plantname = "Coffee Arabica Bush"
	product = /obj/item/food/grown/coffee
	lifespan = 30
	endurance = 20
	maturation = 5
	production = 5
	yield = 5
	instability = 20
	growthstages = 5
	icon_dead = "coffee-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/coffee/robusta)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/coffeepowder = 0.1, /datum/reagent/nitrogen = 0.05)

/obj/item/food/grown/coffee
	seed = /obj/item/seeds/coffee
	name = "Кофе арабика в зёрнах"
	desc = "Засуши их, чтобы сделать кофе."
	icon_state = "coffee_arabica"
	bite_consumption_mod = 2
	dry_grind = TRUE
	grind_results = list(/datum/reagent/toxin/coffeepowder = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/kahlua

// Coffee Robusta
/obj/item/seeds/coffee/robusta
	name = "Пачка семян кофе робуста"
	desc = "Эти семена вырастают в кусты кофе робуста."
	icon_state = "seed-coffeer"
	species = "coffeer"
	plantname = "Coffee Robusta Bush"
	product = /obj/item/food/grown/coffee/robusta
	mutatelist = list()
	reagents_add = list(/datum/reagent/medicine/ephedrine = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/toxin/coffeepowder = 0.1)
	rarity = 20

/obj/item/food/grown/coffee/robusta
	seed = /obj/item/seeds/coffee/robusta
	name = "Кофе робуста в зёрнах"
	desc = "Повышает бодрость на 37 процентов!!"
	icon_state = "coffee_robusta"
	grind_results = list(/datum/reagent/toxin/coffeepowder = 0, /datum/reagent/medicine/morphine = 0)
