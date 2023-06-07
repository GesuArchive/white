/datum/action/cooldown/alien/hide
	name = "Спрятаться"
	desc = "Позволяет спрятаться под столами и некоторыми предметами."
	button_icon_state = "alien_hide"
	plasma_cost = 0
	/// The layer we are on while hiding
	var/hide_layer = ABOVE_NORMAL_TURF_LAYER

/datum/action/cooldown/alien/hide/Activate(atom/target)
	if(owner.layer == hide_layer)
		owner.layer = initial(owner.layer)
		owner.visible_message(
			span_notice("[owner] медленно поднимается..."),
			span_noticealien("Я больше не прячусь."),
		)

	else
		owner.layer = hide_layer
		owner.visible_message(
			span_name("[owner] приникает к земле!"),
			span_noticealien("Я прячусь."),
		)

	return TRUE

/datum/action/cooldown/alien/larva_evolve
	name = "Эволюционировать"
	desc = "Развиться в более совершенную особь."
	button_icon_state = "alien_evolve_larva"
	plasma_cost = 0

/datum/action/cooldown/alien/larva_evolve/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!islarva(owner))
		return FALSE

	var/mob/living/carbon/alien/larva/larva = owner
	if(larva.handcuffed || larva.legcuffed) // Cuffing larvas ? Eh ?
		return FALSE
	if(larva.amount_grown < larva.max_grown)
		return FALSE
	if(larva.movement_type & VENTCRAWLING)
		return FALSE

	return TRUE

/datum/action/cooldown/alien/larva_evolve/Activate(atom/target)
	var/mob/living/carbon/alien/larva/larva = owner
	var/static/list/caste_options
	if(!caste_options)
		caste_options = list()

		// This can probably be genericized in the future.
		var/mob/hunter_path = /mob/living/carbon/alien/humanoid/hunter
		var/datum/radial_menu_choice/hunter = new()
		hunter.name = "Охотник"
		hunter.image  = image(icon = initial(hunter_path.icon), icon_state = initial(hunter_path.icon_state))
		hunter.info = span_info("Это самый быстрый подвид, задачей которых является добыча новых инкубаторов. Они намного быстрее человека и могут прыгать, однако не намного сильнее дрона.")

		caste_options["Охотник"] = hunter

		var/mob/sentinel_path = /mob/living/carbon/alien/humanoid/sentinel
		var/datum/radial_menu_choice/sentinel = new()
		sentinel.name = "Страж"
		sentinel.image  = image(icon = initial(sentinel_path.icon), icon_state = initial(sentinel_path.icon_state))
		sentinel.info = span_info("Защитники улья. Более живучие и не такие быстрые как охотники, но способны скрываться в тенях и стрелять нейротоксичной слизью, после чего утаскивать бессознательную жертву в гнездо.")

		caste_options["Страж"] = sentinel

		var/mob/drone_path = /mob/living/carbon/alien/humanoid/drone
		var/datum/radial_menu_choice/drone = new()
		drone.name = "Трутень"
		drone.image  = image(icon = initial(drone_path.icon), icon_state = initial(drone_path.icon_state))
		drone.info = span_info("Являются самым слабым и медленным подвидом, однако могут вырасти сначала в преторианца, а затем и в королеву, если ее не существует на тот момент, так же они крайне важны за счет их способности выделять биполярную смолу для строительства и расширения улья.")

		caste_options["Трутень"] = drone

	var/alien_caste = show_radial_menu(owner, owner, caste_options, radius = 38, require_near = TRUE, tooltips = TRUE)
	if(QDELETED(src) || QDELETED(owner) || !IsAvailable() || isnull(alien_caste))
		return

	var/mob/living/carbon/alien/humanoid/new_xeno
	switch(alien_caste)
		if("Охотник")
			new_xeno = new /mob/living/carbon/alien/humanoid/hunter(larva.loc)
		if("Страж")
			new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(larva.loc)
		if("Трутень")
			new_xeno = new /mob/living/carbon/alien/humanoid/drone(larva.loc)
		else
			CRASH("Alien evolve was given an invalid / incorrect alien cast type. Got: [alien_caste]")

	larva.alien_evolve(new_xeno)
	return TRUE
