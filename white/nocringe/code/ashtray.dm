/obj/item/storage/ashtray
	name = "пластиковая пепельница"
	desc = "Дешевая пластиковая пепельница."
	icon = 'white/nocringe/icons/ashtray.dmi'
	icon_state = "ashtray_bl"
	var/icon_half  = "ashtray_half_bl"
	var/icon_full  = "ashtray_full_bl"
	var/icon_broken = "ashtray_bork_bl"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 8
	max_integrity = 12
	var/storage_slots = 6
	var/can_hold = list(
			/obj/item/cigbutt,
			/obj/item/clothing/mask/cigarette,
			/obj/item/match,
			/obj/item/rollingpaper
			)

/obj/item/storage/ashtray/Initialize(mapload)
	. = ..()
	pixel_y = rand(-5, 5)
	pixel_x = rand(-6, 6)
	create_storage(
		max_slots=storage_slots,
		canhold=can_hold,
		allow_quick_gather=TRUE,
		allow_quick_empty=TRUE
	)

/obj/item/storage/ashtray/update_icon_state()
	. = ..()
	if(contents.len == storage_slots)
		icon_state = icon_full
		desc = initial(desc) + " Она переполнена."
		return
	if(contents.len >= storage_slots * 0.5)
		icon_state = icon_half
		desc = initial(desc) + " Она наполовину заполнена."
		return
	if(contents.len < storage_slots * 0.5)
		icon_state = initial(icon_state)
		desc = initial(desc)

/obj/item/storage/ashtray/bronze
	name = "латунная пепельница"
	desc = "Массивная латунная пепельница."
	icon_state = "ashtray_br"
	icon_half  = "ashtray_half_br"
	icon_full  = "ashtray_full_br"
	icon_broken = "ashtray_bork_br"
	max_integrity = 16
	throwforce = 10

/obj/item/storage/ashtray/glass
	name = "стеклянная пепельница"
	desc = "Стеклянная пепельница. Выглядит хрупкой."
	icon_state = "ashtray_gl"
	icon_half  = "ashtray_half_gl"
	icon_full  = "ashtray_full_gl"
	icon_broken = "ashtray_bork_gl"
	max_integrity = 8
	throwforce = 6

/obj/item/storage/ashtray/attackby(obj/item/I, mob/user, params)
	if (!(is_type_in_typecache(I, can_hold)))
		return ..()

	if(contents.len == storage_slots)
		visible_message("[user] пытается положить [I] в пепельницу, но она переполнена.")
		return
	if(istype(I, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/cig = I
		if(cig.lit)
			visible_message("[user] тушит [cig] в пепельнице.")
			var/obj/item/butt = new cig.type_butt
			I.transfer_fingerprints_to(butt)
			user.transferItemToLoc(butt, src)
			qdel(cig)
		else
			visible_message("[user] кладет [cig] в пепельницу, даже не закурив.")
		user.transferItemToLoc(cig, src)
		return ..()

	user.transferItemToLoc(I, src)
	visible_message("[user] кладет [I] в пепельницу.")
	return ..()

/obj/item/storage/ashtray/deconstruct()
	var/obj/item/trash/broken_ashtray/shards = new(get_turf(src))
	shards.icon_state = src.icon_broken
	visible_message(span_warning("Пепельница разбилась!"))
	return ..()

/obj/item/storage/ashtray/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(contents.len)
		for(var/obj/item/I in contents)
			I.forceMove(loc)
		update_icon()
		visible_message(span_warning("Пепельница врезается в [hit_atom], разбрасывая свое содержимое!"))
	if(rand(1,20) > max_integrity)
		deconstruct()
	return ..()

/obj/item/trash/broken_ashtray
	name = "ashtray shards"
	icon = 'white/nocringe/icons/ashtray.dmi'
	icon_state = "ashtray_bork_bl"

/obj/item/trash/broken_ashtray/Initialize(mapload)
	. = ..()
	icon_state = "ashtray_bork_" + pick(list("bl","br","gl"))
