
#define GASMINER_POWER_NONE 0
#define GASMINER_POWER_STATIC 1
#define GASMINER_POWER_MOLES 2	//Scaled from here on down.
#define GASMINER_POWER_KPA 3
#define GASMINER_POWER_FULLSCALE 4

/obj/machinery/atmospherics/miner
	name = "газодобытчик"
	desc = "Газы, добываемые газовым гигантом внизу (вверху?) выходят через это массивное отверстие."
	icon = 'icons/obj/atmospherics/components/miners.dmi'
	icon_state = "miner"
	density = FALSE
	resistance_flags = INDESTRUCTIBLE|ACID_PROOF|FIRE_PROOF
	var/spawn_id = null
	var/spawn_temp = T20C
	/// Moles of gas to spawn per second
	var/spawn_mol = MOLES_CELLSTANDARD * 5
	var/max_ext_mol = INFINITY
	var/max_ext_kpa = 6500
	var/overlay_color = "#FFFFFF"
	var/active = TRUE
	var/power_draw = 0
	var/power_draw_static = 9000
	var/power_draw_dynamic_mol_coeff = 5	//DO NOT USE DYNAMIC SETTINGS UNTIL SOMEONE MAKES A USER INTERFACE/CONTROLLER FOR THIS!
	var/power_draw_dynamic_kpa_coeff = 0.5
	var/broken = FALSE
	var/broken_message = "АШЫПКА"
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 1.5
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 2

/obj/machinery/atmospherics/miner/Initialize(mapload)
	. = ..()
	set_active(active)				//Force overlay update.

/obj/machinery/atmospherics/miner/examine(mob/user)
	. = ..()
	if(broken)
		. += {"<hr>Его отладка говорит "[broken_message]"."}

/obj/machinery/atmospherics/miner/proc/check_operation()
	if(!active)
		return FALSE
	var/turf/T = get_turf(src)
	if(!isopenturf(T))
		broken_message = span_boldnotice("ВЕНТИЛЯЦИЯ ЗАБЛОКИРОВАНА")
		set_broken(TRUE)
		return FALSE
	var/turf/open/OT = T
	if(OT.planetary_atmos)
		broken_message = span_boldwarning("УСТРОЙСТВО НЕ МОЖЕТ РАБОТАТЬ В ОТКРЫТОМ ПРОСТРАНСТВЕ")
		set_broken(TRUE)
		return FALSE
	if(isspaceturf(T))
		broken_message = span_boldnotice("ГАЗ УХОДИТ В КОСМОС")
		set_broken(TRUE)
		return FALSE
	var/datum/gas_mixture/G = OT.return_air()
	if(G.return_pressure() > (max_ext_kpa - ((spawn_mol*spawn_temp*R_IDEAL_GAS_EQUATION)/(CELL_VOLUME))))
		broken_message = span_boldwarning("ВНЕШНЕЕ ДАВЛЕНИЕ КРИТИЧЕСКОЕ")
		set_broken(TRUE)
		return FALSE
	if(G.total_moles() > max_ext_mol)
		broken_message = span_boldwarning("ВНЕШНЯЯ КОНЦЕНТРАЦИЯ ГАЗА КРИТИЧЕСКАЯ")
		set_broken(TRUE)
		return FALSE
	if(broken)
		set_broken(FALSE)
		broken_message = ""
	return TRUE

/obj/machinery/atmospherics/miner/proc/set_active(setting)
	if(active != setting)
		active = setting
		update_icon()

/obj/machinery/atmospherics/miner/proc/set_broken(setting)
	if(broken != setting)
		broken = setting
		update_icon()

/obj/machinery/atmospherics/miner/proc/update_power()
	if(!active)
		active_power_usage = idle_power_usage
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/G = T.return_air()
	var/P = G.return_pressure()
	switch(power_draw)
		if(GASMINER_POWER_NONE)
			update_use_power(ACTIVE_POWER_USE, 0)
		if(GASMINER_POWER_STATIC)
			update_use_power(ACTIVE_POWER_USE, power_draw_static)
		if(GASMINER_POWER_MOLES)
			update_use_power(ACTIVE_POWER_USE, spawn_mol * power_draw_dynamic_mol_coeff)
		if(GASMINER_POWER_KPA)
			update_use_power(ACTIVE_POWER_USE, P * power_draw_dynamic_kpa_coeff)
		if(GASMINER_POWER_FULLSCALE)
			update_use_power(ACTIVE_POWER_USE, (spawn_mol * power_draw_dynamic_mol_coeff) + (P * power_draw_dynamic_kpa_coeff))

/obj/machinery/atmospherics/miner/proc/do_use_power(amount)
	var/turf/T = get_turf(src)
	if(T && istype(T))
		var/obj/structure/cable/C = T.get_cable_node() //check if we have a node cable on the machine turf, the first found is picked
		if(C && C.powernet && (C.powernet.avail > amount))
			C.powernet.load += amount
			return TRUE
	if(powered())
		use_power(amount)
		return TRUE
	return FALSE

