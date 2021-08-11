// lavalamp

/obj/item/flashlight/lamp/lavalamp
	name = "лавовая лампа"
	desc = "Декоративный светильник, представляет собой прозрачную стеклянную ёмкость (обычно цилиндр) с прозрачной жидкостью и полупрозрачным парафином, снизу которых расположена лампа накаливания. Работает сам по себе, поэтому не нуждается в постоянном источнике питания."
	icon = 'white/rebolution228/icons/obj/lighting.dmi'
	icon_state = "lava_lamp"
	lefthand_file = 'white/rebolution228/icons/obj/mob/inhand_objects_left.dmi'
	righthand_file = 'white/rebolution228/icons/obj/mob/inhand_objects_right.dmi'
	inhand_icon_state = "lavalamp"
	force = 5
	light_range = 2
	light_system = STATIC_LIGHT
	w_class = WEIGHT_CLASS_NORMAL

//thermos

/obj/item/reagent_containers/food/drinks/thermos
	name = "винтажный термос"
	desc = "Старый, металлический термос со слабым блеском."
	icon = 'white/rebolution228/icons/obj/items.dmi'
	icon_state = "thermos"
	inhand_icon_state = "thermos"
	lefthand_file = 'white/rebolution228/icons/obj/mob/inhand_objects_left.dmi'
	righthand_file = 'white/rebolution228/icons/obj/mob/inhand_objects_right.dmi'
	volume = 50
	list_reagents = list(/datum/reagent/consumable/tea = 30)
	spillable = FALSE
	isGlass = FALSE
	custom_materials = list(/datum/material/iron=1500)
	custom_price = PAYCHECK_HARD * 2

//soviet flask

/obj/item/reagent_containers/food/drinks/flask/gold/soviet
	name = "советская фляжка"
	desc = "Старая позолоченная фляжка. В ней нет ничего примечательного, кроме того, что на ней изображена красная звезда. На крышке также есть гравировка \"ВДВ\" "
	icon = 'white/rebolution228/icons/obj/items.dmi'
	icon_state = "sovietflask"
	list_reagents = list(/datum/reagent/consumable/ethanol/vodka = 30)

// fan

/obj/item/melee/fan
	name = "вентилятор"
	desc = "Маленький настольный вентилятор. Кнопка \"ВКЛ\", кажись, застряла."
	inhand_icon_state = "lamp"
	icon_state = "fan"
	icon = 'white/rebolution228/icons/obj/items.dmi'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 7
	throwforce = 5
