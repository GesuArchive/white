/mob/living/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	//Mind updates
	sync_mind()
	mind.show_memory(src, 0)

	//Round specific stuff
	if(SSticker.mode)
		switch(SSticker.mode.name)
			if("sandbox")
				CanBuild()

	update_damage_hud()
	update_health_hud()

	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

	//Vents
	var/ventcrawler = HAS_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS) || HAS_TRAIT(src, TRAIT_VENTCRAWLER_NUDE)
	if(ventcrawler)
		to_chat(src, span_notice("Есть возможность ползать по трубам! Используй alt+клик на вентиляции/вытяжке и попадёшь во внутрь."))

	var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
	if(changeling)
		changeling.regain_powers()

	var/datum/component/battletension/BT = GetComponent(/datum/component/battletension)
	if(BT)
		BT.pick_sound()
	med_hud_set_status()

	update_fov_client()

	if(SStts.tts_enabled)
		if(client?.prefs?.forced_voice)
			voice = client.prefs.forced_voice
		else
			voice = pick(GLOB.tts_voices)

/mob/living/carbon/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	if(HAS_TRAIT(src, TRAIT_CLIENT_LEAVED))
		REMOVE_TRAIT(src, TRAIT_CLIENT_LEAVED, "ice_cream")

		var/list/spawners = GLOB.mob_spawners[real_name]
		LAZYREMOVE(spawners, src)
		if(!LAZYLEN(spawners))
			GLOB.mob_spawners -= real_name
	else
		ice_cream_mob_time = client?.prefs?.ice_cream_time
		ice_cream_mob = client?.prefs?.ice_cream
