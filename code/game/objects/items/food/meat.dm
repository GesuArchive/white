//Not only meat, actually, but also snacks that are almost meat, such as fish meat or tofu


////////////////////////////////////////////FISH////////////////////////////////////////////

/obj/item/food/cubancarp
	name = "кубинский карп"
	desc = "Вкусный сэндвич, который обжигает язык!"
	icon_state = "cubancarp"
	trash_type = /obj/item/trash/plate
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6,  /datum/reagent/consumable/capsaicin = 1, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("рыба" = 4, "кляр" = 1, "перцы" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fishmeat
	name = "рыбное филе"
	desc = "Филе из мяса рыбы."
	icon_state = "fishfillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	bite_consumption = 6
	tastes = list("рыба" = 1)
	foodtypes = MEAT
	eatverbs = list("bite","chew","gnaw","swallow","chomp")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fishmeat/carp
	name = "филе карпа"
	desc = "Филе космчисекого карпа."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin/carpotoxin = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	/// Cytology category you can swab the meat for.
	var/cell_line = CELL_LINE_TABLE_CARP

/obj/item/food/fishmeat/carp/Initialize(mapload)
	. = ..()
	if(cell_line)
		AddElement(/datum/element/swabable, cell_line, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/fishmeat/carp/imitation
	name = "имитация филе карпа"
	desc = "Почти как настоящее, вроде как."
	cell_line = null

/obj/item/food/fishmeat/moonfish
	name = "филе рыбы-луны"
	desc = "Филе рыбы-луны."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "moonfish_fillet"

/obj/item/food/fishmeat/moonfish/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_moonfish, rand(40 SECONDS, 50 SECONDS), TRUE, TRUE)

//Fish Dishes
/obj/item/food/grilled_moonfish
	name = "рыба-луна на гриле"
	desc = "Кусок рыбы-луны на гриле. Традиционно подается поверх гребешков с соусом на основе вина."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "grilled_moonfish"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("fish" = 1)
	foodtypes = MEAT
	burns_on_grill = TRUE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fishmeat/gunner_jellyfish
	name = "филе медузы"
	desc = "Филе медузы с удаленными щупальцами. Вызывает галлюцинации."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "jellyfish_fillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin/mindbreaker = 2)

/obj/item/food/fishmeat/armorfish
	name = "филе панцирника"
	desc = "Панцирник с удаленными внутренностями и панцирем, готов к приготовлению."
	icon = 'icons/obj/food/lizard.dmi'
	icon_state = "armorfish_fillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)

/obj/item/food/fishmeat/donkfish
	name = "филе донк-рыбы"
	desc = "Ужасное филе донк-рыбы. Ни один здравомыслящий космонавт не станет есть это, и оно не становится лучше после приготовления."
	icon_state = "donkfillet"
	food_reagents = list(/datum/reagent/yuck = 3)

/obj/item/food/fishfingers
	name = "рыбные палочки"
	desc = "Филе рыбы в панировке."
	icon_state = "fishfingers"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	bite_consumption = 1
	tastes = list("рыба" = 1, "панировочные сухари" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/fishandchips
	name = "рыба и картофель фри"
	desc = "Любимая еда британцев."
	icon_state = "fishandchips"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("рыба" = 1, "чипсы" = 1)
	foodtypes = MEAT | VEGETABLES | FRIED
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/fishfry
	name = "жаркое из рыбы"
	desc = "И все это без картошки фри......"
	icon_state = "fishfry"
	food_reagents = list (/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("fish" = 1, "pan seared vegtables" = 1)
	foodtypes = MEAT | VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL

////////////////////////////////////////////MEATS AND ALIKE////////////////////////////////////////////

/obj/item/food/tofu
	name = "тофу"
	desc = "Все мы любим тофу."
	icon_state = "tofu"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("тофу" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/tofu/prison
	name = "размокший тофу"
	desc = "Ты не захочешь есть этот странный бобовый творог."
	tastes = list("кислая, гнилая вода" = 1)
	foodtypes = GROSS

/obj/item/food/spiderleg
	name = "паучья лапка"
	desc = "Все еще дергающаяся нога гигантского паука... Вы же не хотите это съесть, правда?"
	icon_state = "spiderleg"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/toxin = 2)
	tastes = list("паутина" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spiderleg/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/boiledspiderleg, rand(50 SECONDS, 60 SECONDS), TRUE, TRUE)

/obj/item/food/cornedbeef
	name = "солонина с капустой"
	desc = "Теперь вы можете почувствовать себя настоящим туристом, отдыхающим в Ирландии."
	icon_state = "cornedbeef"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("мясо" = 1, "капуста" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bearsteak
	name = "филе Мигравр"
	desc = "Потому что просто есть медвежатину было недостаточно мужественно."
	icon_state = "bearsteak"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 9, /datum/reagent/consumable/ethanol/manly_dorf = 5)
	tastes = list("мясо" = 1, "лосось" = 1)
	foodtypes = MEAT | ALCOHOL
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/raw_meatball
	name = "сырая фрикаделька"
	desc = "Отличная еда со всех сторон - это вам не бревно погрызть. Пока сыровато."
	icon_state = "raw_meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/meatball_type = /obj/item/food/meatball
	var/patty_type = /obj/item/food/raw_patty

/obj/item/food/raw_meatball/MakeGrillable()
	AddComponent(/datum/component/grillable, meatball_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_meatball/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, patty_type, 1, 20)
/obj/item/food/raw_meatball/human
	name = "странная сырая фрикаделька"
	meatball_type = /obj/item/food/meatball/human
	patty_type = /obj/item/food/raw_patty/human

/obj/item/food/raw_meatball/corgi
	name = "сырая фрикаделька из мяса корги"
	meatball_type = /obj/item/food/meatball/corgi
	patty_type = /obj/item/food/raw_patty/corgi

/obj/item/food/raw_meatball/xeno
	name = "сырая фрикаделька из мяса ксеноморфа"
	meatball_type = /obj/item/food/meatball/xeno
	patty_type = /obj/item/food/raw_patty/xeno

/obj/item/food/raw_meatball/bear
	name = "сырая фрикаделька из медвежатины"
	meatball_type = /obj/item/food/meatball/bear
	patty_type = /obj/item/food/raw_patty/bear

/obj/item/food/raw_meatball/chicken
	name = "сырая куриная фрикаделька"
	meatball_type = /obj/item/food/meatball/chicken
	patty_type = /obj/item/food/raw_patty/chicken

/obj/item/food/meatball
	name = "фрикаделька"
	desc = "Отличная еда со всех сторон - это вам не бревно погрызть."
	icon_state = "meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/meatball/human
	name = "странная фрикаделька"

/obj/item/food/meatball/corgi
	name = "фрикаделька из корги"

/obj/item/food/meatball/bear
	name = "фрикаделька из медвежатины"
	tastes = list("мясо" = 1, "salmon" = 1)

/obj/item/food/meatball/xeno
	name = "фрикаделька из мяса ксеноморфа"
	tastes = list("мясо" = 1, "acid" = 1)

/obj/item/food/meatball/chicken
	name = "куриная фрикаделька"
	tastes = list("chicken" = 1)
	icon_state = "chicken_meatball"

/obj/item/food/raw_patty
	name = "сырая котлета"
	desc = "Я ещё.....НЕ ГОТОООВА."
	icon_state = "raw_patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/patty_type = /obj/item/food/patty/plain

/obj/item/food/raw_patty/MakeGrillable()
	AddComponent(/datum/component/grillable, patty_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_patty/human
	name = "странная сырая котлета"
	patty_type = /obj/item/food/patty/human

/obj/item/food/raw_patty/corgi
	name = "сырая котлета из мяса корги"
	patty_type = /obj/item/food/patty/corgi

/obj/item/food/raw_patty/bear
	name = "сырая котлета из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)
	patty_type = /obj/item/food/patty/bear

/obj/item/food/raw_patty/xeno
	name = "сырая котлета из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)
	patty_type = /obj/item/food/patty/xeno

/obj/item/food/raw_patty/chicken
	name = "сырая куриная котлета"
	tastes = list("chicken" = 1)
	patty_type = /obj/item/food/patty/chicken

/obj/item/food/patty
	name = "котлета"
	desc = "Нанотрейзеновская котлета - для тебя и меня!"
	icon_state = "patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

///Exists purely for the crafting recipe (because itll take subtypes)
/obj/item/food/patty/plain

/obj/item/food/patty/human
	name = "странная котлета"

/obj/item/food/patty/corgi
	name = "котлета из мяса корги"

/obj/item/food/patty/bear
	name = "котлета из медвежатины"
	tastes = list("мясо" = 1, "salmon" = 1)

/obj/item/food/patty/xeno
	name = "котлета из мяса корги"
	tastes = list("мясо" = 1, "acid" = 1)

/obj/item/food/patty/chicken
	name = "куриная котлета"
	tastes = list("chicken" = 1)
	icon_state = "chicken_patty"

/obj/item/food/raw_sausage
	name = "сырая сосиска"
	desc = "Смешанные длинные, но сырые, волокна мяса."
	icon_state = "raw_sausage"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	eatverbs = list("bite","chew","nibble","deep throat","gobble","chomp")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_sausage/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/sausage, rand(60 SECONDS, 75 SECONDS), TRUE)

/obj/item/food/sausage
	name = "сосиска"
	desc = "Смешанные длинные волокна мяса."
	icon_state = "sausage"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	eatverbs = list("bite","chew","nibble","deep throat","gobble","chomp")
	var/roasted = FALSE
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/sausage/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/salami, 6, 30)
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/american_sausage, 1, 30)

/obj/item/food/american_sausage
	name = "американская сосиска"
	desc = "Дерзкая."
	icon_state = "american_sausage"

/obj/item/food/salami
	name = "салями"
	desc = "Кусочек вяленой салями."
	icon_state = "salami"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("мясо" = 1, "дымок" = 1)
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawkhinkali
	name = "сырое хинкали"
	desc = "Сотня хинкали? Я что, похож на свинью?"
	icon_state = "khinkali"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/garlic = 1)
	tastes = list("мясо" = 1, "лук" = 1, "чеснок" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawkhinkali/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/khinkali, rand(50 SECONDS, 60 SECONDS), TRUE)

