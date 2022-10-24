/datum/round_event_control/resonance_cascade
	name = "Портальный шторм: Пространственно-временной каскад"
	typepath = /datum/round_event/portal_storm/resonance_cascade
	weight = 0
	max_occurrences = 0

/datum/round_event/portal_storm/resonance_cascade/announce(fake)
	set waitfor = 0
	sound_to_playing_players('white/valtos/sounds/black_mesa/tc_12_portalsuck.ogg')
	sleep(40)
	priority_announce("ВНИМАНИЕ: обнаружен пространственно-временной каскад; приближается массивный межпространственный разлом!", "Межпространственный разлом", ANNOUNCER_ANIMES)
	sleep(20)
	sound_to_playing_players('white/valtos/sounds/black_mesa/tc_13_teleport.ogg')

/datum/round_event/portal_storm/resonance_cascade
	hostile_types = list(
		/mob/living/simple_animal/hostile/blackmesa/xen/bullsquid = 25,
		/mob/living/simple_animal/hostile/blackmesa/xen/houndeye = 25,
		/mob/living/simple_animal/hostile/blackmesa/xen/headcrab = 25,
		/mob/living/simple_animal/hostile/blackmesa/xen/vortigaunt/slave = 25
	)
