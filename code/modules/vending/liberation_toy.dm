/obj/machinery/vending/toyliberationstation
	name = "Юный террорист"
	desc = "Утвержденный поставщик игрушек в возрасте от 8 лет и старше. Если вы нашли нужные провода, вы можете разблокировать настройку режима для взрослых!"
	icon_state = "syndi"
	product_slogans = "Получите свои крутые игрушки сегодня!;Вызовите валид-хантера сегодня!;Качественное игрушечное оружие по низким ценам!;Раздайте всем полный доступ!;Посадите начальника охраны в тюрьму!"
	product_ads = "Почувствуйте себя сильным со своими игрушками!;Выразите своего внутреннего ребенка сегодня!;Игрушечное оружие не убивает людей, а вот валид-хантеры убивают!;Кому нужны обязанности, когда есть игрушечное оружие?;Сделайте ваше следующее убийство ВЕСЁЛЫМ!"
	vend_reply = "Вернись для большего!"
	circuit = /obj/item/circuitboard/machine/vending/syndicatedonksofttoyvendor
	products = list(/obj/item/gun/ballistic/automatic/toy/unrestricted = 10,
					/obj/item/gun/ballistic/automatic/pistol/toy = 10,
					/obj/item/gun/ballistic/shotgun/toy/unrestricted = 10,
					/obj/item/toy/sword = 10,
					/obj/item/ammo_box/foambox = 20,
					/obj/item/toy/foamblade = 10,
					/obj/item/toy/balloon/syndicate = 10,
					/obj/item/clothing/suit/syndicatefake = 5,
					/obj/item/clothing/head/syndicatefake = 5) //OPS IN DORMS oh wait it's just an assistant
	contraband = list(/obj/item/gun/ballistic/shotgun/toy/crossbow = 10,   //Congrats, you unlocked the +18 setting!
					  /obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot = 10,
					  /obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot = 10,
					  /obj/item/ammo_box/foambox/riot = 20,
					  /obj/item/toy/katana = 10,
					  /obj/item/dualsaber/toy = 5,
					  /obj/item/toy/cards/deck/syndicate = 10) //Gambling and it hurts, making it a +18 item
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/donksoft
	default_price = PAYCHECK_HARD
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV
	light_mask = "donksoft-light-mask"
