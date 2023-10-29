/datum/antagonist/nukeop
	name = "Оперативник Синдиката"
	roundend_category = "syndicate operatives" //just in case
	antagpanel_category = "NukeOp"
	job_rank = ROLE_OPERATIVE
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE
	hijack_speed = 2 //If you can't take out the station, take the shuttle instead.
	var/datum/team/nuclear/nuke_team
	var/always_new_team = FALSE //If not assigned a team by default ops will try to join existing ones, set this to TRUE to always create new team.
	var/send_to_spawnpoint = TRUE //Should the user be moved to default spawnpoint.
	var/nukeop_outfit = /datum/outfit/syndicate
	greentext_reward = 10


/datum/antagonist/nukeop/proc/equip_op()
	if(!ishuman(owner.current))
		return
	var/mob/living/carbon/human/H = owner.current

	H.set_species(/datum/species/human) //Plasamen burn up otherwise, and lizards are vulnerable to asimov AIs

	H.equipOutfit(nukeop_outfit)
	return TRUE

/datum/antagonist/nukeop/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg', 100, 0, use_reverb = FALSE)
	to_chat(owner, span_notice("Да я же оперативник Синдиката!"))
	owner.announce_objectives()

/datum/antagonist/nukeop/on_gain()
	give_alias()
	forge_objectives()
	. = ..()
	equip_op()
	if(send_to_spawnpoint)
		move_to_spawnpoint()
		// grant extra TC for the people who start in the nukie base ie. not the lone op
		var/extra_tc = CEILING(GLOB.joined_player_list.len/5, 5)
		var/datum/component/uplink/U = owner.find_syndicate_uplink()
		if (U)
			U.telecrystals += extra_tc
	memorize_code()



/datum/antagonist/nukeop/get_team()
	return nuke_team

/datum/antagonist/nukeop/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current)

/datum/antagonist/nukeop/proc/assign_nuke()
	if(nuke_team && !nuke_team.tracked_nuke)
		nuke_team.memorized_code = random_nukecode()
		var/obj/machinery/nuclearbomb/syndicate/nuke = locate() in GLOB.nuke_list
		if(nuke)
			nuke_team.tracked_nuke = nuke
			if(nuke.r_code == "ADMIN")
				nuke.r_code = nuke_team.memorized_code
			else //Already set by admins/something else?
				nuke_team.memorized_code = nuke.r_code
			for(var/obj/machinery/nuclearbomb/beer/beernuke in GLOB.nuke_list)
				beernuke.r_code = nuke_team.memorized_code
		else
			stack_trace("Не нашли бомбу синдиката в ходе создании команды оперов. Пиздато.")
			nuke_team.memorized_code = null

/datum/antagonist/nukeop/proc/give_alias()
	if(nuke_team?.syndicate_name)
		var/mob/living/carbon/human/H = owner.current
		if(istype(H)) // Reinforcements get a real name
			var/chosen_name = H.dna.species.random_name(H.gender,0,nuke_team.syndicate_name)
			H.fully_replace_character_name(H.real_name,chosen_name)
		else
			var/number = 1
			number = nuke_team.members.Find(owner)
			owner.current.real_name = "[nuke_team.syndicate_name] Оперативник #[number]"



/datum/antagonist/nukeop/proc/memorize_code()
	if(nuke_team && nuke_team.tracked_nuke && nuke_team.memorized_code)
		antag_memory += "<B>[nuke_team.tracked_nuke] Код</B>: [nuke_team.memorized_code]<br>"
		to_chat(owner, "Код авторизации ядерного устройства: <B>[nuke_team.memorized_code]</B>")
	else
		to_chat(owner, "<img src='https://media.discordapp.net/attachments/669610129548640257/828761933812334632/negrpng.png'")

/datum/antagonist/nukeop/proc/forge_objectives()
	if(nuke_team)
		objectives |= nuke_team.objectives

/datum/antagonist/nukeop/proc/move_to_spawnpoint()
	var/team_number = 1
	if(nuke_team)
		team_number = nuke_team.members.Find(owner)
	owner.current.forceMove(GLOB.nukeop_start[((team_number - 1) % GLOB.nukeop_start.len) + 1])

/datum/antagonist/nukeop/leader/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.nukeop_leader_start))

/datum/antagonist/nukeop/create_team(datum/team/nuclear/new_team)
	if(!new_team)
		if(!always_new_team)
			for(var/datum/antagonist/nukeop/N in GLOB.antagonists)
				if(!N.owner)
					stack_trace("Датум антагониста создался без носителя в GLOB.antagonists: [N]")
					continue
				if(N.nuke_team)
					nuke_team = N.nuke_team
					return
		nuke_team = new /datum/team/nuclear
		nuke_team.update_objectives()
		assign_nuke() //This is bit ugly
		return
	if(!istype(new_team))
		stack_trace("Команда проебалась где-то из-за [type] инициализации.")
	nuke_team = new_team

