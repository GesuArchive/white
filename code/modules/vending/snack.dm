/obj/machinery/vending/snack
	name = "Три корочки"
	desc = "Автомат для снэков предоставлен корпорацией Три корочки, базирующейся на Марсе."
	product_slogans = "Попробуйте наш новый батончик из нуги!;В два раза больше калорий за полцены!"
	product_ads = "Самый здоровый!;Отмеченные наградами плитки шоколада!;Ммм! Так вкусно!;Боже мой, он такой сочный!;Перекусите;Закуски хороши для вас!;Ешьте еще Getmore!;Снеки самого высокого качества прямо с Марса.;Мы любим шоколад!;Попробуйте наше новое вяленое мясо!"
	icon_state = "snack"
	light_mask = "snack-light-mask"
	products = list(
		/obj/item/food/spacetwinkie = 15,
		/obj/item/food/cheesiehonkers = 15,
		/obj/item/food/candy = 15,
		/obj/item/food/chips = 15,
		/obj/item/food/sosjerky = 15,
		/obj/item/food/no_raisin = 15,
		/obj/item/food/peanuts = 15,
		/obj/item/food/peanuts/random = 15,
		/obj/item/food/donkpocket = 15,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 3,
		/obj/item/storage/box/gum = 3,
		/obj/item/food/energybar = 6)
	contraband = list(
		/obj/item/food/syndicake = 6,
		/obj/item/food/candy/bronx = 1,
		/obj/item/food/spacers_sidekick = 3)
	refill_canister = /obj/item/vending_refill/snack
	canload_access_list = list(ACCESS_KITCHEN)
	default_price = PAYCHECK_ASSISTANT * 0.2
	extra_price = PAYCHECK_EASY
	payment_department = ACCOUNT_SRV
	input_display_header = "Chef's Food Selection"

/obj/item/vending_refill/snack
	machine_name = "Три корочки"

/obj/machinery/vending/snack/blue
	icon_state = "snackblue"

/obj/machinery/vending/snack/orange
	icon_state = "snackorange"

/obj/machinery/vending/snack/green
	icon_state = "snackgreen"

/obj/machinery/vending/snack/teal
	icon_state = "snackteal"
