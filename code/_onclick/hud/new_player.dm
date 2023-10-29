/datum/hud/new_player

/datum/hud/new_player/New(mob/owner)
	..()
	var/list/buttons = subtypesof(/atom/movable/screen/lobby)
	for(var/button_type in buttons)
		var/atom/movable/screen/lobby/lobbyscreen = new button_type()
		lobbyscreen.SlowInit()
		lobbyscreen.hud = src
		static_inventory += lobbyscreen
		if(istype(lobbyscreen, /atom/movable/screen/lobby/button))
			var/atom/movable/screen/lobby/button/lobby_button = lobbyscreen
			lobby_button.owner = REF(owner)

/atom/movable/screen/lobby
	plane = SPLASHSCREEN_PLANE
	layer = LOBBY_BUTTON_LAYER
	screen_loc = "TOP,CENTER"

/// Run sleeping actions after initialize
/atom/movable/screen/lobby/proc/SlowInit()
	return

/atom/movable/screen/lobby/round_info
	screen_loc = "BOTTOM+2,LEFT:16"
	maptext_height = 256
	maptext_width = 256

/atom/movable/screen/lobby/round_info/Initialize(mapload)
	. = ..()
	RegisterSignal(SStitle, COMSIG_TITLE_UPDATE_INFO, PROC_REF(update_info))

/atom/movable/screen/lobby/round_info/proc/update_info()
	SIGNAL_HANDLER

	var/generated_maptext = MAPTEXT_REALLYBIG_COLOR("Место действия: <b>[SSmapping.config?.map_name || "Загрузка..."]</b></br>", "#cd8c42")
	generated_maptext += MAPTEXT_REALLYBIG_COLOR("Номер события: <b>[GLOB.round_id ? GLOB.round_id : "NULL"]</b></br>", "#e0921e")
	if(!SSticker.HasRoundStarted())
		var/time_remaining = SSticker.GetTimeLeft()
		if(time_remaining > 0)
			time_remaining = "[round(time_remaining/10)]с"
		else if(time_remaining == -10)
			time_remaining = "ОТЛОЖЕНО"
		else
			time_remaining = "СЕЙЧАС"
		generated_maptext += MAPTEXT_REALLYBIG_COLOR("До начала: <b>[time_remaining]</b></br>", "#cf9625")
		generated_maptext += MAPTEXT_REALLYBIG_COLOR("Готовы: <b>[SSticker.totalPlayersReady]/[LAZYLEN(GLOB.clients)]</b></br></br>", "#d6b10a")
	else
		generated_maptext += MAPTEXT_REALLYBIG_COLOR("В действии: <b>[LAZYLEN(GLOB.joined_player_list)] человек</b></br></br>", "#c2b23c")
	generated_maptext += MAPTEXT_REALLYBIG_COLOR("Режим: <b>[SSticker.hide_mode ? "СЕКРЕТ" : "[capitalize(GLOB.master_mode)]"]</b>", "#ff4444")
	maptext = generated_maptext

/atom/movable/screen/lobby/neobg
	screen_loc = "BOTTOM,LEFT"
	icon = 'icons/effects/bg.dmi'
	icon_state = "back"
	layer = LOBBY_BACKGROUND_LAYER
	var/atom/movable/screen/eye_icon_bg
	var/atom/movable/screen/pupil_icon_bg
	var/atom/movable/screen/front_icon_bg
	var/atom/movable/screen/flicker_bg

/atom/movable/screen/lobby/neobg/New(loc, ...)
	. = ..()
	eye_icon_bg = new()
	eye_icon_bg.plane = SPLASHSCREEN_PLANE
	eye_icon_bg.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	eye_icon_bg.icon = icon
	eye_icon_bg.icon_state = "eye"

	pupil_icon_bg = new()
	pupil_icon_bg.plane = SPLASHSCREEN_PLANE
	pupil_icon_bg.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pupil_icon_bg.icon = icon
	pupil_icon_bg.icon_state = "pupil"

	front_icon_bg = new()
	front_icon_bg.plane = SPLASHSCREEN_PLANE
	front_icon_bg.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	front_icon_bg.icon = icon
	front_icon_bg.icon_state = "front"

	flicker_bg = new()
	flicker_bg.blend_mode = BLEND_ADD
	flicker_bg.plane = SPLASHSCREEN_PLANE
	flicker_bg.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flicker_bg.icon = icon
	flicker_bg.icon_state = null

	vis_contents += eye_icon_bg
	vis_contents += pupil_icon_bg
	vis_contents += front_icon_bg
	vis_contents += flicker_bg

