// Poppy
/obj/item/seeds/poppy
	name = "Пачка семян мака"
	desc = "Эти семена вырастают в мак."
	icon_state = "seed-poppy"
	species = "poppy"
	plantname = "Poppy Plants"
	product = /obj/item/food/grown/poppy
	endurance = 10
	maturation = 8
	yield = 6
	potency = 20
	instability = 1 //Flowers have 1 instability, if you want to breed out instability, crossbreed with flowers.
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "poppy-grow"
	icon_dead = "poppy-dead"
	mutatelist = list(/obj/item/seeds/poppy/geranium, /obj/item/seeds/poppy/lily)
	reagents_add = list(/datum/reagent/medicine/c2/libital = 0.2, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/poppy
	seed = /obj/item/seeds/poppy
	name = "Мак"
	desc = "Древний символ спокойствия, мира и смерти."
	icon_state = "poppy"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 3
	foodtypes = VEGETABLES | GROSS
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth
	preserved_food = TRUE

// Lily
/obj/item/seeds/poppy/lily
	name = "Пачка семян лилии"
	desc = "Эти семена вырастут в красивые лилии."
	icon_state = "seed-lily"
	species = "lily"
	plantname = "Lily Plants"
	icon_grow = "lily-grow"
	icon_dead = "lily-dead"
	product = /obj/item/food/grown/poppy/lily
	mutatelist = list(/obj/item/seeds/poppy/lily/trumpet)

/obj/item/food/grown/poppy/lily
	seed = /obj/item/seeds/poppy/lily
	name = "Лилия"
	desc = "Красочный беленький цветок."
	icon_state = "lily"
	preserved_food = TRUE

	//Spacemans's Trumpet
/obj/item/seeds/poppy/lily/trumpet
	name = "Пачка семян космического дурмана"
	desc = "Растение, созданное тяжёлой генной инженерией. Этот дурман даже отдалённо не напоминает его древних предков. Для научного отдела NT более известно, как NTPW-0372."
	icon_state = "seed-trumpet"
	species = "spacemanstrumpet"
	plantname = "Spaceman's Trumpet Plant"
	product = /obj/item/food/grown/trumpet
	lifespan = 80
	production = 5
	endurance = 10
	maturation = 12
	yield = 4
	potency = 20
	growthstages = 4
	weed_rate = 2
	weed_chance = 10
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "spacemanstrumpet-grow"
	icon_dead = "spacemanstrumpet-dead"
	mutatelist = list()
	genes = list(/datum/plant_gene/reagent/polypyr)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05)
	rarity = 30
	graft_gene = /datum/plant_gene/reagent/polypyr

/obj/item/seeds/poppy/lily/trumpet/Initialize(mapload,nogenes)
	. = ..()
	if(!nogenes)
		unset_mutability(/datum/plant_gene/reagent/polypyr, PLANT_GENE_EXTRACTABLE)

/obj/item/food/grown/trumpet
	seed = /obj/item/seeds/poppy/lily/trumpet
	name = "Космический дурман"
	desc = "Яркий цветок, пахнущий свежескошенной травой. После касания этого цветка Ваша кожа окрашивается, через некоторое время после контакта, но большая часть других поверхностей не подвержена этому явлению."
	icon_state = "spacemanstrumpet"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	preserved_food = TRUE

// Geranium
/obj/item/seeds/poppy/geranium
	name = "Пачка семян герани"
	desc = "Эти семена вырастают в герань."
	icon_state = "seed-geranium"
	species = "geranium"
	plantname = "Geranium Plants"
	icon_grow = "geranium-grow"
	icon_dead = "geranium-dead"
	product = /obj/item/food/grown/poppy/geranium
	mutatelist = list(/obj/item/seeds/poppy/geranium/fraxinella, /obj/item/seeds/poppy/geranium/forgetmenot)

//Forget-Me-Not
/obj/item/seeds/poppy/geranium/forgetmenot
	name = "pack of forget-me-not seeds"
	desc = "These seeds grow into forget-me-nots."
	icon_state = "seed-forget_me_not"
	species = "forget_me_not"
	plantname = "Forget-Me-Not Plants"
	product = /obj/item/food/grown/poppy/geranium/forgetmenot
	endurance = 30
	maturation = 5
	yield = 4
	potency = 25
	icon_grow = "forget_me_not-grow"
	icon_dead = "forget_me_not-dead"
	mutatelist = list()
	reagents_add = list(/datum/reagent/medicine/c2/aiuri = 0.2, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/poppy/geranium/forgetmenot
	seed = /obj/item/seeds/poppy/geranium/forgetmenot
	name = "forget-me-not"
	desc = "A clump of small blue flowers, they are primarily associated with rememberance, respect and loyalty."
	icon_state = "forget_me_not"
	preserved_food = TRUE

/obj/item/food/grown/poppy/geranium
	seed = /obj/item/seeds/poppy/geranium
	name = "Герань"
	desc = "Красивый синий цветок."
	icon_state = "geranium"
	preserved_food = TRUE

///Fraxinella seeds.
/obj/item/seeds/poppy/geranium/fraxinella
	name = "Пачка семян фраксинеллы"
	desc = "Эти семена вырастают в фраксинеллу."
	icon_state = "seed-fraxinella"
	species = "fraxinella"
	plantname = "Fraxinella Plants"
	product = /obj/item/food/grown/poppy/geranium/fraxinella
	mutatelist = list()
	rarity = 15
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/fuel/oil = 0.05)

