/obj/structure/alien/weeds/xen
	name = "трава Зена"
	desc = "Похожа на виноградную лозу."
	color = "#ac3b06"

/obj/structure/spacevine/xen
	name = "лоза Зена"
	color = "#ac3b06"

/obj/structure/spacevine/xen/Initialize(mapload)
	. = ..()
	add_atom_colour("#ac3b06", FIXED_COLOUR_PRIORITY)

/obj/structure/spacevine/xen/thick
	name = "толстая органическая лоза Зена"
	color = "#ac3b06"
	opacity = TRUE

/obj/structure/mineral_door/xen
	name = "органическая дверь Зена"
	color = "#ff8d58"
	icon = 'white/valtos/icons/black_mesa/xen_door.dmi'
	icon_state = "resin"
	openSound = 'white/valtos/sounds/black_mesa/xen_door.ogg'
	closeSound = 'white/valtos/sounds/black_mesa/xen_door.ogg'

/obj/machinery/door/keycard/xen
	name = "герметичая органическая дверь Зена"
	desc = "На удивление прочная, органично выглядящая дверь."
	icon = 'white/valtos/icons/black_mesa/xen_door.dmi'
	icon_state = "resin"
	puzzle_id = "xen"

/obj/item/keycard/xen
	name = "органический ключ Зена"
	desc = "Открывает что-то явно органическое."
	color = "#ac3b06"
	puzzle_id = "xen"

/obj/machinery/conveyor/inverted/auto
	processing_flags = START_PROCESSING_ON_INIT

/obj/machinery/conveyor/inverted/auto/Initialize(mapload, newdir)
	. = ..()
	set_operating(TRUE)

/obj/machinery/conveyor/inverted/auto/update()
	. = ..()
	if(.)
		set_operating(TRUE)

/obj/structure/marker_beacon/green
	picked_color = "Lime"
	// set icon_state to make it clear for mappers
	icon_state = "markerlime-on"

/obj/structure/pod
	name = "supply pod"
	desc = "Someone must have sent this a long way."
	icon = 'white/valtos/icons/black_mesa/structures.dmi'
	icon_state = "pod"
	pixel_x = SUPPLYPOD_X_OFFSET
	anchored = TRUE

