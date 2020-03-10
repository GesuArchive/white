/obj/screen/fullscreen/noisescreen
	icon = 'code/shitcode/valtos/icons/fullscreen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"

/mob/dead/new_player/Initialize()
	. = ..()
	overlay_fullscreen("noise", /obj/screen/fullscreen/noisescreen)
