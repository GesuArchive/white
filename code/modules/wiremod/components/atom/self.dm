/**
 * # Self Component
 *
 * Return the current shell.
 */
/obj/item/circuit_component/self
	display_name = "Оболочка (возврат)"
	desc = "Компонент, который возвращает значение текущей оболочки."
	category = "Entity"

	/// The shell this component is attached to.
	var/datum/port/output/output

	/// The signal sent when the status is updated.
	var/datum/port/output/shell_received

/obj/item/circuit_component/self/populate_ports()
	output = add_output_port("Оболочка", PORT_TYPE_ATOM)
	shell_received = add_output_port("Оболочка Обновлена", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/self/register_shell(atom/movable/shell)
	output.set_output(shell)
	shell_received.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/self/unregister_shell(atom/movable/shell)
	output.set_output(null)
	shell_received.set_output(COMPONENT_SIGNAL)
