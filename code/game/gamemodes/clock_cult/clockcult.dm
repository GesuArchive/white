GLOBAL_LIST_EMPTY(servants_of_ratvar)	//List of minds in the cult
GLOBAL_LIST_EMPTY(all_servants_of_ratvar)	//List of minds in the cult
GLOBAL_LIST_EMPTY(human_servants_of_ratvar)	//Humans in the cult
GLOBAL_LIST_EMPTY(cyborg_servants_of_ratvar)

GLOBAL_VAR(ratvar_arrival_tick)	//The world.time that Ratvar will arrive if the gateway is not disrupted

GLOBAL_VAR_INIT(installed_integration_cogs, 0)

GLOBAL_VAR(celestial_gateway)	//The celestial gateway
GLOBAL_VAR_INIT(ratvar_risen, FALSE)	//Has ratvar risen?
GLOBAL_VAR_INIT(gateway_opening, FALSE)	//Is the gateway currently active?

//A useful list containing all scriptures with the index of the name.
//This should only be used for looking up scriptures
GLOBAL_LIST_EMPTY(clockcult_all_scriptures)

GLOBAL_VAR_INIT(clockcult_power, 2500)
GLOBAL_VAR_INIT(clockcult_vitality, 200)

GLOBAL_VAR(clockcult_eminence)

//==========================
//===Clock cult Gamemode ===
//==========================

/datum/game_mode/clockcult
	name = "clockcult"
	config_tag = "clockcult"
	report_type = "clockcult"
	false_report_weight = 5
	required_players = 24
	required_enemies = 4
	recommended_enemies = 4
	antag_flag = ROLE_SERVANT_OF_RATVAR
	enemy_minimum_age = 14

	announce_span = "danger"
	announce_text = "A powerful group of fanatics is trying to summon their deity!\n\
	<span class='danger'>Servants</span>: Convert more servants and defend the Ark of the Clockwork Justicar!\n\
	<span class='notice'>Crew</span>: Prepare yourselfs and destroy the Ark of the Clockwork Justicar."


	var/clock_cultists = CLOCKCULT_SERVANTS
	var/list/selected_servants = list()

	var/datum/team/clock_cult/main_cult

/datum/game_mode/clockcult/setup_maps()
	//Since we are loading in pre_setup, disable map loading.
	LoadReebe()
	return TRUE

/datum/game_mode/clockcult/pre_setup()
	setup_maps()
	//Generate cultists
	for(var/i in 1 to clock_cultists)
		if(!antag_candidates.len)
			break
		var/datum/mind/clockie = antag_pick(antag_candidates, ROLE_SERVANT_OF_RATVAR)
		//In case antag_pick breaks
		if(!clockie)
			continue
		antag_candidates -= clockie
		selected_servants += clockie
		clockie.assigned_role = ROLE_SERVANT_OF_RATVAR
		clockie.special_role = ROLE_SERVANT_OF_RATVAR
	generate_clockcult_scriptures()
	return TRUE

/datum/game_mode/clockcult/post_setup(report)
	var/list/spawns = GLOB.servant_spawns.Copy()
	main_cult = new
	main_cult.setup_objectives()
	//Create team
	for(var/datum/mind/servant_mind in selected_servants)
		//Somehow the mind has no mob, ignore them so it doesn't break everything
		if(!(servant_mind?.current))
			continue
		//Somehow all spawns where used, reuse old spawns
		if(!length(spawns))
			spawns = GLOB.servant_spawns.Copy()
		servant_mind.current.forceMove(pick_n_take(spawns))
		servant_mind.current.set_species(/datum/species/human)
		var/datum/antagonist/servant_of_ratvar/S = add_servant_of_ratvar(servant_mind.current, team=main_cult)
		S.equip_carbon(servant_mind.current)
		S.equip_servant()
		S.prefix = CLOCKCULT_PREFIX_MASTER
	//Setup the conversion limits for auto opening the ark
	calculate_clockcult_values()
	return ..()

/datum/game_mode/clockcult/generate_report()
	return "Подразделение Центрального Командования по делам высших измерений недавно исследовало огромный аномальный всплеск энергии, исходящий от нейтронной звезды недалеко от сектора. В настоящее время предполагается, что древняя группа фанатиков, восхваляющая \
	жуткое божество, сделанное из латуни и других устаревших материалов, злоупотребляет энергией умирающей звезды, чтобы нарушить границы измерений. Завеса синего космоса в вашем текущем местоположении срывается, что делает его главной целью для опасных людей, \
	злоупотребляющих пространственным запретом. О любых доказательствах взлома блюспейс-полей следует сообщать вашему местному капеллану и центральному командованию, если соединение все еще доступно на момент обнаружения."

/datum/game_mode/clockcult/set_round_result()
	..()
	if(check_cult_victory())
		SSticker.mode_result = "win - clockcult win"
		SSticker.news_report = CLOCK_SUMMON
	else if(LAZYLEN(GLOB.cyborg_servants_of_ratvar))
		SSticker.mode_result = "loss - staff destroyed the ark"
		SSticker.news_report = CLOCK_SILICONS
	else
		SSticker.mode_result = "loss - staff destroyed the ark"
		SSticker.news_report = CLOCK_PROSELYTIZATION

/datum/game_mode/clockcult/check_finished(force_ending)
	return force_ending

/datum/game_mode/clockcult/proc/check_cult_victory()
	return GLOB.ratvar_risen

