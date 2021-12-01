/atom/movable/screen/fullscreen/noisescreen
	icon = 'white/valtos/icons/fullscreen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"
	show_when_dead = TRUE
	layer = 25
	plane = 25
	alpha = 87
	blend_mode = 3

/mob/dead/new_player/Initialize()
	. = ..()
	overlay_fullscreen("noise", /atom/movable/screen/fullscreen/noisescreen)

/atom/movable/screen/fullscreen/noisescreen/warfare
	icon = 'white/valtos/icons/is12/effects.dmi'
	icon_state = "wwi"
	alpha = 255
	blend_mode = 0
