/obj/item/circuitboard/computer/enernet_control
	name = "Управление энернетом (Консоль)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/enernet_control

/obj/machinery/computer/enernet_control
	name = "управление энернетом"
	desc = "Используется для регулирования поступления продаваемой в общую сеть энергии."
	icon = 'white/valtos/icons/32x48.dmi'
	icon_state = "econs"
	icon_keyboard = null
	icon_screen = null
	pixel_x = 8
	pixel_y = -2
	circuit = /obj/item/circuitboard/computer/enernet_control
	var/datum/bank_account/attached_account
	var/list/attached_coils = list()
	var/autosell = FALSE
	var/autosell_amount = 1000000
	var/price_for_one_kw = 0.000142

/obj/machinery/computer/enernet_control/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES | EMP_PROTECT_CONTENTS)

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
	data["autosell"] 	     = autosell
	data["autosell_amount"]  = autosell_amount
	data["price_for_one_kw"] = price_for_one_kw
	return data

/obj/machinery/computer/enernet_control/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("setautosellamount")
			autosell_amount = params["autosell_selected"]
			. = TRUE
		if("toggle_autosell")
			if(autosell)
				stop_selling()
			else
				start_selling()
			. = TRUE
		if("get_coils")
			get_coils()
			. = TRUE

/obj/machinery/computer/enernet_control/process()
	. = ..()
	if(autosell && attached_coils.len && attached_account)
		var/total_selled = 0
		for(var/obj/machinery/enernet_coil/E in attached_coils)
			E.update()
			if(E.cur_acc >= autosell_amount)
				E.cur_acc -= autosell_amount
				E.Beam(src, "ebeam", 'white/valtos/icons/projectiles.dmi', 1 SECONDS)
				total_selled += autosell_amount
		var/turf/target = locate(x, y + 8, z)
		Beam(target, "ebeam", 'white/valtos/icons/projectiles.dmi', 1 SECONDS)
		attached_account.adjust_money(total_selled * price_for_one_kw)
	else
		autosell = FALSE
		STOP_PROCESSING(SSmachines, src)

/obj/machinery/computer/enernet_control/proc/get_coils()
	attached_coils.Cut()
	for(var/obj/machinery/enernet_coil/E in view(5))
		attached_coils += E
		playsound(get_turf(E), 'white/valtos/sounds/estart.ogg', 80)
		E.soundloop.start()
	return TRUE

/obj/machinery/computer/enernet_control/proc/start_selling()
	autosell = TRUE
	START_PROCESSING(SSmachines, src)
	return TRUE

/obj/machinery/computer/enernet_control/proc/stop_selling()
	autosell = FALSE
	STOP_PROCESSING(SSmachines, src)
	return TRUE

/obj/item/circuitboard/machine/enernet_coil
	name = "Энергоконцентратор (Оборудование)"
	icon_state = "engineering"
	build_path = /obj/machinery/enernet_coil
	req_components = list(
		/obj/item/stock_parts/capacitor = 4,
		/obj/item/stack/cable_coil = 30)

/obj/machinery/enernet_coil
	name = "энергоконцентратор"
	desc = "Аккумулирует поступающую в него энергию. Требует консоль для работы."
	icon = 'white/valtos/icons/32x48.dmi'
	icon_state = "ecoil_off"
	circuit = /obj/item/circuitboard/machine/enernet_coil
	var/obj/structure/cable/ac
	var/max_acc = 20000000
	var/cur_acc = 0
	var/suck_rate = 2000000
	var/datum/looping_sound/enernet_coil/soundloop

/obj/machinery/enernet_coil/Initialize(mapload)
	. = ..()
	soundloop = new(list(src), TRUE)
	soundloop.stop()
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF | EMP_PROTECT_WIRES | EMP_PROTECT_CONTENTS)

/obj/machinery/enernet_coil/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/enernet_coil/RefreshParts()
	. = ..()
	var/calc_things = 0
	for(var/obj/item/stock_parts/capacitor/cap in component_parts)
		calc_things += cap.rating
	max_acc = 5000000 * calc_things
	suck_rate = 500000 * calc_things

/obj/machinery/enernet_coil/proc/update()
	var/turf/T = get_turf(src)
	ac = locate(/obj/structure/cable) in T
	if(ac)
		var/sp = clamp(ac.surplus(), 0, (max_acc - cur_acc))
		if(sp)
			ac.add_load(sp)
			cur_acc += sp
			icon_state = "ecoil_on"
		else
			playsound(get_turf(src), 'white/valtos/sounds/estop.ogg', 80)
			icon_state = "ecoil_off"
		update_icon()

/obj/machinery/enernet_coil/update_icon()
	. = ..()
	overlays.Cut()
	switch(cur_acc)
		if(0 to max_acc/4)
			add_overlay("ebal_low")
			return
		if((max_acc/4) + 1 to max_acc/2)
			add_overlay("ebal_mid")
			return
		if((max_acc/2) + 1 to max_acc - 1000000)
			add_overlay("eball_near")
			return
		if(max_acc - 1000001 to max_acc)
			add_overlay("eball_fuck")
			return
		if(max_acc +1 to INFINITY)
			playsound(get_turf(src), 'white/valtos/sounds/explo.ogg', 80)
			spawn(1 SECONDS)
				empulse(get_turf(src), rand(1, 4), rand(4, 8))
				cur_acc = 0
				overlays.Cut()
