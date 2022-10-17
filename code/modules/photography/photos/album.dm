/*
 * Photo album
 */
/obj/item/storage/photo_album
	name = "фотоальбом"
	desc = "Большая книга для хранения ваших воспоминаний."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "album"
	inhand_icon_state = "album"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	var/persistence_id = "piss"

/obj/item/storage/photo_album/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(/obj/item/photo))
	atom_storage.max_total_storage = 42
	atom_storage.max_slots = 21
	LAZYADD(SSpersistence.photo_albums, src)

/obj/item/storage/photo_album/Destroy()
	LAZYREMOVE(SSpersistence.photo_albums, src)
	return ..()

/obj/item/storage/photo_album/proc/get_picture_id_list()
	var/list/L = list()
	for(var/i in contents)
		if(istype(i, /obj/item/photo))
			L += i
	if(!L.len)
		return
	. = list()
	for(var/i in L)
		var/obj/item/photo/P = i
		if(!istype(P.picture))
			continue
		. |= P.picture.id

//Manual loading, DO NOT USE FOR HARDCODED/MAPPED IN ALBUMS. This is for if an album needs to be loaded mid-round from an ID.
/obj/item/storage/photo_album/proc/persistence_load()
	var/list/data = SSpersistence.GetPhotoAlbums()
	if(data[persistence_id])
		populate_from_id_list(data[persistence_id])

/obj/item/storage/photo_album/proc/populate_from_id_list(list/ids)
	var/list/current_ids = get_picture_id_list()
	for(var/i in ids)
		if(i in current_ids)
			continue
		var/obj/item/photo/old/P = load_photo_from_disk(i)
		if(istype(P))
			if(!atom_storage?.attempt_insert(P, override = TRUE))
				qdel(P)

/obj/item/storage/photo_album/hos
	name = "фотоальбом начальника охраны"
	icon_state = "album_blue"
	persistence_id = "HoS"

/obj/item/storage/photo_album/rd
	name = "фотоальбом научного руководителя"
	icon_state = "album_blue"
	persistence_id = "RD"

/obj/item/storage/photo_album/hop
	name = "фотоальбом главы персонала"
	icon_state = "album_blue"
	persistence_id = "HoP"

/obj/item/storage/photo_album/captain
	name = "фотоальбом капитана"
	icon_state = "album_blue"
	persistence_id = JOB_CAPTAIN

/obj/item/storage/photo_album/cmo
	name = "фотоальбом главного врача"
	icon_state = "album_blue"
	persistence_id = "CMO"

/obj/item/storage/photo_album/qm
	name = "фотоальбом завхоза"
	icon_state = "album_blue"
	persistence_id = "QM"

/obj/item/storage/photo_album/ce
	name = "фотоальбом старшего инженера"
	icon_state = "album_blue"
	persistence_id = "CE"

/obj/item/storage/photo_album/bar
	name = "фотоальбом бара"
	icon_state = "album_blue"
	persistence_id = "bar"

/obj/item/storage/photo_album/syndicate
	name = "фотоальбом синдиката"
	icon_state = "album_red"
	persistence_id = "syndicate"

/obj/item/storage/photo_album/library
	name = "фотоальбом библиотеки"
	icon_state = "album_blue"
	persistence_id = "library"

/obj/item/storage/photo_album/chapel
	name = "фотоальбом церкви"
	icon_state = "album_blue"
	persistence_id = "chapel"

/obj/item/storage/photo_album/prison
	name = "фотоальбом тюрьмы"
	icon_state = "album_blue"
	persistence_id = "prison"

/obj/item/storage/photo_album/personal
	icon_state = "album_green"
