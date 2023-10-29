//Moth Foods, the three C's: cheese, coleslaw, and cotton
//A large emphasis has been put on sharing and multiple portion dishes
//Additionally, where a mothic name is given, a short breakdown of what exactly it means is provided, for the curious on the internal workings of mothic: it's very onomatopoeic, and makes heavy use of combined words and accents

//Base ingredients and miscellany, generally not served on their own
/obj/item/food/herby_cheese
	name = "сыр с травами"
	desc = "Как основной продукт мотыльковой кухни, сыр часто дополняют различными вкусовыми добавками, чтобы сохранить разнообразие в рационе. Одним из таких дополнений являются травы, которые особенно любят моли."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "herby_cheese"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("cheese" = 1, "herbs" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/grilled_cheese
	name = "жареный сыр"
	desc = "Как предписывает лорд Алтон, да будет благословенно его имя, 99,997% мировых рецептов жареного сыра - чистая ложь: сыр ни разу не жарится, это просто сэндвич на гриле с расплавленным сыром. С другой стороны, это действительно жареный сыр, со всеми признаками того, что он жареный."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "grilled_cheese"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/char = 1)
	tastes = list("cheese" = 1, "char" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mothic_salad
	name = "салат для молей"
	desc = "Простой салат из капусты, красного лука и помидоров. Может служить прекрасной основой для миллиона различных салатов"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothic_salad"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("salad" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/toasted_seeds
	name = "поджаренные семена"
	desc = "Хотя они далеко не сытные, поджаренные семечки являются популярной закуской среди молей. Для большей пикантности можно добавить соль, сахар или даже некоторые экзотические приправы."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "toasted_seeds"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("seeds" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/engine_fodder
	name = "закуска для инженеров"
	desc = "Обычная закуска для инженеров мотылькового флота, сделанная из семян, орехов, шоколада, попкорна и картофельных чипсов - она отличается высокой калорийностью и удобна для перекуса, когда требуется дополнительная подпитка."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "engine_fodder"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/salt = 1)
	tastes = list("seeds" = 1, "nuts" = 1, "chocolate" = 1, "salt" = 1, "popcorn" = 1, "potato" = 1)
	foodtypes = GRAIN | NUTS | VEGETABLES | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mothic_pizza_dough
	name = "мольское тесто для пиццы"
	desc = "Прочное, клейкое тесто, приготовленное из кукурузной муки."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothic_pizza_dough"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("raw flour" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

//Entrees: categorising food that is 90% cheese and salad is not easy
/obj/item/food/squeaking_stir_fry
	name = "стир фрай" //skeklit = squeaking, mischt = stir, poppl = fry
	desc = "Мольская классика, приготовленная из творожного сыра и тофу (помимо всего прочего). В дословном переводе название означает \"пищащее жаркое\", название дано из-за характерного писка при приготовлении."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "squeaking_stir_fry"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("cheese" = 1, "tofu" = 1, "veggies" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sweet_chili_cabbage_wrap
	name = "капустный ролл с чили"
	desc = "Жареный сыр и салат в капустном обертывании, увенчанные восхитительным сладким соусом чили."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "sweet_chili_cabbage_wrap"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/consumable/capsaicin = 1)
	tastes = list("cheese" = 1, "salad" = 1, "sweet chili" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/loaded_curds
	name = "творожный сыр во фритюре" //ozlsettit = overflowing (ozl = over, sett = flow, it = ing), ælo = cheese, skekllön = curds (skeklit = squeaking, llön = pieces/bits), ede = and, pommes = fries (hey, France!)
	desc = "Что может быть лучше творожного сыра? Жареные во фритюре сырники! Что может быть лучше жареного во фритюре творожного сыра? Жареный во фритюре творожный сыр с чили (и еще больше сыра) сверху! А что еще лучше? Положить его на картофель фри!"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "loaded_curds"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/capsaicin = 1)
	tastes = list("cheese" = 1, "oil" = 1, "chili" = 1, "fries" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/baked_cheese
	name = "жареная головка сыра"
	desc = "Жареная головка сыра, расплавленная и вкусная."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "baked_cheese"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/capsaicin = 1)
	tastes = list("cheese" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/baked_cheese_platter
	name = "мольское фондю" //stannt = oven, krakt = baked, ælo = cheese
	desc = "Запеченный сырный круг: любимое блюдо молей для совместного употребления. Обычно подается с хрустящими ломтиками хлеба для макания, потому что лучше хорошего сыра может быть только хороший сыр на хлебе."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "baked_cheese_platter"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/capsaicin = 1)
	tastes = list("cheese" = 1, "bread" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

//Baked Green Lasagna at the Whistlestop Cafe
/obj/item/food/raw_green_lasagne
	name = "сырая зеленая лазанья аль Форно"
	desc = "Изысканная лазанья с песто и травянистым белым соусом, готовая к запеканию."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_green_lasagne"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cheese" = 1, "pesto" = 1, "pasta" = 1)
	foodtypes = VEGETABLES | GRAIN | NUTS
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/food/raw_green_lasagne/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/green_lasagne, rand(25 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/green_lasagne
	name = "зеленая лазанья аль Форно"
	desc = "Изысканная лазанья, приготовленная с песто и травянистым белым соусом."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "green_lasagne"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 12, /datum/reagent/consumable/nutriment/vitamin = 18)
	tastes = list("cheese" = 1, "pesto" = 1, "pasta" = 1)
	foodtypes = VEGETABLES | GRAIN | NUTS
	w_class = WEIGHT_CLASS_NORMAL
	burns_in_oven = TRUE

/obj/item/food/green_lasagne/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/green_lasagne_slice, 6, 30)

