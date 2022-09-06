/obj/item/food/grown/mushroom
	name = "Гриб"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 40

// Reishi
/obj/item/seeds/reishi
	name = "Пачка семян рейши"
	desc = "Этот мицелий вырастает в что-то медицинское и расслабляющее."
	icon_state = "mycelium-reishi"
	species = "reishi"
	plantname = "Reishi"
	product = /obj/item/food/grown/mushroom/reishi
	lifespan = 35
	endurance = 35
	maturation = 10
	production = 5
	yield = 4
	potency = 15
	instability = 30
	growthstages = 4
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/medicine/morphine = 0.35, /datum/reagent/medicine/c2/multiver = 0.35, /datum/reagent/consumable/nutriment = 0)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/reishi
	seed = /obj/item/seeds/reishi
	name = "Рейши"
	desc = "<I>Трутовик лакированный</I>: особый вид гриба, известный своими лечащими и снимающими стресс свойствами ."
	icon_state = "reishi"


// Fly Amanita
/obj/item/seeds/amanita
	name = "Пачка мицелия мухомора"
	desc = "Этот мицелий вырастает во что-то ужасное."
	icon_state = "mycelium-amanita"
	species = "amanita"
	plantname = "Fly Amanitas"
	product = /obj/item/food/grown/mushroom/amanita
	lifespan = 50
	endurance = 35
	maturation = 10
	production = 5
	yield = 4
	instability = 30
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	mutatelist = list(/obj/item/seeds/angel)
	reagents_add = list(/datum/reagent/drug/mushroomhallucinogen = 0.04, /datum/reagent/toxin/amatoxin = 0.35, /datum/reagent/consumable/nutriment = 0, /datum/reagent/growthserum = 0.1)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/amanita
	seed = /obj/item/seeds/amanita
	name = "Мухомор"
	desc = "<I>Мухомор красный</I>: Дети, запомните все ядовитые грибы. Только дотронешься до гриба и всё, понимаешь?."
	icon_state = "amanita"

// Destroying Angel
/obj/item/seeds/angel
	name = "Пачка мицелия ангелов смерти"
	desc = "Этот мицелий вырастает во что-то уничтожающее."
	icon_state = "mycelium-angel"
	species = "angel"
	plantname = "Destroying Angels"
	product = /obj/item/food/grown/mushroom/angel
	lifespan = 50
	endurance = 35
	maturation = 12
	production = 5
	yield = 2
	potency = 35
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/drug/mushroomhallucinogen = 0.04, /datum/reagent/toxin/amatoxin = 0.1, /datum/reagent/consumable/nutriment = 0, /datum/reagent/toxin/amanitin = 0.2)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/angel
	seed = /obj/item/seeds/angel
	name = "Ангел смерти"
	desc = "<I>Белая Поганка</I>: Гриб, содержащий летальные аматоксины."
	icon_state = "angel"
	wine_power = 60

// Liberty Cap
/obj/item/seeds/liberty
	name = "Пачка мицелия колпака свободы"
	desc = "Этот мицелий вырастает в колпак свободы."
	icon_state = "mycelium-liberty"
	species = "liberty"
	plantname = "Liberty-Caps"
	product = /obj/item/food/grown/mushroom/libertycap
	maturation = 7
	production = 1
	yield = 5
	potency = 15
	instability = 10
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/drug/mushroomhallucinogen = 0.25, /datum/reagent/consumable/nutriment = 0.02)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/libertycap
	seed = /obj/item/seeds/liberty
	name = "Колпак свободы"
	desc = "<I>Псилоцибе полуланцетовидная</I>: Освободи себя!"
	icon_state = "libertycap"
	wine_power = 80

// Plump Helmet
/obj/item/seeds/plump
	name = "Пачка мицелия толстошлемника"
	desc = "Наверное, этот мицелий вырастет в шлемы.... наверное."
	icon_state = "mycelium-plump"
	species = "plump"
	plantname = "Plump-Helmet Mushrooms"
	product = /obj/item/food/grown/mushroom/plumphelmet
	maturation = 8
	production = 1
	yield = 4
	potency = 15
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	mutatelist = list(/obj/item/seeds/plump/walkingmushroom)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/plumphelmet
	seed = /obj/item/seeds/plump
	name = "Толстошлем"
	desc = "<I>Плюмус Хельмус</I>: Пухленький и т-такой манящий~"
	icon_state = "plumphelmet"
	distill_reagent = /datum/reagent/consumable/ethanol/manly_dorf

