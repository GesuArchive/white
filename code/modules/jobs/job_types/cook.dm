/datum/job/cook
	title = JOB_COOK
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "главе персонала"
	selection_color = "#bbe291"
	var/cooks = 0 //Counts cooks amount

	outfit = /datum/outfit/job/cook

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	liver_traits = list(TRAIT_CULINARY_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_COOK
	bounty_types = CIV_JOB_CHEF

	departments_list = list(
		/datum/job_department/service,
	)

	rpg_title = "Tavern Chef"
	rpg_title_ru = "Повар Трактира"

	mail_goodies = list(
		/obj/item/storage/box/ingredients/random = 80,
		/datum/reagent/consumable/caramel =  20,
		/obj/item/reagent_containers/food/condiment/flour = 20,
		/obj/item/reagent_containers/food/condiment/rice = 20,
		/obj/item/reagent_containers/food/condiment/enzyme = 15,
		/obj/item/reagent_containers/food/condiment/soymilk = 15,
		/obj/item/kitchen/knife = 4,
		/obj/item/kitchen/knife/butcher = 2
	)

/datum/outfit/job/cook
	name = JOB_COOK
	jobtype = /datum/job/cook

	belt = /obj/item/modular_computer/tablet/pda/cook
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/chef
	suit = /obj/item/clothing/suit/toggle/chef
	head = /obj/item/clothing/head/chefhat
	mask = /obj/item/clothing/mask/fakemoustache/italian
	backpack_contents = list(
		/obj/item/sharpener = 1,
		/obj/item/choice_beacon/ingredient = 1
		)

	id_trim = /datum/id_trim/job/cook

/datum/outfit/job/cook/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	var/datum/job/cook/J = SSjob.GetJobType(jobtype)
	if(J) // Fix for runtime caused by invalid job being passed
		if(J.cooks>0)//Cooks
			suit = /obj/item/clothing/suit/apron/chef
			head = /obj/item/clothing/head/soft/mime
		if(!visualsOnly)
			J.cooks++

/datum/outfit/job/cook/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	var/datum/martial_art/cqc/under_siege/justacook = new
	justacook.teach(H)

/datum/outfit/job/cook/get_types_to_preload()
	. = ..()
	. += /obj/item/clothing/suit/apron/chef
	. += /obj/item/clothing/head/soft/mime
