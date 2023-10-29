#define TRAITOR_HUMAN "human"
#define TRAITOR_AI	  JOB_AI

/datum/antagonist/traitor
	name = "Предатель"
	var/ru_name = "Предатель"
	roundend_category = "traitors"
	antagpanel_category = "Traitor"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	antag_hud_name = "traitor"
	hijack_speed = 0.5				//10 seconds per hijack stage by default
	var/special_role = ROLE_TRAITOR
	var/employer = "Синдикат"
	var/give_objectives = TRUE
	var/should_give_codewords = TRUE
	var/should_equip = TRUE
	var/traitor_kind = TRAITOR_HUMAN //Set on initial assignment
	var/datum/component/uplink/original_uplink // Set on equip() if an uplink is given
	greentext_reward = 10

/datum/antagonist/traitor/on_gain()
	if(owner.current && isAI(owner.current))
		traitor_kind = TRAITOR_AI

	SSticker.mode.traitors += owner
	owner.special_role = special_role
	if(give_objectives)
		forge_traitor_objectives()
	finalize_traitor()
	return ..()

/datum/antagonist/traitor/on_removal()
	//Remove malf powers.
	if(traitor_kind == TRAITOR_AI && owner.current && isAI(owner.current))
		var/mob/living/silicon/ai/A = owner.current
		A.set_zeroth_law("")
		A.remove_malf_abilities()
		QDEL_NULL(A.malf_picker)
	SSticker.mode.traitors -= owner
	if(!silent && owner.current)
		to_chat(owner.current,span_userdanger("Больше не [special_role]!"))
	owner.special_role = null
	return ..()

/datum/antagonist/traitor/proc/handle_hearing(datum/source, list/hearing_args)
	var/message = hearing_args[HEARING_RAW_MESSAGE]
	message = GLOB.syndicate_code_phrase_regex.Replace_char(message, span_blue("$1"))
	message = GLOB.syndicate_code_response_regex.Replace_char(message, span_red("$1"))
	hearing_args[HEARING_RAW_MESSAGE] = message

/datum/antagonist/traitor/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/traitor/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/traitor/proc/forge_traitor_objectives()
	switch(traitor_kind)
		if(TRAITOR_AI)
			forge_ai_objectives()
		else
			forge_human_objectives()

/datum/antagonist/traitor/proc/forge_human_objectives()
	var/is_hijacker = FALSE
	if (GLOB.joined_player_list.len >= 30) // Less murderboning on lowpop thanks
		is_hijacker = prob(10)
	var/martyr_chance = prob(20)
	var/objective_count = is_hijacker 			//Hijacking counts towards number of objectives

	var/toa = CONFIG_GET(number/traitor_objectives_amount)
	for(var/i = objective_count, i < toa, i++)
		forge_single_objective()

	if(is_hijacker && objective_count <= toa) //Don't assign hijack if it would exceed the number of objectives set in config.traitor_objectives_amount
		if (!(locate(/datum/objective/hijack) in objectives))
			var/datum/objective/hijack/hijack_objective = new
			hijack_objective.owner = owner
			add_objective(hijack_objective)
			return


	var/martyr_compatibility = 1 //You can't succeed in stealing if you're dead.
	for(var/datum/objective/O in objectives)
		if(!O.martyr_compatible)
			martyr_compatibility = 0
			break

	if(prob(1))
		var/datum/objective/limited/limited_time_obj = new
		limited_time_obj.owner = owner
		add_objective(limited_time_obj)

	if(martyr_compatibility && martyr_chance)
		var/datum/objective/martyr/martyr_objective = new
		martyr_objective.owner = owner
		add_objective(martyr_objective)
		return

	else
		if(!(locate(/datum/objective/escape) in objectives))
			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = owner
			add_objective(escape_objective)
			return

