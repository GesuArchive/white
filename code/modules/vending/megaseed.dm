/obj/machinery/vending/hydroseeds
	name = "Счастливая ферма"
	desc = "Когда нужны семена быстро!"
	product_slogans = "ТУТ СЕМЕНА ЖИВУТ! ПОЛУЧИТЕ СВОИ!;Самый лучший выбор семян на станции!;Также доступны определенные сорта грибов, больше для знатоков! Получите сертификат сегодня!"
	product_ads = "Мы любим растения!;Выращивай урожай!;Расти, детка, расти!;Ой, да, сын!"
	icon_state = "seeds"
	light_mask = "seeds-light-mask"
	products = list(
		/obj/item/seeds/aloe = 5,
		/obj/item/seeds/ambrosia = 5,
		/obj/item/seeds/apple = 5,
		/obj/item/seeds/banana = 5,
		/obj/item/seeds/chili/bell_pepper = 5,
		/obj/item/seeds/berry = 5,
		/obj/item/seeds/cabbage = 5,
		/obj/item/seeds/carrot = 5,
		/obj/item/seeds/cherry = 5,
		/obj/item/seeds/chanter = 5,
		/obj/item/seeds/chili = 5,
		/obj/item/seeds/cocoapod = 5,
		/obj/item/seeds/coffee = 5,
		/obj/item/seeds/cotton = 5,
		/obj/item/seeds/corn = 5,
		/obj/item/seeds/eggplant = 5,
		/obj/item/seeds/garlic = 5,
		/obj/item/seeds/grape = 5,
		/obj/item/seeds/grass = 5,
		/obj/item/seeds/lemon = 5,
		/obj/item/seeds/lime = 5,
		/obj/item/seeds/herbs = 5,
		/obj/item/seeds/onion = 5,
		/obj/item/seeds/orange = 5,
		/obj/item/seeds/peas = 5,
		/obj/item/seeds/pineapple = 5,
		/obj/item/seeds/potato = 5,
		/obj/item/seeds/poppy = 5,
		/obj/item/seeds/pumpkin = 5,
		/obj/item/seeds/wheat/rice = 5,
		/obj/item/seeds/rose = 5,
		/obj/item/seeds/soya = 5,
		/obj/item/seeds/sugarcane = 5,
		/obj/item/seeds/sunflower = 5,
		/obj/item/seeds/tea = 5,
		/obj/item/seeds/tobacco = 5,
		/obj/item/seeds/tomato = 5,
		/obj/item/seeds/tower = 5,
		/obj/item/seeds/toechtauese = 5,
		/obj/item/seeds/watermelon = 5,
		/obj/item/seeds/wheat = 5,
		/obj/item/seeds/whitebeet = 5)
	contraband = list(
		/obj/item/seeds/amanita = 5,
		/obj/item/seeds/glowshroom = 5,
		/obj/item/seeds/liberty = 5,
		/obj/item/seeds/nettle = 5,
		/obj/item/seeds/plump = 5,
		/obj/item/seeds/reishi = 5,
		/obj/item/seeds/cannabis = 5,
		/obj/item/seeds/starthistle = 5,
		/obj/item/seeds/random = 15)
	premium = list(/obj/item/reagent_containers/spray/waterflower = 1)
	refill_canister = /obj/item/vending_refill/hydroseeds
	default_price = PAYCHECK_PRISONER
	extra_price = PAYCHECK_ASSISTANT
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/hydroseeds
	machine_name = "Счастливая ферма"
	icon_state = "refill_plant"
