//CONTAINS: Evidence bags

/obj/item/evidencebag
	name = "пакетик для улик"
	desc = "Пустой пакетик для улик."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidenceobj"
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_TINY

/obj/item/evidencebag/afterattack(obj/item/I, mob/user,proximity)
	. = ..()
	if(!proximity || loc == I)
		return
	evidencebagEquip(I, user)

/obj/item/evidencebag/attackby(obj/item/I, mob/user, params)
	if(evidencebagEquip(I, user))
		return 1

/obj/item/evidencebag/handle_atom_del(atom/A)
	cut_overlays()
	w_class = initial(w_class)
	icon_state = initial(icon_state)
	desc = initial(desc)

/obj/item/evidencebag/proc/evidencebagEquip(obj/item/I, mob/user)
	if(!istype(I) || I.anchored)
		return

	if(SEND_SIGNAL(loc, COMSIG_CONTAINS_STORAGE) && SEND_SIGNAL(I, COMSIG_CONTAINS_STORAGE))
		to_chat(user, span_warning("Как бы я не пытался у меня не выходит запихать [I] внутрь [src]."))
		return TRUE	//begone infinite storage ghosts, begone from me

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, span_warning("Засовывать один пакетик для улик в другой довольно абсурдное занятие."))
		return TRUE //now this is podracing

	if(loc in I.GetAllContents()) // fixes tg #39452, evidence bags could store their own location, causing I to be stored in the bag while being present inworld still, and able to be teleported when removed.
		to_chat(user, span_warning("Нахожу засовывание [I] в [src] пока он всё еще внутри довольно сложным занятием!"))
		return

	if(I.w_class > WEIGHT_CLASS_NORMAL)
		to_chat(user, span_warning("[I] не поместится в [src]!"))
		return

	if(contents.len)
		to_chat(user, span_warning("Внутри [src] уже что-то есть!"))
		return

	if(!isturf(I.loc)) //If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(SEND_SIGNAL(I.loc, COMSIG_CONTAINS_STORAGE))	//in a container.
			SEND_SIGNAL(I.loc, COMSIG_TRY_STORAGE_TAKE, I, src)
		if(!user.dropItemToGround(I))
			return

	user.visible_message(span_notice("[user] положил [I] в [src].") , span_notice("Положил [I] внутрь [src].") ,\
	span_hear("Слышу как кто-то шелестит полиэтиленовым пакетом засовывая в него что-то."))

	icon_state = "evidence"

	var/mutable_appearance/in_evidence = new(I)
	in_evidence.plane = FLOAT_PLANE
	in_evidence.layer = FLOAT_LAYER
	in_evidence.pixel_x = 0
	in_evidence.pixel_y = 0
	add_overlay(in_evidence)
	add_overlay("evidence")	//should look nicer for transparent stuff. not really that important, but hey.

	desc = "Пакетик для улик, в котором лежит [I]. [I.desc]"
	I.forceMove(src)
	w_class = I.w_class
	return 1

/obj/item/evidencebag/attack_self(mob/user)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] вытаскивает [I] из [src].") , span_notice("Достал [I] из [src].") ,\
		span_hear("Слышу как кто-то шелестит доставая что-то из полиэтиленового пакета."))
		cut_overlays()	//remove the overlays
		user.put_in_hands(I)
		w_class = WEIGHT_CLASS_TINY
		icon_state = "evidenceobj"
		desc = "Пустой пакетик для улик."

	else
		to_chat(user, span_notice("[capitalize(src.name)] пуст."))
		icon_state = "evidenceobj"
	return

/obj/item/storage/box/evidence
	name = "ящик с мешками для улик"
	desc = "Ящик для хранения мешков для улик."

/obj/item/storage/box/evidence/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/evidencebag(src)
