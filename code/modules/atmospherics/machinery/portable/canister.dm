#define CAN_DEFAULT_RELEASE_PRESSURE 	(ONE_ATMOSPHERE)
///Used when setting the mode of the canisters, enabling us to switch the overlays
//These are used as icon states later down the line for tier overlays
#define CANISTER_TIER_1					1
#define CANISTER_TIER_2					2
#define CANISTER_TIER_3					3

/obj/machinery/portable_atmospherics/canister
	name = "канистра"
	desc = "Канистра для хранения газа."
	icon = 'icons/obj/atmospherics/canisters.dmi'
	icon_state = "#mapme"
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#ffff00#000000"
	density = TRUE
	volume = 1000
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 80, ACID = 50)
	max_integrity = 250
	integrity_failure = 0.4
	pressure_resistance = 7 * ONE_ATMOSPHERE
	req_access = list()

	var/icon/canister_overlay_file = 'icons/obj/atmospherics/canisters.dmi'

	///Is the valve open?
	var/valve_open = FALSE
	var/release_log = ""

	var/filled = 0.5
	var/gas_type

	var/release_pressure = ONE_ATMOSPHERE
	var/can_max_release_pressure = (ONE_ATMOSPHERE * 10)
	var/can_min_release_pressure = (ONE_ATMOSPHERE / 10)
	///Max amount of heat allowed inside of the canister before it starts to melt (different tiers have different limits)
	var/heat_limit = 5000
	///Max amount of pressure allowed inside of the canister before it starts to break (different tiers have different limits)
	var/pressure_limit = 50000

	var/temperature_resistance = 1000 + T0C
	var/starter_temp
	// Prototype vars
	var/prototype = FALSE
	var/valve_timer = null
	var/timer_set = 30
	var/default_timer_set = 30
	var/minimum_timer_set = 1
	var/maximum_timer_set = 300
	var/timing = FALSE
	var/restricted = FALSE
	///Set the tier of the canister and overlay used
	var/mode = CANISTER_TIER_1

	var/update = 0
	var/static/list/label2types = list(
		"n2" = /obj/machinery/portable_atmospherics/canister/nitrogen,
		"o2" = /obj/machinery/portable_atmospherics/canister/oxygen,
		"co2" = /obj/machinery/portable_atmospherics/canister/carbon_dioxide,
		"plasma" = /obj/machinery/portable_atmospherics/canister/toxins,
		"n2o" = /obj/machinery/portable_atmospherics/canister/nitrous_oxide,
		"no2" = /obj/machinery/portable_atmospherics/canister/nitryl,
		"bz" = /obj/machinery/portable_atmospherics/canister/bz,
		"air" = /obj/machinery/portable_atmospherics/canister/air,
		"water vapor" = /obj/machinery/portable_atmospherics/canister/water_vapor,
		"tritium" = /obj/machinery/portable_atmospherics/canister/tritium,
		"hyper-noblium" = /obj/machinery/portable_atmospherics/canister/nob,
		"stimulum" = /obj/machinery/portable_atmospherics/canister/stimulum,
		"pluoxium" = /obj/machinery/portable_atmospherics/canister/pluoxium,
		"caution" = /obj/machinery/portable_atmospherics/canister,
		"miasma" = /obj/machinery/portable_atmospherics/canister/miasma,
		"freon" = /obj/machinery/portable_atmospherics/canister/freon,
		"hydrogen" = /obj/machinery/portable_atmospherics/canister/hydrogen,
		"healium" = /obj/machinery/portable_atmospherics/canister/healium,
		"proto_nitrate" = /obj/machinery/portable_atmospherics/canister/proto_nitrate,
		"zauker" = /obj/machinery/portable_atmospherics/canister/zauker,
		"helium" = /obj/machinery/portable_atmospherics/canister/helium,
		"antinoblium" = /obj/machinery/portable_atmospherics/canister/antinoblium,
		"halon" = /obj/machinery/portable_atmospherics/canister/halon
	)

/obj/machinery/portable_atmospherics/canister/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/atmos_sensitive)

/obj/machinery/portable_atmospherics/canister/interact(mob/user)
	if(!allowed(user))
		to_chat(user, span_alert("Ошибка - недостаточно привилегий."))
		playsound(src, 'sound/misc/compiler-failure.ogg', 50, TRUE)
		return
	..()

