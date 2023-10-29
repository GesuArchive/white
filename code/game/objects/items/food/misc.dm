
////////////////////////////////////////////OTHER////////////////////////////////////////////

/obj/item/food/cheesewheel
	name = "головка сыра"
	desc = "Большая головка вкуснейшего чеддера."
	icon_state = "cheesewheel"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 5) //Hard cheeses contain about 25% protein
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("сыр" = 1)
	foodtypes = DAIRY

/obj/item/food/cheesewheel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/food_storage)

/obj/item/food/cheesewheel/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cheesewedge, 5, 30)

/obj/item/food/cheesewheel/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/baked_cheese, rand(20 SECONDS, 25 SECONDS), TRUE, TRUE)
/obj/item/food/royalcheese
	name = "королевский сыр"
	desc = "Взойди на трон. Съешь этот сыр. Почувствуй ВЛАСТЬ."
	icon_state = "royalcheese"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/gold = 20, /datum/reagent/toxin/mutagen = 5)
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("cheese" = 4, "royalty" = 1)
	foodtypes = DAIRY

/obj/item/food/cheesewedge
	name = "кусок сыра"
	desc = "Кусочек восхитительного Чеддера. Сырная головка, с которой он был срезан, не могла укатиться далеко."
	icon_state = "cheesewedge"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("сыр" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/watermelonslice
	name = "долька арбуза"
	desc = "Кусочек водянистого совершенства."
	icon_state = "watermelonslice"
	tastes = list("арбуз" = 1)
	food_reagents = list(/datum/reagent/water = 1, /datum/reagent/consumable/nutriment/vitamin = 0.2, /datum/reagent/consumable/nutriment = 1)
	foodtypes = FRUIT
	food_flags = FOOD_FINGER_FOOD
	juice_results = list(/datum/reagent/consumable/watermelonjuice = 5)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/candy_corn
	name = "леденцовая кукуруза"
	desc = "Это горсть леденцовой кукурузы. Может храниться в шляпе детектива."
	icon_state = "candy_corn"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 2)
	tastes = list("сладкий попкорн" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candy_corn/prison
	name = "сушеная леденцовая кукуруза"
	desc = "Если бы эта леденцовая кукуруза была более твердой, служба безопасности конфисковала бы ее как потенциальную заточку."
	force = 1 // the description isn't lying
	throwforce = 1 // if someone manages to bust out of jail with candy corn god bless them
	tastes = list("горький воск" = 1)
	foodtypes = GROSS

/obj/item/food/chocolatebar
	name = "шоколадка"
	desc = "Такая сладкая.. такая.. жирная.."
	icon_state = "chocolatebar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2)
	tastes = list("шоколад" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/hugemushroomslice
	name = "большая долька гриба"
	desc = "Долька с большого гриба."
	icon_state = "hugemushroomslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("грибы" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/popcorn
	name = "попкорн"
	desc = "Теперь давайте найдем какое-нибудь кино."
	icon_state = "popcorn"
	trash_type = /obj/item/trash/popcorn
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	bite_consumption = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	tastes = list("попкорн" = 3, "масло" = 1)
	foodtypes = JUNKFOOD
	eatverbs = list("кусает","надкусывает","чапает","пожирает","ест")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/loadedbakedpotato
	name = "печеный картофель с начинкой"
	desc = "Пропечен полностью."
	icon_state = "loadedbakedpotato"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("картоха" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fries
	name = "космический картофель фри"
	desc = "Вкусно и точка."
	icon_state = "fries"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("картофель фри" = 3, "соль" = 1)
	foodtypes = VEGETABLES | GRAIN | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/fries/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/tatortot
	name = "драники"
	desc = "Натёртый сырой картофель, пожареный на масле."
	icon_state = "tatortot"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("картоха" = 3, "valids" = 1)
	foodtypes = FRIED | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tatortot/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/soydope
	name = "соевая добавка"
	desc = "Добавка из сои."
	icon_state = "soydope"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("соя" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheesyfries
	name = "сырное фри"
	desc = "Картошка фри. В сыре. Ага."
	icon_state = "cheesyfries"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("картофель фри" = 3, "сыр" = 1)
	foodtypes = VEGETABLES | GRAIN | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cheesyfries/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/badrecipe
	name = "сгоревшая масса"
	desc = "Стоит уволить повара, который это приготовил."
	icon_state = "badrecipe"
	food_reagents = list(/datum/reagent/toxin/bad_food = 30)
	foodtypes = GROSS
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE //Can't decompose any more than this

/obj/item/food/badrecipe/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_GRILLED, PROC_REF(OnGrill))

/obj/item/food/badrecipe/moldy
	name = "гниль"
	desc = "Фу."
	food_reagents = list(/datum/reagent/consumable/mold = 30)
	color = "#781948"

/obj/item/food/badrecipe/moldy/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 25)

///Prevents grilling burnt shit from well, burning.
/obj/item/food/badrecipe/proc/OnGrill()
	return COMPONENT_HANDLED_GRILLING

/obj/item/food/carrotfries
	name = "морковка фри"
	desc = "Вкусное фри из свежей моркови."
	icon_state = "carrotfries"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/medicine/oculine = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("морковка" = 3, "соль" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/carrotfries/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/candiedapple
	name = "карамелизированное яблоко"
	desc = "Яблоко, покрытое сахарным сиропом."
	icon_state = "candiedapple"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/caramel = 5)
	tastes = list("яблоко" = 2, "карамель" = 3)
	foodtypes = JUNKFOOD | FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mint
	name = "мята"
	desc = "Это всего лишь тонкая пластинка."
	icon_state = "mint"
	bite_consumption = 1
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/toxin/minttoxin = 2)
	foodtypes = TOXIC | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/eggwrap
	name = "яичная обертка"
	desc = "Предшественник сосисок в тесте."
	icon_state = "eggwrap"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("яйцо" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spidereggs
	name = "паучьи яйца"
	desc = "Скопление сочных паучьих яиц. Отличный гарнир для тех случаев, когда вы не заботитесь о своем здоровье."
	icon_state = "spidereggs"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin = 2)
	tastes = list("паутина" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spiderling
	name = "спайдерлинг"
	desc = "Он слегка подрагивает лапками в вашей руке. Фу...."
	icon_state = "spiderling"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/toxin = 4)
	tastes = list("паутина" = 1, "кишочки" = 2)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/chewable/spiderlollipop
	name = "паучий леденец"
	desc = "Все равно противно, но, по крайней мере, на нем есть гора сахара."
	icon_state = "spiderlollipop"
	worn_icon_state = "lollipop_stick"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/toxin = 1, /datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/omnizine = 2) //lollipop, but vitamins = toxins
	tastes = list("паутина" = 1, "сахар" = 2)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK

