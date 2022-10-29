/datum/faction/syndicate
	name = "Синдикат"
	//Faction alignment
	friendly_factions = list(/datum/faction/syndicate)
	hostile_factions = list(/datum/faction/nanotrasen, /datum/faction/nanotrasen/central_command, /datum/faction/station)
	faction_tag = "SYD"

/datum/faction/syndicate/cybersun
	name = "Киберсан Индастрис"
	friendly_factions = list(/datum/faction/syndicate/mi_thirteen)
	hostile_factions = list(/datum/faction/nanotrasen, /datum/faction/nanotrasen/central_command, /datum/faction/station, /datum/faction/felinids)
	faction_tag = "CBS"

/datum/faction/syndicate/mi_thirteen
	name = "MI13"
	friendly_factions = list(/datum/faction/syndicate/cybersun)
	hostile_factions = list(/datum/faction/nanotrasen, /datum/faction/nanotrasen/central_command, /datum/faction/station, /datum/faction/felinids)
	faction_tag = "MI13"

/datum/faction/syndicate/tiger_corp
	name = "Тайгеркорп"
	friendly_factions = list(/datum/faction/syndicate/gorlex)
	hostile_factions = list(/datum/faction/nanotrasen, /datum/faction/nanotrasen/central_command, /datum/faction/station, /datum/faction/felinids)
	faction_tag = "TGR"

/datum/faction/syndicate/self
	name = "S.E.L.F"
	faction_tag = "SELF"

/datum/faction/syndicate/arc
	name = "Права животных"
	faction_tag = "ARC"

/datum/faction/syndicate/gorlex
	friendly_factions = list(/datum/faction/syndicate/tiger_corp, /datum/faction/felinids)
	name = "Мародёры горлекса"
	faction_tag = "GOR"

/datum/faction/syndicate/donk
	name = "Корпорация Донк"
	faction_tag = "DNK"

/datum/faction/syndicate/waffle
	name = "Корпорация Ваффл"
	faction_tag = "WFL"

// Oh god oh fuck
/datum/faction/syndicate/elite
	name = "Высшее командование Синдиката"
	faction_tag = "SHC"
