///////////////////////////CSV Bearcat Ruin////////////////////////////

/datum/map_template/ruin/space/bearcat
	id = "bearcat"
	prefix = "white/hule/shuttles/bearcat/"
	suffix = "bearcat_dock.dmm"
	name = "CSV Bearcat Dock"

/datum/map_template/shuttle/bearcat
	name = "CSV Bearcat"
	prefix = "white/hule/shuttles/bearcat/"
	port_id = "bearcat"
	suffix = "template"

/datum/map_template/shuttle/bearcat/trading
	suffix = "trading"

///////////////////////////Areas//////////////////////////////////

/area/shuttle/bearcat
	name = "CSV Bearcat"
	requires_power = TRUE
	area_flags = HIDDEN_AREA | UNIQUE_AREA

/area/shuttle/bearcat/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/shuttle/bearcat/captain
	name = "Captain's Quarters"
	icon_state = "captain"

/area/shuttle/bearcat/dockingbay
	name = "Docking Bay"

/area/shuttle/bearcat/hallway
	name = "Hallway"
	icon_state = "hallC"

/area/shuttle/bearcat/saloon
	name = "Saloon"
	icon_state = "bar"

/area/shuttle/bearcat/bathroom
	name = "Bathroom"
	icon_state = "toilet"

/area/shuttle/bearcat/dorms
	name = "Dorms"
	icon_state = "Sleep"

/area/shuttle/bearcat/engines
	name = "Engine"

/area/shuttle/bearcat/cargo
	name = "Cargo Hold"
	icon_state = "cargo_bay"

/area/shuttle/bearcat/medbay
	name = "Medbay"
	icon_state = "medbay"

/area/shuttle/bearcat/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/shuttle/bearcat/washroom
	name = "Washroom"
	icon_state = "locker"

/area/shuttle/bearcat/toolstorage
	name = "Tool Storage"
	icon_state = "engi_storage"

/area/shuttle/bearcat/engineering
	name = "Engineering"
	icon_state = "engine"

/area/shuttle/bearcat/maint1
	name = "Maintenance"
	icon_state = "maintcentral"

/area/shuttle/bearcat/maint2
	name = "Maintenance"
	icon_state = "maintcentral"

///////////////////////////Nav Console///////////////////////////

/obj/machinery/computer/shuttle_flight/bearcat
	name = "CSV Bearcat console"
	shuttleId = "bearcat"
	possible_destinations = "bearcat_custom;bearcat_away"

/obj/docking_port/mobile/bearcat
	name = "CSV Bearcat"
	id = "bearcat"
	port_direction = SOUTH
	movement_force = list("KNOCKDOWN" = 10, "THROW" = 20)
	engine_coeff = 30
	velocity_multiplier = 0.1

/obj/docking_port/stationary/bearcat
	name = "CSV Bearcat Away"
	id = "bearcat_away"
	roundstart_template = /datum/map_template/shuttle/bearcat/trading
	width = 29
	dwidth = 6
	height = 44
	dheight = 30

///////////////////////////Spawners//////////////////////////////
/obj/effect/mob_spawn/human/bearcatcrew
	name = "CSV Bearcat cryogenics pod"
	desc = "An old cryogenics pod. Looks like it has not been touched for decades."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	mob_species = /datum/species/human
	assignedrole = "CSV Bearcat Crew"
	flavour_text = "<font size=3>You are a member of CSV Bearcat crew."

/obj/effect/mob_spawn/human/bearcatcrew/special(mob/living/carbon/human/H)
	. = ..()
	if(H?.wear_id)
		var/obj/item/card/id/icard = H.wear_id
		icard.add_wildcards(list(ACCESS_AWAY_GENERIC1, ACCESS_AWAY_SEC), mode=FORCE_ADD_ALL)

/obj/effect/mob_spawn/human/bearcatcrew/eng
	mob_name = "an engineer"
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id
	gloves = /obj/item/clothing/gloves/color/yellow

/obj/effect/mob_spawn/human/bearcatcrew/atmos
	mob_name = "an atmostech"
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id
	gloves = /obj/item/clothing/gloves/color/black

/obj/effect/mob_spawn/human/bearcatcrew/pilot
	mob_name = "a pilot"
	uniform = /obj/item/clothing/under/syndicate/camo
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id
