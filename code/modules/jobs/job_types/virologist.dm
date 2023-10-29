/datum/job/virologist
	title = JOB_VIROLOGIST
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "главному врачу"
	selection_color = "#ffeef0"
	exp_type = EXP_TYPE_CREW
	exp_requirements = 300

	outfit = /datum/outfit/job/virologist

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_VIROLOGIST
	bounty_types = CIV_JOB_VIRO

	mail_goodies = list(
		/obj/item/reagent_containers/glass/bottle/random_virus = 15,
		/obj/item/reagent_containers/glass/bottle/formaldehyde = 10,
		/obj/item/reagent_containers/glass/bottle/synaptizine = 10,
		/obj/item/stack/sheet/mineral/plasma = 10,
		/obj/item/stack/sheet/mineral/uranium = 5
	)

	departments_list = list(
		/datum/job_department/medical,
	)

	rpg_title = "Plague Doctor"
	rpg_title_ru = "Чумной доктор"

/datum/outfit/job/virologist
	name = JOB_VIROLOGIST
	jobtype = /datum/job/virologist

	belt = /obj/item/modular_computer/tablet/pda/viro
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/virologist
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/virologist
	suit_store =  /obj/item/flashlight/pen

	backpack = /obj/item/storage/backpack/virology
	satchel = /obj/item/storage/backpack/satchel/vir
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	skillchips = list(/obj/item/skillchip/job/medic/virusolog)

	id_trim = /datum/id_trim/job/virologist
