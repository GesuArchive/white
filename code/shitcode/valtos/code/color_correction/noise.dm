/obj/screen/fullscreen/noisescreen
	icon = 'code/shitcode/valtos/icons/fullscreen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "fullscreen"

/mob/dead/new_player/Initialize()
	. = ..()
	overlay_fullscreen("fullscreen", /obj/screen/fullscreen/noisescreen)
