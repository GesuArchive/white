/obj/item/food/soup
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/obj/food/soupsalad.dmi'
	trash_type = /obj/item/reagent_containers/glass/bowl
	bite_consumption = 5
	max_volume = 80
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("безвкусный суп" = 1)
	foodtypes = VEGETABLES
	eatverbs = list("slurp","sip","inhale","drink")
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/soup/wish
	name = "суп желания"
	desc = "Желаю, чтобы это было супом."
	icon_state = "wishsoup"
	food_reagents = list(/datum/reagent/water = 10)
	tastes = list("мечты" = 1)

/obj/item/food/soup/wish/Initialize(mapload)
	. = ..()
	var/wish_true = prob(25)
	if(wish_true)
		desc = "Желание сбылось!"
		reagents.add_reagent(/datum/reagent/consumable/nutriment, 9)
		reagents.add_reagent(/datum/reagent/consumable/nutriment/vitamin, 1)

/obj/item/food/soup/meatball
	name = "суп с фрикадельками"
	desc = "Закончились спагетти? Не любите тушеное мясо? Это то, что вам нужно."
	icon_state = "meatballsoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 8, /datum/reagent/water = 5)
	tastes = list("мясо" = 1)
	foodtypes = MEAT
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/soup/slime
	name = "Слаймовый суп"
	desc = "Если воды нет, ее можно заменить слезами."
	icon_state = "slimesoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/toxin/slimejelly = 10, /datum/reagent/consumable/nutriment/vitamin = 9, /datum/reagent/water = 5)
	tastes = list("слаймы" = 1)
	foodtypes = TOXIC | SUGAR
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/soup/blood
	name = "томатный суп"
	desc = "Почему-то пахнет железом."
	icon_state = "tomatosoup"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/blood = 10, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("железо" = 1)
	foodtypes = GROSS

/obj/item/food/soup/wingfangchu
	name = "суньвыньчу"
	desc = "Пикантное блюдо из инопланетного сунь-вынь в соевом соусе."
	icon_state = "wingfangchu"
	trash_type = /obj/item/reagent_containers/glass/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 9, /datum/reagent/consumable/soysauce = 10, /datum/reagent/consumable/nutriment/vitamin = 7)
	tastes = list("соя" = 1)
	foodtypes = MEAT

/obj/item/food/soup/clownstears
	name = "слезы клоуна"
	desc = "Не очень смешно."
	icon_state = "clownstears"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/banana = 10, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 16, /datum/reagent/consumable/clownstears = 10)
	tastes = list("плохая шутка" = 1)
	foodtypes = FRUIT | SUGAR

/obj/item/food/soup/vegetable
	name = "овощной суп"
	desc = "Для настоящих веганов."
	icon_state = "vegetablesoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 8)
	tastes = list("овощи" = 1)
	foodtypes = VEGETABLES
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/soup/nettle
	name = "суп из крапивы"
	desc = "Подумать только, ботаник забил бы тебя до смерти одной из этих..."
	icon_state = "nettlesoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 9, /datum/reagent/medicine/omnizine = 5)
	tastes = list("крапива" = 1)
	foodtypes = VEGETABLES
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/soup/mystery
	name = "мистический суп"
	desc = "Загадка в том, почему вы его не едите?"
	icon_state = "mysterysoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 5)
	tastes = list("хаос" = 1)

/obj/item/food/soup/mystery/Initialize(mapload)
	. = ..()
	var/extra_reagent = null
	extra_reagent = pick(/datum/reagent/consumable/capsaicin, /datum/reagent/consumable/frostoil, /datum/reagent/medicine/omnizine, /datum/reagent/consumable/banana, /datum/reagent/blood, /datum/reagent/toxin/slimejelly, /datum/reagent/toxin, /datum/reagent/consumable/banana, /datum/reagent/carbon, /datum/reagent/medicine/oculine)
	reagents.add_reagent(extra_reagent, 5)
	reagents.add_reagent(/datum/reagent/consumable/nutriment, 6)

/obj/item/food/soup/hotchili
	name = "рагу из острого перца"
	desc = "Оно настолькое острое, что тебе стоит вызвать пожарную бригаду!"
	icon_state = "hotchili"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/capsaicin = 3, /datum/reagent/consumable/tomatojuice = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("перцы" = 1)
	foodtypes = VEGETABLES | MEAT
	venue_value = FOOD_PRICE_NORMAL
/obj/item/food/soup/coldchili
	name = "рагу из ледяного чили"
	desc = "Это месиво едва жидкое!"
	icon_state = "coldchili"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/frostoil = 3, /datum/reagent/consumable/tomatojuice = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("томаты" = 1, "мята" = 1)
	foodtypes = VEGETABLES | MEAT

/obj/item/food/soup/clownchili
	name = "чили кон карнивал"
	desc = "Вкусное рагу из мяса, чили и ...соленых слез клоуна.."
	icon_state = "clownchili"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/capsaicin = 1, /datum/reagent/consumable/tomatojuice = 4, /datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/consumable/banana = 1, /datum/reagent/consumable/laughter = 1)
	tastes = list("томаты" = 1, "перцы" = 2, "нога клоуна" = 2, "немного веселья" = 2, "чьи-то родители" = 2)
	foodtypes = VEGETABLES | MEAT