// Walking Mushroom
/obj/item/seeds/plump/walkingmushroom
	name = "Пачка мицелия ходячего гриба"
	desc = "Этот мицелий вырастет в огромную дребедень!"
	icon_state = "mycelium-walkingmushroom"
	species = "walkingmushroom"
	plantname = "Walking Mushrooms"
	product = /obj/item/food/grown/mushroom/walkingmushroom
	lifespan = 30
	endurance = 30
	maturation = 5
	yield = 1
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.15)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/eyes

/obj/item/food/grown/mushroom/walkingmushroom
	seed = /obj/item/seeds/plump/walkingmushroom
	name = "Ходячий гриб"
	desc = "<I>Плюмус Локомотус</I>: Это начало неплохой прогулки!"
	icon_state = "walkingmushroom"
	can_distill = FALSE

/obj/item/food/grown/mushroom/walkingmushroom/attack_self(mob/user)
	if(isspaceturf(user.loc))
		return
	var/mob/living/simple_animal/hostile/mushroom/M = new /mob/living/simple_animal/hostile/mushroom(user.loc)
	M.maxHealth += round(seed.endurance / 4)
	M.melee_damage_lower += round(seed.potency / 20)
	M.melee_damage_upper += round(seed.potency / 20)
	M.move_to_delay -= round(seed.production / 50)
	M.health = M.maxHealth
	qdel(src)
	to_chat(user, span_notice("Сажаю ходячий гриб."))


// Chanterelle
/obj/item/seeds/chanter
	name = "Пачка мицелия лисички"
	desc = "Этот мицелий вырастает в лисичек."
	icon_state = "mycelium-chanter"
	species = "chanter"
	plantname = "Chanterelle Mushrooms"
	product = /obj/item/food/grown/mushroom/chanterelle
	lifespan = 35
	endurance = 20
	maturation = 7
	production = 1
	yield = 5
	potency = 15
	instability = 20
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1)
	mutatelist = list(/obj/item/seeds/chanter/jupitercup)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/chanterelle
	seed = /obj/item/seeds/chanter
	name = "Пучок лисичек"
	desc = "<I>Лисичка обыкновенная</I>: Эти рыжие маленькие грибочки выглядят очень аппетитно!"
	icon_state = "chanterelle"

//Jupiter Cup
/obj/item/seeds/chanter/jupitercup
	name = "Пачка мицелия чашек юпитера"
	desc = "Этот мицелий вырастает в чашки юпитера. Зевс позавидовал бы твоей силе."
	icon_state = "mycelium-jupitercup"
	species = "jupitercup"
	plantname = "Jupiter Cups"
	product = /obj/item/food/grown/mushroom/jupitercup
	lifespan = 40
	production = 4
	endurance = 8
	yield = 4
	growthstages = 2
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/reagent/liquidelectricity, /datum/plant_gene/trait/plant_type/carnivory)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1)
	graft_gene = /datum/plant_gene/trait/plant_type/carnivory

/obj/item/seeds/chanter/jupitercup/Initialize(mapload,nogenes)
	. = ..()
	if(!nogenes)
		unset_mutability(/datum/plant_gene/reagent/liquidelectricity, PLANT_GENE_EXTRACTABLE)
		unset_mutability(/datum/plant_gene/trait/plant_type/carnivory, PLANT_GENE_REMOVABLE)

/obj/item/food/grown/mushroom/jupitercup
	seed = /obj/item/seeds/chanter/jupitercup
	name = "Чашка юпитера"
	desc = "Странный красный гриб, его поверхность влажная и скользкая. Интересно, сколько крошечных червей побывали там?"
	icon_state = "jupitercup"

