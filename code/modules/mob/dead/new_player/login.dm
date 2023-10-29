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

	if(!SSviolence.active) // we don't care about fuckers in this mode
		spawn(-1)
			client.crawler_sanity_check()

	var/motd = global.config.motd
	var/version = global.config.current_version_string
	if(!SSviolence.active)
		if(motd)
			to_chat(src, "<div class=\"motd\">[motd]</div>")
		if(version && GLOB.changelog_json)
			to_chat(src, span_nzcrentr("[version] - <a href='byond://winset?command=view-changelog'>Список изменений</a>"))

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>ВАЖНАЯ ЗАМЕТКА:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Сервер сообщает:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	add_sight(SEE_TURFS)

	client.playtitlemusic()

	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(client)

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

	client?.show_lobby(src)
