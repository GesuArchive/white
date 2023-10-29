
//////////////////////////////////////OUTFITS//////////////////////////////////////
/datum/outfit/schoolshooter
	name = "Schoolshooter (clothes)"

	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/fingerless
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest/leather/noname
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/soft/black/columbine
	l_pocket = /obj/item/switchblade
	back = /obj/item/storage/backpack/duffelbag/syndie
	belt = /obj/item/storage/belt/military


/datum/outfit/schoolshooter/typeone
	name = "Schoolshooter HiPoint"

	suit_store = /obj/item/gun/ballistic/automatic/columbine
	r_pocket = /obj/item/ammo_box/magazine/m9mm_aps
	backpack_contents = list(
								/obj/item/storage/box/survival,
								/obj/item/grenade/iedcasing = 3,
								/obj/item/ammo_box/c9mm = 1,
								/obj/item/ammo_box/magazine/m9mm_aps = 1,
								/obj/item/grenade/c4 = 7,

								)

/datum/outfit/schoolshooter/typetwo
	name = "Schoolshooter Shotgun"

	l_hand = /obj/item/gun/ballistic/shotgun/fallout/huntingshot/columbine
	backpack_contents = list(
								/obj/item/storage/box/survival,
								/obj/item/grenade/iedcasing = 3,
								/obj/item/storage/box/lethalshot = 4,
								/obj/item/storage/belt/bandolier,
								/obj/item/crowbar/power/syndicate,
								/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
								/obj/item/lighter/greyscale
								)

/datum/outfit/schoolshooter/typefire
	name = "Schoolshooter Fire"

	mask = /obj/item/clothing/mask/breath
	gloves = /obj/item/clothing/gloves/color/plasmaman
	uniform = /obj/item/clothing/under/plasmaman
	head = /obj/item/clothing/head/helmet/space/plasmaman/security/head_of_security/terrorist
	r_pocket = /obj/item/tank/internals/plasmaman/belt/full

	l_hand = /obj/item/gun/ballistic/shotgun/fallout/huntingshot/columbine/fire
	backpack_contents = list(
								/obj/item/storage/box/survival,
								/obj/item/grenade/iedcasing = 3,
								/obj/item/storage/box/battle_incendiary = 4,
								/obj/item/storage/belt/bandolier,
								/obj/item/crowbar/power/syndicate,
								/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
								/obj/item/lighter/greyscale
								)

/*	А нужен ли третий тип скулшутера? У меня идея получше, но надо разобраться, как срать в динамик.
/datum/outfit/schoolshooter/typethree
	name = "Schoolshooter SKS"

	l_hand = /obj/item/gun/ballistic/shotgun/automatic/fallout/battle/sks
	backpack_contents =

*/
//////////////////////////////////////TEAM//////////////////////////////////////

/datum/team/schoolshooters
	name = "Террористы"
	member_name = "Террористы"

/datum/team/schoolshooters/New()
	..()
	var/datum/objective/hijack/O = new
	objectives += O

/datum/team/schoolshooters/is_solo()
	return FALSE

/datum/team/schoolshooters/roundend_report()
	var/list/result = list()

	var/won = TRUE
	for(var/datum/objective/O in objectives)
		if(!O.check_completion())
			won = FALSE
	if(won)
		result += "<span class='greentext big'>[name] team fulfilled its mission!</span>"
	else
		result += "<span class='redtext big'>[name] team failed its mission.</span>"

	result += span_header("The [name] were:")
	for(var/datum/mind/shooter in members)
		result += printplayer(shooter)
	result += printobjectives(objectives)

	return "<div class='panel redborder'>[result.Join("<br>")]</div>"

//////////////////////////////////////OBJECTIVES//////////////////////////////////////


//////////////////////////////////////ANTAG//////////////////////////////////////

/datum/antagonist/schoolshooter
	name = "Schoolshooter"
	roundend_category = "Terrorists"
	antagpanel_category = "Terrorists"
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	var/datum/team/schoolshooters/team
	greentext_reward = 20

/datum/antagonist/schoolshooter/create_team(datum/team/abductor_team/new_team)
	if(!new_team)
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	team = new_team

/datum/antagonist/schoolshooter/on_gain()
	owner.special_role = "Terrorist"
	owner.assigned_role = "Terrorist"
	objectives += team.objectives
	return ..()

//////////////////////////////////////ROUND EVENT//////////////////////////////////////

/datum/round_event_control/schoolshooters
	name = "Сотворение Террористов"
	typepath = /datum/round_event/ghost_role/schoolshooters
	max_occurrences = 10
	weight = 25
	min_players = 20
	earliest_start = 20 MINUTES
	//gamemode_blacklist = list("nuclear")

/datum/round_event/ghost_role/schoolshooters
	minimum_required = 2
	role_name = "Terrorists"
	fakeable = FALSE
	var/area/impact_area //Куда же упадут наши космодесантники?

/datum/round_event/ghost_role/schoolshooters/setup()
	impact_area = find_event_area()
	if(!impact_area)
		CRASH("No valid areas for Terrorist drop found.")
	var/list/turf_test = get_area_turfs(impact_area)
	if(!turf_test.len)
		CRASH("Spawn Terrorists : No valid turfs found for [impact_area] - [impact_area.type]")

