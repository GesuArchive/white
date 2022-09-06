//Гигапак костылей.
//Пополнять по необходимости.
//На оффтг за такое бы запермили без права обжалования.
//Хорошо, что мы не оффтг.



//Вызов ЕРТ с какими-то там условиями
//==================================================================================================================================
//Спизжено у валтоса, который свою очередь спиздил этот кусок кода из code\modules\admin\verbs\one_click_antag.dm.
//Я постарался переписать код так, чтобы можно было вызывать один и тот же метод для разных команд ЕРТ.
//В первую очередь сделано для консоли коммуникаций.
//
//то, что несколько идентичных кусков кода не только не являются одним методом, но и ещё разбросаны по разным файлам - зашквар.
//С другой стороны, в vscode переход по дефайнам до смешного прост, а QC у нас как такового вообще нет.
//Так что не похуй ли?

/*
* Вызов ЕРТ с какими-то там условиями, предложение мёртвым игрокам роли в команде.
* Костыль? Костыль.
* mission - задание ЕРТ
* team_name - название команды ЕРТ
* team_name_genitive_case - название команды ЕРТ в родительном падеже (блять)
* antag_datum_leader - инстанс датума антага для лидера (а-ля new /datum/antagonist/ert/janitor/heavy)
* antag_datum - инстанс датума антага для остальных членов команды.
*/
/proc/general_ert_request(mission, team_name, team_name_genitive_case, antag_datum_leader, antag_datum_member, mob/Sender, cost = 0, return_ert_list = FALSE)
	var/msg = copytext_char(sanitize(mission), 1, MAX_MESSAGE_LEN)
	var/teamname_gc = copytext_char(sanitize(team_name_genitive_case), 1, MAX_MESSAGE_LEN)
	var/teamname = copytext_char(sanitize(team_name), 1, MAX_MESSAGE_LEN)

	if(Sender)
		message_admins("[Sender] собирается вызвать [teamname_gc] с миссией: [msg]")
	var/list/mob/dead/observer/candidates = poll_ghost_candidates("Хотите быть в специальном отряде быстрого реагирования?", "deathsquad", null)
	var/teamSpawned = FALSE

	if(candidates.len > 0)
		//Pick the (un)lucky players
		var/numagents = min(7, candidates.len)

		//Create team
		var/datum/team/ert/ert_team = new /datum/team/ert

		//Asign team objective
		var/datum/objective/missionobj = new
		missionobj.team = ert_team
		missionobj.explanation_text = msg
		missionobj.completed = TRUE
		missionobj.reward = 15
		ert_team.objectives += missionobj
		ert_team.mission = missionobj

		var/list/spawnpoints = GLOB.emergencyresponseteamspawn
		var/list/ert_list = list()
		var/index = 0
		while(numagents && candidates.len)
			var/spawnloc = spawnpoints[index+1]
			//loop through spawnpoints one at a time
			index = (index + 1) % spawnpoints.len
			var/mob/dead/observer/chosen_candidate = pick(candidates)
			candidates -= chosen_candidate
			if(!chosen_candidate.key)
				continue

			//Spawn the body
			var/mob/living/carbon/human/ERTOperative = new /mob/living/carbon/human(spawnloc)
			chosen_candidate.client.prefs.copy_to(ERTOperative)
			ERTOperative.key = chosen_candidate.key

			//Give antag datum
			var/datum/antagonist/ert/ert_antag

			if(numagents == 1)
				ert_antag = antag_datum_leader
			else
				ert_antag = antag_datum_member

			ERTOperative.mind.add_antag_datum(ert_antag,ert_team)
			ERTOperative.mind.assigned_role = ert_antag.name

			//Logging and cleanup
			log_game("[key_name(ERTOperative)] has been selected as an [ert_antag.name]")
			numagents--
			teamSpawned++
			LAZYADD(ert_list, ERTOperative)

		if(Sender)
			if (teamSpawned)
				message_admins("[Sender] вызывает [teamname] с миссией: [msg]")
				var/datum/bank_account/bank_account = SSeconomy.get_dep_account(ACCOUNT_STA)
				bank_account.adjust_money(-cost)
			else
				message_admins("[Sender] не смог вызвать [teamname] с миссией: [msg]")
				to_chat(Sender, span_alert("Не удалось найти свободные позиции для запроса. Средства не были потрачены."))

		if(return_ert_list)
			return ert_list
		else
			return TRUE
	else
		return FALSE

