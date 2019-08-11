
//////////////////////////////////////OUTFITS//////////////////////////////////////
/datum/outfit/schoolshooter
	name = "Schoolshooter (clothes)"

	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/fingerless
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest/leather
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/soft/black
	l_pocket = /obj/item/switchblade
	back = /obj/item/storage/backpack/satchel

/datum/outfit/schoolshooter/typeone
	name = "Schoolshooter 1"

	belt = /obj/item/gun/ballistic/automatic/m90/columbine
	r_pocket = /obj/item/ammo_box/magazine/pistolm9mm
	backpack_contents = list(
								/obj/item/ammo_box/c9mm = 1,
								/obj/item/ammo_box/magazine/pistolm9mm = 1,
								/obj/item/grenade/syndieminibomb/concussion = 3,
								/obj/item/grenade/c4 = 2
							)

/datum/outfit/schoolshooter/typetwo
	name = "Schoolshooter 2"

//////////////////////////////////////TEAM//////////////////////////////////////

/datum/team/schoolshooters
	member_name = "schoolshooter"

//////////////////////////////////////ANTAG//////////////////////////////////////

/datum/antagonist/schoolshooter
	name = "Schoolshooter"
	roundend_category = "schoolshooters"
	antagpanel_category = "Traitor"
	show_in_antagpanel = FALSE
	greet_text = "Use your stealth technology and equipment to incapacitate humans for your scientist to retrieve."
	var/datum/team/schoolshooters/team

/datum/antagonist/schoolshooter/typeone
	outfit = /datum/outfit/schoolshooter/typeone

/datum/antagonist/schoolshooter/typetwo
	outfit = /datum/outfit/schoolshooter/typetwo

//////////////////////////////////////ROUND EVENT//////////////////////////////////////

/datum/round_event_control/schoolshooters
	name = "Spawn Schoolshooters"
	typepath = /datum/round_event/ghost_role/schoolshooters
	max_occurrences = 10
	min_players = 20
	earliest_start = 30 MINUTES
	//gamemode_blacklist = list("nuclear")

/datum/round_event/ghost_role/schoolshooters
	minimum_required = 2
	role_name = "schoolshooters"
	fakeable = FALSE

/datum/round_event/ghost_role/schoolshooters/spawn_role()
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

	log_game("[key_name(first)] has been selected as Schoolshooter.")
	log_game("[key_name(second)] has been selected as Schoolshooter.")

	first.mind.add_antag_datum(/datum/antagonist/schoolshooter/typeone, T)
	second.mind.add_antag_datum(/datum/antagonist/schoolshooter/typetwo, T)

	spawned_mobs += list(first, second)

	return SUCCESSFUL_SPAWN


