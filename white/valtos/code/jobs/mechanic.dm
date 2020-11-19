/datum/job/engineer/mechanic
	title = "Механик"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 0
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/mechanic

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_ENG

	metalocked = TRUE

/area/engine/manufactory
	name = "Фабрика"
	icon_state = "engine"

/datum/outfit/job/mechanic
	name = "Механик"
	jobtype = /datum/job/engineer/mechanic

	belt = /obj/item/storage/belt/utility/full/engi
	l_pocket = /obj/item/pda/engineering
	ears = /obj/item/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineering/engineer/wzzzz/mechanic
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/welding
	r_pocket = /obj/item/t_scanner
	l_hand = /obj/item/storage/part_replacer/cargo

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced = 1)

	skillchip_path = /obj/item/skillchip/job/engineer
