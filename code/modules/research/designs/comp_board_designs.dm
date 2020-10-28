///////////////////Computer Boards///////////////////////////////////

/datum/design/board
	name = "Дизайн консоли ( NULL ENTRY )"
	desc = "I promise this doesn't give you syndicate goodies!"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 1000)

/datum/design/board/arcade_battle
	name = "Дизайн консоли (Battle Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "arcade_battle"
	build_path = /obj/item/circuitboard/computer/arcade/battle
	category = list("Консоли")


/datum/design/board/orion_trail
	name = "Дизайн консоли (Orion Trail Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new Orion Trail machine."
	id = "arcade_orion"
	build_path = /obj/item/circuitboard/computer/arcade/orion_trail
	category = list("Консоли")


/datum/design/board/seccamera
	name = "Дизайн консоли (Security Camera)"
	desc = "Allows for the construction of circuit boards used to build security camera computers."
	id = "seccamera"
	build_path = /obj/item/circuitboard/computer/security
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/rdcamera
	name = "Дизайн консоли (Research Monitor)"
	desc = "Allows for the construction of circuit boards used to build research camera computers."
	id = "rdcamera"
	build_path = /obj/item/circuitboard/computer/research
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/xenobiocamera
	name = "Дизайн консоли (Xenobiology Console)"
	desc = "Allows for the construction of circuit boards used to build xenobiology camera computers."
	id = "xenobioconsole"
	build_path = /obj/item/circuitboard/computer/xenobiology
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/aiupload
	name = "Дизайн консоли (AI Upload)"
	desc = "Allows for the construction of circuit boards used to build an AI Upload Console."
	id = "aiupload"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/circuitboard/computer/aiupload
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/borgupload
	name = "Дизайн консоли (Cyborg Upload)"
	desc = "Allows for the construction of circuit boards used to build a Cyborg Upload Console."
	id = "borgupload"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/circuitboard/computer/borgupload
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/med_data
	name = "Дизайн консоли (Medical Records)"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	id = "med_data"
	build_path = /obj/item/circuitboard/computer/med_data
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/operating
	name = "Дизайн консоли (Operating Computer)"
	desc = "Allows for the construction of circuit boards used to build an operating computer console."
	id = "operating"
	build_path = /obj/item/circuitboard/computer/operating
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/pandemic
	name = "Дизайн консоли (PanD.E.M.I.C. 2200)"
	desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
	id = "pandemic"
	build_path = /obj/item/circuitboard/computer/pandemic
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/scan_console
	name = "Дизайн консоли (DNA Console)"
	desc = "Allows for the construction of circuit boards used to build a new DNA console."
	id = "scan_console"
	build_path = /obj/item/circuitboard/computer/scan_consolenew
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/comconsole
	name = "Дизайн консоли (Communications)"
	desc = "Allows for the construction of circuit boards used to build a communications console."
	id = "comconsole"
	build_path = /obj/item/circuitboard/computer/communications
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SECURITY				//Honestly should have a bridge techfab for this sometime.

/datum/design/board/idcardconsole
	name = "Дизайн консоли (ID Console)"
	desc = "Allows for the construction of circuit boards used to build an ID computer."
	id = "idcardconsole"
	build_path = /obj/item/circuitboard/computer/card
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SECURITY				//Honestly should have a bridge techfab for this sometime.

/datum/design/board/crewconsole
	name = "Дизайн консоли (Crew monitoring computer)"
	desc = "Allows for the construction of circuit boards used to build a Crew monitoring computer."
	id = "crewconsole"
	build_path = /obj/item/circuitboard/computer/crew
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/board/secdata
	name = "Дизайн консоли (Security Records Console)"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	id = "secdata"
	build_path = /obj/item/circuitboard/computer/secure_data
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/atmosalerts
	name = "Дизайн консоли (Atmosphere Alert)"
	desc = "Allows for the construction of circuit boards used to build an atmosphere alert console."
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/computer/atmos_alert
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/atmos_control
	name = "Дизайн консоли (Atmospheric Monitor)"
	desc = "Allows for the construction of circuit boards used to build an Atmospheric Monitor."
	id = "atmos_control"
	build_path = /obj/item/circuitboard/computer/atmos_control
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/robocontrol
	name = "Дизайн консоли (Robotics Control Console)"
	desc = "Allows for the construction of circuit boards used to build a Robotics Control console."
	id = "robocontrol"
	build_path = /obj/item/circuitboard/computer/robotics
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/slot_machine
	name = "Дизайн консоли (Slot Machine)"
	desc = "Allows for the construction of circuit boards used to build a new slot machine."
	id = "slotmachine"
	build_path = /obj/item/circuitboard/computer/slot_machine
	category = list("Консоли")


