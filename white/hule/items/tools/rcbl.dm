/obj/item/conv_printer
	name = "Rapid Conveyor Belt Printer"
	desc = "A device used to rapidly construct conveyor lines."
	icon = 'icons/obj/tools.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	icon_state = "rcd"
	flags_1 = CONDUCT_1
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=50000)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	var/matter = 0
	var/mattermax = 100
	var/c_id = ""
	var/mode = 1

/obj/item/conv_printer/Initialize(mapload)
	. = ..()

/obj/item/conv_printer/examine(mob/user)
	. = ..()
	. += "<hr>"
	. += span_notice("It currently holds [matter]/[mattermax] fabrication-units.")

/obj/item/conv_printer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rcd_ammo))
		if((matter + 10) > mattermax)
			to_chat(user, span_notice("The RCBP can't hold any more matter."))
			return
		qdel(I)
		matter += 10
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		to_chat(user, span_notice("The RCBP now holds [matter]/[mattermax] fabrication-units."))
	/*
	else if (istype(I, /obj/item/multitool))
		c_id = tgui_input_text(user, "Input a conveyor id", "Conveyor ID", c_id)
	*/
	else if(istype(I, /obj/item/conveyor_switch_construct))
		to_chat(user, span_notice("You link the switch to the RCBP."))
		var/obj/item/conveyor_switch_construct/C = I
		c_id = C.id
	else
		return ..()

/obj/item/conv_printer/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(c_id == "")
		to_chat(user, span_notice("No switch linked!"))
		return

	if(istype(A, /obj/machinery/conveyor) && user.a_intent == INTENT_HARM)
		matter++
		qdel(A)
		to_chat(user, span_notice("Deconstructing [A.name]..."))
		return

	if (matter < 1)
		to_chat(user, span_warning("<b>[capitalize(src)]</b> doesn't have enough matter left."))
		return

	to_chat(user, span_notice("Constructing conveyor belt..."))

	var/obj/machinery/conveyor/B = new(get_turf(A))
	B.id = c_id
	B.dir = user.dir
	B.movedir = user.dir
	LAZYADD(GLOB.conveyors_by_id[B.id], B)

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)

	matter--
	to_chat(user, span_notice("The RCBP now holds [matter]/[mattermax] fabrication-units."))

/datum/design/conv_printer
	name = "Rapid Conveyor Belt Printer"
	id = "conv_printer"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 50000)
	build_path = /obj/item/conv_printer
	category = list("hacked", "Конструкции")
