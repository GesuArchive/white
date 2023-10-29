/obj/machinery/vending/sustenance
	name = "Баланда по домашнему"
	desc = "Торговый автомат по продаже еды в соответствии с требованиями раздела 47-C Соглашения NT об этическом обращении с заключенными."
	product_slogans = "Приятного аппетита.;Достаточно калорий, чтобы поддерживать напряженный труд."
	product_ads = "Достаточно здоровый.;Эффективно произведенный тофу!;Ммм! Так вкусно!;Ешьте.;Чтобы жить, нужна еда!;Даже заключенные заслуживают хлеба насущного!;Ешьте еще кукурузных конфет!;Попробуйте наши новые ледяные чашки!"
	light_mask = "snack-light-mask"
	icon_state = "sustenance"
	products = list(
		/obj/item/food/tofu/prison = 24,
		/obj/item/food/breadslice/moldy = 15,
		/obj/item/reagent_containers/food/drinks/ice/prison = 12,
		/obj/item/food/candy_corn/prison = 6,
		/obj/item/kitchen/spoon/plastic = 6,
	)
	contraband = list(
		/obj/item/kitchen/knife = 6,
		/obj/item/kitchen/spoon = 6,
		/obj/item/reagent_containers/food/drinks/coffee = 12,
		/obj/item/tank/internals/emergency_oxygen = 6,
		/obj/item/clothing/mask/breath = 6,
	)

	refill_canister = /obj/item/vending_refill/sustenance
	default_price = PAYCHECK_PRISONER
	extra_price = PAYCHECK_PRISONER * 0.6
	payment_department = NO_FREEBIES

/obj/item/vending_refill/sustenance
	machine_name = "Баланда по домашнему"
	icon_state = "refill_snack"
