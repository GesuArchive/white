
GLOBAL_LIST_EMPTY(violence_gear_categories)
GLOBAL_LIST_EMPTY(violence_gear_datums)

/proc/generate_violence_gear()
	for(var/geartype in subtypesof(/datum/violence_gear))
		var/datum/violence_gear/VG = geartype
		if(!initial(VG.cost))
			continue
		if(!GLOB.violence_gear_categories[initial(VG.cat)])
			GLOB.violence_gear_categories[initial(VG.cat)] = new /datum/violence_gear_category(initial(VG.cat))
		GLOB.violence_gear_datums[initial(VG.name)] = new geartype
		var/datum/violence_gear_category/VC = GLOB.violence_gear_categories[initial(VG.cat)]
		VC.gear[initial(VG.name)] = GLOB.violence_gear_datums[initial(VG.name)]
	GLOB.violence_gear_categories = sortAssoc(GLOB.violence_gear_categories)
	return TRUE

/datum/violence_gear_category
	var/cat = ""
	var/list/gear = list()

/datum/violence_gear_category/New(new_cat)
	cat = new_cat
	..()

/datum/violence_gear
	var/name = "???"
	var/cat = "ХУЙ"
	var/cost = 0
	var/items = list()

/datum/violence_gear/melee
	cat = "Ближний бой"

/datum/violence_gear/melee/extinguisher
	name = "Огнетушитель"
	cost = 100
	items = list(/obj/item/extinguisher)

/datum/violence_gear/melee/toolbox
	name = "Ящик с инструментами"
	cost = 200
	items = list(/obj/item/storage/toolbox/mechanical/empty)

/datum/violence_gear/melee/combat
	name = "Боевой нож"
	cost = 700
	items = list(/obj/item/kitchen/knife/combat)

/datum/violence_gear/melee/sabre
	name = "Сабля"
	cost = 1200
	items = list(/obj/item/melee/sabre/german)

/datum/violence_gear/pistol
	cat = "Пистолеты"

/datum/violence_gear/pistol/m1911
	name = "M1911"
	cost = 1250
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/m1911,
		/obj/item/ammo_box/magazine/m45
	)

/datum/violence_gear/pistol/makarov
	name = "Макаров"
	cost = 1500
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/makarov,
		/obj/item/ammo_box/magazine/m9mm
	)

/datum/violence_gear/pistol/mateba
	name = "Матеба"
	cost = 2250
	items = list(
		/obj/item/gun/ballistic/revolver/mateba,
		/obj/item/ammo_box/a357
	)

/datum/violence_gear/pistol/deagle
	name = "Пустынный орёл"
	cost = 2500
	items = list(
		/obj/item/gun/ballistic/automatic/pistol/deagle,
		/obj/item/ammo_box/magazine/m50
	)

/datum/violence_gear/rifle
	cat = "Винтовки"

/datum/violence_gear/rifle/scope
	name = "Болтовка с оптикой"
	cost = 2750
	items = list(
		/obj/item/gun/ballistic/rifle/boltaction/kar98k/scope,
		/obj/item/ammo_box/n792x57
	)

/datum/violence_gear/rifle/c20r
	name = "C-20r SMG"
	cost = 3250
	items = list(
		/obj/item/gun/ballistic/automatic/c20r/unrestricted,
		/obj/item/ammo_box/magazine/smgm45
	)

/datum/violence_gear/rifle/ak74m
	name = "АК-74m"
	cost = 3750
	items = list(
		/obj/item/gun/ballistic/automatic/ak74m,
		/obj/item/ammo_box/magazine/ak74m
	)

/datum/violence_gear/rifle/asval
	name = "Вал"
	cost = 4250
	items = list(
		/obj/item/gun/ballistic/automatic/asval,
		/obj/item/ammo_box/magazine/asval
	)

/datum/violence_gear/shotgun
	cat = "Дробовики"

