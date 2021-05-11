
//////////////////////////////////////OUTFITS//////////////////////////////////////
/datum/outfit/schoolshooter
	name = "Schoolshooter (clothes)"

	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/fingerless
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest/leather/wzzzz/tailcoat/black
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

/*	А нужен ли третий тип скулшутера? У меня идея получше, но надо разобраться, как срать в динамик.
/datum/outfit/schoolshooter/typethree
	name = "Schoolshooter SKS"

	l_hand = /obj/item/gun/ballistic/shotgun/automatic/fallout/battle/sks
	backpack_contents =

*/
//////////////////////////////////////TEAM//////////////////////////////////////

/datum/team/schoolshooters
	name = "Террористы"
	member_name = "Террорист"

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

	result += "<span class='header'>The [name] were:</span>"
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
	var/datum/team/schoolshooters/team

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
	name = "Spawn Terrorists"
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

/datum/round_event/ghost_role/schoolshooters/spawn_role()
	var/list/funny_names = list("Podjog Saraev", "Rulon Oboev", "Ushat Pomoev", "Barak Mongolov", "Ulov Nalimov", "Zabeg Debilov")

	var/list/possible_spawns = list()
	for(var/turf/X in GLOB.xeno_spawn)
		if(istype(X.loc, /area/maintenance))
			possible_spawns += X

	if(!possible_spawns.len)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR

	var/turf/landing_turf = pick(possible_spawns)

	var/list/candidates = get_candidates(ROLE_TRAITOR, null, ROLE_TRAITOR)

	if(candidates.len < 2)
		return NOT_ENOUGH_PLAYERS

	var/mob/living/carbon/human/first = makeBody(pick_n_take(candidates))
	var/mob/living/carbon/human/second = makeBody(pick_n_take(candidates))

	var/datum/team/schoolshooters/T = new

	spawned_mobs += list(first, second)

	first.equipOutfit(/datum/outfit/schoolshooter/typeone)
	second.equipOutfit(/datum/outfit/schoolshooter/typetwo)

	for(var/mob/living/carbon/human/M in spawned_mobs)
		M.mind.add_antag_datum(/datum/antagonist/schoolshooter, T)
		M.forceMove(landing_turf)
		log_game("[key_name(M)] has been selected as Terrorist.")
		var/namae = pick(funny_names)
		funny_names -= namae
		M.real_name = namae


	return SUCCESSFUL_SPAWN

/////////////////////ДИНАМИК ХУЙ ЖРАЛ, А ЕЩЕ Я НЕ ЕБУ, КАК С ЭТИМ РАБОТАТЬ/////////////////////////////////////
/*
datum/dynamic_ruleset/midround/from_ghosts/schoolshooters
	weight = 4
	name = "Команда скулшутеров"
	antag_flag = "schoolshooter"
	antag_flag_override = ROLE_TRAITOR
	antag_datum = /datum/antagonist/schoolshooter
	enemy_roles = list("Russian Officer", "Hacker","Veteran", "Security Officer", "Detective","Head of Security", "Captain", "Field Medic")
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

// /obj/item/ammo_box/a762/sks
//	max_ammo = 10
