/datum/job/lawyer
	title = JOB_LAWYER
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "главе персонала"
	selection_color = "#bbe291"
	var/lawyers = 0 //Counts lawyer amount

	outfit = /datum/outfit/job/lawyer

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_LAWYER

	departments_list = list(
		/datum/job_department/service,
	)

	rpg_title = "Magistrate"
	rpg_title_ru = "Магистрат"

/datum/outfit/job/lawyer
	name = JOB_LAWYER
	jobtype = /datum/job/lawyer

	belt = /obj/item/modular_computer/tablet/pda/lawyer
	ears = /obj/item/radio/headset/headset_srvsec
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit
	suit = /obj/item/clothing/suit/toggle/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/storage/briefcase/lawyer
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge

	chameleon_extras = /obj/item/stamp/law

	id_trim = /datum/id_trim/job/lawyer

/datum/outfit/job/lawyer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return ..()

	var/static/use_purple_suit = FALSE //If there is one lawyer, they get the default blue suit. If another lawyer joins the round, they start with a purple suit.
	if(use_purple_suit)
		uniform = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit
		suit = /obj/item/clothing/suit/toggle/lawyer/purple
	else
		use_purple_suit = TRUE
	..()

/datum/outfit/job/lawyer/get_types_to_preload()
	. = ..()
	. += /obj/item/clothing/under/rank/civilian/lawyer/purpsuit
	. += /obj/item/clothing/suit/toggle/lawyer/purple
