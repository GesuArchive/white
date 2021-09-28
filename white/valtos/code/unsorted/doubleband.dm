/obj/item/storage/belt/bandolier/double
	name = "два бандольера"
	desc = "Вдвое больше веселья!"
	icon = 'white/valtos/icons/clothing/belts.dmi'
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	icon_state = "bandolier_double"
	worn_icon_state = "bandolier_double"

/obj/item/storage/belt/bandolier/double/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 36
	STR.max_combined_w_class = 36
	STR.display_numerical_stacking = TRUE
	STR.set_holdable(list(
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