/proc/janitor_ert_request(input, usr, cost, return_ert_list)
	return general_ert_request(input, "бригада уборщиков", "бригаду уборщиков", new /datum/antagonist/ert/janitor/heavy, new /datum/antagonist/ert/janitor, usr, cost = cost, return_ert_list = return_ert_list)

/proc/omon_ert_request(input, usr, cost, return_ert_list)
	return general_ert_request(input, "СОБР", "СОБР", new /datum/antagonist/ert/sobr/leader, new /datum/antagonist/ert/sobr, usr, cost = cost, return_ert_list = return_ert_list)

/proc/engineer_ert_request(input, usr, cost, return_ert_list)
	return general_ert_request(input, "Ремонтная бригада", "ремонтную бригаду", new /datum/antagonist/ert/engineer/red, new /datum/antagonist/ert/engineer, usr, cost = cost, return_ert_list = return_ert_list)

/proc/deathsquad_request(input, cumshit, return_ert_list)
	return general_ert_request(input, "Отряд смерти", "отряд смерти", new /datum/antagonist/ert/deathsquad/leader, new /datum/antagonist/ert/deathsquad, cumshit, return_ert_list = return_ert_list)

/proc/getnoun(number, one, two, five)
	var/n = abs(number)
	n = n % 100
	if (n >= 11 &&  n <= 19)
		return five

	n = n % 10
	switch(n)
		if(1)
			return one
		if(2 to 4)
			return two
	return five



/proc/get_funny_name(special_name_chance = 0)
	var/static/list/L1 = list (
		"Ushat",
		"Ulov",
		"Buket",
		"Rekord",
		"Otryad",
		"Podriv",
		"Pogrom",
		"Podzhog",
		"Zahvat",
		"Ishod",
		"Pobeg",
		"Obval",
		"Ugon",
		"Udel",
		"Kamaz",
		"Razvod",
		"Zabeg",
		"Parad",
		"Vagon",
		"Rulon",
		"Kvartet",
		"Zagul",
		"Uchet",
		"Razbor",
		"Karman",
		"Obed",
		"Meshok",
		"Polet",
		"Barak",
		"Ukral"
	)
	var/static/list/L2 = list(
		"Pomoev",
		"Nalimov",
		"Kovboev",
		"Ustoev",
		"Evreev",
		"Saraev",
		"Pokoev",
		"Isgoev",
		"Zlodeev",
		"Zaboev",
		"Plebeev",
		"Othodov",
		"Suprugov",
		"Debilov",
		"Urodov",
		"Gandonov",
		"Huev",
		"Oboev",
		"Bratanov",
		"Rashodov",
		"Limonov",
		"Poletov",
		"Lemurov",
		"Pistonov",
		"Gormonov",
		"Zaboev",
		"Fazanov",
		"Pingvinov",
		"Arabov",
		"Mongolov",
		"Baranov",
		"Morozov",
		"Matrosov",
		"Shakalov",
		"Pigmeev"
	)
	var/static/list/S = list(
		"Karasik Dvachev",
		"Grifon Debilov",
		"Kommit Valtosov"
	)
	if(prob(special_name_chance))
		return pick(S)
	return "[pick(L1)] [pick(L2)]"

/proc/programmify(text, color1 = "#ff6090", color2 = "#eeeeee")
	var/result
	for(var/i = 1, i < length(text)+1, i += 2)
		result += "<font color='[color1]'>[text[i]]</font>"
		result += "<font color='[color2]'>[text[i+1]]</font>"
	return result