/obj/item/food/chococoin
	name = "шоколадная монетка"
	desc = "Полностью съедобная монетка."
	icon_state = "chococoin"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/coco = 1, /datum/reagent/consumable/sugar = 1)
	tastes = list("шоколад" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fudgedice
	name = "помадный кубик"
	desc = "У вас появится шоколадная помадка на губах после его поедания."
	icon_state = "chocodice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/coco = 1, /datum/reagent/consumable/sugar = 1)
	trash_type = /obj/item/dice/fudge
	tastes = list("помадка" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/chocoorange
	name = "шоколадный апельсин"
	desc = "Фестивальное угощение."
	icon_state = "chocoorange"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 1)
	tastes = list("шоколад" = 3, "апельсины" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/eggplantparm
	name = "баклажанная пармиджана"
	desc = "Единственный хороший рецепт приготовления баклажанов."
	icon_state = "eggplantparm"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("баклажан" = 3, "сыр" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tortilla
	name = "тортилья"
	desc = "Основа для всех буррито."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "tortilla"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("плоская маисовая лепешка" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/burrito
	name = "буррито"
	desc = "Вкуснятина, завернутая в тортилью."
	icon_state = "burrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2,/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 3)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/cheesyburrito
	name = "сырное буррито"
	desc = "Буррито, наполненное сыром."
	icon_state = "cheesyburrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 3, "сыр" = 1)
	foodtypes = GRAIN | MEAT | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/carneburrito
	name = "буррито Карне Асада"
	desc = "Лучшее бурито для любителей мяса."
	icon_state = "carneburrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 4)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/fuegoburrito
	name = "огненно-плазменный буррито"
	desc = "Очень острый буррито."
	icon_state = "fuegoburrito"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/capsaicin = 5, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("плоская маисовая лепешка" = 2, "мясо" = 3, "перцы" = 1)
	foodtypes = GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_LEGENDARY

/obj/item/food/yakiimo
	name = "яки-имо"
	desc = "Приготовлено из жареного сладкого картофеля!"
	icon_state = "yakiimo"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("сладкая картоха" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/roastparsnip
	name = "жаренный пастернак"
	desc = "Сладкий и хрустящий."
	icon_state = "roastparsnip"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пастернак" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/nachos
	name = "начос"
	desc = "Чипсы из Космо-Мексики."
	icon_state = "nachos"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("начос" = 1)
	foodtypes = VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cheesynachos
	name = "сырные начос"
	desc = "Вкуснейшее сочетание начос и плавящегося сыра."
	icon_state = "cheesynachos"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("начос" = 2, "сыр" = 1)
	foodtypes = VEGETABLES | FRIED | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/cubannachos
	name = "кубинские начос"
	desc = "Опасно острые начос."
	icon_state = "cubannachos"
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/capsaicin = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("начос" = 2, "перец" = 1)
	foodtypes = VEGETABLES | FRIED | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/melonkeg
	name = "бочонок из дыни"
	desc = "Кто ж знал, что водка - это фрукт?"
	icon_state = "melonkeg"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/ethanol/vodka = 15, /datum/reagent/consumable/nutriment/vitamin = 4)
	max_volume = 80
	bite_consumption = 5
	tastes = list("зерновой спирт" = 1, "фрукты" = 1)
	foodtypes = FRUIT | ALCOHOL

/obj/item/food/honeybar
	name = "медово-ореховый батончик"
	desc = "Овсянка и орехи спрессованые в батончик, скрепленный медовой глазурью."
	icon_state = "honeybar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/honey = 5)
	tastes = list("овес" = 3, "орешки" = 2, "мед" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stuffedlegion
	name = "фаршированный Легион"
	desc = "Использование черепов в качестве мисок для еды еще никогда не казалось таким подходящим."
	icon_state = "stuffed_legion"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/capsaicin = 2)
	tastes = list("смерть" = 2, "камни" = 1, "мясо" = 1, "перцы" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_LEGENDARY

/obj/item/food/powercrepe
	name = "боевой блин"
	desc = "С большой силой приходит большой блин."
	icon_state = "powercrepe"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/cherryjelly = 5)
	force = 30
	throwforce = 15
	block_chance = 55
	armour_penetration = 80
	wound_bonus = -50
	attack_verb_continuous = list("шлёпает", "рубит")
	attack_verb_simple = list("шлёпает", "рубит")
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("вишня" = 1, "креп" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

///Shit typepath to allow you to suck on shit. Like the coder of this code probably did to penis.
/obj/item/food/chewable
	slot_flags = ITEM_SLOT_MASK
	///How long it lasts before being deleted in seconds
	var/succ_dur = 360
	///The delay between each time it will handle reagents
	var/succ_int = 100
	///Stores the time set for the next handle_reagents
	var/next_succ = 0

	//makes snacks actually wearable as masks and still edible the old-fashioned way.
/obj/item/food/chewable/proc/handle_reagents()
	if(reagents.total_volume)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				if(!reagents.trans_to(C, REAGENTS_METABOLISM, methods = INGEST))
					reagents.remove_any(REAGENTS_METABOLISM)
				return
		reagents.remove_any(REAGENTS_METABOLISM)

/obj/item/food/chewable/process(delta_time)
	if(iscarbon(loc))
		if(succ_dur <= 0)
			qdel(src)
			return
		succ_dur -= delta_time
		if((reagents?.total_volume) && (next_succ <= world.time))
			handle_reagents()
			next_succ = world.time + succ_int

/obj/item/food/chewable/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_MASK)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/food/chewable/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/food/chewable/lollipop
	name = "леденец"
	desc = "Вкусный леденец. Подойдет для отличного подарка на День Святого Валентина."
	icon = 'icons/obj/lollipop.dmi'
	icon_state = "lollipop_stick"
	inhand_icon_state = "lollipop_stick"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/omnizine = 2)	//Honk
	var/mutable_appearance/head
	var/headcolor = rgb(0, 0, 0)
	tastes = list("конфета" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chewable/lollipop/Initialize(mapload)
	. = ..()
	head = mutable_appearance('icons/obj/lollipop.dmi', "lollipop_head")
	change_head_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))

/obj/item/food/chewable/lollipop/proc/change_head_color(C)
	headcolor = C
	cut_overlay(head)
	head.color = C
	add_overlay(head)

/obj/item/food/chewable/lollipop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..(hit_atom)
	throw_speed = 1
	throwforce = 0

/obj/item/food/chewable/lollipop/cyborg
	var/spamchecking = TRUE

/obj/item/food/chewable/lollipop/cyborg/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(spamcheck)), 1200)

