/datum/blackmarket_item/ammo
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Патроны"

/datum/blackmarket_item/ammo/m10mm
	name = "Пистолетный магазин (10mm)"
	desc = "При покупке могут появится магазины различного типа. Внимание! Не путать с винтовочным магазином!"
	item = /obj/item/ammo_box/magazine/m10mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m10mm/spawn_item(loc)
	var/pistolammo = pick(list(/obj/item/ammo_box/magazine/m10mm,
			/obj/item/ammo_box/magazine/m10mm/fire,
			/obj/item/ammo_box/magazine/m10mm/hp,
			/obj/item/ammo_box/magazine/m10mm/ap,
			/obj/item/ammo_box/magazine/m45))
	return new pistolammo(loc)

/datum/blackmarket_item/ammo/m9mm
	name = "Пистолетный магазин (9mm)"
	desc = "Магазин калибра 9мм"
	item = /obj/item/ammo_box/magazine/pistolm9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m50
	name = "Пистолетный магазин (.50)"
	desc = "Магазин калибра .50"
	item = /obj/item/ammo_box/magazine/pistolm9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/a357
	name = "Быстрый сьёмный магазин для револьвера (.357)"
	desc = "При покупке могут появится магазины различного типа"
	item = /obj/item/ammo_box/a357

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/a357/spawn_item(loc)
	var/a3579ammo = pick(list(/obj/item/ammo_box/a357,
			/obj/item/ammo_box/a357/match))
	return new a3579ammo(loc)

/datum/blackmarket_item/ammo/c38
	name = "Быстрый сьёмный магазин для револьвера (.38)"
	desc = "При покупке могут появится магазины различного типа"
	item = /obj/item/ammo_box/c38

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/c38/spawn_item(loc)
	var/c38ammo = pick(list(/obj/item/ammo_box/c38,
			/obj/item/ammo_box/c38/trac,
			/obj/item/ammo_box/c38/match,
			/obj/item/ammo_box/c38/match/bouncy,
			/obj/item/ammo_box/c38/dumdum,
			/obj/item/ammo_box/c38/hotshot,
			/obj/item/ammo_box/c38/iceblox))
	return new c38ammo(loc)

/datum/blackmarket_item/ammo/wt550m9
	name = "Магазин для СМГ (4.6x30mm)"
	desc = "При покупке могут появится магазины различного типа"
	item = /obj/item/ammo_box/magazine/wt550m9

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wt550m9/spawn_item(loc)
	var/wt550m9ammo = pick(list(/obj/item/ammo_box/magazine/wt550m9,
			/obj/item/ammo_box/magazine/wt550m9/wtap,
			/obj/item/ammo_box/magazine/wt550m9/wtic))
	return new wt550m9ammo(loc)

/datum/blackmarket_item/ammo/smgm9mm
	name = "Магазин для СМГ (9мм)"
	desc = "При покупке могут появится магазины различного типа"
	item = /obj/item/ammo_box/magazine/smgm9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/smgm9mm/spawn_item(loc)
	var/smgammo9mm = pick(list(/obj/item/ammo_box/magazine/smgm9mm,
			/obj/item/ammo_box/magazine/smgm9mm/ap,
			/obj/item/ammo_box/magazine/smgm9mm/fire))
	return new smgammo9mm(loc)

/datum/blackmarket_item/ammo/smgm9mm
	name = "Магазин для СМГ (.45)"
	desc = "Магазин для СМГ калибра .45"
	item = /obj/item/ammo_box/magazine/smgm45

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/smgm9mm
	name = "Барабанный магазин (.45)"
	desc = "Магазин для Томмигана калибра .45"
	item = /obj/item/ammo_box/magazine/tommygunm45

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/uzim9mm
	name = "Магазин для УЗИ (9мм)"
	desc = "магазин для УЗИ калибра 9мм"
	item = /obj/item/ammo_box/magazine/uzim9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m10mm/rifle
	name = "Винтовочный магазин (10mm)"
	desc = "Магазин для винтовок калибра 10мм. Внимание! Не путать с пистолетным магазином!"
	item = /obj/item/ammo_box/magazine/m10mm/rifle

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m556mmtoploader
	name = "Toploader магазин калибра (5.56mm)"
	desc = "Магазин для винтовок калибром 5.56мм"
	item = /obj/item/ammo_box/magazine/m556

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m556mmrifle
	name = "Винтовочный магазин калибра (5.56mm)"
	desc = "Магазин для винтовок калибром 5.56мм"
	item = /obj/item/ammo_box/magazine/m556/arg/wzzzz

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m12g
	name = "Магазин для дробовика (12g buckshot slugs)"
	desc = "При покупке могут появится магазины различного типа. Внимание! Этот магазин для дробовика Bulldog!"
	item = /obj/item/ammo_box/magazine/m12g

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m12g/spawn_item(loc)
	var/bulldogammo = pick(list(/obj/item/ammo_box/magazine/m12g,
			/obj/item/ammo_box/magazine/m12g/stun,
			/obj/item/ammo_box/magazine/m12g/slug,
			/obj/item/ammo_box/magazine/m12g/dragon,
			/obj/item/ammo_box/magazine/m12g/bioterror,
			/obj/item/ammo_box/magazine/m12g/meteor,
			/obj/item/ammo_box/magazine/m12g/limitka))
	return new bulldogammo(loc)

/datum/blackmarket_item/ammo/mm712x82
	name = "Коробочный магазин (7.12x82mm)"
	desc = "При покупке могут появится магазины различного типа"
	item = /obj/item/ammo_box/magazine/mm712x82

	price_min = 1000
	price_max = 5000
	stock_min = 1
	stock_max = 20
	availability_prob = 100

/datum/blackmarket_item/ammo/mm712x82/spawn_item(loc)
	var/lmgammo = pick(list(/obj/item/ammo_box/magazine/mm712x82,
			/obj/item/ammo_box/magazine/mm712x82/hollow,
			/obj/item/ammo_box/magazine/mm712x82/ap,
			/obj/item/ammo_box/magazine/mm712x82/incen,
			/obj/item/ammo_box/magazine/mm712x82/match))
	return new lmgammo(loc)

/datum/blackmarket_item/ammo/egunrecharge
	name = "Энергетический самозаряжающийся магазин"
	desc = "Магазин с самозарядкой для специальных энергетических винтовок"
	item = /obj/item/ammo_box/magazine/recharge

	price_min = 1000
	price_max = 10000
	stock_min = 1
	stock_max = 10
	availability_prob = 100

/datum/blackmarket_item/ammo/sniper
	name = "Магазин для снайперских винтовок (.50)"
	desc = "При покупке могут появится магазины различного типа"
	item = /obj/item/ammo_box/magazine/sniper_rounds

	price_min = 1000
	price_max = 10000
	stock_min = 1
	stock_max = 10
	availability_prob = 100

/datum/blackmarket_item/ammo/sniper/spawn_item(loc)
	var/sniperammo = pick(list(/obj/item/ammo_box/magazine/sniper_rounds,
			/obj/item/ammo_box/magazine/sniper_rounds/soporific,
			/obj/item/ammo_box/magazine/sniper_rounds/penetrator))
	return new sniperammo(loc)
