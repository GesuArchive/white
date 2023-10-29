//node2, air2, network2 correspond to input
//node1, air1, network1 correspond to output
#define CIRCULATOR_HOT 0
#define CIRCULATOR_COLD 1

/obj/machinery/atmospherics/components/binary/circulator
	name = "турбина ТЭГа"
	desc = "Газовый циркулятор с теплообменником."
	icon = 'white/valtos/icons/teg.dmi'
	icon_state = "circ-unassembled-0"
	density = TRUE
	integrity_failure = 0.75
	move_resist = MOVE_RESIST_DEFAULT //can be pushed around like a regular machine
	var/active = FALSE

	var/last_pressure_delta = 0
	pipe_flags = PIPING_ONE_PER_TURF | PIPING_DEFAULT_LAYER_ONLY

	var/flipped = 0
	var/mode = CIRCULATOR_HOT
	var/obj/machinery/power/generator/generator

//for mappers
/obj/machinery/atmospherics/components/binary/circulator/cold
	mode = CIRCULATOR_COLD

/obj/machinery/atmospherics/components/binary/circulator/flipped
	flipped = 1
	icon_state = "circ-unassembled-1"

/obj/machinery/atmospherics/components/binary/circulator/cold/flipped
	mode = CIRCULATOR_COLD
	flipped = 1
	icon_state = "circ-unassembled-1"

/obj/machinery/atmospherics/components/binary/circulator/Initialize(mapload)
	. = ..()
	component_parts = list(new /obj/item/circuitboard/machine/circulator)
	update_icon()

/obj/machinery/atmospherics/components/binary/circulator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS )

/obj/machinery/atmospherics/components/binary/circulator/Destroy()
	if(generator)
		disconnect_from_generator()
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/proc/return_transfer_air()

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]

	var/output_starting_pressure = air1.return_pressure()
	var/input_starting_pressure = air2.return_pressure()

	if(output_starting_pressure >= input_starting_pressure-10)
		//Need at least 10 KPa difference to overcome friction in the mechanism
		last_pressure_delta = 0
		return null

	//Calculate necessary moles to transfer using PV = nRT
	if(air2.temperature>0)
		var/pressure_delta = (input_starting_pressure - output_starting_pressure)/2

		var/transfer_moles = (pressure_delta*air1.volume)/(air2.temperature * R_IDEAL_GAS_EQUATION)

		last_pressure_delta = pressure_delta

		//Actually transfer the gas
		var/datum/gas_mixture/removed = air2.remove(transfer_moles)

		update_parents()

		return removed

	else
		last_pressure_delta = 0

/obj/machinery/atmospherics/components/binary/circulator/process_atmos()
	..()
	update_icon_nopipes()

/obj/machinery/atmospherics/components/binary/circulator/update_icon()
	cut_overlays()

	if(anchored)
		for(var/direction in GLOB.cardinals)
			if(!(direction & initialize_directions))
				continue
			var/obj/machinery/atmospherics/node = find_connecting(direction)

			var/image/cap
			if(node)
				cap = get_pipe_image(icon, "cap", direction, node.pipe_color, piping_layer = piping_layer)

			add_overlay(cap)

	return ..()

/obj/machinery/atmospherics/components/binary/circulator/update_icon_nopipes()
	cut_overlays()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)

	if(machine_stat & (BROKEN))
		icon_state = "circ-broken"
		set_light(0)
		return

	if(!generator)
		icon_state = "circ-unassembled-[flipped]"
		if(panel_open)
			add_overlay("circ-panel")
		set_light(0)
		return
	if(!generator.anchored)
		icon_state = "circ-unassembled-[flipped]"
		if(panel_open)
			add_overlay("circ-panel")
		set_light(0)
		return

	icon_state = "circ-assembled-[flipped]"

	if(!is_operational)
		set_light(0)
		return
	else
		if(!last_pressure_delta)
			set_light(1)
			SSvis_overlays.add_vis_overlay(src, icon, "circ-off", plane = ABOVE_LIGHTING_PLANE, dir = src.dir)
			return
		else
			if(last_pressure_delta > ONE_ATMOSPHERE) //fast
				if(mode)
					set_light(3,2,"#4F82FF")
				else
					set_light(3,2,"#FF3232")
				SSvis_overlays.add_vis_overlay(src, icon, "circ-ex[mode?"cold":"hot"]", plane = ABOVE_LIGHTING_PLANE, dir = src.dir)
				SSvis_overlays.add_vis_overlay(src, icon, "circ-run", plane = ABOVE_LIGHTING_PLANE, dir = src.dir)
			else	//slow
				if(mode)
					set_light(2,1,"#4F82FF")
				else
					set_light(2,1,"#FF3232")
				SSvis_overlays.add_vis_overlay(src, icon, "circ-[mode?"cold":"hot"]", plane = ABOVE_LIGHTING_PLANE, dir = src.dir)
				SSvis_overlays.add_vis_overlay(src, icon, "circ-slow", plane = ABOVE_LIGHTING_PLANE, dir = src.dir)

