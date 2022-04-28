/obj/effect/proc_holder/alien/hide
	name = "Спрятаться"
	desc = "Позволяет спрятаться под столами и некоторыми предметами."
	plasma_cost = 0

	action_icon_state = "alien_hide"

/obj/effect/proc_holder/alien/hide/fire(mob/living/carbon/alien/user)
	if(user.stat != CONSCIOUS)
		return

	if (user.layer != ABOVE_NORMAL_TURF_LAYER)
		user.plane = GAME_PLANE
		user.layer = ABOVE_NORMAL_TURF_LAYER
		user.visible_message(span_name("[user] приникает к земле!") , \
						span_noticealien("Я прячусь."))
	else
		user.plane = GAME_PLANE_FOV_HIDDEN
		user.layer = MOB_LAYER
		user.visible_message(span_notice("[user] медленно поднимается...") , \
					span_noticealien("Я больше не прячусь."))
	return 1


/obj/effect/proc_holder/alien/larva_evolve
	name = "Эволюционировать"
	desc = "Развиться в более совершенную особь."
	plasma_cost = 0

	action_icon_state = "alien_evolve_larva"

/obj/effect/proc_holder/alien/larva_evolve/fire(mob/living/carbon/alien/user)
	if(!islarva(user))
		return
	var/mob/living/carbon/alien/larva/L = user

	if(L.handcuffed || L.legcuffed) // Cuffing larvas ? Eh ?
		to_chat(user, span_warning("У меня не получится сделать это в заточении!"))
		return

	if(L.amount_grown >= L.max_grown) //TODO ~Carn
		to_chat(L, span_name("Вы накопили достаточно сил для дальнейшей эволюции, настало время выбирать свой путь."))
		to_chat(L, span_info("На данный момент вы можете выбрать из:"))
		to_chat(L, span_name("Охотники</span> <span class='info'>это самый быстрый подвид, задачей которых является добыча новых инкубаторов. Они намного быстрее человека и могут прыгать, однако не намного сильнее дрона."))
		to_chat(L, span_name("Стражи</span> <span class='info'>защитники улья. Более живучие и не такие быстрые как охотники, но способны скрываться в тенях и стрелять нейротоксичной слизью, после чего утаскивать бессознательную жертву в гнездо."))
		to_chat(L, span_name("Трутни</span> <span class='info'>являются самым слабым и медленным подвидом, однако могут вырасти сначала в преторианца, а затем и в королеву, если ее не существует на тот момент, так же они крайне важны за счет их способности выделять биполярную смолу для строительства и расширения улья."))
		var/alien_caste = tgui_alert(L, "Выберите путь для дальнейшей эволюции.",,list("Охотник","Страж","Трутень"))

		if(L.movement_type & VENTCRAWLING)
			to_chat(user, span_warning("Для начала нужно выбраться на поверхность!"))
			return

		if(user.incapacitated()) //something happened to us while we were choosing.
			return

		var/mob/living/carbon/alien/humanoid/new_xeno
		switch(alien_caste)
			if("Охотник")
				new_xeno = new /mob/living/carbon/alien/humanoid/hunter(L.loc)
			if("Страж")
				new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(L.loc)
			if("Трутень")
				new_xeno = new /mob/living/carbon/alien/humanoid/drone(L.loc)

		L.alien_evolve(new_xeno)
		return
	else
		to_chat(user, span_warning("Я еще слишком мал для дальнейшей эволюции!"))
		return
