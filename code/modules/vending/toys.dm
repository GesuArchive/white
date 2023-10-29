/obj/machinery/vending/donksofttoyvendor
	name = "Детский Мир"
	desc = "Утвержденный поставщик игрушек для детей в возрасте от 30 лет и старше."
	icon_state = "nt-donk"
	product_slogans = "Получите свои крутые игрушки сегодня!;Запустите валид-хант сегодня!;Качественное игрушечное оружие по низким ценам!;Раздайте всем полный доступ!;Посадите начальника охраны в тюрьму!"
	product_ads = "Почувствуйте себя крепкими со своими игрушками!;Выразите своего внутреннего ребенка сегодня!;Игрушечное оружие не убивает людей, а валид-хантеры убивают!;Кому нужны обязанности, когда у вас есть игрушечное оружие?;Сделайте следующее убийство ВЕСЁЛЫМ!"
	vend_reply = "Вернись для большего!"
	light_mask = "donksoft-light-mask"
	circuit = /obj/item/circuitboard/machine/vending/donksofttoyvendor
	products = list(
		/obj/item/gun/ballistic/automatic/toy/unrestricted = 10,
		/obj/item/gun/ballistic/automatic/pistol/toy = 10,
		/obj/item/gun/ballistic/shotgun/toy/unrestricted = 10,
		/obj/item/toy/sword = 10,
		/obj/item/ammo_box/foambox = 20,
		/obj/item/toy/foamblade = 10,
		/obj/item/toy/balloon/syndicate = 10,
		/obj/item/clothing/suit/syndicatefake = 5,
		/obj/item/clothing/head/syndicatefake = 5)
	contraband = list(
		/obj/item/gun/ballistic/shotgun/toy/crossbow = 10,
		/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted = 10,
		/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted = 10,
		/obj/item/toy/katana = 10,
		/obj/item/dualsaber/toy = 5)
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/donksoft
	default_price = PAYCHECK_ASSISTANT
	extra_price = PAYCHECK_HARD
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/donksoft
	machine_name = "Donksoft Toy Vendor"
	icon_state = "refill_donksoft"
