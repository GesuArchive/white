/**
 * # Get Species Component
 *
 * Return the species of a mob
 */
/obj/item/circuit_component/species
	display_name = "Получить вид"

	/// The input port
	var/datum/port/input/input_port

	/// The result from the output
	var/datum/port/output/output

	has_trigger = TRUE

/obj/item/circuit_component/species/Initialize()
	. = ..()
	input_port = add_input_port("Организм", PORT_TYPE_ATOM)

	output = add_output_port("Мутация", PORT_TYPE_STRING)

/obj/item/circuit_component/species/Destroy()
	input_port = null
	output = null
	return ..()

/obj/item/circuit_component/species/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/human = input_port.input_value
	if(!istype(human) || !human.has_dna())
		output.set_output(null)
		return

	output.set_output(human.dna.species.name)
	trigger_output.set_output(COMPONENT_SIGNAL)
