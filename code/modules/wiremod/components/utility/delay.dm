/// The minimum delay value that the delay component can have.
#define COMP_DELAY_MIN_VALUE 0.1

/**
 * # Delay Component
 *
 * Delays a signal by a specified duration.
 */
/obj/item/circuit_component/delay
	display_name = "Задержка"
	desc = "A component that delays a signal by a specified duration."

	/// Amount to delay by
	var/datum/port/input/delay_amount
	/// Input signal to fire the delay
	var/datum/port/input/trigger

	/// The output of the signal
	var/datum/port/output/output

/obj/item/circuit_component/delay/Initialize()
	. = ..()
	delay_amount = add_input_port("Задержка", PORT_TYPE_NUMBER, FALSE)
	trigger = add_input_port("Активация", PORT_TYPE_SIGNAL)
	output = add_output_port("Результат", PORT_TYPE_SIGNAL)


/obj/item/circuit_component/delay/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	if(!COMPONENT_TRIGGERED_BY(trigger, port))
		return

	var/delay = delay_amount.value
	if(delay > COMP_DELAY_MIN_VALUE)
		// Convert delay into deciseconds
		addtimer(CALLBACK(output, /datum/port/output.proc/set_output, trigger.value), delay*10)
	else
		output.set_output(trigger.value)

#undef COMP_DELAY_MIN_VALUE
