/obj/machinery/vending/boozeomat
	name = "Бухло-Мат"
	desc = "Чудо техники, якобы способное смешать именно ту смесь, которую вы хотите выпить, как только вы ее попросите."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/reagent_containers/food/drinks/drinkingglass = 30,
					/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass = 12,
					/obj/item/reagent_containers/food/drinks/flask = 3,
					/obj/item/reagent_containers/food/drinks/ice = 10,
					/obj/item/reagent_containers/food/drinks/bottle/orangejuice = 4,
					/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 4,
					/obj/item/reagent_containers/food/drinks/bottle/limejuice = 4,
					/obj/item/reagent_containers/food/drinks/bottle/cream = 4,
					/obj/item/reagent_containers/food/drinks/soda_cans/cola = 8,
					/obj/item/reagent_containers/food/drinks/soda_cans/tonic = 8,
					/obj/item/reagent_containers/food/drinks/soda_cans/sodawater = 15,
					/obj/item/reagent_containers/food/drinks/soda_cans/sol_dry = 8,
					/obj/item/reagent_containers/food/drinks/bottle/grenadine = 4,
					/obj/item/reagent_containers/food/drinks/bottle/menthol = 4,
					/obj/item/reagent_containers/food/drinks/ale = 6,
					/obj/item/reagent_containers/food/drinks/beer = 6,
					/obj/item/reagent_containers/food/drinks/bottle/maltliquor = 6,
					/obj/item/reagent_containers/food/drinks/bottle/gin = 5,
					/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/reagent_containers/food/drinks/bottle/tequila = 5,
					/obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5,
					/obj/item/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/reagent_containers/food/drinks/bottle/navy_rum = 5,
					/obj/item/reagent_containers/food/drinks/bottle/wine = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5,
					/obj/item/reagent_containers/food/drinks/bottle/curacao = 5,
					/obj/item/reagent_containers/food/drinks/bottle/hcider = 5,
					/obj/item/reagent_containers/food/drinks/bottle/absinthe = 5,
					/obj/item/reagent_containers/food/drinks/bottle/grappa = 5,
					/obj/item/reagent_containers/food/drinks/bottle/amaretto = 5,
					/obj/item/reagent_containers/food/drinks/bottle/sake = 5,
					/obj/item/reagent_containers/food/drinks/bottle/applejack = 5,
					/obj/item/reagent_containers/food/drinks/bottle = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small = 15
					)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/mug/tea = 12,
		/obj/item/reagent_containers/food/drinks/bottle/fernet = 5,
	)
	premium = list(/obj/item/reagent_containers/glass/bottle/ethanol = 4,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 5,
		/obj/item/reagent_containers/food/drinks/bottle/trappist = 5,
		/obj/item/reagent_containers/food/drinks/bottle/bitters = 5,
	)

	product_slogans = "Надеюсь, никто не попросит у меня чашку кровавого чая...;Алкоголь - друг человечества. Вы бы бросили друга?;Очень рад служить вам!;На этой станции никто не хочет пить?"
	product_ads = "Выпейте!;Выпивка вам полезна!;Алкоголь - лучший друг человечества.;Очень рад служить вам!;Хотите холодного пива?;Ничто так не лечит вас, как выпивка!;Выпейте!;Выпейте!;Выпейте пива!;Пиво полезно для вас!;Только лучший алкоголь!;Выпивка лучшего качества с 2053 года!;Отмеченное наградами вино!;Максимум алкоголя!;Мужчина любит пиво.;Тост за прогресс!"
	req_access = list(ACCESS_BAR)
	refill_canister = /obj/item/vending_refill/boozeomat
	default_price = PAYCHECK_ASSISTANT * 0.9
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV
	light_mask = "boozeomat-light-mask"

/obj/machinery/vending/boozeomat/all_access
	desc = "Чудо техники, якобы способное смешать именно ту смесь, которую вы хотите выпить, как только вы ее попросите. Эта модель не имеет ограничений доступа."
	req_access = null

/obj/machinery/vending/boozeomat/syndicate_access
	req_access = list(ACCESS_SYNDICATE)
	age_restrictions = FALSE

/obj/item/vending_refill/boozeomat
	machine_name = "Бухло-мат"
	icon_state = "refill_booze"