/obj/item/food/green_lasagne_slice
	name = "кусочек зеленой лазаньи аль Форно"
	desc = "Кусочек лазаньи с песто и травами."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "green_lasagne_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("cheese" = 1, "pesto" = 1, "pasta" = 1)
	foodtypes = VEGETABLES | GRAIN | NUTS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_baked_rice
	name = "сырой плов по Мольски"
	desc = "Большая сковорода слоеного картофеля с рисом и овощным бульоном, готовая к запеканию в виде вкусного блюда для совместного употребления."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_baked_rice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("rice" = 1, "potato" = 1, "veggies" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/food/raw_baked_rice/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/big_baked_rice, rand(25 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/big_baked_rice
	name = "плов по мольски"
	desc = "Любимое блюдо молей, запеченный рис по вкусу наполняется различными овощными начинками. Картофель также часто укладывают слоями на дно казана, чтобы получилась ароматная корочка, которая всегда вызывает горячее одобрение со стороны посетителей. Принято употреблять в большой компании."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "big_baked_rice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 12, /datum/reagent/consumable/nutriment/vitamin = 36)
	tastes = list("rice" = 1, "potato" = 1, "veggies" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_NORMAL
	burns_in_oven = TRUE

/obj/item/food/big_baked_rice/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/lil_baked_rice, 6, 30)

/obj/item/food/lil_baked_rice
	name = "порция плова по мольски"
	desc = "Одна порция мольского плова, идеально подходит в качестве гарнира или даже полноценного блюда."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "lil_baked_rice"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("rice" = 1, "potato" = 1, "veggies" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/oven_baked_corn
	name = "кукуруза, запеченная в духовке"
	desc = "Початок кукурузы, запеченный в жаркой духовке до почернения."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "oven_baked_corn"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/consumable/char = 1)
	tastes = list("corn" = 1, "char" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/buttered_baked_corn
	name = "запеченная кукуруза с маслом"
	desc = "Что может быть лучше печеной кукурузы? Запеченная кукуруза с маслом!"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "buttered_baked_corn"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/consumable/char = 1)
	tastes = list("corn" = 1, "char" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fiesta_corn_skillet
	name = "кукурузная фиеста на сковороде"
	desc = "Сладкая, пряная, соленая, все вкусы в одном."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fiesta_corn_skillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 7, /datum/reagent/consumable/char = 1)
	tastes = list("corn" = 1, "chili" = 1, "char" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_ratatouille
	name = "сырой рататуй" //rawtatouille?
	desc = "Нарезанные овощи с соусом из жареного перца."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_ratatouille"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 7, /datum/reagent/consumable/char = 1)
	tastes = list("veggies" = 1, "roasted peppers" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_ratatouille/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/ratatouille, rand(25 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/ratatouille
	name = "рататуй"
	desc = "Идеальное блюдо, которое спасет ваш ресторан от мстительного ресторанного критика. Бонусные очки, если у вас есть крыса в шляпе."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "ratatouille"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 7, /datum/reagent/consumable/char = 1)
	tastes = list("veggies" = 1, "roasted peppers" = 1, "char" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/mozzarella_sticks
	name = "палочки из моцареллы во фритюре"
	desc = "Маленькие палочки моцареллы панированные и жареные."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mozzarella_sticks"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("creamy cheese" = 1, "breading" = 1, "oil" = 1)
	foodtypes = DAIRY | GRAIN | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_stuffed_peppers
	name = "сырой фаршированный перец" //voltöl = stuffed (vol = full, töl = push), paprik (from German paprika) = bell pepper
	desc = "Перец со снятой верхушкой и начинкой из сыра с травами и лука. Наверное, не стоит есть сырым."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_stuffed_pepper"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("creamy cheese" = 1, "herbs" = 1, "onion" = 1, "bell pepper" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_stuffed_peppers/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/stuffed_peppers, rand(15 SECONDS, 35 SECONDS), TRUE, TRUE)

/obj/item/food/stuffed_peppers
	name = "фаршированный перец"
	desc = "Мягкий, но в то же время хрустящий болгарский перец с чудесным расплавленным сыром внутри."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "stuffed_pepper"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("creamy cheese" = 1, "herbs" = 1, "onion" = 1, "bell pepper" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	burns_in_oven = TRUE

/obj/item/food/fueljacks_lunch
	name = "обед заправщика"
	desc = "Блюдо, приготовленное из жареных овощей, популярное среди заправщиков - храбрых молей докеров, что управляют топливными тягачами, чтобы поддерживать работу космодока. Учитывая постоянную потребность в топливе и ограниченное время, в течение которого звезды выстраиваются для сбора урожая (в буквальном смысле), они часто берут упакованные блюда, которые они разогревают, используя плазменные форсунки катеров."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fueljacks_lunch"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("cabbage" = 1, "potato" = 1, "onion" = 1, "chili" = 1, "cheese" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mac_balls
	name = "макаронные шарики с сыром"
	desc = "Жареные шарики макарон с сыром, обмакнутые в кукурузное тесто, подаются с томатным соусом. Популярная закуска во всей галактике, особенно на Мольском флоте, где в качестве основы обычно едят Донк-покеты."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mac_balls"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 3)
	tastes = list("pasta" = 1, "cornbread" = 1, "cheese" = 1)
	foodtypes = DAIRY | VEGETABLES | FRIED | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sustenance_bar
	name = "спецбатончик \"Заряд\""
	desc = "Спецбатончик \"Заряд\" или, как его ещё называют, энергетический батончик - это плотно упакованный, богатый питательными веществами продукт, предназначенный для поддержания жизнедеятельности населения во время нехватки продовольствия. Изготовленный из соевого и горохового белка, каждый батончик рассчитан на 3 дня при достаточном рационе. Несмотря на длительный срок хранения, со временем они портятся, что приводит к их продаже флотом в качестве излишков. Этот, как и большинство искусственно ароматизированных кормов для мотыльков, имеет смешанный травяной вкус."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "sustenance_bar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes = list("травы" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/sustenance_bar/neapolitan
	name = "спецбатончик \"Заряд\" с неополитанским вкусом"
	desc = "Спецбатончик \"Заряд\" или, как его ещё называют, энергетический батончик - это плотно упакованный, богатый питательными веществами продукт, предназначенный для поддержания жизнедеятельности населения во время нехватки продовольствия. Изготовленный из соевого и горохового белка, каждый батончик рассчитан на 3 дня при достаточном рационе. Несмотря на длительный срок хранения, со временем они портятся, что приводит к их продаже флотом в качестве излишков. Этот, как и большинство искусственно ароматизированных кормов для мотыльков, имеет смешанный травяной вкус. Этот неаполитанский со вкусом клубники, ванили и шоколада."
	tastes = list("клубника" = 1, "ваниль" = 1, "шоколад" = 1)

/obj/item/food/sustenance_bar/cheese
	name = "спецбатончик \"Заряд\" со вкусом \"три сыра\""
	desc = "Спецбатончик \"Заряд\" или, как его ещё называют, энергетический батончик - это плотно упакованный, богатый питательными веществами продукт, предназначенный для поддержания жизнедеятельности населения во время нехватки продовольствия. Изготовленный из соевого и горохового белка, каждый батончик рассчитан на 3 дня при достаточном рационе. Несмотря на длительный срок хранения, со временем они портятся, что приводит к их продаже флотом в качестве излишков. Этот, как и большинство искусственно ароматизированных кормов для мотыльков, имеет смешанный травяной вкус. Этот со вкусом трех сыров: пармезана, моцареллы и чеддера."
	tastes = list("пармезан" = 1, "моцарелла" = 1, "чеддер" = 1)

/obj/item/food/sustenance_bar/mint
	name = "спецбатончик \"Заряд\" со вкусом мятного шоколада"
	desc = "Спецбатончик \"Заряд\" или, как его ещё называют, энергетический батончик - это плотно упакованный, богатый питательными веществами продукт, предназначенный для поддержания жизнедеятельности населения во время нехватки продовольствия. Изготовленный из соевого и горохового белка, каждый батончик рассчитан на 3 дня при достаточном рационе. Несмотря на длительный срок хранения, со временем они портятся, что приводит к их продаже флотом в качестве излишков. Этот, как и большинство искусственно ароматизированных кормов для мотыльков, имеет смешанный травяной вкус. Этот со вкусом мятного шоколада."
	tastes = list("перечаня мята" = 1, "картофельные чипсы (?)" = 1, "тёмный шоколад" = 1)

/obj/item/food/sustenance_bar/wonka
	name = "спецбатончик \"Заряд\" - ужин из трёх блюд"
	desc = "Спецбатончик \"Заряд\" или, как его ещё называют, энергетический батончик - это плотно упакованный, богатый питательными веществами продукт, предназначенный для поддержания жизнедеятельности населения во время нехватки продовольствия. Изготовленный из соевого и горохового белка, каждый батончик рассчитан на 3 дня при достаточном рационе. Несмотря на длительный срок хранения, со временем они портятся, что приводит к их продаже флотом в качестве излишков. Этот, как и большинство искусственно ароматизированных кормов для мотыльков, имеет смешанный травяной вкус. В этом сочетаются три вкуса - томатный суп, жареная тыква и черничный пирог."
	tastes = list("томатный суп" = 1, "жареная тыква" = 1, "черничный пирог" = 1)

//Soups
/obj/item/food/soup/moth_cotton_soup
	name = "суп с клёцками из хлопка" //flöf = cotton, rölen = ball, mæsch = soup
	desc = "Суп из хлопка на ароматном овощном бульоне. Нравится только молям и тем, кто преступно безвкусен."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_cotton_soup"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("cotton" = 1, "broth" = 1)
	foodtypes = VEGETABLES | CLOTH
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/moth_cheese_soup
	name = "сырный суп" //ælo = cheese, sterr = melt, mæsch = soup
	desc = "Простой и сытный суп из домашнего сыра и сладкого картофеля. Творог придает текстуру, а сыворотка - объем, вкуснятина!"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_cheese_soup"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/salt = 1)
	tastes = list("cheese" = 1, "cream" = 1, "sweet potato" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/moth_seed_soup
	name = "суп с семянами" //miskl = seed, mæsch = soup
	desc = "Суп на основе семян."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_seed_soup"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("bitterness" = 1, "sourness" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/vegetarian_chili
	name = "веганский чили кон карне"
	desc = "Для тех, кто не хочет карне."
	icon_state = "hotchili"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/capsaicin = 3, /datum/reagent/consumable/tomatojuice = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("bitterness" = 1, "sourness" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/moth_bean_stew
	name = "острая тушеная фасоль" //prickeld = spicy, röndol = bean, haskl = stew
	desc = "Острая тушеная фасоль с большим количеством овощей, обычно подается на борту флота в качестве сытного блюда с рисом или хлебом."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_bean_stew"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 7, /datum/reagent/consumable/char = 1)
	tastes = list("beans" = 1, "cabbage" = 1, "spicy sauce" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/moth_oat_stew
	name = "овсяное рагу" //häfmiskl = oat (häf from German hafer meaning oat, miskl meaning seed), haskl = stew
	desc = "Сытное рагу, приготовленное из овса, сладкого картофеля и различных зимних овощей."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_oat_stew"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 7, /datum/reagent/consumable/char = 1)
	tastes = list("oats" = 1, "sweet potato" = 1, "carrot" = 1, "parsnip" = 1, "pumpkin" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/moth_fire_soup
	name = "изжоговый суп" //tömprött = heart (tömp = thump, rött = muscle), krakkl = fire, mæsch = soup
	desc = "Это холодное суповое блюдо, которое зародилось среди джунглевых мотыльков и получило свое название за две вещи - его бордово-розовый цвет и обжигающе горячий перец чили."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_fire_soup"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("love" = 1, "hate" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/rice_porridge
	name = "рисовая каша"
	desc = "Тарелка рисовой каши. В основном она не имеет вкуса, но заполняет место. Для китайцев это конги, а моли называют ее höllflöfmisklsløsk."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "rice_porridge"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("nothing" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/hua_mulan_congee
	name = "отвар Хуа Мулань"
	desc = "Никто точно не знает, почему эта улыбающаяся миска рисовой каши с яйцами и беконом названа в честь мифологической китайской героини."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "hua_mulan_congee"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/nutriment/protein = 5)
	tastes = list("bacon" = 1, "eggs" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/toechtauese_rice_porridge
	name = "острая рисовая каша"
	desc = "На борту мотылькового флота обычно подают рисовую кашу с острым сиропом, которая более вкусна, чем обычная, хотя бы потому, что она более острая, чем обычно."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "toechtauese_rice_porridge"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("sugar" = 1, "spice" = 1)
	foodtypes = GRAIN | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/cornmeal_porridge
	name = "кукурузная каша"
	desc = "Тарелка кукурузной каши. Она более ароматна, чем большинство каш, и является хорошей основой для других блюд."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cornmeal_porridge"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cornmeal" = 1)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/cheesy_porridge //milk, polenta, firm cheese, curd cheese, butter
	name = "сырная каша"
	desc = "Сытная и сливочная каша из сырной кукурузной муки."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cheesy_porridge"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cornmeal" = 1, "cheese" = 1, "more cheese" = 1, "lots of cheese" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/soup/fried_eggplant_polenta
	name = "жареные баклажаны с полентой"
	desc = "Полента с сыром, подается с несколькими кусочками жареного баклажана и томатным соусом."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fried_eggplant_polenta"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cornmeal" = 1, "cheese" = 1, "eggplant" = 1, "tomato sauce" = 1)
	foodtypes = DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

//Salads: the bread and butter of mothic cuisine
/obj/item/food/caprese_salad
	name = "салат Капрезе"
	desc = "Далеко не оригинальное творение молей, но салат капрезе стал любимым на борту флота благодаря простоте приготовления и вкусу." //zail = two, esken = colour/tone, knuskolt = salad
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "caprese_salad"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("mozzarella" = 1, "tomato" = 1, "balsamic" = 1)
	foodtypes = DAIRY | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/salad/fleet_salad
	name = "салат \"Флит\"" //lörton = fleet, knusksolt = salad (knusk = crisp, solt = bowl) // слушай идика ты нахуй
	desc = "Часто встречается в закусочных и столовых на борту флота. Жареный сыр делает его особенно сытным, а гренки придают хрустящий вкус."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "fleet_salad"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cheese" = 1, "salad" = 1, "bread" = 1)
	foodtypes = DAIRY | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/salad/cotton_salad
	name = "салат из хлопка"
	desc = "Салат с добавлением хлопка и заправки из масла."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cotton_salad"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("cheese" = 1, "salad" = 1, "bread" = 1)
	foodtypes = VEGETABLES | CLOTH
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/salad/moth_kachumbari
	name = "качумбари" //Kæniat = Kenyan, knusksolt = salad // канадский салат трахает
	desc = "Изначально кенийский рецепт, качумбари - еще один межкультурный фаворит человечества, который переняли моли, хотя некоторые ингредиенты были обязательно изменены."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_kachumbari"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("onion" = 1, "tomato" = 1, "corn" = 1, "chili" = 1, "cilantro" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

//Pizza
/obj/item/food/raw_mothic_margherita
	name = "сырая пицца Маргарита для молей"
	desc = "Еще одна человеческая классика, которую переняли моли."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_margherita_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("dough" = 1, "tomato" = 1, "cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_margherita/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_margherita, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_margherita
	name = "пицца Маргарита для молей"
	desc = "Ключевой особенностью мольской пиццы является то, что она продается на вес - отдельные кусочки можно купить за кредиты, а за талон на питание можно купить целый круг."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "margherita_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 25, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_margherita
	boxtag = "Margherita alla Moffuchi"

/obj/item/food/pizzaslice/mothic_margherita
	name = "кусочек пиццы Маргарита для молей"
	desc = "Кусочек пиццы \"Маргарита\", самой скромной из пицц."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "margherita_slice"
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_firecracker
	name = "сырая огненная пицца для молей"
	desc = "Огненная пицца - это фаворит среди более авантюрных молей. ГОРЯЧО! ГОРЯЧО! ГОРЯЧО!"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_firecracker_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/bbqsauce = 6, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/consumable/capsaicin = 10)
	tastes = list("dough" = 1, "chili" = 1, "corn" = 1, "cheese" = 1, "bbq sauce" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_firecracker/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_firecracker, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_firecracker
	name = "огненная пицца для молей"
	desc = "Они не шутят, когда называют это горячей пиццей."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "firecracker_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 25, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/bbqsauce = 6, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/capsaicin = 10)
	tastes = list("crust" = 1, "chili" = 1, "corn" = 1, "cheese" = 1, "bbq sauce" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_firecracker
	boxtag = "Vesuvian Firecracker"

/obj/item/food/pizzaslice/mothic_firecracker
	name = "кусочек огненной пиццы для молей"
	desc = "Пикантный кусочек чего-то очень приятного."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "firecracker_slice"
	tastes = list("crust" = 1, "chili" = 1, "corn" = 1, "cheese" = 1, "bbq sauce" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_five_cheese
	name = "сырая пицца \"4+1 сыра\" для молей"
	desc = "На протяжении веков ученые задавались вопросом: когда сыра становится слишком много?"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_five_cheese_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("dough" = 1, "cheese" = 1, "more cheese" = 1, "excessive amounts of cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_five_cheese/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_five_cheese, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_five_cheese
	name = "пицца \"4+1 сыра\" для молей"
	desc = "Любимица мышей, крыс и английских изобретателей."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "five_cheese_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 25, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("crust" = 1, "cheese" = 1, "more cheese" = 1, "excessive amounts of cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_five_cheese
	boxtag = "Cheeseplosion"

/obj/item/food/pizzaslice/mothic_five_cheese
	name = "кусочек пиццы \"4+1 сыра\" для молей"
	desc = "Это самый сырный кусочек в галактике!"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "five_cheese_slice"
	tastes = list("crust" = 1, "cheese" = 1, "more cheese" = 1, "excessive amounts of cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_white_pie
	name = "сырая пицца \"Бьянко\" для молей"
	desc = "Пицца для тех, кто ненавидит томаты."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_white_pie_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("dough" = 1, "cheese" = 1, "herbs" = 1, "garlic" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_white_pie/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_white_pie, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_white_pie
	name = "пицца \"Бьянко\" для молей"
	desc = "Ты говоришь \"томаты\", я говорю \"помидоры\", и мы не кладем на эту пиццу ни того, ни другого."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "white_pie_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 25, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("crust" = 1, "cheese" = 1, "herbs" = 1, "garlic" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY
	slice_type = /obj/item/food/pizzaslice/mothic_white_pie
	boxtag = "Pane Bianco"

/obj/item/food/pizzaslice/mothic_white_pie
	name = "кусочек пиццы \"Бьянко\" для молей"
	desc = "Сырный, чесночный, вкусный!"
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "white_pie_slice"
	tastes = list("crust" = 1, "cheese" = 1, "more cheese" = 1, "excessive amounts of cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY

/obj/item/food/raw_mothic_pesto
	name = "сырая пицца с соусом песто для молей"
	desc = "Песто - популярная начинка для пиццы молей, возможно, потому, что она олицетворяет их любимые вкусы: сыр, зелень и овощи."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_pesto_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("dough" = 1, "pesto" = 1, "cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS

/obj/item/food/raw_mothic_pesto/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_pesto, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_pesto
	name = "пицца с соусом песто для молей"
	desc = "Зеленый, как трава в саду. Не то чтобы на флоте молей много садов..."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "pesto_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 25, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("crust" = 1, "pesto" = 1, "cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS
	slice_type = /obj/item/food/pizzaslice/mothic_pesto
	boxtag = "Presto Pesto"

/obj/item/food/pizzaslice/mothic_pesto
	name = "кусочек пиццы с соусом песто для молей"
	desc = "A slice of presto pesto pizza."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "pesto_slice"
	tastes = list("crust" = 1, "pesto" = 1, "cheese" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS

/obj/item/food/raw_mothic_garlic
	name = "сырая чесночная пицца для молей"
	desc = "Ах, чеснок. Его любят все, за исключением, возможно, вампиров."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "raw_garlic_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("dough" = 1, "garlic" = 1, "butter" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/raw_mothic_garlic/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/mothic_garlic, rand(20 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/pizza/mothic_garlic
	name = "чесночная пицца для молей"
	desc = "Лучшая еда в галактике, несомненно."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "garlic_pizza"
	food_reagents = list(/datum/reagent/consumable/nutriment = 25, /datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/tomatojuice = 6, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("crust" = 1, "garlic" = 1, "butter" = 1)
	foodtypes = GRAIN | VEGETABLES | DAIRY | NUTS
	slice_type = /obj/item/food/pizzaslice/mothic_pesto
	boxtag = "Garlic Bread alla Moffuchi"

/obj/item/food/pizzaslice/mothic_garlic
	name = "кусочек чесночной пиццы для молей"
	desc = "Лучшее сочетание жирного, чесночного и корочки, известное молям."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "garlic_slice"
	tastes = list("dough" = 1, "garlic" = 1, "butter" = 1)
	foodtypes = GRAIN | VEGETABLES

//Bread
/obj/item/food/bread/corn
	name = "кукурузный хлеб"
	desc = "Вкусный домашний кукурузный хлеб в деревенском стиле."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cornbread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	tastes = list("cornbread" = 10)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bread/corn/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/breadslice/corn, 6, 20)

/obj/item/food/breadslice/corn
	name = "ломтик кукурузного хлеба"
	desc = "Кусок хрустящего кукурузного хлеба в ковбойском стиле. Ешьте с удовольствием."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "cornbread_slice"
	foodtypes = GRAIN
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)

//Sweets
/obj/item/food/moth_cheese_cakes
	name = "шарики из чизкейка" //ælo = cheese, rölen = balls // сырные яйца ебут пиздце
	desc = "Традиционный мольский десерт, который готовится из мягкого сыра, сахарной пудры и муки, скатывается в шарики, обваливается и затем обжаривается во фритюре."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "moth_cheese_cakes"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/sugar = 5)
	tastes = list("cheesecake" = 1, "chocolate" = 1, "honey" = 1)
	foodtypes = SUGAR | FRIED | DAIRY | GRAIN
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cake/mothmallow
	name = "зефирки для молей"
	desc = "Легкий и пушистый веганский зефир со вкусом ванили и рома, увенчанный мягким шоколадом." //höllflöf = cloud (höll = wind, flöf = cotton), starkken = squares
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothmallow_tray"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/sugar = 10)
	tastes = list("vanilla" = 1, "clouds" = 1, "chocolate" = 1)
	foodtypes = VEGETABLES | SUGAR

/obj/item/food/cake/mothmallow/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cakeslice/mothmallow, 6, 20)

/obj/item/food/cakeslice/mothmallow
	name = "зефирки для молей"
	desc = "Пушистые маленькие облака радости - странного цвета, похожего на моль."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "mothmallow_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 2)
	tastes = list("vanilla" = 1, "clouds" = 1, "chocolate" = 1)
	foodtypes = VEGETABLES | SUGAR

/obj/item/food/soup/red_porridge
	name = "свекольная каша с йогуртом" //eltsløsk = red porridge, ül a = with, prikt = sour, æolk = cream // чё блядь долбоеб?
	desc = "Красная каша с йогуртом. Название и растительные ингредиенты скрывают сладкий характер блюда, которое обычно подается в качестве десерта на борту флота."
	icon = 'icons/obj/food/moth.dmi'
	icon_state = "red_porridge"
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/consumable/sugar = 6)
	tastes = list("sweet beets" = 1, "sugar" = 1, "sweetened yoghurt" = 1)
	foodtypes = VEGETABLES | SUGAR | DAIRY

//misc food
/obj/item/food/chewable/bubblegum/wake_up
	name = "жвачка \"Актвин\""
	desc = "Резиновая полоска жвачки. На ней нанесена эмблема флота молей-кочевников."
	food_reagents = list(/datum/reagent/consumable/sugar = 13, /datum/reagent/drug/methamphetamine = 2)
	tastes = list("herbs" = 1)
	color = "#567D46"

/obj/item/storage/box/gum/wake_up
	name = "жвачка \"Актвин\""
	desc = "Оставайтесь бодрыми во время долгих смен в ремонтных туннелях с Активином!"
	icon_state = "bubblegum_wake_up"
	custom_premium_price = PAYCHECK_EASY * 1.5

/obj/item/storage/box/gum/wake_up/examine_more(mob/user)
	var/list/msg = list(span_notice("<i>Читаю описание жвачки на упаковке...</i>"))
	msg += "\t[span_info("Для снятия усталости и сонливости во время работы.")]"
	msg += "\t[span_info("Не разжевывайте более одной полоски каждые 12 часов. Не используйте в качестве полной замены сна.")]"
	msg += "\t[span_info("Не давать детям до 16 лет. Не превышайте максимальную дозировку. Не принимать внутрь. Не принимать более 3 дней подряд. Не принимать в сочетании с другими лекарствами. Может вызывать побочные реакции у пациентов с уже существующими заболеваниями сердца.")]"
	msg += "\t[span_info("Побочные эффекты применения Активина могут включать подергивание усиков, гиперактивные крылья, потерю кератинового блеска, потерю покрытия волосков, аритмию, помутнение зрения и эйфорию. При появлении побочных эффектов прием препарата следует прекратить.")]"
	msg += "\t[span_info("Повторное нескольких полосок за раз может вызвать зависимость.")]"
	msg += "\t[span_info("В случае превышения максимальной дозы немедленно сообщите об этом члену медицинского персонала судна. Не вызывайте рвоту.")]"
	msg += "\t[span_info("Состав: каждая полоска содержит 500 мг Активина (декстро-метамфетамин). Другие ингредиенты включают зеленый краситель 450 (Verdant Meadow) и искусственный травяной ароматизатор.")]"
	msg += "\t[span_info("Хранение: хранить в сухом прохладном месте. Не использовать после истечения срока годности: 32/4/350.")]"
	return msg

/obj/item/storage/box/gum/wake_up/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/food/chewable/bubblegum/wake_up(src)

/obj/item/food/spacers_sidekick
	name = "мятные конфеты \"Кореш космонавта\""
	desc = "Кореш космонавта : Дышите легко, когда рядом с вами друг!"
	icon_state = "spacers_sidekick"
	trash_type = /obj/item/trash/spacers_sidekick
	food_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/menthol = 1, /datum/reagent/medicine/salbutamol = 1)
	tastes = list("strong mint" = 1)
	junkiness = 15
	foodtypes = JUNKFOOD
	w_class = WEIGHT_CLASS_SMALL
