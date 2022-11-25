/obj/item/quantum_keycard
	name = "квантовая ключ-карта"
	desc = "Ключ-карта, способная записать сигнатуру частиц квантовой площадки, позволяя соединить ее с другими квантовыми площадками."
	icon = 'icons/obj/device.dmi'
	icon_state = "quantum_keycard"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/obj/machinery/quantumpad/qpad

/obj/item/quantum_keycard/examine(mob/user)
	. = ..()
	if(qpad)
		. += "<hr>It's currently linked to a quantum pad."
		. += "<hr><span class='notice'>ПКМ to unlink the keycard.</span>"
	else
		. += "<hr><span class='notice'>Insert [src] into an active quantum pad to link it.</span>"

/obj/item/quantum_keycard/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	to_chat(user, span_notice("You start pressing [src] unlink button..."))
	if(do_after(user, 40, target = src))
		to_chat(user, span_notice("The keycard beeps twice and disconnects the quantum link."))
		qpad = null

/obj/item/quantum_keycard/update_icon_state()
	. = ..()
	if(qpad)
		icon_state = "quantum_keycard_on"
	else
		icon_state = initial(icon_state)