/obj/machinery/portable_atmospherics/canister/examine(user)
	. = ..()
	if(mode)
		. += "<hr><span class='notice'>Эта канистра имеет класс точности [mode].\nСтикер сбоку сообщает <b>МАКСИМАЛЬНОЕ ДАВЛЕНИЕ: [siunit_pressure(pressure_limit, 0)]</b>.</span>"

// Please keep the canister types sorted
// Basic canister per gas below here

/obj/machinery/portable_atmospherics/canister/air
	name = "канистра с воздухом"
	desc = "То, чем ты сейчас дышишь."
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#c6c0b5"

/obj/machinery/portable_atmospherics/canister/antinoblium
	name = "канистра с антиноблием"
	desc = "Антиноблий, мы до сих пор не знаем, что он делает, но он очень дорого продается"
	gas_type = /datum/gas/antinoblium
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#9b5d7f#368bff"

/obj/machinery/portable_atmospherics/canister/bz
	name = "канистра с БЗ"
	desc = "БЗ, сильнодействующее галлюциногенное нервно-паралитическое средство."
	gas_type = /datum/gas/bz
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#9b5d7f#d0d2a0"

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "канистра с угарным газом"
	desc = "Углекислый газ. Что за хрень этот углекислый газ?"
	gas_type = /datum/gas/carbon_dioxide
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#4e4c48"

/obj/machinery/portable_atmospherics/canister/freon
	name = "канистра с фреоном"
	desc = "Фреон. Может поглощать тепло."
	gas_type = /datum/gas/freon
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#6696ee#fefb30"

/obj/machinery/portable_atmospherics/canister/halon
	name = "канистра с галоном"
	desc = "Галон, удаляет кислород из высокотемпературных пожаров и охлаждает помещение."
	gas_type = /datum/gas/halon
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#9b5d7f#368bff"

/obj/machinery/portable_atmospherics/canister/healium
	name = "канистра с хилиумом"
	desc = "Хилиум, вызывает глубокий сон. Не путать с гелием."
	gas_type = /datum/gas/healium
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#009823#ff0e00"

/obj/machinery/portable_atmospherics/canister/helium
	name = "канистра с гелием"
	desc = "Гелий, инертный газ."
	gas_type = /datum/gas/helium
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#9b5d7f#368bff"

/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "канистра с водородом"
	desc = "Водород, легковоспламеняющийся."
	gas_type = /datum/gas/hydrogen
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/stripe
	greyscale_colors = "#bdc2c0#ffffff"

/obj/machinery/portable_atmospherics/canister/miasma
	name = "канистра с миазмой"
	desc = "Миазма. Вызывает желание отрезать нос."
	gas_type = /datum/gas/miasma
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#009823#f7d5d3"

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "канистра с азотом"
	desc = "Газообразный азот. Якобы полезно для чего-то."
	gas_type = /datum/gas/nitrogen
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#d41010"

/obj/machinery/portable_atmospherics/canister/nitrous_oxide
	name = "канистра с закисью азота"
	desc = "Закись азота. Вызывает сонливость."
	gas_type = /datum/gas/nitrous_oxide
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#c63e3b#f7d5d3"

/obj/machinery/portable_atmospherics/canister/nitryl
	name = "канистра с нитрилом"
	desc = "Нитрил-газ. Чувствуй себя прекрасно, пока кислота не съест твои легкие."
	gas_type = /datum/gas/nitryl
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#7b4732"

/obj/machinery/portable_atmospherics/canister/nob
	name = "канистра с гипер-ноблием"
	desc = "Гипер-Ноблий. Благороднее всех остальных газов."
	gas_type = /datum/gas/hypernoblium
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#6399fc#b2b2b2"

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "канистра с кислородом"
	desc = "Кислород. Необходим для жизни человека."
	gas_type = /datum/gas/oxygen
	greyscale_config = /datum/greyscale_config/canister/stripe
	greyscale_colors = "#2786e5#e8fefe"

/obj/machinery/portable_atmospherics/canister/pluoxium
	name = "канистра с плюоксием"
	desc = "Плюоксий. Как кислород, но с большей отдачей."
	gas_type = /datum/gas/pluoxium
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#2786e5"

