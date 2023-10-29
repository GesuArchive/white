// Corn
/obj/item/seeds/corn
	name = "Пачка семян кукурузы"
	desc = "Жёлтые, но не золото"
	icon_state = "seed-corn"
	species = "corn"
	plantname = "Corn Stalks"
	product = /obj/item/food/grown/corn
	maturation = 8
	potency = 20
	instability = 50 //Corn used to be wheatgrass, before being cultivated for generations.
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "corn-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "corn-dead" // Same for the dead icon
	mutatelist = list(/obj/item/seeds/corn/snapcorn)
	reagents_add = list(/datum/reagent/consumable/cornoil = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/corn
	seed = /obj/item/seeds/corn
	name = "початок кукурузы"
	desc = "Сейчас бы маслица..."
	icon_state = "corn"
	microwaved_type = /obj/item/food/popcorn
	trash_type = /obj/item/grown/corncob
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/corn_starch = 0)
	tastes = list("corn" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/whiskey

/obj/item/food/grown/corn/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/oven_baked_corn, rand(15 SECONDS, 35 SECONDS), TRUE, TRUE)
/obj/item/grown/corncob
	name = "Огрызок кукурузы"
	desc = "Напоминает о былом вкусе."
	icon_state = "corncob"
	inhand_icon_state = "corncob"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	grind_results = list(/datum/reagent/cellulose = 10) //really partially hemicellulose

/obj/item/grown/corncob/attackby(obj/item/grown/W, mob/user, params)
	if(W.get_sharpness())
		to_chat(user, span_notice("Использую [W], чтобы сделать трубу из початка кукурузы!"))
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe (user.loc)
		qdel(src)
	else
		return ..()

// Snapcorn
/obj/item/seeds/corn/snapcorn
	name = "Пачка семян хруструзы"
	desc = "Очень громко хрустит!"
	icon_state = "seed-snapcorn"
	species = "snapcorn"
	plantname = "Snapcorn Stalks"
	product = /obj/item/grown/snapcorn
	mutatelist = list()
	rarity = 10

/obj/item/grown/snapcorn
	seed = /obj/item/seeds/corn/snapcorn
	name = "Хрусткорн"
	desc = "Початок с хрустящими семенами."
	icon_state = "snapcorn"
	inhand_icon_state = "corncob"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/snap_pops = 1

/obj/item/grown/snapcorn/add_juice()
	..()
	snap_pops = max(round(seed.potency/8), 1)

/obj/item/grown/snapcorn/attack_self(mob/user)
	..()
	to_chat(user, span_notice("Достаю хрустяшки из початка."))
	var/obj/item/toy/snappop/S = new /obj/item/toy/snappop(user.loc)
	if(ishuman(user))
		user.put_in_hands(S)
	snap_pops -= 1
	if(!snap_pops)
		new /obj/item/grown/corncob(user.loc)
		qdel(src)
