// CPU that allows the computer to run programs.
// Better CPUs are obtainable via research and can run more programs on background.

/obj/item/computer_hardware/processor_unit
	name = "Плата процессора"
	desc = "Стандартная плата центрального процессора, используемая в большинстве компьютеров. Она может запускать до трёх программ одновременно."
	icon_state = "cpuboard"
	w_class = WEIGHT_CLASS_SMALL
	power_usage = 50
	critical = 1
	malfunction_probability = 1
	var/max_idle_programs = 2 // 2 idle, + 1 active = 3 as said in description.
	device_type = MC_CPU

/obj/item/computer_hardware/processor_unit/on_remove(obj/item/modular_computer/remove_from, mob/user)
	remove_from.shutdown_computer()

/obj/item/computer_hardware/processor_unit/small
	name = "Микропроцессор"
	desc = "Миниатюрный процессор, используемый в портативных устройствах. Он может запускать до двух программ одновременно."
	icon_state = "cpu"
	w_class = WEIGHT_CLASS_TINY
	power_usage = 25
	max_idle_programs = 1

/obj/item/computer_hardware/processor_unit/photonic
	name = "Плата фотонного процессора"
	desc = "Усовершенствованная экспериментальная плата центрального процесса, в которой вместо обычных схем используется фотонное ядро. Она может запускать до пяти программ одновременно, однако потребляет много энергии."
	icon_state = "cpuboard_super"
	w_class = WEIGHT_CLASS_SMALL
	power_usage = 250
	max_idle_programs = 4

/obj/item/computer_hardware/processor_unit/photonic/small
	name = "Фотонный микропроцессор"
	desc = "Усовершенствованный миниатюрный процессор для использования в портативных устройствах. Он использует фотонное ядро вместо обычных схем. Он может запускать до трёх программ одновременно."
	icon_state = "cpu_super"
	w_class = WEIGHT_CLASS_TINY
	power_usage = 75
	max_idle_programs = 2
