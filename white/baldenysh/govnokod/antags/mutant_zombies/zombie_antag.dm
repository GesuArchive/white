/datum/antagonist/mutant_zombie
	name = "Зомби"
	roundend_category = "Зомби"
	silent = TRUE
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	antag_hud_type = ANTAG_HUD_FUGITIVE ////ааааааааааааааа
	antag_hud_name = "fugitive_hunter" ////ааааааааааааааа

/datum/antagonist/mutant_zombie/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)

/datum/antagonist/mutant_zombie/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)

/*
/datum/antagonist/shizoid/proc/forge_objectives()
	var/datum/objective/escape/escape = new
	escape.owner = owner
	objectives += escape

/datum/antagonist/shizoid/on_gain()
	forge_objectives()
	. = ..()
*/
