/obj/machinery/vending/games
	name = "SpacePunk 3077"
	desc = "Торгует вещами, которые Капитан и Кадровик, вероятно, не оценят, когда вы возитесь с этим вместо своей работы..."
	product_ads = "Убеги в фантастический мир!;Разжигайте свою зависимость от азартных игр!;Разрушайте вашу дружбу!;Бросьте инициативу!;Эльфы и гномы!;Параноидальные компьютеры!;Точно не сатанизм!;Веселые времена навсегда!"
	icon_state = "games"
	products = list(
		/obj/item/toy/cards/deck = 5,
		/obj/item/storage/pill_bottle/dice = 10,
		/obj/item/toy/cards/deck/cas = 3,
		/obj/item/toy/cards/deck/cas/black = 3,
		/obj/item/toy/cards/deck/kotahi = 3,
		/obj/item/toy/cards/deck/tarot = 3,
		/obj/item/toy/cards/deck/wizoff = 3,
		/obj/item/hourglass = 2,
		/obj/item/instrument/piano_synth/headphones = 4,
		/obj/item/camera = 3,
		/obj/item/cardpack/series_one = 10,
		/obj/item/cardpack/resin = 10,
		/obj/item/storage/card_binder = 10,
		/obj/item/skillchip/basketweaving = 2,
		/obj/item/skillchip/bonsai = 2,
		/obj/item/skillchip/wine_taster = 2,
		/obj/item/skillchip/light_remover = 2,
		/obj/item/skillchip/adapter = 5,
		/obj/item/skillchip/job/medic = 2,
		/obj/item/dyespray = 3,
		/obj/item/paint_palette = 3,
		)
	contraband = list(
		/obj/item/dice/fudge = 9,
		/obj/item/clothing/shoes/wheelys/skishoes =4,
		/obj/item/instrument/musicalmoth =1,
		)
	premium = list(
		/obj/item/melee/skateboard/pro = 3,
		/obj/item/clothing/shoes/wheelys/rollerskates = 3,
		/obj/item/melee/skateboard/hoverboard = 1,
		/obj/item/skillchip/job/medic/advanced = 2,
		/obj/item/skillchip/job/engineer = 2,
		/obj/item/skillchip/job/roboticist = 2,
		/obj/item/storage/box/tail_pin = 1,
		)
	refill_canister = /obj/item/vending_refill/games
	default_price = PAYCHECK_ASSISTANT
	extra_price = PAYCHECK_HARD * 1.25
	payment_department = ACCOUNT_SRV
	light_mask = "games-light-mask"

/obj/item/vending_refill/games
	machine_name = "SpacePunk 3077"
	icon_state = "refill_games"