/obj/machinery/portable_atmospherics/canister/proto_nitrate
	name = "канистра с протонитратом"
	desc = "Протонитрат, по-разному реагирует с различными газами."
	gas_type = /datum/gas/proto_nitrate
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#008200#33cc33"

/obj/machinery/portable_atmospherics/canister/stimulum
	name = "канистра со стимулумом"
	desc = "Стимул. Газ высокой энергии, люди высокой энергии."
	gas_type = /datum/gas/stimulum
	greyscale_config = /datum/greyscale_config/canister
	greyscale_colors = "#9b5d7f"

/obj/machinery/portable_atmospherics/canister/toxins
	name = "канистра с плазмой"
	desc = "Плазменный газ. Причина, по которой ТЫ здесь. Сильно токсичен."
	gas_type = /datum/gas/plasma
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#f62800#000000"

/obj/machinery/portable_atmospherics/canister/tritium
	name = "канистра с тритием"
	desc = "Тритий. Вдыхание может вызвать облучение."
	gas_type = /datum/gas/tritium
	greyscale_config = /datum/greyscale_config/canister/hazard
	greyscale_colors = "#3fcd40#000000"

/obj/machinery/portable_atmospherics/canister/water_vapor
	name = "канистра с паром"
	desc = "Водяной пар. Мы поняли, ты вейпер."
	gas_type = /datum/gas/water_vapor
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#4c4e4d#f7d5d3"

/obj/machinery/portable_atmospherics/canister/zauker
	name = "канистра с циклоном Б"
	desc = "Невероятно токсичный газ, лучше не вдыхать."
	gas_type = /datum/gas/zauker
	filled = 1
	greyscale_config = /datum/greyscale_config/canister/double_stripe
	greyscale_colors = "#009a00#006600"

// Special canisters below here

/obj/machinery/portable_atmospherics/canister/fusion_test
	name = "пиздец, а не канистра"
	desc = "Анпедал уже готовится."
	heat_limit = 1e12
	pressure_limit = 1e14
	mode = CANISTER_TIER_3

/obj/machinery/portable_atmospherics/canister/fusion_test/create_gas()
	air_contents.set_moles(/datum/gas/hydrogen, 300)
	air_contents.set_moles(/datum/gas/tritium, 300)
	air_contents.set_temperature(10000)

/obj/machinery/portable_atmospherics/canister/proc/get_time_left()
	if(timing)
		. = round(max(0, valve_timer - world.time) / 10, 1)
	else
		. = timer_set

/obj/machinery/portable_atmospherics/canister/proc/set_active()
	timing = !timing
	if(timing)
		valve_timer = world.time + (timer_set * 10)
	update_icon()

/obj/machinery/portable_atmospherics/canister/proto
	name = "prototype canister"
	greyscale_config = /datum/greyscale_config/prototype_canister
	greyscale_colors = "#ffffff#a50021#ffffff"
	mode = NONE


/obj/machinery/portable_atmospherics/canister/proto/default
	name = "прототип канистры"
	desc = "Лучший способ исправить атмосферную аварию... или лучший способ создать ее."
	volume = 5000
	max_integrity = 300
	temperature_resistance = 2000 + T0C
	can_max_release_pressure = (ONE_ATMOSPHERE * 30)
	can_min_release_pressure = (ONE_ATMOSPHERE / 30)
	prototype = TRUE


/obj/machinery/portable_atmospherics/canister/proto/default/oxygen
	name = "прототип канистры"
	desc = "Канистра любителя изобретать велосипеды, что может пойти не так?"
	gas_type = /datum/gas/oxygen
	filled = 1
	release_pressure = ONE_ATMOSPHERE*2

/obj/machinery/portable_atmospherics/canister/tier_1
	heat_limit = 5000
	pressure_limit = 50000
	mode = CANISTER_TIER_1

/obj/machinery/portable_atmospherics/canister/tier_2
	heat_limit = 500000
	pressure_limit = 5e6
	volume = 3000
	max_integrity = 300
	can_max_release_pressure = (ONE_ATMOSPHERE * 30)
	can_min_release_pressure = (ONE_ATMOSPHERE / 30)
	mode = CANISTER_TIER_2

