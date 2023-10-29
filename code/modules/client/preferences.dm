GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_slots = 3

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#c43b23"
	var/asaycolor = "#ff4500"			//This won't change the color for current admins, only incoming ones.
	var/auto_dementor = FALSE
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.

	var/UI_style = null
	var/buttons_locked = FALSE
	var/hotkeys = TRUE

	///Runechat preference. If true, certain messages will be displayed on the map, not ust on the chat area. Boolean.
	var/chat_on_map = TRUE
	///Limit preference on the size of the message. Requires chat_on_map to have effect.
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH
	///Whether non-mob messages will be displayed, such as machine vendor announcements. Requires chat_on_map to have effect. Boolean.
	var/see_chat_non_mob = TRUE
	///Whether emotes will be displayed on runechat. Requires chat_on_map to have effect. Boolean.
	var/see_rc_emotes = TRUE

	var/ice_cream_time = 10 MINUTES
	var/ice_cream = TRUE

	var/retro_hud = FALSE

	// Custom Keybindings
	var/list/key_bindings = list()

	var/tgui_fancy = TRUE
	var/tgui_lock = FALSE
	var/windowflashing = TRUE
	var/toggles = TOGGLES_DEFAULT
	var/w_toggles = W_TOGGLES_DEFAULT
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null

	var/uses_glasses_colour = TRUE

	//character preferences
	var/slot_randomized					//keeps track of round-to-round randomization of the character slot, prevents overwriting
	var/real_name						//our character's name
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/underwear = "Nude"				//underwear type
	var/underwear_color = "000"			//underwear color
	var/undershirt = "Nude"				//undershirt type
	var/socks = "Nude"					//socks type
	var/backpack = DBACKPACK				//backpack type
	var/jumpsuit_style = PREF_SUIT		//suit/skirt
	var/hairstyle = "Bald"				//Hair type
	var/hair_color = "000"				//Hair color
	var/hair_grad_style = "None"
	var/hair_grad_color = "000"
	var/facial_hairstyle = "Shaved"	//Face hair type
	var/facial_hair_color = "000"		//Facial hair color
	var/facial_grad_style = "None"
	var/facial_grad_color = "000"
	var/skin_tone = "caucasian1"		//Skin color
	var/eye_color_left = "000"
	var/eye_color_right = "000"
	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list("mcolor" = "FFF", "ethcolor" = "9c3030", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs", "moth_wings" = "Plain", "moth_antennae" = "Plain", "moth_markings" = "None")
	var/list/randomise = list(RANDOM_UNDERWEAR = TRUE, RANDOM_UNDERWEAR_COLOR = TRUE, RANDOM_UNDERSHIRT = TRUE, RANDOM_SOCKS = TRUE, RANDOM_BACKPACK = TRUE, RANDOM_JUMPSUIT_STYLE = TRUE, RANDOM_HAIRSTYLE = TRUE, RANDOM_HAIR_COLOR = TRUE, RANDOM_FACIAL_HAIRSTYLE = TRUE, RANDOM_FACIAL_HAIR_COLOR = TRUE, RANDOM_SKIN_TONE = TRUE, RANDOM_EYE_COLOR = TRUE)
	var/phobia = "spiders"

	var/forced_voice = "papa"

	var/list/custom_names = list()
	var/preferred_ai_core_display = "Blue"
	var/prefered_security_department = SEC_DEPT_RANDOM

	//Quirk list
	var/list/all_quirks = list()

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = BERANDOMJOB  //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences
	var/current_tab = 0

	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = -1

	var/widescreenwidth = 19

	var/parallax

	var/ambientocclusion = TRUE
	var/fullscreen = TRUE

	///Should we automatically fit the viewport?
	var/auto_fit_viewport = TRUE
	///What size should pixels be displayed as? 0 is strech to fit
	var/pixel_size = 0
	///What scaling method should we use? Distort means nearest neighbor
	var/scaling_method = SCALING_METHOD_NORMAL
	var/uplink_spawn_loc = UPLINK_PDA
	///The playtime_reward_cloak variable can be set to TRUE from the prefs menu only once the user has gained over 5K playtime hours. If true, it allows the user to get a cool looking roundstart cloak.
	var/playtime_reward_cloak = FALSE

	var/list/exp = list()
	var/list/menuoptions

	var/action_buttons_screen_locs = list()

	var/list/btprefsnew = list()
	var/btvolume_max = null
	var/en_names = FALSE

	//Loadout stuff
	var/list/gear = list()
	var/list/purchased_gear = list()
	var/list/list/equipped_gear_by_character = list()
	var/list/jobs_buyed = list()
	var/gear_tab = "Основное"
	///This var stores the amount of points the owner will get for making it out alive.
	var/hardcore_survival_score = 0

	///Someone thought we were nice! We get a little heart in OOC until we join the server past the below time (we can keep it until the end of the round otherwise)
	var/hearted
	///If we have a hearted commendations, we honor it every time the player loads preferences until this time has been passed
	var/hearted_until

	/// Agendered spessmen can choose whether to have a male or female bodytype
	var/body_type
	/// If we have persistent scars enabled
	var/persistent_scars = TRUE
	// Автокапитализация и поинтизация текста
	var/disabled_autocap = FALSE
	///If we want to broadcast deadchat connect/disconnect messages
	var/broadcast_login_logout = TRUE
	///What outfit typepaths we've favorited in the SelectEquipment menu
	var/list/favorite_outfits = list()

	// автоматическое согласие при входе
	var/iconsent = TRUE
	// автоматический запрет на интересности всем новым игрокам
	var/he_knows = FALSE

	/// Multiz Parallax option
	var/multiz_parallax = FALSE

	/// Multiz Performance option
	var/multiz_performance = -1


/datum/preferences/New(client/C)
	parent = C

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	if(retro_hud)
		UI_style = "Midnight"
	else
		UI_style = "Neoscreen"

	if(istype(C))
		if(!is_guest_key(C.key))
			load_path(C.ckey)

	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return

	//we couldn't load character data so just randomize the character appearance + name
	random_character()		//let's create a random character then - rather than a fat, bald and naked man.
	key_bindings = deep_copy_list(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	C?.set_macros()
	real_name = pref_species.random_name(gender, 1, en_lang = en_names)
	if(!loaded_preferences_successfully)
		save_preferences()

	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

/**
 * Fucking magic
 */

#define SETUP_START_NODE(L)  		  	 		 	 		"<div class='csetup_character_node'><div class='csetup_character_label'>[L]</div><div class='csetup_character_input'>"

#define SETUP_GET_LINK(pref, task, task_type, value) 		"<a href='?_src_=prefs;preference=[pref][task ? ";[task_type]=[task]" : ""]'>[value]</a>"
#define SETUP_GET_LINK_RANDOM(random_type) 		  	 		"<a href='?_src_=prefs;preference=toggle_random;random_type=[random_type]'>[randomise[random_type] ? "🎲" : "🔒"]</a>"
#define SETUP_COLOR_BOX(color) 				  	 	 		"<span style='border: 1px solid #161616; background-color: #[color];'>&nbsp;&nbsp;&nbsp;</span>"

#define SETUP_NODE_SWITCH(label, pref, value)		  		"[SETUP_START_NODE(label)][SETUP_GET_LINK(pref, null, null, value)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_INPUT(label, pref, value)		  		"[SETUP_START_NODE(label)][SETUP_GET_LINK(pref, "input", "task", value)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_COLOR(label, pref, color, random)  		"[SETUP_START_NODE(label)][SETUP_COLOR_BOX(color)][SETUP_GET_LINK(pref, "input", "task", "Изменить")][random ? "[SETUP_GET_LINK_RANDOM(random)]" : ""][SETUP_CLOSE_NODE]"
#define SETUP_NODE_RANDOM(label, random)		  	  		"[SETUP_START_NODE(label)][SETUP_GET_LINK_RANDOM(random)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_INPUT_RANDOM(label, pref, value, random) "[SETUP_START_NODE(label)][SETUP_GET_LINK(pref, "input", "task", value)][SETUP_GET_LINK_RANDOM(random)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_COLOR_RANDOM(label, pref, color, random) "[SETUP_START_NODE(label)][SETUP_COLOR_BOX(color)][SETUP_GET_LINK(pref, "input", "task", "Изменить")][SETUP_GET_LINK_RANDOM(random)][SETUP_CLOSE_NODE]"

#define SETUP_CLOSE_NODE 	  			  			  		"</div></div>"

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return

	if(!MC_RUNNING())
		to_chat(user, span_info("Сервер всё ещё инициализируется. Подождите..."))
		return
	if(slot_randomized)
		load_character(default_slot) // Reloads the character slot. Prevents random features from overwriting the slot if saved.
		slot_randomized = FALSE

	var/list/dat = list("<div id='prefsel'><div id='prefsel_menu'><div class='prefsel_menu_header'>Меню</div><ul>")

	dat += "<li><a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Персонаж</a></li>"
	dat += "<li><a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Магазин</a></li>"
	dat += "<li><a href='?_src_=prefs;preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>Игра</a></li>"
	dat += "<li><a href='?_src_=prefs;preference=tab;tab=3' [current_tab == 3 ? "class='linkOn'" : ""]>OOC</a></li>"
	dat += "<li><a href='?_src_=prefs;preference=tab;tab=4' [current_tab == 4 ? "class='linkOn'" : ""]>Хоткеи</a></li>"
	dat += "</ul>"

	dat += "<div class='prefsel_menu_header'>Настройки</div><ul>"

	if(!is_guest_key(user.key))
		dat += "<li><a href='?_src_=prefs;preference=load'>Отмена</a></li>"
		dat += "<li><a href='?_src_=prefs;preference=save'>Сохранить</a></li>"

	dat += "<li><a href='?_src_=prefs;preference=reset_all'>Сбросить</a></li></ul>"

	if(current_tab != 0)
		dat += "</div><div id='prefsel_main'>"

	switch(current_tab)
		if (0) // Character Settings#
			dat += "<div class='prefsel_menu_header'>Персонаж</div><ul>"
			dat += "<li><a href='?_src_=prefs;preference=job;task=menu'>Должности</a></li>"
			if(CONFIG_GET(flag/roundstart_traits))
				dat += "<li><a href='?_src_=prefs;preference=trait;task=menu'>Особенности</a></li>"
			dat += "</ul><div class='prefsel_menu_header'>Персонажи</div><ul>"
			if(path)
				var/savefile/S = new /savefile(path)
				if(S)
					dat += "<li>"
					var/name
					for(var/i=1, i<=max_slots, i++)
						S.cd = "/character[i]"
						S["real_name"] >> name
						if(!name)
							name = "Персонаж [i]"
						dat += "<a href='?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a> "
					dat += "</li>"
			dat += "</ul></div><div id='prefsel_main'><div class='csetup_main'>"
			if(is_banned_from(user.ckey, "Appearance"))
				dat += "<div class='csetup_banned'>Тебе нельзя. Ты всё ещё можешь настраивать персонажей, но в любом случае получишь случайную внешность и имя.</div>"
			dat += "<div class='csetup_content'><div class='csetup_header'>Имя</div><div class='csetup_nodes'>"
			dat += SETUP_START_NODE("Имя")
			dat += SETUP_GET_LINK("name", "input", "task", real_name)
			dat += SETUP_GET_LINK("name", "random", "task", "Случайное")
			dat += SETUP_CLOSE_NODE
			var/old_group
			for(var/custom_name_id in GLOB.preferences_custom_names)
				var/namedata = GLOB.preferences_custom_names[custom_name_id]
				if(!old_group)
					old_group = namedata["group"]
				else if(old_group != namedata["group"])
					old_group = namedata["group"]
				dat += SETUP_START_NODE(namedata["pref_name"])
				dat += SETUP_GET_LINK(custom_name_id, "input", "task", custom_names[custom_name_id])
				dat += SETUP_CLOSE_NODE

			dat += SETUP_NODE_RANDOM("Всегда случайное имя", RANDOM_NAME)
			dat += SETUP_NODE_SWITCH("Язык генератора имени", "name_lang", en_names ? "EN" : "RU")
			dat += SETUP_NODE_RANDOM("Случайное имя, если антагонист", RANDOM_NAME_ANTAG)

			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Тело</div><div class='csetup_nodes'>"

			dat += "<div class='csetup_character_node'><img class='wideimage icon icon-misc' src='data:image/png;base64,[icon2base64(get_preview_icon())]'></div>"

			if(!(AGENDER in pref_species.species_traits))
				var/dispGender
				if(gender == MALE)
					dispGender = "Мужской"
				else if(gender == FEMALE)
					dispGender = "Женский"
				else
					dispGender = "УДАРНЫЙ ВЕРТОЛЁТ"
				dat += SETUP_START_NODE("Пол")
				dat += SETUP_GET_LINK("gender", null, null, dispGender)
				dat += SETUP_CLOSE_NODE
				if(gender == PLURAL || gender == NEUTER)
					dat += SETUP_START_NODE("Тип тела")
					dat += SETUP_GET_LINK("body_type", null, null, body_type == MALE ? "Мужской" : "Женский")
					dat += SETUP_CLOSE_NODE
				if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG]) //doesn't work unless random body
					dat += SETUP_NODE_RANDOM("Всегда случайный пол", RANDOM_GENDER)
					dat += SETUP_NODE_RANDOM("Когда антагонист", RANDOM_GENDER_ANTAG)

			dat += SETUP_NODE_INPUT("Возраст", "age", age)

			dat += SETUP_NODE_INPUT("Голос", "tts_voice", GLOB.tts_voices[forced_voice])

			if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG]) //doesn't work unless random body
				dat += SETUP_NODE_RANDOM("Всегда случайный возраст", RANDOM_AGE)
				dat += SETUP_NODE_RANDOM("Когда антагонист", RANDOM_AGE_ANTAG)

			if(user.client.get_exp_living(TRUE) >= PLAYTIME_HARDCORE_RANDOM)
				dat += SETUP_NODE_RANDOM("Режим хардкора", RANDOM_HARDCORE)

			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Должностное</div><div class='csetup_nodes'>"

			dat += SETUP_NODE_INPUT("Дисплей ИИ", "ai_core_icon", preferred_ai_core_display)
			dat += SETUP_NODE_INPUT("Отдел офицера", "sec_dept", prefered_security_department)

			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Основное</div><div class='csetup_nodes'>"

			dat += SETUP_NODE_RANDOM("Случайное тело, если антаг", RANDOM_BODY_ANTAG)

			dat += SETUP_START_NODE("Ксенотип")
			dat += SETUP_GET_LINK("species", "input", "task", pref_species.name)
			dat += SETUP_GET_LINK("species", "random", "task", "Случайно")
			dat += SETUP_GET_LINK("toggle_random", RANDOM_SPECIES, "random_type", randomise[RANDOM_SPECIES] ? "🎲" : "🔒")
			dat += SETUP_CLOSE_NODE

			dat += SETUP_NODE_INPUT_RANDOM("Бельё", "underwear", underwear, RANDOM_UNDERWEAR)
			dat += SETUP_NODE_COLOR_RANDOM("Цвет белья", "underwear_color", underwear_color, RANDOM_UNDERWEAR_COLOR)
			dat += SETUP_NODE_INPUT_RANDOM("Рубаха", "undershirt", undershirt, RANDOM_UNDERSHIRT)
			dat += SETUP_NODE_INPUT_RANDOM("Носки", "socks", socks, RANDOM_SOCKS)
			dat += SETUP_NODE_INPUT_RANDOM("Рюкзак", "bag", backpack_to_ru_conversion(backpack), RANDOM_BACKPACK)
			dat += SETUP_NODE_INPUT_RANDOM("Комбез", "suit", jumpsuit_to_ru_conversion(jumpsuit_style), RANDOM_JUMPSUIT_STYLE)
			dat += SETUP_NODE_INPUT("Аплинк", "uplink_loc", uplink_to_ru_conversion(uplink_spawn_loc))

			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Подробное</div><div class='csetup_nodes'>"

			//Adds a thing to select which phobia because I can't be assed to put that in the quirks window
			if("Фобия" in all_quirks)
				dat += SETUP_NODE_INPUT("Фобия", "phobia", phobia)

			if((HAS_FLESH in pref_species.species_traits) || (HAS_BONE in pref_species.species_traits))
				dat += SETUP_START_NODE("Получение шрамов")
				dat += SETUP_GET_LINK("persistent_scars", null, null, persistent_scars ? "Включено" : "Отключено")
				dat += SETUP_GET_LINK("clear_scars", null, null, "Очистить")
				dat += SETUP_CLOSE_NODE

			var/use_skintones = pref_species.use_skintones
			if(use_skintones)
				dat += SETUP_NODE_INPUT_RANDOM("Раса", "s_tone", skin_tone, RANDOM_SKIN_TONE)

			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
				dat += SETUP_NODE_COLOR("Мутацвет", "mutant_color", features["mcolor"], null)

			if(istype(pref_species, /datum/species/ethereal)) //not the best thing to do tbf but I dont know whats better.
				dat += SETUP_NODE_COLOR("Цвет эфира", "color_ethereal", features["ethcolor"], null)

			if((EYECOLOR in pref_species.species_traits) && !(NOEYESPRITES in pref_species.species_traits))
				if("Гетерохромия" in all_quirks)
					dat += SETUP_NODE_COLOR("Цвет левого глаза", "left_eye", eye_color_left, RANDOM_EYE_COLOR)
					dat += SETUP_NODE_COLOR("Цвет правого глаза", "right_eye", eye_color_right, RANDOM_EYE_COLOR)
				else
					dat += SETUP_NODE_COLOR("Цвет глаз", "eyes", eye_color_left, RANDOM_EYE_COLOR)

			if(HAIR in pref_species.species_traits)
				dat += SETUP_NODE_INPUT_RANDOM("Причёска", "hairstyle", hairstyle, RANDOM_HAIRSTYLE)
				dat += SETUP_NODE_COLOR("Цвет причёски", "hair", hair_color, RANDOM_HAIR_COLOR)
				dat += SETUP_NODE_COLOR("Цвет градиента", "hair_grad_color", hair_grad_color, null)
				dat += SETUP_NODE_INPUT("Стиль градиента", "hair_grad_style", hair_grad_style)

				dat += SETUP_NODE_INPUT_RANDOM("Борода", "facial_hairstyle", facial_hairstyle, RANDOM_FACIAL_HAIRSTYLE)
				dat += SETUP_NODE_COLOR("Цвет бороды", "facial", facial_hair_color, RANDOM_FACIAL_HAIR_COLOR)
				dat += SETUP_NODE_COLOR("Цвет градиента", "facial_grad_color", facial_grad_color, null)
				dat += SETUP_NODE_INPUT("Градиент бороды", "facial_grad_style", facial_grad_style)

			//Mutant stuff

			if(pref_species.mutant_bodyparts["ipc_screen"])
				dat += SETUP_NODE_INPUT("Экран", "ipc_screen", features["ipc_screen"])

			if(pref_species.mutant_bodyparts["ipc_antenna"])
				dat += SETUP_NODE_INPUT("Антенна", "ipc_antenna", features["ipc_antenna"])

			if(pref_species.mutant_bodyparts["tail_lizard"])
				dat += SETUP_NODE_INPUT("Хвост", "tail_lizard", features["tail_lizard"])

			if(pref_species.mutant_bodyparts["horns"])
				dat += SETUP_NODE_INPUT("Рожки", "horns", features["horns"])

			if(pref_species.mutant_bodyparts["frills"])
				dat += SETUP_NODE_INPUT("Украшения", "frills", features["frills"])

			if(pref_species.mutant_bodyparts["body_markings"])
				dat += SETUP_NODE_INPUT("Маркировки", "body_markings", features["body_markings"])

			if(pref_species.mutant_bodyparts["legs"])
				dat += SETUP_NODE_INPUT("Ноги", "legs", features["legs"])

			if(pref_species.mutant_bodyparts["moth_wings"])
				dat += SETUP_NODE_INPUT("Крылья", "moth_wings", features["moth_wings"])

			if(pref_species.mutant_bodyparts["moth_antennae"])
				dat += SETUP_NODE_INPUT("Антенна", "moth_antennae", features["moth_antennae"])

			if(pref_species.mutant_bodyparts["moth_markings"])
				dat += SETUP_NODE_INPUT("Маркировки", "moth_markings", features["moth_markings"])

			if(pref_species.mutant_bodyparts["tail_human"])
				dat += SETUP_NODE_INPUT("Хвост", "tail_human", features["tail_human"])

			if(pref_species.mutant_bodyparts["ears"])
				dat += SETUP_NODE_INPUT("Уши", "ears", features["ears"])

			dat += "</div></div></div></div></div>"

		if(1)
			var/list/type_blacklist = list()
			if(LAZYACCESS(equipped_gear_by_character, default_slot))
				if(LAZYLEN(equipped_gear_by_character[default_slot]))
					for(var/i = 1, i <= LAZYLEN(equipped_gear_by_character[default_slot]), i++)
						var/datum/gear/G = GLOB.gear_datums[equipped_gear_by_character[default_slot][i]]
						if(G)
							if(G.subtype_path in type_blacklist)
								continue
							type_blacklist += G.subtype_path
						else
							equipped_gear_by_character[default_slot].Cut(i, i+1)
			else
				LAZYSETLEN(equipped_gear_by_character, 20)
				LAZYADDASSOCLIST(equipped_gear_by_character, default_slot, null)
			var/fcolor =  "#ffffff"
			var/metabalance = user.client.get_metabalance()
			dat += "<table align='center' width='100%' class='metamag'>"
			dat += "<tr><td colspan=4 class='bal'><center>"
			dat += "<b>Баланс: <img src='[SSassets.transport.get_asset_url("mc_32.gif")]' width=16 height=16 border=0>"
			dat += "<font color='[fcolor]'>[metabalance]</font> метакэша.</b>"
			dat += "<a href='?_src_=prefs;preference=gear;clear_loadout=1'>Снять все предметы</a></center></td></tr>"
			dat += "<tr><td colspan=4><center><b>"


			if(gear_tab == "Инвентарь")
				dat += span_linkoff("Инвентарь")
			else
				dat += "<a href='?_src_=prefs;preference=gear;select_category=Инвентарь'>Инвентарь</a>"

			for(var/category in GLOB.loadout_categories)
				if(category == gear_tab)
					dat += " <span class='linkOff'>[category]</span> "
				else
					dat += " <a href='?_src_=prefs;preference=gear;select_category=[category]'>[category]</a> "
			dat += "</b></center></td></tr>"

			dat += "<tr><td colspan=4><hr></td></tr>"

			if(gear_tab != "Инвентарь")
				dat += "<tr><td><b>Название</b></td>"
				dat += "<td><b>Цена</b></td>"
				dat += "<td><b>Роли</b></td>"
				dat += "<td><b>Описание</b></td></tr>"
				dat += "<tr><td colspan=4><hr></td></tr>"
				var/datum/loadout_category/LC = GLOB.loadout_categories[gear_tab]
				for(var/gear_name in LC.gear)
					var/datum/gear/G = LC.gear[gear_name]
					var/ticked = (G.id in equipped_gear_by_character[default_slot])

					dat += "<tr style='vertical-align:middle;' class='metaitem"
					if(G.id in purchased_gear)
						dat += " buyed'><td width=350>"
						if(G.sort_category == "OOC")
							dat += "<a style='white-space:normal;' href='?_src_=prefs;preference=gear;purchase_gear=[G.id]'>Купить ещё</a>"
						else if(G.sort_category == "Роли")
							dat += "<a style='white-space:normal;' href='#'>Куплено</a>"
						else
							dat += "[G.get_base64_icon_html()]<a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?_src_=prefs;preference=gear;toggle_gear=[G.id]'>[ticked ? "Экипировано" : "Экипировать"]</a>"
					else
						dat += "'><td width=350>"
						if(G.sort_category == "OOC" || G.sort_category == "Роли")
							dat += "<a style='white-space:normal;' href='?_src_=prefs;preference=gear;purchase_gear=[G.id]'>Купить</a>"
						else
							dat += "[G.get_base64_icon_html()]<a style='white-space:normal;' href='?_src_=prefs;preference=gear;purchase_gear=[G.id]'>Купить</a>"
					dat += " - [capitalize(G.display_name)]</td>"
					dat += "<td width=5% style='vertical-align:middle' class='metaprice'>[G.cost]</td><td>"
					if(G.allowed_roles)
						dat += "<font size=2>[english_list(G.allowed_roles)]</font>"
					else
						dat += "<font size=2>Все</font>"
					dat += "</td><td><font size=2><i>[G.description]</i></font></td></tr>"
			else
				for(var/category in GLOB.loadout_categories)
					if(category == "OOC" || category == "Роли")
						continue
					dat += "<tr class='metaitem buyed'><td><b>[category]:</b></td><td>"
					for(var/gear_name in purchased_gear)
						var/datum/gear/G = GLOB.gear_datums[gear_name]
						if(!G || category != G.sort_category)
							continue
						var/ticked = (G.id in equipped_gear_by_character[default_slot])
						dat += "<a class='tooltip[ticked ? " linkOn" : ""]' href='?_src_=prefs;preference=gear;toggle_gear=[G.id]'>[G.get_base64_icon_html()]<span class='tooltiptext'>[G.display_name]</span></a>"
					dat += "</td></tr>"
			dat += "</table>"

		if (2) // Game Preferences
			dat += "<div class='csetup_main'>"
			dat += "<div class='csetup_content'><div class='csetup_header'>Интерфейс</div><div class='csetup_nodes'>"
			dat += SETUP_NODE_INPUT("Стиль", "ui", UI_style)
			dat += SETUP_NODE_SWITCH("Старый интерфейс", "retro_hud", retro_hud ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Окна в TGUI", "tgui_lock", tgui_lock ? "Основные" : "Все")
			dat += SETUP_NODE_SWITCH("Стиль TGUI", "tgui_fancy", tgui_fancy ? "Красивый" : "Строгие рамки")
			dat += SETUP_NODE_SWITCH("Кнопки действий", "action_buttons", buttons_locked ? "Не двигаются" : "Свободные")
			dat += SETUP_NODE_SWITCH("Режим хоткеев", "hotkeys", hotkeys ? "Хоткеи" : "Ретро")
			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Runechat</div><div class='csetup_nodes'>"
			dat += SETUP_NODE_SWITCH("Текст над головой", "chat_on_map", chat_on_map ? "Вкл" : "Выкл")
			dat += SETUP_NODE_INPUT("Максимальная длина", "max_chat_length", max_chat_length)
			dat += SETUP_NODE_SWITCH("Текст не только у мобов", "see_chat_non_mob", see_chat_non_mob ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Эмоции над головой", "see_rc_emotes", see_rc_emotes ? "Вкл" : "Выкл")
			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Призрак</div><div class='csetup_nodes'>"
			dat += SETUP_NODE_SWITCH("Разговоры", "ghost_ears", (chat_toggles & CHAT_GHOSTEARS) ? "Все" : "Рядом")
			dat += SETUP_NODE_SWITCH("Радиопереговоры", "ghost_radio", (chat_toggles & CHAT_GHOSTRADIO) ? "Все" : "Рядом")
			dat += SETUP_NODE_SWITCH("Эмоуты", "ghost_sight", (chat_toggles & CHAT_GHOSTSIGHT) ? "Все" : "Рядом")
			dat += SETUP_NODE_SWITCH("Шёпот", "ghost_whispers", (chat_toggles & CHAT_GHOSTWHISPER) ? "Все" : "Рядом")
			dat += SETUP_NODE_SWITCH("ПДА", "ghost_pda", (chat_toggles & CHAT_GHOSTPDA) ? "Все" : "Рядом")
			dat += SETUP_NODE_SWITCH("Вход/Выход призраков", "hear_login_logout", (chat_toggles & CHAT_LOGIN_LOGOUT) ? "Слушать" : "Не слушать")
			dat += SETUP_NODE_SWITCH("Мой выход", "broadcast_login_logout", broadcast_login_logout ? "Оповещать" : "Молчать")
			dat += SETUP_NODE_INPUT("Форма", "ghostform", ghost_form)
			dat += SETUP_NODE_INPUT("Орбита", "ghostorbit", ghost_orbit)
			dat += SETUP_NODE_SWITCH("Передача тела", "ice_cream", ice_cream ? "Вкл" : "Выкл")
			if(ice_cream)
				dat += SETUP_NODE_INPUT("Таймер до передачи", "ice_cream_time", "[ice_cream_time/600] минут")

			var/button_name = "If you see this something went wrong."
			switch(ghost_accs)
				if(GHOST_ACCS_FULL)
					button_name = GHOST_ACCS_FULL_NAME
				if(GHOST_ACCS_DIR)
					button_name = GHOST_ACCS_DIR_NAME
				if(GHOST_ACCS_NONE)
					button_name = GHOST_ACCS_NONE_NAME

			dat += SETUP_NODE_INPUT("Вид призрако", "ghostaccs", button_name)

			switch(ghost_others)
				if(GHOST_OTHERS_THEIR_SETTING)
					button_name = GHOST_OTHERS_THEIR_SETTING_NAME
				if(GHOST_OTHERS_DEFAULT_SPRITE)
					button_name = GHOST_OTHERS_DEFAULT_SPRITE_NAME
				if(GHOST_OTHERS_SIMPLE)
					button_name = GHOST_OTHERS_SIMPLE_NAME

			dat += SETUP_NODE_INPUT("Призраки других", "ghostothers", button_name)
			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Графика</div><div class='csetup_nodes'>"
			dat += SETUP_NODE_SWITCH("Автокоррекция текста", "disabled_autocap", disabled_autocap ? "Выкл" : "Вкл")
			dat += SETUP_NODE_SWITCH("Сообщения ID-карты", "income_pings", (chat_toggles & CHAT_BANKCARD) ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Избыточные сообщения", "chat_spam", (chat_toggles & CHAT_SPAM) ? "Вкл" : "Выкл")
			dat += SETUP_NODE_INPUT("FPS", "clientfps", clientfps)

			switch (parallax)
				if (PARALLAX_LOW)
					button_name = "Low"
				if (PARALLAX_MED)
					button_name = "Medium"
				if (PARALLAX_INSANE)
					button_name = "Insane"
				if (PARALLAX_DISABLE)
					button_name = "Disabled"
				else
					button_name = "High"

			dat += SETUP_NODE_SWITCH("Параллакс", "parallaxdown", button_name)
			dat += SETUP_NODE_SWITCH("Эффект глубины", "multiz_parallax", multiz_parallax ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Ограничение глубины", "multiz_performance", multiz_performance == -1 ? "Выкл" : multiz_performance)
			dat += SETUP_NODE_SWITCH("Тени", "ambientocclusion", ambientocclusion ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Подстройка экрана", "auto_fit_viewport", auto_fit_viewport ? "Авто" : "Вручную")
			dat += SETUP_NODE_SWITCH("Полный экран", "fullscreen", fullscreen ? "Вкл" : "Выкл")

			if (CONFIG_GET(string/default_view) != CONFIG_GET(string/default_view_square))
				dat += SETUP_NODE_INPUT("Ширина экрана", "widescreenwidth", widescreenwidth)

			button_name = pixel_size
			dat += SETUP_NODE_SWITCH("Скалирование", "pixel_size", (button_name) ? "Один к [button_name]" : "Растянуть")

			switch(scaling_method)
				if(SCALING_METHOD_DISTORT)
					button_name = "Nearest Neighbor"
				if(SCALING_METHOD_NORMAL)
					button_name = "Point Sampling"
				if(SCALING_METHOD_BLUR)
					button_name = "Bilinear"

			dat += SETUP_NODE_SWITCH("Метод", "scaling_method", button_name)

			dat += SETUP_NODE_SWITCH("Контекст", "tooltip_no_context", (w_toggles & TOOLTIP_NO_CONTEXT) ? "Выкл" : "Вкл")
			dat += SETUP_NODE_SWITCH("Позиция на экране", "tooltip_pos", (w_toggles & TOOLTIP_USER_POS) ? "Внизу" : "Вверху")
			dat += SETUP_NODE_SWITCH("Ретро-статусбар", "tooltip_retro", (w_toggles & TOOLTIP_USER_RETRO) ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Горизонтальная инверсия", "horiz_inv", (w_toggles & SCREEN_HORIZ_INV) ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Вертикальная инверсия", "verti_inv", (w_toggles & SCREEN_VERTI_INV) ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Невидимые разделители", "hide_split", (w_toggles & SCREEN_HIDE_SPLIT) ? "Вкл" : "Выкл")

			if (CONFIG_GET(flag/maprotation))
				var/p_map = preferred_map
				if (!p_map)
					p_map = "Default"
					if (config.defaultmap)
						p_map += " ([config.defaultmap.map_name])"
				else
					if (p_map in config.maplist)
						var/datum/map_config/VM = config.maplist[p_map]
						if (!VM)
							p_map += " (No longer exists)"
						else
							p_map = VM.map_name
					else
						p_map += " (No longer exists)"
				if(CONFIG_GET(flag/preference_map_voting))
					dat += SETUP_NODE_INPUT("Любимая карта", "preferred_map", p_map)

			dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Спецроли</div><div class='csetup_nodes'>"

			var/display_roles = TRUE

			if(!check_whitelist(user?.ckey))
				dat += "<font color='#aaaaaa'><b>Специальные роли доступны только игрокам из вайтлиста.</b></font>"
				display_roles = FALSE
			else if(user?.client?.get_metabalance() < 50)
				dat += "<font color='#ff3333'><b>Отрицательная карма. Получение роли невозможно.</b></font>"
				display_roles = FALSE
			else if(is_banned_from(user.ckey, ROLE_SYNDICATE))
				dat += "<font color='#fda2fa'><b>Тебе нельзя быть антагами.</b></font>"
				src.be_special = list()
				display_roles = FALSE

			if(display_roles)
				for (var/i in GLOB.special_roles)
					if(is_banned_from(user.ckey, i))
						dat += SETUP_NODE_SWITCH(capitalize(i), "suck", "БАН")
					else
						var/days_remaining = null
						if(ispath(GLOB.special_roles[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
							var/mode_path = GLOB.special_roles[i]
							var/datum/game_mode/temp_mode = new mode_path
							days_remaining = temp_mode.get_remaining_days(user.client)

						if(days_remaining)
							dat += SETUP_NODE_SWITCH(capitalize(i), "suck", "Через [days_remaining] дней")
						else
							dat += SETUP_START_NODE(capitalize(i))
							dat += SETUP_GET_LINK("be_special", i, "be_special_type", (i in be_special) ? "Да" : "Нет")
							dat += SETUP_CLOSE_NODE
			dat += SETUP_NODE_SWITCH("Посреди раунда", "allow_midround_antag", (toggles & MIDROUND_ANTAG) ? "Да" : "Нет")
			dat += "</div></div></div>"
		if(3) //OOC Preferences
			dat += "<div class='csetup_main'>"
			dat += "<div class='csetup_content'><div class='csetup_header'>Настройки OOC</div><div class='csetup_nodes'>"
			dat += SETUP_NODE_SWITCH("Мигание окна", "winflash", windowflashing ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Слышать MIDIs", "hear_midis", (toggles & SOUND_MIDI) ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Слышать Лобби", "lobby_music", (toggles & SOUND_LOBBY) ? "Вкл" : "Выкл")
			dat += SETUP_NODE_SWITCH("Звук конца раунда", "endofround_sounds", (toggles & SOUND_ENDOFROUND) ? "Вкл" : "Выкл")
			if(user.client)
				if(unlock_content)
					dat += SETUP_NODE_SWITCH("BYOND Membership Publicity", "publicity", (toggles & MEMBER_PUBLIC) ? "Public" : "Hidden")

				if(unlock_content || check_rights_for(user.client, R_ADMIN) || check_donations(user.client.ckey) >= 100)
					dat += SETUP_NODE_COLOR("Цвет OOC", "ooccolor", replacetext(ooccolor ? ooccolor : GLOB.normal_ooc_colour, "#", ""), null)

			dat += "</div></div>"

			if(user.client.holder)
				dat += "<div class='csetup_content'><div class='csetup_header'>Admin Settings</div><div class='csetup_nodes'>"
				dat += SETUP_NODE_SWITCH("Adminhelp Sounds", "hear_adminhelps", (toggles & SOUND_ADMINHELP) ? "On" : "Off")
				dat += SETUP_NODE_SWITCH("Prayer Sounds", "hear_prayers", (toggles & SOUND_PRAYERS) ? "On" : "Off")
				dat += SETUP_NODE_SWITCH("Announce Sounds", "announce_login", (toggles & ANNOUNCE_LOGIN) ? "On" : "Off")
				dat += SETUP_NODE_SWITCH("Combo HUD Lighting", "combohud_lighting", (toggles & COMBOHUD_LIGHTING) ? "Full-bright" : "No Change")
				dat += SETUP_NODE_SWITCH("Hide Dead Chat", "toggle_dead_chat", (toggles & CHAT_DEAD) ? "Shown" : "Hidden")
				dat += SETUP_NODE_SWITCH("Hide Radio Messages", "toggle_radio_chatter", (toggles & CHAT_RADIO) ? "Shown" : "Hidden")
				dat += SETUP_NODE_SWITCH("Hide Prayers", "toggle_prayers", (toggles & CHAT_PRAYER) ? "Shown" : "Hidden")
				dat += SETUP_NODE_SWITCH("Ignore Cult Ghost", "toggle_ignore_cult_ghost", (toggles & ADMIN_IGNORE_CULT_GHOST) ? "Don't Allow" : "Allow")
				if(CONFIG_GET(flag/allow_admin_asaycolor))
					dat += SETUP_NODE_COLOR("ASAY Color", "asaycolor", asaycolor ? asaycolor : "#FF4500", null)

				dat += "</div></div><div class='csetup_content'><div class='csetup_header'>Deadmin</div><div class='csetup_nodes'>"

				if(CONFIG_GET(flag/auto_deadmin_players))
					dat += SETUP_NODE_SWITCH("Always Deadmin", "suck", "FORCED")
				else
					dat += SETUP_NODE_SWITCH("Always Deadmin", "toggle_deadmin_always", (toggles & DEADMIN_ALWAYS) ? "On" : "Off")
					if(!(toggles & DEADMIN_ALWAYS))
						if(!CONFIG_GET(flag/auto_deadmin_antagonists) || (CONFIG_GET(flag/auto_deadmin_antagonists)))
							dat += SETUP_NODE_SWITCH("As Antag", "toggle_deadmin_always", (toggles & DEADMIN_ANTAGONIST) ? "Deadmin" : "Keep Admin")
						else
							dat += SETUP_NODE_SWITCH("As Antag", "suck", "FORCED")

						if(!CONFIG_GET(flag/auto_deadmin_heads) || (CONFIG_GET(flag/auto_deadmin_heads)))
							dat += SETUP_NODE_SWITCH("As Command", "toggle_deadmin_head", (toggles & DEADMIN_POSITION_HEAD) ? "Deadmin" : "Keep Admin")
						else
							dat += SETUP_NODE_SWITCH("As Command", "suck", "FORCED")

						if(!CONFIG_GET(flag/auto_deadmin_security) || (CONFIG_GET(flag/auto_deadmin_security)))
							dat += SETUP_NODE_SWITCH("As Security", "toggle_deadmin_security", (toggles & DEADMIN_POSITION_SECURITY) ? "Deadmin" : "Keep Admin")
						else
							dat += SETUP_NODE_SWITCH("As Security", "suck", "FORCED")

						if(!CONFIG_GET(flag/auto_deadmin_silicons) || (CONFIG_GET(flag/auto_deadmin_silicons)))
							dat += SETUP_NODE_SWITCH("As Silicon", "toggle_deadmin_silicon", (toggles & DEADMIN_POSITION_SILICON) ? "Deadmin" : "Keep Admin")
						else
							dat += SETUP_NODE_SWITCH("As Silicon", "suck", "FORCED")

				dat += "</div></div>"
			dat += "</div>"
		if(4) // Custom keybindings
			// Create an inverted list of keybindings -> key
			var/list/user_binds = list()
			for (var/key in key_bindings)
				for(var/kb_name in key_bindings[key])
					user_binds[kb_name] += list(key)

			var/list/kb_categories = list()
			// Group keybinds by category
			for (var/name in GLOB.keybindings_by_name)
				var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
				kb_categories[kb.category] += list(kb)

			dat += "<div class='csetup_main'>"

			dat += "<div class='csetup_content'><div class='csetup_header'>Однокнопочное</div><div class='csetup_nodes'>"
			dat += "<center><a href ='?_src_=prefs;preference=keybindings_reset'>Сбросить хоткеи</a></center></div></div>"

			for (var/category in kb_categories)
				dat += "<div class='csetup_content'><div class='csetup_header'>[category]</div><div class='csetup_nodes'>"
				for (var/i in kb_categories[category])
					var/datum/keybinding/kb = i
					if(!length(user_binds[kb.name]) || user_binds[kb.name][1] == "Unbound")
						dat += SETUP_START_NODE(kb.full_name)
						dat += SETUP_GET_LINK("keybindings_capture", "[kb.name];old_key=["Unbound"]", "keybinding", "Ничего")
						dat += SETUP_CLOSE_NODE
					else
						var/bound_key = user_binds[kb.name][1]
						dat += SETUP_START_NODE(kb.full_name)
						dat += SETUP_GET_LINK("keybindings_capture", "[kb.name];old_key=[bound_key]", "keybinding", bound_key)
						for(var/bound_key_index in 2 to length(user_binds[kb.name]))
							bound_key = user_binds[kb.name][bound_key_index]
							dat += SETUP_GET_LINK("keybindings_capture", "[kb.name];old_key=[bound_key]", "keybinding", bound_key)
						if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
							dat += SETUP_GET_LINK("keybindings_capture", "[kb.name]", "keybinding", "Alt")
						dat += SETUP_CLOSE_NODE
				dat += "</div></div>"
			dat += "</div>"
	dat += "</div>"

	var/datum/asset/stuff = get_asset_datum(/datum/asset/simple/metacoins)
	stuff.send(user)

	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser_new", null, 1400, 900)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(user, "preferences_window", src)

#undef SETUP_START_NODE
#undef SETUP_GET_LINK
#undef SETUP_GET_LINK_RANDOM
#undef SETUP_COLOR_BOX
#undef SETUP_NODE_SWITCH
#undef SETUP_NODE_INPUT
#undef SETUP_NODE_COLOR
#undef SETUP_NODE_RANDOM
#undef SETUP_NODE_INPUT_RANDOM
#undef SETUP_NODE_COLOR_RANDOM
#undef SETUP_CLOSE_NODE

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, old_key)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?_src_=prefs;preference=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences/proc/SetChoices(mob/user, limit = 11, list/splitJobs = list(JOB_CHIEF_ENGINEER), widthPerColumn = 295, height = 620)
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 11 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
		HTML += "Список работ ещё не инициализирован до конца. Подождите немного."
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Готово</a></center><br>" // Easier to press up here.

	else
		HTML += "<b>Выбери шанс получить желаемую должность</b><br>"
		HTML += "<div align='center'>ЛКМ, чтобы поднять вес, ПКМ чтобы понизить.<br></div>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Готово</a></center><br>" // Easier to press up here.
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table class='role_col' width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob

		for(var/datum/job/job in sort_list(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc)))

			index += 1
			if((index >= limit) || (job.title in splitJobs))
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr style='color: [lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			HTML += "<tr style='color: [job.selection_color]'><td width='60%' align='right'>"
			var/rank = job.title
			var/ru_rank = ru_job_parse(job.title)
			lastJob = job
			if(is_banned_from(user.ckey, rank))
				HTML += "<font color='#fda2fa'>[ru_rank]</font></td><td><a href='?_src_=prefs;bancheck=[rank]'> БЛОК</a></td></tr>"
				continue
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			if(required_playtime_remaining)
				HTML += "<font color='#fda2fa'>[ru_rank]</font></td><td><font color='#fda2fa'> \[ [get_exp_format(required_playtime_remaining)] как [job.get_exp_req_type()] \] </font></td></tr>"
				continue
			if(job.metalocked && !(job.type in jobs_buyed))
				HTML += "<font color='#fda2fa'>[ru_rank]</font></td><td><font color='#fda2fa'> \[ META \] </font></td></tr>"
				continue
			if(LAZYLEN(job.whitelisted) && !(user.ckey in job.whitelisted))
				HTML += "<font color='#fda2fa'>[ru_rank]</font></td><td><font color='#fda2fa'> \[ DONATE \] </font></td></tr>"
				continue
//			if(!job.allow_new_players && !check_whitelist(user.ckey))
//				HTML += "<font color='#fda2fa'>[ru_rank]</font></td><td><font color='#fda2fa'> \[ WHITELIST \] </font></td></tr>"
//				continue
			if(!job.inverted_player_age)
				if(!job.player_old_enough(user.client))
					var/available_in_days = job.available_in_days(user.client)
					HTML += "<font color='#fda2fa'>[ru_rank]</font></td><td><font color='#fda2fa'> \[ЧЕРЕЗ [(available_in_days)] ДНЕЙ\]</font></td></tr>"
					continue
//			if(!job.not_available_in_days(user.client))
//				HTML += "<font color='#fda2fa'>[ru_rank]</font></td><td><font color='#fda2fa'> \[БОЛЕЕ НЕДОСТУПЕН\]</font></td></tr>"
//				continue
			if((job_preferences[SSjob.overflow_role] == JP_LOW) && (rank != SSjob.overflow_role) && !is_banned_from(user.ckey, SSjob.overflow_role))
				HTML += "<font color='#ff9955'>[ru_rank]</font></td><td></td></tr>"
				continue
			if((rank in GLOB.command_positions) || (rank == JOB_AI))//Bold head jobs
				HTML += "<b><span>[ru_rank]</span></b>"
			else
				HTML += "<span>[ru_rank]</span>"

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ОШИБКА"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			switch(job_preferences[job.title])
				if(JP_HIGH)
					prefLevelLabel = "Высокий"
					prefLevelColor = "#9999ff"
					prefUpperLevel = 4
					prefLowerLevel = 2
				if(JP_MEDIUM)
					prefLevelLabel = "Средний"
					prefLevelColor = "#77ff77"
					prefUpperLevel = 1
					prefLowerLevel = 3
				if(JP_LOW)
					prefLevelLabel = "Низкий"
					prefLevelColor = "#ff9955"
					prefUpperLevel = 2
					prefLowerLevel = 4
				else
					prefLevelLabel = "НИКОГДА"
					prefLevelColor = "#fda2fa"
					prefUpperLevel = 3
					prefLowerLevel = 1

			HTML += "<a class='rs_butt' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

			if(rank == SSjob.overflow_role)//Overflow is special
				if(job_preferences[SSjob.overflow_role] == JP_LOW)
					HTML += "<font color='#77ff77'>Да</font>"
				else
					HTML += "<font color='#fda2fa'>Нет</font>"
				HTML += "</a></td></tr>"
				continue

			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr style='color: [lastJob.selection_color]><td width='60%' align='right'>&nbsp;</td><td>&nbsp;</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table>"

		var/message = "Быть [SSjob.overflow_role], если не получилось"
		if(joblessrole == BERANDOMJOB)
			message = "Получить случайную должность, если не получилось"
		else if(joblessrole == RETURNTOLOBBY)
			message = "Вернуться в лобби, если не получилось"
		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Сбросить настройки</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Выбор должностей</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return FALSE

	if (level == JP_HIGH) // to high
		//Set all other high to medium
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM
				//technically break here

	job_preferences[job.title] = level
	return TRUE

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	if(!SSjob || SSjob.occupations.len <= 0)
		return
	var/datum/job/job = SSjob.GetJob(role)

	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if (!isnum(desiredLvl))
		to_chat(user, span_danger("UpdateJobPreference - desired level was not a number. Please notify coders!"))
		ShowChoices(user)
		return

	var/jpval = null
	switch(desiredLvl)
		if(3)
			jpval = JP_LOW
		if(2)
			jpval = JP_MEDIUM
		if(1)
			jpval = JP_HIGH

	if(role == SSjob.overflow_role)
		if(job_preferences[job.title] == JP_LOW)
			jpval = null
		else
			jpval = JP_LOW

	SetJobPreferenceLevel(job, jpval)
	SetChoices(user)

	return 1


/datum/preferences/proc/ResetJobs()
	job_preferences = list()

/datum/preferences/proc/SetQuirks(mob/user)
	if(!SSquirks)
		to_chat(user, span_danger("The quirk subsystem is still initializing! Try again in a minute."))
		return

	var/list/dat = list()
	if(!SSquirks.quirks.len)
		dat += "Система особенностей ещё не инициализирована. Надо подождать..."
		dat += "<center><a href='?_src_=prefs;preference=trait;task=close'>Готово</a></center><br>"
	else
		dat += "<center><b>Выбери возможные особенности персонажа</b></center><br>"
		dat += "<div align='center'>ЛКМ, чтобы добавить или удалить особенность. Тебе нужны будут негативные особенности, чтобы иметь позитивные.<br>\
		Особенности применяются каждый раунд и не могут быть убраны обычным путём.</div>"
		dat += "<center><a href='?_src_=prefs;preference=trait;task=close'>Готово</a></center>"
		dat += "<hr>"
		dat += "<center><b>Текущие особенности:</b> [all_quirks.len ? all_quirks.Join(", ") : "Нету!"]</center>"
		dat += "<center>[GetPositiveQuirkCount()] / [MAX_QUIRKS] максимальных позитивных качеств<br>\
		<b>Баланс особенностей:</b> [GetQuirkBalance()]</center><div class='csetup_quirks'>"
		for(var/V in SSquirks.quirks)
			var/datum/quirk/T = SSquirks.quirks[V]
			var/quirk_name = initial(T.name)
			var/has_quirk
			var/quirk_cost = initial(T.value) * -1
			var/lock_reason = "Эта особенность недоступна."
			var/quirk_conflict = FALSE
			for(var/_V in all_quirks)
				if(_V == quirk_name)
					has_quirk = TRUE
			if(initial(T.mood_quirk) && CONFIG_GET(flag/disable_human_mood))
				lock_reason = "Настроение не настроено."
				quirk_conflict = TRUE
			if(has_quirk)
				if(quirk_conflict)
					all_quirks -= quirk_name
					has_quirk = FALSE
				else
					quirk_cost *= -1 //invert it back, since we'd be regaining this amount
			if(quirk_cost > 0)
				quirk_cost = "+[quirk_cost]"
			var/font_color = "#AAAAFF"
			if(initial(T.value) != 0)
				font_color = initial(T.value) > 0 ? "#AAFFAA" : "#FFAAAA"
			if(quirk_conflict)
				dat += "<div class='csetup_quirk'><font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)] \
				<div class='csetup_quirk_text'><font color='red'><b>ЗАБЛОКИРОВАНО: [lock_reason]</b></font></div></div>"
			else
				if(has_quirk)
					dat += "<div class='csetup_quirk'><a href='?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'>[has_quirk ? "Убрать" : "Взять"] ([quirk_cost] о.)</a> \
					<div class='csetup_quirk_text'><b><font color='[font_color]'>[quirk_name]</font></b> - [initial(T.desc)]</div></div>"
				else
					dat += "<div class='csetup_quirk'><a href='?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'>[has_quirk ? "Убрать" : "Взять"] ([quirk_cost] о.)</a> \
					<div class='csetup_quirk_text'><font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)]</div></div>"
		dat += "</div><center><a href='?_src_=prefs;preference=trait;task=reset'>Сбросить особенности</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Настройка особенностей</div>", 900, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/GetQuirkBalance()
	var/bal = 0
	for(var/V in all_quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		bal -= initial(T.value)
	return bal

/datum/preferences/proc/GetPositiveQuirkCount()
	. = 0
	for(var/q in all_quirks)
		if(SSquirks.quirk_points[q] > 0)
			.++

/datum/preferences/proc/validate_quirks()
	if(GetQuirkBalance() < 0)
		all_quirks = list()

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["bancheck"])
		var/list/ban_details = is_banned_from_with_details(user.ckey, user.client.address, user.client.computer_id, href_list["bancheck"])
		var/admin = FALSE
		if(GLOB.admin_datums[user.ckey] || GLOB.deadmins[user.ckey])
			admin = TRUE
		for(var/i in ban_details)
			if(admin && !text2num(i["applies_to_admins"]))
				continue
			ban_details = i
			break //we only want to get the most recent ban's details
		if(ban_details?.len)
			var/expires = " Это перманентный бан."
			if(ban_details["expiration_time"])
				expires = " Блокировка на [DisplayTimeText(text2num(ban_details["duration"]) MINUTES)] и заканчивается [ban_details["expiration_time"]] (по серверному времени)."
			to_chat(user, span_danger("Доступ запрещён к [href_list["bancheck"]], [ban_details["key"]].<br>Метка: [ban_details["reason"]]<br>Блокировка (ID #[ban_details["id"]]) была создана [ban_details["admin_key"]] в [ban_details["bantime"]] во время раунда [ban_details["round_id"]].<br>[expires]"))
			return
	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(is_banned_from(user.ckey, SSjob.overflow_role))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BEOVERFLOW
					if(BEOVERFLOW)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)
			if("setJobLevel")
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			else
				SetChoices(user)
		return 1

	else if(href_list["preference"] == "trait")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("update")
				var/quirk = href_list["trait"]
				if(!SSquirks.quirks[quirk])
					return
				for(var/V in SSquirks.quirk_blacklist) //V is a list
					var/list/L = V
					if(!(quirk in L))
						continue
					for(var/Q in all_quirks)
						if((Q in L) && !(Q == quirk)) //two quirks have lined up in the list of the list of quirks that conflict with each other, so return (see quirks.dm for more details)
							to_chat(user, span_danger("[quirk] is incompatible with [Q]."))
							return
				var/value = SSquirks.quirk_points[quirk]
				var/balance = GetQuirkBalance()
				if(quirk in all_quirks)
					if(balance + value < 0)
						to_chat(user, span_warning("Refunding this would cause you to go below your balance!"))
						return
					all_quirks -= quirk
				else
					var/is_positive_quirk = SSquirks.quirk_points[quirk] > 0
					if(is_positive_quirk && GetPositiveQuirkCount() >= MAX_QUIRKS)
						to_chat(user, span_warning("You can't have more than [MAX_QUIRKS] positive quirks!"))
						return
					if(balance - value < 0)
						to_chat(user, span_warning("You don't have enough balance to gain this quirk!"))
						return
					all_quirks += quirk
				SetQuirks(user)
			if("reset")
				all_quirks = list()
				SetQuirks(user)
			else
				SetQuirks(user)
		return TRUE

	if(href_list["preference"] == "gear")
		if(href_list["purchase_gear"])
			var/datum/gear/TG = GLOB.gear_datums[href_list["purchase_gear"]]
			if(SSviolence.active)
				to_chat(user, span_warning("В этом раунде операции с метакэшем запрещены. Ожидайте новый раунд."))
			else if(TG.cost < user.client.get_metabalance())
				if(TG.purchase(user.client))
					purchased_gear += TG.id
					inc_metabalance(user, (TG.cost * -1), TRUE, "Покупаю [TG.display_name].")
					save_preferences()
			else
				to_chat(user, span_warning("У меня не хватает метакэша для покупки [TG.display_name]!"))
		if(href_list["toggle_gear"])
			var/datum/gear/TG = GLOB.gear_datums[href_list["toggle_gear"]]
			if(TG.id in equipped_gear_by_character[default_slot])
				LAZYREMOVEASSOC(equipped_gear_by_character, default_slot, TG.id)
			else
				var/list/type_blacklist = list()
				var/list/slot_blacklist = list()
				for(var/gear_id in equipped_gear_by_character[default_slot])
					var/datum/gear/G = GLOB.gear_datums[gear_id]
					if(istype(G))
						if(!(G.subtype_path in type_blacklist))
							type_blacklist += G.subtype_path
						if(!(G.slot in slot_blacklist))
							slot_blacklist += G.slot
				if((TG.id in purchased_gear))
					if(!(TG.subtype_path in type_blacklist) || !(TG.slot in slot_blacklist))
						LAZYADDASSOCLIST(equipped_gear_by_character, default_slot, TG.id)
					else
						to_chat(user, span_warning("Нет места для [TG.display_name]. Что-то уже есть в этом слоте."))
			save_preferences()

		else if(href_list["select_category"])
			gear_tab = href_list["select_category"]
		else if(href_list["clear_loadout"])
			LAZYCLEARLIST(equipped_gear_by_character[default_slot])
			save_preferences()

		ShowChoices(user)
		return

	switch(href_list["task"])
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1, en_lang = en_names)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					hair_color = random_short_color()
				if("hairstyle")
					hairstyle = random_hairstyle(gender)
				if("facial")
					facial_hair_color = random_short_color()
				if("facial_hairstyle")
					facial_hairstyle = random_facial_hairstyle(gender)
				if("underwear")
					underwear = random_underwear(gender)
				if("underwear_color")
					underwear_color = random_short_color()
				if("undershirt")
					undershirt = random_undershirt(gender)
				if("socks")
					socks = random_socks()
				if(BODY_ZONE_PRECISE_EYES)
					var/random_eye_color = random_eye_color()
					eye_color_left = random_eye_color
					eye_color_right = random_eye_color
				if("s_tone")
					skin_tone = random_skin_tone()
				if("species")
					random_species()
				if("bag")
					backpack = pick(GLOB.backpacklist)
				if("suit")
					jumpsuit_style = pick(GLOB.jumpsuitlist)
				if("all")
					random_character(gender)

		if("input")

			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])


			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = tgui_input_list(user, "Thanks for supporting BYOND - Choose your ghostly form:", "Thanks for supporting BYOND", GLOB.ghost_forms)
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = tgui_input_list(user, "Thanks for supporting BYOND - Choose your ghostly orbit:", "Thanks for supporting BYOND", GLOB.ghost_orbits)
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = tgui_alert(usr,"Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,list(GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME))
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = tgui_alert(usr,"Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,list(GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME))
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("name")
					var/new_name = tgui_input_text(user, "Choose your character's name:", "Настройки персонажа")
					if(new_name)
						if(pref_species.mutant_bodyparts["ipc_screen"])
							new_name = reject_bad_name(new_name, TRUE)
						else
							new_name = reject_bad_name(new_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, span_red("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and . It must not contain any words restricted by IC chat and name filters."))

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Настройки персонажа") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("hair")
					var/new_hair = input(user, "Choose your character's hair colour:", "Настройки персонажа","#"+hair_color) as color|null
					if(new_hair)
						hair_color = sanitize_hexcolor(new_hair)

				if("ipc_screen")
					var/new_ipc_screen
					new_ipc_screen = tgui_input_list(user, "Choose your character's screen:", "Настройки персонажа", GLOB.ipc_screens_list)
					if(new_ipc_screen)
						features["ipc_screen"] = new_ipc_screen

				if("ipc_antenna")
					var/new_ipc_antenna
					new_ipc_antenna = tgui_input_list(user, "Choose your character's antenna:", "Настройки персонажа", GLOB.ipc_antennas_list)
					if(new_ipc_antenna)
						features["ipc_antenna"] = new_ipc_antenna

				if("hairstyle")
					var/list/options
					switch(gender)
						if(MALE) options = GLOB.hairstyles_male_list
						if(FEMALE) options = GLOB.hairstyles_female_list
						else options = GLOB.hairstyles_list
					var/new_hairstyle = tgui_input_list(user, "Choose your character's hairstyle:", "Настройки персонажа", options)
					if(new_hairstyle)
						hairstyle = new_hairstyle

				if("next_hairstyle")
					if (gender == MALE)
						hairstyle = next_list_item(hairstyle, GLOB.hairstyles_male_list)
					else if(gender == FEMALE)
						hairstyle = next_list_item(hairstyle, GLOB.hairstyles_female_list)
					else
						hairstyle = next_list_item(hairstyle, GLOB.hairstyles_list)

				if("hair_grad_style")
					var/new_grad_style = tgui_input_list(user, "Choose a color pattern for your hair:", "Настройки персонажа", GLOB.hair_gradients_list)
					if(new_grad_style)
						hair_grad_style = new_grad_style

				if("hair_grad_color")
					var/new_grad_color = input(user, "Choose your character's secondary hair color:", "Настройки персонажа","#"+hair_grad_color) as color|null
					if(new_grad_color)
						hair_grad_color = sanitize_hexcolor(new_grad_color)

				if("facial_grad_style")
					var/new_grad_style = tgui_input_list(user, "Choose a color pattern for your facial:", "Настройки персонажа", GLOB.facial_hair_gradients_list)
					if(new_grad_style)
						facial_grad_style = new_grad_style

				if("facial_grad_color")
					var/new_grad_color = input(user, "Choose your character's secondary facial color:", "Настройки персонажа","#"+facial_grad_color) as color|null
					if(new_grad_color)
						facial_grad_color = sanitize_hexcolor(new_grad_color)

				if("previous_hairstyle")
					if (gender == MALE)
						hairstyle = previous_list_item(hairstyle, GLOB.hairstyles_male_list)
					else if(gender == FEMALE)
						hairstyle = previous_list_item(hairstyle, GLOB.hairstyles_female_list)
					else
						hairstyle = previous_list_item(hairstyle, GLOB.hairstyles_list)

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Настройки персонажа","#"+facial_hair_color) as color|null
					if(new_facial)
						facial_hair_color = sanitize_hexcolor(new_facial)

				if("facial_hairstyle")
					var/list/options
					switch(gender)
						if(MALE) options = GLOB.facial_hairstyles_male_list
						if(FEMALE) options = GLOB.facial_hairstyles_female_list
						else options = GLOB.facial_hairstyles_list
					var/new_facial_hairstyle = tgui_input_list(user, "Choose your character's facial-hairstyle:", "Настройки персонажа", options)
					if(new_facial_hairstyle)
						facial_hairstyle = new_facial_hairstyle

				if("next_facehairstyle")
					if (gender == MALE)
						facial_hairstyle = next_list_item(facial_hairstyle, GLOB.facial_hairstyles_male_list)
					else if(gender == FEMALE)
						facial_hairstyle = next_list_item(facial_hairstyle, GLOB.facial_hairstyles_female_list)
					else
						facial_hairstyle = next_list_item(facial_hairstyle, GLOB.facial_hairstyles_list)

				if("previous_facehairstyle")
					if (gender == MALE)
						facial_hairstyle = previous_list_item(facial_hairstyle, GLOB.facial_hairstyles_male_list)
					else if (gender == FEMALE)
						facial_hairstyle = previous_list_item(facial_hairstyle, GLOB.facial_hairstyles_female_list)
					else
						facial_hairstyle = previous_list_item(facial_hairstyle, GLOB.facial_hairstyles_list)

				if("underwear")
					var/list/options
					switch(gender)
						if(MALE) options = GLOB.underwear_m
						if(FEMALE) options = GLOB.underwear_f
						else options = GLOB.underwear_list
					var/new_underwear = tgui_input_list(user, "Choose your character's underwear:", "Настройки персонажа", options)
					if(new_underwear)
						underwear = new_underwear

				if("underwear_color")
					var/new_underwear_color = input(user, "Choose your character's underwear color:", "Настройки персонажа","#"+underwear_color) as color|null
					if(new_underwear_color)
						underwear_color = sanitize_hexcolor(new_underwear_color)

				if("undershirt")
					var/list/options
					switch(gender)
						if(MALE) options = GLOB.undershirt_m
						if(FEMALE) options = GLOB.undershirt_f
						else options = GLOB.undershirt_list
					var/new_undershirt = tgui_input_list(user, "Choose your character's undershirt:", "Настройки персонажа", options)
					if(new_undershirt)
						undershirt = new_undershirt

				if("socks")
					var/new_socks = tgui_input_list(user, "Choose your character's socks:", "Настройки персонажа", GLOB.socks_list)
					if(new_socks)
						socks = new_socks

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Настройки персонажа","#"+eye_color_left) as color|null
					if(new_eyes)
						eye_color_left = sanitize_hexcolor(new_eyes)
						eye_color_right = sanitize_hexcolor(new_eyes)

				if("left_eye")
					var/new_eyes = input(user, "Выбери цвет левого глаза:", "Настройки персонажа","#"+eye_color_left) as color|null
					if(new_eyes)
						eye_color_left = sanitize_hexcolor(new_eyes)

				if("right_eye")
					var/new_eyes = input(user, "Выбери цвет правого глаза:", "Настройки персонажа","#"+eye_color_right) as color|null
					if(new_eyes)
						eye_color_right = sanitize_hexcolor(new_eyes)

				if("species")

					// free the bird
					var/list/custom_races

					if(user.ckey in GLOB.donators_list["race"])
						custom_races = list("golem", "jelly", "shadow", "abductor", "zombie", "slime", "pod", "military_synth", "mush", "snail", "monkey") // GLOB.donators_list["race"][user.ckey]

					var/result = tgui_input_list(user, "Select a species", "Species Selection", GLOB.roundstart_races + custom_races)

					if(result)
						var/newtype = GLOB.species_list[result]
						pref_species = new newtype()
						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						var/temp_hsv = RGBtoHSV(features["mcolor"])
						if(features["mcolor"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#7F7F7F")[3]))
							features["mcolor"] = pref_species.default_color
						if(randomise[RANDOM_NAME])
							real_name = pref_species.random_name(gender, en_lang = en_names)

				if("mutant_color")
					var/new_mutantcolor = input(user, "Choose your character's alien/mutant color:", "Настройки персонажа","#"+features["mcolor"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#7F7F7F")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
						else
							to_chat(user, span_danger("Invalid color. Your color is not bright enough."))

				if("color_ethereal")
					var/new_etherealcolor = tgui_input_list(user, "Choose your ethereal color", "Настройки персонажа", GLOB.color_list_ethereal)
					if(new_etherealcolor)
						features["ethcolor"] = GLOB.color_list_ethereal[new_etherealcolor]


				if("tail_lizard")
					var/new_tail
					new_tail = tgui_input_list(user, "Choose your character's tail:", "Настройки персонажа", GLOB.tails_list_lizard)
					if(new_tail)
						features["tail_lizard"] = new_tail

				if("tail_human")
					var/new_tail
					new_tail = tgui_input_list(user, "Choose your character's tail:", "Настройки персонажа", GLOB.tails_list_human)
					if((!user.client.holder && !(user.client.ckey in GLOB.donators_list["tails"])) && (new_tail == "Fox" || new_tail == "Oni"))
						to_chat(user, span_danger("Pedos not allowed? <big>ВАШЕ ДЕЙСТВИЕ БУДЕТ ЗАПИСАНО</big>."))
						message_admins("[ADMIN_LOOKUPFLW(user)] попытался выбрать фуррятину в виде хвоста.")
						return
					if(new_tail)
						features["tail_human"] = new_tail

				if("snout")
					var/new_snout
					new_snout = tgui_input_list(user, "Choose your character's snout:", "Настройки персонажа", GLOB.snouts_list)
					if(new_snout)
						features["snout"] = new_snout

				if("horns")
					var/new_horns
					new_horns = tgui_input_list(user, "Choose your character's horns:", "Настройки персонажа", GLOB.horns_list)
					if(new_horns)
						features["horns"] = new_horns

				if("ears")
					var/new_ears
					new_ears = tgui_input_list(user, "Choose your character's ears:", "Настройки персонажа", GLOB.ears_list)
					if(new_ears)
						features["ears"] = new_ears

				if("wings")
					var/new_wings
					new_wings = tgui_input_list(user, "Choose your character's wings:", "Настройки персонажа", GLOB.r_wings_list)
					if(new_wings)
						features["wings"] = new_wings

				if("frills")
					var/new_frills
					new_frills = tgui_input_list(user, "Choose your character's frills:", "Настройки персонажа", GLOB.frills_list)
					if(new_frills)
						features["frills"] = new_frills

				if("spines")
					var/new_spines
					new_spines = tgui_input_list(user, "Choose your character's spines:", "Настройки персонажа", GLOB.spines_list)
					if(new_spines)
						features["spines"] = new_spines

				if("body_markings")
					var/new_body_markings
					new_body_markings = tgui_input_list(user, "Choose your character's body markings:", "Настройки персонажа", GLOB.body_markings_list)
					if(new_body_markings)
						features["body_markings"] = new_body_markings

				if("legs")
					var/new_legs
					new_legs = tgui_input_list(user, "Choose your character's legs:", "Настройки персонажа", GLOB.legs_list)
					if(new_legs)
						features["legs"] = new_legs

				if("moth_wings")
					var/new_moth_wings
					new_moth_wings = tgui_input_list(user, "Choose your character's wings:", "Настройки персонажа", GLOB.moth_wings_list)
					if(new_moth_wings)
						features["moth_wings"] = new_moth_wings

				if("moth_antennae")
					var/new_moth_antennae
					new_moth_antennae = tgui_input_list(user, "Choose your character's antennae:", "Настройки персонажа", GLOB.moth_antennae_list)
					if(new_moth_antennae)
						features["moth_antennae"] = new_moth_antennae

				if("moth_markings")
					var/new_moth_markings
					new_moth_markings = tgui_input_list(user, "Choose your character's markings:", "Настройки персонажа", GLOB.moth_markings_list)
					if(new_moth_markings)
						features["moth_markings"] = new_moth_markings

				if("tts_voice")
					var/list/tts_list = list()
					for(var/vc in GLOB.tts_voices)
						tts_list[GLOB.tts_voices[vc]] = vc

					var/new_voice = tgui_input_list(user, "Выбери голос:", "Настройки персонажа", tts_list)
					if(new_voice)
						forced_voice = tts_list[new_voice]
						user?.voice = forced_voice

					var/random_text = pick("Привет, это мой голос.", "Помогите, Александр Роули убивает в техах!", "Корабли лавировали, лавировали, да не вылавировали.")
					INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user.client, random_text, speaker = forced_voice, local = TRUE)

				if("s_tone")
					var/new_s_tone = tgui_input_list(user, "Choose your character's skin-tone:", "Настройки персонажа", GLOB.skin_tones)
					if(new_s_tone)
						skin_tone = new_s_tone

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference",ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = sanitize_ooccolor(new_ooccolor)

				if("asaycolor")
					var/new_asaycolor = input(user, "Choose your ASAY color:", "Game Preference",asaycolor) as color|null
					if(new_asaycolor)
						asaycolor = sanitize_ooccolor(new_asaycolor)

				if("bag")
					var/new_backpack = tgui_input_list(user, "Choose your character's socks:", "Настройки персонажа", GLOB.backpacklist)
					if(new_backpack)
						backpack = new_backpack

				if("suit")
					if(jumpsuit_style == PREF_SUIT)
						jumpsuit_style = PREF_SKIRT
					else
						jumpsuit_style = PREF_SUIT

				if("uplink_loc")
					var/new_loc = tgui_input_list(user, "Choose your character's traitor uplink spawn location:", "Настройки персонажа", GLOB.uplink_spawn_loc_list)
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("playtime_reward_cloak")
					if (user.client.get_exp_living(TRUE) >= PLAYTIME_VETERAN)
						playtime_reward_cloak = !playtime_reward_cloak

				if("ai_core_icon")
					var/ai_core_icon = tgui_input_list(user, "Choose your preferred AI core display screen:", "AI Core Display Screen Selection", GLOB.ai_core_display_screens - "Portrait")
					if(ai_core_icon)
						preferred_ai_core_display = ai_core_icon

				if("sec_dept")
					var/department = tgui_input_list(user, "Choose your preferred security department:", "Security Departments", GLOB.security_depts_prefs)
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/default = "Default"
					if (config.defaultmap)
						default += " ([config.defaultmap.map_name])"
					for (var/M in config.maplist)
						var/datum/map_config/VM = config.maplist[M]
						if(!VM.votable)
							continue
						var/friendlyname = "[VM.map_name] "
						if (VM.voteweight <= 0)
							friendlyname += " (disabled)"
						maplist[friendlyname] = VM.map_name
					maplist[default] = null
					var/pickedmap = tgui_input_list(user, "Choose your preferred map. This will be used to help weight random map selection.", "Настройки персонажа", sort_list(maplist))
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("clientfps")
					var/desiredfps = input(user, "Choose your desired fps.\n-1 means recommended value (currently:[RECOMMENDED_FPS])\n0 means world fps (currently:[world.fps])", "Настройки персонажа", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = sanitize_integer(desiredfps, -1, 1000, clientfps)
						parent.fps = (clientfps < 0) ? RECOMMENDED_FPS : clientfps

				if("ui")
					var/pickedui = tgui_input_list(user, "Choose your UI style.", "Настройки персонажа", sort_list(GLOB.available_ui_styles), UI_style)
					if(!retro_hud)
						pickedui = "Neoscreen"
					else if (retro_hud && pickedui == "Neoscreen")
						pickedui = "Oxide"

					if(pickedui)
						UI_style = pickedui
						if (parent && parent.mob && parent.mob.hud_used)
							parent.mob.hud_used.update_ui_style(ui_style2icon(UI_style))

				if("phobia")
					var/phobiaType = tgui_input_list(user, "What are you scared of?", "Настройки персонажа", SStraumas.phobia_types, phobia)
					if(phobiaType)
						phobia = phobiaType

				if ("max_chat_length")
					var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [initial(max_chat_length)]))", "Настройки персонажа", max_chat_length)  as null|num
					if (!isnull(desiredlength))
						max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)

				if("ice_cream_time")
					var/new_time = input(user, "Какая задержка будет перед передачей тела призракам? (в минутах)", "Ice Cream") as num|null
					if(new_time)
						ice_cream_time = min(new_time MINUTES, 60 MINUTES)

				if ("widescreenwidth")
					var/desiredwidth = input(user, "Какую ширину выберем от до 15-19?", "ВЫБОР", widescreenwidth)  as null|num
					if(!retro_hud)
						desiredwidth = 19

					if (!isnull(desiredwidth))
						widescreenwidth = sanitize_integer(desiredwidth, 15, 19, widescreenwidth)
						user.client.view_size.setDefault("[widescreenwidth]x15")

		else
			switch(href_list["preference"])
				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC
				if("gender")
					var/list/friendlyGenders = list("Male" = "male", "Female" = "female", "Attack Helicopter" = "plural")
					var/pickedGender = tgui_input_list(user, "Choose your gender.", "Настройки персонажа", friendlyGenders, gender)
					if(pickedGender && friendlyGenders[pickedGender] != gender)
						gender = friendlyGenders[pickedGender]
						underwear = random_underwear(gender)
						undershirt = random_undershirt(gender)
						socks = random_socks()
						facial_hairstyle = random_facial_hairstyle(gender)
						hairstyle = random_hairstyle(gender)
				if("body_type")
					if(body_type == MALE)
						body_type = FEMALE
					else
						body_type = MALE
				if("hotkeys")
					hotkeys = !hotkeys
					if(hotkeys)
						winset(user, null, "input.focus=true")
					else
						winset(user, null, "input.focus=true")

				if("keybindings_capture")
					var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
					var/old_key = href_list["old_key"]
					CaptureKeybinding(user, kb, old_key)
					return

				if("keybindings_set")
					var/kb_name = href_list["keybinding"]
					if(!kb_name)
						user << browse(null, "window=capturekeypress")
						ShowChoices(user)
						return

					var/clear_key = text2num(href_list["clear_key"])
					var/old_key = href_list["old_key"]
					if(clear_key)
						if(key_bindings[old_key])
							key_bindings[old_key] -= kb_name
							LAZYADD(key_bindings["Unbound"], kb_name)
							if(!length(key_bindings[old_key]))
								key_bindings -= old_key
						user << browse(null, "window=capturekeypress")
						user.client.set_macros()
						save_preferences()
						ShowChoices(user)
						return

					var/new_key = uppertext(href_list["key"])
					var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
					var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
					var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
					var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
					// var/key_code = text2num(href_list["key_code"])

					if(GLOB._kbMap[new_key])
						new_key = GLOB._kbMap[new_key]

					var/full_key
					switch(new_key)
						if("Alt")
							full_key = "[new_key][CtrlMod][ShiftMod]"
						if("Ctrl")
							full_key = "[AltMod][new_key][ShiftMod]"
						if("Shift")
							full_key = "[AltMod][CtrlMod][new_key]"
						else
							full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
					if(kb_name in key_bindings[full_key]) //We pressed the same key combination that was already bound here, so let's remove to re-add and re-sort.
						key_bindings[full_key] -= kb_name
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					key_bindings[full_key] += list(kb_name)
					key_bindings[full_key] = sort_list(key_bindings[full_key])

					user << browse(null, "window=capturekeypress")
					user.client.set_macros()
					save_preferences()

				if("keybindings_reset")
					var/choice = tgui_alert(user, "ПЕРЕКЛЮЧИТЕСЬ НА АНГЛИЙСКУЮ РАСКЛАДКУ ПЕРЕД ВЫБОРОМ", "Настройка хоткеев", list("Хоткеи", "Классика", "Отмена"))
					if(choice == "Отмена")
						ShowChoices(user)
						return
					hotkeys = (choice == "Хоткеи")
					key_bindings = (hotkeys) ? deep_copy_list(GLOB.hotkey_keybinding_list_by_key) : deep_copy_list(GLOB.classic_keybinding_list_by_key)
					user.client.set_macros()

				if("chat_on_map")
					chat_on_map = !chat_on_map
				if("see_chat_non_mob")
					see_chat_non_mob = !see_chat_non_mob
				if("see_rc_emotes")
					see_rc_emotes = !see_rc_emotes

				if("ice_cream")
					ice_cream = !ice_cream

				if("retro_hud")
					retro_hud = !retro_hud
					if(!retro_hud)
						user.client.view_size.setDefault("19x15")
						UI_style = "Neoscreen"
						if (parent && parent.mob && parent.mob.hud_used)
							parent.mob.hud_used.update_ui_style(ui_style2icon(UI_style))
					parent.fit_viewport()
					to_chat(user, span_notice("Стиль изменится только после смены тела."))

				if("action_buttons")
					buttons_locked = !buttons_locked
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("winflash")
					windowflashing = !windowflashing

				//here lies the badmins
				if("hear_adminhelps")
					user.client.toggleadminhelpsound()
				if("hear_prayers")
					user.client.toggle_prayer_sound()
				if("announce_login")
					user.client.toggleannouncelogin()
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING
				if("toggle_dead_chat")
					user.client.deadchat()
				if("toggle_radio_chatter")
					user.client.toggle_hear_radio()
				if("toggle_prayers")
					user.client.toggleprayers()
				if("toggle_deadmin_always")
					toggles ^= DEADMIN_ALWAYS
				if("toggle_deadmin_antag")
					toggles ^= DEADMIN_ANTAGONIST
				if("toggle_deadmin_head")
					toggles ^= DEADMIN_POSITION_HEAD
				if("toggle_deadmin_security")
					toggles ^= DEADMIN_POSITION_SECURITY
				if("toggle_deadmin_silicon")
					toggles ^= DEADMIN_POSITION_SILICON
				if("toggle_ignore_cult_ghost")
					toggles ^= ADMIN_IGNORE_CULT_GHOST


				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= be_special_type
					else
						be_special += be_special_type

				if("toggle_random")
					var/random_type = href_list["random_type"]
					if(randomise[random_type])
						randomise -= random_type
					else
						randomise[random_type] = TRUE

				if("persistent_scars")
					persistent_scars = !persistent_scars

				if("clear_scars")
					var/path = "data/player_saves/[user.ckey[1]]/[user.ckey]/scars.sav"
					fdel(path)
					to_chat(user, span_notice("All scar slots cleared."))

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client && isnewplayer(user))
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if("endofround_sounds")
					toggles ^= SOUND_ENDOFROUND

				if("ghost_ears")
					chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("ghost_laws")
					chat_toggles ^= CHAT_GHOSTLAWS

				if("hear_login_logout")
					chat_toggles ^= CHAT_LOGIN_LOGOUT

				if("broadcast_login_logout")
					broadcast_login_logout = !broadcast_login_logout

				if("income_pings")
					chat_toggles ^= CHAT_BANKCARD

				if("chat_spam")
					chat_toggles ^= CHAT_SPAM

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = WRAP(parallax + 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("parallaxdown")
					parallax = WRAP(parallax - 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("ambientocclusion")
					ambientocclusion = !ambientocclusion
					for(var/atom/movable/screen/plane_master/rendering_plate/game_world/plane_master in parent.mob?.hud_used?.get_true_plane_masters(GAME_PLANE))
						plane_master.show_to(parent.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && parent)
						parent.fit_viewport()

				if("fullscreen")
					fullscreen = !fullscreen
					parent.ToggleFullscreen()

				if("multiz_parallax")
					multiz_parallax = !multiz_parallax

					var/datum/hud/my_hud = parent?.mob?.hud_used

					if(!my_hud)
						return

					for(var/group_key as anything in my_hud.master_groups)
						var/datum/plane_master_group/group = my_hud.master_groups[group_key]
						group.transform_lower_turfs(my_hud, my_hud.current_plane_offset)

				if("multiz_performance")
					multiz_performance = WRAP(multiz_performance + 1, MULTIZ_PERFORMANCE_DISABLE, MAX_EXPECTED_Z_DEPTH)

					var/datum/hud/my_hud = parent?.mob?.hud_used

					if(!my_hud)
						return

					for(var/group_key as anything in my_hud.master_groups)
						var/datum/plane_master_group/group = my_hud.master_groups[group_key]
						group.transform_lower_turfs(my_hud, my_hud.current_plane_offset)

				if("tooltip_no_context")
					w_toggles ^= TOOLTIP_NO_CONTEXT

				if("tooltip_pos")
					w_toggles ^= TOOLTIP_USER_POS
					if(w_toggles & TOOLTIP_USER_POS)
						user?.hud_used?.tooltip?.screen_loc = "BOTTOM+2,LEFT"
					else
						user?.hud_used?.tooltip?.screen_loc = "TOP,LEFT"

				if("tooltip_retro")
					w_toggles ^= TOOLTIP_USER_RETRO
					if(w_toggles & TOOLTIP_USER_RETRO)
						winset(user, "mainwindow", "statusbar=true")
					else
						winset(user, "mainwindow", "statusbar=false")

				if("horiz_inv")
					w_toggles ^= SCREEN_HORIZ_INV
					if(w_toggles & SCREEN_HORIZ_INV)
						winset(user, "split", "left=infowindow;right=mapwindow")
					else
						winset(user, "split", "left=mapwindow;right=infowindow")

				if("verti_inv")
					w_toggles ^= SCREEN_VERTI_INV
					if(w_toggles & SCREEN_VERTI_INV)
						winset(user, "info", "left=outputwindow;right=statwindow")
					else
						winset(user, "info", "left=statwindow;right=outputwindow")

				if("hide_split")
					w_toggles ^= SCREEN_HIDE_SPLIT
					if(w_toggles & SCREEN_HIDE_SPLIT)
						winset(user, "info", "show-splitter=false")
						winset(user, "split", "show-splitter=false")
					else
						winset(user, "info", "show-splitter=true")
						winset(user, "split", "show-splitter=true")

				if("disabled_autocap")
					disabled_autocap = !disabled_autocap

				if("pixel_size")
					switch(pixel_size)
						if(PIXEL_SCALING_AUTO)
							pixel_size = PIXEL_SCALING_1X
						if(PIXEL_SCALING_1X)
							pixel_size = PIXEL_SCALING_1_2X
						if(PIXEL_SCALING_1_2X)
							pixel_size = PIXEL_SCALING_2X
						if(PIXEL_SCALING_2X)
							pixel_size = PIXEL_SCALING_3X
						if(PIXEL_SCALING_3X)
							pixel_size = PIXEL_SCALING_AUTO
					user.client.view_size.apply() //Let's winset() it so it actually works

				if("scaling_method")
					switch(scaling_method)
						if(SCALING_METHOD_NORMAL)
							scaling_method = SCALING_METHOD_DISTORT
						if(SCALING_METHOD_DISTORT)
							scaling_method = SCALING_METHOD_BLUR
						if(SCALING_METHOD_BLUR)
							scaling_method = SCALING_METHOD_NORMAL
					user.client.view_size.setZoomMode()

				if("save")
					save_preferences()
					save_character()
					to_chat(user, span_notice("Настройки успешно сохранены!"))

				if("load")
					load_preferences()
					load_character()
					to_chat(user, span_notice("Настройки успешно загружены!"))

				if("changeslot")
					if(!load_character(text2num(href_list["num"])))
						random_character()
						real_name = random_unique_name(gender)
						save_character()

				if("name_lang")
					en_names = !en_names

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])

				if("clear_heart")
					hearted = FALSE
					hearted_until = null
					to_chat(user, span_notice("OOC Commendation Heart disabled"))
					save_preferences()

	ShowChoices(user)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE, is_latejoiner = TRUE)

	hardcore_survival_score = 0 //Set to 0 to prevent you getting points from last another time.

	if((randomise[RANDOM_SPECIES] || randomise[RANDOM_HARDCORE]) && !character_setup)

		random_species()

	if((randomise[RANDOM_BODY] || (randomise[RANDOM_BODY_ANTAG] && antagonist) || randomise[RANDOM_HARDCORE]) && !character_setup)
		slot_randomized = TRUE
		random_character(gender, antagonist)

	if((randomise[RANDOM_NAME] || (randomise[RANDOM_NAME_ANTAG] && antagonist) || randomise[RANDOM_HARDCORE]) && !character_setup)
		slot_randomized = TRUE
		real_name = pref_species.random_name(gender, en_lang = en_names)

	if(randomise[RANDOM_HARDCORE] && parent.mob.mind && !character_setup)
		if(can_be_random_hardcore())
			hardcore_random_setup(character, antagonist, is_latejoiner)

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && (pref_species.id == "human"))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	character.real_name = real_name
	character.name = character.real_name

	character.gender = gender
	character.age = age
	if(gender == MALE || gender == FEMALE)
		character.body_type = gender
	else
		character.body_type = body_type

	character.eye_color_left = eye_color_left
	character.eye_color_right = eye_color_right
	var/obj/item/organ/eyes/eyes_organ = character.getorgan(/obj/item/organ/eyes)
	if(eyes_organ && istype(eyes_organ))
		if(!initial(eyes_organ.eye_color_left))
			eyes_organ.eye_color_left = eye_color_left
		eyes_organ.old_eye_color_left = eye_color_left
		if(!initial(eyes_organ.eye_color_right))
			eyes_organ.eye_color_right = eye_color_right
		eyes_organ.old_eye_color_right = eye_color_right

	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color

	LAZYSETLEN(character.grad_color, GRADIENTS_LEN)
	character.grad_color[GRADIENT_HAIR_KEY] = hair_grad_color
	character.grad_color[GRADIENT_FACIAL_HAIR_KEY] = facial_grad_color

	LAZYSETLEN(character.grad_style, GRADIENTS_LEN)
	character.grad_style[GRADIENT_HAIR_KEY] = hair_grad_style
	character.grad_style[GRADIENT_FACIAL_HAIR_KEY] = facial_grad_style

	character.skin_tone = skin_tone
	character.hairstyle = hairstyle
	character.facial_hairstyle = facial_hairstyle
	character.underwear = underwear
	character.underwear_color = underwear_color
	character.undershirt = undershirt
	character.socks = socks

	character.backpack = backpack

	character.jumpsuit_style = jumpsuit_style

	var/datum/species/chosen_species
	chosen_species = pref_species.type

	character.dna.features = features.Copy()
	character.set_species(chosen_species, icon_update = FALSE, pref_load = TRUE)
	character.dna.real_name = character.real_name

	if(pref_species.mutant_bodyparts["tail_lizard"])
		character.dna.species.mutant_bodyparts["tail_lizard"] = pref_species.mutant_bodyparts["tail_lizard"]
	if(pref_species.mutant_bodyparts["spines"])
		character.dna.species.mutant_bodyparts["spines"] = pref_species.mutant_bodyparts["spines"]

	if(icon_updates)
		character.update_body()
		character.update_hair()
		character.update_body_parts()

/datum/preferences/proc/can_be_random_hardcore()
	if(parent.mob.mind.assigned_role in GLOB.command_positions) //No command staff
		return FALSE
	for(var/A in parent.mob.mind.antag_datums)
		var/datum/antagonist/antag
		if(antag.get_team()) //No team antags
			return FALSE
	return TRUE

/datum/preferences/proc/get_default_name(name_id)
	switch(name_id)
		if("human")
			return random_unique_name()
		if("ai")
			return pick(GLOB.ai_names)
		if("cyborg")
			return DEFAULT_CYBORG_NAME
		if("clown")
			return pick(GLOB.clown_names)
		if("mime")
			return pick(GLOB.mime_names)
		if("religion")
			return DEFAULT_RELIGION
		if("deity")
			return DEFAULT_DEITY
		if("bible")
			return DEFAULT_BIBLE
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = tgui_input_text(user, "Choose your character's [namedata["qdesc"]]:","Настройки персонажа")
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, span_red("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, [namedata["allow_numbers"] ? "0-9, " : ""]-, ' and . It must not contain any words restricted by IC chat and name filters."))
			return
		else
			custom_names[name_id] = sanitized_name
