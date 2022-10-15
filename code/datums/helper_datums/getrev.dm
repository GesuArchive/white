/datum/getrev
	var/commit  // git rev-parse HEAD

/datum/getrev/New()
	var/list/head_log = world.file2list(".git/logs/HEAD", "\n")
	for(var/line = head_log.len, line>=1, line--)
		if(head_log[line])
			var/list/last_entry = splittext(head_log[line], " ")
			if(last_entry.len < 2)
				continue
			commit = last_entry[2]
			break

/client/verb/showrevinfo()
	set name = "📘 Информация о сервере"
	set desc = "Check the current server code revision"
	set category = null

	var/list/msg = list("")
	// Round ID
	if(GLOB.round_id)
		msg += "<b>Round ID:</b> [GLOB.round_id]"

	msg += "<b>BYOND Version:</b> [world.byond_version].[world.byond_build]"
	if(DM_VERSION != world.byond_version || DM_BUILD != world.byond_build)
		msg += "<b>Compiled with BYOND Version:</b> [DM_VERSION].[DM_BUILD]"

	// Game mode odds
	msg += "<br><b>Current Informational Settings:</b>"
	msg += "Protect Authority Roles From Traitor: [CONFIG_GET(flag/protect_roles_from_antagonist)]"
	msg += "Protect Assistant Role From Traitor: [CONFIG_GET(flag/protect_assistant_from_antagonist)]"
	msg += "Enforce Human Authority: [CONFIG_GET(flag/enforce_human_authority)]"
	msg += "Allow Latejoin Antagonists: [CONFIG_GET(flag/allow_latejoin_antagonists)]"
	msg += "Enforce Continuous Rounds: [length(CONFIG_GET(keyed_list/continuous))] of [config.modes.len] roundtypes"
	msg += "Allow Midround Antagonists: [length(CONFIG_GET(keyed_list/midround_antag))] of [config.modes.len] roundtypes"
	if(CONFIG_GET(flag/show_game_type_odds))
		var/list/probabilities = CONFIG_GET(keyed_list/probability)
		if(SSticker.IsRoundInProgress())
			var/prob_sum = 0
			var/current_odds_differ = FALSE
			var/list/probs = list()
			var/list/modes = config.gamemode_cache
			var/list/min_pop = CONFIG_GET(keyed_list/min_pop)
			var/list/max_pop = CONFIG_GET(keyed_list/max_pop)
			for(var/mode in modes)
				var/datum/game_mode/M = mode
				var/ctag = initial(M.config_tag)
				if(!(ctag in probabilities))
					continue
				if((min_pop[ctag] && (min_pop[ctag] > SSticker.totalPlayersReady)) || (max_pop[ctag] && (max_pop[ctag] < SSticker.totalPlayersReady)) || (initial(M.required_players) > SSticker.totalPlayersReady))
					current_odds_differ = TRUE
					continue
				probs[ctag] = 1
				prob_sum += probabilities[ctag]
			if(current_odds_differ)
				msg += "<b>Game Mode Odds for current round:</b>"
				for(var/ctag in probs)
					if(probabilities[ctag] > 0)
						var/percentage = round(probabilities[ctag] / prob_sum * 100, 0.1)
						msg += "[ctag] [percentage]%"

		msg += "<b>All Game Mode Odds:</b>"
		var/sum = 0
		for(var/ctag in probabilities)
			sum += probabilities[ctag]
		for(var/ctag in probabilities)
			if(probabilities[ctag] > 0)
				var/percentage = round(probabilities[ctag] / sum * 100, 0.1)
				msg += "[ctag] [percentage]%"
	to_chat(src, msg.Join("<br>"))
