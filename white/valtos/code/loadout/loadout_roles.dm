
/datum/gear/roles
	var/job_path = null

/datum/gear/roles/purchase(client/C)
	C?.prefs?.jobs_buyed += job_path
	C?.prefs?.save_preferences()

/datum/gear/roles/mechanic
	display_name = "Механик"
	sort_category = "Роли"
	description = "Занимается исключительно улучшением всего и вся на станции. Имеет RPED с компонентами."
	cost = 500
	job_path = /datum/job/engineer/mechanic
