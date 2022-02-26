/**
 * # NTNet Transmitter Component
 *
 * Sends a data package through NTNet
 */

/obj/item/circuit_component/ntnet_send
	display_name = "Передатчик NTNet"
	desc = "Отправляет пакет данных через NTNet при срабатывании. Если целевой HID не указан, данные будут отправлены во все каналы сети. Если установлен ключ шифрования, то передаваемые данные будут приниматься только получателями с тем же ключом шифрования."

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	network_id = __NETWORK_CIRCUITS

	var/datum/port/input/data_package
	var/datum/port/input/secondary_package
	var/datum/port/input/enc_key

/obj/item/circuit_component/ntnet_send/Initialize()
	. = ..()
	data_package = add_input_port("Data Package", PORT_TYPE_ANY)
	secondary_package = add_input_port("Secondary Package", PORT_TYPE_ANY)
	enc_key = add_input_port("Encryption Key", PORT_TYPE_STRING)

/obj/item/circuit_component/ntnet_send/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return
	ntnet_send(list("data" = data_package.value, "data_secondary" = secondary_package.value, "enc_key" = enc_key.value))