/obj/item/food/khinkali
	name = "хинкали"
	desc = "Сотня хинкали? Я что, похож на свинью?"
	icon_state = "khinkali"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/garlic = 1)
	bite_consumption = 3
	tastes = list("мясо" = 1, "лук" = 1, "чеснок" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/monkeycube
	name = "обезьяний кубик"
	desc = "Просто добавь воды!"
	icon_state = "monkeycube"
	bite_consumption = 12
	food_reagents = list(/datum/reagent/monkey_powder = 30)
	tastes = list("джунгли" = 1, "бананы" = 1)
	foodtypes = MEAT | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	var/faction
	var/spawned_mob = /mob/living/carbon/human/species/monkey

/obj/item/food/monkeycube/proc/Expand()
	var/mob/spammer = get_mob_by_key(fingerprintslast)
	var/mob/living/bananas = new spawned_mob(drop_location(), TRUE, spammer)
	if(faction)
		bananas.faction = faction
	if (!QDELETED(bananas))
		visible_message(span_notice("[capitalize(src.name)] расширяется!"))
		bananas.log_message("Spawned via [src] at [AREACOORD(src)], Last attached mob: [key_name(spammer)].", LOG_ATTACK)
	else if (!spammer) // Visible message in case there are no fingerprints
		visible_message(span_notice("[capitalize(src.name)] не смог достаточно расшириться!"))
	qdel(src)

/obj/item/food/monkeycube/suicide_act(mob/living/M)
	M.visible_message(span_suicide("[M] суёт [src] в [M.ru_ego()] рот! Похоже, [M.p_theyre()] пытается совершить самоубийство!"))
	var/eating_success = do_after(M, 1 SECONDS, src)
	if(QDELETED(M)) //qdeletion: the nuclear option of self-harm
		return SHAME
	if(!eating_success || QDELETED(src)) //checks if src is gone or if they failed to wait for a second
		M.visible_message(span_suicide("[M] струсил!"))
		return SHAME
	if(HAS_TRAIT(M, TRAIT_NOHUNGER)) //plasmamen don't have saliva/stomach acid
		M.visible_message(span_suicide("[M] понимает, что [M.ru_ego()] тело не может принять [src]!")
		,span_warning("Моё тело не может принять [src]..."))
		return SHAME
	playsound(M, 'sound/items/eatfood.ogg', rand(10,50), TRUE)
	M.temporarilyRemoveItemFromInventory(src) //removes from hands, keeps in M
	addtimer(CALLBACK(src, PROC_REF(finish_suicide), M), 15) //you've eaten it, you can run now
	return MANUAL_SUICIDE

/obj/item/food/monkeycube/proc/finish_suicide(mob/living/M) ///internal proc called by a monkeycube's suicide_act using a timer and callback. takes as argument the mob/living who activated the suicide
	if(QDELETED(M) || QDELETED(src))
		return
	if((src.loc != M)) //how the hell did you manage this
		to_chat(M, span_warning("Что-то случилось с [src]..."))
		return
	Expand()
	M.visible_message(span_danger("[M] лопается, и из него появляется примат!"))
	M.gib(null, TRUE, null, TRUE)

/obj/item/food/monkeycube/syndicate
	faction = list("neutral", ROLE_SYNDICATE)

/obj/item/food/monkeycube/gorilla
	name = "горилловый кубил"
	desc = "Кубик гориллы марки Waffle Co. Теперь с дополнительными молекулами!"
	bite_consumption = 20
	food_reagents = list(/datum/reagent/monkey_powder = 30, /datum/reagent/medicine/strange_reagent = 5)
	tastes = list("джунгли" = 1, "бананы" = 1, "jimmies" = 1)
	spawned_mob = /mob/living/simple_animal/hostile/gorilla

/obj/item/food/monkeycube/chicken
	name = "куриный кубик"
	desc = "Новая классика Нанотрейзен - куриный кубик. На вкус как все возможное!"
	bite_consumption = 20
	food_reagents = list(/datum/reagent/consumable/eggyolk = 30, /datum/reagent/medicine/strange_reagent = 1)
	tastes = list("курица" = 1, "деревня" = 1, "куриный бульон" = 1)
	spawned_mob = /mob/living/simple_animal/chicken

/obj/item/food/monkeycube/bee
	name = "пчелиный кубик"
	desc = "Мы были уверены, что это хорошая идея. Просто добавьте воды."
	bite_consumption = 20
	food_reagents = list(/datum/reagent/consumable/honey = 10, /datum/reagent/toxin = 5, /datum/reagent/medicine/strange_reagent = 1)
	tastes = list("жужжание" = 1, "мед" = 1, "сожаление" = 1)
	spawned_mob = /mob/living/simple_animal/hostile/poison/bees

/obj/item/food/enchiladas
	name = "энчилада"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	bite_consumption = 4
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/capsaicin = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("перцы" = 1, "мясо" = 3, "сыр" = 1, "сметана" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stewedsoymeat
	name = "тушеное соевое мясо"
	desc = "Даже невегетарианцы будут в ВОСТОРГЕ от этого блюда!"
	icon_state = "stewedsoymeat"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("соя" = 1, "овощи" = 1)
	eatverbs = list("slurp","sip","inhale","drink")
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stewedsoymeat/Initialize(mapload)
	. = ..()

/obj/item/food/boiledspiderleg
	name = "вареная паучья лапка"
	desc = "Нога гигантского паука, которая все еще дергается. Отвратительно!"
	icon_state = "spiderlegcooked"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/capsaicin = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("перцы" = 1, "паутина" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/spidereggsham
	name = "ветчина из паучих яиц"
	desc = "Стали бы вы есть это в поезде? Съели бы вы есть это в самолете? Съели бы вы это в современной корпоративной смертельной ловушке, летящей через космос?"
	icon_state = "spidereggsham"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 3)
	bite_consumption = 4
	tastes = list("мясо" = 1, "зелёный цвет" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sashimi
	name = "сашими из карпа"
	desc = "Отпразднуйте нападение враждебных инопланетных форм жизни, госпитализировав себя."
	icon_state = "sashimi"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 10, /datum/reagent/consumable/capsaicin = 9, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("рыба" = 1, "перцы" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_TINY
	//total price of this dish is 20 and a small amount more for soy sauce, all of which are available at the orders console
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/sashimi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CARP, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/nugget
	name = "куриный наггетс"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("\"цыплёнок\"" = 1)
	icon_preview = 'icons/obj/food/food.dmi'
	icon_state_preview = "nugget_lump"
	foodtypes = MEAT
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/nugget/Initialize(mapload)
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	switch(shape)
		if("lump")
			desc = "Обычный куриный наггетс."
		if("star")
			desc = "Куриный наггетс в форме звезды."
		if("lizard")
			desc = "Куриный наггетс в форме ящерицы"
		else
			desc = "Куриный наггетс в форме корги"
	icon_state = "nugget_[shape]"

/obj/item/food/pigblanket
	name = "сосиска в тесте"
	desc = "Маленькая сосиска, завернутая в хрустящий рулет с маслом."
	icon_state = "pigblanket"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("мясо" = 1, "масло" = 1)
	foodtypes = MEAT | DAIRY
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/bbqribs
	name = "ребрышки барбекю"
	desc = "Сладкие, дымные, соленые, и всегда кстати. Идеально подходят для гриля."
	icon_state = "ribs"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 10, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/consumable/bbqsauce = 10)
	tastes = list("мясо" = 3, "дымный соус" = 1)
	foodtypes = MEAT

/obj/item/food/meatclown
	name = "мясной клоун"
	desc = "Восхитительный круглый кусочек мясного клоуна. Какой ужас."
	icon_state = "meatclown"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/banana = 2)
	tastes = list("мясо" = 5, "клоуны" = 3, "шестнадцать тесл" = 1)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/meatclown/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 30)

//////////////////////////////////////////// KEBABS AND OTHER SKEWERS ////////////////////////////////////////////

/obj/item/food/kebab
	trash_type = /obj/item/stack/rods
	icon_state = "kebab"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 14)
	tastes = list("мясо" = 3, "металл" = 1)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/kebab/human
	name = "кебаб из человечины"
	desc = "Человечина на палочке."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("нежное мясо" = 3, "металл" = 1)
	foodtypes = MEAT | GROSS
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/monkey
	name = "кебаб"
	desc = "Вкуснейшее мясо на палочке."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("мясо" = 3, "металл" = 1)
	foodtypes = MEAT
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/tofu
	name = "кебаб с тофу"
	desc = "Веганское мясо на палочке."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 15)
	tastes = list("тофу" = 3, "металл" = 1)
	foodtypes = VEGETABLES
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/tail
	name = "кебаб из хвоста ящерицы"
	desc = "Отрубленный хвост ящерицы на палке."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 30, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("мясо" = 8, "металл" = 4, "чешуйки" = 1)
	foodtypes = MEAT

