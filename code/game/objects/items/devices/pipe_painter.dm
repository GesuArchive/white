/obj/item/pipe_painter
	name = "маркировщик труб"
	desc = "Раскрашивает трубы в нужные цвета."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	inhand_icon_state = "flight"
	item_flags = NOBLUDGEON
	var/paint_color = "grey"

	custom_materials = list(/datum/material/iron=5000, /datum/material/glass=2000)

/obj/item/pipe_painter/afterattack(atom/A, mob/user, proximity_flag)
	. = ..()
	//Make sure we only paint adjacent items
	if(!proximity_flag)
		return

	if(!istype(A, /obj/machinery/atmospherics/pipe))
		return

	var/obj/machinery/atmospherics/pipe/P = A
	if(P.paint(GLOB.pipe_paint_colors[paint_color]))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		user.visible_message(span_notice("[user] paints [P] [paint_color].") ,span_notice("You paint [P] [paint_color]."))

/obj/item/pipe_painter/attack_self(mob/user)
	paint_color = tgui_input_list(usr, "Which colour do you want to use?","Pipe painter",GLOB.pipe_paint_colors)

/obj/item/pipe_painter/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>It is set to [paint_color].</span>"
