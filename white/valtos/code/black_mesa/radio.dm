/obj/item/encryptionkey/headset_faction
	name = "особый ключ шифрования"
	icon_state = "cargo_cypherkey"
	channels = list(RADIO_CHANNEL_FACTION = 1)
	independent = TRUE

/obj/item/radio/headset/headset_faction
	name = "гарнитура"
	desc = "Используется для связи с другими людьми."
	icon_state = "cargo_headset"
	keyslot = new /obj/item/encryptionkey/headset_faction

/obj/item/radio/headset/headset_faction/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_FACTION)

/obj/item/radio/headset/headset_faction/bowman
	name = "гарнитура-бабочка"
	desc = "Используется для связи с другими людьми. Защищает уши от светошумовых гранат."
	icon_state = "com_headset_alt"
	inhand_icon_state = "com_headset_alt"

/obj/item/radio/headset/headset_faction/bowman/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/headset_faction/bowman/captain
	name = "гарнитура-бабочка лидера"
	desc = "Используется для связи с другими людьми. Защищает уши от светошумовых гранат."
	command = TRUE
