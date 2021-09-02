// Citrus - base type
/obj/item/food/grown/citrus
	seed = /obj/item/seeds/lime
	name = "цитрус"
	desc = "Настолько кислый, что тебе скривит еблет."
	icon_state = "lime"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	wine_power = 30

// Lime
/obj/item/seeds/lime
	name = "Пачка семян лайма"
	desc = "Это очень кислые семена."
	icon_state = "seed-lime"
	species = "lime"
	plantname = "Lime Tree"
	product = /obj/item/food/grown/citrus/lime
	lifespan = 55
	endurance = 50
	yield = 4
	potency = 15
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/orange)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/citrus/lime
	seed = /obj/item/seeds/lime
	name = "лайм"
	desc = "Настолько кислый, что у тебя скривится лицо"
	icon_state = "lime"
	juice_results = list(/datum/reagent/consumable/limejuice = 0)

// Orange
/obj/item/seeds/orange
	name = "Пачка семян апельсина"
	desc = "Кислые семена"
	icon_state = "seed-orange"
	species = "orange"
	plantname = "Orange Tree"
	product = /obj/item/food/grown/citrus/orange
	lifespan = 60
	endurance = 50
	yield = 5
	potency = 20
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/lime, /obj/item/seeds/orange_3d)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/citrus/orange
	seed = /obj/item/seeds/orange
	name = "апельсин"
	desc = "Это острый фрукт."
	icon_state = "orange"
	juice_results = list(/datum/reagent/consumable/orangejuice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/triple_sec

// Lemon
/obj/item/seeds/lemon
	name = "Пачка семян лимона"
	desc = "Эти семена довольно кислые."
	icon_state = "seed-lemon"
	species = "lemon"
	plantname = "Lemon Tree"
	product = /obj/item/food/grown/citrus/lemon
	lifespan = 55
	endurance = 45
	yield = 4
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/firelemon)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/citrus/lemon
	seed = /obj/item/seeds/lemon
	name = "лимон"
	desc = "Если жизнь даёт тебе лимон, сделай лимонад"
	icon_state = "lemon"
	juice_results = list(/datum/reagent/consumable/lemonjuice = 0)

// Combustible lemon
/obj/item/seeds/firelemon //combustible lemon is too long so firelemon
	name = "Пачка семян горючего лимона"
	desc = "Если жизнь даёт лимон, то не делай лимонад. Заставь жизнь забрать сраные лимоны! СУКА! Я НЕ ХОЧУ ТВОИ ЧЕРТОВЫ ЛИМОНЫ!!!"
	icon_state = "seed-firelemon"
	species = "firelemon"
	plantname = "Combustible Lemon Tree"
	product = /obj/item/food/grown/firelemon
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 55
	endurance = 45
	yield = 4
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/fuel = 0.05)

/obj/item/food/grown/firelemon
	seed = /obj/item/seeds/firelemon
	name = "Горючий лимон"
	desc = "Создан, чтобы сжигать дома."
	icon_state = "firelemon"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	wine_power = 70

/obj/item/food/grown/firelemon/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] активирует [src]!") , span_userdanger("Ты активировал [src]!"))
	log_bomber(user, "primed a", src, "for detonation")
	icon_state = "firelemon_active"
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, TRUE, -3)
	addtimer(CALLBACK(src, .proc/detonate), rand(10, 60))

/obj/item/food/grown/firelemon/burn()
	detonate()
	..()

/obj/item/food/grown/firelemon/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.dropItemToGround(src)

/obj/item/food/grown/firelemon/ex_act(severity)
	qdel(src) //Ensuring that it's deleted by its own explosion

/obj/item/food/grown/firelemon/proc/detonate(mob/living/lanced_by)
	switch(seed.potency) //Combustible lemons are alot like IEDs, lots of flame, very little bang.
		if(0 to 30)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 1)
			qdel(src)
		if(31 to 50)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 2)
			qdel(src)
		if(51 to 70)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 3)
			qdel(src)
		if(71 to 90)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 4)
			qdel(src)
		else
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 5)
			qdel(src)

//3D Orange
/obj/item/seeds/orange_3d
	name = "Пачка сверхпространственных апельсинов"
	desc = "Полигональные семена."
	icon_state = "seed-orange"
	species = "orange"
	plantname = "Extradimensional Orange Tree"
	product = /obj/item/food/grown/citrus/orange_3d
	lifespan = 60
	endurance = 50
	yield = 5
	potency = 20
	instability = 64
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/haloperidol = 0.15) //insert joke about the effects of haloperidol and our glorious headcoder here

/obj/item/food/grown/citrus/orange_3d
	seed = /obj/item/seeds/orange_3d
	name = "сверхпространственный апельсин"
	desc = "С этой штукой можно и голову потерять."
	icon_state = "orang"
	juice_results = list(/datum/reagent/consumable/orangejuice = 0)
	distill_reagent = /datum/reagent/toxin/mindbreaker
	tastes = list("polygons" = 1, "апельсины" = 1)

/obj/item/food/grown/citrus/orange_3d/pickup(mob/user)
	. = ..()
	icon_state = "orange"

/obj/item/food/grown/citrus/orange_3d/dropped(mob/user)
	. = ..()
	icon_state = "orang"
