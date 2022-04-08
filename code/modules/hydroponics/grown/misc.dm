// Starthistle
/obj/item/seeds/starthistle
	name = "Пачка семян звездополоха"
	desc = "Очень надоедливый и крепкий сорняк, часто появляется меж трещин стоящий кораблей."
	icon_state = "seed-starthistle"
	species = "starthistle"
	plantname = "Starthistle"
	lifespan = 70
	endurance = 50 // damm pesky weeds
	maturation = 5
	production = 1
	yield = 2
	potency = 10
	instability = 35
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	mutatelist = list(/obj/item/seeds/starthistle/corpse_flower, /obj/item/seeds/galaxythistle)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/seeds/starthistle/harvest(mob/user)
	var/obj/machinery/hydroponics/parent = loc
	var/seed_count = yield
	if(prob(getYield() * 20))
		seed_count++
		var/output_loc = parent.Adjacent(user) ? user.loc : parent.loc
		for(var/i in 1 to seed_count)
			var/obj/item/seeds/starthistle/harvestseeds = Copy()
			harvestseeds.forceMove(output_loc)

	parent.update_tray()

// Corpse flower
/obj/item/seeds/starthistle/corpse_flower
	name = "Пачка семян трупоцвета"
	desc = "Этот вид растения издаёт очень гнусный и вонючий запах. Запах перестаёт производится в проблемных атмосферных условиях."
	icon_state = "seed-corpse-flower"
	species = "corpse-flower"
	plantname = "Corpse flower"
	production = 2
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	genes = list()
	mutatelist = list()
	reagents_add = list(/datum/reagent/toxin/formaldehyde = 0.1)

/obj/item/seeds/starthistle/corpse_flower/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

/obj/item/seeds/starthistle/corpse_flower/process(delta_time)
	var/obj/machinery/hydroponics/parent = loc
	if(parent.age < maturation) // Start a little before it blooms
		return

	var/turf/open/T = get_turf(parent)
	if(abs(ONE_ATMOSPHERE - T.return_air().return_pressure()) > (potency/10 + 10)) // clouds can begin showing at around 50-60 potency in standard atmos
		return

	var/datum/gas_mixture/stank = new
	stank.set_moles(GAS_MIASMA, (yield + 6)*3.5*MIASMA_CORPSE_MOLES*delta_time) // this process is only being called about 2/7 as much as corpses so this is 12-32 times a corpses
	stank.set_temperature(T20C) // without this the room would eventually freeze and miasma mining would be easier
	T.assume_air(stank)
	T.air_update_turf()

//Galaxy Thistle
/obj/item/seeds/galaxythistle
	name = "Пачка семян космополоха"
	desc = "Необычный вид сорняков, который, как предполагают, мутировал из обычного чертополоха. Содержит вещества, который могут починить больную печень."
	icon_state = "seed-galaxythistle"
	species = "galaxythistle"
	plantname = "Galaxythistle"
	product = /obj/item/food/grown/galaxythistle
	lifespan = 70
	endurance = 40
	maturation = 3
	production = 2
	yield = 2
	potency = 25
	instability = 35
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy, /datum/plant_gene/trait/invasive)
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/silibinin = 0.1)
	graft_gene = /datum/plant_gene/trait/invasive

/obj/item/seeds/galaxythistle/Initialize(mapload,nogenes)
	. = ..()
	if(!nogenes)
		unset_mutability(/datum/plant_gene/trait/invasive, PLANT_GENE_REMOVABLE)

/obj/item/food/grown/galaxythistle
	seed = /obj/item/seeds/galaxythistle
	name = "Головка космополоха"
	desc = "Колючая гроздь цветов, напоминающая о высоких горах."
	icon_state = "galaxythistle"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	wine_power = 35
	tastes = list("thistle" = 2, "artichoke" = 1)

// Cabbage
/obj/item/seeds/cabbage
	name = "Пачка семян капусты"
	desc = "Эти семена вырастают в кочан капусты."
	icon_state = "seed-cabbage"
	species = "cabbage"
	plantname = "Cabbages"
	product = /obj/item/food/grown/cabbage
	lifespan = 50
	endurance = 25
	maturation = 3
	production = 5
	yield = 4
	instability = 10
	growthstages = 1
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/replicapod)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	seed_flags = null

/obj/item/food/grown/cabbage
	seed = /obj/item/seeds/cabbage
	name = "Капуста"
	desc = "А где заяц?"
	icon_state = "cabbage"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 20

// Sugarcane
/obj/item/seeds/sugarcane
	name = "Пачка семян сахарного тростника"
	desc = "Эти семена вырастают в сахарный тростник."
	icon_state = "seed-sugarcane"
	species = "sugarcane"
	plantname = "Sugarcane"
	product = /obj/item/food/grown/sugarcane
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 60
	endurance = 50
	maturation = 3
	yield = 4
	instability = 15
	growthstages = 3
	reagents_add = list(/datum/reagent/consumable/sugar = 0.25)
	mutatelist = list(/obj/item/seeds/bamboo)

