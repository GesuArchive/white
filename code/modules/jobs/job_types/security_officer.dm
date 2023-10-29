/datum/job/security_officer
	title = JOB_SECURITY_OFFICER
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list(JOB_HEAD_OF_SECURITY)
	faction = "Station"
	total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "начальнику охраны и главе назначенного мне отдела (если есть)"
	selection_color = "#ffeeee"
	minimal_player_age = 14
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/security

	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER
	bounty_types = CIV_JOB_SEC

	var/assign_dep = TRUE

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/melee/baton/boomerang/loaded = 1
	)

	departments_list = list(
		/datum/job_department/security,
	)

	rpg_title = "Guard"
	rpg_title_ru = "Страж"

GLOBAL_LIST_INIT(available_depts, list(SEC_DEPT_ENGINEERING, SEC_DEPT_MEDICAL, SEC_DEPT_SCIENCE, SEC_DEPT_SUPPLY))

/datum/job/security_officer/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	// Assign department security
	var/department
	if(M && M.client && M.client.prefs)
		department = M.client.prefs.prefered_security_department
		if(!LAZYLEN(GLOB.available_depts) || department == "None")
			return
		else if(department in GLOB.available_depts)
			LAZYREMOVE(GLOB.available_depts, department)
		else
			department = pick_n_take(GLOB.available_depts)
	var/ears = null
	var/accessory = null
	var/list/dep_trim = null
	var/destination = null
	var/spawn_point = null
	if(assign_dep)
		switch(department)
			if(SEC_DEPT_SUPPLY)
				ears = /obj/item/radio/headset/headset_sec/alt/department/supply
				dep_trim = /datum/id_trim/job/security_officer/supply
				destination = /area/security/checkpoint/supply
				spawn_point = locate(/obj/effect/landmark/start/depsec/supply) in GLOB.department_security_spawns
				accessory = /obj/item/clothing/accessory/armband/cargo
			if(SEC_DEPT_ENGINEERING)
				ears = /obj/item/radio/headset/headset_sec/alt/department/engi
				dep_trim = /datum/id_trim/job/security_officer/engineering
				destination = /area/security/checkpoint/engineering
				spawn_point = locate(/obj/effect/landmark/start/depsec/engineering) in GLOB.department_security_spawns
				accessory = /obj/item/clothing/accessory/armband/engine
			if(SEC_DEPT_MEDICAL)
				ears = /obj/item/radio/headset/headset_sec/alt/department/med
				dep_trim = /datum/id_trim/job/security_officer/medical
				destination = /area/security/checkpoint/medical
				spawn_point = locate(/obj/effect/landmark/start/depsec/medical) in GLOB.department_security_spawns
				accessory =  /obj/item/clothing/accessory/armband/medblue
			if(SEC_DEPT_SCIENCE)
				ears = /obj/item/radio/headset/headset_sec/alt/department/sci
				dep_trim = /datum/id_trim/job/security_officer/science
				destination = /area/security/checkpoint/science
				spawn_point = locate(/obj/effect/landmark/start/depsec/science) in GLOB.department_security_spawns
				accessory = /obj/item/clothing/accessory/armband/science

	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		U.attach_accessory(new accessory)
	if(ears)
		if(H.ears)
			qdel(H.ears)
		H.equip_to_slot_or_del(new ears(H),ITEM_SLOT_EARS)

	// If there's a departmental sec trim to apply to the card, overwrite.
	if(dep_trim)
		var/obj/item/card/id/worn_id = H.wear_id
		SSid_access.apply_trim_to_card(worn_id, dep_trim)
		H.sec_hud_set_ID()

	var/teleport = 0
	if(!CONFIG_GET(flag/sec_start_brig))
		if(destination || spawn_point)
			teleport = 1
	if(teleport)
		var/turf/T
		if(spawn_point)
			T = get_turf(spawn_point)
			H.Move(T)
		else
			var/list/possible_turfs = get_area_turfs(destination)
			while (length(possible_turfs))
				var/I = rand(1, possible_turfs.len)
				var/turf/target = possible_turfs[I]
				if (H.Move(target))
					break
				possible_turfs.Cut(I,I+1)
	if(department && assign_dep)
		to_chat(M, "<b>Мне назначено следить за порядком в [department]!</b>")
	else
		to_chat(M, "<b>У меня нет особых назначений в отделы на эту смену. Пока только патрулирование является моей задачей.</b>")



/datum/outfit/job/security
	name = JOB_SECURITY_OFFICER
	jobtype = /datum/job/security_officer

	belt = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/officer
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/sec
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld
	suit_store = /obj/item/gun/energy/disabler

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = list(/obj/item/clothing/glasses/hud/security/sunglasses, /obj/item/clothing/head/helmet)
	//The helmet is necessary because /obj/item/clothing/head/helmet/sec is overwritten in the chameleon list by the standard helmet, which has the same name and icon state

	id_trim = /datum/id_trim/job/security_officer


/obj/item/radio/headset/headset_sec/alt/department/Initialize(mapload)
	. = ..()
	wires = new/datum/wires/radio(src)
	secure_radio_connections = list()
	recalculateChannels()

/obj/item/radio/headset/headset_sec/alt/department/engi
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_sec/alt/department/supply
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_sec/alt/department/med
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_sec/alt/department/sci
	keyslot = new /obj/item/encryptionkey/headset_sec
	keyslot2 = new /obj/item/encryptionkey/headset_sci
