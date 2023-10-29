/obj/machinery/vending/coffee
	name = "Кофейник"
	desc = "Торговый автомат по продаже горячих напитков."
	product_ads = "Выпей!;Пей!;Это поможет тебе!;Хочешь горячего Джо?;Я убью за кофе!;Лучшие бобы в галактике.;Только лучший напиток для тебя.;Мммм. Нет ничего лучше кофе.;Я люблю кофе, не так ли?;Кофе помогает тебе работать!;Попробуй чаю.;Надеемся, тебе понравится самый лучший!;Попробуйте наш новый шоколад!;Заговоры педалей!"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	products = list(
		/obj/item/reagent_containers/food/drinks/coffee = 12,
		/obj/item/reagent_containers/food/drinks/mug/tea = 12,
		/obj/item/reagent_containers/food/drinks/mug/coco = 6
		)
	contraband = list(/obj/item/reagent_containers/food/drinks/ice = 12)
	refill_canister = /obj/item/vending_refill/coffee
	default_price = PAYCHECK_PRISONER
	extra_price = PAYCHECK_ASSISTANT
	payment_department = ACCOUNT_SRV
	light_mask = "coffee-light-mask"
	light_color = COLOR_DARK_MODERATE_ORANGE

/obj/item/vending_refill/coffee
	machine_name = "Кофейник"
	icon_state = "refill_joe"
