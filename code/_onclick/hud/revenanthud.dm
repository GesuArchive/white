/datum/hud/revenant
	ui_style = 'icons/hud/screen_gen.dmi'

/datum/hud/revenant/New(mob/owner)
	..()

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = retro_hud ? ui_style : pull_icon.icon
	pull_icon.update_icon()
	pull_icon.screen_loc = retro_hud ? UI_LIVING_PULL_RETRO : UI_LIVING_PULL
	pull_icon.hud = src
	static_inventory += pull_icon

	healths = new /atom/movable/screen/healths/revenant()
	healths.screen_loc = retro_hud ? UI_HEALTH_RETRO : UI_HEALTH
	healths.hud = src
	infodisplay += healths