/datum/violence_gear/shotgun/doublebarrel
	name = "Двухстволка"
	cost = 950
	items = list(
		/obj/item/gun/breakopen/doublebarrel,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/shotgun/combat
	name = "Боевой дробовик"
	cost = 1750
	items = list(
		/obj/item/gun/ballistic/shotgun/automatic/combat,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/shotgun/saiga
	name = "Сайга"
	cost = 2250
	items = list(
		/obj/item/gun/ballistic/shotgun/saiga,
		/obj/item/ammo_box/magazine/saiga,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/shotgun/bulldog
	name = "Bulldog"
	cost = 2500
	items = list(
		/obj/item/gun/ballistic/shotgun/bulldog/unrestricted,
		/obj/item/ammo_box/magazine/m12g,
		/obj/item/storage/box/lethalshot
	)

/datum/violence_gear/heavygun
	cat = "Тяжёлое оружие"

/datum/violence_gear/heavygun/rocketlauncher
	name = "PML-9"
	cost = 4500
	items = list(
		/obj/item/gun/ballistic/rocketlauncher/unrestricted,
		/obj/item/ammo_casing/caseless/rocket
	)

/datum/violence_gear/heavygun/l6_saw
	name = "L6 SAW"
	cost = 6250
	items = list(
		/obj/item/gun/ballistic/automatic/l6_saw/unrestricted,
		/obj/item/ammo_box/magazine/mm712x82
	)

/datum/violence_gear/armor
	cat = "Броня"

/datum/violence_gear/armor/basic
	name = "Бронежилет"
	cost = 650
	items = list(
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/gloves/fingerless
	)

/datum/violence_gear/armor/bulletproof
	name = "Пуленепробиваемый"
	cost = 1050
	items = list(
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/mask/gas/sechailer,
		/obj/item/clothing/head/helmet/alt,
		/obj/item/clothing/gloves/combat
	)

/datum/violence_gear/armor/specops
	name = "Спецназ"
	cost = 1250
	items = list(
		/obj/item/clothing/head/helmet/maska/altyn,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/suit/armor/opvest/sobr,
		/obj/item/clothing/gloves/combat/sobr,
		/obj/item/clothing/shoes/combat
	)

/datum/violence_gear/armor/deathsquad
	name = "Дедушка"
	cost = 2500
	items = list(
		/obj/item/clothing/suit/space/hardsuit/deathsquad,
		/obj/item/clothing/gloves/tackler/combat/insulated,
		/obj/item/clothing/mask/gas/sechailer/swat,
		/obj/item/clothing/shoes/combat/swat
	)

/datum/violence_gear/shield
	cat = "Щиты"

/datum/violence_gear/shield/buckler
	name = "Деревянный щит"
	cost = 500
	items = list(/obj/item/shield/riot/buckler)

/datum/violence_gear/shield/riot
	name = "Крепкий щит"
	cost = 750
	items = list(/obj/item/shield/riot)

/datum/violence_gear/shield/kevlar
	name = "Кевларовый щит"
	cost = 1000
	items = list(/obj/item/shield/riot/kevlar)

/datum/violence_gear/misc
	cat = "Различное"

/datum/violence_gear/misc/medkit
	name = "Аптечка"
	cost = 250
	items = list(/obj/item/storage/firstaid/regular)

/datum/violence_gear/misc/sunglasses
	name = "Солнцезащитные"
	cost = 350
	items = list(/obj/item/clothing/glasses/sunglasses)

/datum/violence_gear/misc/wirecutters
	name = "Кусачки"
	cost = 450
	items = list(/obj/item/wirecutters)

/datum/violence_gear/misc/teargas
	name = "Перцовый газ"
	cost = 600
	items = list(/obj/item/grenade/chem_grenade/teargas)

/datum/violence_gear/misc/frag
	name = "Осколочная"
	cost = 900
	items = list(/obj/item/grenade/frag)

/datum/violence_gear/misc/thermal
	name = "Термалы"
	cost = 2500
	items = list(/obj/item/clothing/glasses/hud/toggle/thermal)
