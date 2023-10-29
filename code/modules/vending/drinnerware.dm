/obj/machinery/vending/dinnerware
	name = "Цельнометаллическая поварешка"
	desc = "Продавец кухонного и ресторанного оборудования."
	product_ads = "Мм, продукты питания!;Еда и пищевые аксессуары.;Бери свои тарелки!;Ты любишь вилки?;Я люблю вилки!;Ух, посуда.;Тебе это действительно не нужно..."
	icon_state = "dinnerware"
	products = list(
		/obj/item/storage/bag/tray = 8,
		/obj/item/reagent_containers/glass/bowl = 20,
		/obj/item/kitchen/fork = 16,
		/obj/item/kitchen/spoon = 16,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 8,
		/obj/item/reagent_containers/food/condiment/pack/ketchup = 5,
		/obj/item/reagent_containers/food/condiment/pack/hotsauce = 5,
		/obj/item/reagent_containers/food/condiment/pack/astrotame = 5,
		/obj/item/reagent_containers/food/condiment/saltshaker = 5,
		/obj/item/reagent_containers/food/condiment/peppermill = 5,
		/obj/item/clothing/suit/apron/chef = 2,
		/obj/item/kitchen/rollingpin = 2,
		/obj/item/kitchen/knife = 2,
		/obj/item/book/granter/crafting_recipe/cooking_sweets_101 = 2
	)
	contraband = list(
		/obj/item/kitchen/rollingpin = 2,
		/obj/item/kitchen/knife/butcher = 2,
	)
	refill_canister = /obj/item/vending_refill/dinnerware
	default_price = PAYCHECK_ASSISTANT * 0.8
	extra_price = PAYCHECK_HARD
	payment_department = ACCOUNT_SRV
	light_mask = "dinnerware-light-mask"

/obj/item/vending_refill/dinnerware
	machine_name = "Цельнометаллическая поварешка"
	icon_state = "refill_smoke"
