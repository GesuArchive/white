/obj/machinery/rnd/production/protolathe
	name = "протолат"
	desc = "Превращает сырье в полезные предметы."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/protolathe
	categories = list(
								"Силовые дизайны",
								"Медицинские дизайны",
								"Блюспейс дизайны",
								"Запчасти обрудования",
								"Снаряжение",
								"Рабочие инструменты",
								"Шахтёрское оборудование",
								"Электроника",
								"Вооружение",
								"Аммуниция",
								"Бойки",
								"Компьютерные запчасти"
								)
	production_animation = "protolathe_n"
	allowed_buildtypes = PROTOLATHE

/obj/machinery/rnd/production/protolathe/deconstruct(disassembled)
	log_game("Protolathe of type [type] [disassembled ? "disassembled" : "deconstructed"] by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()

/obj/machinery/rnd/production/protolathe/Initialize(mapload)
	if(!mapload)
		log_game("Protolathe of type [type] constructed by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()
