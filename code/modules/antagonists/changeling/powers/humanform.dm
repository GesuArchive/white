/datum/action/changeling/humanform
	name = "Человеческая форма"
	desc = "Мы превращаемся в человека. Стоит 5 химикатов."
	button_icon_state = "human_form"
	chemical_cost = 5
	req_dna = 1

//Transform into a human.
/datum/action/changeling/humanform/sting_action(mob/living/carbon/user)
	if(user.movement_type & VENTCRAWLING)
		to_chat(user, span_notice("Мы должны выйти из труб, прежде чем сможем вернуть форму!"))
		return FALSE
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/list/names = list()
	for(var/datum/changelingprofile/prof in changeling.stored_profiles)
		names += "[prof.name]"

	var/chosen_name = tgui_input_list(usr, "Выбираем ДНК: ", "Целевое ДНК", sort_list(names))
	if(!chosen_name)
		return

	var/datum/changelingprofile/chosen_prof = changeling.get_dna(chosen_name)
	if(!chosen_prof)
		return
	if(!user || user.notransform)
		return FALSE
	to_chat(user, span_notice("Трансформируем нашу внешность."))
	..()
	changeling.purchasedpowers -= src

	var/newmob = user.humanize()

	changeling_transform(newmob, chosen_prof)
	return TRUE
