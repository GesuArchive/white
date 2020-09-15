/mob/dead/new_player/Login()
	if(!client)
		return
	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.current = src

	. = ..()
	if(!. || !client)
		return FALSE

	var/list/locinfo = client.get_loc_info()

	var/crsc = client.crawler_sanity_check()

	to_chat(src, "<div class='examine_block'><span class='greenannounce'><center>WHITE DREAM UAC</center><hr>\n\tПОЛЬЗОВАТЕЛЬ: [capitalize(client.ckey)]\n\tСТРАНА: [capitalize(locinfo["country"])]\n\tИГРОВОЕ ВРЕМЯ: [capitalize(client.get_exp_living())]</span><span class='[crsc ? "greenannounce" : "boldwarning"]'>\n\tВХОД [crsc ? "РАЗРЕШЁН" : "БЫЛ ЗАПИСАН НАШЕЙ СИСТЕМОЙ"]</span></div>")

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.admin_notice)
		to_chat(src, "<span class='notice'> > <b>ВАЖНАЯ ЗАМЕТКА:</b>\n \t [GLOB.admin_notice]</span>")

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, "<span class='notice'> > <b>Сервер сообщает:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]</span>")

	sight |= SEE_TURFS

	new_player_panel()
	client.playtitlemusic()
	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "через [DisplayTimeText(tl)]"
		else
			postfix = "скоро"
		to_chat(src, " >> Пожалуйста, настройте своего персонажа и нажмите кнопку \"Готов\". Игра начнётся [postfix].")

	if (!GLOB.donators[ckey]) //It doesn't exist yet
		load_donator(ckey)

	client.update_metabalance_cache()
	client.proverka_na_pindosov()
	client.proverka_na_obemky()
