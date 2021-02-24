
/datum/gear/roles
	sort_category = "Роли"
	var/job_path = null

/datum/gear/roles/purchase(client/C)
	C?.prefs?.jobs_buyed += job_path
	C?.prefs?.save_preferences()
	return TRUE

/datum/gear/roles/mechanic
	display_name = "Механик"
	description = "Занимается исключительно улучшением всего и вся на станции. Имеет RPED с компонентами."
	cost = 500
	job_path = /datum/job/engineer/mechanic

/datum/gear/roles/bomj
	display_name = "Бомж"
	description = "Просто бомж."
	cost = 5
	job_path = /datum/job/bomj
