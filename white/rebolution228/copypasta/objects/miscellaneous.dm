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
	desc = "Старый металлический термос со слабым блеском."
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
	w_class = WEIGHT_CLASS_NORMAL

//soviet flask

/obj/item/reagent_containers/food/drinks/flask/gold/soviet
	name = "советская фляжка"
	desc = "Старая позолоченная фляжка. В ней нет ничего примечательного, кроме того, что на ней изображена красная звезда. На крышке также есть гравировка \"ВДВ\"."
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


// ashtray

/obj/item/ashtray
	name = "пепельница"
	desc = "Простая стеклянная пепельница для использованных сигарет."
	icon = 'white/rebolution228/icons/obj/items.dmi'
	icon_state = "ashtray"
	var/max_butts = 10
	var/health = 20
	w_class = WEIGHT_CLASS_SMALL


/obj/item/ashtray/attackby(obj/item/W as obj, mob/user as mob, params)
	if (istype(W,/obj/item/cigbutt) || istype(W,/obj/item/clothing/mask/cigarette) || istype(W, /obj/item/match))
		if (contents.len >= max_butts)
			to_chat(user,"Пепельница полная.")
			return
		W.loc = src

		if (istype(W,/obj/item/clothing/mask/cigarette))
			var/obj/item/clothing/mask/cigarette/cig = W
			if (cig.lit == 1)
				user.visible_message(span_notice("[user] тушит [cig] об пепельницу."))
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				del(cig)
			else if (cig.lit == 0)
				to_chat(user, span_notice("Пепельница явно не для того, чтобы складывать туда простые сигареты."))
				return

		add_fingerprint(user)
		update_icon()
	else
		health = max(0,health - W.force)
		user << "Вы ударяете [src] при помощи [W]."
		if (health < 1)
			die()
	return

/obj/item/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if(health < 1)
			die()
			return
		if(contents.len)
			to_chat(src, span_warning("Пепельница разбивается об [hit_atom]!"))
		for (var/obj/item/O in contents)
			O.loc = src.loc
		update_icon()
	return ..()

/obj/item/ashtray/proc/die()
	src.visible_message(span_danger("Пепельница разбивается, раскидывая свое содержимое!"))
	playsound(src, "shatter", 30, 1)
	new /obj/item/shard(src.loc)
	new /obj/effect/decal/cleanable/ash(src.loc)
	for (var/obj/item/O in contents)
		O.loc = src.loc
		O.pixel_y = rand(-5, 5)
		O.pixel_x = rand(-6, 6)
	qdel(src)

/obj/item/ashtray/update_icon()
	if (contents.len == max_butts)
		icon_state = "ashtray_full"
		desc = "[initial(desc)] Пепельница заполнена."
	else if (contents.len > 0)
		icon_state = "ashtray_half"
		desc = "[initial(desc)] Пепельница наполовину полная."
	else
		icon_state = "ashtray"
	return ..()
