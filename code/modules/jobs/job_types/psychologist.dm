/datum/job/psychologist
	title = "Psychologist"
	ru_title = "Психолог"
	department_head = list("Head of Personnel", "Chief Medical Officer")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel and the chief medical officer"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/psychologist

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SRV

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PSYCHOLOGIST

	mail_goodies =  list(
		/obj/item/storage/pill_bottle/mannitol = 30,
		/obj/item/storage/pill_bottle/happy = 5,
		/obj/item/gun/syringe = 1
	)

/datum/outfit/job/psychologist
	name = "Psychologist"
	jobtype = /datum/job/psychologist

	ears = /obj/item/radio/headset/headset_srvmed
	uniform = /obj/item/clothing/under/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/advanced
	belt = /obj/item/pda/medical
	pda_slot = ITEM_SLOT_BELT
	l_hand = /obj/item/clipboard

	backpack_contents = list(/obj/item/modular_computer/tablet/preset/cheap=1, /obj/item/storage/pill_bottle/mannitol, /obj/item/storage/pill_bottle/psicodine, /obj/item/storage/pill_bottle/paxpsych, /obj/item/storage/pill_bottle/happinesspsych, /obj/item/storage/pill_bottle/lsdpsych, /obj/item/storage/pill_bottle/labebium)

	skillchips = list(/obj/item/skillchip/job/psychology)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	id_trim = /datum/id_trim/job/psychologist

/*
/datum/outfit/job/psychologist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.AddAbility(new/obj/effect/proc_holder/cure_ptsd(null))

/obj/effect/proc_holder/cure_ptsd
	name = "Вылечить ПТСР"
	action_icon_state = "mindread"

/obj/effect/proc_holder/cure_ptsd/Click()
	select_person(action?.owner)

/obj/effect/proc_holder/cure_ptsd/proc/select_person(mob/user)
	var/mob/living/carbon/human/picked_human
	picked_human = input(user, "Лечение ПТСР", "Это будет стоить тебе всего 100 метакэша. Убедись, что цель отработала их для тебя сполна, перед лечением.") as null|mob in view(4, user)
	if(!picked_human)
		to_chat(user, span_notice("Никого не выбрали."))
		return
	if(!ishuman(picked_human))
		to_chat(user, span_notice("Это не человек!"))
		return
	if(picked_human.stat != CONSCIOUS)
		to_chat(user, span_notice("[picked_human] не сможет вылечиться в таком состоянии."))
		return
	if(!picked_human.has_trauma_type(resilience = TRAUMA_RESILIENCE_PSYCHONLY))
		to_chat(user, span_notice("У [picked_human] нет ПТСР."))
		return
	var/area/A = get_area(picked_human)
	if(!istype(A, /area/medical/psychology))
		to_chat(user, span_notice("[picked_human] должен быть в моём кабинете."))
		return
	inc_metabalance(user, -100, reason="Лечение выполнено успешно!")
	picked_human.cure_all_traumas(TRAUMA_RESILIENCE_PSYCHONLY)
*/
