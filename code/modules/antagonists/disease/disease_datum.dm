/datum/antagonist/disease
	name = "Разумная Болезнь"
	roundend_category = "diseases"
	antagpanel_category = "Disease"
	show_to_ghosts = TRUE
	var/disease_name = ""
	greentext_reward = 30

/datum/antagonist/disease/on_gain()
	owner.special_role = "Разумная Болезнь"
	owner.assigned_role = "Разумная Болезнь"
	var/datum/objective/O = new /datum/objective/disease_infect()
	O.owner = owner
	objectives += O

	O = new /datum/objective/disease_infect_centcom()
	O.owner = owner
	objectives += O

	. = ..()

/datum/antagonist/disease/greet()
	to_chat(owner.current, span_notice("Вы [owner.special_role]!"))
	to_chat(owner.current, span_notice("Заражайте членов экипажа, чтобы получить очки адаптации и распространите инфекцию по станции."))
	owner.announce_objectives()

/datum/antagonist/disease/apply_innate_effects(mob/living/mob_override)
	if(!istype(owner.current, /mob/camera/disease))
		var/turf/T = get_turf(owner.current)
		T = T ? T : SSmapping.get_station_center()
		var/mob/camera/disease/D = new /mob/camera/disease(T)
		owner.transfer_to(D)

/datum/antagonist/disease/admin_add(datum/mind/new_owner,mob/admin)
	..()
	var/mob/camera/disease/D = new_owner.current
	D.pick_name()

/datum/antagonist/disease/roundend_report()
	var/list/result = list()

	result += "<b>Disease name:</b> [disease_name]"
	result += printplayer(owner)

	var/win = TRUE
	var/objectives_text = ""
	var/count = 1
	for(var/datum/objective/objective in objectives)
		if(objective.check_completion())
			objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <span class='greentext'>Success!</span>"
		else
			objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <span class='redtext'>Fail.</span>"
			win = FALSE
		count++

	result += objectives_text

	var/special_role_text = lowertext(name)

	if(win)
		result += span_greentext("[special_role_text] успешена!")
	else
		result += span_redtext("[special_role_text] провалена...")

	if(istype(owner.current, /mob/camera/disease))
		var/mob/camera/disease/D = owner.current
		result += "<B>[disease_name] завершил раунд с [D.hosts.len] заражёнными и с пиковым уровнем заражения в [D.total_points] больных.</B>"
		result += "<B>[disease_name] завершил раунд со следующими мутациями:</B>"
		var/list/adaptations = list()
		for(var/V in D.purchased_abilities)
			var/datum/disease_ability/A = V
			adaptations += A.name
		result += adaptations.Join(", ")

	return result.Join("<br>")


/datum/objective/disease_infect
	explanation_text = "Выжить и заразить как можно больше людей."

/datum/objective/disease_infect/check_completion()
	var/mob/camera/disease/D = owner.current
	if(istype(D) && D.hosts.len) //theoretically it should not exist if it has no hosts, but better safe than sorry.
		return TRUE
	return FALSE


/datum/objective/disease_infect_centcom
	explanation_text = "Хотя бы один зараженный член экипажа должен сбежать на шаттле или в спасательной капсуле."

/datum/objective/disease_infect_centcom/check_completion()
	var/mob/camera/disease/D = owner.current
	if(!istype(D))
		return FALSE
	for(var/V in D.hosts)
		var/mob/living/L = V
		if(L.onCentCom() || L.onSyndieBase())
			return TRUE
	return FALSE
