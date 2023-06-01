/datum/hud/living
	ui_style = 'icons/hud/screen_gen.dmi'

/datum/hud/living/New(mob/living/owner)
	..()

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = retro_hud ? ui_style : pull_icon.icon
	pull_icon.update_icon()
	pull_icon.screen_loc = retro_hud ? UI_LIVING_PULL_RETRO : UI_LIVING_PULL
	pull_icon.hud = src
	static_inventory += pull_icon

	combo_display = new /atom/movable/screen/combo()
	combo_display.icon = retro_hud ? combo_display.icon : ui_style
	combo_display.icon_state = retro_hud ? "" : "combo_bg"
	combo_display.screen_loc = retro_hud ? UI_COMBO_RETRO : UI_COMBO
	combo_display.retro_hud = retro_hud
	infodisplay += combo_display

	//mob health doll! assumes whatever sprite the mob is
	healthdoll = new /atom/movable/screen/healthdoll/living()
	healthdoll.screen_loc = retro_hud ? UI_LIVING_HEALTHDOLL_RETRO : UI_LIVING_HEALTHDOLL
	healthdoll.hud = src
	infodisplay += healthdoll

	typer = new /atom/movable/screen/typer()
	typer.hud = src
	infodisplay += typer
