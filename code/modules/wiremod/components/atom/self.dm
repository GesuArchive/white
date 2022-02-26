/**
 * # Self Component
 *
 * Return the current shell.
 */
/obj/item/circuit_component/self
	display_name = "Оболочка (возврат)"
	desc = "Компонент, который возвращает значение текущей оболочки."

	/// The shell this component is attached to.
	var/datum/port/output/output

/obj/item/circuit_component/self/populate_ports()
	output = add_output_port("Оболочка", PORT_TYPE_ATOM)

/obj/item/circuit_component/self/register_shell(atom/movable/shell)
	output.set_output(shell)

/obj/item/circuit_component/self/unregister_shell(atom/movable/shell)
	output.set_output(null)
