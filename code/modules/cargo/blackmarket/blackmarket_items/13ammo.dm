/datum/blackmarket_item/ammo
	markets = list(/datum/blackmarket_market/blackmarket)
	category = "Патроны"

/datum/blackmarket_item/ammo/fallout/m12mm
	name = "Пистолетный магазин (12.7mm)"
	desc = "Не путайте с магазином для СМГ."
	item = /obj/item/ammo_box/magazine/fallout/m12mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/fallout/cpistol
	name = "Патрон для китайского пистолета"
	desc = "БЛЯТЬ!"
	item = /obj/item/ammo_box/magazine/internal/cpistol

	price_min = 10
	price_max = 50
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m10mm
	name = "Пистолетный магазин для Tanner M41 (10mm)"
	desc = "Не путайте с другими видами пистолетов. Не используется в макарове и стечкине. При покупке могут появится магазины различного типа. Внимание! Не путать с винтовочным магазином!"
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
			/obj/item/ammo_box/magazine/m10mm/ap))
	return new pistolammo(loc)

/datum/blackmarket_item/ammo/fallout/m10mm
	name = "Пистолетный магазин для police 10mm pistol (10mm)"
	desc = "Не путайте с другими видами пистолетов."
	item = /obj/item/ammo_box/magazine/fallout/m10mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/mauser
	name = "Магазин для Маузера (10mm)"
	desc = "Магазин для Маузера"
	item = /obj/item/ammo_box/magazine/wzzzz/mauser

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100


/datum/blackmarket_item/ammo/m9mm
	name = "Пистолетный магазин (9mm)"
	desc = "ВНИМАНИЕ! Этот магазин может не походить к некоторым видам пистолетов. Будьте внимательны. Подходит для Стечкина и Макарова"
	item = /obj/item/ammo_box/magazine/m9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/fallout/m9mm
	name = "Пистолетный магазин на 13 патронов (9mm)"
	desc = "ВНИМАНИЕ! Этот магазин может не походить к некоторым видам пистолетов. Будьте внимательны. Подходит для 9mm pistol, handmade pistol и Maria"
	item = /obj/item/ammo_box/magazine/fallout/m9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/mc9mmt
	name = "top mounted magazine (9mm)"
	desc = "не ебу как перевести поэтому вот вам так. Сами поймёте. далеко не дети..."
	item = /obj/item/ammo_box/magazine/wt550m9/wzzzz/mc9mmt

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/luger
	name = "Магазин для Люгера (9mm)"
	desc = "Магазин для Люгера"
	item = /obj/item/ammo_box/magazine/wzzzz/luger

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/fallout/deagle
	name = "Пистолетный магазин (.44)"
	desc = "Магазин калибра .44"
	item = /obj/item/ammo_box/magazine/fallout/deagle

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/m50
	name = "Пистолетный магазин (.50)"
	desc = "Магазин калибра .50"
	item = /obj/item/ammo_box/magazine/m9mm

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

/datum/blackmarket_item/ammo/fallout/smgm9mm
	name = "Магазин на 30 патронов для СМГ (9мм)"
	desc = "Магазин для 9mm submachine gun и handmade submachine gun"
	item = /obj/item/ammo_box/magazine/fallout/smgm9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/tommygunm45
	name = "Барабанный магазин для СМГ (.22)"
	desc = "Подходит для .22 submachine gun"
	item = /obj/item/ammo_box/magazine/tommygunm45

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/tommygunm45
	name = "Магазин для винтовок (.45)"
	desc = "Подходит для пистолет-пулемёт Томпсона"
	item = /obj/item/ammo_box/magazine/tommygunm45

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/fallout/smgm45
	name = "Барабанный магазин для СМГ (.45)"
	desc = "Магазин для СМГ калибра .45"
	item = /obj/item/ammo_box/magazine/fallout/smgm45

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/smgm45
	name = "Магазин для C-20r (.45)"
	desc = "Магазин для C-20r калибра .45"
	item = /obj/item/ammo_box/magazine/smgm45

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/tommygunm45
	name = "Барабанный магазин для Томмигана (.45)"
	desc = "Магазин ТОЛЬКО для Томмигана калибра .45"
	item = /obj/item/ammo_box/magazine/tommygunm45

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/uzim9mm
	name = "Магазин для УЗИ (9мм)"
	desc = "Магазин для УЗИ калибра 9мм"
	item = /obj/item/ammo_box/magazine/uzim9mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/mp40
	name = "Магазин для МП-40 (9мм)"
	desc = "Магазин для МП-40 калибра 9мм"
	item = /obj/item/ammo_box/magazine/wzzzz/mp40

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/fallout/smgm10mm
	name = "Магазин для СМГ (10мм)"
	desc = "Магазин для СМГ калибра 10мм"
	item = /obj/item/ammo_box/magazine/fallout/smgm10mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/fallout/smgm10mm
	name = "Магазин для СМГ (12.7мм)"
	desc = "Магазин для СМГ калибра 12.7мм"
	item = /obj/item/ammo_box/magazine/fallout/smg12mm

	price_min = 100
	price_max = 500
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/stg
	name = "Магазин для СТГ"
	desc = "Магазин для СТГ"
	item = /obj/item/ammo_box/magazine/wzzzz/stg

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

/datum/blackmarket_item/ammo/wzzzz/assault_rifle
	name = "Магазин для штурмовой винтовки"
	desc = "Магазин для штурмовой винтовки калибра asr"
	item = /obj/item/ammo_box/magazine/wzzzz/assault_rifle

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/g43
	name = "Магазин для g43 (5.56mm)"
	desc = "Магазин для g43"
	item = /obj/item/ammo_box/magazine/wzzzz/g43

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/fg42
	name = "Магазин для fg42 (5.56mm)"
	desc = "Магазин для fg42"
	item = /obj/item/ammo_box/magazine/wzzzz/fg42

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/carbine
	name = "Магазин для боевого карабина (5.56mm)"
	desc = "Магазин для боевого карабина"
	item = /obj/item/ammo_box/magazine/wzzzz/carbine

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/fallout/r20
	name = "Магазин на 20 патронов для штурмовых винтовок (5.56mm)"
	desc = "Магазин для Assault rifle, marksman carbine, All-American, service rifle, Survivalist rifle и Infiltrator"
	item = /obj/item/ammo_box/magazine/fallout/r20

	price_min = 200
	price_max = 600
	stock_min = 1
	stock_max = 50
	availability_prob = 100

/datum/blackmarket_item/ammo/wzzzz/a556carbine
	name = "Магазин для Z8 Bulldog(6.8mm)"
	desc = "Магазин для Z8 Bulldog"
	item = /obj/item/ammo_box/magazine/wzzzz/a556carbine

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

/datum/blackmarket_item/ammo/fallout/ar762
	name = "Магазин для штурмовых винтовок (7.62mm)"
	desc = "Подходит для chinese assault rifle и handmade assault rifle"
	item = /obj/item/ammo_box/magazine/fallout/ar762

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
	name = "Магазин для kar98k(7.92x57mm)"
	desc = "Магазин для kar98k"
	item = /obj/item/ammo_box/magazine/wzzzz/a792x57

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

/datum/blackmarket_item/ammo/fallout/r308
	name = "Магазин для снайперских винтовок (.308)"
	desc = "Подходит снайперских винтовок калибра .308"
	item = /obj/item/ammo_box/magazine/fallout/r308

	price_min = 1000
	price_max = 10000
	stock_min = 1
	stock_max = 10
	availability_prob = 100