/datum/antagonist/nukeop/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.assigned_role = ROLE_SYNDICATE
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has nuke op'ed [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has nuke op'ed [key_name(new_owner)].")

/datum/antagonist/nukeop/get_admin_commands()
	. = ..()
	.["Отправить на базу"] = CALLBACK(src, PROC_REF(admin_send_to_base))
	.["Сказать код"] = CALLBACK(src, PROC_REF(admin_tell_code))

/datum/antagonist/nukeop/proc/admin_send_to_base(mob/admin)
	owner.current.forceMove(pick(GLOB.nukeop_start))

/datum/antagonist/nukeop/proc/admin_tell_code(mob/admin)
	var/code
	for (var/obj/machinery/nuclearbomb/bombue in GLOB.machines)
		if (length(bombue.r_code) <= 5 && bombue.r_code != initial(bombue.r_code))
			code = bombue.r_code
			break
	if (code)
		antag_memory += "<B>Код от ядерной бомбы</B>: [code]<br>"
		to_chat(owner.current, "Код авторизации ядерного устройства: <B>[code]</B>")
	else
		to_chat(admin, span_danger("БОМБЫ НЕТ!"))

/datum/antagonist/nukeop/leader
	name = "Лидер Оперативников"
	nukeop_outfit = /datum/outfit/syndicate/leader
	always_new_team = TRUE
	var/title
	var/challengeitem = /obj/item/nuclear_challenge
	greentext_reward = 15

/datum/antagonist/nukeop/leader/give_alias()
	title = pick("Царь", "Босс", "Коммандор", "Шеф", "Главарь", "Директор", "Оверлорд")
	if(nuke_team?.syndicate_name)
		owner.current.real_name = "[nuke_team.syndicate_name] [title]"
	else
		owner.current.real_name = "Синдикатовец [title]"

/datum/antagonist/nukeop/leader/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg', 100,0, use_reverb = FALSE)
	to_chat(owner, "<B>Вы - лидер оперативников Синдиката. Вы отвечаете за руководство операцией, а так же лишь ваша ID-карточка способна открыть двери к вашему шаттлу.</B>")
	to_chat(owner, "<B>Если вы считаете, что вы не являетесь идеальным кандидатом в качестве лидера - выдайте свою карту другому оперативнику.</B>")
	if(!CONFIG_GET(flag/disable_warops))
		to_chat(owner, "<B>В вашей руке есть специальное устройство, которое может объявить станции войну, в обмен на бонусные телекристаллы. Внимательно осмотрите его и проконсультируйтесь с другими оперативниками, прежде чем активировать это.</B>")
		var/obj/item/dukinuki = new challengeitem
		var/mob/living/carbon/human/H = owner.current
		if(!istype(H))
			dukinuki.forceMove(H.drop_location())
		else
			H.put_in_hands(dukinuki, TRUE)
		nuke_team.war_button_ref = WEAKREF(dukinuki)
	owner.announce_objectives()
	addtimer(CALLBACK(src, PROC_REF(nuketeam_name_assign)), 1)


/datum/antagonist/nukeop/leader/proc/nuketeam_name_assign()
	if(!nuke_team)
		return
	nuke_team.rename_team(ask_name())

/datum/team/nuclear/proc/rename_team(new_name)
	syndicate_name = new_name
	name = "[syndicate_name] Команда"
	for(var/I in members)
		var/datum/mind/synd_mind = I
		var/mob/living/carbon/human/H = synd_mind.current
		if(!istype(H))
			continue
		var/chosen_name = H.dna.species.random_name(H.gender,0,syndicate_name)
		H.fully_replace_character_name(H.real_name,chosen_name)

/datum/antagonist/nukeop/leader/proc/ask_name()
	var/randomname = pick(GLOB.last_names)
	var/newname = stripped_input(owner.current,"Я [title]. Необходимо выбрать фамилию для нашей команды.", "Смена имени",randomname)
	if (!newname)
		newname = randomname
	else
		newname = reject_bad_name(newname)
		if(!newname)
			newname = randomname

	return capitalize(newname)

/datum/antagonist/nukeop/lone
	name = "Одинокий Оперативник"
	always_new_team = TRUE
	send_to_spawnpoint = FALSE //Handled by event
	nukeop_outfit = /datum/outfit/syndicate/full

