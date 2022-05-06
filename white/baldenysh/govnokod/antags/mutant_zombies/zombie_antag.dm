/datum/antagonist/mutant_zombie
	name = "Зомби"
	roundend_category = "Зомби"
	silent = TRUE
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	var/datum/team/mutant_zombies/zombs
	greentext_reward = 5

/datum/antagonist/mutant_zombie/get_team()
	return zombs

/datum/antagonist/mutant_zombie/create_team(datum/team/mutant_zombies/new_team)
	if(!new_team)
		for(var/datum/antagonist/mutant_zombie/Z in GLOB.antagonists)
			if(!Z.owner)
				continue
			if(Z.zombs)
				zombs = Z.zombs
				return
		zombs = new /datum/team/mutant_zombies
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	zombs = new_team

///////////////////////////////////////////////////////////////команда

/datum/team/mutant_zombies
	name = "Зомби"
	var/datum/atom_hud/alternate_appearance/basic/zombies_hud = new
	var/datum/atom_hud/alternate_appearance/infected_hud = new

/datum/team/mutant_zombies/proc/add_zombie_to_hud(mob/living/carbon/C)
	var/image/holder = C.hud_list[ANTAG_HUD]
	holder.icon_state = "zed"
	zombies_hud.add_atom_to_hud(C)

	zombies_hud.show_to(C)
	infected_hud.show_to(C)

/datum/team/mutant_zombies/proc/remove_zombie_from_hud(mob/living/carbon/C)
	var/image/holder = C.hud_list[ANTAG_HUD]
	holder.icon_state = null
	zombies_hud.remove_atom_from_hud(C)

	zombies_hud.hide_from(C)
	infected_hud.hide_from(C)

/datum/team/mutant_zombies/proc/add_infected_to_hud(mob/living/carbon/C)
	var/image/holder = C.hud_list[ANTAG_HUD]
	holder.icon_state = "infected"
	infected_hud.add_atom_to_hud(C)

/datum/team/mutant_zombies/proc/remove_infected_from_hud(mob/living/carbon/C)
	var/image/holder = C.hud_list[ANTAG_HUD]
	holder.icon_state = null
	infected_hud.remove_atom_from_hud(C)


/*
/datum/team/mutant_zombie/roundend_report() //shows the number of fugitives, but not if they won in case there is no security
	var/list/fugitives = list()
	for(var/datum/antagonist/fugitive/fugitive_antag in GLOB.antagonists)
		if(!fugitive_antag.owner)
			continue
		fugitives += fugitive_antag
	if(!fugitives.len)
		return

	var/list/result = list()

	result += "<div class='panel redborder'><B>[fugitives.len]</B> [fugitives.len == 1 ? "fugitive" : "fugitives"] took refuge on [station_name()]!"

	for(var/datum/antagonist/fugitive/antag in fugitives)
		if(antag.owner)
			result += "<b>[printplayer(antag.owner)]</b>"

	return result.Join("<br>")
*/