/obj/machinery/portable_atmospherics/canister/tier_3
	heat_limit = 1e12
	pressure_limit = 1e14
	volume = 5000
	max_integrity = 500
	can_max_release_pressure = (ONE_ATMOSPHERE * 30)
	can_min_release_pressure = (ONE_ATMOSPHERE / 50)
	mode = CANISTER_TIER_3

/obj/machinery/portable_atmospherics/canister/Initialize(mapload, datum/gas_mixture/existing_mixture)
	. = ..()
	if(existing_mixture)
		air_contents.copy_from(existing_mixture)
	else
		create_gas()
	update_icon()


/obj/machinery/portable_atmospherics/canister/proc/create_gas()
	if(gas_type)
		if(starter_temp)
			air_contents.set_temperature(starter_temp)
		air_contents.set_moles(gas_type, (maximum_pressure * filled) * air_contents.return_volume() / (R_IDEAL_GAS_EQUATION * air_contents.return_temperature()))

/obj/machinery/portable_atmospherics/canister/air/create_gas()
	if(starter_temp)
		air_contents.set_temperature(starter_temp)
	air_contents.set_moles(/datum/gas/oxygen, (O2STANDARD * maximum_pressure * filled) * air_contents.return_volume() / (R_IDEAL_GAS_EQUATION * air_contents.return_temperature()))
	air_contents.set_moles(/datum/gas/nitrogen, (N2STANDARD * maximum_pressure * filled) * air_contents.return_volume() / (R_IDEAL_GAS_EQUATION * air_contents.return_temperature()))

/obj/machinery/portable_atmospherics/canister/update_icon_state()
	if(machine_stat & BROKEN)
		icon_state = "[base_icon_state]-1"

/obj/machinery/portable_atmospherics/canister/update_overlays()
	. = ..()
	var/isBroken = machine_stat & BROKEN
	///Function is used to actually set the overlays
	if(mode)
		. += mutable_appearance(canister_overlay_file, "tier[mode]")
	if(isBroken)
		. += mutable_appearance(canister_overlay_file, "broken")
	if(holding)
		. += mutable_appearance(canister_overlay_file, "can-open")
	if(connected_port)
		. += mutable_appearance(canister_overlay_file, "can-connector")

	switch(air_contents?.return_pressure())
		if((40 * ONE_ATMOSPHERE) to INFINITY)
			. += mutable_appearance(canister_overlay_file, "can-3")
		if((10 * ONE_ATMOSPHERE) to (40 * ONE_ATMOSPHERE))
			. += mutable_appearance(canister_overlay_file, "can-2")
		if((5 * ONE_ATMOSPHERE) to (10 * ONE_ATMOSPHERE))
			. += mutable_appearance(canister_overlay_file, "can-1")
		if((10) to (5 * ONE_ATMOSPHERE))
			. += mutable_appearance(canister_overlay_file, "can-0")


/obj/machinery/portable_atmospherics/canister/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > temperature_resistance * mode

/obj/machinery/portable_atmospherics/canister/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(5, BURN, 0)

/obj/machinery/portable_atmospherics/canister/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!(machine_stat & BROKEN))
			canister_break()
		if(disassembled)
			switch(mode)
				if(CANISTER_TIER_1)
					new /obj/item/stack/sheet/iron (loc, 10)
				if(CANISTER_TIER_2)
					new /obj/item/stack/sheet/iron (loc, 10)
					new /obj/item/stack/sheet/plasteel (loc, 5)
				if(CANISTER_TIER_3)
					new /obj/item/stack/sheet/iron (loc, 10)
					new /obj/item/stack/sheet/plasteel (loc, 5)
					new /obj/item/stack/sheet/bluespace_crystal (loc, 1)
		else
			new /obj/item/stack/sheet/iron (loc, 5)
	qdel(src)

