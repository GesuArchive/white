
GLOBAL_LIST_EMPTY(violence_gear_categories)
GLOBAL_LIST_EMPTY(violence_gear_datums)

// если товаров в магазине ещё нет, то генерирует их из всех возможных подтипов для текущего режима
/proc/generate_violence_gear()
	for(var/geartype in subtypesof(/datum/violence_gear))
		var/datum/violence_gear/VG = new geartype
		if(!initial(VG.cost))
			continue
		if(LAZYLEN(VG.allowed_themes) && !(SSviolence.theme in VG.allowed_themes))
			qdel(VG)
			continue
		if(!GLOB.violence_gear_categories[VG.cat])
			GLOB.violence_gear_categories[VG.cat] = new /datum/violence_gear_category(VG.cat)
		GLOB.violence_gear_datums[VG.name] = VG
		var/datum/violence_gear_category/VC = GLOB.violence_gear_categories[VG.cat]
		VC.gear[VG.name] = GLOB.violence_gear_datums[VG.name]
	GLOB.violence_gear_categories = sort_assoc(GLOB.violence_gear_categories)
	return TRUE

// генерируется автоматически, тебе определённо НЕ стоит это трогать
/datum/violence_gear_category
	var/cat = ""
	var/list/gear = list()

/datum/violence_gear_category/New(new_cat)
	cat = new_cat
	..()

/datum/violence_gear
	// название предмета в магазине
	var/name = "???"
	// название категории, создаётся автоматически
	var/cat = "ХУЙ"
	// стоимость. Если 0, то игнорируем
	var/cost = 0
	// список предметов, которые будут выданы при раздаче
	var/list/items = list()
	// специальный тип для киберспейса
	var/random_type = null
	// список разрешённых тем, где можно купить это
	var/list/allowed_themes = list()

/datum/violence_gear/melee
	cat = "Ближний бой"

/datum/violence_gear/melee/extinguisher
	name = "Огнетушитель"
	cost = 25
	items = list(/obj/item/extinguisher)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/melee/rocket
	name = "Перчатки ракеты"
	cost = 65
	items = list(/obj/item/clothing/gloves/tackler/rocket)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/melee/combat
	name = "Боевой нож"
	cost = 70
	items = list(/obj/item/kitchen/knife/combat)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/melee/bat
	name = "Бита"
	cost = 80
	items = list(/obj/item/melee/baseball_bat)
	allowed_themes = list(VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/melee/sabre
	name = "Сабля"
	cost = 225
	items = list(/obj/item/melee/sabre)
	allowed_themes = list(VIOLENCE_THEME_STD)

/datum/violence_gear/melee/katana
	name = "Катана"
	cost = 350
	items = list(/obj/item/katana)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/melee/ignis
	name = "Ignis"
	cost = 700
	items = list(/obj/item/melee/energy/sword/ignis)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_KATANA, VIOLENCE_THEME_PORTAL)

/datum/violence_gear/pistol
	cat = "Пистолеты"

/datum/violence_gear/pistol/handmade
	name = "Самодельный"
	cost = 200
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/fallout/m9mm/handmade,
		/obj/item/ammo_box/magazine/fallout/m9mm
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/pistol/pistol45
	name = "Пистолет"
	cost = 250
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/fallout/pistol45,
		/obj/item/ammo_box/magazine/fallout/m45
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/pistol/mateba
	name = "Матеба"
	cost = 500
	items = list(
		/obj/item/gun/ballistic/revolver/mateba,
		/obj/item/ammo_box/a357
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/pistol/deagle
	name = "Пустынный орёл"
	cost = 750
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/deagle,
		/obj/item/ammo_box/magazine/m50
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/pistol/golden_eagle
	name = "FTU PDH-6G"
	cost = 1000
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/golden_eagle,
		/obj/item/ammo_box/magazine/mm12/saphe
	)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/rifle
	cat = "Винтовки"

