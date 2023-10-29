/obj/machinery/vending/chetverochka
	name = "Продуктовый вендомат (ОАО Четверочка-вендиг)"
	desc = "Всегда рядом."
	icon = 'white/baldenysh/icons/obj/vending.dmi'
	icon_state = "chetverochka"
	products = list(
					/obj/item/food/kebab/rat/double = 3,
					/obj/item/storage/box/lcubes = 5,
					/obj/item/food/canned/peaches/maint = 2,
					/obj/item/food/soylentgreen = 5
					)
	contraband = list(
					/obj/item/food/cheesewheel = 2
					)
	premium = list(
					/obj/item/storage/mre = 5,
					/obj/item/storage/mre/vegan = 5,
					/obj/item/storage/mre/protein = 5
					)
	refill_canister = /obj/item/vending_refill/cola
	default_price = CARGO_CRATE_VALUE * 1
	extra_price = CARGO_CRATE_VALUE * 2
	payment_department = ACCOUNT_SRV
	light_mask = "chetverochka-light-mask"

/obj/machinery/vending/chetverochka/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)

/obj/item/vending_refill/chetverochka
	machine_name = "Продуктовый вендомат (ОАО Четверочка-вендиг)"
	icon_state = "refill_сola"


/obj/machinery/vending/chetverochka/pharma
	name = "Аптечный вендомат (ОАО Четверочка-вендиг)"
	icon_state = "chet_pharma"
	products = list(
					/obj/item/stack/medical/gauze = 10,
					/obj/item/reagent_containers/hypospray/medipen = 3,
					/obj/item/storage/box/pillpack/potassiodide = 3,
					/obj/item/storage/box/pillpack/haloperidol = 3,
					/obj/item/storage/box/pillpack/antihol = 4,
					/obj/item/storage/box/pillpack/psicodine = 2,
					/obj/item/storage/box/pillpack/aspirin = 3
					)
	premium = list(
					/obj/item/storage/box/pillpack/stimulant = 1,
					/obj/item/stack/medical/aloe = 5,
					/obj/item/stack/medical/suture/medicated = 5
					)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/medical
	default_price = CARGO_CRATE_VALUE * 1
	extra_price = CARGO_CRATE_VALUE * 2
	payment_department = ACCOUNT_MED

/obj/machinery/vending/chetverochka/canLoadItem(obj/item/I,mob/user)
	return (I.type in products)

/obj/item/vending_refill/chetverochka/pharma
	machine_name = "Аптечный вендомат (ОАО Четверочка-вендиг)"
	icon_state = "refill_medical"
