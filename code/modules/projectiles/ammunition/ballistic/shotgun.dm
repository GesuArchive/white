// Shotgun

/obj/item/ammo_casing/shotgun
	name = "12 Калибр: Пулевой"
	desc = "Свинцовый стержень 12 калибра."
	icon_state = "blshell"
	worn_icon_state = "shell"
	caliber = "shotgun"
	custom_materials = list(/datum/material/iron=4000)
	projectile_type = /obj/projectile/bullet/shotgun_slug

/obj/item/ammo_casing/shotgun/executioner
	name = "12 Калибр: Заостренный"
	desc = "A 12 gauge lead slug purpose built to annihilate flesh on impact."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_slug/executioner

/obj/item/ammo_casing/shotgun/pulverizer
	name = "12 Калибр: Травматический"
	desc = "A 12 gauge lead slug purpose built to annihilate bones on impact."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_slug/pulverizer

/obj/item/ammo_casing/shotgun/beanbag
	name = "12 Калибр: Резиновая пуля"
	desc = "Мелкие резинки для контроля над беспорядками."
	icon_state = "bshell"
	custom_materials = list(/datum/material/iron=250)
	projectile_type = /obj/projectile/bullet/shotgun_beanbag

/obj/item/ammo_casing/shotgun/incendiary
	name = "12 Калибр: Зажигательный патрон"
	desc = "Пуля с зажигательным покрытием."
	icon_state = "ishell"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun

/obj/item/ammo_casing/shotgun/dragonsbreath
	name = "12 Калибр: Драконье дыхание"
	desc = "Пуля, которая выдаёт кучу горящих шариков."
	icon_state = "ishell2"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun/dragonsbreath
	pellets = 4
	variance = 35

/obj/item/ammo_casing/shotgun/stunslug
	name = "12 Калибр: Электрошоковый патрон"
	desc = "Останавливающая пуля с живительным зарядом энергии внутри."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_stunslug
	custom_materials = list(/datum/material/iron=250)

/obj/item/ammo_casing/shotgun/meteorslug
	name = "12 Калибр: Метеоритный патрон"
	desc = "Пуля оснащенная технологией CMC, которая при выстреле запускает массивный снаряд."
	icon_state = "mshell"
	projectile_type = /obj/projectile/bullet/shotgun_meteorslug

/obj/item/ammo_casing/shotgun/pulseslug
	name = "12 Калибр: Импульсный патрон"
	desc = "Деликатное устройство, которое можно загрузить в ружье. Праймер действует как кнопка, \
	которая запускает среду усиления и запускает мощный энергетический взрыв. Хотя отвод тепла и \
	энергии ограничивает одно использование, он все же может позволить оператору поражать цели, \
	с которыми у баллистических боеприпасов возникнут трудности."
	icon_state = "pshell"
	projectile_type = /obj/projectile/beam/pulse/shotgun

/obj/item/ammo_casing/shotgun/frag12
	name = "12 Калибр: FRAG-12"
	desc = "Выстрел из взрывчатого вещества с большой взрывчаткой для дробовика 12 калибра."
	icon_state = "heshell"
	projectile_type = /obj/projectile/bullet/shotgun_frag12

/obj/item/ammo_casing/shotgun/buckshot
	name = "12 Калибр: Картечь"
	desc = "Шарики 12 калибра."
	icon_state = "gshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_buckshot
	pellets = 6
	variance = 25

/obj/item/ammo_casing/shotgun/rubbershot
	name = "12 Калибр: Резиновая картечь"
	desc = "Пуля, заполненная плотно упакованными резиновыми шариками, используется для выведения людей из строя на расстоянии."
	icon_state = "bshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_rubbershot
	pellets = 6
	variance = 25
	custom_materials = list(/datum/material/iron=4000)

/obj/item/ammo_casing/shotgun/incapacitate
	name = "12 Калибр: Резиновая дробь"
	desc = "Патрон заполненный чем-то... Используется для обезвреживания людей."
	icon_state = "bountyshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_incapacitate
	pellets = 12//double the pellets, but half the stun power of each, which makes this best for just dumping right in someone's face.
	variance = 25
	custom_materials = list(/datum/material/iron=4000)

/obj/item/ammo_casing/shotgun/improvised
	name = "12 Калибр: Самодельный патрон"
	desc = "Чрезвычайно слабая пуля с несколькими маленькими шариками из металлических осколков."
	icon_state = "improvshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_improvised
	custom_materials = list(/datum/material/iron=250)
	pellets = 10
	variance = 25

/obj/item/ammo_casing/shotgun/ion
	name = "12 Калибр: Ионная Картечь"
	desc = "Усовершенствованная пуля, в которой используется подпространственный кристалл для создания эффекта, аналогичного стандартной ионной винтовке. \
	Уникальные свойства кристалла разбивают импульс на множество индивидуально более слабых болтов."
	icon_state = "ionshell"
	projectile_type = /obj/projectile/ion/weak
	pellets = 4
	variance = 35

/obj/item/ammo_casing/shotgun/laserslug
	name = "12 Калибр: Лазерная картечь"
	desc = "Усовершенствованная пуля, которая использует микро-лазер для воспроизведения эффектов лазерного оружия рассеяния в баллистической упаковке."
	icon_state = "lshell"
	projectile_type = /obj/projectile/beam/weak
	pellets = 6
	variance = 35

/obj/item/ammo_casing/shotgun/techshell
	name = "12 Калибр: Пустой высокотехнологичный патрон"
	desc = "Высокотехнологичная пуля, в которую можно загружать материалы для создания уникальных эффектов."
	icon_state = "cshell"
	projectile_type = null

/obj/item/ammo_casing/shotgun/dart
	name = "12 Калибр: Дротик"
	desc = "Дротик для использования в ружьях. Может вводиться до 30 единиц любого химического вещества."
	icon_state = "cshell"
	projectile_type = /obj/projectile/bullet/dart
	var/reagent_amount = 30

/obj/item/ammo_casing/shotgun/dart/Initialize()
	. = ..()
	create_reagents(reagent_amount, OPENCONTAINER)

/obj/item/ammo_casing/shotgun/dart/attackby()
	return

/obj/item/ammo_casing/shotgun/dart/bioterror
	desc = "Патрон наполненный смертельными токсинами."

/obj/item/ammo_casing/shotgun/dart/bioterror/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/neurotoxin, 6)
	reagents.add_reagent(/datum/reagent/toxin/spore, 6)
	reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 6) //;HELP OPS IN MAINT
	reagents.add_reagent(/datum/reagent/toxin/coniine, 6)
	reagents.add_reagent(/datum/reagent/toxin/sodium_thiopental, 6)

/obj/item/ammo_casing/shotgun/apslug
	name = "12 Калибр: Бронебойная пуля"
	desc = "Бронебойный патрон с копьевидной пулей для ружей 12g."
	icon_state = "apshell"
	projectile_type = /obj/projectile/bullet/apslug
