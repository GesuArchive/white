///Hud type with targetting dol and a nutrition bar
/datum/hud/ooze/New(mob/living/owner)
	. = ..()

	zone_select = new /atom/movable/screen/zone_sel()
	zone_select.retro_hud = retro_hud
	zone_select.icon = retro_hud ? ui_style : zone_select.icon
	zone_select.overlay_icon = retro_hud ? 'icons/hud/screen_gen.dmi' : zone_select.icon
	zone_select.screen_loc = retro_hud ? UI_ZONESEL_RETRO : UI_ZONESEL
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select

	alien_plasma_display = new /atom/movable/screen/ooze_nutrition_display //Just going to use the alien plasma display because making new vars for each object is braindead.
	alien_plasma_display.screen_loc = retro_hud ? UI_ALIENPLASMADISPLAY_RETRO : UI_ALIENPLASMADISPLAY
	alien_plasma_display.hud = src
	infodisplay += alien_plasma_display

/atom/movable/screen/ooze_nutrition_display
	icon = 'icons/hud/screen_alien.dmi'
	icon_state = "power_display"
	name = "nutrition"
