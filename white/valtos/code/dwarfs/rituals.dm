/datum/ritual
	var/name = "ritual"
	var/true_name = "basetirual" // to identify ritual in dwarf altar.perform_rite()
	var/desc = "govno"
	var/cost = 0

/datum/ritual/summon_seeds
	name = "Ритуал земли"
	true_name = "seeds"
	desc = "Призывает полезные семена."
	cost = 150

/datum/ritual/summon_dwarf
	name = "Ритуал митозиса"
	true_name = "dwarf"
	desc = "Призывает нового раба Армока."
	cost = 300

/datum/ritual/summon_frog
	name = "Ритуал ква"
	true_name = "frog"
	desc = "Ква."
	cost = 500

/datum/ritual/summon_tools
	name = "Ритуал Грунгни"
	true_name = "tools"
	desc = "Во имя металла!"
	cost = 800