/obj/item/food/kebab/rat
	name = "мышиный кебаб"
	desc = "Не очень вкусное крысиное мясо на палочке."
	icon_state = "ratkebab"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("крысятина" = 1, "металл" = 1)
	foodtypes = MEAT | GROSS
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/kebab/rat/double
	name = "двойной мышиный кебаб"
	icon_state = "doubleratkebab"
	tastes = list("крысятина" = 2, "металл" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/consumable/nutriment/vitamin = 6)

/obj/item/food/kebab/fiesta
	name = "шпажка \"Фиеста\""
	icon_state = "fiestaskewer"
	tastes = list("tex-mex" = 3, "тмин" = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 12, /datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/consumable/capsaicin = 3)

/obj/item/food/meat
	custom_materials = list(/datum/material/meat = MINERAL_MATERIAL_AMOUNT * 4)
	var/subjectname = ""
	var/subjectjob = null
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/effects/flesh_drop.wav'

/obj/item/food/meat/slab
	name = "мясо"
	desc = "Кусок мяса."
	icon_state = "meat"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/cooking_oil = 2) //Meat has fats that a food processor can process into cooking oil
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	///Legacy code, handles the coloring of the overlay of the cutlets made from this.
	var/slab_color = "#FF0000"

/obj/item/food/meat/slab/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/sosjerky/healthy)