/datum/round_event/ghost_role/schoolshooters/proc/find_event_area()
	var/static/list/allowed_areas
	if(!allowed_areas)
		///Places that shouldn't explode
		var/list/safe_area_types = typecacheof(list(
		/area/ai_monitored/turret_protected/ai,
		/area/ai_monitored/turret_protected/ai_upload,
		/area/engineering,
		/area/shuttle,
		/area/science/test_area)
		)

		///Subtypes from the above that actually should explode.
		var/list/unsafe_area_subtypes = typecacheof(list(/area/engineering/break_room))
		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes
	var/list/possible_areas = typecache_filter_list(GLOB.areas,allowed_areas)
	if (length(possible_areas))
		return pick(possible_areas)

/datum/round_event/ghost_role/schoolshooters/spawn_role()
	//var/list/funny_names = list("Podjog Saraev", "Rulon Oboev", "Ushat Pomoev", "Barak Mongolov", "Ulov Nalimov", "Zabeg Debilov", "Kompil Bildov", "Razriv Ochkov", "Anban Debilov", "Ali Rezun", "Obser Shtanov", "Krazha Donatov", "Nerf Debilov", "Progib Kozlov", "Podsos Pindosov")

	var/list/turf/valid_turfs = get_area_turfs(impact_area)
		//Only target non-dense turfs to prevent wall-embedded pods
	for(var/i in valid_turfs)
		var/turf/T = i
		if(T.density)
			valid_turfs -= T
	var/turf/landing = pick(valid_turfs)
	var/list/candidates = get_candidates(ROLE_TRAITOR, null, ROLE_TRAITOR)

	if(candidates.len < 2)
		return NOT_ENOUGH_PLAYERS

	var/mob/living/carbon/human/first = make_body(pick_n_take(candidates))
	var/mob/living/carbon/human/second = make_body(pick_n_take(candidates))

	var/datum/team/schoolshooters/T = new

	spawned_mobs += list(first, second)

	if(isplasmaman(first))
		first.equipOutfit(/datum/outfit/schoolshooter/typefire)
		first.internal = first.get_item_for_held_index(2)
	else
		first.equipOutfit(/datum/outfit/schoolshooter/typeone)

	if(isplasmaman(second))
		second.equipOutfit(/datum/outfit/schoolshooter/typefire)
		second.internal = second.get_item_for_held_index(2)
	else
		second.equipOutfit(/datum/outfit/schoolshooter/typeone)

	var/obj/structure/closet/supplypod/extractionpod/terrorist_pod = new()
	terrorist_pod.bluespace = FALSE
	terrorist_pod.explosionSize = list(0,0,0,3)
	terrorist_pod.style = STYLE_SYNDICATE
	terrorist_pod.name = "Террористический дроппод"
	terrorist_pod.desc = "Прямиком из группировок, запрещенных на территории NT."

	for(var/mob/living/carbon/human/M in spawned_mobs)
		M.mind.add_antag_datum(/datum/antagonist/schoolshooter, T)
		M.forceMove(terrorist_pod)
		log_game("[key_name(M)] has been selected as Terrorist.")
		M.real_name = get_funny_name(15)
	new /obj/effect/pod_landingzone(landing, terrorist_pod)
	spawn(rand(5 SECONDS, 30 SECONDS))
		priority_announce("Зафиксированна десантная капсула неизвестной террористической группировки","ТРЕВОГА!", 'sound/ai/announcer/alert.ogg') //мне это так глаза резало, что я не мог не исправить этот viser

	return SUCCESSFUL_SPAWN

/////////////////////ДИНАМИК ХУЙ ЖРАЛ, А ЕЩЕ Я НЕ ЕБУ, КАК С ЭТИМ РАБОТАТЬ/////////////////////////////////////
/*
datum/dynamic_ruleset/midround/from_ghosts/schoolshooters
	weight = 4
	name = "Команда скулшутеров"
	antag_flag = "schoolshooter"
	antag_flag_override = ROLE_TRAITOR
	antag_datum = /datum/antagonist/schoolshooter
	enemy_roles = list(JOB_RUSSIAN_OFFICER, JOB_HACKER,JOB_VETERAN, JOB_SECURITY_OFFICER, JOB_DETECTIVE,JOB_HEAD_OF_SECURITY, JOB_CAPTAIN, JOB_FIELD_MEDIC, JOB_SPECIALIST, JOB_INTERN)
	required_enemies = list(2,2,1,1,1,1,1,0,0,0)
	required_candidates = 2
	requirements = list(101,101,101,80,60,50,30,20,10,10)
	repeatable = TRUE
	var/list/spawn_locs = list()

/datum/dynamic_ruleset/midround/from_ghosts/schoolshooters/finish_setup(mob/new_character, index)

datum/dynamic_ruleset/midround/from_ghosts/schoolshooters/execute()
	for(var/turf/X in GLOB.xeno_spawn)
		if(istype(X.loc, /area/maintenance))
			spawn_locs += X


*/
////////////////////////////////////// ITEMS //////////////////////////////////////
/obj/item/clothing/head/soft/black/columbine
	armor = list(MELEE = 25, BULLET = 20, LASER = 20,ENERGY = 20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 10)
	name = "cальная кепка"
	desc = "Пропитанная затвердевшим потом и грязью кепка вполне способна сослужить в качестве брони"

/obj/item/gun/ballistic/shotgun/fallout/huntingshot/columbine //Девятизарядный дробовик с ОХУЕННЫМ ЗВУКОМ.
	force = 12

/obj/item/gun/ballistic/shotgun/fallout/huntingshot/columbine/fire
	name = "\"зажигалка\""
	mag_type = /obj/item/ammo_box/magazine/internal/shot/huntingshot/fire

// /obj/item/ammo_box/a762/sks
//	max_ammo = 10
