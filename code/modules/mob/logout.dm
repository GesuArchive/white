/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	log_message("[key_name(src)] is no longer owning mob [src]([src.type])", LOG_OWNERSHIP)
	SStgui.on_logout(src)
	unset_machine()
	remove_from_player_list()
	if(client?.movingmob) //In the case the client was transferred to another mob and not deleted.
		client.movingmob.client_mobs_in_contents -= src
		UNSETEMPTY(client.movingmob.client_mobs_in_contents)
		client.movingmob = null

	if(client?.prefs?.ice_cream)
		addtimer(CALLBACK(src, .proc/ice_cream_check), client?.prefs?.ice_cream_time)

	..()

	if(loc)
		loc.on_log(FALSE)

	if(client)
		for(var/foo in client.player_details.post_logout_callbacks)
			var/datum/callback/CB = foo
			CB.Invoke()

	return TRUE

/mob/proc/ice_cream_check()
	if(!src || client || !isliving(src))
		return
	ADD_TRAIT(src, TRAIT_CLIENT_LEAVED, "ice_cream")
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("Здесь есть свободное тело персонажа [real_name] в зоне [A.name].", source = src, action=NOTIFY_ORBIT, flashwindow = FALSE, ignore_key = POLL_IGNORE_SPLITPERSONALITY, notify_suiciders = FALSE)
	AddElement(/datum/element/point_of_interest)
