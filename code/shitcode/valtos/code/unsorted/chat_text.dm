// source - https://github.com/BurgerLUA/burgerstation/blob/2eb9553859cf3491d1170316dbf658da454bbcb1/code/_core/obj/overlay/chat_text.dm

GLOBAL_VAR_INIT(chat_bubbles, FALSE)

/obj/effect/chat_text
	name = "overlay"
	desc = "overlay object"
	plane = 23

	icon = null

	var/mob/owner

	mouse_opacity = 0

/obj/effect/chat_text/Destroy()

	if(owner)
		owner.stored_chat_text -= src
		owner = null

	return ..()

/obj/effect/chat_text/New(var/atom/desired_loc, var/desired_text, var/bypass_length=FALSE)

	owner = desired_loc

	for(var/obj/effect/chat_text/CT in owner.stored_chat_text)
		animate(CT,pixel_y = CT.pixel_y + 8,time = 5)

	owner.stored_chat_text += src

	src.alpha = 0
	src.pixel_y = -8
	animate(src,pixel_y = 0, alpha = 255, time = 5)
	forceMove(get_turf(desired_loc))

	maptext_width = 32*CEILING(10*0.75,2)
	maptext_x = -(maptext_width-32)*0.5
	maptext_y = 32*0.75

	if(!bypass_length && length_char(desired_text) >= 52) //52 is a magic number because reasons.
		desired_text = copytext_char(desired_text,1,52) + "..."

	maptext = "<center><font color='white' style='text-shadow: 0 0 3px black;'>[html_decode(desired_text)]</font></center>"

	spawn(50)
		animate(src,alpha=0,time=10)
		sleep(10)
		if(src)
			qdel(src)

	return ..()
