/obj/structure/closet/secure_closet/quartermaster
	name = "шкафчик квартирмейстера"
	req_access = list(ACCESS_QM)
	icon_state = "qm"
	anchored = TRUE

/obj/structure/closet/secure_closet/quartermaster/PopulateContents()
	..()
	new /obj/item/key/forklift/cargo(src)
	new /obj/item/clothing/neck/cloak/qm(src)
	new /obj/item/storage/lockbox/medal/cargo(src)
	new /obj/item/clothing/under/rank/cargo/qm(src)
	new /obj/item/clothing/under/rank/cargo/qm/skirt(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/radio/headset/headset_cargo(src)
	new /obj/item/clothing/suit/fire/firefighter(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/megaphone/cargo(src)
	new /obj/item/tank/internals/emergency_oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/head/soft(src)
	new /obj/item/export_scanner(src)
	new /obj/item/door_remote/quartermaster(src)
	new /obj/item/circuitboard/machine/mechfab/cargo(src)
	new /obj/item/storage/photo_album/qm(src)
	new /obj/item/circuitboard/machine/ore_silo(src)
	new /obj/item/cargo_teleporter(src)
	new /obj/item/storage/backpack/duffelbag/mining_conscript(src)
	new /obj/item/circuitboard/machine/harvester(src) // :flushed:

/obj/structure/closet/secure_closet/quartermaster/populate_contents_immediate()
	. = ..()

	// Traitor steal objective
	new /obj/item/card/id/departmental_budget/car(src)
