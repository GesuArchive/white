/**
 * # Split component
 *
 * Splits a string
 */
/obj/item/circuit_component/split
	display_name = "Разделитель"
	desc = "Разбивает строку разделителем, превращая ее в список"
	category = "List"

	/// The input port
	var/datum/port/input/input_port

	/// The seperator
	var/datum/port/input/separator

	/// The result from the output
	var/datum/port/output/output

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/split/populate_ports()
	input_port = add_input_port("Вход", PORT_TYPE_STRING)
	separator = add_input_port("Seperator", PORT_TYPE_STRING)
	output = add_output_port("Выход", PORT_TYPE_LIST(PORT_TYPE_STRING))

/obj/item/circuit_component/split/input_received(datum/port/input/port)

	var/separator_value = separator.value
	if(isnull(separator_value))
		return

	var/value = input_port.value
	if(isnull(value))
		return

	var/list/result = splittext(value,separator_value)

	output.set_output(result)