//==========================
//==== Clock cult procs ====
//==========================

/proc/is_servant_of_ratvar(mob/living/M)
	return M?.mind?.has_antag_datum(/datum/antagonist/servant_of_ratvar)

//Similar to cultist one, except silicons are allowed
/proc/is_convertable_to_clockcult(mob/living/M)
	if(!istype(M))
		return FALSE
	if(!M.mind)
		return FALSE
	if(ishuman(M) && (M.mind.assigned_role in list(JOB_CAPTAIN, JOB_CHAPLAIN)))
		return FALSE
	if(istype(M.get_item_by_slot(ITEM_SLOT_HEAD), /obj/item/clothing/head/foilhat))
		return FALSE
	if(is_servant_of_ratvar(M))
		return FALSE
	if(M.mind.enslaved_to && !is_servant_of_ratvar(M.mind.enslaved_to))
		return FALSE
	if(M.mind.unconvertable)
		return FALSE
	if(iscultist(M) || isconstruct(M) || ispAI(M))
		return FALSE
	if(HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return FALSE
	return TRUE

/proc/generate_clockcult_scriptures()
	//Generate scriptures
	for(var/categorypath in subtypesof(/datum/clockcult/scripture))
		var/datum/clockcult/scripture/S = new categorypath
		GLOB.clockcult_all_scriptures[S.name] = S

/proc/flee_reebe()
	for(var/mob/living/M in GLOB.mob_list)
		if(!is_reebe(M.z))
			continue
		var/safe_place = find_safe_turf()
		M.forceMove(safe_place)
		if(!is_servant_of_ratvar(M))
			M.SetSleeping(50)

//Transmits a message to everyone in the cult
//Doesn't work if the cultists contain holy water, or are not on the station or Reebe
//TODO: SANITIZE MESSAGES WITH THE NORMAL SAY STUFF (punctuation)
/proc/hierophant_message(msg, mob/living/sender, span = "<span class='brass'>", use_sanitisation=TRUE, say=TRUE)
	var/hierophant_message = "[span]"
	if(sender?.reagents)
		if(sender.reagents.has_reagent(/datum/reagent/water/holywater, 1))
			to_chat(sender, span_nezbere("[pick("You fail to transmit your cries for help.", "Your calls into the void go unanswered.", "You try to transmit your message, but the hierophant network is silent.")]"))
			return FALSE
	if(!msg)
		if(sender)
			to_chat(sender, span_brass("Не выходит!"))
		return FALSE
	if(use_sanitisation)
		msg = sanitize(msg)
	if(sender)
		if(say)
			INVOKE_ASYNC(sender, TYPE_PROC_REF(/atom/movable, say), "#[text2ratvar(msg)]")
		msg = sender.treat_message(msg)
		var/datum/antagonist/servant_of_ratvar/SoR = is_servant_of_ratvar(sender)
		var/prefix = "Механический брат"
		switch(SoR.prefix)
			if(CLOCKCULT_PREFIX_EMINENCE)
				prefix = "Мастер"
			if(CLOCKCULT_PREFIX_MASTER)
				prefix = sender.gender == MALE\
					? "Механический отец"\
					: sender.gender == FEMALE\
						? "Механическая мать"\
						: "Механический мастер"
				hierophant_message = "<span class='leader_brass'>"
			if(CLOCKCULT_PREFIX_RECRUIT)
				var/role = sender.mind?.assigned_role
				//Ew, this could be done better with a dictionary list, but this isn't much slower
				if(role in GLOB.command_positions)
					prefix = "Высший служитель"
				else if(role in GLOB.engineering_positions)
					prefix = "Поворачиватель"
				else if(role in GLOB.medical_positions)
					prefix = "Воскрешатель"
				else if(role in GLOB.science_positions)
					prefix = "Калькулятор"
				else if(role in GLOB.supply_positions)
					prefix = "Следопыт"
				else if(role in JOB_ASSISTANT)
					prefix = "Помощник"
				else if(role in JOB_MIME)
					prefix = "Смотрящий за шестерёнками"
				else if(role in JOB_CLOWN)
					prefix = "Шестехонкер"
				else if(role in GLOB.security_positions)
					prefix = "Воин"
				else if(role in GLOB.scum_positions)
					prefix = "Вор"
				else if(role in GLOB.nonhuman_positions)
					prefix = "ПРОЦЕССОР"
			//Fallthrough is default of "Clockbrother"
		hierophant_message += "<b>[prefix] [sender.name]</b> передаёт, \"[msg]\""
	else
		hierophant_message += msg
	if(span)
		hierophant_message += "</span>"
	for(var/datum/mind/mind in GLOB.all_servants_of_ratvar)
		send_hierophant_message_to(mind, hierophant_message)
	for(var/mob/dead/observer/O in GLOB.dead_mob_list)
		if(istype(sender))
			to_chat(O, "[FOLLOW_LINK(O, sender)] [hierophant_message]")
		else
			to_chat(O, hierophant_message)

/proc/send_hierophant_message_to(datum/mind/mind, hierophant_message)
	var/mob/M = mind.current
	if(!isliving(M) || QDELETED(M))
		return
	if(M.reagents)
		if(M.reagents.has_reagent(/datum/reagent/water/holywater, 1))
			if(pick(20))
				to_chat(M, span_nezbere("Слышу как шепчут шестерни, но ничего не могу понять."))
			return
	to_chat(M, hierophant_message)
