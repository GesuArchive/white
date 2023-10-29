/obj/item/ammo_box/magazine/mm712x82
	name = "коробчатый магазин калибра 7.12x82мм"
	desc = "Содержит обычные патроны калибра 7.12x82мм. Используется в некоторых пулеметах."
	icon_state = "a762-50"
	ammo_type = /obj/item/ammo_casing/mm712x82
	caliber = "mm71282"
	max_ammo = 50

/obj/item/ammo_box/magazine/mm712x82/hollow
	name = "коробчатый магазин калибра 7.12x82мм: Экспансивный"
	desc = "Содержит пули со смещенным центром тяжести. Они наносят повышенный урон, однако заметно хуже пробивает броню. Используется в некоторых пулеметах."
	ammo_type = /obj/item/ammo_casing/mm712x82/hollow

/obj/item/ammo_box/magazine/mm712x82/ap
	name = "коробчатый магазин калибра 7.12x82мм: Бронебойный"
	desc = "Содержит пули с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в некоторых пулеметах."
	ammo_type = /obj/item/ammo_casing/mm712x82/ap

/obj/item/ammo_box/magazine/mm712x82/incen
	name = "коробчатый магазин калибра 7.12x82мм: Зажигательный"
	desc = "Содержит пули которые поджигают цель. Немного слабее стандартных пуль. Используется в некоторых пулеметах."
	ammo_type = /obj/item/ammo_casing/mm712x82/incen

/obj/item/ammo_box/magazine/mm712x82/match
	name = "коробчатый магазин калибра 7.12x82мм: Самонаводящийся"
	desc = "Содержит высококачественный патроны, пули которые с высокой вероятностью рикошетят и доводится на противника. Используется в некоторых пулеметах."
	ammo_type = /obj/item/ammo_casing/mm712x82/match

/obj/item/ammo_box/magazine/mm712x82/bouncy
	name = "коробчатый магазин калибра 7.12x82мм: Травматический"
	desc = "Стандартные пули заменены на резиновую болванку. Урон значительно снижен, однако такие попадания сильно изматывают цель, а пули могут рекошетить от стен. Используется в некоторых пулеметах."
	ammo_type = /obj/item/ammo_casing/mm712x82/bouncy

/obj/item/ammo_box/magazine/mm712x82/bouncy/hicap
	name = "коробчатый магазин повышенной емкости калибра 7.12x82мм: Травматический"
	desc = "Стандартные пули заменены на резиновую болванку. Урон значительно снижен, однако такие попадания сильно изматывают цель, а пули могут рекошетить от стен. Используется в некоторых пулеметах."
	max_ammo = 150

/obj/item/ammo_box/magazine/mm712x82/update_icon()
	..()
	icon_state = "a762-[round(ammo_count(),10)]"

/obj/item/ammo_box/magazine/a792x57
	name = "зарядник (7.92x57mm)"
	icon_state = "kclip"
	caliber = "a792x57"
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 5
	multiple_sprites = TRUE

/obj/item/ammo_box/magazine/a792x57/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/a556carbine
	name = "magazine (6.8mm)"
	icon_state = "5.56"
	caliber = "229"
	ammo_type = /obj/item/ammo_casing/a556carbine
	max_ammo = 15
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/carbine
	name = "magazine (5.56mm)"
	icon_state = "carb"
	caliber = "carab"
	ammo_type = /obj/item/ammo_casing/carbine
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/assault_rifle
	name = "assault rifle magazine"
	icon_state = "assault_rifle"
	caliber = "asr"
	ammo_type = /obj/item/ammo_casing/assault_rifle
	max_ammo = 25
	multiple_sprites = AMMO_BOX_FULL_EMPTY
