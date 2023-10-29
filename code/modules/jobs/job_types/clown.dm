/datum/job/clown
	title = JOB_CLOWN
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "главе персонала"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/clown

	paycheck = PAYCHECK_MINIMAL
	paycheck_department = ACCOUNT_SRV

	liver_traits = list(TRAIT_COMEDY_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CLOWN

	mail_goodies = list(
		/obj/item/food/grown/banana = 100,
		/obj/item/food/pie/cream = 50,
		/obj/item/clothing/shoes/clown_shoes/combat = 10,
		/obj/item/reagent_containers/spray/waterflower/lube = 20, // lube
		/obj/item/reagent_containers/spray/waterflower/superlube = 1 // Superlube, good lord.
	)

	departments_list = list(
		/datum/job_department/service,
	)

	rpg_title = "Jester"
	rpg_title_ru = "Плут"

/datum/job/clown/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	H.apply_pref_name("clown", M.client)

/datum/outfit/job/clown
	name = JOB_CLOWN
	jobtype = /datum/job/clown

	belt = /obj/item/modular_computer/tablet/pda/clown
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/bikehorn
	backpack_contents = list(
		/obj/item/stamp/clown = 1,
		/obj/item/reagent_containers/spray/waterflower = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/instrument/bikehorn = 1,
		)

	implants = list(/obj/item/implant/sad_trombone)

	backpack = /obj/item/storage/backpack/clown
	satchel = /obj/item/storage/backpack/clown
	duffelbag = /obj/item/storage/backpack/duffelbag/clown //strangely has a duffel

	box = /obj/item/storage/box/hug/survival

	chameleon_extras = /obj/item/stamp/clown

	id_trim = /datum/id_trim/job/clown

/datum/outfit/job/clown/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BANANIUM_SHIPMENTS))
		backpack_contents[/obj/item/stack/sheet/mineral/bananium] = 10

/datum/outfit/job/clown/get_types_to_preload()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BANANIUM_SHIPMENTS))
		. += /obj/item/stack/sheet/mineral/bananium/ten

/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	H.fully_replace_character_name(H.real_name, pick(GLOB.clown_names)) //rename the mob AFTER they're equipped so their ID gets updated properly.
	ADD_TRAIT(H, TRAIT_NAIVE, JOB_TRAIT)
	H.dna.add_mutation(CLOWNMUT)
	for(var/datum/mutation/human/clumsy/M in H.dna.mutations)
		M.mutadone_proof = TRUE
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(H)
