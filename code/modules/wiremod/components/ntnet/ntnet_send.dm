/**
 * # NTNet Transmitter Component
 *
 * Sends a data package through NTNet
 */

/obj/item/circuit_component/ntnet_send
	display_name = "Передатчик NTNet"
	desc = "Отправляет пакет данных через NTNet при срабатывании. Если целевой HID не указан, данные будут отправлены во все каналы сети. Если установлен ключ шифрования, то передаваемые данные будут приниматься только получателями с тем же ключом шифрования."
	category = "NTNet"

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	/// The list type
	var/datum/port/input/option/list_options

	/// Data being sent
	var/datum/port/input/data_package

	/// Encryption key
	var/datum/port/input/enc_key

/obj/item/circuit_component/ntnet_send/Initialize(mapload)
	. = ..()
	init_network_id(__NETWORK_CIRCUITS)

/obj/item/circuit_component/ntnet_send/populate_options()
	list_options = add_option_port("List Type", GLOB.wiremod_basic_types)

/obj/item/circuit_component/ntnet_send/populate_ports()
	data_package = add_input_port("Data Package", PORT_TYPE_LIST(PORT_TYPE_ANY))
	enc_key = add_input_port("Encryption Key", PORT_TYPE_STRING)

/obj/item/circuit_component/ntnet_send/pre_input_received(datum/port/input/port)
	if(port == list_options)
		var/new_datatype = list_options.value
		data_package.set_datatype(PORT_TYPE_LIST(new_datatype))

/obj/item/circuit_component/ntnet_send/input_received(datum/port/input/port)
	ntnet_send(list("data" = data_package.value, "enc_key" = enc_key.value, "port" = WEAKREF(data_package)))
