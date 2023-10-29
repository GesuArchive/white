// Grass
/obj/item/seeds/grass
	name = "Пачка семян травы"
	desc = "Эти семена вырастают в траву. Вкусно!"
	icon_state = "seed-grass"
	species = "grass"
	plantname = "Grass"
	product = /obj/item/food/grown/grass
	lifespan = 40
	endurance = 40
	maturation = 2
	production = 5
	yield = 5
	instability = 10
	growthstages = 2
	icon_grow = "grass-grow"
	icon_dead = "grass-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/oxygenerator)
	mutatelist = list(/obj/item/seeds/grass/carpet, /obj/item/seeds/grass/fairy)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.02, /datum/reagent/hydrogen = 0.05)

/obj/item/food/grown/grass
	seed = /obj/item/seeds/grass
	name = "Трава"
	desc = "Зелёная и пышная."
	icon_state = "grassclump"
	bite_consumption_mod = 2
	var/stacktype = /obj/item/stack/tile/grass
	var/tile_coefficient = 0.02 // 1/50
	wine_power = 15

/obj/item/food/grown/grass/attack_self(mob/user)
	to_chat(user, span_notice("Заготавливаю искусственный газон."))
	var/grassAmt = 1 + round(seed.potency * tile_coefficient) // The grass we're holding
	for(var/obj/item/food/grown/grass/G in user.loc) // The grass on the floor
		if(G.type != type)
			continue
		grassAmt += 1 + round(G.seed.potency * tile_coefficient)
		qdel(G)
	new stacktype(user.drop_location(), grassAmt)
	qdel(src)

//Fairygrass
/obj/item/seeds/grass/fairy
	name = "Пачка семянволшебной травы"
	desc = "Эти семена вырастают в загадочную траву."
	icon_state = "seed-fairygrass"
	species = "fairygrass"
	plantname = "Fairygrass"
	product = /obj/item/food/grown/grass/fairy
	icon_grow = "fairygrass-grow"
	icon_dead = "fairygrass-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/blue, /datum/plant_gene/trait/oxygenerator)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.02, /datum/reagent/hydrogen = 0.05, /datum/reagent/drug/space_drugs = 0.15)
	graft_gene = /datum/plant_gene/trait/glow/blue

/obj/item/food/grown/grass/fairy
	seed = /obj/item/seeds/grass/fairy
	name = "Волшебная трава"
	desc = "Синяя, светится, слегка пахнет грибами."
	icon_state = "fairygrassclump"
	stacktype = /obj/item/stack/tile/fairygrass

// Carpet
/obj/item/seeds/grass/carpet
	name = "Пачка семян ковра"
	desc = "Эти семена вырастают в элитный ковёр, который можно положить вместо плитки."
	icon_state = "seed-carpet"
	species = "carpet"
	plantname = "Carpet"
	product = /obj/item/food/grown/grass/carpet
	mutatelist = list()
	rarity = 10

/obj/item/food/grown/grass/carpet
	seed = /obj/item/seeds/grass/carpet
	name = "Ковёр"
	desc = "Чёрная магия текстильной промышленности."
	icon_state = "carpetclump"
	stacktype = /obj/item/stack/tile/carpet
	can_distill = FALSE
