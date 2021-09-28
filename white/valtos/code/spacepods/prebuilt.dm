/obj/spacepod/prebuilt
	icon = 'white/valtos/icons/spacepods/goon/2x2.dmi'
	icon_state = "pod_civ"
	var/cell_type = /obj/item/stock_parts/cell/high/plus
	var/armor_type = /obj/item/pod_parts/armor
	var/internal_tank_type = /obj/machinery/portable_atmospherics/canister/air
	var/equipment_types = list()
	construction_state = SPACEPOD_ARMOR_WELDED

/obj/spacepod/prebuilt/Initialize()
	..()
	add_armor(new armor_type(src))
	if(cell_type)
		cell = new cell_type(src)
	if(internal_tank_type)
		internal_tank = new internal_tank_type(src)
	for(var/equip in equipment_types)
		var/obj/item/spacepod_equipment/SE = new equip(src)
		SE.on_install(src)
	return INITIALIZE_HINT_NORMAL // ???

/obj/spacepod/prebuilt/sec
	name = "security space pod"
	icon_state = "pod_mil"
	locked = TRUE
	armor_type = /obj/item/pod_parts/armor/security
	equipment_types = list(/obj/item/spacepod_equipment/weaponry/disabler,
		/obj/item/spacepod_equipment/lock/keyed/sec,
		/obj/item/spacepod_equipment/tracker,
		/obj/item/spacepod_equipment/cargo/chair)

// adminbus spacepod for jousting events
/obj/spacepod/prebuilt/jousting
	name = "jousting space pod"
	icon_state = "pod_mil"
	armor_type = /obj/item/pod_parts/armor/security
	cell_type = /obj/item/stock_parts/cell/infinite
	equipment_types = list(/obj/item/spacepod_equipment/weaponry/laser,
		/obj/item/spacepod_equipment/cargo/chair,
		/obj/item/spacepod_equipment/cargo/chair)

/obj/spacepod/prebuilt/jousting/red
	icon_state = "pod_synd"
	armor_type = /obj/item/pod_parts/armor/security/red

/obj/spacepod/random
	icon = 'white/valtos/icons/spacepods/goon/2x2.dmi'
	icon_state = "pod_civ"
	construction_state = SPACEPOD_ARMOR_WELDED

/obj/spacepod/random/Initialize()
	..()
	var/armor_type = pick(/obj/item/pod_parts/armor,
		/obj/item/pod_parts/armor/syndicate,
		/obj/item/pod_parts/armor/black,
		/obj/item/pod_parts/armor/gold,
		/obj/item/pod_parts/armor/industrial,
		/obj/item/pod_parts/armor/security)
	add_armor(new armor_type(src))
	cell = new /obj/item/stock_parts/cell/high/empty(src)
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	velocity_x = rand(-15, 15)
	velocity_y = rand(-15, 15)
	obj_integrity = rand(100, max_integrity)
	brakes = FALSE

/obj/spacepod/prebuilt/ship
	name = "корабль"
	desc = "Ох..."
	icon = 'white/valtos/icons/spacepods/2x3.dmi'
	icon_state = "ship_civ"
	overlay_file = 'white/valtos/icons/spacepods/2x3.dmi'
	bound_x = 64
	bound_y = 96
	armor_type = /obj/item/pod_parts/armor/ship
	cell_type = /obj/item/stock_parts/cell/infinite
	equipment_types = list(/obj/item/spacepod_equipment/weaponry/laser,
		/obj/item/spacepod_equipment/cargo/chair,
		/obj/item/spacepod_equipment/cargo/chair)

/obj/spacepod/prebuilt/yohei
	name = "проникновенец"
	icon_state = "pod_mil"
	armor_type = /obj/item/pod_parts/armor/security
	cell_type = /obj/item/stock_parts/cell/high
	equipment_types = list(/obj/item/spacepod_equipment/weaponry/burst_disabler,
		/obj/item/spacepod_equipment/cargo/large,
		/obj/item/spacepod_equipment/lock/keyed/yohei,
		/obj/item/spacepod_equipment/cargo/chair,
		/obj/item/spacepod_equipment/teleport)
