/datum/round_event_control/clown_infestation
	name = "Спавн: Апостол Хонкоматери"
	typepath = /datum/round_event/ghost_role/clown_infestation
	max_occurrences = 1
	min_players = 20

/datum/round_event/ghost_role/clown_infestation
	minimum_required = 1
	role_name = "Clown Apostle"
	fakeable = FALSE

/datum/round_event/ghost_role/clown_infestation/spawn_role()
	var/list/candidates = get_candidates(ROLE_ALIEN, null, ROLE_ALIEN)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	var/list/spawn_locs = list()
	for(var/X in GLOB.xeno_spawn)
		var/turf/T = X
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			spawn_locs += T

	if(!spawn_locs.len)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR

	var/mob/living/simple_animal/hostile/clown/mutant/glutton/S = new ((pick(spawn_locs)))
	player_mind.transfer_to(S)
	player_mind.assigned_role = "Apostle"
	player_mind.special_role = "Apostle"
	player_mind.add_antag_datum(/datum/antagonist/apostle)
	playsound(S, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into a Clown Apostle by an event.")
	log_game("[key_name(S)] was spawned as a Clown Apostle by an event.")
	spawned_mobs += S
	return SUCCESSFUL_SPAWN
