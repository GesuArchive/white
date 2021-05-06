// Cocoa Pod
/obj/item/seeds/cocoapod
	name = "Пачка семян какао-бобов"
	desc = "Эти семена вырастают в полноценные деревья. Кажется, они набухают."
	icon_state = "seed-cocoapod"
	species = "cocoapod"
	plantname = "Cocao Tree"
	product = /obj/item/food/grown/cocoapod
	lifespan = 20
	maturation = 5
	production = 5
	yield = 2
	instability = 20
	growthstages = 5
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "cocoapod-grow"
	icon_dead = "cocoapod-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/cocoapod/vanillapod, /obj/item/seeds/cocoapod/bungotree)
	reagents_add = list(/datum/reagent/consumable/coco = 0.25, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/cocoapod
	seed = /obj/item/seeds/cocoapod
	name = "Какао-бобы"
	desc = "Сладенько... Мммммм... шоколад."
	icon_state = "cocoapod"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("cocoa" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/creme_de_cacao

// Vanilla Pod
/obj/item/seeds/cocoapod/vanillapod
	name = "Пачка семян ванили"
	desc = "Эти семена вырастают в деревья. Они выглядят толстеющими."
	icon_state = "seed-vanillapod"
	species = "vanillapod"
	plantname = "Vanilla Tree"
	product = /obj/item/food/grown/vanillapod
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/vanilla = 0.25, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/vanillapod
	seed = /obj/item/seeds/cocoapod/vanillapod
	name = "Ваниль"
	desc = "Пряно... Вкуснятина... ваниль."
	icon_state = "vanillapod"
	foodtypes = FRUIT
	tastes = list("ваниль" = 1)
	distill_reagent = /datum/reagent/consumable/vanilla //Takes longer, but you can get even more vanilla from it.

/obj/item/seeds/cocoapod/bungotree
	name = "Пачка семян банго"
	desc = "Эти семена вырастают в деревья. Они кажутся тяжёлыми и практически идеально сферическими."
	icon_state = "seed-bungotree"
	species = "bungotree"
	plantname = "Bungo Tree"
	product = /obj/item/food/grown/bungofruit
	lifespan = 30
	maturation = 4
	yield = 3
	production = 7
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/enzyme = 0.1, /datum/reagent/consumable/nutriment = 0.1)
	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "bungotree-grow"
	icon_dead = "bungotree-dead"
	rarity = 15

/obj/item/food/grown/bungofruit
	seed = /obj/item/seeds/cocoapod/bungotree
	name = "Банго"
	desc = "Странный фрукт, жёсткая и упругая кожура, которая защищает сочную мякоть и ядовитое семечко."
	icon_state = "bungo"
	trash_type = /obj/item/food/grown/bungopit
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/bungojuice = 0)
	tastes = list("bungo" = 2, "tropical fruitiness" = 1)
	distill_reagent = null

/obj/item/food/grown/bungopit
	seed = /obj/item/seeds/cocoapod/bungotree
	name = "Семечко банго"
	icon_state = "bungopit"
	desc = "Большое семечко, способное остановить сердце взрослого человека."
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	foodtypes = TOXIC
	tastes = list("acrid bitterness" = 1)

/obj/item/food/grown/bungopit/Initialize()
	. =..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/bungotoxin, seed.potency * 0.10) //More than this will kill at too low potency
	reagents.add_reagent(/datum/reagent/consumable/nutriment, seed.potency * 0.04)
