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
			to_chat(user, "<span class='warning'><b>[capitalize(src.name)]</b> пуст!</span>")
			add_fingerprint(user)
			return
		var/obj/item/ph_paper/page = new(get_turf(user))
		page.add_fingerprint(user)
		user.put_in_active_hand(page)
		to_chat(user, "<span class='notice'>Достаю [page] из [src.name].</span>")
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
		to_chat(user, "<span class='warning'><b>[capitalize(src.name)]</b> пуст!</span>")
		add_fingerprint(user)
		return
	if(number_of_pages == 50)
		icon_state = "pHbooklet_open"
	var/obj/item/ph_paper/P = new(get_turf(user))
	P.add_fingerprint(user)
	user.put_in_active_hand(P)
	to_chat(user, "<span class='notice'>Достаю [P] из [src.name].</span>")
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
	var/obj/item/reagent_containers/cont = target
	if(!istype(cont))
		return
	if(used == TRUE)
		to_chat(user, "<span class='warning'><b>[capitalize(src.name)]</b> уже использована!</span>")
		return
	if(!LAZYLEN(cont.reagents.reagent_list))
		return
	switch(round(cont.reagents.ph, 1))
		if(14 to INFINITY)
			color = "#462c83"
		if(13 to 14)
			color = "#63459b"
		if(12 to 13)
			color = "#5a51a2"
		if(11 to 12)
			color = "#3853a4"
		if(10 to 11)
			color = "#3f93cf"
		if(9 to 10)
			color = "#0bb9b7"
		if(8 to 9)
			color = "#23b36e"
		if(7 to 8)
			color = "#3aa651"
		if(6 to 7)
			color = "#4cb849"
		if(5 to 6)
			color = "#b5d335"
		if(4 to 5)
			color = "#f7ec1e"
		if(3 to 4)
			color = "#fbc314"
		if(2 to 3)
			color = "#f26724"
		if(1 to 2)
			color = "#ef1d26"
		if(-INFINITY to 1)
			color = "#c6040c"
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
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	///level of detail for output for the meter
	var/scanmode = DETAILED_CHEM_OUTPUT

/obj/item/ph_meter/attack_self(mob/user)
	if(scanmode == SHORTENED_CHEM_OUTPUT)
		to_chat(user, "<span class='notice'>Переключаю химический анализатор, чтобы получить подробное описание каждого реагента.</span>")
		scanmode = DETAILED_CHEM_OUTPUT
	else
		to_chat(user, "<span class='notice'>Переключаю химический анализатор, чтобы не включать в отчет описания реагентов.</span>")
		scanmode = SHORTENED_CHEM_OUTPUT

/obj/item/ph_meter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!istype(target, /obj/item/reagent_containers))
		return
	var/obj/item/reagent_containers/cont = target
	if(LAZYLEN(cont.reagents.reagent_list) == null)
		return
	var/list/out_message = list()
	to_chat(user, "<i>Измеритель химии издает звуковой сигнал и отображает:</i>")
	out_message += "<span class='notice'><b>Объём: [round(cont.volume, 0.01)] Температура: [round(cont.reagents.chem_temp, 0.1)]K Уровень pH: [round(cont.reagents.ph, 0.01)]\n"
	out_message += "Реагенты:</b>\n"
	if(cont.reagents.is_reacting)
		out_message += "<span class='warning'>Похоже, что в настоящее время происходит реакция.<span class='notice'>\n"
	for(var/datum/reagent/R in cont.reagents.reagent_list)
		out_message += "<b>[round(R.volume, 0.01)] единиц [R.name]</b>, <b>Чистота:</b> [round(R.purity, 0.01)], [(scanmode?"[(R.overdose_threshold?"<b>Передозировка:</b> [R.overdose_threshold] единиц, ":"")][(R.addiction_threshold?"<b>Привыкание:</b> [R.addiction_threshold] единиц, ":"")]<b>Базовый pH:</b> [initial(R.ph)], <b>Текущий pH:</b> [R.ph].":"<b>Текущий pH:</b> [R.ph].")]\n"
		if(scanmode)
			out_message += "<b>Анализ:</b> [R.description]\n"
	to_chat(user, "[out_message.Join()]</span>")
	desc = "Электрод, прикрепленный к небольшой монтажной коробке, на которой будут отображаться детали раствора. Можно переключить, чтобы предоставить описание каждого из реагентов. На экране в настоящее время отображается объём: [round(cont.volume, 0.01)] обнаруженный pH:[round(cont.reagents.ph, 0.1)]."