/obj/item/food/meat/slab/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain, 3, 30)

///////////////////////////////////// HUMAN MEATS //////////////////////////////////////////////////////

/obj/item/food/meat/slab/human
	name = "мясо"
	tastes = list("tender meat" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/human/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain/human, 3, 30)

/obj/item/food/meat/slab/human/mutant/slime
	icon_state = "slimemeat"
	desc = "Потому что даже желе не было достаточно оскорбительным для веганов."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin/slimejelly = 3)
	tastes = list("слаймы" =1, "желе" =1)
	foodtypes = MEAT | RAW | TOXIC

/obj/item/food/meat/slab/human/mutant/golem
	icon_state = "Мясо голема"
	desc = "Съедобные камни, добро пожаловать в будущее."
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/iron = 3)
	tastes = list("камни" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/golem/adamantine
	icon_state = "agolemmeat"
	desc = "Съедобные камни, добро пожаловать в будущее."
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/lizard
	icon_state = "lizardmeat"
	desc = "Вкуснейшее мясо динозвара."
	tastes = list("мясо" = 4, "чешуйки" = 1)
	foodtypes = MEAT | RAW

/obj/item/food/meat/slab/human/mutant/lizard/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/lizard, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/human/mutant/plant
	icon_state = "plantmeat"
	desc = "Все радости здорового питания со всеми удовольствиями каннибализма."
	tastes = list("салат" =1, "дерево" =1)
	foodtypes = VEGETABLES

/obj/item/food/meat/slab/human/mutant/shadow
	icon_state = "shadowmeat"
	desc = "Ой, край."
	tastes = list("тьма" = 1, "мясо" = 1)
	foodtypes = MEAT | RAW

/obj/item/food/meat/slab/human/mutant/fly
	icon_state = "flymeat"
	desc = "Ничто так не вкусно, как наполненная личинками радиоактивная плоть мутанта."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/uranium = 3)
	tastes = list("личинки" = 1, "внутренности реактора" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/moth
	icon_state = "mothmeat"
	desc = "Неприятно порошкообразное и сухое. Хотя и довольно симпатичное."
	tastes = list("пыль" = 1, "порох" = 1, "мясо" = 2)
	foodtypes = MEAT | RAW

/obj/item/food/meat/slab/human/mutant/skeleton
	name = "кость"
	icon_state = "skeletonmeat"
	desc = "Есть момент, когда нужно остановиться. Очевидно, что мы его упустили."
	tastes = list("кости" = 1)
	foodtypes = GROSS

/obj/item/food/meat/slab/human/mutant/skeleton/MakeProcessable()
	return //skeletons dont have cutlets

/obj/item/food/meat/slab/human/mutant/zombie
	name = "гнилое мясо"
	icon_state = "rottenmeat"
	desc = "На полпути к тому, чтобы стать удобрением для вашего сада."
	tastes = list("мозги" = 1, "мясо" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/human/mutant/ethereal
	icon_state = "etherealmeat"
	desc = "Такой блестящий, что, кажется, проглотив его, ты тоже засияешь."
	food_reagents = list(/datum/reagent/consumable/liquidelectricity = 3)
	tastes = list("электричество" = 2, "мясо" = 1)
	foodtypes = RAW | MEAT | TOXIC

////////////////////////////////////// OTHER MEATS ////////////////////////////////////////////////////////


/obj/item/food/meat/slab/synthmeat
	name = "synthmeat"
	icon_state = "meat_old"
	desc = "Кусок синтетического мяса."
	foodtypes = RAW | MEAT //hurr durr chemicals we're harmed in the production of this meat thus its non-vegan.

/obj/item/food/meat/slab/synthmeat/MakeGrillable()
	AddComponent(/datum/component/grillable,/obj/item/food/meat/steak/plain/synth, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)
/obj/item/food/meat/slab/meatproduct
	name = "мясной продукт"
	icon_state = "meatproduct"
	desc = "Кусок переработанного и химически обработанного мясного продукта."
	tastes = list("мясной ароматизатор" = 2, "модифицированные крахмалы" = 2, "натуральные и искусственные красители" = 1, "масляная кислота" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/meatproduct/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/meatproduct, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/monkey
	name = "обезьянье мясо"
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/mouse
	name = "мышиное мясо"
	desc = "Кусок мышиного мяса. Лучше не есть сырым."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/mouse/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOUSE, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/corgi
	name = "мясо корги"
	desc = "На вкус как...ну...ты знаешь..."
	tastes = list("мясо" = 4, "любовь к ношению шляп" = 1)
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/corgi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CORGI, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/pug
	name = "мясо мопса"
	desc = "На вкус как...ну...ты знаешь..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/pug/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_PUG, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/dach
	name = "мясо таксы"
	desc = "На вкус похоже... ну, ты же знаешь..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/jack
	name = "мясо джек рассел терьера"
	desc = "На вкус похоже... ну, ты же знаешь..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/chi
	name = "мясо чихуахуа"
	desc = "На вкус похоже... ну, ты же знаешь..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/shepherd
	name = "мясо немецкой овчарки"
	desc = "На вкус похоже... ну, ты же знаешь..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/killertomato
	name = "мясо томата"
	desc = "Кусок огромного томата."
	icon_state = "tomatomeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("томаты" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/slab/killertomato/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/killertomato, rand(70 SECONDS, 85 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/killertomato/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/killertomato, 3, 30)

/obj/item/food/meat/slab/bear
	name = "медвежатина"
	desc = "Очень мужественный кусок мяса."
	icon_state = "bearmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/medicine/morphine = 5, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/cooking_oil = 6)
	tastes = list("мясо" = 1, "лосось" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/bear/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/bear, 3, 30)

/obj/item/food/meat/slab/bear/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/bear, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/bear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/xeno
	name = "мясо ксеноморфа"
	desc = "Кусок мяса."
	icon_state = "xenomeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 3)
	bite_consumption = 4
	tastes = list("мясо" = 1, "кислота" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/xeno/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/xeno, 3, 30)

/obj/item/food/meat/slab/xeno/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/xeno, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/spider
	name = "паучье мясо"
	desc = "Кусок паучьего мяса. Это так по-кафкиански."
	icon_state = "spidermeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/toxin = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("паутина" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/spider/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/spider, 3, 30)

/obj/item/food/meat/slab/spider/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/spider, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/goliath
	name = "мясо голиафа"
	desc = "Кусок мяса голиафа. Сейчас оно не очень съедобно, но оно отлично готовится в лаве."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/toxin = 5, /datum/reagent/consumable/cooking_oil = 3)
	icon_state = "goliathmeat"
	tastes = list("мясо" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/goliath/burn()
	visible_message(span_notice("[capitalize(src.name)] finishes cooking!"))
	new /obj/item/food/meat/steak/goliath(loc)
	qdel(src)

/obj/item/food/meat/slab/meatwheat
	name = "мясной комочек"
	desc = "Это не похоже на мясо, но ваши стандарты не <i>настолько</i> высоки..."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/blood = 5, /datum/reagent/consumable/cooking_oil = 1)
	icon_state = "meatwheat_clump"
	bite_consumption = 4
	tastes = list("мясо" = 1, "пшеница" = 1)
	foodtypes = GRAIN

/obj/item/food/meat/slab/gorilla
	name = "мясо гориллы"
	desc = "Намного мяснее, чем обезьянье мясо."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/cooking_oil = 5) //Plenty of fat!

/obj/item/food/meat/rawbacon
	name = "сырой бекон"
	desc = "Кусочек сырого бекона."
	icon_state = "bacon"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("бекон" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/rawbacon/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/bacon, rand(25 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/meat/bacon
	name = "кусочек бекона"
	desc = "Кусочек вкуснейшего бекона."
	icon_state = "baconcooked"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("бекон" = 1)
	foodtypes = MEAT | BREAKFAST
	burns_on_grill = TRUE

/obj/item/food/meat/slab/gondola
	name = "мясо гондолы"
	desc = "Согласно старым легендам, употребление сырой плоти гондолы дарует человеку внутренний покой."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/tranquility = 5, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("мясо" = 4, "спокойствие" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/gondola/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/gondola, 3, 30)

/obj/item/food/meat/slab/gondola/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/gondola, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?


/obj/item/food/meat/slab/penguin
	name = "мясо пингвина"
	icon_state = "birdmeat"
	desc = "Кусок мяса пингвина."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("говядина" = 1, "треска" = 1)

/obj/item/food/meat/slab/penguin/MakeProcessable()
	. = ..()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/penguin, 3, 30)

/obj/item/food/meat/slab/penguin/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/penguin, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/rawcrab
	name = "сырое крабовое мясо"
	desc = "Груда сырого крабового мяса."
	icon_state = "crabmeatraw"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("сырой краб" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/rawcrab/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/crab, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/crab
	name = "крабовое мясо"
	desc = "Вкусно приготовленное крабовое мясо."
	icon_state = "crabmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("краб" = 1)
	foodtypes = MEAT
	burns_on_grill = TRUE

/obj/item/food/meat/slab/chicken
	name = "куриное мясо"
	icon_state = "birdmeat"
	desc = "Кусок сырой курицы. Не забудьте вымыть руки!"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6) //low fat
	tastes = list("цыплёнок" = 1)

/obj/item/food/meat/slab/chicken/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/chicken, 3, 30)

/obj/item/food/meat/slab/chicken/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/chicken, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe? (no this is chicken)

/obj/item/food/meat/slab/chicken/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)
////////////////////////////////////// MEAT STEAKS ///////////////////////////////////////////////////////////

