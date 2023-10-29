/obj/item/folder
	name = "папка"
	desc = "Просто папка."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = WEIGHT_CLASS_SMALL
	pressure_resistance = 2
	resistance_flags = FLAMMABLE

/obj/item/folder/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] начинает оформление мнимого смертного приговора! Судя по всему, он[user.ru_a()] пытается совершить суицид!"))
	return OXYLOSS

/obj/item/folder/blue
	desc = "Просто голубая папка."
	icon_state = "folder_blue"

/obj/item/folder/red
	desc = "Просто красная папка."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "Просто жёлтая папка."
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = "Просто белая папка."
	icon_state = "folder_white"


/obj/item/folder/update_overlays()
	. = ..()
	if(contents.len)
		. += "folder_paper"


/obj/item/folder/attackby(obj/item/W, mob/user, params)
	if(burn_paper_product_attackby_check(W, user))
		return
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/documents))
		if(!user.transferItemToLoc(W, src))
			return
		to_chat(user, span_notice("Кладу [W] в [src]."))
		update_icon()
	else if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, span_notice("Неразборчиво калякаю на обложке [src]!"))
			return

		var/inputvalue = stripped_input(user, "Как подпишем папку?", "Переименование папки", "", MAX_NAME_LEN)

		if(!inputvalue)
			return

		if(user.canUseTopic(src, BE_CLOSE))
			name = "папка[(inputvalue ? " - '[inputvalue]'" : null)]"


/obj/item/folder/Destroy()
	for(var/obj/important_thing in contents)
		if(!(important_thing.resistance_flags & INDESTRUCTIBLE))
			continue
		important_thing.forceMove(drop_location()) //don't destroy round critical content such as objective documents.
	return ..()


/obj/item/folder/attack_self(mob/user)
	var/dat = "<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head>"

	for(var/obj/item/I in src)
		dat += "<a href='?src=[REF(src)];read=[REF(I)]'>[I.name]</a><a href='?src=[REF(src)];remove=[REF(I)]'>Изъять</a></br>"
	var/datum/browser/folder = new(user, "folder", "[name]", 300, 500)
	folder.set_content(dat)
	folder.open()
	add_fingerprint(usr)


/obj/item/folder/Topic(href, href_list)
	..()
	if(usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(usr.contents.Find(src))

		if(href_list["remove"])
			var/obj/item/I = locate(href_list["remove"]) in src
			if(istype(I))
				I.forceMove(usr.loc)
				usr.put_in_hands(I)

		if(href_list["read"])
			var/obj/item/I = locate(href_list["read"]) in src
			if(istype(I))
				usr.examinate(I)

		//Update everything
		attack_self(usr)
		update_icon()

/obj/item/folder/documents
	name = "папка - 'СОВЕРШЕННО СЕКРЕТНО'"
	desc = "Папка со штампом \"Совершенно секретно — собственность корпорации NanoTrasen. Несанкционированное распространение карается смертью.\""

/obj/item/folder/documents/Initialize(mapload)
	. = ..()
	new /obj/item/documents/nanotrasen(src)
	update_icon()

/obj/item/folder/syndicate
	icon_state = "folder_syndie"
	name = "папка - 'СОВЕРШЕННО СЕКРЕТНО'"
	desc = "Папка со штампом \"Совершенно секретно — собственность Синдиката.\""

/obj/item/folder/syndicate/red
	icon_state = "folder_sred"

/obj/item/folder/syndicate/red/Initialize(mapload)
	. = ..()
	new /obj/item/documents/syndicate/red(src)
	update_icon()

/obj/item/folder/syndicate/blue
	icon_state = "folder_sblue"

/obj/item/folder/syndicate/blue/Initialize(mapload)
	. = ..()
	new /obj/item/documents/syndicate/blue(src)
	update_icon()

/obj/item/folder/syndicate/mining/Initialize(mapload)
	. = ..()
	new /obj/item/documents/syndicate/mining(src)
	update_icon()