/obj/item/food/chewable/lollipop/cyborg/equipped(mob/living/user, slot)
	. = ..(user, slot)
	spamchecking = FALSE

/obj/item/food/chewable/lollipop/cyborg/proc/spamcheck()
	if(spamchecking)
		qdel(src)

/obj/item/food/chewable/bubblegum
	name = "жвачка"
	desc = "Резиновая полоска жвачки. Не совсем насыщает, но держит вас в тонусе."
	icon_state = "bubblegum"
	inhand_icon_state = "bubblegum"
	color = "#E48AB5" // craftable custom gums someday?
	food_reagents = list(/datum/reagent/consumable/sugar = 5)
	tastes = list("конфета" = 1)
	succ_dur = 15 * 60
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chewable/bubblegum/nicotine
	name = "никотиновая жвачка"
	food_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/consumable/menthol = 5)
	tastes = list("мята" = 1)
	color = "#60A584"

/obj/item/food/chewable/bubblegum/happiness
	name = "HP+ жвачка"
	desc = "Резиновая полоска жвачки. Пахнет забавно."
	food_reagents = list(/datum/reagent/drug/happiness = 15)
	tastes = list("растворитель" = 1)
	color = "#EE35FF"

/obj/item/food/chewable/bubblegum/bubblegum
	name = "резиновая жвачка"
	desc = "Резиновая полоска жвачки. Кажется, что есть ее - не лучшая идея."
	color = "#913D3D"
	food_reagents = list(/datum/reagent/blood = 15)
	tastes = list("ад" = 1)
	succ_dur = 6 * 60

