/datum/antagonist/slaughter
	name = "Демон бойни"
	show_name_in_check_antagonists = TRUE
	var/objective_verb = "Kill"
	var/datum/mind/summoner
	job_rank = ROLE_ALIEN
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	greentext_reward = 40

/datum/antagonist/slaughter/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/slaughter/greet()
	. = ..()
	owner.announce_objectives()
	to_chat(owner, span_warning("У тебя есть мощная альтернативная атака, которая отбрасывает людей. Ты можешь активировать её используя shift+ctrl+лкм по цели!"))

/datum/antagonist/slaughter/proc/forge_objectives()
	if(summoner)
		var/datum/objective/assassinate/new_objective = new /datum/objective/assassinate
		new_objective.owner = owner
		new_objective.target = summoner
		new_objective.explanation_text = "[objective_verb] [summoner.name], the one who summoned you."
		objectives += new_objective
	var/datum/objective/new_objective2 = new /datum/objective
	new_objective2.owner = owner
	new_objective2.explanation_text = "[objective_verb] everyone[summoner ? " else while you're at it":""]."
	objectives += new_objective2

/datum/antagonist/slaughter/laughter
	name = "Демон смеха"
	objective_verb = "Hug and Tickle"
	greentext_reward = 35
