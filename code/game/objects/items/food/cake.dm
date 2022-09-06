/obj/item/food/cake
	icon = 'icons/obj/food/piecake.dmi'
	bite_consumption = 3
	max_volume = 80
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("торт" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/cake/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/food_storage)

/obj/item/food/cakeslice
	icon = 'icons/obj/food/piecake.dmi'
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("торт" = 1)
	foodtypes = GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cake/plain
	name = "торт"
	desc = "Простой торт, не ложь"
	icon_state = "plaincake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 30, /datum/reagent/consumable/nutriment/vitamin = 7)
	tastes = list("сладость" = 2,"торт" = 5)
	foodtypes = GRAIN | DAIRY | SUGAR
	burns_in_oven = TRUE


/obj/item/food/cake/plain/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/plain, 5, 30)

/obj/item/food/cakeslice/plain
	name = "кусок торта"
	desc = "Просто кусочек торта стандартного размера."
	icon_state = "plaincake_slice"
	tastes = list("сладость" = 2,"торт" = 5)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/carrot
	name = "морковный торт"
	desc = "Любимый десерт хитвого кволика. Не ложь."
	icon_state = "carrotcake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/medicine/oculine = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("торт" = 5, "сладость" = 2, "морковь" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_CHEAP


/obj/item/food/cake/carrot/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/carrot, 5, 30)

/obj/item/food/cakeslice/carrot
	name = "кусочек морковного торта"
	desc = "Морковный кусочек морковного торта, морковь полезна для глаз! Тоже не ложь."
	icon_state = "carrotcake_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/oculine = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("торт" = 5, "сладость" = 2, "морковь" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cake/brain
	name = "торт с мозгами"
	desc = "Нечто вроде торта."
	icon_state = "braincake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/medicine/mannitol = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("торт" = 5, "сладость" = 2, "мозги" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | GROSS | SUGAR

/obj/item/food/cake/brain/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/brain, 5, 30)

/obj/item/food/cakeslice/brain
	name = "кусочек торта с мозгами"
	desc = "Давай я расскажу тебе кое-что о прионах. ОНИ ВОСХИТИТЕЛЬНЫ!"
	icon_state = "braincakeslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/medicine/mannitol = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("торт" = 5, "сладость" = 2, "мозги" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | GROSS | SUGAR

/obj/item/food/cake/cheese
	name = "сырный торт"
	desc = "ОПАСНО сырный."
	icon_state = "cheesecake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 8, /datum/reagent/consumable/nutriment/protein = 5)
	tastes = list("торт" = 4, "сливочный сыр" = 3)
	foodtypes = GRAIN | DAIRY
	venue_value = FOOD_PRICE_CHEAP


/obj/item/food/cake/cheese/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/cheese, 5, 30)

/obj/item/food/cakeslice/cheese
	name = "кусочек сырного торта"
	desc = "Кусочек чистого сырного наслаждения."
	icon_state = "cheesecake_slice"
	tastes = list("торт" = 4, "сливочный сыр" = 3)
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1.3)
	foodtypes = GRAIN | DAIRY

/obj/item/food/cake/orange
	name = "апельсиновый торт"
	desc = "Торт с апельсинами."
	icon_state = "orangecake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("торт" = 5, "сладость" = 2, "апельсины" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cake/orange/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/orange, 5, 30)

