/obj/item/circuitboard/computer/enernet_control
	name = "консоль управления энергоконцентратором"
	desc = "Используется для регулирования поступления продаваемой в общую сеть энергии."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/enernet_control

/obj/machinery/computer/enernet_control
	name = "консоль управления энергоконцентратором"
	desc = "Используется для регулирования поступления продаваемой в общую сеть энергии."
	icon = 'white/valtos/icons/32x48.dmi'
	icon_state = "econs"
	icon_keyboard = null
	icon_screen = null
	circuit = /obj/item/circuitboard/computer/enernet_control
	var/list/attached_coils = list()
	var/obj/structure/cable/power_cable

/obj/machinery/computer/enernet_control/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	var/turf/T = get_turf(src)
	power_cable = T.get_cable_node()

	START_PROCESSING(SSmachines, src)

/obj/machinery/computer/enernet_control/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EnerNet", name)
		ui.open()

/obj/machinery/computer/enernet_control/ui_data(mob/user)
	var/list/data = list()
	data["coils"] = list()
	for(var/obj/machinery/enernet_coil/E in attached_coils)
		data["coils"] += list(list("acc" = E.cur_acc, "max" = E.max_acc, "suc" = E.suck_rate))
	return data

/obj/machinery/computer/enernet_control/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("get_coils")
			get_coils()
			. = TRUE

/obj/machinery/computer/enernet_control/process()
	. = ..()
	if(!power_cable)
		var/turf/T = get_turf(src)
		power_cable = T.get_cable_node()

	if(power_cable && attached_coils.len)
		for(var/obj/machinery/enernet_coil/E in attached_coils)
			if(get_dist(src, E) > 7 || E.cur_acc >= E.max_acc)
				E.e_control = null
				E.update_overlays()
				attached_coils -= E
				continue
			E.cur_acc += min(use_power_from_net(E.suck_rate, TRUE), E.max_acc)
			E.update_overlays()
			E.Beam(src, "ebeam", 'white/valtos/icons/projectiles.dmi', 1 SECONDS)

/obj/machinery/computer/enernet_control/proc/get_coils()
	for(var/obj/machinery/enernet_coil/E in view(5))
		if(E.e_control)
			continue
		E.icon_state = "ecoil_charged"
		attached_coils += E
		playsound(get_turf(E), 'white/valtos/sounds/estart.ogg', 80)
	return TRUE

/obj/item/circuitboard/machine/enernet_coil
	name = "Энергоконцентратор"
	desc = "Аккумулирует поступающую в него энергию. Требует консоль для работы."
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/enernet_coil
	req_components = list(
		/obj/item/stock_parts/capacitor = 4,
		/obj/item/stack/cable_coil = 30)

/obj/machinery/enernet_coil
	name = "энергоконцентратор"
	desc = "Аккумулирует поступающую в него энергию. Требует консоль для работы."
	icon = 'white/valtos/icons/32x48.dmi'
	icon_state = "ecoil_empty"
	circuit = /obj/item/circuitboard/machine/enernet_coil
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/max_acc = 2000000
	var/cur_acc = 0
	var/suck_rate = 20000
	var/obj/machinery/computer/enernet_control/e_control
	var/datum/looping_sound/enernet_coil/soundloop

/obj/machinery/enernet_coil/Initialize(mapload)
	. = ..()
	soundloop = new(src, TRUE)
	soundloop.start()

	for(var/atom/A in view(5))
		if(istype(A, /obj/machinery/computer/enernet_control))
			e_control = A
			return

/obj/machinery/enernet_coil/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool, 1 SECONDS))
		return
	e_control?.attached_coils -= src
	e_control = null

/obj/machinery/enernet_coil/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/enernet_coil/RefreshParts()
	. = ..()
	var/calc_things = 0
	for(var/obj/item/stock_parts/capacitor/cap in component_parts)
		calc_things += cap.rating
	max_acc = 500000 * calc_things
	suck_rate = 5000 * calc_things

/obj/machinery/enernet_coil/update_overlays()
	. = ..()
	if(cur_acc in 0 to max_acc/4)
		. += mutable_appearance(icon, "ebal_low")
	else if(cur_acc in (max_acc/4) + 1 to max_acc/2)
		. += mutable_appearance(icon, "ebal_mid")
	else if(cur_acc in (max_acc/2) + 1 to max_acc)
		. += mutable_appearance(icon, "eball_near")
	else if(cur_acc in max_acc to INFINITY)
		. += mutable_appearance(icon, "eball_fuck")
