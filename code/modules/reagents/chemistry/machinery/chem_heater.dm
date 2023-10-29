///Tutorial states
#define TUT_NO_BUFFER 50
#define TUT_START 1
#define TUT_HAS_REAGENTS 2
#define TUT_IS_ACTIVE 3
#define TUT_IS_REACTING 4
#define TUT_FAIL 4.5
#define TUT_COMPLETE 5
#define TUT_MISSING 10

/obj/machinery/chem_heater
	name = "Реакционная камера"
	desc = "Миниатюрная термомашина способная быстро изменять и удерживать температуру состава, а так же мануально контролировать баланс ПШ."
	density = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.4
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_heater

	var/obj/item/reagent_containers/beaker = null
	var/target_temperature = 300
	var/heater_coefficient = 0.05
	var/on = FALSE
	var/dispense_volume = 1
	//The list of active clients using this heater, so that we can update the UI on a reaction_step. I assume there are multiple clients possible.
	var/list/ui_client_list
	///If the user has the tutorial enabled
	var/tutorial_active = FALSE
	///What state we're at in the tutorial
	var/tutorial_state = 0

/obj/machinery/chem_heater/Initialize(mapload)
	. = ..()
	create_reagents(200, NO_REACT)//Lets save some calculations here
	reagents.add_reagent(/datum/reagent/reaction_agent/basic_buffer, 20)
	reagents.add_reagent(/datum/reagent/reaction_agent/acidic_buffer, 20)
	//TODO: comsig reaction_start and reaction_end to enable/disable the UI autoupdater - this doesn't work presently as there's a hard divide between instant and processed reactions

/obj/machinery/chem_heater/deconstruct(disassembled)
	. = ..()
	if(beaker && disassembled)
		UnregisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP)
		beaker.forceMove(drop_location())
		beaker = null

/obj/machinery/chem_heater/Destroy()
	if(beaker)
		UnregisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP)
		QDEL_NULL(beaker)
	return ..()

/obj/machinery/chem_heater/handle_atom_del(atom/A)
	. = ..()
	if(A == beaker)
		beaker = null
		update_icon()

/obj/machinery/chem_heater/update_icon_state()
	. = ..()
	if(beaker)
		icon_state = "mixer1b"
	else
		icon_state = "mixer0b"

/obj/machinery/chem_heater/AltClick(mob/living/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	replace_beaker(user)

/obj/machinery/chem_heater/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		UnregisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
		RegisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP, PROC_REF(on_reaction_step))
	update_icon()
	return TRUE

/obj/machinery/chem_heater/RefreshParts()
	. = ..()
	heater_coefficient = 0.1
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		heater_coefficient *= M.rating

/obj/machinery/chem_heater/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<hr><span class='notice'>Дисплей: Скорость нагревательных реагентов на <b>[heater_coefficient*1000]%</b>.</span>"

