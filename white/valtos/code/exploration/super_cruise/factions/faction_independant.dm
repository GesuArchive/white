/datum/faction/spider_clan
	name = "Клан паука"
	//No straight hostiles until acted aganist
	faction_tag = "SPD"

/datum/faction/pirates
	name = "Пираты"
	hostile_factions = list(/datum/faction/nanotrasen, /datum/faction/station, /datum/faction/independant)
	faction_tag = "Unmarked"

/datum/faction/golems
	name = "Свободные големы"
	friendly_factions = list(/datum/faction/nanotrasen, /datum/faction/station, /datum/faction/felinids)
	hostile_factions = list(/datum/faction/spider_clan, /datum/faction/syndicate)
	faction_tag = "GLM"

/datum/faction/felinids
	name = "ОФА"
	friendly_factions = list(/datum/faction/syndicate/arc, /datum/faction/golems)
	hostile_factions = list(/datum/faction/spider_clan)
	faction_tag = "CAT"

/datum/faction/independant
	name = "Независимые"
	//Faction alignment (Starts only hostile to pirates but can become hostile to the syndicate.)
	hostile_factions = list(/datum/faction/pirates)
	faction_tag = "IND"