/datum/violence_gear/rifle/HK416
	name = "HK416"
	cost = 450
	items = list(
		/obj/item/gun/ballistic/automatic/HK416,
		/obj/item/ammo_box/magazine/HK416
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/rifle/c20r
	name = "C-20r SMG"
	cost = 475
	items = list(
		/obj/item/gun/ballistic/automatic/c20r/unrestricted,
		/obj/item/ammo_box/magazine/smgm45
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/rifle/mp5
	name = "MP5"
	cost = 550
	items = list(
		/obj/item/gun/ballistic/automatic/mp5,
		/obj/item/ammo_box/magazine/mp5
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE, VIOLENCE_THEME_PORTAL)

/datum/violence_gear/rifle/assaultrifle
	name = "Штурмовая винтовка"
	cost = 600
	items = list(
		/obj/item/gun/ballistic/automatic/fallout/assaultrifle,
		/obj/item/ammo_box/magazine/fallout/r20
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/rifle/M41A
	name = "M41A"
	cost = 625
	items = list(
		/obj/item/gun/ballistic/automatic/M41A,
		/obj/item/ammo_box/magazine/m41a
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/rifle/z8
	name = "Z8"
	cost = 800
	items = list(
		/obj/item/gun/ballistic/automatic/m90/unrestricted/z8,
		/obj/item/ammo_box/magazine/a556carbine
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/rifle/r37
	name = "Xan-Jing R37"
	cost = 1750
	items = list(
		/obj/item/gun/ballistic/automatic/pitbull/r37,
		/obj/item/ammo_box/magazine/r37
	)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/rifle/r40
	name = "Xan-Jing R40"
	cost = 2500
	items = list(
		/obj/item/gun/ballistic/automatic/pitbull/r40,
		/obj/item/ammo_box/magazine/r40
	)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/shotgun
	cat = "Дробовики"

/datum/violence_gear/shotgun/lethal
	name = "Помповый дробовик"
	cost = 250
	items = list(
		/obj/item/gun/ballistic/shotgun/lethal,
		/obj/item/storage/box/lethalshot
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/shotgun/lever
	name = "Дезинтегратор"
	cost = 300
	items = list(
		/obj/item/gun/ballistic/shotgun/fallout/lever,
		/obj/item/storage/box/lethalshot
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/shotgun/bulldog
	name = "Bulldog"
	cost = 325
	items = list(
		/obj/item/gun/ballistic/shotgun/bulldog/unrestricted,
		/obj/item/ammo_box/magazine/m12g,
		/obj/item/storage/box/lethalshot
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/heavygun
	cat = "Тяжёлое оружие"

/datum/violence_gear/heavygun/beam_rifle
	name = "УЧВ"
	cost = 400
	items = list(/obj/item/gun/energy/beam_rifle/violence)
	allowed_themes = list(VIOLENCE_THEME_KATANA, VIOLENCE_THEME_PORTAL)

/datum/violence_gear/heavygun/hecate
	name = "Hecate II"
	cost = 450
	items = list(
		/obj/item/gun/ballistic/rifle/boltaction/hecate,
		/obj/item/ammo_box/magazine/sniper_rounds/penetrator
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/heavygun/rocketlauncher
	name = "PML-9"
	cost = 500
	items = list(
		/obj/item/gun/ballistic/rocketlauncher/unrestricted,
		/obj/item/ammo_casing/caseless/rocket
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/heavygun/l6_saw
	name = "L6 SAW"
	cost = 825
	items = list(
		/obj/item/gun/ballistic/automatic/l6_saw/unrestricted,
		/obj/item/ammo_box/magazine/mm712x82
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/heavygun/xray
	name = "X-Ray"
	cost = 950
	items = list(/obj/item/gun/energy/xray/violence)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/armor
	cat = "Броня"

/datum/violence_gear/armor/basic
	name = "Бронежилет"
	cost = 200
	items = list(
		/obj/item/clothing/suit/armor/vest/hecu,
		/obj/item/clothing/mask/gas/heavy/m40,
		/obj/item/clothing/head/helmet/hecu,
		/obj/item/clothing/gloves/combat
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/armor/bulletproof
	name = "Пуленепробиваемый"
	cost = 450
	items = list(
		/obj/item/clothing/suit/armor/bulletproof/hecu,
		/obj/item/clothing/mask/gas/heavy/gp7vm,
		/obj/item/clothing/head/helmet/alt/hecu,
		/obj/item/clothing/gloves/combat
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/armor/pcv
	name = "PCV MARK II"
	cost = 650
	items = list(
		/obj/item/clothing/suit/space/hev_suit/pcv,
		/obj/item/clothing/gloves/combat,
		/obj/item/clothing/mask/gas/heavy/m40,
		/obj/item/clothing/head/helmet/space/hev_suit/pcv,
		/obj/item/clothing/shoes/combat/swat
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/armor/deathsquad
	name = "Дедушка"
	cost = 900
	items = list(
		/obj/item/clothing/suit/space/hardsuit/deathsquad,
		/obj/item/clothing/gloves/combat,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/shoes/combat/swat
	)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/shield
	cat = "Щиты"

/datum/violence_gear/shield/buckler
	name = "Деревянный щит"
	cost = 200
	items = list(/obj/item/shield/riot/buckler)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/shield/riot
	name = "Крепкий щит"
	cost = 300
	items = list(/obj/item/shield/riot)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/shield/kevlar
	name = "Кевларовый щит"
	cost = 600
	items = list(/obj/item/shield/riot/kevlar)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/misc
	cat = "Различное"

/datum/violence_gear/misc/medkit
	name = "Жгут"
	cost = 25
	items = list(/obj/item/stack/medical/suture/medicated)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE, VIOLENCE_THEME_KATANA, VIOLENCE_THEME_PORTAL)

/datum/violence_gear/misc/sunglasses
	name = "Солнцезащитные"
	cost = 30
	items = list(/obj/item/clothing/glasses/sunglasses)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE, VIOLENCE_THEME_KATANA, VIOLENCE_THEME_PORTAL)

/datum/violence_gear/misc/wirecutters
	name = "Кусачки"
	cost = 35
	items = list(/obj/item/wirecutters)

/datum/violence_gear/misc/flare
	name = "Сигнальная шашка"
	cost = 40
	items = list(/obj/item/flashlight/flare)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE, VIOLENCE_THEME_KATANA, VIOLENCE_THEME_PORTAL)

/datum/violence_gear/misc/teargas
	name = "Перцовый газ"
	cost = 60
	items = list(/obj/item/grenade/chem_grenade/teargas)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/misc/frag
	name = "Осколочная"
	cost = 90
	items = list(/obj/item/grenade/frag)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE)

/datum/violence_gear/misc/thermal
	name = "Термалы"
	cost = 1250
	items = list(/obj/item/clothing/glasses/hud/toggle/thermal)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE, VIOLENCE_THEME_KATANA)

/datum/violence_gear/ammo
	cat = "Аммуниция"

/datum/violence_gear/ammo/m9mm
	name = "П. Обойма 9mm"
	cost = 25
	items = list(/obj/item/ammo_box/magazine/fallout/m9mm)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/m45
	name = "П. Обойма .45"
	cost = 30
	items = list(/obj/item/ammo_box/magazine/fallout/m45)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/a357
	name = "П. Зарядник .357"
	cost = 40
	items = list(/obj/item/ammo_box/a357)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/m50
	name = "П. Обойма .50ae"
	cost = 50
	items = list(/obj/item/ammo_box/magazine/m50)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/saphe
	name = "П. Обойма 12.7x35mm"
	cost = 300
	items = list(/obj/item/ammo_box/magazine/mm12/saphe)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/ammo/HK416
	name = "А. Магазин HK416"
	cost = 75
	items = list(/obj/item/ammo_box/magazine/HK416)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/smgm45
	name = "А. Магазин .45"
	cost = 90
	items = list(/obj/item/ammo_box/magazine/smgm45)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/MP5
	name = "А. Магазин MP5"
	cost = 100
	items = list(/obj/item/ammo_box/magazine/mp5)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/r20
	name = "А. Магазин 5.56mm"
	cost = 125
	items = list(/obj/item/ammo_box/magazine/fallout/r20)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/m41a
	name = "А. Магазин 4.6x30mm"
	cost = 175
	items = list(/obj/item/ammo_box/magazine/m41a)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/a556carbine
	name = "А. Магазин 6.8mm"
	cost = 150
	items = list(/obj/item/ammo_box/magazine/a556carbine)
	allowed_themes = list(VIOLENCE_THEME_STD, VIOLENCE_THEME_WARFARE, VIOLENCE_THEME_HOTLINE)

/datum/violence_gear/ammo/r37
	name = "А. Магазин 6.5mm"
	cost = 315
	items = list(/obj/item/ammo_box/magazine/r37)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/ammo/r40
	name = "А. Магазин 7.2mm"
	cost = 350
	items = list(/obj/item/ammo_box/magazine/r40)
	allowed_themes = list(VIOLENCE_THEME_KATANA)

/datum/violence_gear/random
	cat = "Случайное"

/datum/violence_gear/random/food
	name = "ЕДА"
	cost = 5
	random_type = /obj/item/food
	allowed_themes = list(VIOLENCE_THEME_CYBER)

/datum/violence_gear/random/clothing
	name = "ОДЕЖДА"
	cost = 10
	random_type = /obj/item/clothing
	allowed_themes = list(VIOLENCE_THEME_CYBER)

/datum/violence_gear/random/book
	name = "КНИГА"
	cost = 20
	random_type = /obj/item/book
	allowed_themes = list(VIOLENCE_THEME_CYBER)

/datum/violence_gear/random/reagent_containers
	name = "РЕАГЕНТ"
	cost = 40
	random_type = /obj/item/reagent_containers
	allowed_themes = list(VIOLENCE_THEME_CYBER)

/datum/violence_gear/random/shield
	name = "ЩИТ"
	cost = 80
	random_type = /obj/item/shield
	allowed_themes = list(VIOLENCE_THEME_CYBER)

/datum/violence_gear/random/melee
	name = "БЛИЖНИЙ БОЙ"
	cost = 160
	random_type = /obj/item/melee
	allowed_themes = list(VIOLENCE_THEME_CYBER)

/datum/violence_gear/random/gun
	name = "ДАЛЬНИЙ БОЙ"
	cost = 320
	random_type = /obj/item/gun
	allowed_themes = list(VIOLENCE_THEME_CYBER)