/obj/item/food/meat/steak
	name = "стейк"
	desc = "Кусок горячего острого мяса."
	icon_state = "meatsteak"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 1)
	foodtypes = MEAT
	tastes = list("мясо" = 1)
	burns_on_grill = TRUE

/obj/item/food/meat/steak/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(OnMicrowaveCooked))


/obj/item/food/meat/steak/proc/OnMicrowaveCooked(datum/source, obj/item/source_item, cooking_efficiency = 1)
	SIGNAL_HANDLER
	name = "стейк из [source_item.name]"

/obj/item/food/meat/steak/plain
	foodtypes = MEAT

/obj/item/food/meat/steak/plain/human
	tastes = list("нежное мясо" = 1)
	foodtypes = MEAT | GROSS

///Make sure the steak has the correct name
/obj/item/food/meat/steak/plain/human/OnMicrowaveCooked(datum/source, obj/item/source_item, cooking_efficiency = 1)
	. = ..()
	if(istype(source_item, /obj/item/food/meat))
		var/obj/item/food/meat/origin_meat = source_item
		subjectname = origin_meat.subjectname
		subjectjob = origin_meat.subjectjob
		if(subjectname)
			name = "стейк из [origin_meat.subjectname]"
		else if(subjectjob)
			name = "стейк из [origin_meat.subjectjob]"


