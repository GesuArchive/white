/**
 * #To Number Component
 *
 * Converts a string into a Number
 */
/obj/item/circuit_component/tonumber
	display_name = "В цифру"
	desc = "Компонент, который преобразует входные данные (строку) в число. Если во входных данных есть текст, он будет учитываться только в том случае, если он начинается с цифры. Он примет это число и проигнорирует остальное."
	category = "String"

	/// The input port
	var/datum/port/input/input_port

	/// The result from the output
	var/datum/port/output/output

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/tonumber/populate_ports()
	input_port = add_input_port("Вход", PORT_TYPE_STRING)
	output = add_output_port("Выход", PORT_TYPE_NUMBER)

/obj/item/circuit_component/tonumber/input_received(datum/port/input/port)
	output.set_output(text2num(input_port.value))
