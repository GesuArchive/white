/**
 * Command
 */
/obj/item/computer_disk/command
	icon_state = "datadisk7"
	max_capacity = 256
	///Static list of programss ALL command tablets have.
	var/static/list/datum/computer_file/command_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/science,
		/datum/computer_file/program/status,
		/datum/computer_file/program/budgetorders,
	)

/obj/item/computer_disk/command/Initialize(mapload)
	. = ..()
	for(var/programs in command_programs)
		var/datum/computer_file/program/program_type = new programs
		add_file(program_type)

/obj/item/computer_disk/command/captain
	name = "диск с программами капитана"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 256 ГБ данных."
	icon_state = "datadisk10"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/phys_scanner/all,
		/datum/computer_file/program/radar/lifeline,
		/datum/computer_file/program/surgmaster,
		/datum/computer_file/program/signal_commander,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/borg_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/minnet,
		/datum/computer_file/program/radar/fission360,
		/datum/computer_file/program/secureye,
	)

/obj/item/computer_disk/command/cmo
	name = "диск с программами СМО"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 256 ГБ данных."
	starting_programs = list(
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/phys_scanner/all,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/radar/lifeline,
		/datum/computer_file/program/surgmaster,
	)

/obj/item/computer_disk/command/rd
	name = "диск с программами РД"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 256 ГБ данных."
	starting_programs = list(
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/phys_scanner/all,
		/datum/computer_file/program/signal_commander,
		/datum/computer_file/program/borg_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/minnet,
		/datum/computer_file/program/surgmaster,
	)

/obj/item/computer_disk/command/hos
	name = "диск с программами ХОСа"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 256 ГБ данных."
	icon_state = "datadisk9"
	starting_programs = list(
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/radar/fission360,
		/datum/computer_file/program/radar/lifeline,
		/datum/computer_file/program/phys_scanner/medical,
		/datum/computer_file/program/radar/lifeline,
		/datum/computer_file/program/secureye,
	)

/obj/item/computer_disk/command/hop
	name = "диск с программами ХОПа"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 256 ГБ данных."
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/job_management,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/job_management,
	)

/obj/item/computer_disk/command/ce
	name = "диск с программами СЕ"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 256 ГБ данных."
	starting_programs = list(
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/ntnetmonitor,
	)

/**
 * Security
 */
/obj/item/computer_disk/security
	name = "диск с программами охраны"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 64 ГБ данных."
	icon_state = "datadisk9"
	max_capacity = 64
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/phys_scanner/medical,
		/datum/computer_file/program/radar/lifeline,
		/datum/computer_file/program/secureye,
	)

/**
 * Medical
 */
/obj/item/computer_disk/medical
	name = "диск с программами врача"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 64 ГБ данных."
	icon_state = "datadisk7"
	max_capacity = 64
	starting_programs = list(
		/datum/computer_file/program/phys_scanner/medical,
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/surgmaster,
		/datum/computer_file/program/radar/lifeline,
	)

/obj/item/computer_disk/chemistry
	name = "диск с программами химика"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 64 ГБ данных."
	icon_state = "datadisk5"
	max_capacity = 64
	starting_programs = list(
		/datum/computer_file/program/phys_scanner/chemistry,
		/datum/computer_file/program/records/medical,
	)

/**
 * Supply
 */
/obj/item/computer_disk/quartermaster
	name = "диск с программами карго"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 64 ГБ данных."
	icon_state = "cargodisk"
	max_capacity = 64
	starting_programs = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/shipping,
		/datum/computer_file/program/skill_tracker,
	)

/**
 * Science
 */
/obj/item/computer_disk/ordnance
	name = "диск с программами ученых"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 64 ГБ данных."
	icon_state = "datadisk5"
	max_capacity = 64
	starting_programs = list(
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/signal_commander,
		/datum/computer_file/program/minnet,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/borg_monitor,
		/datum/computer_file/program/surgmaster,
	)

/**
 * Engineering
 */
/obj/item/computer_disk/engineering
	name = "диск с программами инженеров"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 64 ГБ данных."
	icon_state = "datadisk6"
	max_capacity = 64
	starting_programs = list(
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/ntnetmonitor,
		/datum/computer_file/program/atmosscan,
	)

/obj/item/computer_disk/atmos
	name = "диск с программами атмотехника"
	desc = "Съёмный диск, используемый для хранения данных. Хранит в себе список программ положенных по служебному положению. Вмещает до 64 ГБ данных."
	icon_state = "datadisk6"
	max_capacity = 64
	starting_programs = list(
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/alarm_monitor,
	)
