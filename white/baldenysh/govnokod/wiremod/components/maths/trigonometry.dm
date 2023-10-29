#define COMP_TRIG_SIN "Sin"
#define COMP_TRIG_COS "Cos"
#define COMP_TRIG_TAN "Tan"

#define COMP_TRIG_ARCSIN "Arcsin"
#define COMP_TRIG_ARCCOS "Arccos"
#define COMP_TRIG_ARCTAN "Arctan"

/obj/item/circuit_component/trigonometry
	display_name = "Тригонометрия"
	desc = "Компонент для вычисления всякой тригонометрической хуйни."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	var/datum/port/input/option/trigonometric_option

/obj/item/circuit_component/trigonometry/populate_options()
	var/static/component_options = list(
		COMP_TRIG_SIN,
		COMP_TRIG_COS,
		COMP_TRIG_TAN,
		COMP_TRIG_ARCSIN,
		COMP_TRIG_ARCCOS,
		COMP_TRIG_ARCTAN
	)
	trigonometric_option = add_option_port("Trigonometric Option", component_options)

/obj/item/circuit_component/trigonometry/Initialize(mapload)
	. = ..()
	add_input_port("Вход", PORT_TYPE_NUMBER)
	add_output_port("Выход", PORT_TYPE_NUMBER)

/obj/item/circuit_component/trigonometry/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	//var/datum/port/input/input = input_ports[1]
	var/datum/port/output/output = output_ports[1]
	var/value = port.value
	var/result

	switch(trigonometric_option)
		if(COMP_TRIG_SIN)
			result = sin(value)
		if(COMP_TRIG_COS)
			result = cos(value)
		if(COMP_TRIG_TAN)
			result = tan(value)
		if(COMP_TRIG_ARCSIN)
			result = arcsin(value)
		if(COMP_TRIG_ARCCOS)
			result = arccos(value)
		if(COMP_TRIG_ARCTAN)
			result = arctan(value)

	output.set_output(result)
