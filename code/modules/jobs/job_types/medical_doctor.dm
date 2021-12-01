/datum/job/doctor
	title = "Medical Doctor"
	ru_title = "Врач"
	department_head = list("Chief Medical Officer")
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "главному врачу"
	selection_color = "#ffeef0"

	exp_type = EXP_TYPE_CREW
	exp_requirements = 1200

	outfit = /datum/outfit/job/doctor

	skills = list(/datum/skill/surgery = SKILL_EXP_APPRENTICE)
	minimal_skills = list(/datum/skill/surgery = SKILL_EXP_NOVICE)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_MEDICAL_DOCTOR
	bounty_types = CIV_JOB_MED

	mail_goodies = list(
		/obj/item/healthanalyzer/advanced = 15,
		/obj/item/scalpel/advanced = 6,
		/obj/item/retractor/advanced = 6,
		/obj/item/cautery/advanced = 6,
		/datum/reagent/toxin/formaldehyde = 6,
		/obj/effect/spawner/lootdrop/organ_spawner = 5,
		/obj/effect/spawner/lootdrop/memeorgans = 1
	)

	rpg_title = "Клерик"

/datum/outfit/job/doctor
	name = "Medical Doctor"
	jobtype = /datum/job/doctor

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/doctor
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/medical
	suit_store = /obj/item/flashlight/pen
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/cheap=1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical

	skillchips = list(/obj/item/skillchip/entrails_reader)

	chameleon_extras = /obj/item/gun/syringe

	id_trim = /datum/id_trim/job/medical_doctor

/datum/outfit/job/doctor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	var/datum/martial_art/krav_maga/sanitar_closed_combat/maga = new
	maga.teach(H)
