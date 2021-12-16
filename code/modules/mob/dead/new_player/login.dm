/mob/dead/new_player/Login()
	if(!client)
		return
	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.set_current(src)

	. = ..()
	if(!. || !client)
		return FALSE

	spawn(-1)
		client.crawler_sanity_check()
		//spawn(10 SECONDS)
		//	to_chat(src, "<div class='examine_block'><span class='greenannounce'><center> .: CRAWLER CONTROL SYSTEM :. </center></span><hr><span class='[crsc ? "greenannounce" : "boldwarning"]'><center> ВХОД [crsc ? "РАЗРЕШЁН" : "БЫЛ ЗАПИСАН НАШЕЙ СИСТЕМОЙ \[<a href='https://crawler.station13.ru/?ckey=[client?.ckey]'>?</a>\] \[<a href='https://station13.ru/ru/purgatory'>ЧТО ЭТО?</a>\]"] </center></span></div>")

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>ВАЖНАЯ ЗАМЕТКА:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Сервер сообщает:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	sight |= SEE_TURFS

	client.playtitlemusic()

	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(client)

	// Check if user should be added to interview queue
	if (!client.holder && CONFIG_GET(flag/panic_bunker) && CONFIG_GET(flag/panic_bunker_interview) && !(client.ckey in GLOB.interviews.approved_ckeys))
		var/required_living_minutes = CONFIG_GET(number/panic_bunker_living)
		var/living_minutes = client.get_exp_living(TRUE)
		if (required_living_minutes > living_minutes)
			client.interviewee = TRUE
			register_for_interview()
			return

	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "через [DisplayTimeText(tl)]"
		else
			postfix = "скоро"
		to_chat(src, "Пожалуйста, настройте своего персонажа и нажмите кнопку \"Готов\". Игра начнётся [postfix].")

	if (!GLOB.donators[ckey]) //It doesn't exist yet
		load_donator(ckey)

	client.update_metabalance_cache()
	client.proverka_na_pindosov()

	client.show_lobby()