/obj/item/food/cakeslice/orange
	name = "кусочек апельсинового торта"
	desc = "Просто кусочек торта стандартного размера."
	icon_state = "orangecake_slice"
	tastes = list("торт" = 5, "сладость" = 2, "апельсины" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/lime
	name = "лаймовый торт"
	desc = "Торт с лаймами."
	icon_state = "limecake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("торт" = 5, "сладость" = 2, "невыносимая кислинка" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cake/lime/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/lime, 5, 30)

/obj/item/food/cakeslice/lime
	name = "кусочек лаймового торта"
	desc = "Просто кусочек торта стандартного размера."
	icon_state = "limecake_slice"
	tastes = list("торт" = 5, "сладость" = 2, "невыносимая кислинка" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/lemon
	name = "лимонный торт"
	desc = "Торт с лимонами."
	icon_state = "lemoncake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("торт" = 5, "сладость" = 2, "кислинка" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cake/lemon/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/lemon, 5, 30)

/obj/item/food/cakeslice/lemon
	name = "кусочек лимонного торта"
	desc = "Просто кусочек торта стандартного размера."
	icon_state = "lemoncake_slice"
	tastes = list("торт" = 5, "сладость" = 2, "кислинка" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/chocolate
	name = "шоколадный торт"
	desc = "Торт с шоколадом."
	icon_state = "chocolatecake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("торт" = 5, "сладость" = 1, "шоколад" = 4)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cake/chocolate/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/chocolate, 5, 30)

/obj/item/food/cakeslice/chocolate
	name = "кусочек шоколадного торта"
	desc = "Просто кусочек торта стандартного размера."
	icon_state = "chocolatecake_slice"
	tastes = list("торт" = 5, "сладость" = 1, "шоколад" = 4)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday
	name = "праздничный торт"
	desc = "С Днем рождения, маленький клоун..."
	icon_state = "birthdaycake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/sprinkles = 10, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("торт" = 5, "сладость" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/birthday, 5, 30)

/obj/item/food/cake/birthday/microwave_act(obj/machinery/microwave/M) //super sekrit club
	new /obj/item/clothing/head/hardhat/cakehat(get_turf(src))
	qdel(src)

/obj/item/food/cakeslice/birthday
	name = "кусочек праздничного торта"
	desc = "Кусочек твоего дня рождения."
	icon_state = "birthdaycakeslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sprinkles = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("торт" = 5, "сладость" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD | SUGAR

/obj/item/food/cake/birthday/energy
	name = "энерго торт"
	desc = "Достаточно калорий для целого отряда ядерных оперативников."
	icon_state = "energycake"
	force = 5
	hitsound = 'sound/weapons/blade1.ogg'
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/sprinkles = 10, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/pwr_game = 10, /datum/reagent/consumable/liquidelectricity = 10)
	tastes = list("торт" = 3, "a Vlad's Salad" = 1)

/obj/item/food/cake/birthday/energy/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/birthday/energy, 5, 30)

/obj/item/food/cake/birthday/energy/proc/energy_bite(mob/living/user)
	to_chat(user, span_boldwarning("Когда я ел этот торт, я случайно поранился. Откуда в нём энергетический меч?!"))
	user.apply_damage(30,BRUTE,BODY_ZONE_HEAD)
	playsound(user, 'sound/weapons/blade1.ogg', 5, TRUE)

/obj/item/food/cake/birthday/energy/attack(mob/living/M, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM) && M != user) //Prevents pacifists from attacking others directly
		return
	energy_bite(M, user)

/obj/item/food/cake/birthday/energy/microwave_act(obj/machinery/microwave/M) //super sekriter club
	new /obj/item/clothing/head/hardhat/cakehat/energycake(get_turf(src))
	qdel(src)

/obj/item/food/cakeslice/birthday/energy
	name = "кусочек энерго торта"
	desc = "С собой для предателя."
	icon_state = "energycakeslice"
	force = 2
	hitsound = 'sound/weapons/blade1.ogg'
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sprinkles = 2, /datum/reagent/consumable/nutriment/vitamin = 1,  /datum/reagent/consumable/pwr_game = 2, /datum/reagent/consumable/liquidelectricity = 2)
	tastes = list("торт" = 3, "a Vlad's Salad" = 1)

/obj/item/food/cakeslice/birthday/energy/proc/energy_bite(mob/living/user)
	to_chat(user, span_boldwarning("Когда я ел этот торт, я случайно поранился. Откуда в нём энергетический меч?!"))
	user.apply_damage(18,BRUTE,BODY_ZONE_HEAD)
	playsound(user, 'sound/weapons/blade1.ogg', 5, TRUE)

/obj/item/food/cakeslice/birthday/energy/attack(mob/living/M, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM) && M != user) //Prevents pacifists from attacking others directly
		return
	energy_bite(M, user)

