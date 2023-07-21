/datum/export/toolbox
	cost = CARGO_CRATE_VALUE * 0.02
	unit_name = "ящик с инструментами"
	export_types = list(/obj/item/storage/toolbox)

// mechanical toolbox:	22cr
// emergency toolbox:	17-20cr
// electrical toolbox:	36cr
// robust: priceless

// Basic tools
/datum/export/screwdriver
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "Отвёртка"
	export_types = list(/obj/item/screwdriver)
	include_subtypes = FALSE

/datum/export/wrench
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "Гаечный ключ"
	export_types = list(/obj/item/wrench)

/datum/export/crowbar
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "Карманный лом"
	export_types = list(/obj/item/crowbar)

/datum/export/wirecutters
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "Кусачки"
	export_types = list(/obj/item/wirecutters)


/datum/export/weldingtool
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Сварочный аппарат"
	export_types = list(/obj/item/weldingtool)
	include_subtypes = FALSE

/datum/export/weldingtool/emergency
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "Аварийный сварочный аппарат"
	export_types = list(/obj/item/weldingtool/mini)

/datum/export/weldingtool/industrial
	cost = CARGO_CRATE_VALUE * 0.05
	unit_name = "Индустриальный сварочный аппарат"
	export_types = list(/obj/item/weldingtool/largetank, /obj/item/weldingtool/hugetank)


/datum/export/extinguisher
	cost = CARGO_CRATE_VALUE * 0.075
	unit_name = "Огнетушитель"
	export_types = list(/obj/item/extinguisher)
	include_subtypes = FALSE

/datum/export/extinguisher/mini
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "Карманный огнетушитель"
	export_types = list(/obj/item/extinguisher/mini)


/datum/export/flashlight
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Фонарик"
	export_types = list(/obj/item/flashlight)
	include_subtypes = FALSE

/datum/export/flashlight/flare
	cost = CARGO_CRATE_VALUE * 0.01
	unit_name = "Сигнальная шашка"
	export_types = list(/obj/item/flashlight/flare)

/datum/export/flashlight/seclite
	cost = CARGO_CRATE_VALUE * 0.05
	unit_name = "Крепкий фонарик"
	export_types = list(/obj/item/flashlight/seclite)


/datum/export/analyzer
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Газоанализатор"
	export_types = list(/obj/item/analyzer)

/datum/export/analyzer/t_scanner
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Терагерцовый сканер"
	export_types = list(/obj/item/t_scanner)


/datum/export/radio
	cost = CARGO_CRATE_VALUE * 0.025
	unit_name = "Рация"
	export_types = list(/obj/item/radio)
	exclude_types = list(/obj/item/radio/mech)

//Advanced/Power Tools.
/datum/export/weldingtool/experimental
	cost = CARGO_CRATE_VALUE * 0.45
	unit_name = "Экспериментальный сварочный аппарат"
	export_types = list(/obj/item/weldingtool/experimental)

/datum/export/jawsoflife
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "Гидравлические ножницы"
	export_types = list(/obj/item/crowbar/power)

/datum/export/handdrill
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "Шуруповерт"
	export_types = list(/obj/item/screwdriver/power)

/datum/export/rld_mini
	cost = CARGO_CRATE_VALUE * 0.75
	unit_name = "РЛД - Светопостановщик"
	export_types = list(/obj/item/construction/rld)

/datum/export/rsf
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "РСФ - Сервировщик"
	export_types = list(/obj/item/rsf)

/datum/export/rcd
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "РЦД"
	export_types = list(/obj/item/construction/rcd)

/datum/export/rcd_ammo
	cost = CARGO_CRATE_VALUE * 0.3
	unit_name = "Картридж спрессованной материи"
	export_types = list(/obj/item/rcd_ammo)

/datum/export/rpd
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "РПД"
	export_types = list(/obj/item/pipe_dispenser)

/datum/export/singulo //failsafe in case someone decides to ship a live singularity to CentCom without the corresponding bounty
	cost = CARGO_CRATE_VALUE * 5
	unit_name = "Гравитационная сингулярность"
	export_types = list(/obj/singularity)
	include_subtypes = FALSE

/datum/export/singulo/total_printout(datum/export_report/ex, notes = TRUE)
	. = ..()
	if(. && notes)
		. += " ОШИБКА: Обнаружен недействительный объект."

/datum/export/singulo/tesla //see above
	unit_name = "Шаровая молния"
	export_types = list(/obj/energy_ball)

/datum/export/singulo/tesla/total_printout(datum/export_report/ex, notes = TRUE)
	. = ..()
	if(. && notes)
		. += " Ошибка: Обнаружена незапланированная поставка энергетического шара."
//artisanal exports for the mom and pops
/datum/export/soap
	cost = CARGO_CRATE_VALUE * 0.375
	unit_name = "Мыло"
	export_types = list(/obj/item/soap)

/datum/export/soap/homemade
	cost = CARGO_CRATE_VALUE * 0.15
	unit_name = "Самодельное мыло"
	export_types = list(/obj/item/soap/homemade)

/datum/export/soap/omega
	cost = CARGO_CRATE_VALUE * 14
	unit_name = "Омега мыло"
	export_types = list(/obj/item/soap/omega)

/datum/export/candle
	cost = CARGO_CRATE_VALUE * 0.125
	unit_name = "Красная свеча"
	export_types = list(/obj/item/candle)
