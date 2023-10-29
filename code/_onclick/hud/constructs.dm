/datum/hud/constructs
	ui_style = 'icons/hud/screen_construct.dmi'

/datum/hud/constructs/New(mob/owner)
	..()
	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = retro_hud ? ui_style : pull_icon.icon
	pull_icon.update_icon()
	pull_icon.screen_loc = UI_CONSTRUCT_PULL
	pull_icon.hud = src
	static_inventory += pull_icon

	healths = new /atom/movable/screen/healths/construct()
	healths.hud = src
	infodisplay += healths
