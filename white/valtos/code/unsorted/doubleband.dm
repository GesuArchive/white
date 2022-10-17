/obj/item/storage/belt/bandolier/double
	name = "два бандольера"
	desc = "Вдвое больше веселья!"
	icon = 'white/valtos/icons/clothing/belts.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	icon_state = "bandolier_double"
	worn_icon_state = "bandolier_double"

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
		if(contents.len > 0)
			to_chat(user, span_warning("Оба должны быть пустыми!"))
			return
		else
			to_chat(user, span_notice("Соединяю бандольеры вместе."))
			qdel(I)
			qdel(src)
			user.put_in_hands(new /obj/item/storage/belt/bandolier/double(user))
			return
	..()
