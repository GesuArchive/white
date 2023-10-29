/datum/round_event_control/carp_migration
	name = "Спавн: Миграция Карпов"
	typepath = /datum/round_event/carp_migration
	weight = 15
	min_players = 2
	earliest_start = 10 MINUTES
	max_occurrences = 6

/datum/round_event_control/carp_migration/New()
	. = ..()
	if(!HAS_TRAIT(SSstation, STATION_TRAIT_CARP_INFESTATION))
		return
	weight *= 3
	max_occurrences *= 2
	earliest_start *= 0.5

/datum/round_event/carp_migration
	announceWhen	= 3
	startWhen = 50
	var/hasAnnounced = FALSE

/datum/round_event/carp_migration/setup()
	startWhen = rand(40, 60)

/datum/round_event/carp_migration/announce(fake)
	priority_announce("Неизвестные биологические организмы были обнаружены вблизи [station_name()], пожалуйста, приготовьтесь.", "Вторжение на борт", 'sound/ai/announcer/assault.ogg')


/datum/round_event/carp_migration/start()
	var/mob/living/simple_animal/hostile/carp/fish
	for(var/obj/effect/landmark/carpspawn/C in GLOB.landmarks_list)
		if(prob(95))
			fish = new (C.loc)
		else
			fish = new /mob/living/simple_animal/hostile/carp/megacarp(C.loc)
			fishannounce(fish) //Prefer to announce the megacarps over the regular fishies
	fishannounce(fish)

/datum/round_event/carp_migration/proc/fishannounce(atom/fish)
	if (!hasAnnounced)
		announce_to_ghosts(fish) //Only anounce the first fish
		hasAnnounced = TRUE

/datum/round_event_control/scav_invasion
	name = "Заблудшие харвестеры"
	typepath = /datum/round_event/scav_invasion
	weight = 20
	min_players = 2
	earliest_start = 25 MINUTES
	max_occurrences = 1

/datum/round_event/scav_invasion
	announceWhen = 3
	startWhen = 50
	var/hasAnnounced = FALSE

/datum/round_event/scav_invasion/setup()
	startWhen = rand(40, 60)

/datum/round_event/scav_invasion/announce(fake)
	priority_announce("Обнаружен рой харвестеров, рекомендуем держать их подальше от обшивки станции [station_name()].", "Вторжение на борт", 'sound/ai/announcer/assault.ogg')

/datum/round_event/scav_invasion/start()
	var/mob/living/simple_animal/hostile/scavenger/scav
	for(var/obj/effect/landmark/carpspawn/C in GLOB.landmarks_list)
		if(prob(25))
			scav = new (C.loc)
	scavannounce(scav)

/datum/round_event/scav_invasion/proc/scavannounce(atom/scav)
	if (!hasAnnounced)
		announce_to_ghosts(scav)
		hasAnnounced = TRUE