/datum/antagonist/nukeop/lone/assign_nuke()
	if(nuke_team && !nuke_team.tracked_nuke)
		nuke_team.memorized_code = random_nukecode()
		var/obj/machinery/nuclearbomb/selfdestruct/nuke = locate() in GLOB.nuke_list
		if(nuke)
			nuke_team.tracked_nuke = nuke
			if(nuke.r_code == "ADMIN")
				nuke.r_code = nuke_team.memorized_code
			else //Already set by admins/something else?
				nuke_team.memorized_code = nuke.r_code
		else
			stack_trace("Бомба самоуничтожения не была обнаружена в ходе создания лон-опера. Ебите маппера этой хуйни.")
			nuke_team.memorized_code = null

/datum/antagonist/nukeop/reinforcement
	send_to_spawnpoint = FALSE
	nukeop_outfit = /datum/outfit/syndicate/no_crystals

/datum/team/nuclear
	var/syndicate_name
	var/obj/machinery/nuclearbomb/tracked_nuke
	var/core_objective = /datum/objective/nuclear
	var/memorized_code
	var/list/team_discounts
	var/datum/weakref/war_button_ref

/datum/team/nuclear/New()
	..()
	syndicate_name = syndicate_name()

/datum/team/nuclear/proc/update_objectives()
	if(core_objective)
		var/datum/objective/O = new core_objective
		O.team = src
		objectives += O

/datum/team/nuclear/proc/disk_rescued()
	for(var/obj/item/disk/nuclear/D in SSpoints_of_interest.real_nuclear_disks)
		//If emergency shuttle is in transit disk is only safe on it
		if(SSshuttle.emergency.mode == SHUTTLE_ESCAPE)
			if(!SSshuttle.emergency.is_in_shuttle_bounds(D))
				return FALSE
		//If shuttle escaped check if it's on centcom side
		else if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME)
			if(!D.onCentCom())
				return FALSE
		else //Otherwise disk is safe when on station
			var/turf/T = get_turf(D)
			if(!T || !is_station_level(T.z))
				return FALSE
	return TRUE

/datum/team/nuclear/proc/operatives_dead()
	for(var/I in members)
		var/datum/mind/operative_mind = I
		if(ishuman(operative_mind.current) && (operative_mind.current.stat != DEAD))
			return FALSE
	return TRUE

/datum/team/nuclear/proc/syndies_escaped()
	var/obj/docking_port/mobile/S = SSshuttle.getShuttle("syndicate")
	var/obj/docking_port/stationary/transit/T = locate() in S.loc
	return S && (is_centcom_level(S.z) || T)

/datum/team/nuclear/proc/get_result()
	var/evacuation = EMERGENCY_ESCAPED_OR_ENDGAMED
	var/disk_rescued = disk_rescued()
	var/syndies_didnt_escape = !syndies_escaped()
	var/station_was_nuked = SSticker.mode.station_was_nuked
	var/nuke_off_station = SSticker.mode.nuke_off_station

	if(nuke_off_station == NUKE_SYNDICATE_BASE)
		return NUKE_RESULT_FLUKE
	else if(station_was_nuked && !syndies_didnt_escape)
		return NUKE_RESULT_NUKE_WIN
	else if (station_was_nuked && syndies_didnt_escape)
		return NUKE_RESULT_NOSURVIVORS
	else if (!disk_rescued && !station_was_nuked && nuke_off_station && !syndies_didnt_escape)
		return NUKE_RESULT_WRONG_STATION
	else if (!disk_rescued && !station_was_nuked && nuke_off_station && syndies_didnt_escape)
		return NUKE_RESULT_WRONG_STATION_DEAD
	else if ((disk_rescued && evacuation) && operatives_dead())
		return NUKE_RESULT_CREW_WIN_SYNDIES_DEAD
	else if (disk_rescued)
		return NUKE_RESULT_CREW_WIN
	else if (!disk_rescued && operatives_dead())
		return NUKE_RESULT_DISK_LOST
	else if (!disk_rescued && evacuation)
		return NUKE_RESULT_DISK_STOLEN
	else
		return	//Undefined result