/obj/item/food/meat/steak/killertomato
	name = "стейк из мяса томата"
	tastes = list("томаты" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/steak/bear
	name = "стейк из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/meat/steak/xeno
	name = "стейк из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)

/obj/item/food/meat/steak/spider
	name = "стейк из паучьего мяса"
	tastes = list("паутина" = 1)

/obj/item/food/meat/steak/goliath
	name = "стейк из голиафа"
	desc = "Вкуснейший, приготовленный в лаве стейк."
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	icon_state = "goliathsteak"
	trash_type = null
	tastes = list("мясо" = 1, "камни" = 1)
	foodtypes = MEAT

/obj/item/food/meat/steak/gondola
	name = "стейк из гондолы"
	tastes = list("мясо" = 1, "спокойствие" = 1)

/obj/item/food/meat/steak/penguin
	name = "стейк из пингвина"
	icon_state = "birdsteak"
	tastes = list("говядина" = 1, "треска" = 1)

/obj/item/food/meat/steak/chicken
	name = "стейк из курицы" //Can you have chicken steaks? Maybe this should be renamed once it gets new sprites.
	icon_state = "birdsteak"
	tastes = list("говядина" = 1)

/obj/item/food/meat/steak/plain/human/lizard
	name = "стейк из ящерицы"
	icon_state = "birdsteak"
	tastes = list("juicy chicken" = 3, "scales" = 1)
	foodtypes = MEAT

/obj/item/food/meat/steak/meatproduct
	name = "термически обработанный мясной продукт"
	icon_state = "meatproductsteak"
	tastes = list("мясной ароматизатор" = 2, "модифицированные крахмалы" = 2, "натуральные и искусственные красители" = 1, "эмульгаторы" = 1)

/obj/item/food/meat/steak/plain/synth
	name = "стейк из синтетического мяса"
	desc = "Стейк из синтетического мяса. Это выглядит не совсем правильно, не так ли?"
	icon_state = "meatsteak_old"
	tastes = list("мясо" = 4, "криоксадон" = 1)

//////////////////////////////// MEAT CUTLETS ///////////////////////////////////////////////////////

//Raw cutlets

/obj/item/food/meat/rawcutlet
	name = "сырая котлета"
	desc = "Сырая мясная котлета."
	icon_state = "rawcutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT | RAW
	var/meat_type = "meat"

/obj/item/food/meat/rawcutlet/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/OnCreatedFromProcessing(mob/living/user, obj/item/I, list/chosen_option, atom/original_atom)
	..()
	if(istype(original_atom, /obj/item/food/meat/slab))
		var/obj/item/food/meat/slab/original_slab = original_atom
		var/mutable_appearance/filling = mutable_appearance(icon, "rawcutlet_coloration")
		filling.color = original_slab.slab_color
		add_overlay(filling)
		name = "сырая котлета из [original_atom.name]"
		meat_type = original_atom.name

/obj/item/food/meat/rawcutlet/plain
	foodtypes = MEAT

/obj/item/food/meat/rawcutlet/plain

/obj/item/food/meat/rawcutlet/plain/human
	tastes = list("нежное мясо" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/rawcutlet/plain/human/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain/human, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/plain/human/OnCreatedFromProcessing(mob/living/user, obj/item/I, list/chosen_option, atom/original_atom)
	. = ..()
	if(istype(original_atom, /obj/item/food/meat))
		var/obj/item/food/meat/origin_meat = original_atom
		subjectname = origin_meat.subjectname
		subjectjob = origin_meat.subjectjob
		if(subjectname)
			name = "сырая котлета из [origin_meat.subjectname]"
		else if(subjectjob)
			name = "сырая котлета из [origin_meat.subjectjob]"

/obj/item/food/meat/rawcutlet/killertomato
	name = "сырая котлета из мяса томата"
	tastes = list("томаты" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/rawcutlet/killertomato/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/killertomato, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/bear
	name = "сырая котлета из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/meat/rawcutlet/bear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/rawcutlet/bear/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/bear, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)
/obj/item/food/meat/rawcutlet/xeno
	name = "сырая котлета из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)

/obj/item/food/meat/rawcutlet/xeno/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/xeno, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/spider
	name = "сырая котлета из паучьего мяса"
	tastes = list("паутина" = 1)

/obj/item/food/meat/rawcutlet/spider/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/spider, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)
/obj/item/food/meat/rawcutlet/gondola
	name = "сырая котлета из мяса гондолы"
	tastes = list("мясо" = 1, "спокойствие" = 1)

/obj/item/food/meat/rawcutlet/gondola/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/gondola, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)
/obj/item/food/meat/rawcutlet/penguin
	name = "сырая котлета из мяса пингвина"
	tastes = list("говядина" = 1, "треска" = 1)

/obj/item/food/meat/rawcutlet/penguin/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/penguin, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken
	name = "сырая куриная котлета"
	tastes = list("цыплёнок" = 1)

/obj/item/food/meat/rawcutlet/chicken/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/chicken, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)

