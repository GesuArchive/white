/datum/hud/larva
	ui_style = 'icons/hud/screen_alien.dmi'

/datum/hud/larva/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/act_intent/alien()
	using.screen_loc = retro_hud ? UI_ACTI_RETRO : UI_ACTI
	using.icon_state = mymob.a_intent
	using.hud = src
	static_inventory += using
	action_intent = using

	healths = new /atom/movable/screen/healths/alien()
	healths.screen_loc = retro_hud ? UI_ALIEN_HEALTH_RETRO : UI_ALIEN_HEALTH
	healths.hud = src
	infodisplay += healths

	alien_queen_finder = new /atom/movable/screen/alien/alien_queen_finder()
	alien_queen_finder.hud = src
	infodisplay += alien_queen_finder

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = 'icons/hud/screen_alien.dmi'
	pull_icon.update_icon()
	pull_icon.screen_loc = UI_ABOVE_MOVEMENT
	pull_icon.hud = src
	hotkeybuttons += pull_icon

	using = new /atom/movable/screen/navigate
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_ALIEN_NAVIGATE_RETRO : UI_ALIEN_NAVIGATE
	using.hud = src
	static_inventory += using

	using = new/atom/movable/screen/language_menu
	using.icon = retro_hud ? ui_style : using.icon
	using.screen_loc = retro_hud ? UI_ALIEN_LANGUAGE_MENU_RETRO : UI_ALIEN_LANGUAGE_MENU
	using.hud = src
	static_inventory += using

	zone_select = new /atom/movable/screen/zone_sel/alien()
	zone_select.retro_hud = retro_hud
	zone_select.icon = retro_hud ? 'icons/hud/screen_alien.dmi' : zone_select.icon
	zone_select.overlay_icon = retro_hud ? 'icons/hud/screen_alien.dmi' : zone_select.icon
	zone_select.screen_loc = retro_hud ? UI_ZONESEL_RETRO : UI_ZONESEL
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select
