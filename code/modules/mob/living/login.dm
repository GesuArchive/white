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
	if(ventcrawler)
		to_chat(src, "<span class='notice'>Есть возможность ползать по трубам! Используй alt+клик на вентиляции/вытяжке и попадёшь во внутрь.</span>")

	if(ranged_ability)
		ranged_ability.add_ranged_ability(src, "<span class='notice'>Имею <b>[ranged_ability]</b> активной!</span>")

	var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
	if(changeling)
		changeling.regain_powers()

	var/datum/component/battletension/BT = GetComponent(/datum/component/battletension)
	if(BT)
		BT.pick_sound()
	med_hud_set_status()
