/obj/machinery/vending/sovietsoda
	name = "ВОДА"
	desc = "Старый торговый автомат пресной воды."
	icon_state = "sovietsoda"
	light_mask = "soviet-light-mask"
	product_ads = "За Царя и Страны.;Вы выполнили сегодня норму питания?;Очень красиво!;Мы простые люди, потому что это все, что мы едим.;Если есть человек, есть проблема. Если нет человека, значит, нет проблем."
	products = list(/obj/item/reagent_containers/food/drinks/drinkingglass/filled/soda = 30)
	contraband = list(/obj/item/reagent_containers/food/drinks/drinkingglass/filled/cola = 20)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/sovietsoda
	default_price = CARGO_CRATE_VALUE * 1
	extra_price = PAYCHECK_ASSISTANT //One credit for every state of FREEDOM
	payment_department = NO_FREEBIES
	light_color = COLOR_PALE_ORANGE

/obj/item/vending_refill/sovietsoda
	machine_name = "ВОДА"
	icon_state = "refill_cola"
