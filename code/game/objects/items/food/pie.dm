/obj/item/food/pie
	icon = 'icons/obj/food/piecake.dmi'
	trash_type = /obj/item/trash/plate
	bite_consumption = 3
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 80
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("пирог" = 1)
	foodtypes = GRAIN
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/pieslice
	name = "кусок пирога"
	icon = 'icons/obj/food/piecake.dmi'
	trash_type = /obj/item/trash/plate
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("пирог" = 1, "uncertainty" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/plain
	name = "пирог"
	desc = "Обычный вкусный пирог."
	icon_state = "pie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("пирог" = 1)
	foodtypes = GRAIN
	burns_in_oven = TRUE

/obj/item/food/pie/cream
	name = "банановый пирог со сливками"
	desc = "По рецепту ХонкоМамы! ХОНК!"
	icon_state = "pie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/banana = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пирог" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	var/stunning = TRUE

/obj/item/food/pie/cream/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/food/pie/cream/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/pie_smudge(T)
	if(reagents?.total_volume)
		reagents.expose(hit_atom, TOUCH)
	if(isliving(hit_atom))
		var/mob/living/living_target_getting_hit = hit_atom
		if(stunning)
			living_target_getting_hit.Paralyze(20) //splat!
		living_target_getting_hit.adjust_blurriness(1)
		living_target_getting_hit.visible_message(span_warning("[living_target_getting_hit] is creamed by [src]!") , span_userdanger("You've been creamed by [src]!"))
		playsound(living_target_getting_hit, "desecration", 50, TRUE)
	if(is_type_in_typecache(hit_atom, GLOB.creamable))
		hit_atom.AddComponent(/datum/component/creamed, src)
	qdel(src)

/obj/item/food/pie/cream/nostun
	stunning = FALSE

/obj/item/food/pie/berryclafoutis
	name = "ягодный клафути"
	desc = "Почувствуй вкус древней Франции."
	icon_state = "berryclafoutis"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/berryjuice = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пирог" = 1, "ежевика" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/pie/bearypie
	name = "медвежий пирог"
	desc = "Где повар смог найти медведя..."
	icon_state = "bearypie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 12, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("пирог" = 1, "мясо" = 1, "лосось" = 1)
	foodtypes = GRAIN | SUGAR | MEAT | FRUIT

/obj/item/food/pie/meatpie
	name = "мясной пирог"
	icon_state = "meatpie"
	desc = "Старый земной рецепт, очень вкусно!"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("пирог" = 1, "мясо" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/pie/tofupie
	name = "пирог с тофу"
	icon_state = "meatpie"
	desc = "Вкусный пирог с тофу."
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("пирог" = 1, "тофу" = 1)
	foodtypes = GRAIN

/obj/item/food/pie/amanita_pie
	name = "пирог с мухоморами"
	desc = "Сладкий и вкусный ядовитый пирог."
	icon_state = "amanita_pie"
	bite_consumption = 4
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/toxin/amatoxin = 3, /datum/reagent/drug/mushroomhallucinogen = 1, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пирог" = 1, "грибы" = 1)
	foodtypes = GRAIN | VEGETABLES | TOXIC | GROSS

/obj/item/food/pie/plump_pie
	name = "пирог с толстошлемником"
	desc = "Держу пари, тебе понравится вкус толстошлемника!"
	icon_state = "plump_pie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пирог" = 1, "грибы" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/plump_pie/Initialize(mapload)
	var/fey = prob(10)
	if(fey)
		name = "исключительный пирог с толстошлемником"
		desc = "Микроволновку захватывает феерическое настроение! Ведь в ней приготовили пирог с толстошлемником!"
		food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/medicine/omnizine = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	. = ..()

/obj/item/food/pie/xemeatpie
	name = "ксено пирог"
	icon_state = "xenomeatpie"
	desc = "Вкуснейший мясной пирог. Почему-то пахнет кислотой."
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("пирог" = 1, "мясо" = 1, "кислота" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/pie/applepie
	name = "яблочный пирог"
	desc = "Пирог, приготовленный с добавлением любви повара... ну... или яблок."
	icon_state = "applepie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("пирог" = 1, "яблоко" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/cherrypie
	name = "вишневый пирог"
	desc = "Вкус настолько хорош, что заставит плакать даже твоего отца."
	icon_state = "cherrypie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("пирог" = 7, "Nicole Paige Brooks" = 2)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/pumpkinpie
	name = "тыквенный пирог"
	desc = "Вкусное осеннее угощение."
	icon_state = "pumpkinpie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 11, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("пирог" = 1, "тыква" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/pumpkinpie/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/pieslice/pumpkin, 5, 20)

/obj/item/food/pieslice/pumpkin
	name = "кусок тыквенного пирога"
	desc = "Кусочек тыквенного пирога со взбитыми сливками сверху. Прекрасно."
	icon_state = "pumpkinpieslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("пирог" = 1, "тыква" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/appletart
	name = "торт со стружкой из золотого яблока"
	desc = "Вкусный десерт. Не пытайся пройти с ним через металлоискатель."
	icon_state = "gappletart"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/gold = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пирог" = 1, "яблоко" = 1, "дорогой металл" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/grapetart
	name = "виноградный торт"
	desc = "Вкусный десерт, который напомнит вам о вине, который вы могли сделать вместо этого."
	icon_state = "grapetart"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пирог" = 1, "виноград" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/mimetart
	name = "мимовый торт"
	desc = "..."
	icon_state = "mimetart"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/nothing = 10)
	tastes = list("ничего" = 3)
	foodtypes = GRAIN

/obj/item/food/pie/berrytart
	name = "ягодный торт"
	desc = "Вкусный десерт из множества различных мелких ягод на тонком корже."
	icon_state = "berrytart"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("пирог" = 1, "ягоды" = 2)
	foodtypes = GRAIN | FRUIT

/obj/item/food/pie/cocolavatart
	name = "шоколадный лавовый торт"
	desc = "Вкусный десерт из шоколада с жидкой сердцевиной." //But it doesn't even contain chocolate...
	icon_state = "cocolavatart"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("пирог" = 1, "тёмный шоколад" = 3)
	foodtypes = GRAIN | SUGAR

/obj/item/food/pie/blumpkinpie
	name = "синетыквенный пирог"
	desc = "Странный синий пирог, приготовленный из синетыквенника."
	icon_state = "blumpkinpie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 13, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("пирог" = 1, "глоток воды в бассейне" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/blumpkinpie/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/pieslice/blumpkin, 5, 20)

/obj/item/food/pieslice/blumpkin
	name = "кусок синетыквенного пирога"
	desc = "Кусочек синетыквенного пирога со взбитыми сливками сверху. Он точно съедобен?"
	icon_state = "blumpkinpieslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("пирог" = 1, "глоток воды в бассейне" = 1)
	foodtypes = GRAIN | VEGETABLES

/obj/item/food/pie/dulcedebatata
	name = "дульсе де батата"
	desc = "Вкусное желе, приготовленное из сладкого картофеля."
	icon_state = "dulcedebatata"
	food_reagents = list(/datum/reagent/consumable/nutriment = 14, /datum/reagent/consumable/nutriment/vitamin = 8)
	tastes = list("желе" = 1, "сладкая картоха" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR
	venue_value = FOOD_PRICE_EXOTIC

/obj/item/food/pie/dulcedebatata/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/pieslice/dulcedebatata, 5, 20)

/obj/item/food/pieslice/dulcedebatata
	name = "кусок дульсе да батата"
	desc = "Кусочек сладкого желе дульсе де батата."
	icon_state = "dulcedebatataslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("желе" = 1, "сладкая картоха" = 1)
	foodtypes = GRAIN | VEGETABLES | SUGAR

/obj/item/food/pie/frostypie
	name = "ледяной пирог"
	desc = "Ты узнаешь каков синий цвет на вкус."
	icon_state = "frostypie"
	food_reagents = list(/datum/reagent/consumable/nutriment = 14, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("мята" = 1, "пирог" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/pie/baklava
	name = "пахлава"
	desc = "Восхитительная закуска из ореховых слоев между тонкими хлебными прослойками."
	icon_state = "baklava"
	food_reagents = list(/datum/reagent/consumable/nutriment = 12, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("орехи" = 1, "пирог" = 1)
	foodtypes = GRAIN

/obj/item/food/pie/baklava/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/pieslice/baklava, 6, 20)

/obj/item/food/pieslice/baklava
	name = "порция пахлавы"
	desc = "Порция восхитительной закуски из ореховых слоев с тонким хлебом."
	icon_state = "baklavaslice"
	tastes = list("орехи" = 1, "пирог" = 1)
	foodtypes = GRAIN
