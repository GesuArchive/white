
////////////////////////////////
/proc/message_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">AL:</span> <span class=\"message linkify\">[msg]</span></span>"
	to_chat(GLOB.admins,
		type = MESSAGE_TYPE_ADMINLOG,
		html = msg)

	webhook_send_garbage("ADMIN LOG", msg)

/proc/relay_msg_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">RELAY:</span> <span class=\"message linkify\">[msg]</span></span>"
	to_chat(GLOB.admins,
		type = MESSAGE_TYPE_ADMINLOG,
		html = msg)


///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(mob/M in world)
	set category = "Адм.Игра"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!check_rights())
		return
	// var/mob/M = tgui_input_list(usr, "Choose mob", "Show player panel", GLOB.mob_list)
	log_admin("[key_name(usr)] checked the individual player panel for [key_name(M)][isobserver(usr)?"":" while in game"].")

	if(!M)
		to_chat(usr, span_warning("You seem to be selecting a mob that doesn't exist anymore."))
		return

	var/body = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><title>Панель [M.key]</title></head>"
	body += "<body><b>[M]</b>"
	if(M.client)
		body += " с кеем <b>[M.client]</b> "
		body += "<A href='?_src_=holder;[HrefToken()];editrights=[(GLOB.admin_datums[M.client.ckey] || GLOB.deadmins[M.client.ckey]) ? "rank" : "add"];key=[M.key]'>[M.client.holder ? M.client.holder.rank : "Игрок"]</A>"
		if(CONFIG_GET(flag/use_exp_tracking))
			body += "<A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(M)]'>" + M.client.get_exp_living(FALSE) + "</a>"
			body += "<A href='?_src_=holder;[HrefToken()];toggleexempt=[REF(M.client)]'>T-Jobs</a>"

	if(isnewplayer(M))
		body += " <B>В лобби.</B> "
	else
		body += "<A href='?_src_=holder;[HrefToken()];revive=[REF(M)]'>Лечить</A>"

	if(M.client)
		body += "<br><b>Наша база:</b> [M.client.player_join_date] "
		body += "<b>Бьёнд:</b> [M.client.account_join_date]"
		body += "<br><b>Баны у пиндосов: </b> "
		if(CONFIG_GET(string/centcom_ban_db))
			body += "<a href='?_src_=holder;[HrefToken()];centcomlookup=[M.client.ckey]'>Поиск</a>"
		else
			body += "<i>Выкл?</i>"
		body += "<br><b>Мультиакки: </b> "
		body += "<a href='?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(M.client)]'>CID</a>"
		body += "<a href='?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(M.client)]'>IP</a>"
		body += "<br><b>Страна:</b> [M.client.get_loc_info()["country"]]"
		if(check_rights(R_SECURED, show_msg = FALSE))
			body += " | Город: [M.client.get_loc_info()["city"]]"
		body += "<br><b>Crawler:</b> <a href='?_src_=holder;[HrefToken()];pushmetocrawler=[REF(M.client)]'>INFO</a>"
		var/rep = 0
		rep += SSpersistence.antag_rep[M.ckey]
		body += "<br><b>Антаг-репа:</b> [rep] "
		if(check_rights(R_SECURED, show_msg = FALSE))
			body += "<a href='?_src_=holder;[HrefToken()];modantagrep=add;mob=[REF(M)]'>+</a> "
			body += "<a href='?_src_=holder;[HrefToken()];modantagrep=subtract;mob=[REF(M)]'>-</a> "
			body += "<a href='?_src_=holder;[HrefToken()];modantagrep=set;mob=[REF(M)]'>=</a> "
			body += "<a href='?_src_=holder;[HrefToken()];modantagrep=zero;mob=[REF(M)]'>0</a>"
		var/metabalance = M.client.get_metabalance()
		if(check_rights(R_SECURED, show_msg = FALSE))
			if(check_donations(M.client.ckey))
				body += "<br><b>Донатер:</b> [check_donations(M.client.ckey)] р."
		body += "<br><b>Метакэш</b>: [metabalance]"
		if(check_rights(R_SECURED, show_msg = FALSE))
			body += " <a href='?_src_=holder;[HrefToken()];changemetacash=[REF(M)]'>\[???\]</a>"
			body += " <a href='?_src_=holder;[HrefToken()];addmetacash=[REF(M)]'>\[!!!\]</a>"

		var/full_version = "Unknown"
		if(M.client.byond_version)
			full_version = "[M.client.byond_version].[M.client.byond_build ? M.client.byond_build : "xxx"]"
		body += "<br><b>Билд Бьёнда:</b> [full_version]<br>"

	body += "<br><a href='?_src_=vars;[HrefToken()];Vars=[REF(M)]'>VV</a>"
	if(M.mind)
		body += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>TP</a>"
		body += "<a href='?_src_=holder;[HrefToken()];skill=[REF(M)]'>SKILLS</a>"
	else
		body += "<a href='?_src_=holder;[HrefToken()];initmind=[REF(M)]'>Init Mind</a>"
	if (iscyborg(M))
		body += "<a href='?_src_=holder;[HrefToken()];borgpanel=[REF(M)]'>BP</a>"
	body += "<a href='?priv_msg=[M.ckey]'>PM</a>"
	body += "<a href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>SM</a>"
	if (ishuman(M) && M.mind)
		body += "<a href='?_src_=holder;[HrefToken()];HeadsetMessage=[REF(M)]'>HM</a>"
	body += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M)]'>FLW</a>"
	//Default to client logs if available
	var/source = LOGSRC_MOB
	if(M.client)
		source = LOGSRC_CLIENT
	body += "<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_src=[source]'>LOGS</a> <br>"

	body += "<b>Моб</b> = [M.type]<br><br>"

	body += "<b>Кара: </b><A href='?_src_=holder;[HrefToken()];boot2=[REF(M)]'>Кик</A>"
	if(M.client)
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key];newbanip=[M.client.address];newbancid=[M.client.computer_id]'>Бан</A>"
	else
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key]'>Бан (нет клиента)</A>"

	body += "<A href='?_src_=holder;[HrefToken()];showmessageckey=[M.ckey]'>Заметки</A>"
	if(M.client)
		// body += "<A href='?_src_=holder;[HrefToken()];sendtoprison=[REF(M)]'>Prison</A>"
		body += "\ <A href='?_src_=holder;[HrefToken()];sendbacktolobby=[REF(M)]'>Кинуть в лобби</A>"
		var/muted = M.client.prefs.muted
		body += "<br><b>Заглушить: </b> "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"white"]'>IC</font></a>"
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"white"]'>OOC</font></a>"
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"white"]'>LOOC</font></a>"
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"white"]'>PRAY</font></a>"
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"white"]'>ADMINHELP</font></a>"
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"white"]'>DEADCHAT</font></a>"
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"white"]'>ВСЁ</font></a>"

	body += "<br><b>Перемещение: </b>"
	body += "<A href='?_src_=holder;[HrefToken()];jumpto=[REF(M)]'><b>К цели</b></A>"
	body += "<A href='?_src_=holder;[HrefToken()];getmob=[REF(M)]'>Цель к себе</A>"
	body += "<A href='?_src_=holder;[HrefToken()];sendmob=[REF(M)]'>Отправить в</A>"

	body += "<br><b>Ролевое: </b>"
	body += "<A href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>Антаг</A>"
	body += "<A href='?_src_=holder;[HrefToken()];narrateto=[REF(M)]'>DN</A>"
	body += "<A href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>Голос в голове</A>"
	body += "<A href='?_src_=holder;[HrefToken()];playsoundto=[REF(M)]'>Проиграть звук лично</A>"
	body += "<A href='?_src_=holder;[HrefToken()];languagemenu=[REF(M)]'>Языки</A>"

	if (M.client)
		if(!isnewplayer(M))
			body += "<br>"
			//Human
			if(ishuman(M) && !ismonkey(M))
				body += "<B>Человек</B>: "
			else
				body += "<A href='?_src_=holder;[HrefToken()];humanone=[REF(M)]'>Человек</A>"

			//Monkey
			if(ismonkey(M))
				body += "<B>Манки</B>: "
			else
				body += "<A href='?_src_=holder;[HrefToken()];monkeyone=[REF(M)]'>Манки</A>"

			//Corgi
			if(iscorgi(M))
				body += "<B>Корги</B>: "
			else
				body += "<A href='?_src_=holder;[HrefToken()];corgione=[REF(M)]'>Корги</A>"

			//AI / Cyborg
			if(isAI(M))
				body += "<B>ИИ</B>: "
			else if(ishuman(M))
				body += "<A href='?_src_=holder;[HrefToken()];makeai=[REF(M)]'>ИИ</A>"
				body += "<A href='?_src_=holder;[HrefToken()];makerobot=[REF(M)]'>Робот</A>"
				body += "<A href='?_src_=holder;[HrefToken()];makealien=[REF(M)]'>Чужой</A>"
				body += "<A href='?_src_=holder;[HrefToken()];makeslime=[REF(M)]'>Слайм</A>"
				body += "<A href='?_src_=holder;[HrefToken()];makeblob=[REF(M)]'>Масса</A>"

			//Simple Animals
			if(isanimal(M))
				body += "<A href='?_src_=holder;[HrefToken()];makeanimal=[REF(M)]'>Re-Animalize</A>"
			else
				body += "<A href='?_src_=holder;[HrefToken()];makeanimal=[REF(M)]'>Animalize</A>"

			body += "<br><br>"
			body += "<b>ПЛОХАЯ ТРАНСФОРМАЦИЯ:</b><br>Использовать только когда знаете че делаете.<br>"
			body += "<b>Трахоёбля:</b> <A href='?_src_=holder;[HrefToken()];simplemake=observer;mob=[REF(M)]'>Гост</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=human;mob=[REF(M)]'>Хуман</A>"
			body += "<br><b>Алень:</b> <A href='?_src_=holder;[HrefToken()];simplemake=drone;mob=[REF(M)]'>Дрон</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=hunter;mob=[REF(M)]'>Охотник</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=sentinel;mob=[REF(M)]'>Страж</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=praetorian;mob=[REF(M)]'>Претор</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=queen;mob=[REF(M)]'>Королева</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=larva;mob=[REF(M)]'>Лярва</A>"
			body += "<br><b>Слайм:</b> <A href='?_src_=holder;[HrefToken()];simplemake=slime;mob=[REF(M)]'>Молодой</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=adultslime;mob=[REF(M)]'>Взрослый</A>"
			body += "<br><b>Другое:</b> <A href='?_src_=holder;[HrefToken()];simplemake=monkey;mob=[REF(M)]'>Мартыха</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=robot;mob=[REF(M)]'>Киборг</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=cat;mob=[REF(M)]'>Кот</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=runtime;mob=[REF(M)]'>Рантайм</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=corgi;mob=[REF(M)]'>Корги</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=ian;mob=[REF(M)]'>Ян</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=crab;mob=[REF(M)]'>Краб</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=coffee;mob=[REF(M)]'>Кофий</A>"
			body += "<br><b>Констракты:</b> <A href='?_src_=holder;[HrefToken()];simplemake=constructarmored;mob=[REF(M)]'>Джаггернаут</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=constructbuilder;mob=[REF(M)]'>Ремесленник</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=constructwraith;mob=[REF(M)]'>Жнец</A>"
			body += "<A href='?_src_=holder;[HrefToken()];simplemake=shade;mob=[REF(M)]'>Душка</A>"
			body += "<br>"

	if (M.client)
		body += "<br><b>Другое:</b> "
		//body += "<A href='?_src_=holder;[HrefToken()];forcespeech=[REF(M)]'>Форс-сей</A>"
		body += "<A href='?_src_=holder;[HrefToken()];tdome1=[REF(M)]'>Thunderdome 1</A>"
		body += "<A href='?_src_=holder;[HrefToken()];tdome2=[REF(M)]'>Thunderdome 2</A>"
		body += "<A href='?_src_=holder;[HrefToken()];tdomeadmin=[REF(M)]'>Thunderdome Admin</A>"
		body += "<A href='?_src_=holder;[HrefToken()];tdomeobserve=[REF(M)]'>Thunderdome Observer</A>"
		body += "<A href='?_src_=holder;[HrefToken()];admincommend=[REF(M)]'>Зарекомендовать</A>"

	body += "<br><br><br>"
	body += "</body></html>"

	var/datum/browser/popup = new(usr, "adminplayeropts-[REF(M)]", "Player Panel", 550, 515)
	popup.set_content(body)
	popup.open()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/Game()
	if(!check_rights(0))
		return

	var/dat = {"
		<center><B>Game Panel</B></center><hr>\n
		<A href='?src=[REF(src)];[HrefToken()];c_mode=1'>Change Game Mode</A><br>
		"}
	if(GLOB.master_mode == "secret")
		dat += "<A href='?src=[REF(src)];[HrefToken()];f_secret=1'>(Force Secret Mode)</A><br>"
	if(SSticker.is_mode("dynamic"))
		if(SSticker.current_state <= GAME_STATE_PREGAME)
			dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_roundstart=1'>(Force Roundstart Rulesets)</A><br>"
			if (GLOB.dynamic_forced_roundstart_ruleset.len > 0)
				for(var/datum/dynamic_ruleset/roundstart/rule in GLOB.dynamic_forced_roundstart_ruleset)
					dat += {"<A href='?src=[REF(src)];[HrefToken()];f_dynamic_roundstart_remove=[text_ref(rule)]'>-> [rule.name] <-</A><br>"}
				dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_roundstart_clear=1'>(Clear Rulesets)</A><br>"
			dat += "<A href='?src=[REF(src)];[HrefToken()];f_dynamic_options=1'>(Dynamic mode options)</A><br>"
		dat += "<hr/>"
	if(SSticker.IsRoundInProgress())
		dat += "<a href='?src=[REF(src)];[HrefToken()];gamemode_panel=1'>(Game Mode Panel)</a><BR>"
	dat += {"
		<BR>
		<A href='?src=[REF(src)];[HrefToken()];create_object=1'>Create Object</A><br>
		<A href='?src=[REF(src)];[HrefToken()];quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_turf=1'>Create Turf</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_mob=1'>Create Mob</A><br>
		"}

	if(marked_datum && istype(marked_datum, /atom))
		dat += "<A href='?src=[REF(src)];[HrefToken()];dupe_marked_datum=1'>Duplicate Marked Datum</A><br>"

	usr << browse(dat, "window=admin2;size=240x280")
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "Срв"
	set name = "Reboot World"
	set desc="Restarts the world immediately"
	if (!usr.client.holder)
		return

	var/localhost_addresses = list("127.0.0.1", "::1")
	var/list/options = list("Regular Restart", "Regular Restart (with delay)", "Hard Restart (No Delay/Feeback Reason)", "Hardest Restart (No actions, just reboot)", "Server Restart (Kill and restart DD)")

	if(SSticker.admin_delay_notice)
		if(tgui_alert(usr, "Are you sure? An admin has already delayed the round end for the following reason: [SSticker.admin_delay_notice]", "Confirmation", list("Yes", "No")) != "Yes")
			return FALSE

	var/result = tgui_input_list(usr, "Select reboot method", "World Reboot", options, options[1])
	if(result)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		var/init_by = "Востребовано [usr.client.holder.fakekey ? "скрытой педалью" : usr.key]."
		switch(result)
			if("Regular Restart")
				if(!(isnull(usr.client.address) || (usr.client.address in localhost_addresses)))
					if(tgui_alert(usr, "Are you sure you want to restart the server?","This server is live",list("Restart","Cancel")) != "Restart")
						return FALSE
				SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", 10)
			if("Regular Restart (with delay)")
				var/delay = input("What delay should the restart have (in seconds)?", "Restart Delay", 5) as num|null
				if(!delay)
					return FALSE
				if(!(isnull(usr.client.address) || (usr.client.address in localhost_addresses)))
					if(tgui_alert(usr,"Are you sure you want to restart the server?","This server is live",list("Restart","Cancel")) != "Restart")
						return FALSE
				SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", delay * 10)
			if("Hard Restart (No Delay, No Feeback Reason)")
				to_chat(world, "Перезагрузка мира - [init_by]")
				world.Reboot()
			if("Hardest Restart (No actions, just reboot)")
				to_chat(world, "Быстрая перезагрузка мира - [init_by]")
				world.Reboot(fast_track = TRUE)
			if("Server Restart (Kill and restart DD)")
				to_chat(world, "Жесткая перезагрузка мира - [init_by]")
				if(CONFIG_GET(flag/this_shit_is_stable))
					world.shelleo("curl -X POST http://localhost:3636/hard-reboot-white/[GLOB.round_id]")

/datum/admins/proc/end_round()
	set category = "Срв"
	set name = "End Round"
	set desc = "Attempts to produce a round end report and then restart the server organically."

	if (!usr.client.holder)
		return
	var/confirm = tgui_alert(usr, "End the round and  restart the game world?", "End Round", list("Yes", "Cancel"))
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		SSticker.force_ending = 1
		SSblackbox.record_feedback("tally", "admin_verb", 1, "End Round") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/announce()
	set category = "Особенное"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))
		return

	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		to_chat(world, "<span class='adminnotice'><b>[usr.client.holder.fakekey ? "Администратор" : usr.key] делает объявление:</b></span>\n \t [message]")
		log_admin("Announce: [key_name(usr)] : [message]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Announce") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/set_admin_notice()
	set category = "Особенное"
	set name = "Set Admin Notice"
	set desc ="Set an announcement that appears to everyone who joins the server. Only lasts this round"
	if(!check_rights(0))
		return

	var/new_admin_notice = input(src,"Set a public notice for this round. Everyone who joins the server will see it.\n(Leaving it blank will delete the current notice):","Set Notice",GLOB.admin_notice) as message|null
	if(new_admin_notice == null)
		return
	if(new_admin_notice == GLOB.admin_notice)
		return
	if(new_admin_notice == "")
		message_admins("[key_name(usr)] removed the admin notice.")
		log_admin("[key_name(usr)] removed the admin notice:\n[GLOB.admin_notice]")
	else
		message_admins("[key_name(usr)] set the admin notice.")
		log_admin("[key_name(usr)] set the admin notice:\n[new_admin_notice]")
		to_chat(world, span_adminnotice("<b>Admin Notice:</b>\n \t [new_admin_notice]"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Admin Notice") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	GLOB.admin_notice = new_admin_notice
	return

/datum/admins/proc/toggleooc()
	set category = "Срв"
	set desc="Toggle dis bitch"
	set name="Toggle OOC"
	toggle_ooc()
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle OOC", "[GLOB.ooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleoocdead()
	set category = "Срв"
	set desc="Toggle dis bitch"
	set name="Toggle Dead OOC"
	toggle_dooc()

	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Dead OOC", "[GLOB.dooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = "Срв"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(SSticker.current_state == GAME_STATE_PREGAME || SSticker.current_state == GAME_STATE_STARTUP)
		if(!SSticker.start_immediately)
			var/localhost_addresses = list("127.0.0.1", "::1")
			if(!(isnull(usr.client.address) || (usr.client.address in localhost_addresses)))
				if(tgui_alert(usr, "Are you sure you want to start the round?","Start Now",list("Start Now","Cancel")) != "Start Now")
					return FALSE
			SSticker.start_immediately = TRUE
			log_admin("[usr.key] has started the game.")
			var/msg = ""
			if(SSticker.current_state == GAME_STATE_STARTUP)
				msg = " (The server is still setting up, but the round will be \
					started as soon as possible.)"
			message_admins(span_blue("[usr.key] has started the game.[msg]"))
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Now") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			return TRUE
		SSticker.start_immediately = FALSE
		SSticker.SetTimeLeft(1800)
		to_chat(world, "<b>The game will start in 180 seconds.</b>")
		SEND_SOUND(world, sound(SSstation.announcer.get_rand_alert_sound()))
		message_admins(span_blue("[usr.key] has cancelled immediate game start. Game will start in 180 seconds."))
		log_admin("[usr.key] has cancelled immediate game start.")
	else
		to_chat(usr, span_red("Error: Start Now: Game has already started."))
	return FALSE

/datum/admins/proc/toggleenter()
	set category = "Срв"
	set desc="People can't enter"
	set name="Toggle Entering"
	if(!SSlag_switch.initialized)
		return
	SSlag_switch.set_measure(DISABLE_NON_OBSJOBS, !SSlag_switch.measures[DISABLE_NON_OBSJOBS])
	log_admin("[key_name(usr)] toggled new player game entering. Lag Switch at index ([DISABLE_NON_OBSJOBS])")
	message_admins("[key_name_admin(usr)] toggled new player game entering [SSlag_switch.measures[DISABLE_NON_OBSJOBS] ? "OFF" : "ON"].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Entering", "[!SSlag_switch.measures[DISABLE_NON_OBSJOBS] ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "Срв"
	set desc="People can't be AI"
	set name="Toggle AI"
	var/alai = CONFIG_GET(flag/allow_ai)
	CONFIG_SET(flag/allow_ai, !alai)
	if (alai)
		to_chat(world, "<B>The AI job is no longer chooseable.</B>")
	else
		to_chat(world, "<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle AI", "[!alai ? "Disabled" : "Enabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "Срв"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	var/new_nores = !CONFIG_GET(flag/norespawn)
	CONFIG_SET(flag/norespawn, new_nores)
	if (!new_nores)
		to_chat(world, "<B>Разрешено переродиться.</B>")
	else
		to_chat(world, "<B>Запрещено перерождаться.</B>")
	message_admins(span_adminnotice("[key_name_admin(usr)] toggled respawn to [!new_nores ? "On" : "Off"]."))
	log_admin("[key_name(usr)] toggled respawn to [!new_nores ? "On" : "Off"].")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Respawn", "[!new_nores ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "Срв"
	set desc="Delay the game start"
	set name="Delay Pre-Game"

	var/newtime = input("Set a new time in seconds. Set -1 for indefinite delay.","Set Delay",round(SSticker.GetTimeLeft()/10)) as num|null
	if(SSticker.current_state > GAME_STATE_PREGAME)
		return tgui_alert(usr, "Too late... The game has already started!")
	if(newtime)
		newtime = newtime*10
		SSticker.SetTimeLeft(newtime)
		SSticker.start_immediately = FALSE
		if(newtime < 0)
			to_chat(world, "<b>Запуск отложен.</b>")
			log_admin("[key_name(usr)] delayed the round start.")
		else
			to_chat(world, "<b>Игра начнётся через [DisplayTimeText(newtime)].</b>")
			SEND_SOUND(world, sound(SSstation.announcer.get_rand_alert_sound()))
			log_admin("[key_name(usr)] set the pre-game delay to [DisplayTimeText(newtime)].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delay Game Start") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/unprison(mob/M in GLOB.mob_list)
	set category = "Адм"
	set name = "Unprison"
	if (is_centcom_level(M.z))
		SSjob.SendToLateJoin(M)
		message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]")
		log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
	else
		tgui_alert(usr,"[M.name] is not prisoned.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unprison") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS
/datum/admins/proc/spawn_atom(object as text)
	set name = "Spawn"
	set category = "Дбг.Маппинг"
	set desc = "(atom path) Spawn an atom"



	if(!check_rights(R_SPAWN) || !object)
		return



	var/list/preparsed = splittext(object,":")
	var/path = preparsed[1]
	var/amount = 1
	if(preparsed.len > 1)
		amount = clamp(text2num(preparsed[2]),1,ADMIN_SPAWN_CAP)

	var/chosen = pick_closest_path(path)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		for(var/i in 1 to amount)
			var/atom/A = new chosen(T)
			A.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(usr)] spawned [amount] x [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/podspawn_atom(object as text)
	set category = "Дбг.Маппинг"
	set desc = "(atom path) Spawn an atom via supply drop"
	set name = "Podspawn"



	if(!check_rights(R_SPAWN))
		return



	var/chosen = pick_closest_path(object)
	if(!chosen)
		return
	var/turf/target_turf = get_turf(usr)

	if(ispath(chosen, /turf))
		target_turf.ChangeTurf(chosen)
	else
		var/obj/structure/closet/supplypod/pod = podspawn(list(
			"target" = target_turf,
			"path" = /obj/structure/closet/supplypod/centcompod,
		))
		//we need to set the admin spawn flag for the spawned items so we do it outside of the podspawn proc
		var/atom/A = new chosen(pod)
		A.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(usr)] pod-spawned [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Podspawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/spawn_cargo(object as text)
	set category = "Дбг.Маппинг"
	set desc = "(atom path) Spawn a cargo crate"
	set name = "Spawn Cargo"



	if(!check_rights(R_SPAWN))
		return



	var/chosen = pick_closest_path(object, make_types_fancy(subtypesof(/datum/supply_pack)))
	if(!chosen)
		return
	var/datum/supply_pack/S = new chosen
	S.admin_spawned = TRUE
	S.generate(get_turf(usr))

	log_admin("[key_name(usr)] spawned cargo pack [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Cargo") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/show_traitor_panel(mob/target_mob in GLOB.mob_list)
	set category = "Адм.Игра"
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"
	var/datum/mind/target_mind = target_mob.mind
	if(!target_mind)
		to_chat(usr, "This mob has no mind!")
		return
	if(!istype(target_mob) && !istype(target_mind))
		to_chat(usr, "This can only be used on instances of type /mob and /mind")
		return
	target_mind.traitor_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Traitor Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/show_skill_panel(target)
	set category = "Адм.Игра"
	set desc = "Edit mobs's experience and skill levels"
	set name = "Show Skill Panel"
	var/datum/mind/target_mind
	if(ismob(target))
		var/mob/target_mob = target
		target_mind = target_mob.mind
	else if (istype(target, /datum/mind))
		target_mind = target
	else
		to_chat(usr, "This can only be used on instances of type /mob and /mind")
		return
	var/datum/skill_panel/SP  = new(usr, target_mind)
	SP.ui_interact(usr)



/datum/admins/proc/toggletintedweldhelmets()
	set category = "Дбг.Интерфейс"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmes"
	GLOB.tinted_weldhelh = !( GLOB.tinted_weldhelh )
	if (GLOB.tinted_weldhelh)
		to_chat(world, "<B>The tinted_weldhelh has been enabled!</B>")
	else
		to_chat(world, "<B>The tinted_weldhelh has been disabled!</B>")
	log_admin("[key_name(usr)] toggled tinted_weldhelh.")
	message_admins("[key_name_admin(usr)] toggled tinted_weldhelh.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Tinted Welding Helmets", "[GLOB.tinted_weldhelh ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "Срв"
	set desc="Guests can't enter"
	set name="Toggle guests"
	var/new_guest_ban = !CONFIG_GET(flag/guest_ban)
	CONFIG_SET(flag/guest_ban, new_guest_ban)
	if (new_guest_ban)
		to_chat(world, "<B>Guests may no longer enter the game.</B>")
	else
		to_chat(world, "<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed.")
	message_admins(span_adminnotice("[key_name_admin(usr)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed."))
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Guests", "[!new_guest_ban ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/i in GLOB.silicon_mobs)
		var/mob/living/silicon/S = i
		ai_number++
		if(isAI(S))
			to_chat(usr, "<b>AI [key_name(S, usr)] laws:</b>")
		else if(iscyborg(S))
			var/mob/living/silicon/robot/R = S
			to_chat(usr, "<b>CYBORG [key_name(S, usr)] [R.connected_ai?"(Slaved to: [key_name(R.connected_ai)])":"(Independent)"]: laws:</b>")
		else if (ispAI(S))
			to_chat(usr, "<b>pAI [key_name(S, usr)] laws:</b>")
		else
			to_chat(usr, "<b>SOMETHING SILICON [key_name(S, usr)] laws:</b>")

		if (S.laws == null)
			to_chat(usr, "[key_name(S, usr)] laws are null?? Contact a coder.")
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		to_chat(usr, "<b>No AIs located</b>")

/datum/admins/proc/manage_free_slots()
	if(!check_rights())
		return
	var/datum/browser/browser = new(usr, "jobmanagement", "Manage Free Slots", 520)
	var/list/dat = list()
	var/count = 0

	if(!SSjob.initialized)
		tgui_alert(usr, "You cannot manage jobs before the job subsystem is initialized!")
		return

	if(SSlag_switch.measures[DISABLE_NON_OBSJOBS])
		dat += "<div class='notice red' style='font-size: 125%'>Lag Switch \"Disable non-observer late joining\" is ON. Only Observers may join!</div>"

	dat += "<table>"

	for(var/j in SSjob.occupations)
		var/datum/job/job = j
		count++
		var/J_title = html_encode(job.title)
		var/J_opPos = html_encode(job.total_positions - (job.total_positions - job.current_positions))
		var/J_totPos = html_encode(job.total_positions)
		dat += "<tr><td>[J_title]:</td> <td>[J_opPos]/[job.total_positions < 0 ? " (unlimited)" : J_totPos]"

		dat += "</td>"
		dat += "<td>"
		if(job.total_positions >= 0)
			dat += "<A href='?src=[REF(src)];[HrefToken()];customjobslot=[job.title]'>Custom</A> | "
			dat += "<A href='?src=[REF(src)];[HrefToken()];addjobslot=[job.title]'>Add 1</A> | "
			if(job.total_positions > job.current_positions)
				dat += "<A href='?src=[REF(src)];[HrefToken()];removejobslot=[job.title]'>Remove</A> | "
			else
				dat += "Remove | "
			dat += "<A href='?src=[REF(src)];[HrefToken()];unlimitjobslot=[job.title]'>Unlimit</A></td>"
		else
			dat += "<A href='?src=[REF(src)];[HrefToken()];limitjobslot=[job.title]'>Limit</A></td>"

	browser.height = min(100 + count * 20, 650)
	browser.set_content(dat.Join())
	browser.open()

/datum/admins/proc/dynamic_mode_options(mob/user)
	var/dat = {"
		<center><B><h2>Dynamic Mode Options</h2></B></center><hr>
		<br/>
		<h3>Common options</h3>
		<i>All these options can be changed midround.</i> <br/>
		<br/>
		<b>Force extended:</b> - Option is <a href='?src=[REF(src)];[HrefToken()];f_dynamic_force_extended=1'> <b>[GLOB.dynamic_forced_extended ? "ON" : "OFF"]</a></b>.
		<br/>This will force the round to be extended. No rulesets will be drafted. <br/>
		<br/>
		<b>No stacking:</b> - Option is <a href='?src=[REF(src)];[HrefToken()];f_dynamic_no_stacking=1'> <b>[GLOB.dynamic_no_stacking ? "ON" : "OFF"]</b></a>.
		<br/>Unless the threat goes above [GLOB.dynamic_stacking_limit], only one "round-ender" ruleset will be drafted. <br/>
		<br/>
		<b>Forced threat level:</b> Current value : <a href='?src=[REF(src)];[HrefToken()];f_dynamic_forced_threat=1'><b>[GLOB.dynamic_forced_threat_level]</b></a>.
		<br/>The value threat is set to if it is higher than -1.<br/>
		<br/>
		<br/>
		<b>Stacking threeshold:</b> Current value : <a href='?src=[REF(src)];[HrefToken()];f_dynamic_stacking_limit=1'><b>[GLOB.dynamic_stacking_limit]</b></a>.
		<br/>The threshold at which "round-ender" rulesets will stack. A value higher than 100 ensure this never happens. <br/>
		"}

	user << browse(dat, "window=dyn_mode_options;size=900x650")

/datum/admins/proc/create_or_modify_area()
	set category = "Дбг.Маппинг"
	set name = "Create or modify area"
	create_area(usr)

//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//

//RIP ferry snowflakes

//Kicks all the clients currently in the lobby. The second parameter (kick_only_afk) determins if an is_afk() check is ran, or if all clients are kicked
//defaults to kicking everyone (afk + non afk clients in the lobby)
//returns a list of ckeys of the kicked clients
/proc/kick_clients_in_lobby(message, kick_only_afk = 0)
	var/list/kicked_client_names = list()
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			if(kick_only_afk && !C.is_afk()) //Ignore clients who are not afk
				continue
			if(message)
				to_chat(C, message)
			kicked_client_names.Add("[C.key]")
			qdel(C)
	return kicked_client_names

//returns TRUE to let the dragdrop code know we are trapping this event
//returns FALSE if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(mob/dead/observer/frommob, mob/tomob)

	//this is the exact two check rights checks required to edit a ckey with vv.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_SPAWN|R_DEBUG,0))
		return FALSE



	if (!frommob.ckey)
		return FALSE

	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"

	var/ask = tgui_alert(usr, question, "Place ghost in control of mob?", list("Yes", "No"))
	if (ask != "Yes")
		return TRUE

	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return TRUE

	// Disassociates observer mind from the body mind
	if(tomob.client)
		tomob.ghostize(FALSE)
	else
		for(var/mob/dead/observer/ghost in GLOB.dead_mob_list)
			if(tomob.mind == ghost.mind)
				ghost.mind = null

	message_admins(span_adminnotice("[key_name_admin(usr)] has put [frommob.key] in control of [tomob.name]."))
	log_admin("[key_name(usr)] stuffed [frommob.key] into [tomob.name].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Ghost Drag Control")

	tomob.ckey = frommob.ckey
	tomob.client?.init_verbs()
	qdel(frommob)

	return TRUE

/client/proc/adminGreet(logout)
	if(SSticker.HasRoundStarted())
		var/string
		if(logout && CONFIG_GET(flag/announce_admin_logout))
			string = pick(
				"Admin logout: [key_name(src)]")
		else if(!logout && CONFIG_GET(flag/announce_admin_login))
			string = pick(
				"Admin login: [key_name(src)]")
		if(string)
			message_admins("[string]")

/datum/admins/proc/show_lag_switch_panel()
	set category = "Срв"
	set name = "Show Lag Switches"
	set desc="Display the controls for drastic lag mitigation measures."

	if(!SSlag_switch.initialized)
		to_chat(usr, span_notice("The Lag Switch subsystem has not yet been initialized."))
		return
	if(!check_rights())
		return

	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Lag Switches</title></head><body><h2><B>Lag (Reduction) Switches</B></h2>")
	dat += "Automatic Trigger: <a href='?_src_=holder;[HrefToken()];change_lag_switch_option=TOGGLE_AUTO'><b>[SSlag_switch.auto_switch ? "On" : "Off"]</b></a><br/>"
	dat += "Population Threshold: <a href='?_src_=holder;[HrefToken()];change_lag_switch_option=NUM'><b>[SSlag_switch.trigger_pop]</b></a><br/>"
	dat += "Slowmode Cooldown (toggle On/Off below): <a href='?_src_=holder;[HrefToken()];change_lag_switch_option=SLOWCOOL'><b>[SSlag_switch.slowmode_cooldown/10] seconds</b></a><br/>"
	dat += "<br/><b>SET ALL MEASURES: <a href='?_src_=holder;[HrefToken()];change_lag_switch=ALL_ON'>ON</a> | <a href='?_src_=holder;[HrefToken()];change_lag_switch=ALL_OFF'>OFF</a></b><br/>"
	dat += "<br/>Disable ghosts zoom and t-ray verbs (except staff): <a href='?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_GHOST_ZOOM_TRAY]'><b>[SSlag_switch.measures[DISABLE_GHOST_ZOOM_TRAY] ? "On" : "Off"]</b></a><br/>"
	dat += "Disable late joining: <a href='?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_NON_OBSJOBS]'><b>[SSlag_switch.measures[DISABLE_NON_OBSJOBS] ? "On" : "Off"]</b></a><br/>"
	dat += "<br/>============! MAD GHOSTS ZONE !============<br/>"
	dat += "Disable deadmob keyLoop (except staff, informs dchat): <a href='?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_DEAD_KEYLOOP]'><b>[SSlag_switch.measures[DISABLE_DEAD_KEYLOOP] ? "On" : "Off"]</b></a><br/>"
	dat += "==========================================<br/>"
	dat += "<br/><b>Measures below can be bypassed with a <abbr title='TRAIT_BYPASS_MEASURES'><u>special trait</u></abbr></b><br/>"
	dat += "Slowmode say verb (informs world): <a href='?_src_=holder;[HrefToken()];change_lag_switch=[SLOWMODE_SAY]'><b>[SSlag_switch.measures[SLOWMODE_SAY] ? "On" : "Off"]</b></a><br/>"
	dat += "Disable runechat: <a href='?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_RUNECHAT]'><b>[SSlag_switch.measures[DISABLE_RUNECHAT] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to speaker</span><br/>"
	dat += "Disable examine icons: <a href='?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_USR_ICON2HTML]'><b>[SSlag_switch.measures[DISABLE_USR_ICON2HTML] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to examiner</span><br/>"
	dat += "Disable parallax: <a href='?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_PARALLAX]'><b>[SSlag_switch.measures[DISABLE_PARALLAX] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to character</span><br />"
	dat += "Disable footsteps: <a href='?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_FOOTSTEPS]'><b>[SSlag_switch.measures[DISABLE_FOOTSTEPS] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to character</span><br />"
	dat += "</body></html>"
	usr << browse(dat.Join(), "window=lag_switch_panel;size=420x480")

/datum/admins/proc/get_spd_list()
	set category = "Адм"
	set name = "Get SPD List"

	if(!check_rights())
		return

	var/data = ""
	for(var/flag in SSspd.checked_flags)
		data += "[uppertext(flag)]: [english_list(SSspd.checked_flags[flag])]</br>"

	var/datum/browser/popup = new(usr, "spdlist", "Система Первичного Детектирования", 400, 650)
	popup.set_content(data)
	popup.open()

/datum/admins/proc/kill_system32()
