/datum/job/freelancer
	title = JOB_FREELANCER
	department_head = list()
	faction = "Station"
	total_positions = 10
	spawn_positions = 10
	supervisors = "никому"
	selection_color = "#e005e4"

	exp_type = EXP_TYPE_CREW
	exp_requirements = 0

	outfit = /datum/outfit/job/freelancer

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_STA

	display_order = JOB_DISPLAY_ORDER_SPECIAL
	bounty_types = CIV_JOB_RANDOM

	departments_list = list(
		/datum/job_department/assistant,
	)

	rpg_title = "Freelancer"
	rpg_title_ru = "Путешественник"

/datum/job/freelancer/New()
	. = ..()
	whitelisted = GLOB.donators_list["boosty"]

/datum/outfit/job/freelancer
	name = JOB_FREELANCER
	jobtype = /datum/job/freelancer

	glasses = /obj/item/clothing/glasses/hud/health/sunglasses

	r_pocket = /obj/item/kitchen/knife/combat
	l_pocket = /obj/item/gps

	id_trim = /datum/id_trim/job/freelancer

/datum/job/freelancer/override_latejoin_spawn(mob/living/carbon/human/H)
	if(SSmapping.spawn_type_shuttle(/datum/map_template/shuttle/freelancer/medium))
		H.forceMove(get_spawnpoint())
	return TRUE

/datum/job/freelancer/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	if(!latejoin && SSmapping.spawn_type_shuttle(/datum/map_template/shuttle/freelancer/medium))
		H.forceMove(get_spawnpoint())

/datum/job/freelancer/proc/get_spawnpoint()
	for(var/_sloc in GLOB.start_landmarks_list)
		var/obj/effect/landmark/start/sloc = _sloc
		if(sloc.name != JOB_FREELANCER)
			continue
		var/turf/T = get_turf(sloc)
		qdel(sloc)
		return T
	return null

/datum/outfit/job/freelancer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	return

/datum/outfit/job/freelancer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	GLOB.freelancer_shuttles = GLOB.freelancer_shuttles + 1

	spawn(50)
		var/obj/item/card/id/ID = H.get_idcard()
		if(ID)
			ID.registered_account.adjust_money(15000, 25000)

/datum/id_trim/job/freelancer
	assignment = JOB_FREELANCER
	trim_state = "trim_freelancer"
	full_access = list(ACCESS_MAINT_TUNNELS, ACCESS_AWAY_GENERAL)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_AWAY_GENERAL)
	config_job = "freelancer"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_CHANGE_IDS)

/obj/item/circuitboard/computer/freelancer
	build_path = /obj/machinery/computer/shuttle_flight/freelancer

GLOBAL_VAR_INIT(freelancer_shuttles, 0)

/obj/machinery/computer/shuttle_flight/freelancer
	name = "Консоль Управления Фрегатом"
	desc = "Используется для управления данным быстрым и мобильным кораблём."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list()
	circuit = /obj/item/circuitboard/computer/freelancer

/obj/machinery/computer/shuttle_flight/freelancer/Initialize(mapload, obj/item/circuitboard/C)
	shuttleId = "freelancer_small[GLOB.freelancer_shuttles]"
	possible_destinations = "freelancer_small[GLOB.freelancer_shuttles]_custom"
	. = ..()

/obj/machinery/computer/shuttle_flight/freelancer/LateInitialize()
	. = ..()
	launch_shuttle()

/area/shuttle/freelancer
	name = "Фрегат Путешественника"
	requires_power = TRUE
	area_flags = VALID_TERRITORY | UNIQUE_AREA
	ambience_index = AMBIENCE_NONE
	ambientsounds = SCARLET_DAWN_AMBIENT
	area_limited_icon_smoothing = /area/shuttle/freelancer

/area/shuttle/freelancer/cabine
	name = "Фрегат Путешественника: Кабина"

/area/shuttle/freelancer/cargo
	name = "Фрегат Путешественника: Трюм"

/area/shuttle/freelancer/passengers
	name = "Фрегат Путешественника: Пассажиры"

/area/shuttle/freelancer/rnd
	name = "Фрегат Путешественника: Исследования"

/area/shuttle/freelancer/med
	name = "Фрегат Путешественника: Медбей"

/obj/docking_port/mobile/freelancer
	name = "Фрегат Путешественника"
	id = "freelancer_small"
	ignitionTime = 5
	callTime = 5
	port_direction = 2
	preferred_direction = 1

/obj/docking_port/mobile/freelancer/Initialize(mapload)
	id = "freelancer_small[GLOB.freelancer_shuttles]"
	. = ..()
