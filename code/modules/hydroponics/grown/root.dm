// Carrot
/obj/item/seeds/carrot
	name = "Пачка семян моркови"
	desc = "Эти семена вырастают в морковь."
	icon_state = "seed-carrot"
	species = "carrot"
	plantname = "Carrots"
	product = /obj/item/food/grown/carrot
	maturation = 10
	production = 1
	yield = 5
	instability = 15
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	mutatelist = list(/obj/item/seeds/carrot/parsnip)
	reagents_add = list(/datum/reagent/medicine/oculine = 0.25, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/carrot
	seed = /obj/item/seeds/carrot
	name = "Морковь"
	desc = "Разве ты кролик?!"
	icon_state = "carrot"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/carrotjuice = 0)
	wine_power = 30

/obj/item/food/grown/carrot/attackby(obj/item/I, mob/user, params)
	if(I.get_sharpness())
		to_chat(user, span_notice("Затачиваю морковь в заточку при помощи[I]."))
		var/obj/item/kitchen/knife/shiv/carrot/Shiv = new /obj/item/kitchen/knife/shiv/carrot
		remove_item_from_storage(user)
		qdel(src)
		user.put_in_hands(Shiv)
	else
		return ..()

// Parsnip
/obj/item/seeds/carrot/parsnip
	name = "Пачка семян пастернака"
	desc = "Эти семена вырастают в пастернак."
	icon_state = "seed-parsnip"
	species = "parsnip"
	plantname = "Parsnip"
	product = /obj/item/food/grown/parsnip
	icon_dead = "carrot-dead"
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/parsnip
	seed = /obj/item/seeds/carrot/parsnip
	name = "Пастернак"
	desc = "Очень тесно связан с морковью."
	icon_state = "parsnip"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/parsnipjuice = 0)
	wine_power = 35


// White-Beet
/obj/item/seeds/whitebeet
	name = "Упаковка семян сахарной свёклы"
	desc = "Эти семена вырастают в сахарную свёклу."
	icon_state = "seed-whitebeet"
	species = "whitebeet"
	plantname = "White-Beet Plants"
	product = /obj/item/food/grown/whitebeet
	lifespan = 60
	endurance = 50
	yield = 5
	instability = 10
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"
	mutatelist = list(/obj/item/seeds/redbeet)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/sugar = 0.2, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/whitebeet
	seed = /obj/item/seeds/whitebeet
	name = "Сахарная свёкла"
	desc = "Свекла или свёкла?"
	icon_state = "whitebeet"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 40

// Red Beet
/obj/item/seeds/redbeet
	name = "Пачка семян свёклы"
	desc = "Эти семена вырастают в свёклу."
	icon_state = "seed-redbeet"
	species = "redbeet"
	plantname = "Red-Beet Plants"
	product = /obj/item/food/grown/redbeet
	lifespan = 60
	endurance = 50
	yield = 6
	instability = 15
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"
	genes = list(/datum/plant_gene/trait/maxchem)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05)
	graft_gene = /datum/plant_gene/trait/maxchem

/obj/item/food/grown/redbeet
	seed = /obj/item/seeds/redbeet
	name = "красный beet"
	desc = "Красненькая, но не такая сладкая."
	icon_state = "redbeet"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 60
