/obj/machinery/vending/medical
	name = "НаноМед Плюс"
	desc = "Раздатчик медицинских препаратов."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Иди спаси несколько жизней!;Лучшее для медотсека.;Только лучшие инструменты.;Натуральные химикаты!;Эти штуки спасают жизни.;Разве ты не хочешь?;Пинг!"
	req_access = list(ACCESS_MEDICAL)
	products = list(
		/obj/item/reagent_containers/hypospray/medipen = 10,
		/obj/item/reagent_containers/hypospray/medipen/blood_loss = 5,
		/obj/item/reagent_containers/syringe = 12,
		/obj/item/reagent_containers/dropper = 3,
		/obj/item/healthanalyzer = 4,
		/obj/item/wrench/medical = 1,
		/obj/item/stack/sticky_tape/surgical = 3,
		/obj/item/stack/medical/bone_gel/four = 4,
		/obj/item/stack/medical/gauze = 8,
		/obj/item/stack/medical/suture/medicated = 6,
		/obj/item/stack/medical/mesh/advanced = 6,
		)
	contraband = list(
		/obj/item/storage/box/gum/happiness = 3,
		/obj/item/storage/box/hug/medical = 1,
		)
	premium = list(
		/obj/item/healthanalyzer/range = 2,
		/obj/item/reagent_containers/hypospray/medipen/blood_boost = 3,
		/obj/item/storage/belt/medical = 3,
		/obj/item/sensor_device = 2,
		/obj/item/pinpointer/crew = 2,
		/obj/item/storage/firstaid/advanced = 2,
		/obj/item/storage/firstaid/medical = 2,
		/obj/item/shears = 1,
		/obj/item/storage/organbox = 1
		)
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/medical
	default_price = PAYCHECK_EASY
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_MED
	light_mask = "med-light-mask"

/obj/item/vending_refill/medical
	machine_name = "НаноМед Плюс"
	icon_state = "refill_medical"

/obj/machinery/vending/medical/syndicate_access
	name = "СиндиМед Плюс"
	req_access = list(ACCESS_SYNDICATE)

//Created out of a necessity to get these dumb chems out of the medical tools vendor.
/obj/machinery/vending/drugs
	name = "НаноХим Плюс"
	desc = "Диспенсер медицинских препаратов."
	icon_state = "drug"
	icon_deny = "drug-deny"
	product_ads = "Иди спаси несколько жизней!;Лучшее для медотсека.;Только лучшие инструменты.;Натуральные химикаты!;Эти штуки спасают жизни.;Разве ты не хочешь?;Пинг!"
	req_access = list(ACCESS_MEDICAL)
	products = list(
		/obj/item/reagent_containers/pill/patch/libital = 15,
		/obj/item/reagent_containers/pill/patch/aiuri = 15,
		/obj/item/reagent_containers/pill/patch/synthflesh = 5,
		/obj/item/reagent_containers/pill/insulin = 15,
		/obj/item/storage/pill_bottle/psicodine = 4,
		/obj/item/storage/pill_bottle/sens = 4,
		/obj/item/reagent_containers/pill/mannitol = 10,
		/obj/item/reagent_containers/pill/neurine = 10,
		/obj/item/reagent_containers/pill/paxpsych = 10,
		/obj/item/reagent_containers/glass/bottle/multiver = 2,
		/obj/item/reagent_containers/glass/bottle/syriniver = 2,
		/obj/item/reagent_containers/glass/bottle/epinephrine = 3,
		/obj/item/reagent_containers/glass/bottle/morphine = 4,
		/obj/item/reagent_containers/glass/bottle/diphenhydramine = 3,
		/obj/item/reagent_containers/glass/bottle/potass_iodide = 3,
		/obj/item/reagent_containers/glass/bottle/salglu_solution = 3,
		/obj/item/reagent_containers/glass/bottle/toxin = 3,
		/obj/item/reagent_containers/syringe/antiviral = 6,
		/obj/item/reagent_containers/syringe/convermol = 2,
		/obj/item/reagent_containers/syringe/seiver_cold = 3,
		/obj/item/reagent_containers/syringe/seiver_hot = 3,
		/obj/item/reagent_containers/syringe/leporazine = 3,
		/obj/item/reagent_containers/medigel/libital = 4,
		/obj/item/reagent_containers/medigel/aiuri = 4,
		/obj/item/reagent_containers/medigel/multiver = 4,
		/obj/item/reagent_containers/medigel/sterilizine = 4,
		/obj/item/reagent_containers/medigel/synthflesh = 4)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/reagent_containers/pill/morphine = 4,
		)
	premium = list(/obj/item/plunger/reinforced = 2)
	default_price = CARGO_CRATE_VALUE * 5
	extra_price = CARGO_CRATE_VALUE * 15
	payment_department = ACCOUNT_MED
	refill_canister = /obj/item/vending_refill/drugs

/obj/item/vending_refill/drugs
	machine_name = "НаноХим Плюс"
	icon_state = "refill_medical"
