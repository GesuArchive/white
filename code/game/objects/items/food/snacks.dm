////////////////////////////////////////////SNACKS FROM VENDING MACHINES////////////////////////////////////////////
//in other words: junk food
//don't even bother looking for recipes for these

/obj/item/food/candy
	name = "конфетка"
	desc = "Ты либо любишь это, либо ненавидишь."
	icon_state = "candy"
	trash_type = /obj/item/trash/candy
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3)
	junkiness = 25
	tastes = list("конфета" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	preserved_food = TRUE

/obj/item/food/candy/bronx
	name = "батончик \"South Bronx Paradise\""
	desc = "Похудение гарантировано! Вкус карамельного мокко... Здесь ещё кое что написано, надо присмотреться..."
	icon_state = "bronx"
	inhand_icon_state = "candy"
	trash_type = /obj/item/trash/candy
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 2, /datum/reagent/yuck = 1)
	junkiness = 10
	bite_consumption = 10
	tastes = list("конфета" = 5, "потеря веса" = 4, "личинка насекомых" = 1)
	foodtypes = JUNKFOOD | RAW | GROSS
	custom_price = PAYCHECK_ASSISTANT * 1.6 //Joke adjusted for inflation
	w_class = WEIGHT_CLASS_TINY
	var/revelation = FALSE
	preserved_food = TRUE

/obj/item/food/candy/bronx/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				microwaved_type = microwaved_type,\
				junkiness = junkiness,\
				after_eat = CALLBACK(src, PROC_REF(after_eat)))

/obj/item/food/candy/bronx/proc/after_eat(mob/living/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/carl = eater
		var/datum/disease/P = new /datum/disease/parasite()
		carl.ForceContractDisease(P, FALSE, TRUE)

/obj/item/food/candy/bronx/examine(mob/user)
	. = ..()
	if(!revelation)
		to_chat(user, span_notice("Боже, что с моими глазами, ничего не вижу. Надо посмотреть ещё раз"))
		desc = "Похудение гарантировано! Вкус карамельного мокко! ПРЕДУПРЕЖДЕНИЕ: ПРОДУКТ НЕ ПРИГОДЕН ДЛЯ УПОТРЕБЛЕНИЯ ЧЕЛОВЕКОМ. СОДЕРЖИТ ЖИВЫХ ЛИЧИНОК ДИАМФИДИЙ."
		name = "батончик \"South Bronx Paradise\""
		revelation = TRUE

/obj/item/food/sosjerky
	name = "Вяленая говядина \"Scaredy's Private Reserve Beef Jerky\""
	icon_state = "sosjerky"
	desc = "Вяленая говядина, изготовленная из лучших космических коров."
	trash_type = /obj/item/trash/sosjerky
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/salt = 2)
	junkiness = 25
	tastes = list("сушеное мясо" = 1)
	w_class = WEIGHT_CLASS_SMALL
	foodtypes = JUNKFOOD | MEAT | SUGAR
	preserved_food = TRUE

/obj/item/food/sosjerky/healthy
	name = "вяленая говядина домашнего приготовления"
	desc = "Домашняя вяленая говядина, изготовленная из лучших коров космического происхождения."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	junkiness = 0

/obj/item/food/chips
	name = "чипсы"
	desc = "Из 100% натурального картофеля."
	icon_state = "chips"
	trash_type = /obj/item/trash/chips
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/salt = 1)
	junkiness = 20
	tastes = list("соль" = 1, "чипсы" = 1)
	foodtypes = JUNKFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/chips/MakeLeaveTrash()
	if(trash_type)
		AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)

/obj/item/food/no_raisin
	name = "пачка изюма"
	icon_state = "4no_raisins"
	desc = "Лучший изюм во вселенной. Не знаю почему."
	trash_type = /obj/item/trash/raisins
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 4)
	junkiness = 25
	tastes = list("сушеный изюм" = 1)
	foodtypes = JUNKFOOD | FRUIT | SUGAR
	food_flags = FOOD_FINGER_FOOD
	custom_price = PAYCHECK_ASSISTANT * 0.7
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/no_raisin/healthy
	name = "изюм домашнего приготовления"
	desc = "Домашний изюм, лучший во изюм во вселенной."
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	junkiness = 0
	foodtypes = FRUIT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spacetwinkie
	name = "космическое твинки"
	icon_state = "space_twinkie"
	desc = "Не испортится даже после твоей смерти."
	food_reagents = list(/datum/reagent/consumable/sugar = 4)
	junkiness = 25
	foodtypes = JUNKFOOD | GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	custom_price = PAYCHECK_PRISONER
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/candy_trash
	name = "окурок леденцовой сигареты"
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "candybum"
	desc = "Остатки от выкуренной леденцовой сигареты. Можно съесть!"
	food_reagents = list(/datum/reagent/consumable/sugar = 4, /datum/reagent/ash = 3)
	junkiness = 10 //powergame trash food by buying candy cigs in bulk and eating them when they extinguish
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	preserved_food = TRUE

