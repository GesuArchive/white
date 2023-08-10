/datum/blackmarket_item/weapon
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Оружие"

/datum/blackmarket_item/weapon/pgun
	name = "Случайное баллистическое оружие"
	desc = "Пукает хорошо а стоимость ещё дороже"
	item = /obj/item/gun/ballistic/

	price_min = BLACKMARKET_CRATE_VALUE * 1250
	price_max = BLACKMARKET_CRATE_VALUE * 5000
	stock_min = 1
	stock_max = 10
	availability_prob = 100

/datum/blackmarket_item/weapon/pgun/spawn_item(loc)
	var/pgun = pick(list(/obj/item/gun/ballistic/automatic/ar,
			/obj/item/gun/ballistic/automatic/surplus,
			/obj/item/gun/ballistic/shotgun/riot,
			/obj/item/gun/ballistic/automatic/pistol/makarov,
			/obj/item/gun/ballistic/rifle/boltaction,
			/obj/item/gun/ballistic/shotgun/doublebarrel,
			/obj/item/gun/ballistic/shotgun/sc_pump,
			/obj/item/gun/ballistic/revolver/mateba,
			/obj/item/gun/ballistic/automatic/pistol/traumatic,
			/obj/item/gun/ballistic/automatic/M41A,
			/obj/item/gun/ballistic/automatic/pistol/deagle,
			/obj/item/gun/ballistic/automatic/pistol/deagle/gold,
			/obj/item/gun/ballistic/automatic/ar,
			/obj/item/gun/ballistic/automatic/wt550,
			/obj/item/gun/ballistic/automatic/pistol/m1911,
			/obj/item/gun/ballistic/automatic/fallout/smg45,
			/obj/item/gun/ballistic/automatic/fallout/smg22,
			/obj/item/gun/ballistic/automatic/fallout/smg9mm,
			/obj/item/gun/ballistic/automatic/fallout/smg9mm/handmade,
			/obj/item/gun/ballistic/automatic/fallout/smg10mm,
			/obj/item/gun/ballistic/automatic/fallout/smg12mm,
			/obj/item/gun/ballistic/automatic/fallout/marksman/service/survival,
			/obj/item/gun/ballistic/automatic/fallout/marksman/service/police22,
			/obj/item/gun/ballistic/automatic/fallout/marksman/service,
			/obj/item/gun/ballistic/automatic/fallout/assaultrifle/chinese,
			/obj/item/gun/ballistic/automatic/fallout/assaultrifle,
			/obj/item/gun/ballistic/automatic/pistol/fallout/deagle,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m10mm,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m10mm/chinese,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m10mm/chinese/v420,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m10mm/military,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m12mm,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m12mm/devil,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m9mm,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m9mm/handmade,
			/obj/item/gun/ballistic/automatic/pistol/fallout/m9mm/maria,
			/obj/item/gun/ballistic/shotgun/fallout/huntingshot,
			/obj/item/gun/ballistic/shotgun/fallout/lever))
	return new pgun(loc)


/datum/blackmarket_item/weapon/egun
	name = "Случайное энергетическое оружие"
	desc = "Пукает хорошо а стоимость ещё дороже"
	item = /obj/item/gun/energy/

	price_min = BLACKMARKET_CRATE_VALUE * 1000
	price_max = BLACKMARKET_CRATE_VALUE * 4000
	stock_min = 1
	stock_max = 10
	availability_prob = 100

/datum/blackmarket_item/weapon/egun/spawn_item(loc)
	var/egun = pick(list(/obj/item/gun/energy/e_gun,
			/obj/item/gun/energy/e_gun/mini,
			/obj/item/gun/energy/e_gun/stun,
			/obj/item/gun/energy/e_gun/old,
			/obj/item/gun/energy/e_gun/nuclear,
			/obj/item/gun/energy/laser,
			/obj/item/gun/energy/laser/retro,
			/obj/item/gun/energy/laser/retro/old,
			/obj/item/gun/energy/laser/scatter,
			/obj/item/gun/energy/laser/scatter/shotty,
			/obj/item/gun/energy/xray,
			/obj/item/gun/energy/tesla_revolver,
			/obj/item/gun/energy/kinetic_accelerator/crossbow,
			/obj/item/gun/energy/kinetic_accelerator/crossbow/large))
	return new egun(loc)

/datum/blackmarket_item/weapon/tgun
	name = "Случайное Тазер/Дизаблер"
	desc = "Тазер или Дизаблер? Сложный выбор..."
	item = /obj/item/gun/energy/taser

	price_min = BLACKMARKET_CRATE_VALUE * 1000
	price_max = BLACKMARKET_CRATE_VALUE * 3000
	stock_min = 1
	stock_max = 10
	availability_prob = 100

/datum/blackmarket_item/weapon/tgun/spawn_item(loc)
	var/tgun = pick(list(/obj/item/gun/energy/taser,
			/obj/item/gun/energy/e_gun/advtaser,
			/obj/item/gun/energy/disabler))
	return new tgun(loc)

/datum/blackmarket_item/weapon/sgun
	name = "Случайная снайперка"
	desc = "Для истинных долбаёбов"
	item = /obj/item/gun/ballistic/automatic/fallout/marksman

	price_min = BLACKMARKET_CRATE_VALUE * 4000
	price_max = BLACKMARKET_CRATE_VALUE * 8000
	stock_min = 1
	stock_max = 10
	availability_prob = 100

/datum/blackmarket_item/weapon/sgun/spawn_item(loc)
	var/sgun = pick(list(/obj/item/gun/ballistic/automatic/fallout/marksman/sniper,
			/obj/item/gun/ballistic/automatic/fallout/marksman/american,
			/obj/item/gun/ballistic/automatic/fallout/marksman,
			/obj/item/gun/ballistic/automatic/fallout/assaultrifle/infiltrator
			))
	return new sgun(loc)


