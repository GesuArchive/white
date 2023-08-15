// 7.12x82mm (SAW)

/obj/item/ammo_casing/mm712x82
	name = "патрон калибра 7.12x82мм"
	desc = "Обычный патрон калибра 7.12x82мм. Используется в некоторых пулеметах."
	icon_state = "762-casing"
	caliber = "mm71282"
	projectile_type = /obj/projectile/bullet/mm712x82

/obj/item/ammo_casing/mm712x82/ap
	name = "бронебойный патрон калибра 7.12x82мм"
	desc = "Содержит пулю с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в некоторых пулеметах."
	projectile_type = /obj/projectile/bullet/mm712x82_ap

/obj/item/ammo_casing/mm712x82/hollow
	name = "экспансивный патрон калибра 7.12x82мм"
	desc = "Снаряжен пулей со смещенным центром тяжести. Наносит повышенный урон, однако заметно хуже пробивает броню. Используется в некоторых пулеметах."
	projectile_type = /obj/projectile/bullet/mm712x82_hp

/obj/item/ammo_casing/mm712x82/incen
	name = "зажигательный патрон калибра 7.12x82мм"
	desc = "При удачном попадании поджигает цель. Немного слабее стандартных пуль. Используется в некоторых пулеметах."
	projectile_type = /obj/projectile/bullet/incendiary/mm712x82

/obj/item/ammo_casing/mm712x82/match
	name = "самонаводящийся патрон калибра 7.12x82мм"
	desc = "Высококачественный патрон, пуля из которого с высокой вероятностью рикошетит и доводится на противника. Используется в некоторых пулеметах."
	projectile_type = /obj/projectile/bullet/mm712x82_match

/obj/item/ammo_casing/mm712x82/bouncy
	name = "травматический патрон калибра 7.12x82мм"
	desc = "Стандартная пуля заменена на резиновую болванку. Урон значительно снижен, однако такие попадания сильно изматывают цель, а пули могут рекошетить от стен. Используется в некоторых пулеметах."
	projectile_type = /obj/projectile/bullet/mm712x82_bouncy

/obj/item/ammo_casing/a792x57
	name = "гильза 7.92x57mm"
	caliber = "a792x57"
	projectile_type = /obj/projectile/bullet/a792x57

/obj/item/ammo_casing/a556carbine
	desc = "гильза 5.56mm"
	caliber = "229"
	projectile_type = /obj/projectile/bullet/a556

/obj/item/ammo_casing/carbine
	desc = "A 5.56mm bullet casing."
	caliber = "carab"
	projectile_type = /obj/projectile/bullet/carab

/obj/item/ammo_casing/assault_rifle
	desc = "Assault rifle bullet casing."
	caliber = "asr"
	projectile_type = /obj/projectile/bullet/assault_rifle
