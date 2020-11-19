/obj/machinery/rnd/production/circuit_imprinter
	name = "схемопринтер"
	desc = "Производит печатные платы для создания оборудования."
	icon_state = "circuit_imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter
	categories = list(
								"Модули ИИ",
								"Консоли",
								"Телепортация",
								"Медицинское оборудование",
								"Инженерное оборудование",
								"Модули экзоскелетов",
								"Оборудование гидропоники",
								"Подпространственная связь",
								"Исследовательское оборудование",
								"Различное оборудование",
								"Компьютерные запчасти"
								)
	production_animation = "circuit_imprinter_ani"
	allowed_buildtypes = IMPRINTER

/obj/machinery/rnd/production/circuit_imprinter/calculate_efficiency()
	. = ..()
	var/total_rating = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		total_rating += M.rating * 2			//There is only one.
	total_rating = max(1, total_rating)
	efficiency_coeff = total_rating
