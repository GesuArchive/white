/obj/machinery/vending/liberationstation
	name = "Станция Освобождения"
	desc = "Подавляющее количество <b>древнего патриотизма</b> овладевает вами, просто глядя на машину."
	icon_state = "liberationstation"
	product_slogans = "Станция Освобождения: ваш универсальный магазин для всего, что касается второй поправки!;Будь сегодня патриотом, возьми в руки ствол!;Качественное оружие по низким ценам!;Лучше мертвый, чем красный!"
	product_ads = "Плавайте, как космонавт, жальте, как пуля!;Выскажите вторую поправку сегодня!;Пушки не убивают людей, но вы можете!;Кому нужны обязанности, когда у вас есть оружие?"
	vend_reply = "Запомните название: Станция Освобождения!"
	products = list(/obj/item/food/burger/plain = 5, //O say can you see, by the dawn's early light
					/obj/item/food/burger/baseball = 3, //What so proudly we hailed at the twilight's last gleaming
					/obj/item/food/fries = 5, //Whose broad stripes and bright stars through the perilous fight
					/obj/item/reagent_containers/food/drinks/beer/light = 10, //O'er the ramparts we watched, were so gallantly streaming?
					/obj/item/gun/ballistic/automatic/pistol/deagle/gold = 2,
		            /obj/item/gun/ballistic/automatic/pistol/deagle/camo = 2,
					/obj/item/gun/ballistic/automatic/pistol/m1911 = 2,
					/obj/item/gun/ballistic/automatic/proto/unrestricted = 2,
					/obj/item/gun/ballistic/shotgun/automatic/combat = 2,
					/obj/item/gun/ballistic/automatic/gyropistol = 1,
					/obj/item/gun/ballistic/shotgun = 2,
					/obj/item/gun/ballistic/automatic/ar = 2)
	premium = list(/obj/item/ammo_box/magazine/smgm9mm = 2,
		           /obj/item/ammo_box/magazine/m50 = 4,
		           /obj/item/ammo_box/magazine/m45 = 2,
		           /obj/item/ammo_box/magazine/m75 = 2,
				   /obj/item/food/cheesyfries = 5,
				   /obj/item/food/burger/baconburger = 5) //Premium burgers for the premium section
	contraband = list(/obj/item/clothing/under/misc/patriotsuit = 3,
		              /obj/item/bedsheet/patriot = 5,
					  /obj/item/food/burger/superbite = 3) //U S A
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	default_price = PAYCHECK_HARD * 2.5
	extra_price = PAYCHECK_COMMAND * 2.5
	payment_department = ACCOUNT_SEC
	light_mask = "liberation-light-mask"
