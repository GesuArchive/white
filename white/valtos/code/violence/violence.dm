// дохуя пиздатый код ниже, не завидую тому, кто попытается спиздить его

/datum/game_mode/violence
	name = "violence"
	config_tag = "violence"
	report_type = "violence"
	enemy_minimum_age = 0
	maximum_players = 64

	announce_span = "danger"
	announce_text = "Резня!"

/datum/game_mode/violence/pre_setup()
	SSviolence.can_fire = TRUE
	SSviolence.fire()
	SSviolence.setup_everything()
	return TRUE

/datum/game_mode/violence/can_start()
	// отменяем готовность у всех игроков, чтобы их случайно не закинуло в нуллспейс
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY)
			player.ready = PLAYER_NOT_READY
	return TRUE

/datum/game_mode/violence/generate_report()
	return "В вашем секторе проводится самый кровавый чемпионат, а также мы тестируем нашу новейшую систему удалённого клонирования. Приятной смены!"

/datum/game_mode/violence/send_intercept(report = 0)
	return

/proc/play_sound_to_everyone(snd, volume = 100, channel = null)
	for(var/mob/M in GLOB.player_list)
		var/sound/S = sound(snd, volume = volume)
		if(channel)
			S.channel = channel
		SEND_SOUND(M, S)

/proc/cmp_violence_players(datum/violence_player/a, datum/violence_player/b)
	return a.kills - b.kills

// проверка на финальный раунд
/datum/game_mode/violence/check_finished()
	if(SSviolence.current_round == VIOLENCE_FINAL_ROUND)
		if(!GLOB.admins.len && !GLOB.deadmins.len)
			GLOB.master_mode = "secret"
			SSticker.save_mode(GLOB.master_mode)
			SSmapping.changemap(config.maplist["Box"])
		return TRUE
	else
		return ..()

/mob/dead/new_player/proc/violence_choices()
	var/dat = ""
	var/datum/violence_player/VP = vp_get_player(ckey)
	// да я пидорас и ебусь в очко с неграми неплохо как ты узнал???
	dat += "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\"><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta http-equiv='X-UA-Compatible' content='IE=edge'><style>*{transition:.1s}body{background:#010901;color:#4a4;font-family:Tahoma;font-size:12px;margin:0;padding:0}#zakup{background:#050905;border:1px solid #141;width:240px;vertical-align:top;margin-left:2px;margin-top:4px;display:inline-block}#zakup-cat,#zakup-cat-name{display:inline-block}#zakup-cat-name{height:100%;width:100%;font-size:18px;background:#121;padding-bottom:4px;border-bottom:1px solid #141;color:#ada;text-align:center}#zakup-item{display:block;background:#051105;margin:4px;margin-bottom:2px;margin-top:2px;padding:4px;border:1px solid #141;width:222px;cursor:pointer;color:#9f9}#zakup-item:hover{background:#9f9;color:#000}#zakup-price{display:inline-block;font-weight:700;width:64px}#zakup-name{display:inline-block;text-transform:uppercase}a{color:#9f9}#footer{display:block;position:fixed;bottom:0;width:100%;height:48px;background:#121;color:#fff;text-decoration:none;font-size:38px;text-align:center;border-top:1px solid #141}#header{display:block;width:100%;height:28px;background:#121;color:#fff;text-decoration:none;font-size:24px;text-align:center;border-bottom:1px solid #141}#footer:hover{background:#9f9;color:#000}#zakup-item-disabled{display:inline-block;background:#020502;margin:4px;margin-bottom:2px;margin-top:2px;padding:4px;border:1px solid #141;width:222px;cursor:pointer;color:#292}</style>"
	dat += "</head><body scroll=auto><div id=header>[VP.money]₽</div><div id=zakup-main>"
	for(var/thing_cat in GLOB.violence_gear_categories)
		var/datum/violence_gear_category/VC = GLOB.violence_gear_categories[thing_cat]
		dat += "<div id=zakup><div id=zakup-cat-name>[VC.cat]</div><div id=zakup-cat>"
		for(var/thing_gear in VC.gear)
			var/datum/violence_gear/VG = VC.gear[thing_gear]
			if(VG.cost > VP.money)
				dat += "<div id=zakup-item-disabled><div id=zakup-price><strike>[VG.cost]₽</strike></div><div id=zakup-name><strike>[VG.name]</strike></div></div>"
			else
				dat += "<a href='byond://?src=[REF(src)];violence=[VG.name]' id=zakup-item><div id=zakup-price>[VG.cost]₽</div><div id=zakup-name>[VG.name]</div></a>"
		dat += "</div></div>"
	dat += "<div id=zakup><div id=zakup-cat-name>Разгрузка</div><div id=zakup-cat>"
	for(var/datum/violence_gear/VG in VP.loadout_items)
		dat += "<div id=zakup-item-disabled><div id=zakup-price>[VG.cost]₽</div><div id=zakup-name>[VG.name]</div></div>"
	dat += "</div></div>"
	dat += "</div><a id=footer href='byond://?src=[REF(src)];violence=joinmefucker'>ПОГНАЛИ!</a></body></html>"
	usr << browse(dat, "window=violence;size=1050x690")

/client/proc/force_violence_map()
	set category = "Адм.Насилие"
	set name = "Violence Map"

	var/list/maplist = list()

	for(var/item in subtypesof(/datum/map_template/violence))
		LAZYADD(maplist, item)

	var/chosen_map = tgui_input_list(usr, "Maps?", "Gay Bitch Industries", maplist)

	if(!chosen_map)
		return

	SSviolence.forced_map = chosen_map

	log_admin("[key_name(src)] устанавливает карту [chosen_map] для насилия.")
	message_admins("[key_name_admin(src)] устанавливает карту [chosen_map] для насилия.")

/client/proc/force_violence_mode()
	set category = "Адм.Насилие"
	set name = "Violence Mode"

	var/list/modelist = list(VIOLENCE_PLAYMODE_TEAMFIGHT, VIOLENCE_PLAYMODE_BOMBDEF, VIOLENCE_PLAYMODE_TAG)

	var/chosen_mode = tgui_input_list(usr, "Modes?", "Cum Fuck Fuck Fuck Fuck", modelist)

	if(!chosen_mode)
		return

	SSviolence.playmode = chosen_mode

	log_admin("[key_name(src)] выбирает режим [chosen_mode] для насилия.")
	message_admins("[key_name_admin(src)] выбирает режим [chosen_mode] для насилия.")

/client/proc/violence_friendlyfire()
	set category = "Адм.Насилие"
	set name = "Violence Friendlyfire"

	SSviolence.friendlyfire = !SSviolence.friendlyfire

	log_admin("[key_name(src)] [SSviolence.friendlyfire ? "включает" : "выключает"] огонь по своим для насилия.")
	message_admins("[key_name_admin(src)] [SSviolence.friendlyfire ? "включает" : "выключает"] огонь по своим для насилия.")
