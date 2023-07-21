/obj/machinery/vending/hydronutrients
	name = "Дом и Сад"
	desc = "Поставщик питательных веществ для растений."
	product_slogans = "Разве вы не рады, что вам не нужно удобрять естественным способом?;Теперь вонь на 50% меньше!;Растения тоже люди!"
	product_ads = "Нам нравятся растения!;Разве вы не хотите?;Самые зеленые пальцы на свете;Мы любим большие растения;Мягкая почва..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	light_mask = "nutri-light-mask"
	products = list(
		/obj/item/reagent_containers/glass/bottle/nutrient/ez = 30,
		/obj/item/reagent_containers/glass/bottle/nutrient/l4z = 30,
		/obj/item/reagent_containers/glass/bottle/nutrient/rh = 20,
		/obj/item/reagent_containers/spray/pestspray = 20,
		/obj/item/reagent_containers/syringe = 5,
		/obj/item/storage/bag/plants = 5,
		/obj/item/cultivator = 5,
		/obj/item/shovel/spade = 5,
		/obj/item/secateurs = 5,
		/obj/item/plant_analyzer = 4,
		/obj/item/storage/box/disks_plantgene = 4,
		)
	contraband = list(
		/obj/item/reagent_containers/glass/bottle/ammonia = 10,
		/obj/item/reagent_containers/glass/bottle/diethylamine = 5,
		/obj/item/storage/box/plumbing = 1,
		/obj/item/construction/plumbing = 1,
		/obj/item/reagent_containers/glass/beaker/large = 2
		)
	refill_canister = /obj/item/vending_refill/hydronutrients
	default_price = PAYCHECK_ASSISTANT * 0.8
	extra_price = PAYCHECK_HARD * 0.8
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/hydronutrients
	machine_name = "Дом и Сад"
	icon_state = "refill_plant"