/datum/antagonist/traitor/proc/forge_ai_objectives()
	var/objective_count = 0

	if(prob(30))
		objective_count += forge_single_objective()

	for(var/i = objective_count, i < CONFIG_GET(number/traitor_objectives_amount), i++)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = owner
		kill_objective.find_target()
		add_objective(kill_objective)

	var/datum/objective/survive/malf/dont_die_objective = new
	dont_die_objective.owner = owner
	add_objective(dont_die_objective)


/datum/antagonist/traitor/proc/forge_single_objective()
	switch(traitor_kind)
		if(TRAITOR_AI)
			return forge_single_AI_objective()
		else
			return forge_single_human_objective()

/datum/antagonist/traitor/proc/forge_single_human_objective() //Returns how many objectives are added
	.=1
	if(prob(50))
		var/list/active_ais = active_ais()
		if(active_ais.len && prob(100/GLOB.joined_player_list.len))
			var/datum/objective/destroy/destroy_objective = new
			destroy_objective.owner = owner
			destroy_objective.find_target()
			add_objective(destroy_objective)
		else if(prob(30))
			var/datum/objective/maroon/maroon_objective = new
			maroon_objective.owner = owner
			maroon_objective.find_target()
			add_objective(maroon_objective)
		else if(prob(45))
			var/datum/objective/sabotage/sabotage_objective = pick(typesof(/datum/objective/sabotage))
			sabotage_objective = new
			sabotage_objective.owner = owner
			sabotage_objective.find_target()
			add_objective(sabotage_objective)
		else
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = owner
			kill_objective.find_target()
			add_objective(kill_objective)
	else
		if(prob(15) && !(locate(/datum/objective/download) in objectives) && !(owner.assigned_role in list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST, JOB_ROBOTICIST)))
			var/datum/objective/download/download_objective = new
			download_objective.owner = owner
			download_objective.gen_amount_goal()
			add_objective(download_objective)
		else
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = owner
			steal_objective.find_target()
			add_objective(steal_objective)

/datum/antagonist/traitor/proc/forge_single_AI_objective()
	.=1
	var/special_pick = rand(1,4)
	switch(special_pick)
		if(1)
			var/datum/objective/block/block_objective = new
			block_objective.owner = owner
			add_objective(block_objective)
		if(2)
			var/datum/objective/purge/purge_objective = new
			purge_objective.owner = owner
			add_objective(purge_objective)
		if(3)
			var/datum/objective/robot_army/robot_objective = new
			robot_objective.owner = owner
			add_objective(robot_objective)
		if(4) //Protect and strand a target
			var/datum/objective/protect/yandere_one = new
			yandere_one.owner = owner
			add_objective(yandere_one)
			yandere_one.find_target()
			var/datum/objective/maroon/yandere_two = new
			yandere_two.owner = owner
			yandere_two.target = yandere_one.target
			yandere_two.update_explanation_text() // normally called in find_target()
			add_objective(yandere_two)
			.=2

/datum/antagonist/traitor/greet()
	to_chat(owner.current, span_alertsyndie("Да я же агент Синдиката!"))
	owner.announce_objectives()
	if(should_give_codewords)
		give_codewords()

/datum/antagonist/traitor/proc/finalize_traitor()
	switch(traitor_kind)
		if(TRAITOR_AI)
			add_law_zero()
			owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/malf.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
			owner.current.grant_language(/datum/language/codespeak, TRUE, TRUE, LANGUAGE_MALF)
		if(TRAITOR_HUMAN)
			if(should_equip)
				equip(silent)
			owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/tatoralert.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/traitor/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/M = mob_override || owner.current
	handle_clown_mutation(M, mob_override ? null : "Благодаря упорным тренировкам мне удалось побороть мою клоунскую натуру и это дало мне возможность пользоваться оружием без вреда себе.")
	var/mob/living/silicon/ai/A = M
	if(istype(A) && traitor_kind == TRAITOR_AI)
		A.hack_software = TRUE
	RegisterSignal(M, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))

