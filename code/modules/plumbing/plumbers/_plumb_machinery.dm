/**Basic plumbing object.
* It doesn't really hold anything special, YET.
* Objects that are plumbing but not a subtype are as of writing liquid pumps and the reagent_dispenser tank
* Also please note that the plumbing component is toggled on and off by the component using a signal from default_unfasten_wrench, so dont worry about it
*/
/obj/machinery/plumbing
	name = "pipe thing"
	icon = 'icons/obj/plumbing/plumbers.dmi'
	icon_state = "pump"
	density = TRUE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 7.5
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	///Plumbing machinery is always gonna need reagents, so we might aswell put it here
	var/buffer = 50
	///Flags for reagents, like INJECTABLE, TRANSPARENT bla bla everything thats in DEFINES/reagents.dm
	var/reagent_flags = TRANSPARENT
	///wheter we partake in rcd construction or not

/obj/machinery/plumbing/Initialize(mapload, bolt = TRUE)
	. = ..()
	set_anchored(bolt)
	create_reagents(buffer, reagent_flags)
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, PROC_REF(can_be_rotated)))

/obj/machinery/plumbing/proc/can_be_rotated(mob/user,rotation_type)
	return !anchored

/obj/machinery/plumbing/examine(mob/user)
	. = ..()
	. += span_notice("The maximum volume display reads: <b>[reagents.maximum_volume] units</b>.")

/obj/machinery/plumbing/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	return TRUE

/obj/machinery/plumbing/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	to_chat(user, span_notice("You start furiously plunging [name]."))
	if(do_after(user, 30, target = src))
		to_chat(user, span_notice("You finish plunging the [name]."))
		reagents.expose(get_turf(src), TOUCH) //splash on the floor
		reagents.clear_reagents()

/obj/machinery/plumbing/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(anchored)
		to_chat(user, "<span class='warning'>The [name] needs to be unbolted to do that!</span")
	if(I.tool_start_check(user, amount=0))
		to_chat(user, "<span class='notice'>You start slicing the [name] apart.</span")
		if(I.use_tool(src, user, (1.5 SECONDS), volume=50))
			deconstruct(TRUE)
			to_chat(user, "<span class='notice'>You slice the [name] apart.</span")
			return TRUE


///We can empty beakers in here and everything
/obj/machinery/plumbing/input
	name = "input gate"
	desc = "Can be manually filled with reagents from containers."
	icon_state = "pipe_input"
	reagent_flags = TRANSPARENT | REFILLABLE

/obj/machinery/plumbing/input/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, bolt, layer)

///We can fill beakers in here and everything. we dont inheret from input because it has nothing that we need
/obj/machinery/plumbing/output
	name = "output gate"
	desc = "A manual output for plumbing systems, for taking reagents directly into containers."
	icon_state = "pipe_output"
	reagent_flags = TRANSPARENT | DRAINABLE

/obj/machinery/plumbing/output/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_demand, bolt, layer)


/obj/machinery/plumbing/tank
	name = "chemical tank"
	desc = "A massive chemical holding tank."
	icon_state = "tank"
	buffer = 400

	//mechcomp interaction related stuff
	var/pairs_glue = ";"
	var/list_glue = "&"
	var/use_enname_for_list = TRUE //fuck off

/obj/machinery/plumbing/tank/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/tank, bolt, layer)
	AddComponent(/datum/component/mechanics_holder)

	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_INPUT, "Send out contents data", "sendout")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set pairs glue", "setpairsglue")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Set list glue", "setlistglue")
	SEND_SIGNAL(src, COMSIG_MECHCOMP_ADD_CONFIG, "Toggle usage of english names", "toggleenname")

/obj/machinery/plumbing/tank/proc/sendout(datum/mechcompMessage/msg)
	var/list/l = list()
	for(var/datum/reagent/r in reagents.reagent_list)
		l.Add("[use_enname_for_list ? "[r.enname ? "[r.enname]" : "[r.name]"]" : "[r.name]"][pairs_glue][r.volume]")
	if(length(l))
		SEND_SIGNAL(src, COMSIG_MECHCOMP_TRANSMIT_SIGNAL, jointext(l, list_glue))


/obj/machinery/plumbing/tank/proc/setpairsglue(obj/item/I, mob/user)
	var/input = prompt("pairs glue",pairs_glue)
	if(!isnull(input))
		pairs_glue = input
		to_chat(user, span_notice("You set the pairs glue to [pairs_glue]."))

/obj/machinery/plumbing/tank/proc/setlistglue(obj/item/I, mob/user)
	var/input = prompt("list glue",list_glue)
	if(!isnull(input))
		list_glue = input
		to_chat(user, span_notice("You set the list glue to [list_glue]."))

/obj/machinery/plumbing/tank/proc/toggleenname(obj/item/I, mob/user)
	use_enname_for_list = !use_enname_for_list
	if(use_enname_for_list)
		to_chat(user, span_notice("Now the [src.name] will use english reagent names for output list, if they're available."))
	else
		to_chat(user, span_notice("Now the [src.name] will use russian reagent names for output list."))

/obj/machinery/plumbing/tank/proc/prompt(varname, v)
	var/input = input("Set [varname] to what? Make sure to select a unique symbol like \"&\", otherwise extracting from list will be very problematic! (Groups of symbols are also accepted!)", "[varname]", v) as null|num
	return input


///Layer manifold machine that connects a bunch of layers
/obj/machinery/plumbing/layer_manifold
	name = "layer manifold"
	desc = "A plumbing manifold for layers."
	icon_state = "manifold"
	density = FALSE

/obj/machinery/plumbing/layer_manifold/Initialize(mapload, bolt, layer)
	. = ..()

	AddComponent(/datum/component/plumbing/manifold, bolt, SECOND_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, bolt, THIRD_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, bolt, FOURTH_DUCT_LAYER)