/atom/movable/screen/lobby/neobg/Initialize(mapload)
	. = ..()
	RegisterSignal(SStitle, COMSIG_TITLE_UPDATE_BACKGROUND, PROC_REF(flex_with_background))

/atom/movable/screen/lobby/neobg/proc/flex_with_background(datum/source, autorotate = TRUE)
	SIGNAL_HANDLER

	flicker_bg.icon = icon
	flicker_bg.alpha = 255

	if(!autorotate)
		flicker_bg.icon = SStitle.icon
		return

	flick("fuck", flicker_bg)

	spawn(13)
		if(!flicker_bg)
			return
		flicker_bg.alpha = 0
		flicker_bg.icon = SStitle.icon
		animate(flicker_bg, alpha = 255, time = 10, easing = EASE_IN)
		animate(alpha = 200, time = 100)
		animate(alpha = 0, time = 50)

/atom/movable/screen/lobby/neobg/Destroy()
	. = ..()
	QDEL_NULL(eye_icon_bg)
	QDEL_NULL(pupil_icon_bg)
	QDEL_NULL(front_icon_bg)
	QDEL_NULL(flicker_bg)

/atom/movable/screen/lobby/neobg/MouseMove(location, control, params)

	if(!isnewplayer(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])

	animate(eye_icon_bg, 1, FALSE, SINE_EASING, ANIMATION_PARALLEL, pixel_x = (icon_x * 0.03) - 9, pixel_y = (icon_y * 0.03) - 7)
	animate(pupil_icon_bg, 1, FALSE, SINE_EASING, ANIMATION_PARALLEL, pixel_x = (icon_x * 0.06) - 18, pixel_y = (icon_y * 0.06) - 14)

/atom/movable/screen/lobby/button
	///Is the button currently enabled?
	var/enabled = TRUE
	///Is the button currently being hovered over with the mouse?
	var/highlighted = FALSE
	/// The ref of the mob that owns this button. Only the owner can click on it.
	var/owner

/atom/movable/screen/lobby/button/New(loc, ...)
	. = ..()
	add_filter("lobby", 1, drop_shadow_filter(0, 0, 12, 5, "#303030"))

/atom/movable/screen/lobby/button/Click(location, control, params)
	if(owner != REF(usr))
		return

	. = ..()

	if(!enabled)
		return
	flick("[base_icon_state]_pressed", src)
	update_appearance(UPDATE_ICON)
	return TRUE

/atom/movable/screen/lobby/button/MouseEntered(location,control,params)
	if(owner != REF(usr))
		return

	. = ..()
	highlighted = TRUE
	update_appearance(UPDATE_ICON)

/atom/movable/screen/lobby/button/MouseExited()
	if(owner != REF(usr))
		return

	. = ..()
	highlighted = FALSE
	update_appearance(UPDATE_ICON)

/atom/movable/screen/lobby/button/update_icon(updates)
	. = ..()
	if(!enabled)
		icon_state = "[base_icon_state]_disabled"
		return
	else if(highlighted)
		icon_state = "[base_icon_state]_highlighted"
		return
	icon_state = base_icon_state

/atom/movable/screen/lobby/button/proc/set_button_status(status)
	if(status == enabled)
		return FALSE
	enabled = status
	update_appearance(UPDATE_ICON)
	return TRUE

///Prefs menu
/atom/movable/screen/lobby/button/character_setup
	screen_loc = "LEFT+9,SOUTH:26"
	icon = 'icons/hud/lobbyv3/character_setup.dmi'
	icon_state = "character_setup"
	base_icon_state = "character_setup"

/atom/movable/screen/lobby/button/character_setup/Click(location, control, params)
	. = ..()
	if(!.)
		return

	hud.mymob.client.prefs.ShowChoices(hud.mymob)

///Button that appears before the game has started
/atom/movable/screen/lobby/button/ready
	screen_loc = "LEFT+2,SOUTH:26"
	icon = 'icons/hud/lobbyv3/ready.dmi'
	icon_state = "not_ready"
	base_icon_state = "not_ready"
	var/ready = FALSE

/atom/movable/screen/lobby/button/ready/Initialize(mapload)
	. = ..()
	switch(SSticker.current_state)
		if(GAME_STATE_PREGAME, GAME_STATE_STARTUP)
			RegisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP, PROC_REF(hide_ready_button))
		if(GAME_STATE_SETTING_UP)
			set_button_status(FALSE)
			RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(show_ready_button))
		else
			set_button_status(FALSE)

/atom/movable/screen/lobby/button/ready/proc/hide_ready_button()
	SIGNAL_HANDLER
	set_button_status(FALSE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP)
	RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(show_ready_button))

/atom/movable/screen/lobby/button/ready/proc/show_ready_button()
	SIGNAL_HANDLER
	set_button_status(TRUE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP)
	RegisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP, PROC_REF(hide_ready_button))

/atom/movable/screen/lobby/button/ready/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/mob/dead/new_player/new_player = hud.mymob

	if(!new_player.client.prefs.iconsent)
		new_player.client << browse(file2text('html/newcomer.html'), "window=newcomer;size=665x525;border=0;can_minimize=0;can_close=0;can_resize=0")
		to_chat(new_player.client, span_notice("Необходимо дать согласие, перед тем как вступить в игру."))
		return FALSE

	ready = !ready
	if(ready)
		new_player.ready = PLAYER_READY_TO_PLAY
		base_icon_state = "ready"
	else
		new_player.ready = PLAYER_NOT_READY
		base_icon_state = "not_ready"
	SStitle.update_lobby()
	update_appearance(UPDATE_ICON)

///Shown when the game has started
/atom/movable/screen/lobby/button/join
	screen_loc = "LEFT+1,SOUTH:24"
	icon = 'icons/hud/lobbyv3/join.dmi'
	icon_state = "" //Default to not visible
	base_icon_state = "join_game"
	enabled = FALSE

/atom/movable/screen/lobby/button/join/Initialize(mapload)
	. = ..()
	switch(SSticker.current_state)
		if(GAME_STATE_PREGAME, GAME_STATE_STARTUP)
			RegisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP, PROC_REF(show_join_button))
		if(GAME_STATE_SETTING_UP)
			set_button_status(TRUE)
			RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(hide_join_button))
		else
			set_button_status(TRUE)

/atom/movable/screen/lobby/button/join/Click(location, control, params)
	. = ..()
	if(!.)
		return
	if(!SSticker?.IsRoundInProgress())
		to_chat(hud.mymob, span_boldwarning("Раунд ещё не начался или уже завершился..."))
		return

	//Determines Relevent Population Cap
	var/relevant_cap
	var/hpc = CONFIG_GET(number/hard_popcap)
	var/epc = CONFIG_GET(number/extreme_popcap)
	if(hpc && epc)
		relevant_cap = min(hpc, epc)
	else
		relevant_cap = max(hpc, epc)

	var/mob/dead/new_player/new_player = hud.mymob

	if(SSticker.queued_players.len || (relevant_cap && living_player_count() >= relevant_cap && !(ckey(new_player.key) in GLOB.admin_datums)))
		to_chat(new_player, span_danger("[CONFIG_GET(string/hard_popcap_message)]"))

		var/queue_position = SSticker.queued_players.Find(new_player)
		if(queue_position == 1)
			to_chat(new_player, span_notice("Ты следующий по списку желающих войти в раунд. Тебя оповестят о подходящей возможности."))
		else if(queue_position)
			to_chat(new_player, span_notice("Перед тобой [queue_position-1] игроков в очереди ожидания захода в раунд."))
		else
			SSticker.queued_players += new_player
			to_chat(new_player, span_notice("Тебя добавили в очередь для захода в игру. Твой номер в очереди: [SSticker.queued_players.len]."))
		return
	if(SSrust_mode.active)
		new_player.AttemptLateSpawn(JOB_RUST_ENJOYER)
		return
	if(SSviolence.active)
		new_player.violence_choices()
		return
	else if(!GLOB.is_tournament_rules)
		new_player.LateChoices()
	else
		new_player.make_me_an_observer(TRUE)

/atom/movable/screen/lobby/button/join/proc/show_join_button()
	SIGNAL_HANDLER
	set_button_status(TRUE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP)
	RegisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP, PROC_REF(hide_join_button))

/atom/movable/screen/lobby/button/join/proc/hide_join_button()
	SIGNAL_HANDLER
	set_button_status(FALSE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ERROR_SETTING_UP)
	RegisterSignal(SSticker, COMSIG_TICKER_ENTER_SETTING_UP, PROC_REF(show_join_button))

/atom/movable/screen/lobby/button/observe
	screen_loc = "LEFT+5:24,SOUTH:24"
	icon = 'icons/hud/lobbyv3/observe.dmi'
	icon_state = "observe_disabled"
	base_icon_state = "observe"
	enabled = FALSE

