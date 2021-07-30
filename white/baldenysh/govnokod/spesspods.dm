/obj/spacepod
	var/should_do_rotate_anim = TRUE

/obj/spacepod/multidir
	should_do_rotate_anim = FALSE

/obj/spacepod/multidir/update_icon()
	. = ..()
	dir = angle2dir(angle)

/obj/spacepod/multidir/prebuilt
	icon = 'white/valtos/icons/spacepods/goon/2x2.dmi'
	icon_state = "pod_civ"
	var/cell_type = /obj/item/stock_parts/cell/high/plus
	var/armor_type = /obj/item/pod_parts/armor
	var/internal_tank_type = /obj/machinery/portable_atmospherics/canister/air
	var/equipment_types = list()
	construction_state = SPACEPOD_ARMOR_WELDED

/obj/spacepod/multidir/prebuilt/Initialize()
	..()
	add_armor(new armor_type(src))
	if(cell_type)
		cell = new cell_type(src)
	if(internal_tank_type)
		internal_tank = new internal_tank_type(src)
	for(var/equip in equipment_types)
		var/obj/item/spacepod_equipment/SE = new equip(src)
		SE.on_install(src)

////////////////////////////////////////////////////////////////////////////////////test

/obj/spacepod/multidir/prebuilt/test
	name = "мехокарась"
	desc = "амонг"
	icon = 'white/baldenysh/icons/mob/karasik.dmi'
	icon_state = "karasik"
	overlay_file = 'white/baldenysh/icons/mob/karasik.dmi'
	bound_x = 64
	bound_y = 32
	movement_type = PHASING

	armor_type = /obj/item/pod_parts/armor/multidir_test
	cell_type = /obj/item/stock_parts/cell/infinite
	equipment_types = list(/obj/item/spacepod_equipment/weaponry/laser,
		/obj/item/spacepod_equipment/cargo/chair,
		/obj/item/spacepod_equipment/cargo/chair)

/obj/item/pod_parts/armor/multidir_test
	name = "мехокарась"
	icon_state = "pod_armor_mil"
	desc = "Ого..."
	pod_icon = 'white/baldenysh/icons/mob/karasik.dmi'
	pod_icon_state = "karasik"
	pod_desc = "Хых..."
	pod_integrity = 650

////////////////////////////////////////////////////////////////////////////////////actual praikol


