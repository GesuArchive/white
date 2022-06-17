///if the ph_meter gives a detailed output
#define DETAILED_CHEM_OUTPUT 1
///if the pH meter gives a shorter output
#define SHORTENED_CHEM_OUTPUT 0

/*
* a pH booklet that contains pH paper pages that will change color depending on the pH of the reagents datum it's attacked onto
*/
/obj/item/ph_booklet
	name = "буклет с индикатором pH"
	desc = "Буклет, содержащий бумагу, пропитанную универсальным индикатором."
	icon_state = "pHbooklet"
	icon = 'icons/obj/chemical.dmi'
	item_flags = NOBLUDGEON
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	///How many pages the booklet holds
	var/number_of_pages = 50

//A little janky with pockets
/obj/item/ph_booklet/attack_hand(mob/user)
	if(user.get_held_index_of_item(src))//Does this check pockets too..?
		if(number_of_pages == 50)
			icon_state = "pHbooklet_open"
		if(!number_of_pages)
			to_chat(user, span_warning("<b>[capitalize(src.name)]</b> пуст!"))
			add_fingerprint(user)
			return
		var/obj/item/ph_paper/page = new(get_turf(user))
		page.add_fingerprint(user)
		user.put_in_active_hand(page)
		to_chat(user, span_notice("Достаю [page] из [src.name]."))
		number_of_pages--
		playsound(user.loc, 'sound/items/poster_ripped.ogg', 50, TRUE)
		add_fingerprint(user)
		if(!number_of_pages)
			icon_state = "pHbooklet_empty"
		return
	var/I = user.get_active_held_item()
	if(!I)
		user.put_in_active_hand(src)
	return ..()

/obj/item/ph_booklet/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	var/mob/living/user = usr
	if(!isliving(user))
		return
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	if(!number_of_pages)
		to_chat(user, span_warning("<b>[capitalize(src.name)]</b> пуст!"))
		add_fingerprint(user)
		return
	if(number_of_pages == 50)
		icon_state = "pHbooklet_open"
	var/obj/item/ph_paper/P = new(get_turf(user))
	P.add_fingerprint(user)
	user.put_in_active_hand(P)
	to_chat(user, span_notice("Достаю [P] из [src.name]."))
	number_of_pages--
	playsound(user.loc, 'sound/items/poster_ripped.ogg', 50, TRUE)
	add_fingerprint(user)
	if(!number_of_pages)
		icon_state = "pHbookletEmpty"

/*
* pH paper will change color depending on the pH of the reagents datum it's attacked onto
*/
/obj/item/ph_paper
	name = "индикаторная полоска pH"
	desc = "Лист бумаги, который меняет цвет в зависимости от pH раствора."
	icon_state = "pHpaper"
	icon = 'icons/obj/chemical.dmi'
	item_flags = NOBLUDGEON
	color = "#f5c352"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	///If the paper was used, and therefore cannot change color again
	var/used = FALSE

/obj/item/ph_paper/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!is_reagent_container(target))
		return
	var/obj/item/reagent_containers/cont = target
	if(used == TRUE)
		to_chat(user, span_warning("<b>[capitalize(src.name)]</b> уже использована!"))
		return
	if(!LAZYLEN(cont.reagents.reagent_list))
		return
	CONVERT_PH_TO_COLOR(round(cont.reagents.ph, 1), color)
	desc += " Бумага выглядит примерно с pH равным [round(cont.reagents.ph, 1)]"
	name = "использованная [name]"
	used = TRUE

/*
* pH meter that will give a detailed or truncated analysis of all the reagents in of an object with a reagents datum attached to it. Only way of detecting purity for now.
*/
/obj/item/ph_meter
	name = "химический анализатор"
	desc = "Электрод, прикрепленный к небольшой коробке, на которой будут отображаться детали раствора. Можно переключить, чтобы предоставить описание каждого из реагентов. На данный момент на экране ничего не отображается."
	icon_state = "pHmeter"
	icon = 'icons/obj/chemical.dmi'
	w_class = WEIGHT_CLASS_TINY
	///level of detail for output for the meter
	var/scanmode = DETAILED_CHEM_OUTPUT

/obj/item/ph_meter/attack_self(mob/user)
	if(scanmode == SHORTENED_CHEM_OUTPUT)
		to_chat(user, span_notice("Переключаю химический анализатор, чтобы получить подробное описание каждого реагента."))
		scanmode = DETAILED_CHEM_OUTPUT
	else
		to_chat(user, span_notice("Переключаю химический анализатор, чтобы не включать в отчет описания реагентов."))
		scanmode = SHORTENED_CHEM_OUTPUT

