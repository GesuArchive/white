//////////////////Imp

/mob/living/simple_animal/hostile/imp
	name = "Имп"
	real_name = "imp"
	unique_name = TRUE
	desc = "Крупное страшное, мерзкое существо, покрытое угольно-чёрной крепкой чешуей."
	speak_emote = list("кудахчет")
	emote_hear = list("кудахчет","визжит")
	response_help_continuous = "прикасается"
	response_help_simple = "прикасается"
	response_disarm_continuous = "цепляется"
	response_disarm_simple = "цепляется"
	response_harm_continuous = "бьёт"
	response_harm_simple = "бьёт"
	icon = 'icons/mob/mob.dmi'
	icon_state = "imp"
	icon_living = "imp"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speed = 1
	a_intent = INTENT_HARM
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	attack_sound = 'sound/magic/demon_attack1.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 250 //Weak to cold
	maxbodytemp = INFINITY
	faction = list("hell")
	attack_verb_continuous = "яростно разрывает"
	attack_verb_simple = "яростно разрывает"
	maxHealth = 200
	health = 200
	healable = 0
	obj_damage = 40
	melee_damage_lower = 10
	melee_damage_upper = 15
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	del_on_death = TRUE
	deathmessage = "издаёт ужасный рёв, когда он распадается на серый дым."
	deathsound = 'sound/magic/demon_dies.ogg'
	var/playstyle_string = "<span class='big bold'>Ты Имп,</span><B> ужасное исчадие из ада. У тебя самый низкий ранг в аду \
							Хотя вы и не обязаны помогать, возможно, помогая дьяволу более высокого ранга, вы могли бы запросто получить повышение. Хотя вы не способны	\
							умышленно причинить вред другому дьяволу.</B>"
	discovery_points = 10000

/datum/antagonist/imp
	name = "Имп"
	antagpanel_category = "Devil"
	show_in_roundend = FALSE
	greentext_reward = 5

/datum/antagonist/imp/on_gain()
	. = ..()
	give_objectives()

/datum/antagonist/imp/proc/give_objectives()
	var/datum/objective/newobjective = new
	newobjective.explanation_text = "Хочу повышение! Мне надо выслужиться! И я буду самым главным! Все-все будет моим!"
	newobjective.owner = owner
	objectives += newobjective