/atom/movable/screen/lobby/button/observe/Initialize(mapload)
	. = ..()
	if(SSticker.current_state > GAME_STATE_STARTUP)
		set_button_status(TRUE)
	else
		RegisterSignal(SSticker, COMSIG_TICKER_ENTER_PREGAME, PROC_REF(enable_observing))

/atom/movable/screen/lobby/button/observe/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/mob/dead/new_player/new_player = hud.mymob
	new_player.make_me_an_observer()

/atom/movable/screen/lobby/button/observe/proc/enable_observing()
	SIGNAL_HANDLER
	flick("[base_icon_state]_enabled", src)
	set_button_status(TRUE)
	UnregisterSignal(SSticker, COMSIG_TICKER_ENTER_PREGAME, PROC_REF(enable_observing))

/*

/atom/movable/screen/lobby/button/settings
	icon = 'icons/hud/lobby/bottom_buttons.dmi'
	icon_state = "settings"
	base_icon_state = "settings"
	screen_loc = "TOP:-122,CENTER:+58"

*/

/atom/movable/screen/lobby/button/settings/Click(location, control, params)
	. = ..()
	if(!.)
		return

	hud.mymob.client.prefs.ShowChoices(hud.mymob)

/atom/movable/screen/lobby/button/site_button
	icon = 'icons/hud/lobbyv3/bottom_buttons.dmi'
	icon_state = "changelog"
	base_icon_state = "changelog"
	screen_loc = "LEFT+11:8,SOUTH:26"


/atom/movable/screen/lobby/button/crew_manifest
	icon = 'icons/hud/lobbyv3/bottom_buttons.dmi'
	icon_state = "crew_manifest"
	base_icon_state = "crew_manifest"
	screen_loc = "LEFT+13:16,SOUTH:26"

/atom/movable/screen/lobby/button/crew_manifest/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/mob/dead/new_player/new_player = hud.mymob
	new_player.ViewManifest()

/atom/movable/screen/lobby/button/site_button/Click(location, control, params)
	. = ..()
	var/lets_fucking_go = tgui_alert(usr,"Перейдём в интересное место? (это откроет страницу в браузере)", "Любопытство", list("Да", "Нет"))
	if(lets_fucking_go == "Да")
		usr << link("https://station13.ru")

/atom/movable/screen/lobby/button/poll
	icon = 'icons/hud/lobbyv3/bottom_buttons.dmi'
	icon_state = "poll"
	base_icon_state = "poll"
	screen_loc = "LEFT+16,SOUTH:26"

	var/new_poll = FALSE

/atom/movable/screen/lobby/button/poll/SlowInit(mapload)
	. = ..()
	if(!usr)
		return
	var/mob/dead/new_player/new_player = usr
	if(is_guest_key(new_player.key))
		set_button_status(FALSE)
		return
	if(!SSdbcore.Connect())
		set_button_status(FALSE)
		return
	var/isadmin = FALSE
	if(new_player.client?.holder)
		isadmin = TRUE
	var/datum/db_query/query_get_new_polls = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("poll_question")]
		WHERE (adminonly = 0 OR :isadmin = 1)
		AND Now() BETWEEN starttime AND endtime
		AND deleted = 0
		AND id NOT IN (
			SELECT pollid FROM [format_table_name("poll_vote")]
			WHERE ckey = :ckey
			AND deleted = 0
		)
		AND id NOT IN (
			SELECT pollid FROM [format_table_name("poll_textreply")]
			WHERE ckey = :ckey
			AND deleted = 0
		)
	"}, list("isadmin" = isadmin, "ckey" = new_player.ckey))
	if(!query_get_new_polls.Execute())
		qdel(query_get_new_polls)
		set_button_status(FALSE)
		return
	if(query_get_new_polls.NextRow())
		new_poll = TRUE
	else
		new_poll = FALSE
	update_appearance(UPDATE_OVERLAYS)
	qdel(query_get_new_polls)
	if(QDELETED(new_player))
		set_button_status(FALSE)
		return

/atom/movable/screen/lobby/button/poll/update_overlays()
	. = ..()
	if(new_poll)
		. += mutable_appearance('icons/hud/lobby/poll_overlay.dmi', "new_poll")

/atom/movable/screen/lobby/button/poll/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/mob/dead/new_player/new_player = hud.mymob
	new_player.handle_player_polling()