// Glowshroom
/obj/item/seeds/glowshroom
	name = "Пачка мицелия светогриба"
	desc = "Этот мицелий высветает в грибы!"
	icon_state = "mycelium-glowshroom"
	species = "glowshroom"
	plantname = "Glowshrooms"
	product = /obj/item/food/grown/mushroom/glowshroom
	lifespan = 100 //ten times that is the delay
	endurance = 30
	maturation = 15
	production = 1
	yield = 3 //-> spread
	potency = 30 //-> brightness
	instability = 20
	growthstages = 4
	rarity = 20
	genes = list(/datum/plant_gene/trait/glow, /datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	mutatelist = list(/obj/item/seeds/glowshroom/glowcap, /obj/item/seeds/glowshroom/shadowshroom)
	reagents_add = list(/datum/reagent/uranium/radium = 0.1, /datum/reagent/phosphorus = 0.1, /datum/reagent/consumable/nutriment = 0.04)
	graft_gene = /datum/plant_gene/trait/glow

/obj/item/food/grown/mushroom/glowshroom
	seed = /obj/item/seeds/glowshroom
	name = "Светогриб"
	desc = "<I>Мицена Брепрокс</I>: Этот вид цветов засветит всё!"
	icon_state = "glowshroom"
	var/effect_path = /obj/structure/glowshroom
	wine_power = 50

/obj/item/food/grown/mushroom/glowshroom/attack_self(mob/user)
	if(isspaceturf(user.loc))
		return FALSE
	if(!isturf(user.loc))
		to_chat(user, span_warning("Нужно больше места, чтобы посадить [src]."))
		return FALSE
	var/count = 0
	var/maxcount = 1
	for(var/tempdir in GLOB.cardinals)
		var/turf/closed/wall = get_step(user.loc, tempdir)
		if(istype(wall))
			maxcount++
	for(var/obj/structure/glowshroom/G in user.loc)
		count++
	if(count >= maxcount)
		to_chat(user, span_warning("Здесь слишком много грибов, чтобы сажать [src]."))
		return FALSE
	new effect_path(user.loc, seed)
	to_chat(user, span_notice("Сажаю [src]."))
	qdel(src)
	return TRUE


// Glowcap
/obj/item/seeds/glowshroom/glowcap
	name = "Пачка мицелия светошляпника"
	desc = "Этот мицелий расСВЕТает в грибы!"
	icon_state = "mycelium-glowcap"
	species = "glowcap"
	icon_harvest = "glowcap-harvest"
	plantname = "Glowcaps"
	product = /obj/item/food/grown/mushroom/glowshroom/glowcap
	genes = list(/datum/plant_gene/trait/glow/red, /datum/plant_gene/trait/cell_charge, /datum/plant_gene/trait/plant_type/fungal_metabolism)
	mutatelist = list()
	reagents_add = list(/datum/reagent/teslium = 0.1, /datum/reagent/consumable/nutriment = 0.04)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/cell_charge

/obj/item/food/grown/mushroom/glowshroom/glowcap
	seed = /obj/item/seeds/glowshroom/glowcap
	name = "Светошляпник"
	desc = "<I>Мицена Руфения</I>: Светятся в темноте, но на деле не биолюмисцентные. Тёплые на ощупь."
	icon_state = "glowcap"
	effect_path = /obj/structure/glowshroom/glowcap
	tastes = list("glowcap" = 1)


//Shadowshroom
/obj/item/seeds/glowshroom/shadowshroom
	name = "Пачка мицелия тенегриба"
	desc = "Этот мицелий вырастет в что-то тёмное."
	icon_state = "mycelium-shadowshroom"
	species = "shadowshroom"
	icon_grow = "shadowshroom-grow"
	icon_dead = "shadowshroom-dead"
	plantname = "Shadowshrooms"
	product = /obj/item/food/grown/mushroom/glowshroom/shadowshroom
	genes = list(/datum/plant_gene/trait/glow/shadow, /datum/plant_gene/trait/plant_type/fungal_metabolism)
	mutatelist = list()
	reagents_add = list(/datum/reagent/uranium/radium = 0.2, /datum/reagent/consumable/nutriment = 0.04)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/glow/shadow

/obj/item/food/grown/mushroom/glowshroom/shadowshroom
	seed = /obj/item/seeds/glowshroom/shadowshroom
	name = "Гроздь тенегриба"
	desc = "<I>Мицена Умбра</I>: Этот вид грибов поглощают свет, а не создают."
	icon_state = "shadowshroom"
	effect_path = /obj/structure/glowshroom/shadowshroom
	tastes = list("shadow" = 1, "грибы" = 1)
	wine_power = 60

/obj/item/food/grown/mushroom/glowshroom/shadowshroom/attack_self(mob/user)
	. = ..()
	if(.)
		investigate_log("was planted by [key_name(user)] at [AREACOORD(user)]", INVESTIGATE_BOTANY)
