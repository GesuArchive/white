/obj/item/ammo_box/a357
	name = "скорозарядник .357 калибра"
	desc = "Предназначен для быстрой перезарядки крупнокалиберных револьверов. Содержит в себе обычные патроны .357 калибра."
	icon_state = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 7
	multiple_sprites = AMMO_BOX_PER_BULLET
	item_flags = NO_MAT_REDEMPTION

/obj/item/ammo_box/a357/match
	name = "скорозарядник .357 калибра: Самонаводящиеся"
	desc = "Предназначен для быстрой перезарядки крупнокалиберных револьверов. Высококачественный патрон, пуля из которого с высокой вероятностью рикошетит и доводится на противника."
	ammo_type = /obj/item/ammo_casing/a357/match

/obj/item/ammo_box/c38
	name = "скорозарядник .38 калибра"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Содержит в себе обычные патроны .38 калибра."
	icon_state = "38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = AMMO_BOX_PER_BULLET
	custom_materials = list(/datum/material/iron = 20000)

/obj/item/ammo_box/c38/trac
	name = "скорозарядник .38 калибра: Следящий"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Содержит в себе следящий микроимплант. Сильно слабее стандартных пуль."
	ammo_type = /obj/item/ammo_casing/c38/trac

/obj/item/ammo_box/c38/match
	name = "скорозарядник .38 калибра: Самонаводящиеся"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Высококачественный патрон, пуля из которого с высокой вероятностью рикошетит и доводится на противника."
	ammo_type = /obj/item/ammo_casing/c38/match

/obj/item/ammo_box/c38/match/bouncy
	name = "скорозарядник .38 калибра: Травматический"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Высококачественный НЕ ЛЕТАЛЬНЫЙ патрон, пуля из которого с высокой вероятностью рикошетит и доводится на противника."
	ammo_type = /obj/item/ammo_casing/c38/match/bouncy

/obj/item/ammo_box/c38/dumdum
	name = "скорозарядник .38 калибра: Экспансивный"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. Наносит повышенный урон, однако заметно хуже пробивает броню."
	ammo_type = /obj/item/ammo_casing/c38/dumdum

/obj/item/ammo_box/c38/hotshot
	name = "скорозарядник .38 калибра: Зажигательный"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. При удачном попадании поджигает цель. Немного слабее стандартных пуль."
	ammo_type = /obj/item/ammo_casing/c38/hotshot

/obj/item/ammo_box/c38/iceblox
	name = "скорозарядник .38 калибра: Замораживающий"
	desc = "Предназначен для быстрой перезарядки старомодных револьверов. При удачном попадании замораживает цель. Немного слабее стандартных пуль."
	ammo_type = /obj/item/ammo_casing/c38/iceblox

/obj/item/ammo_box/c9mm
	name = "упаковка 9мм патронов"
	desc = "Обычные патроны калибра 9мм. Используется в пистолетах и пистолет-пулеметах."
	icon_state = "9mmbox"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_box/c9mm_traumatic
	name = "упаковка травматических 9мм патронов"
	desc = "Боевая пуля в них заменена на резиновую болванку. Практически не наносит урона, однако валит с пары-тройки попаданий."
	icon_state = "9mmbox"
	ammo_type = /obj/item/ammo_casing/c9mm/traumatic
	max_ammo = 30

/obj/item/ammo_box/c10mm
	name = "упаковка 10мм патронов"
	desc = "Обычные патроны калибра 10мм. Используется в пистолетах."
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 30

/obj/item/ammo_box/c45
	name = "упаковка патронов .45 калибра"
	desc = "Обычные патроны калибра .45мм. Используется в пистолетах и пистолет-пулеметах."
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30

/obj/item/ammo_box/a50ae
	name = "упаковка патронов .50AE калибра"
	desc = "Обычные патроны калибра 50AE. Используется в пистолете Пустынный Орел."
	icon_state = "50aebox"
	ammo_type = /obj/item/ammo_casing/a50ae
	max_ammo = 20

/obj/item/ammo_box/a40mm
	name = "упаковка 40мм гранат"
	desc = "Боевая фугасная граната, которая может быть активирована только при выстрела из гранатомета."
	icon_state = "40mm"
	ammo_type = /obj/item/ammo_casing/a40mm
	max_ammo = 4
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/a762
	name = "скорозарядник калибра 7.62мм"
	desc = "Вмещает до 5 патронов калибра 7.62мм. Подходит к винтовке Мосина."
	icon_state = "762"
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 5
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/zinc_762
	name = "цинк патронов калибра 7.62мм"
	desc = "Вмещает 90 патронов калибра 7.62мм. Подходит к большинству оружия Красной Армии."
	icon = 'icons/obj/storage.dmi'
	icon_state = "ammobox"
	inhand_icon_state = "ammobox"
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound =  'sound/items/handling/ammobox_pickup.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 90

/obj/item/ammo_box/magazine/ak47mag
	name = "магазин калибра 7.62мм"
	desc = "Содержит обычные патроны калибра 7.62мм. Подходит к автомату Калашникова."
	icon = 'white/valtos/icons/ammo.dmi'
	icon_state = "akm"
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	max_ammo = 30

/obj/item/ammo_box/magazine/ak47mag/update_icon()
	..()
	icon_state = "akm-[ammo_count() ? "30" : "0"]"

/obj/item/ammo_box/n762
	name = "упаковка патронов калибра 7.62x38мм-R"
	desc = "Содержит обычные патроны калибра 7.62x38мм-R. Используется в револьверах системы Нагана."
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/n762
	max_ammo = 14

/obj/item/ammo_box/foambox
	name = "упаковка пенчиков"
	desc = "Детям от восьми лет и старше."
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foambox"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 40
	custom_materials = list(/datum/material/iron = 500)

/obj/item/ammo_box/foambox/riot
	name = "упаковка резиновых пенчиков"
	desc = "Повышенного останавливающего возздействия. Детям от восьми лет и старше."
	icon_state = "foambox_riot"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot
	custom_materials = list(/datum/material/iron = 50000)

/obj/item/ammo_box/n792x57
	name = "ящик с патронами (7.92x57)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 14