/obj/machinery/chem_heater/process(delta_time)
	..()
	//Tutorial logics
	if(tutorial_active)
		switch(tutorial_state)
			if(TUT_NO_BUFFER)
				if(reagents.has_reagent(/datum/reagent/reaction_agent/basic_buffer, 5) && reagents.has_reagent(/datum/reagent/reaction_agent/acidic_buffer, 5))
					tutorial_state = TUT_START

			if(TUT_START)
				if(!reagents.has_reagent(/datum/reagent/reaction_agent/basic_buffer, 5) || !reagents.has_reagent(/datum/reagent/reaction_agent/acidic_buffer, 5))
					tutorial_state = TUT_NO_BUFFER
					return
				if(beaker?.reagents.has_reagent(/datum/reagent/mercury, 10) || beaker?.reagents.has_reagent(/datum/reagent/chlorine, 10))
					tutorial_state = TUT_HAS_REAGENTS
			if(TUT_HAS_REAGENTS)
				if(!(beaker?.reagents.has_reagent(/datum/reagent/mercury, 9)) || !(beaker?.reagents.has_reagent(/datum/reagent/chlorine, 9)))
					tutorial_state = TUT_MISSING
					return
				if(beaker?.reagents.chem_temp > 374)//If they heated it up as asked
					tutorial_state = TUT_IS_ACTIVE
					target_temperature = 375
					beaker.reagents.chem_temp = 375

			if(TUT_IS_ACTIVE)
				if(!(beaker?.reagents.has_reagent(/datum/reagent/mercury)) || !(beaker?.reagents.has_reagent(/datum/reagent/chlorine))) //Slightly concerned that people might take ages to read and it'll react anyways
					tutorial_state = TUT_MISSING
					return
				if(length(beaker?.reagents.reaction_list) == 1)//Only fudge numbers for our intentful reaction
					beaker.reagents.chem_temp = 375

				if(target_temperature >= 390)
					tutorial_state = TUT_IS_REACTING

			if(TUT_IS_REACTING)
				if(!(beaker?.reagents.has_reagent(/datum/reagent/mercury)) || !(beaker?.reagents.has_reagent(/datum/reagent/chlorine)))
					tutorial_state = TUT_COMPLETE

			if(TUT_COMPLETE)
				if(beaker?.reagents.has_reagent(/datum/reagent/consumable/failed_reaction))
					tutorial_state = TUT_FAIL
					return
				if(!beaker?.reagents.has_reagent(/datum/reagent/medicine/calomel))
					tutorial_state = TUT_MISSING

	if(machine_stat & NOPOWER)
		return
	if(on)
		if(beaker?.reagents.total_volume)
			if(beaker.reagents.is_reacting)//on_reaction_step() handles this
				return
			//keep constant with the chemical acclimator please
			beaker.reagents.adjust_thermal_energy((target_temperature - beaker.reagents.chem_temp) * heater_coefficient * delta_time * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume)
			beaker.reagents.handle_reactions()

			use_power(active_power_usage * delta_time)

/obj/machinery/chem_heater/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mixer0b", "mixer0b", I))
		return

	if(default_deconstruction_crowbar(I))
		return

	if(default_unfasten_wrench(user, I))
		return

	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, span_notice("Добавил [B] к [src]."))
		updateUsrDialog()
		update_icon()
		return

	if(beaker)
		if(istype(I, /obj/item/reagent_containers/dropper))
			var/obj/item/reagent_containers/dropper/D = I
			D.afterattack(beaker, user, 1)
			return
		if(istype(I, /obj/item/reagent_containers/syringe))
			var/obj/item/reagent_containers/syringe/S = I
			S.afterattack(beaker, user, 1)
			return
	return ..()

/obj/machinery/chem_heater/on_deconstruction()
	replace_beaker()
	return ..()

///Forces a UI update every time a reaction step happens inside of the beaker it contains. This is so the UI is in sync with the reaction since it's important that the output matches the current conditions for pH adjustment and temperature.
/obj/machinery/chem_heater/proc/on_reaction_step(datum/reagents/holder, num_reactions, delta_time)
	SIGNAL_HANDLER
	if(on)
		holder.adjust_thermal_energy((target_temperature - beaker.reagents.chem_temp) * heater_coefficient * delta_time * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume * (rand(8,11) * 0.1))//Give it a little wiggle room since we're actively reacting
	for(var/ui_client in ui_client_list)
		var/datum/tgui/ui = ui_client
		if(!ui)
			stack_trace("Warning: UI in UI client list is missing in [src] (chem_heater)")
			remove_ui_client_list(ui)
			continue
		ui.send_update()

/obj/machinery/chem_heater/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemHeater", name)
		ui.open()
		add_ui_client_list(ui)

/obj/machinery/chem_heater/ui_close(mob/user, datum/tgui/tgui)
	for(var/ui_client in ui_client_list)
		var/datum/tgui/ui = ui_client
		if(ui.user == user)
			remove_ui_client_list(ui)
	return ..()

/*
*This adds an open ui client to the list - so that it can be force updated from reaction mechanisms.
* After adding it to the list, it enables a signal incase the ui is deleted - which will call a method to remove it from the list
* This is mostly to ensure we don't have defunct ui instances stored from any condition.
*/
/obj/machinery/chem_heater/proc/add_ui_client_list(new_ui)
	LAZYADD(ui_client_list, new_ui)
	RegisterSignal(new_ui, COMSIG_PARENT_QDELETING, PROC_REF(on_ui_deletion))

