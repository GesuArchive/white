GLOBAL_DATUM_INIT(AI_track_menu, /datum/ai_track_menu, new)

/datum/ai_track_menu
	var/list/humans = list()
	var/list/others = list()

/datum/ai_track_menu/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/datum/ai_track_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AI_Tracking")
		ui.open()

/datum/ai_track_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	switch(action)
		if("follow")
			var/target_name = params["target_name"]

			if(isnull(target_name))
				return FALSE

			if(istype(usr, /mob/living/silicon/robot/shell))
				var/mob/living/silicon/robot/shell/S = usr
				S.ai_camera_track(target_name)
			else
				var/mob/living/silicon/ai/AI = usr
				AI.ai_camera_track(target_name)

			return TRUE

/datum/ai_track_menu/ui_data(mob/user)
	var/list/data = list()

	update_targets_list(user)

	data["humans"] = humans
	data["others"] = others

	return data

/datum/ai_track_menu/proc/update_targets_list(mob/user)
	var/mob/living/silicon/ai/AI
	if(istype(user, /mob/living/silicon/robot/shell))
		var/mob/living/silicon/robot/shell/S = user
		AI = S.mainframe
	else
		AI = user

	humans.Cut()
	others.Cut()

	AI.trackable_mobs(user) // actually update /datum/trackable

	for(var/name in AI.track.humans)
		var/list/serialized = list()

		serialized["name"] = name
		humans += list(serialized)

	for(var/name in AI.track.others)
		var/list/serialized = list()

		serialized["name"] = name
		others += list(serialized)

/// Shows the UI to the specified user.
/datum/ai_track_menu/proc/show(mob/user)
	ui_interact(user)