//Cooked cutlets

/obj/item/food/meat/cutlet
	name = "котлета"
	desc = "Приготовленная мясная котлета."
	icon_state = "cutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("мясо" = 1)
	foodtypes = MEAT
	burns_on_grill = TRUE

/obj/item/food/meat/cutlet/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(OnMicrowaveCooked))

///This proc handles setting up the correct meat name for the cutlet, this should definitely be changed with the food rework.
/obj/item/food/meat/cutlet/proc/OnMicrowaveCooked(datum/source, atom/source_item, cooking_efficiency)
	SIGNAL_HANDLER
	if(istype(source_item, /obj/item/food/meat/rawcutlet))
		var/obj/item/food/meat/rawcutlet/original_cutlet = source_item
		name = "[original_cutlet.meat_type] котлета"

/obj/item/food/meat/cutlet/plain

/obj/item/food/meat/cutlet/plain/human
	tastes = list("нежное мясо" = 1)
	foodtypes = MEAT | GROSS

/obj/item/food/meat/cutlet/plain/human/OnMicrowaveCooked(datum/source, atom/source_item, cooking_efficiency)
	. = ..()
	if(istype(source_item, /obj/item/food/meat))
		var/obj/item/food/meat/origin_meat = source_item
		if(subjectname)
			name = "[origin_meat.subjectname] [initial(name)]"
		else if(subjectjob)
			name = "[origin_meat.subjectjob] [initial(name)]"

