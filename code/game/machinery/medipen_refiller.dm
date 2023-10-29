/obj/machinery/medipen_refiller
	name = "наполнитель медипенов"
	desc = "Машина, производящая пустые медипены, а так же перезаряжающая их химикатами. Внимание! Перезарядка осуществляется только для медипенов одобренных медицинской ассоциацией Нанотрейзен. Химический состав наполнителя должен строго соответствовать маркировке, в противном случае операция будет прервана."
	icon = 'icons/obj/machines/medipen_refiller.dmi'
	icon_state = "medipen_refiller"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/medipen_refiller
	/// list of medipen subtypes it can refill
	var/list/allowed = list(
		/obj/item/reagent_containers/hypospray/medipen = /datum/reagent/medicine/epinephrine,
		/obj/item/reagent_containers/hypospray/medipen/atropine = /datum/reagent/medicine/atropine,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol = /datum/reagent/medicine/salbutamol,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = /datum/reagent/medicine/oxandrolone,
		/obj/item/reagent_containers/hypospray/medipen/salacid = /datum/reagent/medicine/sal_acid,
		/obj/item/reagent_containers/hypospray/medipen/penacid = /datum/reagent/medicine/pen_acid,
		/obj/item/reagent_containers/hypospray/medipen/blood_loss = /datum/reagent/medicine/salglu_solution,
		/obj/item/reagent_containers/hypospray/medipen/blood_boost = /datum/reagent/medicine/hematogen,
		/obj/item/reagent_containers/hypospray/medipen/super_brute = /datum/reagent/medicine/c2/libital,
		/obj/item/reagent_containers/hypospray/medipen/super_burn = /datum/reagent/medicine/c2/lenturi,

		/obj/item/reagent_containers/hypospray/medipen/empty = /datum/reagent/medicine/epinephrine,	// болванки
		/obj/item/reagent_containers/hypospray/medipen/atropine/empty = /datum/reagent/medicine/atropine,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol/empty = /datum/reagent/medicine/salbutamol,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone/empty = /datum/reagent/medicine/oxandrolone,
		/obj/item/reagent_containers/hypospray/medipen/salacid/empty = /datum/reagent/medicine/sal_acid,
		/obj/item/reagent_containers/hypospray/medipen/penacid/empty = /datum/reagent/medicine/pen_acid,
		/obj/item/reagent_containers/hypospray/medipen/blood_loss/empty = /datum/reagent/medicine/salglu_solution,
		/obj/item/reagent_containers/hypospray/medipen/blood_boost/empty = /datum/reagent/medicine/hematogen,
		/obj/item/reagent_containers/hypospray/medipen/super_brute/empty = /datum/reagent/medicine/c2/libital,
		/obj/item/reagent_containers/hypospray/medipen/super_burn/empty = /datum/reagent/medicine/c2/lenturi,
		)

	var/list/allowed2 = list(
		/obj/item/reagent_containers/hypospray/medipen/blood_boost = /datum/reagent/medicine/salglu_solution,
		/obj/item/reagent_containers/hypospray/medipen/super_brute = /datum/reagent/medicine/sal_acid,
		/obj/item/reagent_containers/hypospray/medipen/super_burn = /datum/reagent/medicine/oxandrolone,

		/obj/item/reagent_containers/hypospray/medipen/blood_boost/empty = /datum/reagent/medicine/salglu_solution,	// болванки
		/obj/item/reagent_containers/hypospray/medipen/super_brute/empty = /datum/reagent/medicine/sal_acid,
		/obj/item/reagent_containers/hypospray/medipen/super_burn/empty = /datum/reagent/medicine/oxandrolone,
		)
	/// var to prevent glitches in the animation
	var/busy = FALSE

	var/last_request = 0
	var/medipen_cd = 60 SECONDS

/obj/machinery/medipen_refiller/Initialize(mapload)
	. = ..()
	create_reagents(100, TRANSPARENT)
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		reagents.maximum_volume += 100 * B.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		medipen_cd = 60 SECONDS / M.rating

	AddComponent(/datum/component/plumbing/simple_demand)