///Fraxinella Flowers.
/obj/item/food/grown/poppy/geranium/fraxinella
	seed = /obj/item/seeds/poppy/geranium/fraxinella
	name = "Фраксинелла"
	desc = "Красивый светло-розовый цветок."
	icon_state = "fraxinella"
	distill_reagent = /datum/reagent/ash
	preserved_food = TRUE

// Harebell
/obj/item/seeds/harebell
	name = "Пачка семян колокольчиков"
	desc = "Эти семена вырастают в красивые маленькие цветочки."
	icon_state = "seed-harebell"
	species = "harebell"
	plantname = "Harebells"
	product = /obj/item/food/grown/harebell
	lifespan = 100
	endurance = 20
	maturation = 7
	production = 1
	yield = 2
	potency = 30
	instability = 1
	growthstages = 4
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.04)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/food/grown/harebell
	seed = /obj/item/seeds/harebell
	name = "Колокольчики"
	desc = "\"Я украшу твою могилу: этот цветок заменит все другие, он будет лежать в твоей могиле, подобно твоему лицу: бледному, бездыханному, подобно твоим венам, по которым больше не течёт кровь, такой же бледный, такой же блеклый.\""
	icon_state = "harebell"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 3
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth
	preserved_food = TRUE

// Sunflower
/obj/item/seeds/sunflower
	name = "Пачка семян подсолнуха"
	desc = "Эти семена вырастают в подсолнух."
	icon_state = "seed-sunflower"
	species = "sunflower"
	plantname = "Sunflowers"
	product = /obj/item/grown/sunflower
	endurance = 20
	production = 2
	yield = 2
	instability = 1
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "sunflower-grow"
	icon_dead = "sunflower-dead"
	mutatelist = list(/obj/item/seeds/sunflower/moonflower, /obj/item/seeds/sunflower/novaflower)
	reagents_add = list(/datum/reagent/consumable/cornoil = 0.08, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/grown/sunflower // FLOWER POWER!
	seed = /obj/item/seeds/sunflower
	name = "Подсолнух"
	desc = "Это прекрасно! Кое-кто может сделать с вами кое-что, если вы растопчете этот цветок."
	icon_state = "sunflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/grown/sunflower/attack(mob/M, mob/user)
	to_chat(M, "<font color='green'>[user] шлёпает меня подсолнухом!<font color='orange'><b>ЦВЕТОЧНАЯ СИЛА!</b></font></font>")
	to_chat(user, "<font color='green'>Шлёпаю подсолнухом <font color='orange'><b>ЦВЕТОЧНАЯ СИЛА</b></font> strikes [M]!</font>")

// Moonflower
/obj/item/seeds/sunflower/moonflower
	name = "Пачка семян лунного цветка"
	desc = "Эти семена вырастут в лунный цветок."
	icon_state = "seed-moonflower"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	species = "moonflower"
	plantname = "Moonflowers"
	icon_grow = "moonflower-grow"
	icon_dead = "sunflower-dead"
	product = /obj/item/food/grown/moonflower
	genes = list(/datum/plant_gene/trait/glow/purple)
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/ethanol/moonshine = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/consumable/nutriment = 0.02)
	rarity = 15
	graft_gene = /datum/plant_gene/trait/glow/purple

/obj/item/food/grown/moonflower
	seed = /obj/item/seeds/sunflower/moonflower
	name = "Лунный цветок"
	desc = "Хранить как минимум в 50 метрах от оборотней."
	icon_state = "moonflower"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 2
	distill_reagent = /datum/reagent/consumable/ethanol/absinthe //It's made from flowers.
	preserved_food = TRUE

// Novaflower
/obj/item/seeds/sunflower/novaflower
	name = "Пачка семян звездоцвета"
	desc = "Эти семена вырастают в звездоцвет."
	icon_state = "seed-novaflower"
	species = "novaflower"
	plantname = "Novaflowers"
	icon_grow = "novaflower-grow"
	icon_dead = "sunflower-dead"
	product = /obj/item/grown/novaflower
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/condensedcapsaicin = 0.25, /datum/reagent/consumable/capsaicin = 0.3, /datum/reagent/consumable/nutriment = 0)
	rarity = 20

