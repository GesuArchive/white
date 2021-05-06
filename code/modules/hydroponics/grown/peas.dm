// Finally, peas. Base plant.
/obj/item/seeds/peas
	name = "Пачка семян стручкового гороха"
	desc = "Из этих семян вырастает богатый витаминами горох!"
	icon_state = "seed-peas"
	species = "peas"
	plantname = "Pea Vines"
	product = /obj/item/food/grown/peas
	maturation = 3
	potency = 25
	instability = 15
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "peas-grow"
	icon_dead = "peas-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/peas/laugh)
	reagents_add = list (/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/water = 0.05)

/obj/item/food/grown/peas
	seed = /obj/item/seeds/peas
	name = "Горох"
	desc = "Что-то меня пучит..."
	icon_state = "peas"
	bite_consumption_mod = 1
	foodtypes = VEGETABLES
	tastes = list ("peas" = 1, "chalky saltiness" = 1)
	wine_power = 50
	wine_flavor = "what is, distressingly, fermented peas."

// Laughin' Peas
/obj/item/seeds/peas/laugh
	name = "Пачка семян смехороха"
	desc = "Эти семена издают мягкое фиолетовое свечение и пахнут ржомбой... скоро они вырастут в смехорох."
	icon_state = "seed-laughpeas"
	species = "laughpeas"
	plantname = "Laughin' Peas"
	product = /obj/item/food/grown/laugh
	maturation = 7
	potency = 10
	yield = 7
	production = 5
	growthstages = 3
	icon_grow = "laughpeas-grow"
	icon_dead = "laughpeas-dead"
	genes = list (/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/purple, /datum/plant_gene/trait/plant_laughter)
	mutatelist = list (/obj/item/seeds/peas/laugh/peace)
	reagents_add = list (/datum/reagent/consumable/laughter = 0.05, /datum/reagent/consumable/sugar = 0.05, /datum/reagent/consumable/nutriment = 0.07)
	rarity = 25 //It actually might make Central Command Officials loosen up a smidge, eh?
	graft_gene = /datum/plant_gene/trait/plant_laughter

/obj/item/food/grown/laugh
	seed = /obj/item/seeds/peas/laugh
	name = "Стручок смехороха"
	desc = "Вот это смешинка! Эта штука умеет поднять настроение!"
	icon_state = "laughpeas"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list (/datum/reagent/consumable/laughsyrup = 0)
	tastes = list ("a prancing rabbit" = 1) //Vib Ribbon sends her regards.. wherever she is.
	wine_power = 90
	wine_flavor = "a vector-graphic rabbit dancing on your tongue"

// World Peas - Peace at last, peace at last...
/obj/item/seeds/peas/laugh/peace
	name = "Пачка семян мирового гороха"
	desc = "Эти крупные семена испускают успокаивающее голубое свечение..."
	icon_state = "seed-worldpeas"
	species = "worldpeas"
	plantname = "World Peas"
	product = /obj/item/food/grown/peace
	maturation = 20
	potency = 75
	yield = 1
	production = 10
	instability = 45 //The world is a very unstable place. Constantly changing.
	growthstages = 3
	icon_grow = "worldpeas-grow"
	icon_dead = "worldpeas-dead"
	genes = list (/datum/plant_gene/trait/glow/blue)
	reagents_add = list (/datum/reagent/pax = 0.1, /datum/reagent/drug/happiness = 0.1, /datum/reagent/consumable/nutriment = 0.15)
	rarity = 50 // This absolutely will make even the most hardened Syndicate Operators relax.
	graft_gene = /datum/plant_gene/trait/glow/blue

/obj/item/food/grown/peace
	seed = /obj/item/seeds/peas/laugh/peace
	name = "Гроздь мировых горошин"
	desc = "Растение, выведенное благодаря продвинутой генной инженерии. Поговаривают, что он приносит мир любому, кто его употребляет. Учёные называют его 'Мир Во Всем Мире'." //напоследок... мировой горох.
	icon_state = "worldpeas"
	bite_consumption_mod = 4
	foodtypes = VEGETABLES
	tastes = list ("numbing tranquility" = 2, "warmth" = 1)
	wine_power = 100
	wine_flavor = "mind-numbing peace and warmth"