/obj/item/food/cake/apple
	name = "яблочый торт"
	desc = "Пирог с яблоком в центре."
	icon_state = "applecake"

	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("торт" = 5, "сладость" = 1, "яблоко" = 1)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cake/apple/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/apple, 5, 30)

/obj/item/food/cakeslice/apple
	name = "кусочек яблочного торта"
	desc = "Кусочек райского наслаждения."
	icon_state = "applecakeslice"
	tastes = list("торт" = 5, "сладость" = 1, "яблоко" = 1)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/slimecake
	name = "слаймовый торт"
	desc = "Торт из слаймов. Возможно, не электрифицирован."
	icon_state = "slimecake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("торт" = 5, "сладость" = 1, "слаймы" =1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/slimecake/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/slimecake, 5, 30)

/obj/item/food/cakeslice/slimecake
	name = "кусочек слаймового торта"
	desc = "Кусочек слаймового торта."
	icon_state = "slimecake_slice"
	tastes = list("торт" = 5, "сладость" = 1, "слаймы" =1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/pumpkinspice
	name = "тыквенно-пряный торт"
	desc = "Полый пирог из настоящей тыквы."
	icon_state = "pumpkinspicecake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("торт" = 5, "сладость" = 1, "тыква" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cake/pumpkinspice/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/pumpkinspice, 5, 30)

/obj/item/food/cakeslice/pumpkinspice
	name = "кусочек тыквенно-пряного пирога"
	desc = "Пикантный кусочек тыквенной вкуснятины."
	icon_state = "pumpkinspicecakeslice"
	tastes = list("торт" = 5, "сладость" = 1, "тыква" = 1)
	foodtypes = GRAIN | DAIRY | VEGETABLES | SUGAR

/obj/item/food/cake/bsvc // blackberry strawberries vanilla cake
	name = "ванильный торт с ежевикой и клубникой"
	desc = "Простой торт с начинкой из ежевики и клубники!"
	icon_state = "blackbarry_strawberries_cake_vanilla_cake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("ежевика" = 2, "клубника" = 2, "ваниль" = 2, "сладость" = 2, "торт" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/bsvc/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/bsvc, 5, 30)

/obj/item/food/cakeslice/bsvc
	name = "кусочек ванильного торта с ежевикой и клубникой"
	desc = "Кусочек простого торта с начинкой из ежевики и клубники!"
	icon_state = "blackbarry_strawberries_cake_vanilla_slice"
	tastes = list("ежевика" = 2, "клубника" = 2, "ваниль" = 2, "сладость" = 2,"торт" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/bscc // blackbarry strawberries chocolate cake
	name = "шоколадный торт с ежевикой и клубникой"
	desc = "Шоколадный торт с начинкой из ежевики и клубники!"
	icon_state = "blackbarry_strawberries_cake_coco_cake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/coco = 5)
	tastes = list("ежевика" = 2, "клубника" = 2, "шоколад" = 2, "сладость" = 2,"торт" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/bscc/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/bscc, 5, 30)

/obj/item/food/cakeslice/bscc
	name = "кусочек шоколадного торта с ежевикой и клубникой"
	desc = "Кусочек шоколадного торта с начинкой из ежевики и клубники!"
	icon_state = "blackbarry_strawberries_cake_coco_slice"
	tastes = list("ежевика" = 2, "клубника" = 2, "шоколад" = 2, "сладость" = 2,"торт" = 3)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/holy_cake
	name = "торт \"Пища Ангелов\""
	desc = "Торт, приготовленный как для ангелов, так и для капелланов! Содержит святую воду."
	icon_state = "holy_cake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/water/holywater = 10)
	tastes = list("торт" = 5, "сладость" = 1, "облака" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/holy_cake/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/holy_cake_slice, 5, 30)

/obj/item/food/cakeslice/holy_cake_slice
	name = "кусочек торта \"Пища Ангелов\""
	desc = "Кусочек райского торта."
	icon_state = "holy_cake_slice"
	tastes = list("торт" = 5, "сладость" = 1, "облака" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/pound_cake
	name = "фунтовый торт"
	desc = "Торт со сгущенкой, этим ты точно наешься."
	icon_state = "pound_cake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 60, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("торт" = 5, "сладость" = 1, "кляр" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR | JUNKFOOD
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cake/pound_cake/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/pound_cake_slice, 7, 30)

/obj/item/food/cakeslice/pound_cake_slice
	name = "кусочек фунтового торта"
	desc = "Кусок торта со сгущенкой, которым ты точно наешься."
	icon_state = "pound_cake_slice"
	tastes = list("торт" = 5, "сладость" = 5, "кляр" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 0.5)
	foodtypes = GRAIN | DAIRY | SUGAR | JUNKFOOD

/obj/item/food/cake/hardware_cake
	name = "аппаратурный торт"
	desc = "Сделан из электронных плат и, кажется, из него вытекает кислота..."
	icon_state = "hardware_cake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/toxin/acid = 15, /datum/reagent/fuel/oil = 15)
	tastes = list("кислота" = 3, "металл" = 4, "стекло" = 5)
	foodtypes = GRAIN | GROSS

/obj/item/food/cake/hardware_cake/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/hardware_cake_slice, 5, 30)

/obj/item/food/cakeslice/hardware_cake_slice
	name = "кусочек аппаратурного торта"
	desc = "Кусочек электронной платы с кислотой."
	icon_state = "hardware_cake_slice"
	tastes = list("кислота" = 3, "металл" = 4, "стекло" = 5)
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/toxin/acid = 3, /datum/reagent/fuel/oil = 3)
	foodtypes = GRAIN | GROSS