/obj/machinery/portable_atmospherics/canister/welder_act(mob/living/user, obj/item/I)
	..()
	if(user.a_intent == INTENT_HARM)
		return FALSE

	if(!I.tool_start_check(user, amount=0))
		return TRUE
	var/pressure = air_contents.return_pressure()
	if(pressure > 300)
		to_chat(user, span_alert("Индикаторы канистры сообщают о высоком давлении внутри... может стоит передумать?"))
		message_admins("[src] deconstructed by [ADMIN_LOOKUPFLW(user)]")
		log_game("[src] deconstructed by [key_name(user)]")
	to_chat(user, span_notice("Начинаю резать <b>[src.name]</b> на куски..."))
	if(I.use_tool(src, user, 3 SECONDS, volume=50))
		to_chat(user, span_notice("Режу <b>[src.name]</b> на куски."))
		deconstruct(TRUE)

	return TRUE

/obj/machinery/portable_atmospherics/canister/obj_break(damage_flag)
	. = ..()
	if(!.)
		return
	canister_break()

/obj/machinery/portable_atmospherics/canister/proc/canister_break()
	disconnect()
	var/datum/gas_mixture/expelled_gas = air_contents.remove(air_contents.total_moles())
	var/turf/T = get_turf(src)
	T.assume_air(expelled_gas)
	air_update_turf(FALSE, FALSE)

	obj_break()

	set_density(FALSE)
	playsound(src.loc, 'sound/effects/spray.ogg', 10, TRUE, -3)
	investigate_log("was destroyed.", INVESTIGATE_ATMOS)

	if(holding)
		holding.forceMove(T)
		holding = null

	animate(src, 0.5 SECONDS, transform=turn(transform, rand(-179, 180)), easing=BOUNCE_EASING)

/obj/machinery/portable_atmospherics/canister/replace_tank(mob/living/user, close_valve)
	. = ..()
	if(!.)
		return
	if(close_valve)
		valve_open = FALSE
		update_icon()
		investigate_log("Valve was <b>closed</b> by [key_name(user)].", INVESTIGATE_ATMOS)
	else if(valve_open && holding)
		investigate_log("[key_name(user)] started a transfer into [holding].", INVESTIGATE_ATMOS)

/obj/machinery/portable_atmospherics/canister/process_atmos(delta_time)
	..()
	if(machine_stat & BROKEN)
		return PROCESS_KILL
	if(timing && valve_timer < world.time)
		valve_open = !valve_open
		timing = FALSE

	// Handle gas transfer.
	if(valve_open)
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/target_air = holding ? holding.air_contents : T.return_air()

		if(air_contents.release_gas_to(target_air, release_pressure) && !holding)
			air_update_turf(FALSE, FALSE)

	var/our_pressure = air_contents.return_pressure()
	var/our_temperature = air_contents.return_temperature()

	///function used to check the limit of the canisters and also set the amount of damage that the canister can receive, if the heat and pressure are way higher than the limit the more damage will be done
	if(our_temperature > heat_limit || our_pressure > pressure_limit)
		take_damage(clamp((our_temperature/heat_limit) * (our_pressure/pressure_limit) * delta_time * 2, 5, 50), BURN, 0)
	update_icon()

/obj/machinery/portable_atmospherics/canister/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Canister", name)
		ui.open()

/obj/machinery/portable_atmospherics/canister/ui_static_data(mob/user)
	return list(
		"defaultReleasePressure" = round(CAN_DEFAULT_RELEASE_PRESSURE),
		"minReleasePressure" = round(can_min_release_pressure),
		"maxReleasePressure" = round(can_max_release_pressure),
		"pressureLimit" = round(pressure_limit),
		"holdingTankLeakPressure" = round(TANK_LEAK_PRESSURE),
		"holdingTankFragPressure" = round(TANK_FRAGMENT_PRESSURE)
	)

/obj/machinery/portable_atmospherics/canister/ui_data()
	. = list(
		"portConnected" = !!connected_port,
		"tankPressure" = round(air_contents.return_pressure()),
		"releasePressure" = round(release_pressure),
		"valveOpen" = !!valve_open,
		"isPrototype" = !!prototype,
		"hasHoldingTank" = !!holding
	)

	if (prototype)
		. += list(
			"restricted" = restricted,
			"timing" = timing,
			"time_left" = get_time_left(),
			"timer_set" = timer_set,
			"timer_is_not_default" = timer_set != default_timer_set,
			"timer_is_not_min" = timer_set != minimum_timer_set,
			"timer_is_not_max" = timer_set != maximum_timer_set
		)

	if (holding)
		. += list(
			"holdingTank" = list(
				"name" = holding.name,
				"tankPressure" = round(holding.air_contents.return_pressure())
			)
		)

