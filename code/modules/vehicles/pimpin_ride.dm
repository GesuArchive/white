//PIMP-CART
/obj/vehicle/ridden/janicart
	name = "ДжениКар"
	desc = "Отважный киборг-уборщик отдал свою жизнь за создание такого удивительного сочетания скорости и полезности."
	icon_state = "pussywagon"
	key_type = /obj/item/key/janitor
	var/obj/item/storage/bag/trash/mybag = null
	var/floorbuffer = FALSE

/obj/vehicle/ridden/janicart/Initialize(mapload)
	. = ..()
	update_icon()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/janicart)

	GLOB.janitor_devices += src

	if(floorbuffer)
		AddElement(/datum/element/cleaning)

/obj/vehicle/ridden/janicart/Destroy()
	GLOB.janitor_devices -= src
	if(mybag)
		QDEL_NULL(mybag)
	return ..()

/obj/item/janiupgrade
	name = "модернизация полоукладчика"
	desc = "Модернизация для ремонта пола на ДжениКаре."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "upgrade"

/obj/vehicle/ridden/janicart/examine(mob/user)
	. = ..()
	if(floorbuffer)
		. += "<hr>Модернизирован полоукладчиком."

/obj/vehicle/ridden/janicart/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/storage/bag/trash))
		if(mybag)
			to_chat(user, span_warning("Тут уже висит мешок для мусора!"))
			return
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, span_notice("Прицепляю мусорный мешок к [src]у."))
		mybag = I
		update_icon()
	else if(istype(I, /obj/item/janiupgrade))
		if(floorbuffer)
			to_chat(user, span_warning("[capitalize(src.name)] уже модифицирован полоукладчиком!"))
			return
		floorbuffer = TRUE
		qdel(I)
		to_chat(user, span_notice("Модернизирую [src] при помощи модуля полоукладчика."))
		AddElement(/datum/element/cleaning)
		update_icon()
	else if(mybag)
		mybag.attackby(I, user)
	else
		return ..()

/obj/vehicle/ridden/janicart/update_overlays()
	. = ..()
	if(mybag)
		. += "cart_garbage"
	if(floorbuffer)
		. += "cart_buffer"

/obj/vehicle/ridden/janicart/attack_hand(mob/user)
	. = ..()
	if(. || !mybag)
		return
	mybag.forceMove(get_turf(user))
	user.put_in_hands(mybag)
	mybag = null
	update_icon()

/obj/vehicle/ridden/janicart/upgraded
	floorbuffer = TRUE
