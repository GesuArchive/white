/mob/living/carbon/human/examine(mob/user)
//this is very slightly better than it was because you can use it more places. still can't do \his[src] though.
	var/t_on 	= ru_who(TRUE)
	var/t_ego 	= ru_ego()
	var/t_na 	= ru_na()
	var/t_a 	= ru_a()

	var/obscure_name
	var/true_info = FALSE

	if(isliving(user))
		var/mob/living/L = user
		if(HAS_TRAIT(L, TRAIT_PROSOPAGNOSIA) || HAS_TRAIT(L, TRAIT_INVISIBLE_MAN))
			obscure_name = TRUE

	if(IS_DREAMER(user) && user != src)
		true_info = TRUE

	. = list("")

	if(true_info)
		. += "<span class='info'>Это же <EM>отвратительная свинья</EM>.<hr>"
	else
		var/racetext
		if (ishuman(user))
			var/mob/living/carbon/human/human_user = user
			racetext = get_race_text(human_user.skin_tone)
		. += "<span class='info'>Это же <EM>[!obscure_name ? name : "Неизвестный"]</EM>, [racetext ? "<big class='interface'>[racetext]</big>" : "[get_age_text()]"]!<hr>"

	if(user?.stat == CONSCIOUS && ishuman(user))
		user.visible_message(span_small("<b>[user]</b> смотрит на <b>[!obscure_name ? name : "Неизвестного"]</b>.") , span_small("Смотрю на <b>[!obscure_name ? name : "Неизвестного"]</b>.") , null, COMBAT_MESSAGE_RANGE)

	var/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))

	if(get_bodypart(BODY_ZONE_HEAD) && !skipface)
		var/obj/item/bodypart/head/O = locate(/obj/item/bodypart/head) in bodyparts
		if(O)
			if(O.get_teeth() < O.max_teeth)
				. += "<span class='warning'>Не хватает [O.max_teeth - O.get_teeth()] зубов!</span>\n"

	if(headstamp && !(obscured & ITEM_SLOT_HEAD))
		. += "У н[t_ego] на лбу написано <b>[headstamp]</b>. Круто.\n"

	//head
	if(head && !(obscured & ITEM_SLOT_HEAD) && !(head.item_flags & EXAMINE_SKIP))
		. += "На голове у н[t_ego] [head.get_examine_string(user)].\n"

	//eyes
	if(!(obscured & ITEM_SLOT_EYES) )
		if(glasses  && !(glasses.item_flags & EXAMINE_SKIP))
			. += "Также на [t_na] [glasses.get_examine_string(user)].\n"
		else if(eye_color_left == BLOODCULT_EYE)
			if(IS_CULTIST(src) && HAS_TRAIT(src, TRAIT_CULT_EYES))
				. += "<span class='warning'><B>[ru_ego(TRUE)] глаза ярко-красные и они горят!</B></span>\n"
			else if(HAS_TRAIT(src, TRAIT_BLOODSHOT_EYES))
				. += "<span class='warning'><B>[ru_ego(TRUE)] глаза красные!</B></span>\n"

	//ears
	if(ears && !(obscured & ITEM_SLOT_EARS) && !(ears.item_flags & EXAMINE_SKIP))
		. += "В ушах у н[t_ego] есть [ears.get_examine_string(user)].\n"

	//mask
	if(wear_mask && !(obscured & ITEM_SLOT_MASK)  && !(wear_mask.item_flags & EXAMINE_SKIP))
		. += "На лице у н[t_ego] [wear_mask.get_examine_string(user)].\n"

	if(wear_neck && !(obscured & ITEM_SLOT_NECK)  && !(wear_neck.item_flags & EXAMINE_SKIP))
		. += "На шее у н[t_ego] [wear_neck.get_examine_string(user)].\n"

	//suit/armor
	if(wear_suit && !(wear_suit.item_flags & EXAMINE_SKIP))
		//suit/armor storage
		var/suit_thing
		if(s_store && !(obscured & ITEM_SLOT_SUITSTORE) && !(s_store.item_flags & EXAMINE_SKIP))
			suit_thing += " вместе с [s_store.get_examine_string(user)]"

		. += "На [t_na] надет [wear_suit.get_examine_string(user)][suit_thing].\n"

	//uniform
	if(w_uniform && !(obscured & ITEM_SLOT_ICLOTHING) && !(w_uniform.item_flags & EXAMINE_SKIP))
		//accessory
		var/accessory_msg
		if(istype(w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.attached_accessory)
				accessory_msg += " с [icon2html(U.attached_accessory, user)] [U.attached_accessory]"

		. += "Одет[t_a] он[t_a] в [w_uniform.get_examine_string(user)][accessory_msg].\n"

	//back
	if(back && !(back.item_flags & EXAMINE_SKIP))
		. += "Со спины у н[t_ego] свисает [back.get_examine_string(user)].\n"

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT) && !(I.item_flags & EXAMINE_SKIP))
			. += "В [get_held_index_name(get_held_index_of_item(I))] он[t_a] держит [I.get_examine_string(user)].\n"

	//gloves
	if(gloves && !(obscured & ITEM_SLOT_GLOVES) && !(gloves.item_flags & EXAMINE_SKIP))
		. += "А на руках у н[t_ego] [gloves.get_examine_string(user)].\n"
	else if(GET_ATOM_BLOOD_DNA_LENGTH(src))
		if(num_hands)
			. += "<span class='warning'>[ru_ego(TRUE)] рук[num_hands > 1 ? "и" : "а"] также в крови!</span>\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/restraints/handcuffs/cable))
			. += "<span class='warning'>[t_on] [icon2html(handcuffed, user)] связан[t_a]!</span>\n"
		else
			. += "<span class='warning'>[t_on] [icon2html(handcuffed, user)] в наручниках!</span>\n"

	//belt
	if(belt && !(belt.item_flags & EXAMINE_SKIP))
		. += "И ещё на поясе у н[t_ego] [belt.get_examine_string(user)].\n"

	//shoes
	if(shoes && !(obscured & ITEM_SLOT_FEET)  && !(shoes.item_flags & EXAMINE_SKIP))
		. += "А на [t_ego] ногах [shoes.get_examine_string(user)].\n"

	//ID
	if(wear_id && !(wear_id.item_flags & EXAMINE_SKIP))
		. += "И конечно же у н[t_ego] есть [wear_id.get_examine_string(user)].\n"

	. += "<hr>"

	//Status effects
	var/list/status_examines = status_effect_examines()
	if (length(status_examines))
		. += status_examines

	//Jitters
	switch(jitteriness)
		if(300 to INFINITY)
			. += "<span class='warning'><B>[t_on] бьётся в судорогах!</B></span>\n"
		if(200 to 300)
			. += "<span class='warning'>[t_on] нервно дёргается.</span>\n"
		if(100 to 200)
			. += "<span class='warning'>[t_on] дрожит.</span>\n"

	var/appears_dead = FALSE
	var/just_sleeping = FALSE
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE
		if(isliving(user) && HAS_TRAIT(user, TRAIT_NAIVE))
			just_sleeping = TRUE
		if(!just_sleeping)
			if(suiciding)
				. += "<span class='warning'>[t_on] выглядит как суицидник... [t_ego] уже невозможно спасти.</span>\n"
			if(hellbound)
				. += span_warning("[t_ego] душа выглядит вырванной из [t_ego] тела. Воскрешение невозможно.")

			. += generate_death_examine_text()

	if(get_bodypart(BODY_ZONE_HEAD) && !getorgan(/obj/item/organ/brain))
		. += "<span class='deadsay'>Похоже, что у н[t_ego] нет мозга...</span>\n"

	var/list/msg = list()

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/list/disabled = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/body_part = X
		if(body_part.bodypart_disabled)
			disabled += body_part
		missing -= body_part.body_zone
		for(var/obj/item/I in body_part.embedded_objects)
			if(I.isEmbedHarmless())
				msg += "<B>Из [t_ego] [body_part.name] торчит [icon2html(I, user)] [I]!</B>\n"
			else
				msg += "<B>У н[t_ego] застрял [icon2html(I, user)] [I] в [body_part.name]!</B>\n"

		for(var/i in body_part.wounds)
			var/datum/wound/iter_wound = i
			msg += "[iter_wound.get_examine_description(user)]\n"

	for(var/X in disabled)
		var/obj/item/bodypart/body_part = X
		var/damage_text
		if(HAS_TRAIT(body_part, TRAIT_DISABLED_BY_WOUND))
			continue // skip if it's disabled by a wound (cuz we'll be able to see the bone sticking out!)
		if(!(body_part.get_damage(include_stamina = FALSE) >= body_part.max_damage)) //we don't care if it's stamcritted
			damage_text = "выглядит бледновато"
		else
			damage_text = (body_part.brute_dam >= body_part.burn_dam) ? body_part.heavy_brute_msg : body_part.heavy_burn_msg
		msg += "<B>[ru_ego(TRUE)] [body_part.name] [damage_text]!</B>\n"

	//stores missing limbs
	var/l_limbs_missing = 0
	var/r_limbs_missing = 0
	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			msg += "<span class='deadsay'><B>[ru_ego(TRUE)] [ru_exam_parse_zone(parse_zone(t))] отсутствует!</B></span>\n"
			continue
		if(t == BODY_ZONE_L_ARM || t == BODY_ZONE_L_LEG)
			l_limbs_missing++
		else if(t == BODY_ZONE_R_ARM || t == BODY_ZONE_R_LEG)
			r_limbs_missing++

		msg += "<span class='warning'><B>[ru_ego(TRUE)] [ru_exam_parse_zone(parse_zone(t))] отсутствует!</B></span>\n"

	if(l_limbs_missing >= 2 && r_limbs_missing == 0)
		msg += "[t_on] стоит на правой части.\n"
	else if(l_limbs_missing == 0 && r_limbs_missing >= 2)
		msg += "[t_on] стоит на левой части.\n"
	else if(l_limbs_missing >= 2 && r_limbs_missing >= 2)
		msg += "[t_on] выглядит как котлетка.\n"

	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		var/temp
		if(user == src && src.hal_screwyhud == SCREWYHUD_CRIT)//fake damage
			temp = 50
		else
			temp = getBruteLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] имеет незначительные ушибы.\n"
			else if(temp < 50)
				msg += "[t_on] <b>тяжело</b> ранен[t_a]!\n"
			else
				msg += "<B>[t_on] смертельно ранен[t_a]!</B>\n"

		temp = getFireLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] немного подгорел[t_a].\n"
			else if (temp < 50)
				msg += "[t_on] имеет <b>серьёзные</b> ожоги!\n"
			else
				msg += "<B>[t_on] имеет смертельные ожоги!</B>\n"

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_on] имеет незначительные подтёки на теле.\n"
			else if(temp < 50)
				msg += "[t_on] имеет <b>обвисшую</b> кожу на большей части тела!\n"
			else
				msg += "<b>[t_on] имеет тело состоящее из кусков свисающей плоти!</b>\n"


	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks))
		msg += "[t_on] в чем-то горючем.\n"
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[t_on] выглядит мокро.\n"


	if(pulledby?.grab_state)
		msg += "[t_on] удерживается захватом [pulledby].\n"

	if(nutrition < NUTRITION_LEVEL_STARVING - 50)
		msg += "[t_on] выглядит смертельно истощённо.\n"
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "[t_on] выглядит как толстенький, словно поросёнок. Очень вкусный поросёнок.\n"
		else
			msg += "[t_on] выглядит довольно плотно.\n"
	switch(disgust)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			msg += "[t_on] выглядит немного неприятно.\n"
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			msg += "[t_on] выглядит очень неприятно.\n"
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			msg += "[t_on] выглядит отвратительно.\n"

	if(blood_volume < BLOOD_VOLUME_SAFE || skin_tone == "albino")
		msg += "[ru_ego(TRUE)] кожа бледная.\n"

	if(is_bleeding())
		var/list/obj/item/bodypart/bleeding_limbs = list()
		var/list/obj/item/bodypart/grasped_limbs = list()

		for(var/i in bodyparts)
			var/obj/item/bodypart/body_part = i
			if(body_part.get_part_bleed_rate())
				bleeding_limbs += body_part
			if(body_part.grasped_by)
				grasped_limbs += body_part

		var/num_bleeds = LAZYLEN(bleeding_limbs)

		var/list/bleed_text
		if(appears_dead)
			bleed_text = list("<span class='deadsay'><B>Кровь брызгает струйками из [ru_ego(FALSE)]")
		else
			bleed_text = list("<B>[t_on] имеет кровотечение из [ru_ego(FALSE)]")

		switch(num_bleeds)
			if(1 to 2)
				bleed_text += " [ru_otkuda_zone(bleeding_limbs[1].name)][num_bleeds == 2 ? " и [ru_otkuda_zone(bleeding_limbs[2].name)]" : ""]"
			if(3 to INFINITY)
				for(var/i in 1 to (num_bleeds - 1))
					var/obj/item/bodypart/body_part = bleeding_limbs[i]
					bleed_text += " [ru_otkuda_zone(body_part.name)],"
				bleed_text += " и [ru_otkuda_zone(bleeding_limbs[num_bleeds].name)]"

		if(appears_dead)
			bleed_text += ", но очень медленно.</span></B>\n"
		else
			if(reagents.has_reagent(/datum/reagent/toxin/heparin, needs_metabolizing = TRUE))
				bleed_text += " невероятно быстро"

			bleed_text += "!</B>\n"

		for(var/i in grasped_limbs)
			var/obj/item/bodypart/grasped_part = i
			bleed_text += "[t_on] сжимает свою [grasped_part.name], пока из той течёт кровь!\n"

		msg += bleed_text.Join()

	if(reagents.has_reagent(/datum/reagent/teslium, needs_metabolizing = TRUE))
		msg += "[t_on] испускает нежное голубое свечение!\n"

	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[t_on] [stun_absorption[i]["examine_message"]]\n"

	if(just_sleeping)
		msg += "[t_on] похоже спит. Гы.\n"

	if(!appears_dead)
		if(drunkenness && !skipface) //Drunkenness
			switch(drunkenness)
				if(11 to 21)
					msg += "[t_on] немного пьян[t_a].\n"
				if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
					msg += "[t_on] пьян[t_a].\n"
				if(41.01 to 51)
					msg += "[t_on] довольно пьян[t_a] и от н[t_ego] чувствуется запах алкоголя.\n"
				if(51.01 to 61)
					msg += "Очень пьян[t_a] и от н[t_ego] несёт перегаром.\n"
				if(61.01 to 91)
					msg += "[t_on] в стельку.\n"
				if(91.01 to INFINITY)
					msg += "[t_on] в говно!\n"

		if(!user)
			return

		if(src != user)
			if (a_intent != INTENT_HELP)
				msg += "[t_on] выглядит на готове.\n"
			if (getOxyLoss() >= 10)
				msg += "[t_on] выглядит измотанно.\n"
			if (getToxLoss() >= 10)
				msg += "[t_on] выглядит болезненно.\n"
			var/datum/component/mood/mood = src.GetComponent(/datum/component/mood)
			if(mood.sanity <= SANITY_DISTURBED)
				msg += "[t_on] выглядит расстроено.\n"
			if (bodytemperature > dna.species.bodytemp_heat_damage_limit)
				msg += "[t_on] краснеет и хрипит.\n"
			if (bodytemperature < dna.species.bodytemp_cold_damage_limit)
				msg += "[t_on] дрожит.\n"
			if (HAS_TRAIT(src, TRAIT_BLIND))
				msg += "[t_on] смотрит в пустоту.\n"
			if (HAS_TRAIT(src, TRAIT_DEAF))
				msg += "[t_on] не реагирует на шум.\n"
			if(HAS_TRAIT(user, TRAIT_EMPATH))
				if(mood.sanity <= SANITY_DISTURBED)
					SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "empath", /datum/mood_event/sad_empath, src)
				if(mood.sanity >= SANITY_GREAT)
					SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "empath", /datum/mood_event/not_sad_empath, src)
			if(HAS_TRAIT(user, TRAIT_SPIRITUAL) && mind?.holy_role)
				msg += "От н[t_ego] веет святым духом.\n"
				SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "religious_comfort", /datum/mood_event/religiously_comforted)

		switch(stat)
			if(UNCONSCIOUS, HARD_CRIT)
				msg += "<span class='deadsay'>[t_on] не реагирует на происходящее вокруг.</span>\n"
			if(SOFT_CRIT)
				msg += "<span class='deadsay'>[t_on] едва в сознании.</span>\n"
			if(CONSCIOUS)
				if(HAS_TRAIT(src, TRAIT_DUMB))
					msg += "[t_on] имеет глупое выражение лица.\n"
		if(getorgan(/obj/item/organ/brain))
			if(ai_controller?.ai_status == AI_STATUS_ON)
				msg += "<span class='deadsay'>[t_on] выглядит не очень разумно.</span>\n"
			if(!key && !hide_client_absence)
				msg += "<span class='deadsay'>[t_on] кататоник. Стресс от жизни в глубоком космосе сильно повлиял на н[t_ego]. Восстановление маловероятно.</span>\n"
			else if(!client && !hide_client_absence)
				msg += "<span class='notice'>[t_on] имеет пустой, рассеянный взгляд и кажется совершенно не реагирующим ни на что. [t_on] может выйти из этого в ближайшее время.</span>\n"

	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		msg += trait_exam

	var/scar_severity = 0
	for(var/i in all_scars)
		var/datum/scar/S = i
		if(S.is_visible(user))
			scar_severity += S.severity

	switch(scar_severity)
		if(1 to 4)
			msg += span_smallnoticeital("\n[t_on] похоже имеет шрамы... Стоит присмотреться, чтобы разглядеть ещё.")
		if(5 to 8)
			msg += span_notice("\n<i>[t_on] имеет несколько серьёзных шрамов... Стоит присмотреться, чтобы разглядеть ещё.</i>")
		if(9 to 11)
			msg += span_notice("\n<b><i>[t_on] имеет множество ужасных шрамов... Стоит присмотреться, чтобы разглядеть ещё.</i></b>")
		if(12 to INFINITY)
			msg += span_notice("\n<b><i>[t_on] имеет разорванное в хлам тело состоящее из шрамов... Стоит присмотреться, чтобы разглядеть ещё?</i></b>")

	if (length(msg))
		. += span_warning("[msg.Join("")]")

	var/perpname = get_face_name(get_id_name(""))
	if(perpname && (HAS_TRAIT(user, TRAIT_SECURITY_HUD) || HAS_TRAIT(user, TRAIT_MEDICAL_HUD)))
		var/datum/data/record/R = find_record("name", perpname, GLOB.data_core.general)
		if(R)
			. += "<hr><span class='deptradio'>Должность:</span> [R.fields["rank"]]\n<a href='?src=[REF(src)];hud=1;photo_front=1'>\[Фото\]</a><a href='?src=[REF(src)];hud=1;photo_side=1'>\[Альт.\]</a>"
		if(HAS_TRAIT(user, TRAIT_MEDICAL_HUD))
			var/cyberimp_detect
			for(var/obj/item/organ/cyberimp/CI in internal_organs)
				if(CI.status == ORGAN_ROBOTIC && !CI.syndicate_implant)
					cyberimp_detect += "[!cyberimp_detect ? "[CI.get_examine_string(user)]" : ", [CI.get_examine_string(user)]"]\n"
			if(cyberimp_detect)
				. += "<hr><span class='notice ml-1'>Обнаружены кибернетические модификации:</span>\n"
				. += "<span class='notice ml-2'>[cyberimp_detect]</span>"
			if(R)
				var/health_r = R.fields["p_stat"]
				. += "<a href='?src=[REF(src)];hud=m;p_stat=1'>\[[health_r]\]</a>"
				health_r = R.fields["m_stat"]
				. += "<a href='?src=[REF(src)];hud=m;m_stat=1'>\[[health_r]\]</a>"
			R = find_record("name", perpname, GLOB.data_core.medical)
			if(R)
				. += "<a href='?src=[REF(src)];hud=m;evaluation=1'>\[Медицинское заключение\]</a><br>"
			. += "<a href='?src=[REF(src)];hud=m;quirk=1'>\[Признаки\]</a>"

		if(HAS_TRAIT(user, TRAIT_SECURITY_HUD))
			if(!user.stat && user != src)
			//|| !user.canmove || user.restrained()) Fluff: Sechuds have eye-tracking technology and sets 'arrest' to people that the wearer looks and blinks at.
				var/criminal = "None"

				R = find_record("name", perpname, GLOB.data_core.security)
				if(R)
					criminal = R.fields["criminal"]

				. += "<hr><span class='deptradio'>Статус:</span> <a href='?src=[REF(src)];hud=s;status=1'>\[[criminal]\]</a>\n"
				. += jointext(list("<span class='deptradio'>Заметки:</span> <a href='?src=[REF(src)];hud=s;view=1'>\[Показать\]</a>\n",
					"<a href='?src=[REF(src)];hud=s;add_citation=1'>\[Добавить цитату\]</a> ",
					"<a href='?src=[REF(src)];hud=s;add_crime=1'>\[Добавить нарушение\]</a>\n",
					"<a href='?src=[REF(src)];hud=s;view_comment=1'>\[Просмотреть комментарии\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_comment=1'>\[Добавить комментарий\]</a> "), "")
	else if(isobserver(user))
		. += "<hr><span class='info'><b>Черты:</b> [get_quirk_string()]</span>"
		if(HAS_TRAIT(src, TRAIT_CLIENT_LEAVED))
			. += "<hr><span class='boldnotice'>Это тело можно занять!</span>"

	if(true_info)
		var/obj/item/organ/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
		if(heart?.key_for_dreamer)
			. += span_revenbignotice("<hr>Оно ЗНАЕТ ключ [heart.key_for_dreamer]!")

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/proc/status_effect_examines(pronoun_replacement) //You can include this in any mob's examine() to show the examine texts of status effects!
	var/list/dat = list()
	if(!pronoun_replacement)
		pronoun_replacement = ru_who(TRUE)
	for(var/V in status_effects)
		var/datum/status_effect/E = V
		if(E.examine_text)
			var/new_text = replacetext_char(E.examine_text, "SUBJECTPRONOUN", pronoun_replacement)
			dat += "[new_text]\n" //dat.Join("\n") doesn't work here, for some reason
	if(dat.len)
		return dat.Join()

/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	if ((wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE)))
		return
	var/age_text
	switch(age)
		if(-INFINITY to 25)
			age_text = "очень молод[ru_aya()]"
		if(26 to 35)
			age_text = "молод[ru_aya()]"
		if(36 to 55)
			age_text = "среднего возраста"
		if(56 to 75)
			age_text = "достаточно взросл[ru_aya()]"
		if(76 to 100)
			if(gender == FEMALE)
				age_text = "старуха"
			else
				age_text = "старик"
		if(101 to INFINITY)
			age_text = "сейчас превратится в пыль"
	. += list(span_notice("<hr>[ru_who(TRUE)] на вид [age_text]."))