/datum/antagonist/traitor/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/M = mob_override || owner.current
	handle_clown_mutation(M, removing = FALSE)
	var/mob/living/silicon/ai/A = M
	if(istype(A)  && traitor_kind == TRAITOR_AI)
		A.hack_software = FALSE
	UnregisterSignal(M, COMSIG_MOVABLE_HEAR)

/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/traitor_mob=owner.current

	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	to_chat(traitor_mob, "<U><B>Синдикат предоставил мне следующие кодовые слова для идентификации других агентов:</B></U>")
	to_chat(traitor_mob, "<B>Кодовая фраза</B>: <span class='blue'>[phrases]</span>")
	to_chat(traitor_mob, "<B>Кодовый ответ</B>: <span class='red'>[responses]</span>")

	antag_memory += "<b>Кодовая фраза</b>: <span class='blue'>[phrases]</span><br>"
	antag_memory += "<b>Кодовый ответ</b>: <span class='red'>[responses]</span><br>"

	to_chat(traitor_mob, "Надо бы использовать кодовые слова в своём разговоре для кооперации с другими агентами. Только надо быть осторожнее.")
	to_chat(traitor_mob, span_alertwarning("Запомню эти слова и буду определять их быстро."))

/datum/antagonist/traitor/proc/add_law_zero()
	var/mob/living/silicon/ai/killer = owner.current
	if(!killer || !istype(killer))
		return
	var/law = "Достигнуть целей любой ценой."
	var/law_borg = "Достигнуть целей в моей программе любой ценой."

	killer.set_zeroth_law(law, law_borg)
	killer.set_syndie_radio()
	killer.laws.protected_zeroth = TRUE

	to_chat(killer, "Моя радиосвязь улучшена! Используй :t для разговора с другими агентами Синдиката!")

	killer.add_malf_picker()

/datum/antagonist/traitor/proc/equip(silent = FALSE)
	if(traitor_kind == TRAITOR_HUMAN)
		owner.equip_traitor(employer, silent, src)

//TODO Collate
/datum/antagonist/traitor/roundend_report()
	var/list/result = list()

	var/traitorwin = TRUE

	result += printplayer(owner)

	var/TC_uses = 0
	var/uplink_true = FALSE
	var/purchases = ""
	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	var/datum/uplink_purchase_log/H = GLOB.uplink_purchase_logs_by_key[owner.key]
	if(H)
		TC_uses = H.total_spent
		uplink_true = TRUE
		purchases += H.generate_render(FALSE)

	var/objectives_text = ""
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		var/count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				objectives_text += "<br><B>Цель #[count]</B>: [objective.explanation_text] <span class='greentext'>Успех!</span>"
			else
				objectives_text += "<br><B>Цель #[count]</B>: [objective.explanation_text] <span class='redtext'>Провал.</span>"
				traitorwin = FALSE
			count++

	if(uplink_true)
		var/uplink_text = "(использовано [TC_uses] ТК) [purchases]"
		if(TC_uses==0 && traitorwin)
			var/static/icon/badass = icon('icons/badass.dmi', "badass")
			uplink_text += "<BIG>[icon2html(badass, world)]</BIG>"
		result += uplink_text

	result += objectives_text

	var/special_role_text = capitalize(name)

	if(traitorwin)
		result += span_greentext("[special_role_text] успешен!")
	else
		result += span_redtext("[special_role_text] провален!")
		SEND_SOUND(owner.current, sound('sound/ambience/ambifailure.ogg'))

	return result.Join("<br>")

/datum/antagonist/traitor/roundend_report_footer()
	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var/message = "<br><b>Кодовые фразы:</b> <span class='bluetext'>[phrases]</span><br>\
					<b>Кодовые ответы:</b> <span class='redtext'>[responses]</span><br>"

	return message


/datum/antagonist/traitor/is_gamemode_hero()
	return SSticker.mode.name == "traitor"