/obj/item/food/chewable/bubblegum/bubblegum/process()
	. = ..()
	if(iscarbon(loc))
		hallucinate(loc)

/obj/item/food/chewable/bubblegum/bubblegum/MakeEdible()
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
				on_consume = CALLBACK(src, PROC_REF(OnConsume)))

/obj/item/food/chewable/bubblegum/bubblegum/proc/OnConsume(mob/living/eater, mob/living/feeder)
	if(iscarbon(eater))
		hallucinate(eater)

///This proc has a 5% chance to have a bubblegum line appear, with an 85% chance for just text and 15% for a bubblegum hallucination and scarier text.
/obj/item/food/chewable/bubblegum/bubblegum/proc/hallucinate(mob/living/carbon/victim)
	if(!prob(5)) //cursed by bubblegum
		return
	if(prob(15))
		new /datum/hallucination/oh_yeah(victim)
		to_chat(victim, span_colossus("<b>[pick("Я БЕССМЕРТЕН.","Я ЗАБЕРУ ТВОЙ МИР.","Я ТЕБЯ ВИЖУ.","ТЫ НЕ СМОЖЕШЬ СПРЯТАТЬСЯ ОТ МЕНЯ.","НИЧТО НЕ МОЖЕТ УДЕРЖАТЬ МЕНЯ.")]</b>"))
	else
		to_chat(victim, span_warning("[pick("Я слышу тихий шепот.","Я чувствую запах пепла.","Мне жарко.","Я слышу рев вдали.")]"))

