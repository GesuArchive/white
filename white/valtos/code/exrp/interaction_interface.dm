/mob/proc/try_interaction()
	return

/mob/living/MouseDrop_T(mob/M as mob, mob/user as mob)
	. = ..()
	if(M == src || src == usr || M != usr)
		return
	if(HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	user.try_interaction(src)

/mob/living/try_interaction(var/mob/partner)

	if (!check_rights_for(client, R_ADMIN) && !check_whitelist_exrp(ckey))
		return

	var/dat = "<B><HR><FONT size=3>Взаимодействие с [partner].</FONT></B><HR>"

	make_interactions()
	for(var/interaction_key in GLOB.interactions)
		var/datum/interaction/I = GLOB.interactions[interaction_key]
		if(I.evaluate_user(src) && I.evaluate_target(src, partner))
			dat += I.get_action_link_for(src, partner)

	var/datum/browser/popup = new(usr, "interactions", "Взаимодействие", 340, 380)
	popup.set_content(dat)
	popup.open()
