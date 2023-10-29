/obj/machinery/vending/assist
	name = "Амперка"
	desc = "Вся самая лучшая электроника, которая только может понадобиться! Не несет ответственности за любые травмы, вызванные неосторожным использованием деталей."
	icon_state = "parts"
	icon_deny = "parts-deny"
	products = list(
		/obj/item/assembly/prox_sensor = 5,
		/obj/item/assembly/igniter = 5,
		/obj/item/assembly/signaler = 10,
		/obj/item/wirecutters = 5,
		/obj/item/crowbar = 5,
		/obj/item/screwdriver = 5,
		/obj/item/weldingtool = 5,
		/obj/item/wrench = 5,
		/obj/item/multitool =5,
		/obj/item/computer_disk/ordnance = 4,
		/obj/item/stock_parts/matter_bin/adv = 30,
		/obj/item/stock_parts/manipulator/nano = 30,
		/obj/item/stock_parts/micro_laser/high = 30,
		/obj/item/stock_parts/scanning_module/adv = 30,
		/obj/item/stock_parts/capacitor/adv = 30,
		/obj/item/assembly/timer = 20,
		/obj/item/assembly/voice = 20,
		/obj/item/assembly/health = 20,
		/obj/item/stock_parts/cell/high = 10,
		/obj/item/storage/belt/utility = 2
	)
	contraband = list(
		/obj/item/stock_parts/capacitor/super = 10,
		/obj/item/stock_parts/scanning_module/phasic = 10,
		/obj/item/stock_parts/manipulator/pico = 10,
		/obj/item/stock_parts/micro_laser/ultra = 10,
		/obj/item/stock_parts/matter_bin/super = 10,
	)
	premium = list(
		/obj/item/price_tagger = 3,
		/obj/item/vending_refill/custom = 3,
		/obj/item/circuitboard/machine/vendor = 3,
		/obj/item/assembly/igniter/condenser = 2,
		/obj/item/screwdriver/power/orange = 1,
		/obj/item/multitool/tricorder = 1
	)

	refill_canister = /obj/item/vending_refill/assist
	product_ads = "Только лучшее!;Купи инструменты.;Самое надежное оборудование.;Лучшие штуки во всём космосе!"
	default_price = PAYCHECK_ASSISTANT * 0.1
	extra_price = PAYCHECK_EASY
	payment_department = NO_FREEBIES
	light_mask = "generic-light-mask"

/obj/item/vending_refill/assist
	machine_name = "Амперка"
	icon_state = "refill_engi"