/obj/machinery/atmospherics/miner/update_overlays()
	. = ..()
	if(broken)
		. += "broken"
	else if(active)
		var/mutable_appearance/on_overlay = mutable_appearance(icon, "on")
		on_overlay.color = overlay_color
		. += on_overlay

/obj/machinery/atmospherics/miner/process(delta_time)
	update_power()
	check_operation()
	if(active && !broken)
		if(isnull(spawn_id))
			return FALSE
		if(do_use_power(active_power_usage))
			mine_gas(delta_time)

/obj/machinery/atmospherics/miner/proc/mine_gas(delta_time = 2)
	var/turf/open/O = get_turf(src)
	if(!isopenturf(O))
		return FALSE
	var/datum/gas_mixture/merger = new
	merger.set_moles(spawn_id, spawn_mol * delta_time)
	merger.set_temperature(spawn_temp)
	O.assume_air(merger)
	O.air_update_turf(TRUE)

/obj/machinery/atmospherics/miner/attack_ai(mob/living/silicon/user)
	if(broken)
		to_chat(user, "[capitalize(src.name)] неисправен. Отладка: [broken_message]")
	..()

/obj/machinery/atmospherics/miner/n2o
	name = "газодобытчик N2O"
	overlay_color = "#FFCCCC"
	spawn_id = GAS_NITROUS

/obj/machinery/atmospherics/miner/n2o/clown
	name = "газодобытчик N2O"
	overlay_color = "#FFCCCC"
	spawn_id = GAS_NITROUS

/obj/machinery/atmospherics/miner/nitrogen
	name = "газодобытчик N2"
	overlay_color = "#CCFFCC"
	spawn_id = GAS_N2

/obj/machinery/atmospherics/miner/oxygen
	name = "газодобытчик O2"
	overlay_color = "#007FFF"
	spawn_id = GAS_O2

/obj/machinery/atmospherics/miner/toxins
	name = "газодобытчик Плазмы"
	overlay_color = "#FF0000"
	spawn_id = GAS_PLASMA

/obj/machinery/atmospherics/miner/carbon_dioxide
	name = "газодобытчик CO2"
	overlay_color = "#CDCDCD"
	spawn_id = GAS_CO2

/obj/machinery/atmospherics/miner/bz
	name = "газодобытчик БЗ"
	overlay_color = "#FAFF00"
	spawn_id = GAS_BZ

/obj/machinery/atmospherics/miner/water_vapor
	name = "газодобытчик Пара"
	overlay_color = "#99928E"
	spawn_id = GAS_H2O

/obj/machinery/atmospherics/miner/freon
	name = "газодобытчик Фреона"
	overlay_color = "#61edff"
	spawn_id = GAS_FREON

/obj/machinery/atmospherics/miner/halon
	name = "газодобытчик Галона"
	overlay_color = "#5f0085"
	spawn_id = GAS_HALON

/obj/machinery/atmospherics/miner/healium
	name = "газодобытчик Хилиума"
	overlay_color = "#da4646"
	spawn_id = GAS_HEALIUM

/obj/machinery/atmospherics/miner/hydrogen
	name = "газодобытчик Водорода"
	overlay_color = "#ffffff"
	spawn_id = GAS_HYDROGEN

/obj/machinery/atmospherics/miner/hypernoblium
	name = "газодобытчик Гипер-ноблия"
	overlay_color = "#00f7ff"
	spawn_id = GAS_HYPERNOB

/obj/machinery/atmospherics/miner/miasma
	name = "газодобытчик Миазмы"
	overlay_color = "#395806"
	spawn_id = GAS_MIASMA

/obj/machinery/atmospherics/miner/nitryl
	name = "газодобытчик Нитрила"
	overlay_color = "#752b00"
	spawn_id = GAS_NITRYL

/obj/machinery/atmospherics/miner/pluoxium
	name = "газодобытчик Плюоксия"
	overlay_color = "#4b54a3"
	spawn_id = GAS_PLUOXIUM

/obj/machinery/atmospherics/miner/proto_nitrate
	name = "газодобытчик Протонитрата"
	overlay_color = "#00571d"
	spawn_id = GAS_PROTO_NITRATE

/obj/machinery/atmospherics/miner/stimulum
	name = "газодобытчик Стимулума"
	overlay_color = "#d577dd"
	spawn_id = GAS_STIMULUM

/obj/machinery/atmospherics/miner/tritium
	name = "газодобытчик Трития"
	overlay_color = "#15ff00"
	spawn_id = GAS_TRITIUM

/obj/machinery/atmospherics/miner/zauker
	name = "газодобытчик Циклона Б"
	overlay_color = "#022e00"
	spawn_id = GAS_ZAUKER

/obj/machinery/atmospherics/miner/helium
	name = "газодобытчик Гелия"
	overlay_color = "#022e00"
	spawn_id = GAS_HELIUM

/obj/machinery/atmospherics/miner/antinoblium
	name = "газодобытчик Антиноблия"
	overlay_color = "#022e00"
	spawn_id = GAS_ANTINOBLIUM