/obj/machinery/portable_atmospherics/canister/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("relabel")
			var/label = input("New canister label:", name) as null|anything in sortList(label2types)
			if(label && !..())
				var/newtype = label2types[label]
				if(newtype)
					var/obj/machinery/portable_atmospherics/canister/replacement = newtype
					investigate_log("was relabelled to [initial(replacement.name)] by [key_name(usr)].", INVESTIGATE_ATMOS)
					name = initial(replacement.name)
					desc = initial(replacement.desc)
					icon_state = initial(replacement.icon_state)
					base_icon_state = icon_state
					set_greyscale(initial(replacement.greyscale_colors), initial(replacement.greyscale_config))
		if("restricted")
			restricted = !restricted
			if(restricted)
				req_access = list(ACCESS_ENGINE)
			else
				req_access = list()
				. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = CAN_DEFAULT_RELEASE_PRESSURE
				. = TRUE
			else if(pressure == "min")
				pressure = can_min_release_pressure
				. = TRUE
			else if(pressure == "max")
				pressure = can_max_release_pressure
				. = TRUE
			else if(pressure == "input")
				pressure = input("New release pressure ([can_min_release_pressure]-[can_max_release_pressure] kPa):", name, release_pressure) as num|null
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				release_pressure = clamp(round(pressure), can_min_release_pressure, can_max_release_pressure)
				investigate_log("was set to [release_pressure] kPa by [key_name(usr)].", INVESTIGATE_ATMOS)
		if("valve")
			var/logmsg
			valve_open = !valve_open
			if(valve_open)
				logmsg = "Valve was <b>opened</b> by [key_name(usr)], starting a transfer into [holding || "air"].<br>"
				if(!holding)
					var/list/danger = list()
					for(var/id in air_contents.get_gases())
						if(!GLOB.meta_gas_info[id][META_GAS_DANGER])
							continue
						if(air_contents.get_moles(id) > (GLOB.meta_gas_info[id][META_GAS_MOLES_VISIBLE] || MOLES_GAS_VISIBLE)) //if moles_visible is undefined, default to default visibility
							danger[GLOB.meta_gas_info[id][META_GAS_NAME]] = air_contents.get_moles(id) //ex. "plasma" = 20

					if(danger.len)
						message_admins("[ADMIN_LOOKUPFLW(usr)] opened a canister that contains the following at [ADMIN_VERBOSEJMP(src)]:")
						log_admin("[key_name(usr)] opened a canister that contains the following at [AREACOORD(src)]:")
						for(var/name in danger)
							var/msg = "[name]: [danger[name]] moles."
							log_admin(msg)
							message_admins(msg)
			else
				logmsg = "Valve was <b>closed</b> by [key_name(usr)], stopping the transfer into [holding || "air"].<br>"
			investigate_log(logmsg, INVESTIGATE_ATMOS)
			release_log += logmsg
			. = TRUE
		if("timer")
			var/change = params["change"]
			switch(change)
				if("reset")
					timer_set = default_timer_set
				if("decrease")
					timer_set = max(minimum_timer_set, timer_set - 10)
				if("increase")
					timer_set = min(maximum_timer_set, timer_set + 10)
				if("input")
					var/user_input = input(usr, "Set time to valve toggle.", name) as null|num
					if(!user_input)
						return
					var/N = text2num(user_input)
					if(!N)
						return
					timer_set = clamp(N,minimum_timer_set,maximum_timer_set)
					log_admin("[key_name(usr)] has activated a prototype valve timer")
					. = TRUE
				if("toggle_timer")
					set_active()
		if("eject")
			if(holding)
				if(valve_open)
					message_admins("[ADMIN_LOOKUPFLW(usr)] removed [holding] from [src] with valve still open at [ADMIN_VERBOSEJMP(src)] releasing contents into the <span class='boldannounce'>air</span>.")
					investigate_log("[key_name(usr)] removed the [holding], leaving the valve open and transferring into the <span class='boldannounce'>air</span>.", INVESTIGATE_ATMOS)
				replace_tank(usr, FALSE)
				. = TRUE
	update_icon()
