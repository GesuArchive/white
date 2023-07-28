/obj/item/ammo_box/magazine/wt550m9
	name = "магазин калибра 4.6x30мм"
	desc = "Содержит обычные патроны калибра 4.6x30мм. Используется в пистолет-пулемете ВТ-550."
	icon_state = "46x30mmt-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	caliber = "4.6x30mm"
	max_ammo = 20

/obj/item/ammo_box/magazine/wt550m9/update_icon()
	..()
	icon_state = "46x30mmt-[round(ammo_count(),4)]"

/obj/item/storage/toolbox/ammo/wt550

/obj/item/storage/toolbox/ammo/wt550/PopulateContents()
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)
	new /obj/item/ammo_box/magazine/wt550m9(src)

/obj/item/ammo_box/magazine/wt550m9/wtap
	name = "магазин калибра 4.6x30мм: Бронебойный"
	desc = "Содержит патроны с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в пистолет-пулемете ВТ-550."
	icon_state = "46x30mmtA-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/ap

/obj/item/ammo_box/magazine/wt550m9/wtap/update_icon()
	..()
	icon_state = "46x30mmtA-[round(ammo_count(),4)]"

/obj/item/ammo_box/magazine/wt550m9/wtic
	name = "магазин калибра 4.6x30мм: Зажигательный"
	desc = "Содержит патроны поджигающие цель. Немного слабее стандартных пуль. Используется в пистолет-пулемете ВТ-550."
	icon_state = "46x30mmtI-20"
	ammo_type = /obj/item/ammo_casing/c46x30mm/inc

/obj/item/ammo_box/magazine/wt550m9/wtic/update_icon()
	..()
	icon_state = "46x30mmtI-[round(ammo_count(),4)]"

/obj/item/ammo_box/magazine/plastikov9mm
	name = "магазин калибра 9x19мм"
	desc = "Содержит обычные патроны калибра 9x19мм. Используется в пистолет-пулемете ПП-95."
	icon_state = "9x19-50"
	ammo_type = /obj/item/ammo_casing/c9x19mm
	caliber = "9x19mm"
	max_ammo = 50

/obj/item/ammo_box/magazine/plastikov9mm/update_icon()
	. = ..()
	if(ammo_count())
		icon_state = "9x19-50"
		return
	icon_state = "9x19-0"

/obj/item/ammo_box/magazine/uzim9mm
	name = "магазин калибра 9мм"
	desc = "Содержит обычные патроны калибра 9мм. Используется в пистолет-пулемете Uzi-U3."
	icon_state = "uzi9mm-32"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 32

/obj/item/ammo_box/magazine/uzim9mm/update_icon()
	..()
	icon_state = "uzi9mm-[round(ammo_count(),4)]"

/obj/item/ammo_box/magazine/smgm9mm
	name = "автоматный магазин калибра 9мм"
	desc = "Содержит обычные патроны калибра 9мм. Используется в пистолет-пулемете Saber."
	icon_state = "smg9mm-42"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 21

/obj/item/ammo_box/magazine/smgm9mm/update_icon()
	..()
	icon_state = "smg9mm-[ammo_count() ? "42" : "0"]"

/obj/item/ammo_box/magazine/smgm9mm/ap
	name = "автоматный магазин калибра 9мм: Бронебойный"
	desc = "Содержит патроны с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в пистолет-пулемете Saber."
	ammo_type = /obj/item/ammo_casing/c9mm/ap

/obj/item/ammo_box/magazine/smgm9mm/fire
	name = "автоматный магазин калибра 9мм: Зажигательный"
	desc = "Содержит патроны поджигающие цель. Немного слабее стандартных пуль. Используется в пистолет-пулемете Saber."
	ammo_type = /obj/item/ammo_casing/c9mm/fire

/obj/item/ammo_box/magazine/smgm45
	name = "автоматный магазин .45 калибра"
	desc = "Содержит обычные патроны .45 калибра. Используется в пистолет-пулемете С-20р."
	icon_state = "c20r45-24"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 24

/obj/item/ammo_box/magazine/smgm45/update_icon()
	..()
	icon_state = "c20r45-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/smgm45/ap
	name = "автоматный магазин .45 калибра: Бронебойный"
	desc = "Содержит патроны с закаленным сердечником, это заметно повышает бронепробитие, однако незначительно понижает урон. Используется в пистолет-пулемете С-20р."
	ammo_type = /obj/item/ammo_casing/c45/ap

/obj/item/ammo_box/magazine/smgm45/incen
	name = "автоматный магазин .45 калибра: Зажигательный"
	desc = "Содержит патроны поджигающие цель. Немного слабее стандартных пуль. Используется в пистолет-пулемете С-20р."
	ammo_type = /obj/item/ammo_casing/c45/inc

/obj/item/ammo_box/magazine/tommygunm45
	name = "барабанный магазин .45 калибра"
	desc = "Содержит обычные патроны .45 калибра. Используется в пистолет-пулемёте Томпсона."
	icon_state = "drum45"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 50