///This removes an open ui instance from the ui list and deregsiters the signal
/obj/machinery/chem_heater/proc/remove_ui_client_list(old_ui)
	UnregisterSignal(old_ui, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(ui_client_list, old_ui)

///This catches a signal and uses it to delete the ui instance from the list
/obj/machinery/chem_heater/proc/on_ui_deletion(datum/tgui/source, force)
	SIGNAL_HANDLER
	remove_ui_client_list(source)

/obj/machinery/chem_heater/ui_assets()
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/tutorial_advisors)

/obj/machinery/chem_heater/ui_data(mob/user)
	var/data = list()
	data["targetTemp"] = target_temperature
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? 1 : 0

	data["currentTemp"] = beaker ? beaker.reagents.chem_temp : null
	data["beakerCurrentVolume"] = beaker ? round(beaker.reagents.total_volume, 0.01) : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	data["currentpH"] = beaker ? round(beaker.reagents.ph, 0.01)  : null
	var/upgrade_level = heater_coefficient*10
	data["upgradeLevel"] = upgrade_level

	var/list/beaker_contents = list()
	for(var/r in beaker?.reagents.reagent_list)
		var/datum/reagent/reagent = r
		beaker_contents.len++
		beaker_contents[length(beaker_contents)] = list("name" = reagent.name, "volume" = round(reagent.volume, 0.01))
	data["beakerContents"] = beaker_contents

	var/list/active_reactions = list()
	var/flashing = DISABLE_FLASHING //for use with alertAfter - since there is no alertBefore, I set the after to 0 if true, or to the max value if false
	for(var/_reaction in beaker?.reagents.reaction_list)
		var/datum/equilibrium/equilibrium = _reaction
		if(!length(beaker.reagents.reaction_list))//I'm not sure why when it explodes it causes the gui to fail (it's missing danger (?) )
			stack_trace("how is this happening??")
			continue
		if(!equilibrium.reaction.results)//Incase of no result reactions
			continue
		var/_reagent = equilibrium.reaction.results[1]
		var/datum/reagent/reagent = beaker?.reagents.get_reagent(_reagent) //Reactions are named after their primary products
		if(!reagent)
			continue
		var/overheat = FALSE
		var/danger = FALSE
		var/purity_alert = 2 //same as flashing
		if(reagent.purity < equilibrium.reaction.purity_min)
			purity_alert = ENABLE_FLASHING//Because 0 is seen as null
			danger = TRUE
		if(!(flashing == ENABLE_FLASHING))//So that the pH meter flashes for ANY reactions out of optimal
			if(equilibrium.reaction.optimal_ph_min > beaker?.reagents.ph || equilibrium.reaction.optimal_ph_max < beaker?.reagents.ph)
				flashing = ENABLE_FLASHING
		if(equilibrium.reaction.is_cold_recipe)
			if(equilibrium.reaction.overheat_temp > beaker?.reagents.chem_temp && equilibrium.reaction.overheat_temp != NO_OVERHEAT)
				danger = TRUE
				overheat = TRUE
		else
			if(equilibrium.reaction.overheat_temp < beaker?.reagents.chem_temp)
				danger = TRUE
				overheat = TRUE
		if(equilibrium.reaction.reaction_flags & REACTION_COMPETITIVE) //We have a compeitive reaction - concatenate the results for the different reactions
			for(var/entry in active_reactions)
				if(entry["name"] == reagent.name) //If we have multiple reaction methods for the same result - combine them
					entry["reactedVol"] = equilibrium.reacted_vol
					entry["targetVol"] = round(equilibrium.target_vol, 1)//Use the first result reagent to name the reaction detected
					entry["quality"] = (entry["quality"] + equilibrium.reaction_quality) /2
					continue
		active_reactions.len++
		active_reactions[length(active_reactions)] = list("name" = reagent.name, "danger" = danger, "purityAlert" = purity_alert, "quality" = equilibrium.reaction_quality, "overheat" = overheat, "inverse" = reagent.inverse_chem_val, "minPure" = equilibrium.reaction.purity_min, "reactedVol" = equilibrium.reacted_vol, "targetVol" = round(equilibrium.target_vol, 1))//Use the first result reagent to name the reaction detected
	data["activeReactions"] = active_reactions
	data["isFlashing"] = flashing

	data["acidicBufferVol"] = reagents.get_reagent_amount(/datum/reagent/reaction_agent/acidic_buffer)
	data["basicBufferVol"] = reagents.get_reagent_amount(/datum/reagent/reaction_agent/basic_buffer)
	data["dispenseVolume"] = dispense_volume

	data["tutorialMessage"] = null
	//Tutorial output
	if(tutorial_active)
		switch(tutorial_state)
			if(TUT_NO_BUFFER)//missing buffer
				data["tutorialMessage"] = {"Похоже, у вас мало буферов, вот как сделать больше:
Кислотный буфер:	2 единицы Sodium
			2 единицы Hydrogen
			2 единицы Ethanol
			2 единицы Water
Базовый буфер:	3 единицы Ammonia
			2 единицы Chlorine
			2 единицы Hydrogen
			2 единицы Oxygen
Нагрейте либо, чтобы ускорить реакцию.
Когда реакции будут выполнены, наполните камеру, нажав кнопки справа от соответствующих индикаторов объема.
Чтобы продолжить обучение, заполните как кислотный, так и щелочной объем как минимум 5 ед."}
			if(TUT_START)//Default start
				data["tutorialMessage"] = {"Здравствуйте и добро пожаловать в увлекательный мир химии! Этот вариант помощи научит вас основам реакций, проведя вас через каломельную реакцию.
Для большинства реакций температура перегрева составляет 900K, а диапазон pH составляет 5-9, хотя всегда стоит искать диапазоны, поскольку они меняются. Каломель ничем не отличается.
Чтобы продолжить обучение, вставьте стакан с добавлением не менее 10 мкл ртути и 10 мкл хлора."}
			if(TUT_HAS_REAGENTS) //10u Hg and Cl
				data["tutorialMessage"] = {"Молодец! Вы увидите, что в настоящее время это не реагирует. Это потому, что для этой реакции требуется минимальная температура 375 К.
По большей части, чем горячее ваша реакция, тем быстрее она отреагирует, когда температура превысит минимальную. Но будьте осторожны, не нагревайте его слишком сильно! «Если ваша реакция медленная, ваша температура слишком низкая»!
Когда будете готовы, установите температуру 375 К и нагрейте стакан до этой величины."}
			if(TUT_IS_ACTIVE) //heat 375K
				data["tutorialMessage"] = {"Отлично! Требуется увидеть, как ваша реакция медленно прогрессирует.
Обратите внимание на шкалу pH справа; Суммарный pH должен медленно сдвигаться влево на шкале. Степень чистоты раствора в конечном итоге зависит от того, насколько хорошо вы поддерживаете свою реакцию в оптимальном диапазоне pH. Циферблат будет мигать, если какая-либо из текущих реакций выходит за рамки оптимальных. «Если вы получаете отстой, подтолкните свой pH»!
Через мгновение мы увеличим температуру, чтобы наша скорость была быстрее. Вам решать, чтобы поддерживать уровень pH в установленных пределах, поэтому следите за шкалой и будьте готовы добавить базовый буфер, используя кнопку инъекции слева от индикатора объема.
Чтобы продолжить, установите целевую температуру на 390 К."}
			if(TUT_IS_REACTING) //Heat 390K
				data["tutorialMessage"] = "Сосредоточьтесь на реакции! Вы сможете это сделать!"
			if(TUT_FAIL) //Sludge
				data["tutorialMessage"] = "Ах, к сожалению, ваша чистота была слишком низкой, и реакция рассыпалась в беспорядочный осадок. Не волнуйтесь, вы всегда можете попробовать еще раз! Однако будьте осторожны, для некоторых реакций неудача не так проста."
			if(TUT_COMPLETE) //Complete
				var/datum/reagent/calo = beaker?.reagents.has_reagent(/datum/reagent/medicine/calomel)
				if(!calo)
					tutorial_state = TUT_COMPLETE
					return
				switch(calo.purity)
					if(-INFINITY to 0.25)
						data["tutorialMessage"] = "Вы сделали это! Поздравляю! Можно сказать вам, что ваша последняя чистота была [calo.purity]. Это довольно близко к чистоте отказа 0,15, что часто может вызвать взрыв некоторых реакций. Этот химикат превращается в токсичный осадок при проглатывании другим человеком и не вызывает нормальных эффектов каломели. Подлый, а?"
					if(0.25 to 0.6)
						data["tutorialMessage"] = "Вы сделали это! Поздравляю! Можно сказать вам, что ваша последняя чистота была [calo.purity]. Обычно эта реакция разрешается выше 0,7 без вмешательства. Вы восхваляете нечистые реакции? Чем ниже вы опускаетесь, тем выше вероятность получения опасных эффектов во время реакции. В некоторых более опасных реакциях вы находитесь на тонкой грани между смертью и обратной химией, не забывайте, что вы всегда можете охладить свою реакцию, чтобы дать себе больше времени, чтобы справиться с ней!"
					if(0.6 to 0.75)
						data["tutorialMessage"] = "Вы сделали это! Поздравляю! Можно сказать вам, что ваша последняя чистота была [calo.purity]. Обычно эта реакция разрешается выше 0,7 без вмешательства. Возможно, вы добавили слишком много базового буфера и перешли через 9? Если хотите - можете попробовать еще раз. Просто дважды нажмите кнопку справки!"
					if(0.75 to 0.85)
						data["tutorialMessage"] = "Вы сделали это! Поздравляю! Можно сказать вам, что ваша последняя чистота была [calo.purity]. Вы очень близки к оптимальному! Если хотите, попробуйте еще раз, дважды нажав кнопку справки."
					if(0.75 to 0.99)
						data["tutorialMessage"] = "Вы сделали это! Поздравляю! Можно сказать вам, что ваша последняя чистота была [calo.purity]. Вы очень близки к оптимальному! Не стесняйтесь попробовать еще раз, если хотите, дважды нажав кнопку справки, но это респектабельная чистота."
					if(0.99 to 1)
						data["tutorialMessage"] = "Вы сделали это! Поздравляю! Можно сказать вам, что ваша последняя чистота была [calo.purity]. Ваша каломель такая же чистая, как и приходит! Вы освоили основы химии, но впереди еще много испытаний. Удачи!"
						user.client?.give_award(/datum/award/achievement/misc/chemistry_tut, user)
				data["tutorialMessage"] += "\n\nВы заметили, что ваша температура поднялась выше 390K, пока была реакция? Это потому, что эта реакция экзотермическая (с тепловыделением), поэтому для некоторых реакций вам, возможно, придется скорректировать цель, чтобы компенсировать это. Да, и вы можете проверить свою чистоту, исследуя и распечатав химический анализатор на медлисте (пока)!"
			if(TUT_MISSING) //Missing
				data["tutorialMessage"] = "Ой, что-то пошло не так. Вы вынули мензурку, слишком быстро ее нагрели или в стакане есть что-то еще? Попробуйте перезапустить руководство, дважды нажав кнопку справки."

	return data

/obj/machinery/chem_heater/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("temperature")
			var/target = params["target"]
			if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				target_temperature = clamp(target, 0, 1000)
		if("eject")
			//Eject doesn't turn it off, so you can preheat for beaker swapping
			replace_beaker(usr)
			. = TRUE
		if("acidBuffer")
			var/target = params["target"]
			if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				move_buffer("acid", target)
		if("basicBuffer")
			var/target = params["target"]
			if(text2num(target) != null)
				target = text2num(target) //Because the input is flipped
				. = TRUE
			if(.)
				move_buffer("basic", target)
		if("disp_vol")
			var/target = params["target"]
			if(text2num(target) != null)
				target = text2num(target) //Because the input is flipped
				. = TRUE
			if(.)
				dispense_volume = target
		if("help")
			tutorial_active = !tutorial_active
			if(tutorial_active)
				tutorial_state = 1
				return
			tutorial_state = 0
			//Refresh window size
			ui_close(usr)
			ui_interact(usr, null)


///Moves a type of buffer from the heater to the beaker, or vice versa
/obj/machinery/chem_heater/proc/move_buffer(buffer_type, volume)
	if(!beaker)
		say("Не вижу пробирку!")
		return
	if(buffer_type == "acid")
		if(volume < 0)
			var/datum/reagent/acid_reagent = beaker.reagents.get_reagent(/datum/reagent/reaction_agent/acidic_buffer)
			if(!acid_reagent)
				say("Невозможно найти кислотный буфер в пробирке! Вставьте стакан с кислотным буфером.")
				return
			var/datum/reagent/acid_reagent_heater = reagents.get_reagent(/datum/reagent/reaction_agent/acidic_buffer)
			var/cur_vol = 0
			if(acid_reagent_heater)
				cur_vol = acid_reagent_heater.volume
			volume = 100 - cur_vol
			beaker.reagents.trans_id_to(src, acid_reagent.type, volume)//negative because we're going backwards
			return
		//We must be positive here
		reagents.trans_id_to(beaker, /datum/reagent/reaction_agent/acidic_buffer, dispense_volume)
		return

	if(buffer_type == "basic")
		if(volume < 0)
			var/datum/reagent/basic_reagent = beaker.reagents.get_reagent(/datum/reagent/reaction_agent/basic_buffer)
			if(!basic_reagent)
				say("Невозможно найти щелочной буфер в пробирке! Пожалуйста, вставьте стакан с щелочным буфером.")
				return
			var/datum/reagent/basic_reagent_heater = reagents.get_reagent(/datum/reagent/reaction_agent/basic_buffer)
			var/cur_vol = 0
			if(basic_reagent_heater)
				cur_vol = basic_reagent_heater.volume
			volume = 100 - cur_vol
			beaker.reagents.trans_id_to(src, basic_reagent.type, volume)//negative because we're going backwards
			return
		reagents.trans_id_to(beaker, /datum/reagent/reaction_agent/basic_buffer, dispense_volume)
		return


/obj/machinery/chem_heater/proc/get_purity_color(datum/equilibrium/equilibrium)
	var/_reagent = equilibrium.reaction.results[1]
	var/datum/reagent/reagent = equilibrium.holder.get_reagent(_reagent)
	// Can't be a switch due to http://www.byond.com/forum/post/2750423
	if(reagent.purity in 1 to INFINITY)
		return "blue"
	else if(reagent.purity in 0.8 to 1)
		return "green"
	else if(reagent.purity in reagent.inverse_chem_val to 0.8)
		return "olive"
	else if(reagent.purity in equilibrium.reaction.purity_min to reagent.inverse_chem_val)
		return "orange"
	else if(reagent.purity in -INFINITY to equilibrium.reaction.purity_min)
		return "red"

//Has a lot of buffer and is upgraded
/obj/machinery/chem_heater/debug
	name = "Debug Reaction Chamber"
	desc = "Now with even more buffers!"

/obj/machinery/chem_heater/debug/Initialize(mapload)
	. = ..()
	reagents.maximum_volume = 2000
	reagents.add_reagent(/datum/reagent/reaction_agent/basic_buffer, 980)
	reagents.add_reagent(/datum/reagent/reaction_agent/acidic_buffer, 980)
	heater_coefficient = 0.4 //hack way to upgrade

//map load types
/obj/machinery/chem_heater/withbuffer
	desc = "This Reaction Chamber comes with a bit of buffer to help get you started."

/obj/machinery/chem_heater/withbuffer/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/reaction_agent/basic_buffer, 20)
	reagents.add_reagent(/datum/reagent/reaction_agent/acidic_buffer, 20)

#undef TUT_NO_BUFFER
#undef TUT_START
#undef TUT_HAS_REAGENTS
#undef TUT_IS_ACTIVE
#undef TUT_IS_REACTING
#undef TUT_FAIL
#undef TUT_COMPLETE
#undef TUT_MISSING