/obj/item/grown/novaflower
	seed = /obj/item/seeds/sunflower/novaflower
	name = "Звездоцвет"
	desc = "Эти прекрасные цветы имеют аромат дыма, напоминает летние шашлычки."
	icon_state = "novaflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	attack_verb_continuous = list("жарит", "поджигает", "выжигает")
	attack_verb_simple = list("жарит", "поджигает", "выжигает")
	grind_results = list(/datum/reagent/consumable/capsaicin = 0, /datum/reagent/consumable/condensedcapsaicin = 0)

/obj/item/grown/novaflower/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	force = round((5 + seed.potency / 5), 1)
	AddElement(/datum/element/plant_backfire, /obj/item/grown/novaflower.proc/singe_holder)

/obj/item/grown/novaflower/attack(mob/living/carbon/M, mob/user)
	if(!..())
		return
	if(isliving(M))
		to_chat(M, span_danger("Горю, словно в огне от интенсивного жара [name]!"))
		M.adjust_fire_stacks(seed.potency / 20)
		if(M.IgniteMob())
			message_admins("[ADMIN_LOOKUPFLW(user)] set [ADMIN_LOOKUPFLW(M)] on fire with [src] at [AREACOORD(user)]")
			log_game("[key_name(user)] set [key_name(M)] on fire with [src] at [AREACOORD(user)]")

/obj/item/grown/novaflower/afterattack(atom/A as mob|obj, mob/user,proximity)
	. = ..()
	if(!proximity)
		return
	if(force > 0)
		force -= rand(1, (force / 3) + 1)
	else
		to_chat(usr, span_warning("Все лепестки отвалились от сильного удара [name]!"))
		qdel(src)

/*
 * Burn the person holding the novaflower's hand. Their active hand takes burn = the novaflower's force.
 *
 * user - the carbon who is holding the flower.
 */
/obj/item/grown/novaflower/proc/singe_holder(mob/living/carbon/user)
	to_chat(user, span_danger("[src] обжигает мою голую руку!"))
	var/obj/item/bodypart/affecting = user.get_active_hand()
	if(affecting?.receive_damage(0, force, wound_bonus = CANT_WOUND))
		user.update_damage_overlays()

// Rose
/obj/item/seeds/rose
	name = "Пачка семян розы"
	desc = "Эти семена вырастают в розы."
	icon_state = "seed-rose"
	species = "rose"
	plantname = "Rose Bush"
	product = /obj/item/food/grown/rose
	endurance = 12
	yield = 6
	potency = 15
	instability = 20 //Roses crossbreed easily, and there's many many species of them.
	growthstages = 3
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "rose-grow"
	icon_dead = "rose-dead"
	mutatelist = list(/obj/item/seeds/carbon_rose)
	//Roses are commonly used as herbal medicines (diarrhodons) and for their 'rose oil'.
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/granibitaluri = 0.1, /datum/reagent/fuel/oil = 0.05)

/obj/item/food/grown/rose
	seed = /obj/item/seeds/rose
	name = "Роза"
	desc = "Классический цветок де романтик. Аккуратнее с колючками!"
	icon_state = "rose"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	bite_consumption_mod = 3
	foodtypes = VEGETABLES | GROSS
	preserved_food = TRUE

/obj/item/food/grown/rose/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	AddElement(/datum/element/plant_backfire, /obj/item/food/grown/rose.proc/prick_holder, list(TRAIT_PIERCEIMMUNE))

/obj/item/food/grown/rose/proc/prick_holder(mob/living/carbon/user)
	if(!seed.get_gene(/datum/plant_gene/trait/sticky) && prob(66))
		return

	to_chat(user, span_danger("Вы укололи свою руку об колючку на розе [name]. Ауч."))
	var/obj/item/bodypart/affecting = user.get_active_hand()
	if(affecting?.receive_damage(2))
		user.update_damage_overlays()

// Carbon Rose
/obj/item/seeds/carbon_rose
	name = "Пачка семян углеродной розы"
	desc = "Эти семена вырастают в углеродную розу."
	icon_state = "seed-carbonrose"
	species = "carbonrose"
	plantname = "Carbon Rose Flower"
	product = /obj/item/grown/carbon_rose
	endurance = 12
	yield = 6
	potency = 15
	instability = 3
	growthstages = 3
	genes = list(/datum/plant_gene/reagent/carbon)
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	icon_grow = "carbonrose-grow"
	icon_dead = "carbonrose-dead"
	mutatelist = list(/obj/item/seeds/carbon_rose)
	reagents_add = list(/datum/reagent/plastic_polymers = 0.05)
	rarity = 10
	graft_gene = /datum/plant_gene/reagent/carbon

/obj/item/seeds/carbon_rose/Initialize(mapload, nogenes)
	. = ..()
	if(!nogenes)
		unset_mutability(/datum/plant_gene/reagent/carbon, PLANT_GENE_EXTRACTABLE)

/obj/item/grown/carbon_rose
	seed = /obj/item/seeds/carbon_rose
	name = "Углеродная роза"
	desc = "Новый вид цветка де романтик, более совершенный, без колючек."
	icon_state = "carbonrose"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	force = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HEAD
	throw_speed = 1
	throw_range = 3