/obj/item/food/chewable/gumball
	name = "жвачка"
	desc = "Красочный, сладкий шарик жвачки."
	icon = 'icons/obj/lollipop.dmi'
	icon_state = "gumball"
	worn_icon_state = "bubblegum"
	food_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/sal_acid = 2, /datum/reagent/medicine/oxandrolone = 2)	//Kek
	tastes = list("конфета")
	foodtypes = JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/chewable/gumball/Initialize(mapload)
	. = ..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))

/obj/item/food/chewable/gumball/cyborg
	var/spamchecking = TRUE

/obj/item/food/chewable/gumball/cyborg/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(spamcheck)), 1200)

/obj/item/food/chewable/gumball/cyborg/equipped(mob/living/user, slot)
	. = ..(user, slot)
	spamchecking = FALSE

/obj/item/food/chewable/gumball/cyborg/proc/spamcheck()
	if(spamchecking)
		qdel(src)

/obj/item/food/taco
	name = "классическое тако"
	desc = "Традиционное тако с мясом, сыром и салатом."
	icon_state = "taco"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("тако" = 4, "мясо" = 2, "сыр" = 2, "салат" = 1)
	foodtypes = MEAT | DAIRY | GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/taco/plain
	name = "тако"
	desc = "Традиционное тако с мясом и сыром, за вычетом кроличьего корма."
	icon_state = "taco_plain"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("тако" = 4, "мясо" = 2, "сыр" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/branrequests
	name = "сухой завтрак с отрубями"
	desc = "Сухия хлопья, идеальны для завтрака. Вкус уникален: изюм и соль."
	icon_state = "bran_requests"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/salt = 8)
	tastes = list("отруби" = 4, "причинычи" = 3, "соль" = 1)
	foodtypes = GRAIN | FRUIT | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter
	name = "кусочек сливочного масла"
	desc = "Палочка вкусной, золотистой, жирной пользы."
	icon_state = "butter"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("масло" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Если у вас есть стержень, вы можете сделать <b>масло на палочке</b>.</span>"

/obj/item/food/butter/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if(!R.use(1))//borgs can still fail this if they have no metal
			to_chat(user, span_warning("Мне не хватает железа, чтобы насадить [src] на палку!"))
			return ..()
		to_chat(user, span_notice("Я втыкаю стержень в кусочек масла."))
		var/obj/item/food/butter/on_a_stick/new_item = new(usr.loc)
		var/replace = (user.get_inactive_held_item() == R)
		if(!R && replace)
			user.put_in_hands(new_item)
		qdel(src)
		return TRUE
	..()

/obj/item/food/butter/on_a_stick //there's something so special about putting it on a stick.
	name = "масло на палочке"
	desc = "Вкусное, золотистое, жирное лакомство на палочке."
	icon_state = "butteronastick"
	trash_type = /obj/item/stack/rods
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/onionrings
	name = "луковые кольца"
	desc = "Луковые кольца в кляре."
	icon_state = "onionrings"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	gender = PLURAL
	tastes = list("кляр" = 3, "лук" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/pineappleslice
	name = "долька ананаса"
	desc = "Отрезанный кусочек сочного ананаса."
	icon_state = "pineapple_slice"
	juice_results = list(/datum/reagent/consumable/pineapplejuice = 3)
	tastes = list("ананас" = 1)
	foodtypes = FRUIT | PINEAPPLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/tinychocolate
	name = "шоколад"
	desc = "Маленький и сладкий шоколад."
	icon_state = "tiny_chocolate"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/coco = 1)
	tastes = list("шоколад" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/canned
	name = "консервированный воздух"
	desc = "Если вы когда-нибудь задумывались, откуда берется воздух..."
	food_reagents = list(/datum/reagent/oxygen = 6, /datum/reagent/nitrogen = 24)
	icon = 'icons/obj/food/canned.dmi'
	icon_state = "peachcan"
	food_flags = FOOD_IN_CONTAINER
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 30
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE


/obj/item/food/canned/proc/open_can(mob/user)
	to_chat(user, span_notice("Тяну колечко от крышки <b>[src.name]</b>."))
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	reagents.flags |= OPENCONTAINER
	preserved_food = FALSE
	MakeDecompose()

/obj/item/food/canned/attack_self(mob/user)
	if(!is_drainable())
		open_can(user)
		icon_state = "[icon_state]_open"
	return ..()

/obj/item/food/canned/attack(mob/living/M, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, span_warning("[capitalize(src.name)] не вскрыта!"))
		return FALSE
	return ..()

/obj/item/food/canned/beans
	name = "консвервированные бобы"
	desc = "Музыкальный фрукт в чуть менее музыкальном контейнере."
	icon_state = "beans"
	trash_type = /obj/item/trash/can/food/beans
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 9, /datum/reagent/consumable/ketchup = 4)
	tastes = list("бобы" = 1)
	foodtypes = VEGETABLES

/obj/item/food/canned/peaches
	name = "консервированные персики"
	desc = "Красивая банка спелых персиков, плавающих в собственном соку."
	icon_state = "peachcan"
	trash_type = /obj/item/trash/can/food/peaches
	food_reagents = list(/datum/reagent/consumable/peachjuice = 20, /datum/reagent/consumable/sugar = 8, /datum/reagent/consumable/nutriment = 2)
	tastes = list("персики" = 7, "олово" = 1)
	foodtypes = FRUIT | SUGAR

/obj/item/food/canned/peaches/maint
	name = "персики для тех. обслуживания"
	desc = "У меня есть рот, и я должен есть."
	icon_state = "peachcanmaint"
	trash_type = /obj/item/trash/can/food/peaches/maint
	tastes = list("персики" = 1, "олово" = 7)

/obj/item/food/canned/tomatoes
	name = "консервированные помидоры San Marzano"
	desc = "Банка первоклассных томатов San Marzano с холмов Южной Италии."
	icon_state = "tomatoescan"
	trash_type = /obj/item/trash/can/food/tomatoes
	food_reagents = list(/datum/reagent/consumable/tomatojuice = 20, /datum/reagent/consumable/salt = 2)
	tastes = list("tomato" = 7, "tin" = 1)
	foodtypes = VEGETABLES //fuck you, real life!

/obj/item/food/canned/pine_nuts
	name = "консервированные кедровые орехи"
	desc = "Небольшая банка кедровых орехов. Можно есть сами по себе, если вам такое нравится."
	icon_state = "pinenutscan"
	trash_type = /obj/item/trash/can/food/pine_nuts
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("pine nuts" = 1)
	foodtypes = NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/crab_rangoon
	name = "крабовый рангун"
	desc = "У него много названий: крабовые слойки, сырные вонтоны, крабовые пельмени? Как бы вы его ни называли, это потрясающая комбинация сливочного сыра с крабовым мясом."
	icon_state = "crabrangoon"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/nutriment/vitamin = 5)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("сливочный сыр" = 4, "краб" = 3, "хрупкость" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cornchips
	name = "кукурузные чипсы \"Boritos\""
	desc = "Треугольные кукурузные чипсы. Они кажутся немного безвкусными, но, вероятно, хорошо сочетаются с каким-нибудь соусом."
	icon_state = "boritos"
	trash_type = /obj/item/trash/boritos
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/cooking_oil = 2, /datum/reagent/consumable/salt = 3)
	junkiness = 20
	tastes = list("жареная кукуруза" = 1)
	foodtypes = JUNKFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cornchips/MakeLeaveTrash()
	if(trash_type)
		AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)


