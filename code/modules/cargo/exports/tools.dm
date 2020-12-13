/datum/export/toolbox
	cost = CARGO_CRATE_VALUE * 0.02
	unit_name = "тулбокс"
	export_types = list(/obj/item/storage/toolbox)

// mechanical toolbox:	22cr
// emergency toolbox:	17-20cr
// electrical toolbox:	36cr
// robust: priceless

// Basic tools
/datum/export/screwdriver
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "отвёртка"
	export_types = list(/obj/item/screwdriver)
	include_subtypes = FALSE

/datum/export/wrench
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "гаечный ключ"
	export_types = list(/obj/item/wrench)

/datum/export/crowbar
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "ломик"
	export_types = list(/obj/item/crowbar)

/datum/export/wirecutters
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "пара"
	message = "кусачек"
	export_types = list(/obj/item/wirecutters)


/datum/export/weldingtool
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "сварочный инструмент"
	export_types = list(/obj/item/weldingtool)
	include_subtypes = FALSE

/datum/export/weldingtool/emergency
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "экстренный сварочный инструмент"
	export_types = list(/obj/item/weldingtool/mini)

/datum/export/weldingtool/industrial
	cost = CARGO_CRATE_VALUE * 0.05
	unit_name = "промышленный сварочный инструмент"
	export_types = list(/obj/item/weldingtool/largetank, /obj/item/weldingtool/hugetank)


/datum/export/extinguisher
	cost = CARGO_CRATE_VALUE * 0.075
	unit_name = "петушитель"
	export_types = list(/obj/item/extinguisher)
	include_subtypes = FALSE

/datum/export/extinguisher/mini
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "карманный петушитель"
	export_types = list(/obj/item/extinguisher/mini)


/datum/export/flashlight
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "фонарик"
	export_types = list(/obj/item/flashlight)
	include_subtypes = FALSE

/datum/export/flashlight/flare
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "флаер"
	export_types = list(/obj/item/flashlight/flare)

/datum/export/flashlight/seclite
	cost = CARGO_CRATE_VALUE * 0.05
	unit_name = "фонарик щитсеков"
	export_types = list(/obj/item/flashlight/seclite)


/datum/export/analyzer
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "анализатор"
	export_types = list(/obj/item/analyzer)

/datum/export/analyzer/t_scanner
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "t-ray сканер"
	export_types = list(/obj/item/t_scanner)


/datum/export/radio
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "радио"
	export_types = list(/obj/item/radio)
	exclude_types = list(/obj/item/radio/mech)

//Advanced/Power Tools.
/datum/export/weldingtool/experimental
	cost = CARGO_CRATE_VALUE * 0.45
	unit_name = "экспериментальный сварочный инструмент"
	export_types = list(/obj/item/weldingtool/experimental)

/datum/export/jawsoflife
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "челюсти жизни"
	export_types = list(/obj/item/crowbar/power)

/datum/export/handdrill
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "ручная дрель"
	export_types = list(/obj/item/screwdriver/power)

/datum/export/rld_mini
	cost = CARGO_CRATE_VALUE * 0.75
	unit_name = "мини РЛД"
	export_types = list(/obj/item/construction/rld/mini)

/datum/export/rsf
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "РСФ"
	export_types = list(/obj/item/rsf)

/datum/export/rcd
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "РЦД"
	export_types = list(/obj/item/construction/rcd)

/datum/export/rcd_ammo
	cost = CARGO_CRATE_VALUE * 0.3
	unit_name = "картридж сжатого вещества"
	export_types = list(/obj/item/rcd_ammo)

/datum/export/rpd
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "РПД"
	export_types = list(/obj/item/pipe_dispenser)

/datum/export/singulo //failsafe in case someone decides to ship a live singularity to CentCom without the corresponding bounty
	cost = 1
	unit_name = "сингулярность"
	export_types = list(/obj/singularity)
	include_subtypes = FALSE

/datum/export/singulo/total_printout(datum/export_report/ex, notes = TRUE)
	. = ..()
	if(. && notes)
		. += " ОШИБКА: Обнаружен недействительный объект."

/datum/export/singulo/tesla //see above
	unit_name = "энергетический шар"
	export_types = list(/obj/singularity/energy_ball)

/datum/export/singulo/tesla/total_printout(datum/export_report/ex, notes = TRUE)
	. = ..()
	if(. && notes)
		. += " Ошибка: Обнаружена незапланированная поставка энергетического шара."
//artisanal exports for the mom and pops
/datum/export/soap
	cost = CARGO_CRATE_VALUE * 0.375
	unit_name = "soap"
	export_types = list(/obj/item/soap)

/datum/export/soap/homemade
	cost = CARGO_CRATE_VALUE * 0.15
	unit_name = "artisanal soap"
	export_types = list(/obj/item/soap/homemade)

/datum/export/soap/omega
	cost = CARGO_CRATE_VALUE * 14
	unit_name = "omega soap"
	export_types = list(/obj/item/soap/omega)

/datum/export/candle
	cost = CARGO_CRATE_VALUE * 0.125
	unit_name = "candle"
	export_types = list(/obj/item/candle)
