/datum/disease/cumvirus
	name = "Cum Virus"
	max_stages = 5
	spread_text = "On contact"
	cure_text = "Галоперидол & Святая вода"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cures = list(/datum/reagent/medicine/haloperidol,/datum/reagent/water/holywater)
	cure_chance = 7.5
	agent = "Cumthiris+61"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Симптомы заставляют зараженный субъект непроизвольно эякулировать."
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	permeability_mod = 1
	severity = DISEASE_SEVERITY_BIOHAZARD

/datum/disease/cumvirus/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return
	switch(stage)
		if(2)
			if(DT_PROB(5, delta_time))
				affected_mob.emote("cough")
		if(3)
			if(DT_PROB(5, delta_time))
				affected_mob.emote("moan")
			if(DT_PROB(10, delta_time))
				to_chat(affected_mob, "<span class='danger'>Ты чувствуешь себя возбужденным.</span>")
		if(4)
			to_chat(affected_mob, "<span class='userdanger'>Ты чувствуешь очень сильное напряжение в своем половом органе!</span>")
			if(DT_PROB(40, delta_time))
				affected_mob.emote("moan")
				affected_mob.cum()
				affected_mob.adjustStaminaLoss(3.5, FALSE)
				affected_mob.adjustOxyLoss(1.5, FALSE)
				shake_camera(affected_mob, 1, 1)
			if(DT_PROB(20, delta_time))
				to_chat(affected_mob, "<span class='danger'>Ты чувствуешь себя ОЧЕНЬ возбужденным.</span>")
		if(5)
			to_chat(affected_mob, "<span class='userdanger'>Ты непроизвольно кончаешь!</span>")
			if(DT_PROB(30, delta_time))
				affected_mob.emote("moan")
				affected_mob.cum()
				affected_mob.adjustStaminaLoss(10, FALSE)
				affected_mob.adjustOxyLoss(5, FALSE)
				shake_camera(affected_mob, 1, 2)
			if(DT_PROB(20, delta_time))
				affected_mob.emote("choke")
				affected_mob.cum()
				affected_mob.Paralyze(40)
				affected_mob.add_confusion(8)
				shake_camera(affected_mob, 2, 3)
				affected_mob.overlay_fullscreen("flash", /atom/movable/screen/fullscreen/flash)
				affected_mob.clear_fullscreen("flash", 4.5)