/obj/item/food/rationpack
	name = "сухой паёк"
	desc = "Квадратная плитка, которая, к сожалению, <i>выглядит</i> как шоколад, упакованная в серую обертку. Раньше спасал жизни солдат - обычно останавливая пули."
	icon_state = "rationpack"
	bite_consumption = 3
	junkiness = 15
	tastes = list("картон" = 3, "грусть" = 3)
	foodtypes = null //Don't ask what went into them. You're better off not knowing.
	food_reagents = list(/datum/reagent/consumable/nutriment/stabilized = 10, /datum/reagent/consumable/nutriment = 2) //Won't make you fat. Will make you question your sanity.

///Override for checkliked callback
/obj/item/food/rationpack/MakeEdible()
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
				check_liked = CALLBACK(src, PROC_REF(check_liked)))

/obj/item/food/rationpack/proc/check_liked(fraction, mob/M)	//Nobody likes rationpacks. Nobody.
	return FOOD_DISLIKED

/obj/item/food/ant_candy
	name = "муравьиная конфета"
	desc = "Колония муравьев, в затвердевшем сахаре. Эти твари мертвы, верно?"
	icon_state = "ant_pop"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/sugar = 5, /datum/reagent/ants = 3)
	tastes = list("candy" = 1, "insects" = 1)
	foodtypes = JUNKFOOD | SUGAR | GROSS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

