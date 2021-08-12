SUBSYSTEM_DEF(metainv)
	name = "Метаинвентарь"
	flags = SS_NO_FIRE //хз потом убрать если дроп кейсов со временем прикрутить припрет
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = 5

	var/list/items_by_ckey = list()

/datum/controller/subsystem/metainv/Initialize()
	. = ..()

/datum/controller/subsystem/killcounter/proc/load(ckey)
	var/json_file = file("data/player_saves/[ckey[1]]/[ckey]/metainv.json")
	if(!fexists(json_file))
		items_by_ckey[ckey] = list()
		return
	items_by_ckey[ckey] = json_decode(json_file)

/datum/controller/subsystem/killcounter/proc/save(ckey)
	var/infofile = "data/player_saves/[ckey[1]]/[ckey]/metainv.json"
