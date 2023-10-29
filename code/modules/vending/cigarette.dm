/obj/machinery/vending/cigarette
	name = "Смог"
	desc = "Если вы хотите заболеть раком, сделайте это стильно."
	product_slogans = "Космические сигареты имеют приятный вкус, как и должна быть настоящая сигарета.;Я бы предпочел удар от ящика с инструментами по голове, чем бросать курить!;Кури!;"
	product_ads = "Точно не навредит вам!;Не верьте ученым!;Это не навредит вам!;Не бросайте, покупайте больше!;Кури!;Никотиновый рай только здесь.;Лучшие сигареты с 2150 года;Отмеченные наградами сигареты."
	icon_state = "cigs"
	products = list(
		/obj/item/storage/fancy/cigarettes = 5,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 4,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 3,
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 4,
		/obj/item/storage/fancy/rollingpapers = 5,
		/obj/item/storage/ashtray = 2)
	contraband = list(/obj/item/clothing/mask/vape = 5)
	premium = list(
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 3,
		/obj/item/storage/box/gum/nicotine = 2,
		/obj/item/lighter = 3,
		/obj/item/storage/fancy/cigarettes/cigars = 1,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 1,
		/obj/item/storage/fancy/cigarettes/cigars/cohiba = 1)
	refill_canister = /obj/item/vending_refill/cigarette
	default_price = PAYCHECK_ASSISTANT
	extra_price = PAYCHECK_HARD
	payment_department = ACCOUNT_SRV
	light_mask = "cigs-light-mask"

/obj/machinery/vending/cigarette/syndicate
	products = list(
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate = 7,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 2,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 2,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 1,
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 4,
		/obj/item/storage/fancy/rollingpapers = 5,
		/obj/item/storage/ashtray = 2)

/obj/machinery/vending/cigarette/beach //Used in the lavaland_biodome_beach.dmm ruin
	name = "Смог ультра"
	desc = "Теперь с дополнительными продуктами премиум-класса!"
	product_ads = "Космические сигареты имеют приятный вкус, как и должна быть настоящая сигарета.;Я бы предпочел удар от ящика с инструментами по голове, чем бросать курить!;Кури!;"
	product_slogans = "Включись, настройся, выпадай!;Лучше жить через химию!;Пыхнем?;Не забудь сохранить улыбку на губах и песенку в душе!"
	products = list(
		/obj/item/storage/fancy/cigarettes = 5,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_cannabis = 5,
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 4,
		/obj/item/storage/fancy/rollingpapers = 5,
		/obj/item/storage/ashtray = 2)
	premium = list(
		/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker = 5,
		/obj/item/clothing/mask/vape = 5,
		/obj/item/lighter = 3)

/obj/item/vending_refill/cigarette
	machine_name = "Смог"
	icon_state = "refill_smoke"

/obj/machinery/vending/cigarette/pre_throw(obj/item/I)
	if(istype(I, /obj/item/lighter))
		var/obj/item/lighter/L = I
		L.set_lit(TRUE)
