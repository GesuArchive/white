/obj/machinery/vending/magivend
	name = "Лавка Мэрлина"
	desc = "Волшебный торговый автомат."
	icon_state = "MagiVend"
	product_slogans = "Говори заклинания должным образом!;Будь своим собственным Гудини! Используй Лавку Мэрлина!"
	vend_reply = "Волшебного вечера!"
	product_ads = "АОЛДАОЫВ;ФОЛАДИОФЛД;1234 ЛУНАТИКИ ЛОЛ!;>мое лицо, когда;Убей этих лохов!;GET DAT FUKKEN DISK;ХОНК!;ЭЙ НАХ;Уничтожь станцию!;Админские заговоры навсегда!;Оборудование для закручивания пространства-времени!"
	products = list(/obj/item/clothing/head/wizard = 1,
		            /obj/item/clothing/suit/wizrobe = 1,
		            /obj/item/clothing/head/wizard/red = 1,
		            /obj/item/clothing/suit/wizrobe/red = 1,
		            /obj/item/clothing/head/wizard/yellow = 1,
		            /obj/item/clothing/suit/wizrobe/yellow = 1,
		            /obj/item/clothing/shoes/sandal/magic = 1,
		            /obj/item/staff = 2)
	contraband = list(/obj/item/reagent_containers/glass/bottle/wizarditis = 1)	//No one can get to the machine to hack it anyways; for the lulz - Microwave
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	default_price = 0 //Just in case, since it's primary use is storage.
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV
	light_mask = "magivend-light-mask"