/obj/machinery/medipen_refiller/RefreshParts()
	. = ..()
	var/new_volume = 100
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		new_volume += 100 * B.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		medipen_cd = 60 SECONDS / M.rating
	if(!reagents)
		create_reagents(new_volume, TRANSPARENT)
	reagents.maximum_volume = new_volume
	return TRUE

///  handles the messages and animation, calls refill to end the animation
/obj/machinery/medipen_refiller/attackby(obj/item/I, mob/user, params)
	if(busy)
		to_chat(user, span_danger("Машина занята."))
		return
	if(istype(I, /obj/item/reagent_containers) && I.is_open_container())
		var/obj/item/reagent_containers/RC = I
		var/units = RC.reagents.trans_to(src, RC.amount_per_transfer_from_this, transfered_by = user)
		if(units)
			to_chat(user, span_notice("Переливаю [units] единиц раствора в [name]."))
			return
		else
			to_chat(user, span_danger("[name] полон."))
			return
	if(istype(I, /obj/item/reagent_containers/hypospray/medipen))
		var/obj/item/reagent_containers/hypospray/medipen/P = I
		if(!(LAZYFIND(allowed, P.type)))
			to_chat(user, span_danger("Ошибка! В базе нет данных о конструкции данного медипена!"))
			return
		if(P.reagents?.reagent_list.len)
			to_chat(user, span_notice("Данный медипен уже заряжен."))
			return
		if(reagents.has_reagent(allowed[P.type], P.reagent1_vol))
			if(P.reagent2_vol)
				if(!reagents.has_reagent(allowed2[P.type], P.reagent2_vol))
					to_chat(user, span_danger("Внимание! В машине недостаточно реагентов или они не соответствуют данному медипену."))
					return
			busy = TRUE
			add_overlay("active")
			playsound(src, 'sound/effects/spray.ogg', 30, TRUE, -6)
			addtimer(CALLBACK(src, PROC_REF(refill), P, user), 20)
			qdel(P)
			return
		to_chat(user, span_danger("Внимание! В машине недостаточно реагентов или они не соответствуют данному медипену."))
		return
	..()

/obj/machinery/medipen_refiller/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	to_chat(user, span_notice("Яростно прочищаю [name]."))
	if(do_after(user, 30, target = src))
		to_chat(user, span_notice("Готово, [name] пуст."))
		reagents.expose(get_turf(src), TOUCH)
		reagents.clear_reagents()

/obj/machinery/medipen_refiller/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	return TRUE

/obj/machinery/medipen_refiller/crowbar_act(mob/user, obj/item/I)
	..()
	default_deconstruction_crowbar(I)
	return TRUE

/obj/machinery/medipen_refiller/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(!.)
		return default_deconstruction_screwdriver(user, "medipen_refiller_open", "medipen_refiller", I)

/// refills the medipen
/obj/machinery/medipen_refiller/proc/refill(obj/item/reagent_containers/hypospray/medipen/P, mob/user)
	if(P.empty_start)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/empty))
			new /obj/item/reagent_containers/hypospray/medipen(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/atropine/empty))
			new /obj/item/reagent_containers/hypospray/medipen/atropine(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/salacid/empty))
			new /obj/item/reagent_containers/hypospray/medipen/salacid(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/oxandrolone/empty))
			new /obj/item/reagent_containers/hypospray/medipen/oxandrolone(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/penacid/empty))
			new /obj/item/reagent_containers/hypospray/medipen/penacid(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/salbutamol/empty))
			new /obj/item/reagent_containers/hypospray/medipen/salbutamol(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/blood_loss/empty))
			new /obj/item/reagent_containers/hypospray/medipen/blood_loss(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/blood_boost/empty))
			new /obj/item/reagent_containers/hypospray/medipen/blood_boost(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/super_brute/empty))
			new /obj/item/reagent_containers/hypospray/medipen/super_brute(loc)
		if(istype(P,/obj/item/reagent_containers/hypospray/medipen/super_burn/empty))
			new /obj/item/reagent_containers/hypospray/medipen/super_burn(loc)
	else
		new P.type(loc)
	reagents.remove_reagent(allowed[P.type], P.reagent1_vol)
	if(P.reagent2_vol)
		reagents.remove_reagent(allowed2[P.type], P.reagent2_vol)
	cut_overlays()
	busy = FALSE
	to_chat(user, span_notice("Медипен перезаряжен."))
	use_power(active_power_usage)


