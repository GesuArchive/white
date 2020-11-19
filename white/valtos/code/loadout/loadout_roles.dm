/datum/gear/roles/mechanic
	display_name = "Механик"
	sort_category = "Роли"
	description = "Занимается исключительно улучшением всего и вся на станции. Имеет RPED с компонентами."
	cost = 500

/datum/gear/roles/purchase(client/C)
	C?.prefs?.jobs_buyed += src
	C?.prefs?.save_preferences()
