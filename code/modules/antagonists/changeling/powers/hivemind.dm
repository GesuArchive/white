//HIVEMIND COMMUNICATION (:g)
/datum/action/changeling/hivemind_comms
	name = "Общение с ульем"
	desc = "Мы настраиваемся на принятие и отправку данных с другими генокрадами."
	helptext = "Мы сможем общаться с другими генокрадами, используя :g."
	needs_button = FALSE
	dna_cost = 0
	chemical_cost = -1

/datum/action/changeling/hivemind_comms/on_purchase(mob/user, is_respec)
	..()
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	changeling.changeling_speak = 1
	to_chat(user, "<i><font color=#800080>Используй \"[MODE_TOKEN_CHANGELING] сообщение\" чтобы общаться с другими генокрадами.</font></i>")
	var/datum/action/changeling/hivemind_upload/S1 = new
	if(!changeling.has_sting(S1))
		S1.Grant(user)
		changeling.purchasedpowers+=S1
	var/datum/action/changeling/hivemind_download/S2 = new
	if(!changeling.has_sting(S2))
		S2.Grant(user)
		changeling.purchasedpowers+=S2

/datum/action/changeling/hivemind_comms/Remove(mob/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(changeling.changeling_speak)
		changeling.changeling_speak = FALSE
	for(var/p in changeling.purchasedpowers)
		var/datum/action/changeling/otherpower = p
		if(istype(otherpower, /datum/action/changeling/hivemind_upload) || istype(otherpower, /datum/action/changeling/hivemind_download))
			changeling.purchasedpowers -= otherpower
			otherpower.Remove(changeling.owner.current)
	..()



// HIVE MIND UPLOAD/DOWNLOAD DNA
GLOBAL_LIST_EMPTY(hivemind_bank)

/datum/action/changeling/hivemind_upload
	name = "Обмен ДНК с роем"
	desc = "Позволяет нам направлять ДНК в эфир, чтобы позволить другим генокрадам поглотить ее. Стоит 10 химикатов."
	button_icon_state = "hivemind_channel"
	chemical_cost = 10
	dna_cost = -1

/datum/action/changeling/hivemind_upload/sting_action(mob/living/user)
	if (HAS_TRAIT(user, CHANGELING_HIVEMIND_MUTE))
		to_chat(user, span_warning("Яд в воздухе препятствует нашей способности взаимодействовать с роем."))
		return
	..()
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/list/names = list()
	for(var/datum/changelingprofile/prof in changeling.stored_profiles)
		if(!(prof in GLOB.hivemind_bank))
			names += prof.name

	if(names.len <= 0)
		to_chat(user, span_warning("В эфире уже есть наш ДНК!"))
		return

	var/chosen_name = tgui_input_list(usr, "Выбрать бы ДНК для отправки: ", "Обмен ДНК с роем", sort_list(names))
	if(!chosen_name)
		return

	var/datum/changelingprofile/chosen_dna = changeling.get_dna(chosen_name)
	if(!chosen_dna)
		return

	var/datum/changelingprofile/uploaded_dna = new chosen_dna.type
	chosen_dna.copy_profile(uploaded_dna)
	GLOB.hivemind_bank += uploaded_dna
	to_chat(user, span_notice("Мы рассеиваем ДНК <b>[chosen_name]</b> по воздуху."))
	return TRUE

/datum/action/changeling/hivemind_download
	name = "Поглощение ДНК из роя"
	desc = "Позволяет нам поглощать ДНК, которая была направлена в эфир. Не учитывает поглощение целей. Стоит 10 химикатов."
	button_icon_state = "hive_absorb"
	chemical_cost = 10
	dna_cost = -1

/datum/action/changeling/hivemind_download/can_sting(mob/living/carbon/user)
	if(!..())
		return
	if (HAS_TRAIT(user, CHANGELING_HIVEMIND_MUTE))
		to_chat(user, span_warning("Яд в воздухе препятствует нашей способности взаимодействовать с роем."))
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/datum/changelingprofile/first_prof = changeling.stored_profiles[1]
	if(first_prof.name == user.real_name)//If our current DNA is the stalest, we gotta ditch it.
		to_chat(user, span_warning("Мы достигли максимума хранения ДНК! Нам нужно трансформироваться перед поглощением новых."))
		return
	return 1

/datum/action/changeling/hivemind_download/sting_action(mob/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/list/names = list()
	for(var/datum/changelingprofile/prof in GLOB.hivemind_bank)
		if(!(prof in changeling.stored_profiles))
			names[prof.name] = prof

	if(names.len <= 0)
		to_chat(user, span_warning("Похоже ещё никто не делился ДНК!"))
		return

	var/S = tgui_input_list(usr, "Какое ДНК мы поглотим сегодня: ", "Поглощение ДНК", sort_list(names))
	if(!S)
		return
	var/datum/changelingprofile/chosen_prof = names[S]
	if(!chosen_prof)
		return
	..()
	if(!(changeling.has_dna(chosen_prof.dna)))
		chosen_prof.copy_profile(chosen_prof)
		changeling.add_profile(chosen_prof)
		to_chat(user, span_notice("Мы поглощаем днк <b>[S]</b> из воздуха."))
	else
		to_chat(user, span_notice("У нас уже есть это ДНК в хранилище."))
		return
	return TRUE