/obj/item/ph_meter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!is_reagent_container(target))
		return
	var/obj/item/reagent_containers/cont = target
	if(LAZYLEN(cont.reagents.reagent_list) == null)
		return
	var/list/out_message = list()
	to_chat(user, "<i>Измеритель химии издает звуковой сигнал и отображает:</i>")
	out_message += "<span class='notice'><b>Объём: [round(cont.volume, 0.01)] Температура: [round(cont.reagents.chem_temp, 0.1)]K Уровень pH: [round(cont.reagents.ph, 0.01)]\n"
	out_message += "Реагенты:</b>\n"
	if(cont.reagents.is_reacting)
		out_message += "<span class='warning'>Похоже, что в настоящее время происходит реакция.</span><span class='notice'>\n"
	for(var/datum/reagent/reagent in cont.reagents.reagent_list)
		if(reagent.purity < 1) //If the reagent is impure
			if(reagent.purity < reagent.inverse_chem_val && reagent.inverse_chem) //Below level and has an inverse
				var/datum/reagent/inverse_reagent = GLOB.chemical_reagents_list[reagent.inverse_chem]
				out_message += "<span class='warning'>Инвертированные реагенты: </span><span class='notice'><b>[round(reagent.volume, 0.01)] единиц [inverse_reagent.name]</b>, <b>Чистота:</b> [round(1 - reagent.purity, 0.01)*100]%, [(scanmode?"[(inverse_reagent.overdose_threshold?"<b>Передозировка:</b> [inverse_reagent.overdose_threshold]u, ":"")]<b>Базовый pH:</b> [initial(inverse_reagent.ph)], <b>Текущий pH:</b> [reagent.ph].":"<b>Текущий pH:</b> [reagent.ph].")]\n"
			else if(reagent.impure_chem) //Otherwise has an impure
				var/datum/reagent/impure_reagent = GLOB.chemical_reagents_list[reagent.impure_chem]
				out_message += "<b>[round(reagent.volume, 0.01)] единиц [reagent.name]</b>, <b>Чистота:</b> [round(reagent.purity, 0.01)*100]%, [(scanmode?"[(reagent.overdose_threshold?"<b>Передозировка:</b> [reagent.overdose_threshold]u, ":"")]<b>Базовый pH:</b> [initial(reagent.ph)], <b>Текущий pH:</b> [reagent.ph].":"<b>Текущий pH:</b> [reagent.ph].")]\n"
				out_message += "<span class='warning'>Impurities detected: </span><span class='notice'><b>[round(reagent.volume - (reagent.volume * reagent.purity), 0.01)]u of [impure_reagent.name]</b>, [(scanmode?"[(reagent.overdose_threshold?"<b>Передозировка:</b> [reagent.overdose_threshold]u, ":"")]":"")]\n"
		else
			out_message += "<b>[round(reagent.volume, 0.01)] единиц [reagent.name]</b>, <b>Чистота:</b> [round(reagent.purity, 0.01)*100]%, [(scanmode?"[(reagent.overdose_threshold?"<b>Передозировка:</b> [reagent.overdose_threshold]u, ":"")]<b>Базовый pH:</b> [initial(reagent.ph)], <b>Текущий pH:</b> [reagent.ph].":"<b>Текущий pH:</b> [reagent.ph].")]\n"
		if(scanmode)
			out_message += "<b>Анализ:</b> [reagent.description]\n"
	to_chat(user, "[out_message.Join()]</span>")
	desc = "Электрод, прикрепленный к небольшой монтажной коробке, на которой будут отображаться детали раствора. Можно переключить, чтобы предоставить описание каждого из реагентов. На экране в настоящее время отображается объём: [round(cont.volume, 0.01)] обнаруженный pH:[round(cont.reagents.ph, 0.1)]."


/obj/item/burner
	name = "спиртовая горелка"
	desc = "Ёмкость, которая используется для нагрева жидкостей в пробирках."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "burner"
	grind_results = list(/datum/reagent/consumable/ethanol = 5, /datum/reagent/silicon = 10)
	item_flags = NOBLUDGEON
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	heat = 2000
	///If the flame is lit - i.e. if we're processing and burning
	var/lit = FALSE
	///total reagent volume
	var/max_volume = 50
	///What the creation reagent is
	var/reagent_type = /datum/reagent/consumable/ethanol

/obj/item/burner/Initialize(mapload)
	. = ..()
	create_reagents(max_volume, TRANSPARENT)//We have our own refillable - since we want to heat and pour
	if(reagent_type)
		reagents.add_reagent(reagent_type, 15)

/obj/item/burner/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(is_reagent_container(I))
		if(lit)
			var/obj/item/reagent_containers/container = I
			container.reagents.expose_temperature(get_temperature())
			to_chat(user, span_notice("Нагреваю [I] используя [src.name]."))
			playsound(user.loc, 'sound/chemistry/heatdam.ogg', 50, TRUE)
			return
		else if(I.is_drainable()) //Transfer FROM it TO us. Special code so it only happens when flame is off.
			var/obj/item/reagent_containers/container = I
			if(!container.reagents.total_volume)
				to_chat(user, span_warning("[capitalize(container)] пуст!"))
				return

			if(reagents.holder_full())
				to_chat(user, span_warning("[src.name] переполнена."))
				return

			var/trans = container.reagents.trans_to(src, container.amount_per_transfer_from_this, transfered_by = user)
			to_chat(user, span_notice("Заполняю [src.name] используя [trans] единиц содержимого [container]."))
	if(I.heat < 1000)
		return
	set_lit(TRUE)
	user.visible_message(span_notice("[user] поджигает [src.name]."))

