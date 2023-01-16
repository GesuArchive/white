/obj/item/storage/belt/bandolier/double
	name = "двойной бандольер"
	desc = "Вдвое больше веселья!"
	icon = 'white/valtos/icons/clothing/belts.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	icon_state = "bandolier_double"
	worn_icon_state = "bandolier_double"
	multibelt = BANDOLIER_DOUBLE

/obj/item/storage/belt/bandolier/double/Initialize()
	. = ..()
	atom_storage.max_slots = 36
	atom_storage.max_total_storage = 36
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(
		/obj/item/ammo_casing/shotgun
		))

/obj/item/storage/belt/bandolier/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/storage/belt/bandolier))
		if(multibelt == BANDOLIER_MONO)
			if(contents.len > 0)
				to_chat(user, span_warning("Все бандольеры должны быть пустыми!"))
				return
			else
				to_chat(user, span_notice("Соединяю бандольеры вместе."))
				qdel(I)
				qdel(src)
				user.put_in_hands(new /obj/item/storage/belt/bandolier/double(user))
				return
		if(multibelt == BANDOLIER_DOUBLE)
			if(contents.len > 0)
				to_chat(user, span_warning("Все бандольеры должны быть пустыми!"))
				return
			else
				to_chat(user, span_notice("Соединяю бандольеры вместе."))
				qdel(I)
				qdel(src)
				user.put_in_hands(new /obj/item/storage/belt/bandolier/triple(user))
				return
		if(multibelt == BANDOLIER_TRIPLE)
			to_chat(user, span_warning("Куда уже больше?!"))
			return
	..()

/obj/item/storage/belt/bandolier/triple
	name = "тройной бандольер"
	desc = "Мы хорошие ребята, жаль патронов маловато..."
	icon = 'white/valtos/icons/clothing/belts.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	icon_state = "bandolier_triple"
	worn_icon_state = "bandolier_double"
	multibelt = BANDOLIER_TRIPLE

/obj/item/storage/belt/bandolier/doutripleble/Initialize()
	. = ..()
	atom_storage.max_slots = 54
	atom_storage.max_total_storage = 54
	atom_storage.numerical_stacking = TRUE
	atom_storage.set_holdable(list(
		/obj/item/ammo_casing/shotgun
		))
