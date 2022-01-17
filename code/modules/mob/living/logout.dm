/mob/living/Logout()
	update_z(null)
	..()
	if(!key && mind)	//key and mind have become separated.
		mind.active = FALSE	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.
	med_hud_set_status()

/mob/living/carbon/Logout()
	. = ..()
	if(ice_cream_mob && !isbrain(src))
		addtimer(CALLBACK(src, .proc/ice_cream_check), ice_cream_mob_time)

/mob/living/carbon/proc/ice_cream_check()
	if(!src || client || stat == DEAD)
		return
	ADD_TRAIT(src, TRAIT_CLIENT_LEAVED, "ice_cream")
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("Здесь есть свободное тело персонажа [real_name] в зоне [A.name].", source = src, action=NOTIFY_ORBIT, flashwindow = FALSE, ignore_key = POLL_IGNORE_SPLITPERSONALITY, notify_suiciders = FALSE)
	AddElement(/datum/element/point_of_interest)