//	Создание пустых медипенов болванок

/obj/machinery/medipen_refiller/attack_hand(mob/user)
	. = ..()
	if(last_request + medipen_cd < world.time)
		to_chat(usr, span_notice("Нажимаю кнопку производства болванки нового медипена."))
		var/static/list/choices = list(
			"Адреналин" 					= image(icon = 'icons/obj/syringe.dmi', icon_state = "medipen"),
			"Салициловая кислота" 			= image(icon = 'icons/obj/syringe.dmi', icon_state = "salacid"),
			"Оксандролон" 					= image(icon = 'icons/obj/syringe.dmi', icon_state = "oxapen"),
			"Пентетовая кислота" 			= image(icon = 'icons/obj/syringe.dmi', icon_state = "penacid"),
			"Сальбутомол" 					= image(icon = 'icons/obj/syringe.dmi', icon_state = "salpen"),
			"Атропин" 						= image(icon = 'icons/obj/syringe.dmi', icon_state = "atropen"),
			"Кровезамещающий медипен" 		= image(icon = 'icons/obj/syringe.dmi', icon_state = "hypovolemic"),
			"Антитравматический медипен" 	= image(icon = 'white/Feline/icons/medipens.dmi', icon_state = "super_brute"),
			"Антиожоговый медипен" 			= image(icon = 'white/Feline/icons/medipens.dmi', icon_state = "super_burn"),
			"Гемолитический медипен"	 	= image(icon = 'white/Feline/icons/medipens.dmi', icon_state = "blood_boost"),
			)
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE, require_near = TRUE)
		if(!choice)
			return
		switch(choice)
			if("Адреналин")
				new /obj/item/reagent_containers/hypospray/medipen/empty(loc)
			if("Салициловая кислота")
				new /obj/item/reagent_containers/hypospray/medipen/salacid/empty(loc)
			if("Оксандролон")
				new /obj/item/reagent_containers/hypospray/medipen/oxandrolone/empty(loc)
			if("Пентетовая кислота")
				new /obj/item/reagent_containers/hypospray/medipen/penacid/empty(loc)
			if("Сальбутомол")
				new /obj/item/reagent_containers/hypospray/medipen/salbutamol/empty(loc)
			if("Атропин")
				new /obj/item/reagent_containers/hypospray/medipen/atropine/empty(loc)
			if("Кровезамещающий медипен")
				new /obj/item/reagent_containers/hypospray/medipen/blood_loss/empty(loc)
			if("Антитравматический медипен")
				new /obj/item/reagent_containers/hypospray/medipen/super_brute/empty(loc)
			if("Антиожоговый медипен")
				new /obj/item/reagent_containers/hypospray/medipen/super_burn/empty(loc)
			if("Гемолитический медипен")
				new /obj/item/reagent_containers/hypospray/medipen/blood_boost/empty(loc)

		last_request = world.time
		playsound(src, 'sound/effects/light_flicker.ogg', 30, TRUE, -6)
		return TRUE
	else
		to_chat(usr, span_notice("Производится синтез материалов для новой болванки. До завершения [(last_request + medipen_cd - world.time)/10] секунд."))
		return

//	Пустые

/obj/item/reagent_containers/hypospray/medipen/empty
	list_reagents = list(null)
	icon_state = "medipen0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/atropine/empty
	list_reagents = list(null)
	icon_state = "atropen0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/oxandrolone/empty
	list_reagents = list(null)
	icon_state = "oxapen0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/penacid/empty
	list_reagents = list(null)
	icon_state = "penacid0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/salacid/empty
	list_reagents = list(null)
	icon_state = "salacid0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/salbutamol/empty
	list_reagents = list(null)
	icon_state = "salpen0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/blood_loss/empty
	list_reagents = list(null)
	icon_state = "hypovolemic0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/blood_boost/empty
	list_reagents = list(null)
	icon_state = "blood_boost0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/super_brute/empty
	list_reagents = list(null)
	icon_state = "super_brute0"
	empty_start = TRUE

/obj/item/reagent_containers/hypospray/medipen/super_burn/empty
	list_reagents = list(null)
	icon_state = "super_burn0"
	empty_start = TRUE

