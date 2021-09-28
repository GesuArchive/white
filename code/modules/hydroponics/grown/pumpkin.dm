// Pumpkin
/obj/item/seeds/pumpkin
	name = "Пачка семян тыквы"
	desc = "Эти семена вырастают в тыковки."
	icon_state = "seed-pumpkin"
	species = "pumpkin"
	plantname = "Pumpkin Vines"
	product = /obj/item/food/grown/pumpkin
	lifespan = 50
	endurance = 40
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "pumpkin-grow"
	icon_dead = "pumpkin-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/pumpkin/blumpkin)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.2)

/obj/item/food/grown/pumpkin
	seed = /obj/item/seeds/pumpkin
	name = "Тыква"
	desc = "Успей до полуночи!"
	icon_state = "pumpkin"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/pumpkinjuice = 0)
	wine_power = 20

/obj/item/food/grown/pumpkin/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.get_sharpness())
		user.show_message(span_notice("Вырезаю рожицу в [src]!") , MSG_VISUAL)
		new /obj/item/clothing/head/hardhat/pumpkinhead(user.loc)
		qdel(src)
		return
	else
		return ..()

// Blumpkin
/obj/item/seeds/pumpkin/blumpkin
	name = "Пачка семян синквы"
	desc = "Эти семена вырастают в синкву."
	icon_state = "seed-blumpkin"
	species = "blumpkin"
	plantname = "Blumpkin Vines"
	product = /obj/item/food/grown/blumpkin
	mutatelist = list()
	reagents_add = list(/datum/reagent/ammonia = 0.2, /datum/reagent/chlorine = 0.1, /datum/reagent/consumable/nutriment = 0.2)
	rarity = 20

/obj/item/food/grown/blumpkin
	seed = /obj/item/seeds/pumpkin/blumpkin
	name = "Синква"
	desc = "Токсины в этой тыкве просто УБИЙСТВЕННЫЕ."
	icon_state = "blumpkin"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/blumpkinjuice = 0)
	wine_power = 50