/obj/item/food/soup/monkeysdelight
	name = "обезьяний восторг"
	desc = "Вкусный суп с клецками и кусками обезьяньего мяса."
	icon_state = "monkeysdelight"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3,  /datum/reagent/consumable/nutriment/protein = 9, /datum/reagent/consumable/banana = 5, /datum/reagent/consumable/nutriment/vitamin = 10)
	tastes = list("джунгли" = 1, "банан" = 1)
	foodtypes = FRUIT
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/soup/tomato
	name = "томатный суп"
	desc = "Пить это - все равно что быть вампиром! Томатным вампиром..."
	icon_state = "tomatosoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/tomatojuice = 10, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("томаты" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/tomato/eyeball
	name = "суп с глазными яблоками"
	desc = "Он смотрит прямо в душу..."
	icon_state = "eyeballsoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/tomatojuice = 10, /datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/liquidgibs = 3)
	tastes = list("томаты" = 1, "squirming" = 1)
	foodtypes = MEAT | GROSS

/obj/item/food/soup/milo
	name = "мисосиру"
	desc = "Лучший суп во вселенной! ВКУСНЯТИНА!!!"
	icon_state = "milosoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("сорго" = 1) // wtf is milo //i don't know either but hey i guess japanese tourists will order it
	foodtypes = VEGETABLES
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/soup/mushroom
	name = "грибной суп"
	desc = "Вкусный и сытный грибной суп."
	icon_state = "mushroomsoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("грибы" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/beet
	name = "борщ"
	desc = "Накормите своего внутреннего русского борщом."
	icon_state = "beetsoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 6)
	foodtypes = VEGETABLES

/obj/item/food/soup/beet/Initialize(mapload)
	. = ..()
	name = "борщ"
	tastes = "борщ"


/obj/item/food/soup/spacylibertyduff
	name = "наркотическая фригийская шняга"
	desc = "По рецепту Альфреда Хаббарда."
	icon_state = "spacylibertyduff"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/drug/mushroomhallucinogen = 6, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("желе" = 1, "грибы" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/amanitajelly
	name = "мухоморное желе"
	desc = "Выглядит ядовидым."
	icon_state = "amanitajelly"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/drug/mushroomhallucinogen = 3, /datum/reagent/toxin/amatoxin = 6, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("желе" = 1, "грибы" = 1)
	foodtypes = VEGETABLES | TOXIC

/obj/item/food/soup/stew
	name = "стью"
	desc = "Вкусное и теплое рагу."
	icon_state = "stew"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/medicine/oculine = 5, /datum/reagent/consumable/tomatojuice = 10, /datum/reagent/consumable/nutriment/vitamin = 6)
	bite_consumption = 7
	max_volume = 100
	tastes = list("томаты" = 1, "морковь" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/sweetpotato
	name = "суп из сладкого картофеля"
	desc = "Вкусный сладкий картофель в виде супа."
	icon_state = "sweetpotatosoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 12, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("сладкая картоха" = 1)
	foodtypes = VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_NORMAL
/obj/item/food/soup/beet/red
	name = "свекольник"
	desc = "Настоящий деликатес."
	icon_state = "redbeetsoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 12, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("свекла" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/onion
	name = "французский луковый суп"
	desc = "Достаточно хорош, чтобы заставить мима заплакать."
	icon_state = "onionsoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/medicine/oculine = 5, /datum/reagent/consumable/tomatojuice = 8, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("карамелизированный лук" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/bisque
	name = "биск"
	desc = "Классическое блюдо из Космо-Франции."
	icon_state = "bisque"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/water = 5, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("кремовая текстура" = 1, "краб" = 4)
	foodtypes = MEAT
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/soup/electron
	name = "электризованный суп"
	desc = "Гастрономическая диковинка неземного происхождения. Славится миниатюрным облачком, образующимся над правильно приготовленным супом.."
	icon_state = "electronsoup"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/liquidelectricity = 5)
	tastes = list("грибы" = 1, "электроны" = 4)
	foodtypes = VEGETABLES | TOXIC

/obj/item/food/soup/bungocurry
	name = "бунго карри"
	desc = "Острый овощной карри, приготовленный из скромного фрукта бунго, Экзотика!"
	icon_state = "bungocurry"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/bungojuice = 9, /datum/reagent/consumable/capsaicin = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("бунго" = 2, "горячее карри" = 4, "тропическая сладость" = 1)
	foodtypes = VEGETABLES | FRUIT | DAIRY

/obj/item/food/soup/mammi
	name = "мямми"
	desc = "Миска кашеобразного хлеба с молоком. Напоминает, если без приукрашивания, дерьмо."
	icon_state = "mammi"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/nutriment/vitamin = 2)

/obj/item/food/soup/peasoup
	name = "гороховый суп"
	desc = "Обычный гороховый суп."
	icon_state = "peasoup"
	food_reagents = list (/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/medicine/oculine = 2)
	tastes = list("creamy peas"= 2, "parsnip" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/oatmeal
	name = "овсянка"
	desc = "Хорошая порция овсянки."
	icon_state = "oatmeal"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/milk = 10, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("овёс" = 1, "молоко" = 1)
	foodtypes = DAIRY | GRAIN | BREAKFAST