/datum/team/nuclear/roundend_report()
	var/list/parts = list()
	parts += span_header("[syndicate_name] Оперативники:")

	switch(get_result())
		if(NUKE_RESULT_FLUKE)
			parts += "<span class='redtext big'>Унизительное Уничтожение Синдиката</span>"
			parts += "<B>Экипаж станции [station_name()] вернули оперативникам их собственную бомбу! База Синдиката была уничтожена!</B> Не теряйте ядерную бомбу!"
		if(NUKE_RESULT_NUKE_WIN)
			parts += "<span class='greentext big'>Syndicate Major Victory!</span>"
			parts += "<B>Оперативники Синдиката успешно уничтожили [station_name()]!</B>"
		if(NUKE_RESULT_NOSURVIVORS)
			parts += "<span class='neutraltext big'>Тотальная Аннигиляция</span>"
			parts +=  "<B>Оперативники Синдиката уничтожили [station_name()], но не покинули зону поражения вовремя и были аннигилированы.</B> Не теряйте диск!"
		if(NUKE_RESULT_WRONG_STATION)
			parts += "<span class='redtext big'>Crew Minor Victory</span>"
			parts += "<B>Оперативники Синдиката сохранили диск, но взорвали то, что не является станцией [station_name()].</B> Не делайте так!"
		if(NUKE_RESULT_WRONG_STATION_DEAD)
			parts += "<span class='redtext big'>Оперативники Синдиката получили Премию Дарвина!</span>"
			parts += "<B>Оперативники Синдиката взорвали что-то, что не является станцией [station_name()] и были уничтожены взрывом.</B> Не делайте так!"
		if(NUKE_RESULT_CREW_WIN_SYNDIES_DEAD)
			parts += "<span class='redtext big'>Crew Major Victory!</span>"
			parts += "<B>Экипаж станции сохранил диск и успешно уничтожил всех оперативников!</B>"
		if(NUKE_RESULT_CREW_WIN)
			parts += "<span class='redtext big'>Crew Major Victory</span>"
			parts += "<B>Экипаж станции сохранил диск и остановил оперативников!</B>"
		if(NUKE_RESULT_DISK_LOST)
			parts += "<span class='neutraltext big'>Нейтральная победа!</span>"
			parts += "<B>Экипаж станции потерял диск, но смог уничтожить всех оперативников Синдиката!</B>"
		if(NUKE_RESULT_DISK_STOLEN)
			parts += "<span class='greentext big'>Syndicate Minor Victory!</span>"
			parts += "<B>Оперативники Синдиката смогли выжить в штурме, но не взорвали станцию [station_name()].</B> Не теряйте диск!"
		else
			parts += "<span class='neutraltext big'>Ничья!</span>"
			parts += "<B>Операция прервана!</B>"

	var/text = "<br><span class='header'>Оперативниками были:</span>"
	var/purchases = ""
	var/TC_uses = 0
	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	for(var/I in members)
		var/datum/mind/syndicate = I
		var/datum/uplink_purchase_log/H = GLOB.uplink_purchase_logs_by_key[syndicate.key]
		if(H)
			TC_uses += H.total_spent
			purchases += H.generate_render(show_key = FALSE)
	text += printplayerlist(members)
	text += "<br>"
	text += "(Команда оперативников использовало [TC_uses] ТК) [purchases]"
	if(TC_uses == 0 && SSticker.mode.station_was_nuked && !operatives_dead())
		text += "<BIG>[icon2html('icons/badass.dmi', world, "badass")]</BIG>"

	parts += text

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/team/nuclear/antag_listing_name()
	if(syndicate_name)
		return "[syndicate_name] Syndicates"
	else
		return "Syndicates"

/datum/team/nuclear/antag_listing_entry()
	var/disk_report = "<b>Nuclear Disk(s)</b><br>"
	disk_report += "<table cellspacing=5>"
	for(var/obj/item/disk/nuclear/N in SSpoints_of_interest.real_nuclear_disks)
		disk_report += "<tr><td>[N.name], "
		var/atom/disk_loc = N.loc
		while(!isturf(disk_loc))
			if(ismob(disk_loc))
				var/mob/M = disk_loc
				disk_report += "carried by <a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(M)]'>[M.real_name]</a> "
			if(isobj(disk_loc))
				var/obj/O = disk_loc
				disk_report += "in \a [O.name] "
			disk_loc = disk_loc.loc
		disk_report += "in [disk_loc.loc] at ([disk_loc.x], [disk_loc.y], [disk_loc.z])</td><td><a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(N)]'>FLW</a></td></tr>"
	disk_report += "</table>"
	var/common_part = ..()
	var/challenge_report
	var/obj/item/nuclear_challenge/war_button = war_button_ref?.resolve()
	if(war_button)
		challenge_report += "<b>War not declared.</b> <a href='?_src_=holder;[HrefToken()];force_war=[REF(war_button)]'>\[Force war\]</a>"
	return common_part + disk_report + challenge_report

/datum/team/nuclear/is_gamemode_hero()
	return SSticker.mode.name == "nuclear emergency"