/obj/item/food/meat/cutlet/killertomato
	name = "котлета из мяса томата"
	tastes = list("томаты" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/cutlet/bear
	name = "котлета из медвежатины"
	tastes = list("мясо" = 1, "лосось" = 1)

/obj/item/food/meat/cutlet/xeno
	name = "котлета из мяса ксеноморфа"
	tastes = list("мясо" = 1, "кислота" = 1)

/obj/item/food/meat/cutlet/spider
	name = "котлета из паучьего мяса"
	tastes = list("паутина" = 1)

/obj/item/food/meat/cutlet/gondola
	name = "котлета из мяса гондолы"
	tastes = list("мясо" = 1, "спокойствие" = 1)

/obj/item/food/meat/cutlet/penguin
	name = "котлета из мяса пингвина"
	tastes = list("говядина" = 1, "треска" = 1)

/obj/item/food/meat/cutlet/chicken
	name = "куриная котлета"
	tastes = list("цыплёнок" = 1)

/obj/item/food/fried_chicken
	name = "жареная курица"
	desc = "Сочный кусок обжаренного куриного мяса."
	icon_state = "fried_chicken1"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("цыплёнок" = 3, "жареная шкурка" = 1)
	foodtypes = MEAT | FRIED
	junkiness = 25
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fried_chicken/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "fried_chicken2"

/obj/item/food/beef_stroganoff
	name = "бефстроганов"
	desc = "Русское блюдо, состоящее из говядины и соуса. Очень популярно в Японии, или, по крайней мере, на это намекает мое аниме."
	icon_state = "beefstroganoff"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("beef" = 3, "sour cream" = 1, "salt" = 1, "pepper" = 1)
	foodtypes = MEAT | VEGETABLES | DAIRY
	trash_type = /obj/item/trash/plate
	w_class = WEIGHT_CLASS_SMALL
	//basic ingredients, but a lot of them. just covering costs here
	venue_value = FOOD_PRICE_NORMAL