/obj/item/food/candy_trash/nicotine
	desc = "Остатки от выкуренной конфетной сигареты. Пахнет никотином...?"
	food_reagents = list(/datum/reagent/consumable/sugar = 4, /datum/reagent/ash = 3, /datum/reagent/drug/nicotine = 1)

/obj/item/food/cheesiehonkers
	name = "сырные хонкеры"
	desc = "Сырные закуски, от которых ты будешь хонкать."
	icon_state = "cheesie_honkers"
	trash_type = /obj/item/trash/cheesie
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3)
	junkiness = 25
	tastes = list("сыр" = 5, "чипсы" = 2)
	foodtypes = JUNKFOOD | DAIRY | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/syndicake
	name = "синди-кейки"
	icon_state = "syndi_cakes"
	desc = "Очень влажные кексы, вкус такой же, как и после ядерного взрыва."
	trash_type = /obj/item/trash/syndi_cakes
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/doctor_delight = 5)
	tastes = list("сладость" = 3, "торт" = 1)
	foodtypes = GRAIN | FRUIT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/energybar
	name = "мощные энергетические батончики"
	icon_state = "energybar"
	desc = "Энергетический батончик, который, вероятно, не стоит есть."
	trash_type = /obj/item/trash/energybar
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/liquidelectricity = 3)
	tastes = list("электричество" = 3, "фитнес" = 2)
	foodtypes = TOXIC
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/peanuts
	name = "ореховый микс"
	desc = "Фаворит среди неизлечимо злых людей."
	icon_state = "peanuts"
	trash_type = /obj/item/trash/peanuts
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("peanuts" = 4, "anger" = 1)
	foodtypes = JUNKFOOD | NUTS
	custom_price = PAYCHECK_ASSISTANT * 0.8 //nuts are expensive in real life, and this is the best food in the vendor.
	junkiness = 10 //less junky than other options, since peanuts are a decently healthy snack option
	w_class = WEIGHT_CLASS_SMALL
	grind_results = list(/datum/reagent/consumable/peanut_butter = 5, /datum/reagent/consumable/cooking_oil = 2)
	var/safe_for_consumption = TRUE
	preserved_food = TRUE

/obj/item/food/peanuts/salted
	name = "соленый ореховый микс"
	desc = "Ммм, солёный."
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/salt = 1)
	tastes = list("peanuts" = 3, "salt" = 1, "high blood pressure" = 1)

/obj/item/food/peanuts/wasabi
	name = "ореховый микс с васаби"
	desc = "Острейший арахис."
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/capsaicin = 1)
	tastes = list("peanuts" = 3, "wasabi" = 1, "rage" = 1)

/obj/item/food/peanuts/honey_roasted
	name = "сладкий ореховый микс"
	desc = "Очень странная горечь для сладкого арахиса."
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 1)
	tastes = list("peanuts" = 3, "honey" = 1, "bitterness" = 1)

/obj/item/food/peanuts/barbecue
	name = "ореховый микс со вкусом барбекю"
	desc = "Не бывает дыма без огня? Бывает, просто иногда это соус барбекю."
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/bbqsauce = 1)
	tastes = list("peanuts" = 3, "bbq sauce" = 1, "arguments" = 1)

/obj/item/food/peanuts/ban_appeal
	name = "ореховый микс \"Ban Appel\""
	desc = "Злаполучная смесь, запрещенная в 6 секторах."
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/cyanide = 1) //uses dried poison apples
	tastes = list("peanuts" = 3, "apples" = 1, "regret" = 1)
	safe_for_consumption = FALSE

/obj/item/food/peanuts/random
	name = "ореховый микс"
	desc = "Угадай, с каким он будет вкусом?"
	icon_state = "peanuts"
	safe_for_consumption = FALSE

/obj/item/food/cnds
	name = "M&M’s"
	desc = "Юридически мы не можем утверждать, что они не растают в ваших руках."
	icon_state = "cnds"
	trash_type = /obj/item/trash/cnds
	food_reagents = list(/datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/coco = 1)
	tastes = list("chocolate candy" = 3)
	junkiness = 25
	foodtypes = JUNKFOOD
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE

/obj/item/food/cnds/suicide_act(mob/user)
	. = ..()
	user.visible_message(span_suicide("[user] is letting [src] melt in [user.p_their()] hand! It looks like [user.p_theyre()] trying to commit suicide!"))
	return TOXLOSS

/obj/item/food/cnds/random
	name = "M&M’s \"Случайный вкус\""
	desc = "Наполнен одним из четырех восхитительных вкусов!"

/obj/item/food/cnds/random/Initialize(mapload)
	var/random_flavour = pick(subtypesof(/obj/item/food/cnds) - /obj/item/food/cnds/random)
	var/obj/item/food/sample = new random_flavour(loc)
	name = sample.name
	desc = sample.desc
	food_reagents = sample.food_reagents
	tastes = sample.tastes
	qdel(sample)
	. = ..()
