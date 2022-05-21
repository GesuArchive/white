///SCI TELEPAD///
/obj/machinery/telepad
	name = "телепад"
	desc = "Блюспейс катапульта в масштабах космоса. Для использования нужно ввести точные координаты с поправкой в консоль телепада."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 2
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 2
	circuit = /obj/item/circuitboard/machine/telesci_pad
	var/efficiency

/obj/machinery/telepad/RefreshParts()
	. = ..()
	var/E
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = E

/obj/machinery/telepad/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "pad-idle-o", "pad-idle", I))
		return

	if(panel_open)
		if(istype(I, /obj/item/multitool))
			var/obj/item/multitool/M = I
			M.buffer = src
			to_chat(user, span_caution("Сохраняю данные в буфере [I.name]."))
			return 1

	if(exchange_parts(user, I))
		return

	if(default_deconstruction_crowbar(I))
		return

	return ..()
