/datum/round_event_control/wizard/ghost //The spook is real
	name = "П-П-Призраки!"
	weight = 3
	typepath = /datum/round_event/wizard/ghost
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/wizard/ghost/start()
	var/msg = span_warning("Я внезапно ощущаю себя чрезвычайно материальным...")
	set_observer_default_invisibility(0, msg)


//--//

/datum/round_event_control/wizard/possession //Oh shit
	name = "Обличение П-П-Призраков!"
	weight = 2
	typepath = /datum/round_event/wizard/possession
	max_occurrences = 5
	earliest_start = 0 MINUTES

/datum/round_event/wizard/possession/start()
	for(var/mob/dead/observer/G in GLOB.player_list)
		add_verb(G, /mob/dead/observer/verb/boo)
		add_verb(G, /mob/dead/observer/verb/possess)
		to_chat(G, "Я чуствую прилив новой, жуткой силы...")
