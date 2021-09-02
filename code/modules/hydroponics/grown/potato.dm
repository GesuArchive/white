// Potato
/obj/item/seeds/potato
	name = "Пачка семян картофеля"
	desc = "Свари, пожарь, приготовь пюре!"
	icon_state = "seed-potato"
	species = "potato"
	plantname = "Potato Plants"
	product = /obj/item/food/grown/potato
	lifespan = 30
	maturation = 10
	production = 1
	yield = 4
	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "potato-grow"
	icon_dead = "potato-dead"
	genes = list(/datum/plant_gene/trait/battery)
	mutatelist = list(/obj/item/seeds/potato/sweet)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	graft_gene = /datum/plant_gene/trait/battery

/obj/item/food/grown/potato
	seed = /obj/item/seeds/potato
	name = "Картофель"
	desc = "Антошка! Антошка! Пошли копать картошку!"
	icon_state = "potato"
	bite_consumption = 100
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/potato_juice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/vodka

/obj/item/food/grown/potato/wedges
	name = "Картофельные дольки"
	desc = "Почти чипсы."
	icon_state = "potato_wedges"
	bite_consumption = 100


/obj/item/food/grown/potato/attackby(obj/item/W, mob/user, params)
	if(W.get_sharpness())
		to_chat(user, span_notice("Нарезаю картофель на мелкие дольки, используя [W]."))
		var/obj/item/food/grown/potato/wedges/Wedges = new /obj/item/food/grown/potato/wedges
		remove_item_from_storage(user)
		qdel(src)
		user.put_in_hands(Wedges)
	else
		return ..()


// Sweet Potato
/obj/item/seeds/potato/sweet
	name = "Пачка семян батата"
	desc = "Эти семена вырастают в батат."
	icon_state = "seed-sweetpotato"
	species = "sweetpotato"
	plantname = "Sweet Potato Plants"
	product = /obj/item/food/grown/potato/sweet
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/sugar = 0.1, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/potato/sweet
	seed = /obj/item/seeds/potato/sweet
	name = "Батат"
	desc = "Как картошка, но слаще."
	icon_state = "sweetpotato"
	distill_reagent = /datum/reagent/consumable/ethanol/sbiten
