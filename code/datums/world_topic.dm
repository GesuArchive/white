// SETUP

/proc/TopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/world_topic)
	for(var/I in all_handlers)
		var/datum/world_topic/WT = I
		var/keyword = initial(WT.keyword)
		if(!keyword)
			warning("[WT] has no keyword! Ignoring...")
			continue
		var/existing_path = .[keyword]
		if(existing_path)
			warning("[existing_path] and [WT] have the same keyword! Ignoring [WT]...")
		else if(keyword == "key")
			warning("[WT] has keyword 'key'! Ignoring...")
		else
			.[keyword] = WT

// DATUM

/datum/world_topic
	var/keyword
	var/log = TRUE
	var/key_valid
	var/require_comms_key = FALSE

/datum/world_topic/proc/TryRun(list/input)
	key_valid = config && (CONFIG_GET(string/comms_key) == input["key"])
	var/key_cvalid = config && (CONFIG_GET(string/cross_key) == input["key"])
	if(require_comms_key && !key_valid)
		if(!key_cvalid) //хочу спать
			return "Bad Key"
	input -= "key"
	if(require_comms_key && !key_valid)
		. = "Bad Key"
		if (input["format"] == "json")
			. = list("error" = .)
	else
		. = Run(input)
	if (input["format"] == "json")
		. = json_encode(.)
	else if(islist(.))
		. = list2params(.)

/datum/world_topic/proc/Run(list/input)
	CRASH("Run() not implemented for [type]!")

// TOPICS

/datum/world_topic/ping
	keyword = "ping"
	log = FALSE

/datum/world_topic/ping/Run(list/input)
	. = 0
	for (var/client/C in GLOB.clients)
		++.

/datum/world_topic/playing
	keyword = "playing"
	log = FALSE

/datum/world_topic/playing/Run(list/input)
	return GLOB.player_list.len

/datum/world_topic/pr_announce
	keyword = "announce"
	require_comms_key = TRUE
	var/static/list/PRcounts = list()	//PR id -> number of times announced this round

/datum/world_topic/pr_announce/Run(list/input)
	var/list/payload = r_json_decode(input["payload"])
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > PR_ANNOUNCEMENTS_PER_ROUND)
			return

	var/final_composed = span_announce("PR: [input[keyword]]")
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/datum/world_topic/ahelp_relay
	keyword = "Ahelp"
	require_comms_key = TRUE

/datum/world_topic/ahelp_relay/Run(list/input)
	relay_msg_admins(span_adminnotice("<b><font color=red>HELP: </font> [input["source"]] [input["message_sender"]]: [input["message"]]</b>"))

/datum/world_topic/comms_console
	keyword = "Comms_Console"
	require_comms_key = TRUE

/datum/world_topic/comms_console/Run(list/input)
	// Reject comms messages from other servers that are not on our configured network,
	// if this has been configured. (See CROSS_COMMS_NETWORK in comms.txt)
	var/configured_network = CONFIG_GET(string/cross_comms_network)
	if (configured_network && configured_network != input["network"])
		return

	minor_announce(input["message"], "Входящее сообщение от [input["message_sender"]]")
	for(var/obj/machinery/computer/communications/CM in GLOB.machines)
		CM.override_cooldown()

/datum/world_topic/news_report
	keyword = "News_Report"
	require_comms_key = TRUE

/datum/world_topic/news_report/Run(list/input)
	minor_announce(input["message"], "Входящее сообщение от [input["message_sender"]]")

/datum/world_topic/status
	keyword = "status"