/obj/item/food/grown/sugarcane
	seed = /obj/item/seeds/sugarcane
	name = "Сахарный тростник"
	desc = "Сахар в его натуральном проявлении."
	icon_state = "sugarcane"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | SUGAR
	distill_reagent = /datum/reagent/consumable/ethanol/rum

// Gatfruit
/obj/item/seeds/gatfruit
	name = "Пачка семян револыни"
	desc = "Эти семена вырастают в револьвер .357 калибра."
	icon_state = "seed-gatfruit"
	species = "gatfruit"
	plantname = "Gatfruit Tree"
	product = /obj/item/food/grown/shell/gatfruit
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 20
	endurance = 20
	maturation = 40
	production = 10
	yield = 2
	potency = 60
	growthstages = 2
	rarity = 60 // Obtainable only with xenobio+superluck.
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	reagents_add = list(/datum/reagent/sulfur = 0.1, /datum/reagent/carbon = 0.1, /datum/reagent/nitrogen = 0.07, /datum/reagent/potassium = 0.05)

/obj/item/food/grown/shell/gatfruit
	seed = /obj/item/seeds/gatfruit
	name = "Револынь"
	desc = "Пахнет свежим выстрелом."
	icon_state = "gatfruit"
	trash_type = /obj/item/gun/ballistic/revolver
	bite_consumption_mod = 2
	foodtypes = FRUIT
	tastes = list("gunpowder" = 1)
	wine_power = 90 //It burns going down, too.

//Cherry Bombs
/obj/item/seeds/cherry/bomb
	name = "Пачка косточек бомбишни"
	desc = "При их виде кровь в жилах стынет..."
	icon_state = "seed-cherry_bomb"
	species = "cherry_bomb"
	plantname = "Cherry Bomb Tree"
	product = /obj/item/food/grown/cherry_bomb
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.1, /datum/reagent/gunpowder = 0.7)
	rarity = 60 //See above

/obj/item/food/grown/cherry_bomb
	name = "Бомбишня"
	desc = "Кабум?."
	icon_state = "cherry_bomb"
	seed = /obj/item/seeds/cherry/bomb
	bite_consumption_mod = 2
	max_volume = 125 //Gives enough room for the gunpowder at max potency
	max_integrity = 40
	wine_power = 80

/obj/item/food/grown/cherry_bomb/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] выдёргивает стебель [src]!") , span_userdanger("Выдираю стебель из [src], начинается громкое шипение!"))
	log_bomber(user, "primed a", src, "for detonation")
	detonate()

/obj/item/food/grown/cherry_bomb/deconstruct(disassembled = TRUE)
	if(!disassembled)
		detonate()
	if(!QDELETED(src))
		qdel(src)

/obj/item/food/grown/cherry_bomb/ex_act(severity)
	qdel(src) //Ensuring that it's deleted by its own explosion. Also prevents mass chain reaction with piles of cherry bombs

/obj/item/food/grown/cherry_bomb/proc/detonate(mob/living/lanced_by)
	icon_state = "cherry_bomb_lit"
	playsound(src, 'sound/effects/fuse.ogg', seed.potency, FALSE)
	reagents.chem_temp = 1000 //Sets off the gunpowder
	reagents.handle_reactions()

// aloe
/obj/item/seeds/aloe
	name = "Пачка семян алоэ"
	desc = "Эти семена вырастают в алоэ."
	icon_state = "seed-aloe"
	species = "aloe"
	plantname = "Aloe"
	product = /obj/item/food/grown/aloe
	lifespan = 60
	endurance = 25
	maturation = 4
	production = 4
	yield = 6
	growthstages = 5
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/aloe
	seed = /obj/item/seeds/aloe
	name = "Алоэ"
	desc = "Срежьте листики с самого растения."
	icon_state = "aloe"
	bite_consumption_mod = 5
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/aloejuice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/tequila

/obj/item/food/grown/aloe/microwave_act(obj/machinery/microwave/M)
	new /obj/item/stack/medical/aloe(drop_location(), 2)
	qdel(src)

/obj/item/seeds/shrub
	name = "Пачка семян кустарника"
	desc = "Эти семена вырастают в живую изгородь."
	icon_state = "seed-shrub"
	species = "shrub"
	plantname = "Shrubbery"
	product = /obj/item/grown/shrub
	lifespan = 40
	endurance = 30
	maturation = 4
	production = 6
	yield = 2
	instability = 10
	growthstages = 3
	reagents_add = list()

/obj/item/grown/shrub
	seed = /obj/item/seeds/shrub
	name = "Кустарник"
	desc = "Милый кустик, да и стоил он не так дорого. Посадите его на землю, чтобы получилась живая изгородь, к сожалению, она не говорит."
	icon_state = "shrub"

/obj/item/grown/shrub/attack_self(mob/user)
	var/turf/player_turf = get_turf(user)
	if(player_turf?.is_blocked_turf(TRUE))
		return FALSE
	user.visible_message(span_danger("[user] начинает сажать <b>[src.name]</b>..."))
	if(do_after(user, 8 SECONDS, target = user.drop_location(), progress = TRUE))
		new /obj/structure/fluff/hedge/opaque(user.drop_location())
		to_chat(user, span_notice("Сажаю <b>[src.name]</b>."))
		qdel(src)