/datum/design/board/powermonitor
	name = "Дизайн консоли (Power Monitor)"
	desc = "Allows for the construction of circuit boards used to build a new power monitor."
	id = "powermonitor"
	build_path = /obj/item/circuitboard/computer/powermonitor
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/solarcontrol
	name = "Дизайн консоли (Solar Control)"
	desc = "Allows for the construction of circuit boards used to build a solar control console."
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/computer/solar_control
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/prisonmanage
	name = "Дизайн консоли (Prisoner Management Console)"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/computer/prisoner
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/mechacontrol
	name = "Дизайн консоли (Exosuit Control Console)"
	desc = "Allows for the construction of circuit boards used to build an exosuit control console."
	id = "mechacontrol"
	build_path = /obj/item/circuitboard/computer/mecha_control
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/mechapower
	name = "Дизайн консоли (Mech Bay Power Control Console)"
	desc = "Allows for the construction of circuit boards used to build a mech bay power control console."
	id = "mechapower"
	build_path = /obj/item/circuitboard/computer/mech_bay_power_console
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/rdconsole
	name = "Дизайн консоли (R&D Console)"
	desc = "Allows for the construction of circuit boards used to build a new R&D console."
	id = "rdconsole"
	build_path = /obj/item/circuitboard/computer/rdconsole
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/cargo
	name = "Дизайн консоли (Supply Console)"
	desc = "Allows for the construction of circuit boards used to build a Supply Console."
	id = "cargo"
	build_path = /obj/item/circuitboard/computer/cargo
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/cargorequest
	name = "Дизайн консоли (Supply Request Console)"
	desc = "Allows for the construction of circuit boards used to build a Supply Request Console."
	id = "cargorequest"
	build_path = /obj/item/circuitboard/computer/cargo/request
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/board/mining
	name = "Дизайн консоли (Outpost Status Display)"
	desc = "Allows for the construction of circuit boards used to build an outpost status display console."
	id = "mining"
	build_path = /obj/item/circuitboard/computer/mining
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/comm_monitor
	name = "Дизайн консоли (Telecommunications Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunications monitor."
	id = "comm_monitor"
	build_path = /obj/item/circuitboard/computer/comm_monitor
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/comm_server
	name = "Дизайн консоли (Telecommunications Server Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunication server browser and monitor."
	id = "comm_server"
	build_path = /obj/item/circuitboard/computer/comm_server
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/message_monitor
	name = "Дизайн консоли (Messaging Monitor Console)"
	desc = "Allows for the construction of circuit boards used to build a messaging monitor console."
	id = "message_monitor"
	build_path = /obj/item/circuitboard/computer/message_monitor
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/aifixer
	name = "Дизайн консоли (AI Integrity Restorer)"
	desc = "Allows for the construction of circuit boards used to build an AI Integrity Restorer."
	id = "aifixer"
	build_path = /obj/item/circuitboard/computer/aifixer
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/libraryconsole
	name = "Дизайн консоли (Library Console)"
	desc = "Allows for the construction of circuit boards used to build a new library console."
	id = "libraryconsole"
	build_path = /obj/item/circuitboard/computer/libraryconsole
	category = list("Консоли")


/datum/design/board/apc_control
	name = "Дизайн консоли (APC Control)"
	desc = "Allows for the construction of circuit boards used to build a new APC control console."
	id = "apc_control"
	build_path = /obj/item/circuitboard/computer/apc_control
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/nanite_chamber_control
	name = "Дизайн консоли (Nanite Chamber Control)"
	desc = "Allows for the construction of circuit boards used to build a new nanite chamber control console."
	id = "nanite_chamber_control"
	build_path = /obj/item/circuitboard/computer/nanite_chamber_control
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/nanite_cloud_control
	name = "Дизайн консоли (Nanite Cloud Control)"
	desc = "Allows for the construction of circuit boards used to build a new nanite cloud control console."
	id = "nanite_cloud_control"
	build_path = /obj/item/circuitboard/computer/nanite_cloud_controller
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/board/advanced_camera
	name = "Дизайн консоли (Advanced Camera Console)"
	desc = "Allows for the construction of circuit boards used to build advanced camera consoles."
	id = "advanced_camera"
	build_path = /obj/item/circuitboard/computer/advanced_camera
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/board/bountypad_control
	name = "Дизайн консоли (Civilian Bounty Pad Control)"
	desc = "Allows for the construction of circuit boards used to build a new civilian bounty pad console."
	id = "bounty_pad_control"
	build_path = /obj/item/circuitboard/computer/bountypad
	category = list("Консоли")

/datum/design/board/price_controller
	name = "Дизайн консоли (Контроллер цен)"
	desc = "Позволяет манипулировать ценами на станции."
	id = "price_controller"
	build_path = /obj/item/circuitboard/computer/price_controller
	category = list("Консоли")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO
