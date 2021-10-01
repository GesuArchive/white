/atom/movable/screen/fullscreen/noisescreen
	icon = 'white/valtos/icons/fullscreen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"
	show_when_dead = TRUE
	layer = 25
	plane = 25
	alpha = 200
	blend_mode = 3

/mob/dead/new_player/Initialize()
	. = ..()
	overlay_fullscreen("noise", /atom/movable/screen/fullscreen/noisescreen)
