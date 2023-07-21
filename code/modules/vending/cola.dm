
/obj/machinery/vending/cola
	name = "Прилив Робаста"
	desc = "Поставщик безалкогольных напитков, предоставленный Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_slogans = "Прилив Робаста: Гасит надежнее, чем ящиком для инструментов по голове!"
	product_ads = "Освежающий!;Надеюсь ты хочешь пить!;Продано более 1 миллиона напитков!;Жажда? Может быть кола?;Пожалуйста, выпей!;Пей!;Лучшие напитки в космосе."
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/sol_dry = 10,
					/obj/item/reagent_containers/food/drinks/waterbottle = 10)
	contraband = list(/obj/item/reagent_containers/food/drinks/soda_cans/thirteenloko = 6,
		              /obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 6)
	premium = list(/obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola = 1,
		           /obj/item/reagent_containers/food/drinks/soda_cans/air = 1,
		           /obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy = 1,
		           /obj/item/reagent_containers/food/drinks/soda_cans/grey_bull = 1)
	refill_canister = /obj/item/vending_refill/cola
	default_price = PAYCHECK_ASSISTANT * 0.7
	extra_price = PAYCHECK_MEDIUM
	payment_department = ACCOUNT_SRV


/obj/item/vending_refill/cola
	machine_name = "Прилив Робаста"
	icon_state = "refill_cola"

/obj/machinery/vending/cola/blue
	icon_state = "Cola_Machine"
	light_mask = "cola-light-mask"
	light_color = COLOR_MODERATE_BLUE

/obj/machinery/vending/cola/black
	icon_state = "cola_black"
	light_mask = "cola-light-mask"

/obj/machinery/vending/cola/red
	icon_state = "red_cola"
	name = "Автомат \"Космо-Колы\""
	desc = "Кола в космосе!"
	product_slogans = "Классический вкус в космосе!"
	light_mask = "red_cola-light-mask"
	light_color = COLOR_DARK_RED

/obj/machinery/vending/cola/space_up
	icon_state = "space_up"
	name = "Автомат \"На Взлёт!\""
	desc = "Побалуйте себя взрывом аромата."
	product_slogans = "На Взлёт! Как пробоина корпуса во рту."
	light_mask = "space_up-light-mask"
	light_color = COLOR_DARK_MODERATE_LIME_GREEN

/obj/machinery/vending/cola/starkist
	icon_state = "starkist"
	name = "Автомат \"Звездный ларь\""
	desc = "Вкус звезды в жидком виде."
	product_slogans = "Пейте звезды! Звездный ларь!"
	light_mask = "starkist-light-mask"
	light_color = COLOR_LIGHT_ORANGE

/obj/machinery/vending/cola/sodie
	icon_state = "soda"
	light_mask = "soda-light-mask"
	light_color = COLOR_WHITE

/obj/machinery/vending/cola/pwr_game
	icon_state = "pwr_game"
	name = "Автомат \"Pwr Game\""
	desc = "Вы хотели - вы получили.."
	product_slogans = "СИЛА, которой жаждут геймеры! PWR GAME!"
	light_mask = "pwr_game-light-mask"
	light_color = COLOR_STRONG_VIOLET

/obj/machinery/vending/cola/shamblers
	name = "Автомат шипучки"
	desc = "~Просто взболтни!~"
	icon_state = "shamblers_juice"
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/sol_dry = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 10)
	product_slogans = "~Просто взблотни!~"
	product_ads = "Освежающий!;Выпило более 1 триллиона душ!;Жажда? Пей!."
	light_mask = "shamblers-light-mask"
	light_color = COLOR_MOSTLY_PURE_PINK