/obj/item/burner/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(lit)
		if(is_reagent_container(target))
			var/obj/item/reagent_containers/container = target
			container.reagents.expose_temperature(get_temperature())
			to_chat(user, span_notice("Нагреваю [src.name]."))
			playsound(user.loc, 'sound/chemistry/heatdam.ogg', 50, TRUE)
			return
	else if(isitem(target))
		var/obj/item/item = target
		if(item.heat > 1000)
			set_lit(TRUE)
			user.visible_message(span_notice("[user] поджигает [src.name]."))

/obj/item/burner/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][lit ? "-on" : ""]"

/obj/item/burner/proc/set_lit(new_lit)
	if(lit == new_lit)
		return
	lit = new_lit
	if(lit)
		force = 5
		damtype = BURN
		hitsound = 'sound/items/welder.ogg'
		attack_verb_continuous = string_list(list("burns", "sings"))
		attack_verb_simple = string_list(list("burn", "sing"))
		START_PROCESSING(SSobj, src)
	else
		hitsound = "swing_hit"
		force = 0
		attack_verb_continuous = null //human_defense.dm takes care of it
		attack_verb_simple = null
		STOP_PROCESSING(SSobj, src)
	set_light_on(lit)
	update_icon()

/obj/item/burner/extinguish()
	set_lit(FALSE)

/obj/item/burner/attack_self(mob/living/user)
	. = ..()
	if(.)
		return
	if(lit)
		set_lit(FALSE)
		user.visible_message(span_notice("[user] задувает пламя [src.name]."))

/obj/item/burner/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(lit && M.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(M)] on fire with [src] at [AREACOORD(user)]")
		log_game("[key_name(user)] set [key_name(M)] on fire with [src] at [AREACOORD(user)]")
	return ..()

/obj/item/burner/process()
	var/current_heat = 0
	var/number_of_burning_reagents = 0
	for(var/datum/reagent/reagent as anything in reagents.reagent_list)
		reagent.burn(reagents) //burn can set temperatures of reagents
		if(!isnull(reagent.burning_temperature))
			current_heat += reagent.burning_temperature
			number_of_burning_reagents += 1
			reagents.remove_reagent(reagent.type, reagent.burning_volume)
			continue

	if(!number_of_burning_reagents)
		set_lit(FALSE)
		heat = 0
		return
	open_flame()
	current_heat /= number_of_burning_reagents
	heat = current_heat

/obj/item/burner/get_temperature()
	return lit * heat

/obj/item/burner/oil
	name = "масляная горелка"
	reagent_type = /datum/reagent/fuel/oil
	grind_results = list(/datum/reagent/fuel/oil = 5, /datum/reagent/silicon = 10)

/obj/item/burner/fuel
	name = "топливная горелка"
	reagent_type = /datum/reagent/fuel
	grind_results = list(/datum/reagent/fuel = 5, /datum/reagent/silicon = 10)

/obj/item/thermometer
	name = "термометр"
	desc = "Используется для проверки температуры в сосудах."
	icon_state = "thermometer"
	icon = 'icons/obj/chemical.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	grind_results = list(/datum/reagent/mercury = 5)
	///The reagents datum that this object is attached to, so we know where we are when it's added to something.
	var/datum/reagents/attached_to_reagents

/obj/item/thermometer/Destroy()
	QDEL_NULL(attached_to_reagents) //I have no idea how you can destroy this, but not the beaker, but here we go
	return ..()

/obj/item/thermometer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(target.reagents)
		if(!user.transferItemToLoc(src, target))
			return
		attached_to_reagents = target.reagents
		to_chat(user, span_notice("Прикрепляю [src.name] в [target]."))
		ui_interact(usr, null)

/obj/item/thermometer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Thermometer", name)
		ui.open()

/obj/item/thermometer/ui_close(mob/user, datum/tgui/tgui)
	. = ..()
	remove_thermometer(user)

/obj/item/thermometer/ui_status(mob/user)
	if(!(in_range(src, user)))
		return UI_CLOSE
	return UI_INTERACTIVE

/obj/item/thermometer/ui_state(mob/user)
	return GLOB.physical_state

/obj/item/thermometer/ui_data(mob/user)
	if(!attached_to_reagents)
		ui_close(user)
	var/data = list()
	data["Temperature"] = round(attached_to_reagents.chem_temp)
	return data

/obj/item/thermometer/proc/remove_thermometer(mob/target)
	try_put_in_hand(src, target)
	attached_to_reagents = null

/obj/item/thermometer/proc/try_put_in_hand(obj/object, mob/living/user)
	to_chat(user, span_notice("Убираю [src.name] из [attached_to_reagents.my_atom]."))
	if(!issilicon(user) && in_range(src.loc, user))
		user.put_in_hands(object)
	else
		object.forceMove(drop_location())

/obj/item/thermometer/pen
	color = "#888888"