/obj/machinery/atmospherics/components/binary/circulator/wrench_act(mob/living/user, obj/item/I)
	if(user.a_intent == INTENT_HARM)
		return

	if(!panel_open)
		to_chat(user, span_warning("Стоит открыть панель!"))
		return TRUE

	if(generator)
		to_chat(user, span_warning("Нужно отключить [generator] сначала!"))
		return TRUE

	anchored = !anchored
	I.play_tool_sound(src)
	to_chat(user, span_notice("[anchored?"Прикручиваю":"Откручиваю"] [src]."))

	var/obj/machinery/atmospherics/node1 = nodes[1]
	var/obj/machinery/atmospherics/node2 = nodes[2]

	if(node1)
		node1.disconnect(src)
		nodes[1] = null
		nullify_pipenet(parents[1])
	if(node2)
		node2.disconnect(src)
		nodes[2] = null
		if(parents[2])
			nullify_pipenet(parents[2])

	if(anchored)
		set_init_directions()
		atmos_init()
		node1 = nodes[1]
		if(node1)
			node1.atmos_init()
			node1.add_member(src)
		node2 = nodes[2]
		if(node2)
			node2.atmos_init()
			node2.add_member(src)
		SSair.add_to_rebuild_queue(src)

	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/set_init_directions()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = EAST|WEST
		if(EAST, WEST)
			initialize_directions = NORTH|SOUTH

/obj/machinery/atmospherics/components/binary/circulator/get_node_connects()
	if(flipped)
		return list(turn(dir, 270), turn(dir, 90))
	return list(turn(dir, 90), turn(dir, 270))

/obj/machinery/atmospherics/components/binary/circulator/can_be_node(obj/machinery/atmospherics/target)
	if(anchored)
		return ..(target)
	return FALSE

/obj/machinery/atmospherics/components/binary/circulator/multitool_act(mob/living/user, obj/item/I)
	if(user.a_intent == INTENT_HARM)
		return
	if(generator)
		to_chat(user, span_warning("Нужно отключить [generator] сначала!"))
		return TRUE

	mode = !mode
	to_chat(user, span_notice("Выставляю режим [src] в [mode?"холодный":"горячий"] поток."))
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/screwdriver_act(mob/user, obj/item/I)
	if(..())
		return TRUE
	if(user.a_intent == INTENT_HARM)
		return
	if(generator)
		to_chat(user, span_warning("Сначала нужно отключить генератор!"))
		return TRUE

	toggle_panel_open()
	I.play_tool_sound(src)
	to_chat(user, span_notice("[panel_open?"Открываю":"Закрываю"] панель [src]."))
	update_icon_nopipes()
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/crowbar_act(mob/user, obj/item/I)
	if(user.a_intent == INTENT_HARM)
		return
	if(anchored)
		to_chat(user, span_warning("[capitalize(src.name)] прикручен!"))
		return TRUE
	if(!panel_open)
		circulator_flip()
		return TRUE
	else
		default_deconstruction_crowbar(I)
		return TRUE

/obj/machinery/atmospherics/components/binary/circulator/on_deconstruction()
	if(generator)
		disconnect_from_generator()

/obj/machinery/atmospherics/components/binary/circulator/proc/disconnect_from_generator()
	if(mode)
		generator.cold_circ = null
	else
		generator.hot_circ = null
	generator.update_icon()
	generator = null

/obj/machinery/atmospherics/components/binary/circulator/verb/circulator_flip()
	set name = "Крутить"
	set category = "Объект"
	set src in oview(1)

	if(!ishuman(usr))
		return

	if(anchored)
		to_chat(usr, span_danger("[src] прикручен!"))
		return

	flipped = !flipped
	to_chat(usr, span_notice("Кручу [src.name]."))
	playsound(src, 'sound/items/change_drill.ogg', 50)
	update_icon_nopipes()

/obj/machinery/atmospherics/components/binary/circulator/obj_break(damage_flag)
	if(generator)
		generator.kill_circs()
		generator.update_icon()
	..()
