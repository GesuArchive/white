/datum/disease/magnitis
	name = "Магнитис"
	max_stages = 4
	spread_text = "Воздушное"
	cure_text = "Железо"
	cures = list(/datum/reagent/iron)
	agent = "Фуккос Миракос"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	spreading_modifier = 0.75
	desc = "Эта болезнь нарушает магнитное поле тела, заставляя его действовать как мощный магнит. Инъекции железа помогают стабилизировать поле зрения."
	severity = DISEASE_SEVERITY_MEDIUM
	infectable_biotypes = MOB_ORGANIC|MOB_ROBOTIC
	process_dead = TRUE


/datum/disease/magnitis/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю удар током всем своим телом."))
			if(DT_PROB(1, delta_time))
				for(var/obj/nearby_object in orange(2, affected_mob))
					if(nearby_object.anchored || !(nearby_object.flags_1 & CONDUCT_1))
						continue
					var/move_dir = get_dir(nearby_object, affected_mob)
					nearby_object.Move(get_step(nearby_object, move_dir), move_dir)
				for(var/mob/living/silicon/nearby_silicon in orange(2, affected_mob))
					if(isAI(nearby_silicon))
						continue
					var/move_dir = get_dir(nearby_silicon, affected_mob)
					nearby_silicon.Move(get_step(nearby_silicon, move_dir), move_dir)
		if(3)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю удар током всем своим телом."))
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю себя как клоуна."))
			if(DT_PROB(2, delta_time))
				for(var/obj/nearby_object in orange(4, affected_mob))
					if(nearby_object.anchored || !(nearby_object.flags_1 & CONDUCT_1))
						continue
					for(var/i in 1 to rand(1, 2))
						var/move_dir = get_dir(nearby_object, affected_mob)
						if(!nearby_object.Move(get_step(nearby_object, move_dir), move_dir))
							break
				for(var/mob/living/silicon/nearby_silicon in orange(4, affected_mob))
					if(isAI(nearby_silicon))
						continue
					for(var/i in 1 to rand(1, 2))
						var/move_dir = get_dir(nearby_silicon, affected_mob)
						if(!nearby_silicon.Move(get_step(nearby_silicon, move_dir), move_dir))
							break
		if(4)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю сильный удар током всем своим телом."))
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Природа чудесная."))
			if(DT_PROB(4, delta_time))
				for(var/obj/nearby_object in orange(6, affected_mob))
					if(nearby_object.anchored || !(nearby_object.flags_1 & CONDUCT_1))
						continue
					for(var/i in 1 to rand(1, 3))
						var/move_dir = get_dir(nearby_object, affected_mob)
						if(!nearby_object.Move(get_step(nearby_object, move_dir), move_dir))
							break
				for(var/mob/living/silicon/nearby_silicon in orange(6, affected_mob))
					if(isAI(nearby_silicon))
						continue
					for(var/i in 1 to rand(1, 3))
						var/move_dir = get_dir(nearby_silicon, affected_mob)
						if(!nearby_silicon.Move(get_step(nearby_silicon, move_dir), move_dir))
							break
