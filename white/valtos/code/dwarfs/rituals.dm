/datum/ritual
	var/name = "ritual"
	var/true_name = "basetirual" // to identify ritual in dwarf altar.perform_rite()
	var/desc = "govno"
	var/cost = 0

/datum/ritual/summon_dwarf
	name = "Призвать дворфа"
	true_name = "dwarf"
	desc = "Призывает нового карлика."
	cost = 300

/datum/ritual/summon_seeds
	name = "Призыв сеням"
	true_name = "seeds"
	desc = "Призывает полезные семена."
	cost = 150

/datum/ritual/summon_frog
	name = "Призвать лягушку"
	true_name = "frog"
	desc = "Ква."
	cost = 500

/datum/ritual/summon_tools
	name = "Призвать запасные инструменты"
	true_name = "tools"
	desc = "Не повезло!"
	cost = 800
