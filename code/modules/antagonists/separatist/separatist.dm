/datum/team/nation
	name = "Нация"

/datum/antagonist/separatist
	name = "Сепаратисты"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	var/datum/team/nation/nation
	greentext_reward = 20

/datum/antagonist/separatist/create_team(datum/team/nation/new_team)
	if(!new_team)
		return
	nation = new_team

/datum/antagonist/separatist/get_team()
	return nation

/datum/antagonist/separatist/greet()
	to_chat(owner, "<B>Ты сепаратист! [nation.name] вечна! Защищай суверенитет вашей новообретенной земли вместе с товарищами по оружию!</B>")
