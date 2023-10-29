/obj/machinery/vending/wallmed
	name = "НаноМед"
	desc = "Настенный диспенсер для медицинских утех."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = FALSE
	products = list(
		/obj/item/reagent_containers/syringe = 3,
		/obj/item/reagent_containers/pill/patch/libital = 10,
		/obj/item/reagent_containers/pill/patch/aiuri = 10,
		/obj/item/reagent_containers/pill/multiver = 10,
		/obj/item/reagent_containers/medigel/libital = 2,
		/obj/item/reagent_containers/medigel/aiuri = 2,
		/obj/item/reagent_containers/medigel/multiver = 2,
		/obj/item/reagent_containers/medigel/sterilizine = 2,
		/obj/item/reagent_containers/hypospray/medipen = 3,
		/obj/item/reagent_containers/hypospray/medipen/blood_boost = 3,
		/obj/item/healthanalyzer/wound = 2,
		/obj/item/stack/medical/bone_gel/four = 2
		)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 2,
		/obj/item/reagent_containers/pill/morphine = 2,
		/obj/item/storage/box/gum/happiness = 1)
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/wallmed
	default_price = PAYCHECK_HARD //Double the medical price due to being meant for public consumption, not player specfic
	extra_price = PAYCHECK_HARD * 1.5
	payment_department = ACCOUNT_MED
	tiltable = FALSE
	light_mask = "wallmed-light-mask"

/obj/machinery/vending/wallmed/directional/north
	dir = SOUTH
	pixel_y = 32

/obj/machinery/vending/wallmed/directional/south
	dir = NORTH
	pixel_y = -32

/obj/machinery/vending/wallmed/directional/east
	dir = WEST
	pixel_x = 32

/obj/machinery/vending/wallmed/directional/west
	dir = EAST
	pixel_x = -32

/obj/item/vending_refill/wallmed
	machine_name = "НаноМед"
	icon_state = "refill_medical"
