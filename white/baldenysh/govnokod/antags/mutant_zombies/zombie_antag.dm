/datum/antagonist/mutant_zombie
	name = "Зомби"
	roundend_category = "Зомби"
	silent = TRUE
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	var/datum/team/mutant_zombies/zombs

/datum/antagonist/mutant_zombie/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_hud(M)

/datum/antagonist/mutant_zombie/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_hud(M)

/datum/antagonist/mutant_zombie/proc/add_hud(mob/living/zombie, icontype="zed")
	zombs?.kostil_hud.join_hud(zombie)
	set_antag_hud(zombie, icontype) // Located in icons/mob/hud.dmi

/datum/antagonist/mutant_zombie/proc/remove_hud(mob/living/zombie)
	zombs?.kostil_hud.leave_hud(zombie)
	set_antag_hud(zombie, null)

///////////////////////////////////////////////////////////////команда

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

/datum/team/mutant_zombies
	var/datum/atom_hud/antag/hidden/kostil_hud = new


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