/obj/item/food/cake/vanilla_cake
	name = "ванильный торт"
	desc = "Торт с ванильной глазурью."
	icon_state = "vanillacake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/sugar = 15, /datum/reagent/consumable/vanilla = 15)
	tastes = list("торт" = 1, "сахар" = 1, "ваниль" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/vanilla_cake/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/vanilla_slice, 5, 30)

/obj/item/food/cakeslice/vanilla_slice
	name = "кусочек ванильного торта"
	desc = "Кусочек ванильного торта с глазурью."
	icon_state = "vanillacake_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/vanilla = 3)
	tastes = list("торт" = 1, "сахар" = 1, "ваниль" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/clown_cake
	name = "клоунский торт"
	desc = "Смешной торт с лицом клоуна."
	icon_state = "clowncake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/sugar = 15)
	tastes = list("торт" = 1, "сахар" = 1, "радость" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/clown_cake/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/clown_slice, 5, 30)

/obj/item/food/cakeslice/clown_slice
	name = "кусочек клоунского торта"
	desc = "Кусочек плохих шуток и глупого реквизита."
	icon_state = "clowncake_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/sugar = 3)
	tastes = list("торт" = 1, "сахар" = 1, "радость" = 10)
	foodtypes = GRAIN | SUGAR | DAIRY

/obj/item/food/cake/trumpet
	name = "торт космонавтов"
	desc = "Торт с шляпкой из глазури."
	icon_state = "trumpetcake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/medicine/polypyr = 15, /datum/reagent/consumable/cream = 5, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/berryjuice = 5)
	tastes = list("торт" = 4, "фиалки" = 2, "варенье" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/trumpet/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/trumpet, 5, 30)

/obj/item/food/cakeslice/trumpet
	name = "кусочек торта космонавтов"
	desc = "Просто кусочек торта стандартного размера."
	icon_state = "trumpetcakeslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/medicine/polypyr = 3, /datum/reagent/consumable/cream = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/berryjuice = 1)
	tastes = list("торт" = 4, "фиалки" = 2, "варенье" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR

/obj/item/food/cake/brioche
	name = "торт Бриошь"
	desc = "Кольцо из сладких глазированных булочек."
	icon_state = "briochecake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cake" = 4, "butter" = 2, "cream" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR

/obj/item/food/cake/brioche/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/brioche, 6, 30)

/obj/item/food/cakeslice/brioche
	name = "кусочек торта Бриошь"
	desc = "Вкусный сладкий хлеб. Кому нужно что-нибудь еще?"
	icon_state = "briochecake_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("cake" = 4, "butter" = 2, "cream" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
