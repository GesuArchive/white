/datum/faction/station
	name = "Космическая Станция 13"
	//Faction alignment
	friendly_factions = list(/datum/faction/nanotrasen, /datum/faction/nanotrasen/central_command)
	hostile_factions = list(/datum/faction/syndicate, /datum/faction/spider_clan)
	faction_tag = "NT13"

/datum/faction/nanotrasen
	name = "Нанотрейзен"
	//Faction alignment
	friendly_factions = list(/datum/faction/station, /datum/faction/nanotrasen/central_command)
	hostile_factions = list(/datum/faction/syndicate, /datum/faction/spider_clan)
	faction_tag = "NTC"

/datum/faction/nanotrasen/central_command
	name = "Центральное командование Нанотрейзен"
	//Faction alignment
	friendly_factions = list(/datum/faction/station, /datum/faction/nanotrasen)
	hostile_factions = list(/datum/faction/syndicate, /datum/faction/spider_clan)
	faction_tag = "NTC"