/datum/world_topic/status/Run(list/input)
	. = list()
	.["version"] = GLOB.game_version
	.["mode"] = GLOB.master_mode
	.["respawn"] = config ? !CONFIG_GET(flag/norespawn) : FALSE
	.["enter"] = !LAZYACCESS(SSlag_switch.measures, DISABLE_NON_OBSJOBS)
	.["vote"] = CONFIG_GET(flag/allow_vote_mode)
	.["ai"] = CONFIG_GET(flag/allow_ai)
	.["host"] = world.host ? world.host : null
	.["round_id"] = GLOB.round_id
	.["players"] = GLOB.clients.len
	.["hub"] = GLOB.hub_visibility
	var/game_status
	switch(SSticker.current_state)
		if(GAME_STATE_PREGAME, GAME_STATE_STARTUP)
			game_status = "lobby"
		if(COMSIG_TICKER_ERROR_SETTING_UP)
			game_status = "starting"
		if(GAME_STATE_PLAYING)
			game_status = "playing"
		if(GAME_STATE_FINISHED)
			game_status = "finished"
		else
			game_status = "unknown"
	.["game_status"] = game_status


	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	.["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
	.["gamestate"] = SSticker.current_state

	.["map_name"] = SSmapping.config?.map_name || "Loading..."

	if(key_valid)
		.["active_players"] = get_active_player_count()
		if(SSticker.HasRoundStarted())
			.["real_mode"] = SSticker.mode.name
			// Key-authed callers may know the truth behind the "secret"

	.["security_level"] = SSsecurity_level.get_current_level_as_text()
	.["round_duration"] = SSticker ? round((world.time-SSticker.round_start_time)/10) : 0
	// Amount of world's ticks in seconds, useful for calculating round duration

	//Time dilation stats.
	.["time_dilation_current"] = SStime_track.time_dilation_current
	.["time_dilation_avg"] = SStime_track.time_dilation_avg
	.["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	.["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	//pop cap stats
	.["soft_popcap"] = CONFIG_GET(number/soft_popcap) || 0
	.["hard_popcap"] = CONFIG_GET(number/hard_popcap) || 0
	.["extreme_popcap"] = CONFIG_GET(number/extreme_popcap) || 0
	.["popcap"] = max(CONFIG_GET(number/soft_popcap), CONFIG_GET(number/hard_popcap), CONFIG_GET(number/extreme_popcap)) //generalized field for this concept for use across ss13 codebases
	.["bunkered"] = CONFIG_GET(flag/panic_bunker) || FALSE
	if(SSshuttle?.emergency)
		.["shuttle_mode"] = SSshuttle.emergency.mode
		// Shuttle status, see /__DEFINES/stat.dm
		.["shuttle_timer"] = SSshuttle.emergency.timeLeft()
		// Shuttle timer, in seconds

/datum/world_topic/players
	keyword = "players"
	log = FALSE

/datum/world_topic/players/Run(list/input)
	return GLOB.whitelist.len + GLOB.player_list.len

/datum/world_topic/adminwho
	keyword = "adminwho"
	log = FALSE

/datum/world_topic/adminwho/Run(list/input)
	var/msg = "Педали:\n"
	for(var/adm in GLOB.admins)
		var/client/C = adm
		if(!C.holder.fakekey)
			msg += "\t[C] - [C.holder.rank]"
			msg += "\n"
	return msg

/datum/world_topic/who
	keyword = "who"
	log = FALSE

/datum/world_topic/who/Run(list/input)
	var/msg = "Текущие игроки:\n"
	var/n = 0
	for(var/client/C in GLOB.clients)
		n++
		if(C.holder && C.holder.fakekey)
			msg += "\t[C.holder.fakekey]\n"
		else
			msg += "\t[C.key]\n"
	msg += "Всего: [n]"
	return msg

/datum/world_topic/asay
	keyword = "asay"
	require_comms_key = TRUE

/datum/world_topic/asay/Run(list/input)
	var/msg = "<font color='[GLOB.OOC_COLOR]'><span class='adminobserver'><span class='prefix'>DASAY</span> <EM>[input["admin"]]</EM>: <span class='message linkify'>[input["asay"]]</span></span></font>"
	to_chat(GLOB.admins, msg)

/datum/world_topic/ooc
	keyword = "ooc"
	require_comms_key = TRUE

/datum/world_topic/ooc/Run(list/input)
	if(!GLOB.ooc_allowed&&!input["isadmin"])
		return "globally muted"

	if(is_banned_from(ckey(input["ckey"]), "OOC"))
		return "you are retard"

	for(var/client/C in GLOB.clients)
		if(C.prefs.chat_toggles & CHAT_OOC) // ooc ignore
			to_chat(C, "<font color='[GLOB.OOC_COLOR]'><span class='ooc'><span class='prefix'>DOOC</span> <EM>[input["ckey"]]:</EM> <span class='message linkify'>[input["ooc"]]</span></span></font>")

/datum/world_topic/ahelp
	keyword = "adminhelp"
	require_comms_key = TRUE

/datum/world_topic/ahelp/Run(list/input)
	var/r_ckey = ckey(input["ckey"])
	var/s_admin = input["admin"]
	var/msg = input["response"]
	var/keywordparsedmsg = keywords_lookup(msg)
	var/client/recipient = GLOB.directory[r_ckey]
	if(!recipient)
		return "FAIL"
	if(!recipient.current_ticket)
		new /datum/admin_help(msg, recipient, TRUE)
	to_chat(recipient, "<font color='red' size='4'><b>-- Сообщение администратора из Discord --</b></font>")
	to_chat(recipient, span_red("Сообщение от <b>[s_admin]</b>: [msg]"))
	to_chat(recipient, span_red("<i>Нажми на имя администратора для ответа.</i>"))
	to_chat(src, span_blue("Сообщение для <b>[key_name(recipient, 1, 1)]</b>: [msg]"))

	recipient.giveadminhelpverb() //reset ahelp CD to allow fast reply

	admin_ticket_log(recipient, span_blue("PM From [s_admin]: [keywordparsedmsg]"))
	SEND_SOUND(recipient, sound('sound/effects/adminhelp.ogg'))
	log_admin_private("PM: IRC -> [r_ckey]: [sanitize(msg)]")
	for(var/client/X in GLOB.admins)
		to_chat(X, span_blue("<B>PM: DISCORD([s_admin]) -&gt; [key_name(recipient, X, 0)]</B> [keywordparsedmsg]"))
	webhook_send_ahelp("[input["admin"]] -> [ckey(input["ckey"])]", input["response"])

/datum/world_topic/special_cmd
	keyword = "special_cmd"
	require_comms_key = TRUE

/datum/world_topic/special_cmd/Run(list/input)
	if(!input["proc"])
		return "WHERE IS PROC"

	var/list/proclist = splittext(input["proc"], "/")
	if (!length(proclist))
		return "WHAT THE FUCK"

	var/procname = proclist[proclist.len]
	var/proctype = ("verb" in proclist) ? "verb" : "proc"

	var/procpath = "/[proctype]/[procname]"
	if(!text2path(procpath))
		return "Error: callproc(): [procpath] does not exist."
	var/list/lst = r_json_decode(input["args"])
	if(!lst)
		return "NO ARGS ARRRRGH NIGGER"

	log_admin("InCon -> [procname]() -> [lst.len ? "[list2params(lst)]":"0 args"].")
	message_admins("InCon -> [procname]() -> [lst.len ? "[list2params(lst)]":"0 args"].")

	return call("/proc/[procname]")(arglist(lst))

/**
 * Отправляет админ-анноунс
 */
/proc/global_fucking_announce(text, userkey = null)
	to_chat(world, "<span class='adminnotice'><b>[userkey ? userkey : "Администратор"] делает объявление:</b></span>\n \t [text]")
	return TRUE

/**
 * Устанавливает сумму метакэша. Если нет в базе, то шлёт на хуй
 * announce: объявлять ли пользователю, если он в игре
 */
/proc/set_metacoins_by_key(userkey, value = 0, announce = FALSE)
	var/datum/db_query/query_set_metacoins = SSdbcore.NewQuery(
		"UPDATE player SET metacoins = :value WHERE ckey = :userkey",
		list("value" = value, "userkey" = userkey)
	)
	var/no_err = query_set_metacoins.Execute()
	qdel(query_set_metacoins)
	if(announce)
		for(var/client/C in GLOB.clients)
			if(userkey == C.ckey)
				to_chat(C, "<span class='rose bold'>Новый баланс: [value] метакэша!</span>")
	return no_err

/**
 * Устанавливает сумму донатов. Если нет в базе, то добавляет запись. ПОЛЬЗОВАТЬСЯ ОСТОРОЖНО
 */
/proc/set_donate_value(userkey, value = 0)
	var/datum/db_query/query_set_donate
	if(load_donator(userkey))
		query_set_donate = SSdbcore.NewQuery(
			"UPDATE donations SET sum = :value WHERE byond = :userkey",
			list("value" = value, "userkey" = userkey)
		)
	else if (!check_donations(userkey))
		query_set_donate = SSdbcore.NewQuery(
			"INSERT INTO donations (sum, byond) VALUES (:value, :userkey)",
			list("value" = value, "userkey" = userkey)
		)
	var/no_err = query_set_donate.Execute()
	qdel(query_set_donate)
	return no_err

/**
 * Отправляет негра с хуем пользователю
 * delete_after: удаление негра через n-секунд
 */
/proc/penetrate_retard(userkey, delete_after = 10)
	for(var/client/C in GLOB.clients)
		if(userkey == C.ckey)
			if(isliving(C.mob))
				var/mob/L = new /mob/living/carbon/human/raper(get_turf(C.mob))
				QDEL_IN(L, delete_after SECONDS)
				return TRUE
	return FALSE

GLOBAL_VAR_INIT(cmd_central_announce, FALSE)

/**
 * Отправляет сообщение от имени ЦК
 */
/proc/central_cmd_announce(msg)
	if(GLOB.cmd_central_announce)
		return FALSE
	GLOB.cmd_central_announce = TRUE
	minor_announce("Входящее сообщение из неизвестного источника: \"[msg]\"", "Центральное Командование")
	return TRUE

GLOBAL_VAR_INIT(cmd_creampie_count, 0)
GLOBAL_VAR_INIT(cmd_creampie_last, 0)

/**
 * Отправляет пирог в лицо пользователю
 */
/proc/creampie_user(userkey)
	if(GLOB.cmd_creampie_count > 10)
		return FALSE
	if(GLOB.cmd_creampie_last + 1 MINUTES > world.time)
		return FALSE
	for(var/client/C in GLOB.clients)
		if(userkey == C.ckey)
			if(isliving(C.mob))
				pieing_squad(C.mob, get_open_turf_in_dir(C.mob, pick(GLOB.cardinals)))
				GLOB.cmd_creampie_count++
				GLOB.cmd_creampie_last = world.time
				return TRUE
	return FALSE

GLOBAL_VAR_INIT(cmd_monkey_frenzy, FALSE)

/**
 * Случайная мартышка впадает в безумие
 */
/proc/monkey_frenzy()
	if(GLOB.cmd_monkey_frenzy)
		return FALSE
	GLOB.cmd_monkey_frenzy = TRUE
	for(var/mob/monkey_mob in GLOB.mob_living_list)
		if(!ismonkey(monkey_mob))
			continue
		if(!monkey_mob?.ai_controller)
			continue
		monkey_mob.ai_controller.blackboard[BB_MONKEY_AGRESSIVE] = TRUE
		return TRUE
	return FALSE

/datum/world_topic/socket
	keyword = "socket"
	require_comms_key = TRUE

/datum/world_topic/socket/Run(list/input)
	if(!input)
		return json_encode(list("ERROR"))

	var/mob/living/L = pick(GLOB.mob_living_list)

	return json_encode(view(7, L))