//Curd cheese, a general term which I will now proceed to stretch as thin as the toppings on a supermarket sandwich:
//I'll use it as a substitute for ricotta, cottage cheese and quark, as well as any other non-aged, soft grainy cheese
/obj/item/food/curd_cheese
	name = "творожный сыр"
	desc = "Известный под многими названиями во всей человеческой кухне, творожный сыр полезен для приготовления самых разнообразных блюд."
	icon_state = "curd_cheese"
	microwaved_type = /obj/item/food/cheese_curds
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/cream = 1)
	tastes = list("cream" = 1, "cheese" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheese_curds
	name = "сырники"
	desc = "Не путать с творожным сыром. Вкусней во фритюре."
	icon_state = "cheese_curds"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("cheese" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheese_curds/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/firm_cheese)

/obj/item/food/firm_cheese
	name = "твердый сыр"
	desc = "Твердый выдержанный сыр, по текстуре схожий с твердым тофу. Практически не плавится."
	icon_state = "firm_cheese"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("aged cheese" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/firm_cheese/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/firm_cheese_slice, 3, 30)

/obj/item/food/firm_cheese_slice
	name = "кусок твёрдого сыра"
	desc = "Кусок твердого сыра. Идеально подходит для гриля или приготовления вкусного песто."
	icon_state = "firm_cheese_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("aged cheese" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/firm_cheese_slice/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_cheese, rand(25 SECONDS, 35 SECONDS), TRUE, TRUE)

/obj/item/food/mozzarella
	name = "моцарелла"
	desc = "Вкусный, сливочный и сырный, все в одной простой упаковке."
	icon_state = "mozzarella"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("mozzarella" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/pesto
	name = "песто"
	desc = "Сочетание твердого сыра, соли, трав, чеснока, масла и кедровых орехов. Часто используется в качестве соуса для пасты или пиццы, а также намазывается на хлеб."
	icon_state = "pesto"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("pesto" = 1)
	foodtypes = VEGETABLES | DAIRY | NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tomato_sauce
	name = "томатный соус"
	desc = "Томатный соус, идеально подходящий для пиццы или пасты. Mamma mia!"
	icon_state = "tomato_sauce"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("tomato" = 1, "herbs" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bechamel_sauce
	name = "соус Бешамель"
	desc = "Классический белый соус, характерный для нескольких Европейских культур."
	icon_state = "bechamel_sauce"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("cream" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/roasted_bell_pepper
	name = "жареный болгарский перец"
	desc = "Почерневший, запекшийся болгарский перец. Отлично подходит для приготовления соусов."
	icon_state = "roasted_bell_pepper"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/char = 1)
	tastes = list("bell pepper" = 1, "char" = 1)
	foodtypes = VEGETABLES
	burns_in_oven = TRUE

//DONK DINNER: THE INNOVATIVE WAY TO GET YOUR DAILY RECOMMENDED ALLOWANCE OF SALT... AND THEN SOME!
/obj/item/food/ready_donk
	name = "донк-покет \"Жрачка холостяка\""
	desc = "Быстрый Донк-обед: теперь не безвкусный!"
	icon_state = "ready_donk"
	trash_type = /obj/item/trash/ready_donk
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	microwaved_type = /obj/item/food/ready_donk/warm
	tastes = list("еда?" = 2, "лень" = 1)
	foodtypes = MEAT | JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/ready_donk/examine_more(mob/user)
	var/list/msg = list(span_notice("<i>Вы осматриваете обратную сторону упаковки...</i>"))
	msg += "\t[span_info("Готовый Донк-покет: продукт Donk Co.")]"
	msg += "\t[span_info("Инструкция по приготовлению: откройте коробку и проткните пленку, разогрейте в микроволновой печи на высокой мощности в течение 2 минут. Дайте постоять 60 секунд перед употреблением. Продукт будет горячим.")]"
	msg += "\t[span_info("На 200 г порции содержится: 8 г натрия; 25 г жиров, из которых 22 г насыщенных; 2 г сахара.")]"
	return msg

/obj/item/food/ready_donk/warm
	name = "донк-покет \"Жрачка холостяка\""
	desc = "Быстрый Донк-обед: теперь не безвкусный! Всё ещё горячий!"
	icon_state = "ready_donk_warm"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/omnizine = 3)
	microwaved_type = null
	tastes = list("еда?" = 2, "лень" = 1)

/obj/item/food/ready_donk/mac_n_cheese
	name = "донк-покет: \"Донкеронни\""
	desc = "Неоново-оранжевые макароны с сыром за считанные секунды!"
	microwaved_type = /obj/item/food/ready_donk/warm/mac_n_cheese
	tastes = list("макароны с сыром" = 2, "лень" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD

/obj/item/food/ready_donk/warm/mac_n_cheese
	name = "тёплый донк-покет \"Донкеронни\""
	desc = "Неоново-оранжевые макароны с сыром, готовы к употреблению!"
	icon_state = "ready_donk_warm_mac"
	tastes = list("макароны с сыром" = 2, "лень" = 1)
	foodtypes = GRAIN | DAIRY | JUNKFOOD

/obj/item/food/ready_donk/donkhiladas
	name = "донк-покет \"Донкхиладас\""
	desc = "Фирменные \"Донкхиладас\" от Donk Co с соусом Donk с \"настоящим\" вкусом Мексики"
	microwaved_type = /obj/item/food/ready_donk/warm/donkhiladas
	tastes = list("энчилада" = 2, "лень" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | VEGETABLES | JUNKFOOD

/obj/item/food/ready_donk/warm/donkhiladas
	name = "тёплый донк-покет \"Донкхиладас\""
	desc = "Donk Co's signature Donkhiladas with Donk sauce, served as hot as the Mexican sun."
	icon_state = "ready_donk_warm_mex"
	tastes = list("энчилада" = 2, "лень" = 1)
	foodtypes = GRAIN | DAIRY | MEAT | VEGETABLES | JUNKFOOD
